namespace ImageService.Api.Services;

public sealed record UploadedObjectInfo(
    string BucketName,
    string ObjectKey,
    string? VersionId,
    string OriginalFileName,
    string ContentType,
    long ContentLength,
    string? ETag);
