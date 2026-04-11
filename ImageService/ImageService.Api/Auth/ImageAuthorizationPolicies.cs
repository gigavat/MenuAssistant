using Microsoft.AspNetCore.Authorization;

namespace ImageService.Api.Auth;

public static class ImageAuthorizationPolicies
{
    public const string Read = "images.read";
    public const string Write = "images.write";
    public const string Delete = "images.delete";

    public static void Configure(AuthorizationOptions options)
    {
        options.AddPolicy(Read, policy =>
            policy.RequireAuthenticatedUser()
                .AddRequirements(new ScopeAuthorizationRequirement(Read)));

        options.AddPolicy(Write, policy =>
            policy.RequireAuthenticatedUser()
                .AddRequirements(new ScopeAuthorizationRequirement(Write)));

        options.AddPolicy(Delete, policy =>
            policy.RequireAuthenticatedUser()
                .AddRequirements(new ScopeAuthorizationRequirement(Delete)));
    }
}
