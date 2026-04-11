using ImageService.Api.Auth;
using ImageService.Api.Contracts;
using ImageService.Api.Models;
using ImageService.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImageService.Api.Controllers;

[ApiController]
[Route("images")]
public sealed class ImagesController(IImageService imageService) : ControllerBase
{
    private readonly IImageService _imageService = imageService;

    [HttpGet]
    [Authorize(Policy = ImageAuthorizationPolicies.Read)]
    [ProducesResponseType<IReadOnlyList<ImageResponse>>(StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyList<ImageResponse>>> List(
        [FromQuery] int limit = 50,
        [FromQuery] int offset = 0,
        CancellationToken cancellationToken = default)
    {
        var normalizedLimit = Math.Clamp(limit, 1, 200);
        var normalizedOffset = Math.Max(offset, 0);
        var images = await _imageService.ListAsync(normalizedLimit, normalizedOffset, cancellationToken);

        return Ok(images.Select(MapResponse));
    }

    [HttpGet("{imageId:guid}")]
    [Authorize(Policy = ImageAuthorizationPolicies.Read)]
    [ProducesResponseType<ImageResponse>(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ImageResponse>> Get(
        Guid imageId,
        CancellationToken cancellationToken = default)
    {
        var image = await _imageService.GetAsync(imageId, cancellationToken);
        return image is null ? NotFound() : Ok(MapResponse(image));
    }

    [HttpGet("{imageId:guid}/content")]
    [Authorize(Policy = ImageAuthorizationPolicies.Read)]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetContent(
        Guid imageId,
        CancellationToken cancellationToken = default)
    {
        var downloadedObject = await _imageService.DownloadAsync(imageId, cancellationToken);
        if (downloadedObject is null)
        {
            return NotFound();
        }

        HttpContext.Response.RegisterForDispose(downloadedObject.StorageResponse);

        return File(
            downloadedObject.StorageResponse.ResponseStream,
            downloadedObject.ContentType,
            downloadedObject.FileName,
            enableRangeProcessing: true);
    }

    [HttpPost]
    [Authorize(Policy = ImageAuthorizationPolicies.Write)]
    [Consumes("multipart/form-data")]
    [ProducesResponseType<ImageResponse>(StatusCodes.Status201Created)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<ImageResponse>> Create(
        [FromForm] UploadImageRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request.File is null)
        {
            return BadRequest(new ValidationProblemDetails(new Dictionary<string, string[]>
            {
                ["file"] = ["Form field 'file' is required."]
            }));
        }

        try
        {
            var image = await _imageService.CreateAsync(request.File, cancellationToken);
            return CreatedAtAction(nameof(Get), new { imageId = image.ImageId }, MapResponse(image));
        }
        catch (InvalidImageException exception)
        {
            return Problem(statusCode: StatusCodes.Status400BadRequest, title: "Invalid image", detail: exception.Message);
        }
    }

    [HttpPut("{imageId:guid}")]
    [Authorize(Policy = ImageAuthorizationPolicies.Write)]
    [Consumes("multipart/form-data")]
    [ProducesResponseType<ImageResponse>(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<ImageResponse>> Update(
        Guid imageId,
        [FromForm] UploadImageRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request.File is null)
        {
            return BadRequest(new ValidationProblemDetails(new Dictionary<string, string[]>
            {
                ["file"] = ["Form field 'file' is required."]
            }));
        }

        try
        {
            var image = await _imageService.UpdateAsync(imageId, request.File, cancellationToken);
            return image is null ? NotFound() : Ok(MapResponse(image));
        }
        catch (InvalidImageException exception)
        {
            return Problem(statusCode: StatusCodes.Status400BadRequest, title: "Invalid image", detail: exception.Message);
        }
    }

    [HttpDelete("{imageId:guid}")]
    [Authorize(Policy = ImageAuthorizationPolicies.Delete)]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(
        Guid imageId,
        CancellationToken cancellationToken = default)
    {
        var deleted = await _imageService.DeleteAsync(imageId, cancellationToken);
        return deleted ? NoContent() : NotFound();
    }

    private ImageResponse MapResponse(ImageRecord image)
    {
        var metadataUrl = Url.ActionLink(nameof(Get), values: new { imageId = image.ImageId }) ?? $"/images/{image.ImageId}";
        var contentUrl = Url.ActionLink(nameof(GetContent), values: new { imageId = image.ImageId }) ?? $"/images/{image.ImageId}/content";

        return ImageResponse.FromRecord(image, metadataUrl, contentUrl);
    }
}
