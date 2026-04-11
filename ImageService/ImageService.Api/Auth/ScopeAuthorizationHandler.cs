using Microsoft.AspNetCore.Authorization;

namespace ImageService.Api.Auth;

public sealed class ScopeAuthorizationHandler : AuthorizationHandler<ScopeAuthorizationRequirement>
{
    protected override Task HandleRequirementAsync(
        AuthorizationHandlerContext context,
        ScopeAuthorizationRequirement requirement)
    {
        var scopes = context.User.Claims
            .Where(static claim => claim.Type is "scope" or "scp")
            .SelectMany(static claim => claim.Value.Split(' ', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            .ToHashSet(StringComparer.Ordinal);

        if (scopes.Overlaps(requirement.AllowedScopes))
        {
            context.Succeed(requirement);
        }

        return Task.CompletedTask;
    }
}
