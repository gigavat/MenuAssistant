using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ImageService.Api.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "images",
                columns: table => new
                {
                    ImageId = table.Column<Guid>(type: "uuid", nullable: false),
                    S3BucketName = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false),
                    S3ObjectKey = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    S3VersionId = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    OriginalFileName = table.Column<string>(type: "character varying(512)", maxLength: 512, nullable: false),
                    ContentType = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    ContentLength = table.Column<long>(type: "bigint", nullable: false),
                    ETag = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_images", x => x.ImageId);
                });

            migrationBuilder.CreateIndex(
                name: "IX_images_CreatedAtUtc",
                table: "images",
                column: "CreatedAtUtc");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "images");
        }
    }
}
