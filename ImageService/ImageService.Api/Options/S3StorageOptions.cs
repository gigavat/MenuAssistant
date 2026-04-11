namespace ImageService.Api.Options;

public sealed class S3StorageOptions
{
    public const string SectionName = "AWS:S3";

    public string Region { get; init; } = string.Empty;

    public string BucketName { get; init; } = string.Empty;

    public string? ServiceUrl { get; init; }

    public bool ForcePathStyle { get; init; }

    public string? AccessKey { get; init; }

    public string? SecretKey { get; init; }
}
