using ImageService.Api.Models;
using ImageService.Api.Options;
using ImageService.Api.Services;
using ImageService.Api.Tests.Helpers;
using ImageService.Api.Tests.TestDoubles;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;

namespace ImageService.Api.Tests.Services;

public sealed class S3ObjectStorageServiceTests
{
    [Fact]
    public async Task UploadAndDownloadAsync_RoundTripsImagePayload()
    {
        var fakeS3 = new InMemoryAmazonS3Client();
        var service = CreateStorageService(fakeS3);
        var imageId = Guid.NewGuid();
        var payload = "fake-png-binary"u8.ToArray();
        var formFile = TestFormFileFactory.Create(payload, "menu.png", "image/png");

        var uploaded = await service.UploadAsync(imageId, formFile, CancellationToken.None);
        var record = new ImageRecord
        {
            ImageId = imageId,
            S3BucketName = uploaded.BucketName,
            S3ObjectKey = uploaded.ObjectKey,
            S3VersionId = uploaded.VersionId,
            OriginalFileName = uploaded.OriginalFileName,
            ContentType = uploaded.ContentType,
            ContentLength = uploaded.ContentLength,
            ETag = uploaded.ETag,
            CreatedAtUtc = DateTimeOffset.UtcNow,
            UpdatedAtUtc = DateTimeOffset.UtcNow
        };

        var downloaded = await service.DownloadAsync(record, CancellationToken.None);

        Assert.NotNull(downloaded);

        await using var copy = new MemoryStream();
        await downloaded.StorageResponse.ResponseStream.CopyToAsync(copy);

        Assert.Equal(payload, copy.ToArray());
        Assert.Equal("image/png", downloaded.ContentType);
        Assert.Equal("menu.png", downloaded.FileName);
    }

    [Fact]
    public async Task DeleteAsync_RemovesStoredObject()
    {
        var fakeS3 = new InMemoryAmazonS3Client();
        var service = CreateStorageService(fakeS3);
        var imageId = Guid.NewGuid();
        var uploaded = await service.UploadAsync(
            imageId,
            TestFormFileFactory.Create("payload"u8.ToArray()),
            CancellationToken.None);

        var record = new ImageRecord
        {
            ImageId = imageId,
            S3BucketName = uploaded.BucketName,
            S3ObjectKey = uploaded.ObjectKey,
            S3VersionId = uploaded.VersionId,
            OriginalFileName = uploaded.OriginalFileName,
            ContentType = uploaded.ContentType,
            ContentLength = uploaded.ContentLength,
            ETag = uploaded.ETag,
            CreatedAtUtc = DateTimeOffset.UtcNow,
            UpdatedAtUtc = DateTimeOffset.UtcNow
        };

        await service.DeleteAsync(record, CancellationToken.None);
        var downloaded = await service.DownloadAsync(record, CancellationToken.None);

        Assert.Null(downloaded);
        Assert.Equal(0, fakeS3.ObjectCount);
    }

    [Fact]
    public async Task UploadAsync_RejectsNonImageContentType()
    {
        var fakeS3 = new InMemoryAmazonS3Client();
        var service = CreateStorageService(fakeS3);
        var formFile = TestFormFileFactory.Create("not-an-image"u8.ToArray(), "notes.txt", "text/plain");

        await Assert.ThrowsAsync<InvalidImageException>(() =>
            service.UploadAsync(Guid.NewGuid(), formFile, CancellationToken.None));
    }

    private static S3ObjectStorageService CreateStorageService(InMemoryAmazonS3Client fakeS3) =>
        new(
            fakeS3,
            Microsoft.Extensions.Options.Options.Create(new S3StorageOptions
            {
                Region = "eu-west-1",
                BucketName = "unit-test-bucket",
                ForcePathStyle = true
            }),
            NullLogger<S3ObjectStorageService>.Instance);
}
