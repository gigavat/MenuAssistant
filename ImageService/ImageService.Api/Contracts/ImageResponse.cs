using ImageService.Api.Models;

namespace ImageService.Api.Contracts;

public sealed record ImageResponse(
    Guid ImageId,
    string OriginalFileName,
    string ContentType,
    long ContentLength,
    string? ETag,
    DateTimeOffset CreatedAtUtc,
    DateTimeOffset UpdatedAtUtc,
    string MetadataUrl,
    string ContentUrl)
{
    public static ImageResponse FromRecord(ImageRecord record, string metadataUrl, string contentUrl) =>
        new(
            record.ImageId,
            record.OriginalFileName,
            record.ContentType,
            record.ContentLength,
            record.ETag,
            record.CreatedAtUtc,
            record.UpdatedAtUtc,
            metadataUrl,
            contentUrl);
}
