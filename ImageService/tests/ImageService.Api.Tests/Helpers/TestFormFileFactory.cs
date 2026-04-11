using Microsoft.AspNetCore.Http;

namespace ImageService.Api.Tests.Helpers;

public static class TestFormFileFactory
{
    public static IFormFile Create(
        byte[] payload,
        string fileName = "image.png",
        string contentType = "image/png",
        string fieldName = "file")
    {
        var stream = new MemoryStream(payload);

        return new FormFile(stream, 0, payload.Length, fieldName, fileName)
        {
            Headers = new HeaderDictionary(),
            ContentType = contentType
        };
    }
}
