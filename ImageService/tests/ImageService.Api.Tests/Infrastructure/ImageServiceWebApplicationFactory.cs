using Amazon.S3;
using ImageService.Api.Tests.TestDoubles;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace ImageService.Api.Tests.Infrastructure;

public sealed class ImageServiceWebApplicationFactory : WebApplicationFactory<Program>
{
    public const string JwtIssuer = "serverpod-tests";
    public const string JwtAudience = "image-service";
    public const string JwtSigningKey = "test-only-signing-key-with-at-least-32-bytes";
    public const string BucketName = "integration-test-bucket";

    public InMemoryAmazonS3Client S3Client { get; } = new();

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment("Testing");

        builder.ConfigureAppConfiguration((_, configBuilder) =>
        {
            configBuilder.AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["ConnectionStrings:ImageDb"] = "Host=unused;Port=5432;Database=unused;Username=unused;Password=unused",
                ["Database:Provider"] = "InMemory",
                ["Database:Name"] = $"image-service-tests-{Guid.NewGuid():N}",
                ["AWS:S3:Region"] = "eu-west-1",
                ["AWS:S3:BucketName"] = BucketName,
                ["InternalJwt:Issuer"] = JwtIssuer,
                ["InternalJwt:Audience"] = JwtAudience,
                ["InternalJwt:SigningKey"] = JwtSigningKey
            });
        });

        builder.ConfigureServices(services =>
        {
            services.RemoveAll<IAmazonS3>();
            services.AddSingleton<IAmazonS3>(S3Client);
        });
    }
}
