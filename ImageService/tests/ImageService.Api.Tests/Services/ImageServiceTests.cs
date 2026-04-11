using ImageService.Api.Data;
using ImageService.Api.Options;
using ImageService.Api.Services;
using ImageService.Api.Tests.Helpers;
using ImageService.Api.Tests.TestDoubles;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;

namespace ImageService.Api.Tests.Services;

public sealed class ImageServiceTests
{
    [Fact]
    public async Task UpdateAsync_ReplacesStoredBlobAndKeepsSingleActiveObject()
    {
        await using var dbContext = new ImageDbContext(
            new DbContextOptionsBuilder<ImageDbContext>()
                .UseInMemoryDatabase($"image-service-{Guid.NewGuid():N}")
                .Options);

        var fakeS3 = new InMemoryAmazonS3Client();
        var storageService = new S3ObjectStorageService(
            fakeS3,
            Microsoft.Extensions.Options.Options.Create(new S3StorageOptions
            {
                Region = "eu-west-1",
                BucketName = "unit-test-bucket",
                ForcePathStyle = true
            }),
            NullLogger<S3ObjectStorageService>.Instance);

        var imageService = new ImageService.Api.Services.ImageService(
            dbContext,
            storageService,
            NullLogger<ImageService.Api.Services.ImageService>.Instance);

        var created = await imageService.CreateAsync(
            TestFormFileFactory.Create("first-image"u8.ToArray(), "first.png"),
            CancellationToken.None);

        var updated = await imageService.UpdateAsync(
            created.ImageId,
            TestFormFileFactory.Create("second-image"u8.ToArray(), "second.png"),
            CancellationToken.None);

        var downloaded = await imageService.DownloadAsync(created.ImageId, CancellationToken.None);
        Assert.NotNull(updated);
        Assert.Equal(created.ImageId, updated.ImageId);
        Assert.Equal(1, fakeS3.ObjectCount);

        await using var copy = new MemoryStream();
        await downloaded!.StorageResponse.ResponseStream.CopyToAsync(copy);

        Assert.Equal("second-image"u8.ToArray(), copy.ToArray());
    }
}
