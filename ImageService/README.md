# ImageService

`ImageService` is a `.NET 10` microservice that stores image binaries in Amazon S3 and keeps its own metadata mapping in PostgreSQL. It accepts only internal service-to-service calls and protects image endpoints with short-lived internal JWTs signed with `HS256`.

## What it does

- Generates its own `imageId` (`Guid`) instead of exposing raw S3 keys.
- Stores image metadata in PostgreSQL.
- Stores image content in S3 via the official `AWSSDK.S3` client.
- Requires an internal bearer token with `images.read`, `images.write`, or `images.delete` scopes.
- Exposes `GET /healthz` without authentication for container and load balancer health checks.

## API

- `GET /healthz` anonymous health check.
- `GET /images` requires `images.read`.
- `GET /images/{imageId}` requires `images.read`.
- `GET /images/{imageId}/content` requires `images.read`.
- `POST /images` requires `images.write` and accepts multipart field `file`.
- `PUT /images/{imageId}` requires `images.write` and accepts multipart field `file`.
- `DELETE /images/{imageId}` requires `images.delete`.

## Configuration

Configuration comes from `appsettings.json`, environment variables, or container overrides.

Required:

- `ConnectionStrings__ImageDb`
- `AWS__S3__Region`
- `AWS__S3__BucketName`
- `InternalJwt__Issuer`
- `InternalJwt__Audience`
- `InternalJwt__SigningKey`

Optional:

- `AWS__S3__AccessKey`
- `AWS__S3__SecretKey`
- `AWS__S3__ServiceUrl`
- `AWS__S3__ForcePathStyle`

`InternalJwt__SigningKey` must be at least 32 bytes for `HS256`.

## Internal JWT contract

The calling service, for example `serverpod`, should issue a short-lived JWT:

- `iss`: `serverpod` or another stable internal issuer name.
- `aud`: `image-service`.
- `sub`: caller service name.
- `scope`: space-separated scopes such as `images.read images.write`.
- `exp`: a short lifetime, for example `1-5` minutes.

Recommended model:

- client sends the user token only to `serverpod`.
- `serverpod` validates the user and business permissions.
- `serverpod` calls `image-service` with an internal JWT of its own.
- `image-service` trusts only the internal JWT, not the original user token.

## Run locally with Docker

1. Set real S3 settings and the shared JWT secret in [docker-compose.yml](/C:/Users/andre/OneDrive/Desktop/MenuAssistant2/ImageService/docker-compose.yml).
2. Start PostgreSQL and the API:

```powershell
docker compose up --build
```

3. Probe the health endpoint:

```powershell
curl http://localhost:8080/healthz
```

The compose file already injects:

- `ConnectionStrings__ImageDb`
- `InternalJwt__Issuer`
- `InternalJwt__Audience`
- `InternalJwt__SigningKey`

You still need to provide valid S3 credentials unless you are relying on the default AWS credential chain in another environment.

## Run locally without Docker

1. Start PostgreSQL.
2. Configure [appsettings.Development.json](/C:/Users/andre/OneDrive/Desktop/MenuAssistant2/ImageService/ImageService.Api/appsettings.Development.json) or environment variables.
3. Run the API:

```powershell
$env:DOTNET_CLI_HOME=(Get-Location).Path
$env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE='1'
dotnet run --project ImageService.Api
```

## Tests

The test suite does not require real S3 or PostgreSQL.

- Unit tests use `InMemoryAmazonS3Client`, a reusable fake S3 client in [InMemoryAmazonS3Client.cs](/C:/Users/andre/OneDrive/Desktop/MenuAssistant2/ImageService/tests/ImageService.Api.Tests/TestDoubles/InMemoryAmazonS3Client.cs).
- Integration-style API tests host the real ASP.NET application with:
  - EF Core InMemory database
  - the same fake S3 client
  - test JWT settings injected in-memory

Run tests:

```powershell
$env:DOTNET_CLI_HOME=(Get-Location).Path
$env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE='1'
dotnet test ImageService.slnx -v minimal
```

If you want to reuse the fake S3 in additional integration tests, register `InMemoryAmazonS3Client` as `IAmazonS3` the same way as [ImageServiceWebApplicationFactory.cs](/C:/Users/andre/OneDrive/Desktop/MenuAssistant2/ImageService/tests/ImageService.Api.Tests/Infrastructure/ImageServiceWebApplicationFactory.cs).

## Amazon ECS production setup

Recommended deployment model:

- run `serverpod` and `image-service` as separate ECS services in private subnets;
- expose `image-service` only through private networking;
- allow inbound traffic to `image-service` only from the `serverpod` security group;
- use `GET /healthz` for ECS or ALB health checks;
- keep PostgreSQL private;
- use an ECS task role for S3 access instead of static AWS access keys.

### ECS secrets and env vars

Store these in `AWS Secrets Manager` or `SSM Parameter Store` and inject them into both services:

- `InternalJwt__Issuer`
- `InternalJwt__Audience`
- `InternalJwt__SigningKey`

Store these for `image-service` only:

- `ConnectionStrings__ImageDb`

Regular environment variables for `image-service`:

- `AWS__S3__Region`
- `AWS__S3__BucketName`

In production on ECS, prefer omitting:

- `AWS__S3__AccessKey`
- `AWS__S3__SecretKey`

and instead grant the ECS task role permission to:

- `s3:GetObject`
- `s3:PutObject`
- `s3:DeleteObject`

for the target bucket and prefix.

### Recommended production values

- `InternalJwt__Issuer=serverpod`
- `InternalJwt__Audience=image-service`
- `InternalJwt__SigningKey=<shared secret from Secrets Manager>`
- token lifetime: `1-5` minutes
- scopes:
  - `images.read` for read-only flows
  - `images.write` for create and replace flows
  - `images.delete` for delete flows

### TLS in ECS

Recommended:

- terminate TLS on an internal ALB if services talk through an ALB;
- keep `image-service` private even if the ALB is internal;
- if traffic bypasses an ALB and goes direct service-to-service, decide explicitly whether TLS is handled by the platform, a mesh, or the application.

Even with private networking, keep the JWT check enabled. Security groups answer "who can reach the service". Internal JWT answers "who is authorized to call the API".

## Notes

- The application currently uses `EnsureCreated()` for schema bootstrap. Replace this with EF Core migrations before production rollout.
- Updating an image uploads a new S3 object and deletes the old blob after metadata is updated in PostgreSQL.
- The fake S3 client is intended for tests only. Do not register it in production.
