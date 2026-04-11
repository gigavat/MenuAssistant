namespace ImageService.Api.Auth;

public sealed class InternalJwtOptions
{
    public const string SectionName = "InternalJwt";

    public string Issuer { get; init; } = string.Empty;

    public string Audience { get; init; } = string.Empty;

    public string SigningKey { get; init; } = string.Empty;
}
