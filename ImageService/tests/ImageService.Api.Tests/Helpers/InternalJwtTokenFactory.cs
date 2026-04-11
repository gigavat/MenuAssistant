using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace ImageService.Api.Tests.Helpers;

public static class InternalJwtTokenFactory
{
    public static string CreateToken(
        string issuer,
        string audience,
        string signingKey,
        params string[] scopes)
    {
        var now = DateTime.UtcNow;
        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, "serverpod"),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString("N"))
        };

        if (scopes.Length > 0)
        {
            claims.Add(new Claim("scope", string.Join(' ', scopes)));
        }

        var credentials = new SigningCredentials(
            new SymmetricSecurityKey(Encoding.UTF8.GetBytes(signingKey)),
            SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            notBefore: now.AddSeconds(-5),
            expires: now.AddMinutes(5),
            signingCredentials: credentials);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
