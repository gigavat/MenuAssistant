using Microsoft.AspNetCore.Authorization;

namespace ImageService.Api.Auth;

public sealed class ScopeAuthorizationRequirement(params string[] allowedScopes) : IAuthorizationRequirement
{
    public IReadOnlyCollection<string> AllowedScopes { get; } = allowedScopes;
}
