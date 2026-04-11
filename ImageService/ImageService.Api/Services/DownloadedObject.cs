using Amazon.S3.Model;

namespace ImageService.Api.Services;

public sealed record DownloadedObject(
    GetObjectResponse StorageResponse,
    string ContentType,
    string FileName);
