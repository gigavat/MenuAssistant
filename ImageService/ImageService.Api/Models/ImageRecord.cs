namespace ImageService.Api.Models;

public sealed class ImageRecord
{
    public Guid ImageId { get; set; }

    public required string S3BucketName { get; set; }

    public required string S3ObjectKey { get; set; }

    public string? S3VersionId { get; set; }

    public required string OriginalFileName { get; set; }

    public required string ContentType { get; set; }

    public long ContentLength { get; set; }

    public string? ETag { get; set; }

    public DateTimeOffset CreatedAtUtc { get; set; }

    public DateTimeOffset UpdatedAtUtc { get; set; }
}
