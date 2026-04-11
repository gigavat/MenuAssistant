namespace ImageService.Api.Services;

public sealed class InvalidImageException(string message) : Exception(message);
