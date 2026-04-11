using ImageService.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ImageService.Api.Data;

public sealed class ImageDbContext(DbContextOptions<ImageDbContext> options) : DbContext(options)
{
    public DbSet<ImageRecord> Images => Set<ImageRecord>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        var image = modelBuilder.Entity<ImageRecord>();

        image.ToTable("images");
        image.HasKey(x => x.ImageId);

        image.Property(x => x.ImageId)
            .ValueGeneratedNever();

        image.Property(x => x.S3BucketName)
            .HasMaxLength(128)
            .IsRequired();

        image.Property(x => x.S3ObjectKey)
            .HasMaxLength(1024)
            .IsRequired();

        image.Property(x => x.S3VersionId)
            .HasMaxLength(256);

        image.Property(x => x.OriginalFileName)
            .HasMaxLength(512)
            .IsRequired();

        image.Property(x => x.ContentType)
            .HasMaxLength(255)
            .IsRequired();

        image.Property(x => x.ETag)
            .HasMaxLength(128);

        image.Property(x => x.CreatedAtUtc)
            .HasColumnType("timestamp with time zone");

        image.Property(x => x.UpdatedAtUtc)
            .HasColumnType("timestamp with time zone");

        image.HasIndex(x => x.CreatedAtUtc);
    }
}
