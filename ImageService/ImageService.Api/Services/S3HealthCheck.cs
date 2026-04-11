using Amazon.S3;
using ImageService.Api.Options;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;

namespace ImageService.Api.Services;

public sealed class S3HealthCheck(IAmazonS3 s3Client, IOptions<S3StorageOptions> options) : IHealthCheck
{
    private readonly IAmazonS3 _s3Client = s3Client;
    private readonly string _bucketName = options.Value.BucketName;

    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            await _s3Client.GetBucketLocationAsync(_bucketName, cancellationToken);
            return HealthCheckResult.Healthy();
        }
        catch (Exception exception)
        {
            return HealthCheckResult.Unhealthy(
                $"S3 bucket '{_bucketName}' is unreachable.",
                exception);
        }
    }
}
