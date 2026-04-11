using System.Collections.Concurrent;
using System.Net;
using System.Security.Cryptography;
using Amazon.Runtime;
using Amazon.S3;
using Amazon.S3.Model;

namespace ImageService.Api.Tests.TestDoubles;

public sealed class InMemoryAmazonS3Client : AmazonS3Client
{
    private readonly ConcurrentDictionary<(string BucketName, string ObjectKey), StoredObject> _objects = new();

    public InMemoryAmazonS3Client()
        : base(
            new BasicAWSCredentials("test-access-key", "test-secret-key"),
            new AmazonS3Config
            {
                AuthenticationRegion = "eu-west-1",
                ForcePathStyle = true,
                ServiceURL = "http://localhost"
            })
    {
    }

    public int ObjectCount => _objects.Count;

    public override async Task<PutObjectResponse> PutObjectAsync(PutObjectRequest request, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);
        ArgumentNullException.ThrowIfNull(request.InputStream);

        await using var sourceStream = request.InputStream;
        await using var buffer = new MemoryStream();
        await sourceStream.CopyToAsync(buffer, cancellationToken);

        var payload = buffer.ToArray();
        var eTag = Convert.ToHexString(MD5.HashData(payload)).ToLowerInvariant();
        var versionId = Guid.NewGuid().ToString("N");

        _objects[(request.BucketName, request.Key)] = new StoredObject(
            payload,
            request.ContentType ?? "application/octet-stream",
            versionId,
            eTag);

        return new PutObjectResponse
        {
            HttpStatusCode = HttpStatusCode.OK,
            VersionId = versionId,
            ETag = $"\"{eTag}\""
        };
    }

    public override Task<GetObjectResponse> GetObjectAsync(string bucketName, string key, CancellationToken cancellationToken = default)
    {
        if (!_objects.TryGetValue((bucketName, key), out var storedObject))
        {
            throw new AmazonS3Exception("Object not found")
            {
                StatusCode = HttpStatusCode.NotFound,
                ErrorCode = "NoSuchKey"
            };
        }

        var response = new GetObjectResponse
        {
            BucketName = bucketName,
            Key = key,
            VersionId = storedObject.VersionId,
            ETag = $"\"{storedObject.ETag}\"",
            ResponseStream = new MemoryStream(storedObject.Payload, writable: false)
        };

        response.Headers.ContentType = storedObject.ContentType;

        return Task.FromResult(response);
    }

    public override Task<DeleteObjectResponse> DeleteObjectAsync(DeleteObjectRequest request, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);
        _objects.TryRemove((request.BucketName, request.Key), out _);

        return Task.FromResult(new DeleteObjectResponse
        {
            HttpStatusCode = HttpStatusCode.NoContent
        });
    }

    private sealed record StoredObject(
        byte[] Payload,
        string ContentType,
        string VersionId,
        string ETag);
}
