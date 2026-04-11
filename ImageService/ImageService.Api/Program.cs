using System.Text;
using Amazon;
using Amazon.S3;
using ImageService.Api.Auth;
using ImageService.Api.Data;
using ImageService.Api.Options;
using ImageService.Api.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions.Options;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddProblemDetails();
builder.Services.AddOpenApi();
builder.Services.AddHealthChecks();

builder.Services.AddDbContext<ImageDbContext>((serviceProvider, options) =>
{
    var configuration = serviceProvider.GetRequiredService<IConfiguration>();
    var databaseProvider = configuration["Database:Provider"] ?? "Postgres";

    if (string.Equals(databaseProvider, "InMemory", StringComparison.OrdinalIgnoreCase))
    {
        var databaseName = configuration["Database:Name"] ?? "image-service-tests";
        options.UseInMemoryDatabase(databaseName);
        return;
    }

    var imageDbConnectionString = configuration.GetConnectionString("ImageDb")
        ?? throw new InvalidOperationException("Connection string 'ConnectionStrings:ImageDb' is required.");

    options.UseNpgsql(imageDbConnectionString);
});

builder.Services.Configure<S3StorageOptions>(builder.Configuration.GetSection(S3StorageOptions.SectionName));
builder.Services.AddOptions<InternalJwtOptions>()
    .Bind(builder.Configuration.GetSection(InternalJwtOptions.SectionName))
    .Validate(static options => !string.IsNullOrWhiteSpace(options.Issuer), "Configuration value 'InternalJwt:Issuer' is required.")
    .Validate(static options => !string.IsNullOrWhiteSpace(options.Audience), "Configuration value 'InternalJwt:Audience' is required.")
    .Validate(static options => !string.IsNullOrWhiteSpace(options.SigningKey) && Encoding.UTF8.GetByteCount(options.SigningKey) >= 32, "Configuration value 'InternalJwt:SigningKey' is required and must be at least 32 bytes for HS256.")
    .ValidateOnStart();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer();

builder.Services.AddOptions<JwtBearerOptions>(JwtBearerDefaults.AuthenticationScheme)
    .Configure<IOptions<InternalJwtOptions>>((options, internalJwt) =>
    {
        var jwt = internalJwt.Value;
        options.MapInboundClaims = false;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = jwt.Issuer,
            ValidateAudience = true,
            ValidAudience = jwt.Audience,
            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromSeconds(30),
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwt.SigningKey))
        };
    });

builder.Services.AddSingleton<IAuthorizationHandler, ScopeAuthorizationHandler>();
builder.Services.AddAuthorization(ImageAuthorizationPolicies.Configure);

builder.Services.AddSingleton<IAmazonS3>(serviceProvider =>
{
    var options = serviceProvider
        .GetRequiredService<IConfiguration>()
        .GetSection(S3StorageOptions.SectionName)
        .Get<S3StorageOptions>() ?? new S3StorageOptions();

    ValidateS3Options(options);

    var config = new AmazonS3Config
    {
        ForcePathStyle = options.ForcePathStyle
    };

    if (!string.IsNullOrWhiteSpace(options.ServiceUrl))
    {
        config.ServiceURL = options.ServiceUrl;
        config.AuthenticationRegion = options.Region;
    }
    else
    {
        config.RegionEndpoint = RegionEndpoint.GetBySystemName(options.Region);
    }

    return string.IsNullOrWhiteSpace(options.AccessKey) || string.IsNullOrWhiteSpace(options.SecretKey)
        ? new AmazonS3Client(config)
        : new AmazonS3Client(options.AccessKey, options.SecretKey, config);
});

builder.Services.AddScoped<IObjectStorageService, S3ObjectStorageService>();
builder.Services.AddScoped<IImageService, ImageService.Api.Services.ImageService>();

var app = builder.Build();

await using (var scope = app.Services.CreateAsyncScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<ImageDbContext>();
    await dbContext.Database.EnsureCreatedAsync();
}

app.UseExceptionHandler();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseAuthentication();
app.UseAuthorization();

app.MapHealthChecks("/healthz").AllowAnonymous();
app.MapControllers();
app.Run();

static void ValidateS3Options(S3StorageOptions options)
{
    if (string.IsNullOrWhiteSpace(options.Region))
    {
        throw new InvalidOperationException("Configuration value 'AWS:S3:Region' is required.");
    }

    if (string.IsNullOrWhiteSpace(options.BucketName))
    {
        throw new InvalidOperationException("Configuration value 'AWS:S3:BucketName' is required.");
    }
}

public partial class Program;
