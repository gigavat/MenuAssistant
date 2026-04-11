using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using ImageService.Api.Contracts;
using ImageService.Api.Tests.Helpers;
using ImageService.Api.Tests.Infrastructure;

namespace ImageService.Api.Tests.Integration;

public sealed class ImagesApiIntegrationTests
{
    [Fact]
    public async Task HealthCheck_IsAnonymous()
    {
        using var factory = new ImageServiceWebApplicationFactory();
        using var client = factory.CreateClient();

        var response = await client.GetAsync("/healthz");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task GetImages_WithoutToken_ReturnsUnauthorized()
    {
        using var factory = new ImageServiceWebApplicationFactory();
        using var client = factory.CreateClient();

        var response = await client.GetAsync("/images");

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task CreateReadAndDeleteImage_WithProperScopes_WorksEndToEnd()
    {
        using var factory = new ImageServiceWebApplicationFactory();
        using var client = factory.CreateClient();

        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
            "Bearer",
            InternalJwtTokenFactory.CreateToken(
                ImageServiceWebApplicationFactory.JwtIssuer,
                ImageServiceWebApplicationFactory.JwtAudience,
                ImageServiceWebApplicationFactory.JwtSigningKey,
                "images.read",
                "images.write",
                "images.delete"));

        using var multipart = new MultipartFormDataContent();
        var payload = "integration-image"u8.ToArray();
        var imageContent = new ByteArrayContent(payload);
        imageContent.Headers.ContentType = new MediaTypeHeaderValue("image/png");
        multipart.Add(imageContent, "file", "integration.png");

        var createResponse = await client.PostAsync("/images", multipart);
        var created = await createResponse.Content.ReadFromJsonAsync<ImageResponse>();

        Assert.Equal(HttpStatusCode.Created, createResponse.StatusCode);
        Assert.NotNull(created);

        var metadataResponse = await client.GetAsync($"/images/{created!.ImageId}");
        var metadata = await metadataResponse.Content.ReadFromJsonAsync<ImageResponse>();
        var contentResponse = await client.GetAsync($"/images/{created.ImageId}/content");
        var deleteResponse = await client.DeleteAsync($"/images/{created.ImageId}");

        Assert.Equal(HttpStatusCode.OK, metadataResponse.StatusCode);
        Assert.NotNull(metadata);
        Assert.Equal("integration.png", metadata!.OriginalFileName);
        Assert.Equal(HttpStatusCode.OK, contentResponse.StatusCode);
        Assert.Equal(payload, await contentResponse.Content.ReadAsByteArrayAsync());
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);
    }

    [Fact]
    public async Task DeleteImage_WithReadOnlyScope_ReturnsForbidden()
    {
        using var factory = new ImageServiceWebApplicationFactory();
        using var client = factory.CreateClient();

        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
            "Bearer",
            InternalJwtTokenFactory.CreateToken(
                ImageServiceWebApplicationFactory.JwtIssuer,
                ImageServiceWebApplicationFactory.JwtAudience,
                ImageServiceWebApplicationFactory.JwtSigningKey,
                "images.read"));

        var response = await client.DeleteAsync($"/images/{Guid.NewGuid()}");

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }
}
