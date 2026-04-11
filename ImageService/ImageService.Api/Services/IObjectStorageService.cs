using ImageService.Api.Models;

namespace ImageService.Api.Services;

public interface IObjectStorageService
{
    Task<UploadedObjectInfo> UploadAsync(Guid imageId, IFormFile file, CancellationToken cancellationToken);

    Task<DownloadedObject?> DownloadAsync(ImageRecord image, CancellationToken cancellationToken);

    Task DeleteAsync(ImageRecord image, CancellationToken cancellationToken);
}
