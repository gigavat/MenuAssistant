"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { PageHeader } from "@/components/page-header";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { adminApi, type CuratedDish } from "@/lib/api";

/**
 * Экран ревью dish-каталога. В MVP фильтр = `status='draft'` — всё что
 * было загружено bootstrap'ом / agregator'ом в Sprint 4.5/4.10 и ждёт
 * валидации. При появлении confidence scoring в Claude (техдолг из
 * ROADMAP) добавим фильтры low_confidence / plausible_description и
 * flagged-by-users.
 */
export default function DishReviewPage() {
  const qc = useQueryClient();
  const { data, isLoading, error } = useQuery({
    queryKey: ["admin", "curated-dishes", "draft", ""],
    queryFn: () =>
      adminApi.listCuratedDishes({ status: "draft", limit: 60 }),
  });

  const setStatus = useMutation({
    mutationFn: (params: { id: number; status: string }) =>
      adminApi.updateCuratedDish(params),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin", "curated-dishes"] });
      qc.invalidateQueries({ queryKey: ["admin", "audit"] });
    },
  });

  return (
    <div>
      <PageHeader
        eyebrow="Moderation · approve or reject drafts"
        title="Dish review"
        sub={`${data ? data.length : "…"} draft dishes waiting for review. Approve sets approvedBy to your email. Audit log captures every decision.`}
      />

      <div className="grid gap-4 p-8 md:grid-cols-2 lg:grid-cols-3">
        {isLoading &&
          [0, 1, 2, 3].map((i) => (
            <Skeleton key={i} className="h-56 w-full rounded-[14px]" />
          ))}

        {error && (
          <Card className="border-red-300 bg-red-50/40 md:col-span-2 lg:col-span-3">
            <CardHeader>
              <CardTitle className="text-red-700">Admin API error</CardTitle>
            </CardHeader>
            <CardContent className="font-mono text-xs text-red-800">
              {(error as Error).message}
            </CardContent>
          </Card>
        )}

        {data && data.length === 0 && (
          <div className="col-span-full py-16 text-center text-brand-muted">
            No drafts — catalog is fully reviewed.
          </div>
        )}

        {data?.map((d) => (
          <DishCard
            key={d.id}
            dish={d}
            onApprove={() =>
              setStatus.mutate({ id: d.id, status: "approved" })
            }
            onReject={() =>
              setStatus.mutate({ id: d.id, status: "rejected" })
            }
            pending={
              setStatus.isPending && setStatus.variables?.id === d.id
            }
          />
        ))}
      </div>
    </div>
  );
}

function DishCard({
  dish,
  onApprove,
  onReject,
  pending,
}: {
  dish: CuratedDish;
  onApprove: () => void;
  onReject: () => void;
  pending: boolean;
}) {
  const flagged = dish.tags?.includes("plausible_description");
  return (
    <Card className="flex flex-col">
      <CardHeader className="space-y-1.5">
        <div className="flex items-start justify-between gap-2">
          <CardTitle className="font-serif text-xl font-medium leading-tight">
            {dish.displayName}
          </CardTitle>
          {flagged && (
            <Badge
              variant="secondary"
              className="bg-yellow-100 font-mono text-[10px] text-yellow-900"
            >
              plausible
            </Badge>
          )}
        </div>
        <div className="flex flex-wrap gap-1.5 font-mono text-[10px] uppercase tracking-[0.06em] text-brand-muted">
          {dish.cuisine && <span>{dish.cuisine}</span>}
          {dish.countryCode && <span>· {dish.countryCode}</span>}
          {dish.wikidataId && <span>· {dish.wikidataId}</span>}
        </div>
      </CardHeader>
      <CardContent className="flex-1">
        <p className="line-clamp-6 text-[13px] leading-relaxed text-brand-ink-2">
          {dish.description ?? (
            <span className="italic text-brand-muted">no description</span>
          )}
        </p>
      </CardContent>
      <div className="flex gap-2 border-t border-brand-line p-3">
        <Button
          variant="ghost"
          disabled={pending}
          onClick={onReject}
          className="flex-1 border border-brand-line"
        >
          Reject
        </Button>
        <Button
          disabled={pending}
          onClick={onApprove}
          className="flex-1 bg-brand-ok text-white hover:bg-brand-ok/90"
        >
          Approve
        </Button>
      </div>
    </Card>
  );
}
