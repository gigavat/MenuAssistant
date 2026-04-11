using System.ComponentModel.DataAnnotations;

namespace ImageService.Api.Contracts;

public sealed class UploadImageRequest
{
    [Required]
    public IFormFile? File { get; init; }
}
