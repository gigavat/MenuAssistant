"use client";

import { use, useState } from "react";
import Link from "next/link";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { PageHeader } from "@/components/page-header";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Textarea } from "@/components/ui/textarea";
import {
  Sheet,
  SheetContent,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import {
  adminApi,
  type MenuValidationView,
  type MenuItem,
} from "@/lib/api";

export default function ValidatePage({
  params,
}: {
  params: Promise<{ restaurantId: string }>;
}) {
  const { restaurantId } = use(params);
  const rid = parseInt(restaurantId, 10);

  const qc = useQueryClient();
  const [activePage, setActivePage] = useState(0);
  const [editingItem, setEditingItem] = useState<MenuItem | null>(null);
  const [rejectingReason, setRejectingReason] = useState<string | null>(null);

  const { data, isLoading, error } = useQuery<MenuValidationView>({
    queryKey: ["admin", "validation", rid],
    queryFn: () => adminApi.getMenuForValidation({ restaurantId: rid }),
  });

  const approve = useMutation({
    mutationFn: () => adminApi.approveMenu({ restaurantId: rid }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin", "validation", rid] });
      qc.invalidateQueries({ queryKey: ["admin", "queue"] });
      qc.invalidateQueries({ queryKey: ["admin", "audit"] });
    },
  });

  const reject = useMutation({
    mutationFn: (reason: string) =>
      adminApi.rejectMenu({ restaurantId: rid, reason }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin", "validation", rid] });
      qc.invalidateQueries({ queryKey: ["admin", "queue"] });
      qc.invalidateQueries({ queryKey: ["admin", "audit"] });
      setRejectingReason(null);
    },
  });

  if (isLoading) {
    return (
      <div className="p-8">
        <Skeleton className="mb-4 h-20 w-full" />
        <Skeleton className="h-96 w-full" />
      </div>
    );
  }
  if (error || !data) {
    return (
      <div className="p-8 text-red-700">
        Admin API error: {(error as Error | undefined)?.message ?? "no data"}
      </div>
    );
  }

  const status = data.restaurant.moderationStatus ?? "auto";
  const currentPage = data.pages[activePage];

  return (
    <div className="flex min-h-screen flex-col">
      <PageHeader
        eyebrow={
          <span className="inline-flex items-center gap-2">
            <Link
              href="/queue"
              className="text-brand-muted hover:text-brand-ink"
            >
              ← queue
            </Link>
            <span>·</span>
            <span>restaurant #{data.restaurant.id}</span>
            <span>·</span>
            <StatusBadge status={status} />
          </span>
        }
        title={data.restaurant.name}
        sub={
          [
            data.restaurant.cityHint,
            data.restaurant.countryCode,
            data.restaurant.currency,
          ]
            .filter(Boolean)
            .join(" · ") || "no location metadata"
        }
        actions={
          <>
            <Button
              variant="outline"
              disabled={reject.isPending}
              onClick={() => setRejectingReason("")}
              className="border-red-300 text-red-700 hover:bg-red-50"
            >
              Reject
            </Button>
            <Button
              onClick={() => approve.mutate()}
              disabled={approve.isPending}
              className="bg-brand-ok text-white hover:bg-brand-ok/90"
            >
              {approve.isPending ? "Approving…" : "Approve menu"}
            </Button>
          </>
        }
      />

      <div className="grid flex-1 gap-0 lg:grid-cols-[minmax(0,1fr)_minmax(0,1fr)]">
        {/* Left: source pages */}
        <div className="border-r border-brand-line p-6">
          {data.pages.length === 0 ? (
            <div className="rounded-[14px] border border-brand-line bg-brand-surface p-8 text-center text-brand-muted">
              No source pages. Legacy upload?
            </div>
          ) : (
            <div className="sticky top-6 space-y-3">
              <div className="flex items-center gap-2 font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
                <span>
                  Page {activePage + 1} / {data.pages.length}
                </span>
                <span>·</span>
                <span>{currentPage?.sourceType}</span>
              </div>
              {currentPage && (
                <div className="overflow-hidden rounded-[14px] border border-brand-line bg-brand-surface">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img
                    src={currentPage.imageUrl}
                    alt={`Page ${activePage + 1}`}
                    className="max-h-[75vh] w-full object-contain bg-brand-bg"
                  />
                </div>
              )}
              {data.pages.length > 1 && (
                <div className="flex flex-wrap gap-2">
                  {data.pages.map((p, i) => (
                    <button
                      key={p.id ?? i}
                      onClick={() => setActivePage(i)}
                      className={`rounded border px-2 py-1 font-mono text-[11px] ${
                        i === activePage
                          ? "border-brand-ink bg-brand-ink text-brand-bg"
                          : "border-brand-line hover:bg-brand-surface-2"
                      }`}
                    >
                      {i + 1}
                    </button>
                  ))}
                </div>
              )}
            </div>
          )}
        </div>

        {/* Right: parsed items */}
        <div className="p-6">
          <div className="space-y-6">
            {data.categories.length === 0 && (
              <div className="rounded-[14px] border border-brand-line bg-brand-surface p-8 text-center text-brand-muted">
                Menu has no categories yet.
              </div>
            )}
            {data.categories.map((cat) => {
              const catItems = data.items.filter(
                (it) => it.categoryId === cat.id,
              );
              return (
                <div key={cat.id}>
                  <div className="mb-2 flex items-baseline gap-2">
                    <h2 className="font-serif text-xl font-medium">
                      {cat.name}
                    </h2>
                    <span className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
                      {catItems.length} dishes
                    </span>
                  </div>
                  <div className="divide-y divide-brand-line overflow-hidden rounded-[14px] border border-brand-line bg-brand-surface">
                    {catItems.length === 0 && (
                      <div className="p-4 text-center text-brand-muted">
                        (no items)
                      </div>
                    )}
                    {catItems.map((it) => (
                      <button
                        key={it.id}
                        onClick={() => setEditingItem(it)}
                        className="flex w-full items-center justify-between gap-3 px-4 py-3 text-left hover:bg-brand-surface-2"
                      >
                        <div className="min-w-0 flex-1">
                          <div className="font-medium">{it.name}</div>
                          <div className="mt-0.5 flex flex-wrap gap-1">
                            {it.tags?.map((t) => (
                              <Badge
                                key={t}
                                variant="secondary"
                                className="font-mono text-[9px]"
                              >
                                {t}
                              </Badge>
                            ))}
                          </div>
                        </div>
                        <div className="shrink-0 font-mono text-[13px] text-brand-ink-2">
                          {it.price.toLocaleString("ru-RU", {
                            minimumFractionDigits: 0,
                            maximumFractionDigits: 2,
                          })}{" "}
                          {data.restaurant.currency}
                        </div>
                      </button>
                    ))}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      <ItemEditSheet
        item={editingItem}
        restaurantId={rid}
        onClose={() => setEditingItem(null)}
      />

      <RejectSheet
        open={rejectingReason !== null}
        onCancel={() => setRejectingReason(null)}
        pending={reject.isPending}
        onSubmit={(r) => reject.mutate(r)}
      />
    </div>
  );
}

function StatusBadge({ status }: { status: string }) {
  const klass =
    status === "approved"
      ? "bg-brand-ok/15 text-brand-ok"
      : status === "rejected"
        ? "bg-red-600/15 text-red-700"
        : status === "under_review"
          ? "bg-yellow-100 text-yellow-900"
          : "bg-brand-surface-2 text-brand-ink-2";
  return (
    <span
      className={`rounded-full px-2 py-0.5 font-mono text-[10px] uppercase ${klass}`}
    >
      {status}
    </span>
  );
}

function ItemEditSheet({
  item,
  restaurantId,
  onClose,
}: {
  item: MenuItem | null;
  restaurantId: number;
  onClose: () => void;
}) {
  const qc = useQueryClient();
  const [name, setName] = useState("");
  const [price, setPrice] = useState("");

  if (item && name === "" && price === "") {
    setName(item.name);
    setPrice(String(item.price));
  }

  const save = useMutation({
    mutationFn: async () => {
      if (!item?.id) throw new Error("no item id");
      const parsed = parseFloat(price);
      return adminApi.updateMenuItem({
        itemId: item.id,
        name,
        price: isNaN(parsed) ? undefined : parsed,
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({
        queryKey: ["admin", "validation", restaurantId],
      });
      qc.invalidateQueries({ queryKey: ["admin", "audit"] });
      setName("");
      setPrice("");
      onClose();
    },
  });

  return (
    <Sheet
      open={item != null}
      onOpenChange={(o) => {
        if (!o) {
          setName("");
          setPrice("");
          onClose();
        }
      }}
    >
      <SheetContent className="w-[400px] p-0 sm:max-w-md">
        <SheetHeader className="px-6 pt-6">
          <SheetTitle className="font-serif text-xl font-medium">
            Edit menu item
          </SheetTitle>
          <div className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
            menu_item · id {item?.id}
          </div>
        </SheetHeader>

        <div className="space-y-4 px-6 py-5">
          <div className="space-y-1.5">
            <label className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
              Name
            </label>
            <Input value={name} onChange={(e) => setName(e.target.value)} />
          </div>
          <div className="space-y-1.5">
            <label className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
              Price
            </label>
            <Input
              type="number"
              step="0.01"
              value={price}
              onChange={(e) => setPrice(e.target.value)}
            />
          </div>
          {save.error && (
            <div className="rounded-md border border-red-300 bg-red-50 p-3 text-xs text-red-800">
              {(save.error as Error).message}
            </div>
          )}
        </div>

        <SheetFooter className="border-t border-brand-line px-6 py-4">
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button
            onClick={() => save.mutate()}
            disabled={save.isPending || !name.trim()}
            className="bg-brand-ink text-brand-bg hover:bg-brand-ink-2"
          >
            {save.isPending ? "Saving…" : "Save"}
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}

function RejectSheet({
  open,
  onCancel,
  pending,
  onSubmit,
}: {
  open: boolean;
  onCancel: () => void;
  pending: boolean;
  onSubmit: (reason: string) => void;
}) {
  const [reason, setReason] = useState("");

  return (
    <Sheet
      open={open}
      onOpenChange={(o) => {
        if (!o) {
          setReason("");
          onCancel();
        }
      }}
    >
      <SheetContent className="w-[400px] p-0 sm:max-w-md">
        <SheetHeader className="px-6 pt-6">
          <SheetTitle className="font-serif text-xl font-medium">
            Reject menu
          </SheetTitle>
          <div className="text-[13px] text-brand-ink-2">
            Reason будет записан в audit_log и виден в validator&apos;е
            при следующей загрузке.
          </div>
        </SheetHeader>

        <div className="px-6 py-5">
          <Textarea
            rows={6}
            placeholder="e.g. unreadable photo / duplicate / parse errors"
            value={reason}
            onChange={(e) => setReason(e.target.value)}
          />
        </div>

        <SheetFooter className="border-t border-brand-line px-6 py-4">
          <Button variant="ghost" onClick={onCancel}>
            Cancel
          </Button>
          <Button
            onClick={() => onSubmit(reason)}
            disabled={pending || !reason.trim()}
            className="bg-red-600 text-white hover:bg-red-700"
          >
            {pending ? "Rejecting…" : "Reject menu"}
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}
