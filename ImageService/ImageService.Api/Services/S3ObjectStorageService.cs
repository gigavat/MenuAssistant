using System.Net;
using Amazon.S3;
using Amazon.S3.Model;
using ImageService.Api.Models;
using ImageService.Api.Options;
using Microsoft.Extensions.Options;

namespace ImageService.Api.Services;

public sealed class S3ObjectStorageService(
    IAmazonS3 s3Client,
    IOptions<S3StorageOptions> options,
    ILogger<S3ObjectStorageService> logger) : IObjectStorageService
{
    private readonly IAmazonS3 _s3Client = s3Client;
    private readonly S3StorageOptions _options = options.Value;
    private readonly ILogger<S3ObjectStorageService> _logger = logger;

    public async Task<UploadedObjectInfo> UploadAsync(Guid imageId, IFormFile file, CancellationToken cancellationToken)
    {
        ValidateImage(file);

        var objectKey = BuildObjectKey(imageId, file.FileName);

        await using var stream = file.OpenReadStream();

        var request = new PutObjectRequest
        {
            BucketName = _options.BucketName,
            Key = objectKey,
            InputStream = stream,
            ContentType = file.ContentType
        };

        request.Metadata["original-file-name"] = file.FileName;

        var response = await _s3Client.PutObjectAsync(request, cancellationToken);

        return new UploadedObjectInfo(
            _options.BucketName,
            objectKey,
            response.VersionId,
            file.FileName,
            file.ContentType,
            file.Length,
            NormalizeETag(response.ETag));
    }

    public async Task<DownloadedObject?> DownloadAsync(ImageRecord image, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _s3Client.GetObjectAsync(
                image.S3BucketName,
                image.S3ObjectKey,
                cancellationToken);

            return new DownloadedObject(
                response,
                response.Headers.ContentType ?? image.ContentType,
                image.OriginalFileName);
        }
        catch (AmazonS3Exception exception) when (exception.StatusCode == HttpStatusCode.NotFound || exception.ErrorCode == "NoSuchKey")
        {
            _logger.LogWarning(
                exception,
                "Image {ImageId} exists in metadata store, but blob {Bucket}/{ObjectKey} is missing in S3.",
                image.ImageId,
                image.S3BucketName,
                image.S3ObjectKey);

            return null;
        }
    }

    public Task DeleteAsync(ImageRecord image, CancellationToken cancellationToken) =>
        _s3Client.DeleteObjectAsync(
            new DeleteObjectRequest
            {
                BucketName = image.S3BucketName,
                Key = image.S3ObjectKey,
                VersionId = image.S3VersionId
            },
            cancellationToken);

    private static readonly HashSet<string> AllowedContentTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        "image/jpeg",
        "image/png",
        "image/webp",
        "image/gif",
    };

    private static void ValidateImage(IFormFile file)
    {
        if (file.Length <= 0)
        {
            throw new InvalidImageException("Uploaded file is empty.");
        }

        if (string.IsNullOrWhiteSpace(file.ContentType) || !AllowedContentTypes.Contains(file.ContentType))
        {
            throw new InvalidImageException(
                $"Content type '{file.ContentType}' is not allowed. " +
                "Accepted types: image/jpeg, image/png, image/webp, image/gif.");
        }
    }

    private static string BuildObjectKey(Guid imageId, string fileName)
    {
        var extension = Path.GetExtension(fileName);
        var safeExtension = extension.Length <= 10 ? extension.ToLowerInvariant() : string.Empty;

        return $"images/{imageId:N}/{Guid.NewGuid():N}{safeExtension}";
    }

    private static string? NormalizeETag(string? eTag) =>
        string.IsNullOrWhiteSpace(eTag)
            ? null
            : eTag.Trim('"');
}
