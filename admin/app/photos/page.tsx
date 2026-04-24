"use client";

import { useEffect, useMemo, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { PageHeader } from "@/components/page-header";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { adminApi, type PhotoReviewRow } from "@/lib/api";

/**
 * Keyboard-driven photo review.
 *   1-5 — rate current photo (quality score), moves to next
 *   D   — delete current photo, moves to next
 *   ←/→ — navigate without change
 *   Esc — close focus (no-op visually)
 *
 * Photo в фокусе = первая в списке после текущего cursor'а. Grid
 * остаётся как наглядный reference; клавиатура всегда применяется к
 * sursor'у.
 */
export default function PhotosPage() {
  const qc = useQueryClient();
  const [cursor, setCursor] = useState(0);

  const { data, isLoading, error } = useQuery({
    queryKey: ["admin", "photos", "low-quality"],
    queryFn: () => adminApi.listLowQualityPhotos({ maxQuality: 3, limit: 80 }),
  });

  const rate = useMutation({
    mutationFn: (params: { imageId: number; qualityScore: number }) =>
      adminApi.setPhotoQuality(params),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin", "photos"] });
      qc.invalidateQueries({ queryKey: ["admin", "audit"] });
      setCursor((c) => c + 1);
    },
  });
  const del = useMutation({
    mutationFn: (params: { imageId: number }) => adminApi.deletePhoto(params),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin", "photos"] });
      qc.invalidateQueries({ queryKey: ["admin", "audit"] });
    },
  });

  const current: PhotoReviewRow | undefined = useMemo(
    () => data?.[cursor],
    [data, cursor],
  );

  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (!current) return;
      if (e.key >= "1" && e.key <= "5") {
        e.preventDefault();
        rate.mutate({
          imageId: current.imageId,
          qualityScore: parseInt(e.key, 10),
        });
      } else if (e.key.toLowerCase() === "d") {
        e.preventDefault();
        del.mutate({ imageId: current.imageId });
      } else if (e.key === "ArrowRight") {
        setCursor((c) => Math.min(c + 1, (data?.length ?? 1) - 1));
      } else if (e.key === "ArrowLeft") {
        setCursor((c) => Math.max(c - 1, 0));
      }
    };
    window.addEventListener("keydown", handler);
    return () => window.removeEventListener("keydown", handler);
  }, [current, rate, del, data?.length]);

  return (
    <div>
      <PageHeader
        eyebrow="Moderation · curated_dish_image · qualityScore ≤ 3"
        title="Photo review"
        sub="Press 1–5 to rate, D to delete, ← → to navigate. All actions logged to audit_log."
      />

      <div className="p-8">
        {isLoading && (
          <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
            {[0, 1, 2, 3].map((i) => (
              <Skeleton key={i} className="aspect-square rounded-[14px]" />
            ))}
          </div>
        )}

        {error && (
          <div className="rounded-md border border-red-300 bg-red-50/50 p-4 text-sm text-red-800">
            Admin API error: {(error as Error).message}
          </div>
        )}

        {data && data.length === 0 && (
          <div className="py-16 text-center text-brand-muted">
            No low-quality photos. Everything graded ≥ 4.
          </div>
        )}

        {data && data.length > 0 && current && (
          <div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_360px]">
            <div className="overflow-hidden rounded-[14px] border border-brand-line bg-brand-surface">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={current.imageUrl}
                alt={current.dishDisplayName}
                className="aspect-[4/3] w-full object-cover"
              />
              <div className="border-t border-brand-line p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <div className="font-serif text-xl font-medium">
                      {current.dishDisplayName}
                    </div>
                    <div className="mt-1 flex gap-2 font-mono text-[10px] uppercase tracking-[0.06em] text-brand-muted">
                      <Badge
                        variant="secondary"
                        className="font-mono text-[10px]"
                      >
                        {current.source}
                      </Badge>
                      <span>quality {current.qualityScore}/5</span>
                      {current.isPrimary && <span>· primary</span>}
                      {current.width && current.height && (
                        <span>
                          · {current.width}×{current.height}
                        </span>
                      )}
                    </div>
                  </div>
                  <div className="font-mono text-[11px] text-brand-muted">
                    {cursor + 1} / {data.length}
                  </div>
                </div>
              </div>
            </div>

            <div className="space-y-4">
              <div className="rounded-[14px] border border-brand-line bg-brand-surface p-4">
                <div className="mb-2 font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
                  Rate
                </div>
                <div className="flex gap-2">
                  {[1, 2, 3, 4, 5].map((n) => (
                    <Button
                      key={n}
                      variant={
                        current.qualityScore === n ? "default" : "outline"
                      }
                      disabled={rate.isPending}
                      onClick={() =>
                        rate.mutate({
                          imageId: current.imageId,
                          qualityScore: n,
                        })
                      }
                      className="h-12 flex-1 text-lg font-mono"
                    >
                      {n}
                    </Button>
                  ))}
                </div>
              </div>
              <div className="rounded-[14px] border border-brand-line bg-brand-surface p-4">
                <div className="mb-2 font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
                  Actions
                </div>
                <div className="space-y-2">
                  <Button
                    variant="outline"
                    disabled={del.isPending}
                    onClick={() =>
                      del.mutate({ imageId: current.imageId })
                    }
                    className="w-full border-red-300 text-red-700 hover:bg-red-50"
                  >
                    Delete (D)
                  </Button>
                  <div className="flex gap-2">
                    <Button
                      variant="ghost"
                      onClick={() => setCursor((c) => Math.max(c - 1, 0))}
                      className="flex-1 border border-brand-line"
                    >
                      ← Prev
                    </Button>
                    <Button
                      variant="ghost"
                      onClick={() =>
                        setCursor((c) =>
                          Math.min(c + 1, data.length - 1),
                        )
                      }
                      className="flex-1 border border-brand-line"
                    >
                      Next →
                    </Button>
                  </div>
                </div>
              </div>
              <p className="px-1 text-xs text-brand-muted">
                Press <kbd className="rounded bg-brand-surface-2 px-1.5 py-0.5 font-mono text-[11px]">1</kbd>
                –<kbd className="rounded bg-brand-surface-2 px-1.5 py-0.5 font-mono text-[11px]">5</kbd>
                to rate, <kbd className="rounded bg-brand-surface-2 px-1.5 py-0.5 font-mono text-[11px]">D</kbd>
                to delete. Rate advances cursor automatically.
              </p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
