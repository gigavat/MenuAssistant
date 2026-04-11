using ImageService.Api.Models;

namespace ImageService.Api.Services;

public interface IImageService
{
    Task<IReadOnlyList<ImageRecord>> ListAsync(int limit, int offset, CancellationToken cancellationToken);

    Task<ImageRecord?> GetAsync(Guid imageId, CancellationToken cancellationToken);

    Task<ImageRecord> CreateAsync(IFormFile file, CancellationToken cancellationToken);

    Task<ImageRecord?> UpdateAsync(Guid imageId, IFormFile file, CancellationToken cancellationToken);

    Task<DownloadedObject?> DownloadAsync(Guid imageId, CancellationToken cancellationToken);

    Task<bool> DeleteAsync(Guid imageId, CancellationToken cancellationToken);
}
