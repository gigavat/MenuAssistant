using ImageService.Api.Data;
using ImageService.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ImageService.Api.Services;

public sealed class ImageService(
    ImageDbContext dbContext,
    IObjectStorageService objectStorageService,
    ILogger<ImageService> logger) : IImageService
{
    private readonly ImageDbContext _dbContext = dbContext;
    private readonly IObjectStorageService _objectStorageService = objectStorageService;
    private readonly ILogger<ImageService> _logger = logger;

    public async Task<IReadOnlyList<ImageRecord>> ListAsync(int limit, int offset, CancellationToken cancellationToken) =>
        await _dbContext.Images
            .AsNoTracking()
            .OrderByDescending(x => x.CreatedAtUtc)
            .Skip(offset)
            .Take(limit)
            .ToListAsync(cancellationToken);

    public Task<ImageRecord?> GetAsync(Guid imageId, CancellationToken cancellationToken) =>
        _dbContext.Images
            .AsNoTracking()
            .SingleOrDefaultAsync(x => x.ImageId == imageId, cancellationToken);

    public async Task<ImageRecord> CreateAsync(IFormFile file, CancellationToken cancellationToken)
    {
        var imageId = Guid.NewGuid();
        var now = DateTimeOffset.UtcNow;
        var uploadedObject = await _objectStorageService.UploadAsync(imageId, file, cancellationToken);

        var image = new ImageRecord
        {
            ImageId = imageId,
            S3BucketName = uploadedObject.BucketName,
            S3ObjectKey = uploadedObject.ObjectKey,
            S3VersionId = uploadedObject.VersionId,
            OriginalFileName = uploadedObject.OriginalFileName,
            ContentType = uploadedObject.ContentType,
            ContentLength = uploadedObject.ContentLength,
            ETag = uploadedObject.ETag,
            CreatedAtUtc = now,
            UpdatedAtUtc = now
        };

        try
        {
            _dbContext.Images.Add(image);
            await _dbContext.SaveChangesAsync(cancellationToken);
            return image;
        }
        catch
        {
            await DeleteUploadedObjectSilentlyAsync(image, cancellationToken);
            throw;
        }
    }

    public async Task<ImageRecord?> UpdateAsync(Guid imageId, IFormFile file, CancellationToken cancellationToken)
    {
        var image = await _dbContext.Images.SingleOrDefaultAsync(x => x.ImageId == imageId, cancellationToken);
        if (image is null)
        {
            return null;
        }

        var previousBlob = new ImageRecord
        {
            ImageId = image.ImageId,
            S3BucketName = image.S3BucketName,
            S3ObjectKey = image.S3ObjectKey,
            S3VersionId = image.S3VersionId,
            OriginalFileName = image.OriginalFileName,
            ContentType = image.ContentType,
            ContentLength = image.ContentLength,
            ETag = image.ETag,
            CreatedAtUtc = image.CreatedAtUtc,
            UpdatedAtUtc = image.UpdatedAtUtc
        };

        var uploadedObject = await _objectStorageService.UploadAsync(imageId, file, cancellationToken);

        image.S3BucketName = uploadedObject.BucketName;
        image.S3ObjectKey = uploadedObject.ObjectKey;
        image.S3VersionId = uploadedObject.VersionId;
        image.OriginalFileName = uploadedObject.OriginalFileName;
        image.ContentType = uploadedObject.ContentType;
        image.ContentLength = uploadedObject.ContentLength;
        image.ETag = uploadedObject.ETag;
        image.UpdatedAtUtc = DateTimeOffset.UtcNow;

        try
        {
            await _dbContext.SaveChangesAsync(cancellationToken);
        }
        catch
        {
            var cleanupImage = new ImageRecord
            {
                ImageId = image.ImageId,
                S3BucketName = uploadedObject.BucketName,
                S3ObjectKey = uploadedObject.ObjectKey,
                S3VersionId = uploadedObject.VersionId,
                OriginalFileName = uploadedObject.OriginalFileName,
                ContentType = uploadedObject.ContentType,
                ContentLength = uploadedObject.ContentLength,
                ETag = uploadedObject.ETag,
                CreatedAtUtc = image.CreatedAtUtc,
                UpdatedAtUtc = image.UpdatedAtUtc
            };

            await DeleteUploadedObjectSilentlyAsync(cleanupImage, cancellationToken);
            throw;
        }

        try
        {
            await _objectStorageService.DeleteAsync(previousBlob, cancellationToken);
        }
        catch (Exception exception)
        {
            _logger.LogWarning(
                exception,
                "Failed to delete previous blob {Bucket}/{ObjectKey} for image {ImageId}.",
                previousBlob.S3BucketName,
                previousBlob.S3ObjectKey,
                previousBlob.ImageId);
        }

        return image;
    }

    public async Task<DownloadedObject?> DownloadAsync(Guid imageId, CancellationToken cancellationToken)
    {
        var image = await _dbContext.Images
            .AsNoTracking()
            .SingleOrDefaultAsync(x => x.ImageId == imageId, cancellationToken);

        return image is null
            ? null
            : await _objectStorageService.DownloadAsync(image, cancellationToken);
    }

    public async Task<bool> DeleteAsync(Guid imageId, CancellationToken cancellationToken)
    {
        var image = await _dbContext.Images.SingleOrDefaultAsync(x => x.ImageId == imageId, cancellationToken);
        if (image is null)
        {
            return false;
        }

        await _objectStorageService.DeleteAsync(image, cancellationToken);

        _dbContext.Images.Remove(image);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return true;
    }

    private async Task DeleteUploadedObjectSilentlyAsync(ImageRecord image, CancellationToken cancellationToken)
    {
        try
        {
            await _objectStorageService.DeleteAsync(image, cancellationToken);
        }
        catch (Exception exception)
        {
            _logger.LogWarning(
                exception,
                "Failed to cleanup uploaded blob {Bucket}/{ObjectKey} for image {ImageId}.",
                image.S3BucketName,
                image.S3ObjectKey,
                image.ImageId);
        }
    }
}
