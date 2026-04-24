"use client";

import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { PageHeader } from "@/components/page-header";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { adminApi, type CuratedDish } from "@/lib/api";

const STATUSES = ["draft", "approved", "rejected"] as const;

export default function LibraryPage() {
  const [status, setStatus] = useState<string>("");
  const [search, setSearch] = useState("");
  const [editing, setEditing] = useState<CuratedDish | null>(null);

  const { data, isLoading, error } = useQuery({
    queryKey: ["admin", "curated-dishes", status, search],
    queryFn: () =>
      adminApi.listCuratedDishes({
        status: status || null,
        search: search || null,
        limit: 100,
      }),
  });

  return (
    <div>
      <PageHeader
        eyebrow="Catalog · curated knowledge base"
        title="Dish library"
        sub="Reference dish entries с описанием, cuisine, country. Edit мутации пишутся в audit_log."
      />

      <div className="p-8">
        <div className="mb-4 flex flex-wrap items-center gap-3">
          <Input
            placeholder="Search by name…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="max-w-sm"
          />
          <Select
            value={status || "all"}
            onValueChange={(v) => setStatus(v === "all" ? "" : v)}
          >
            <SelectTrigger className="w-44">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">all statuses</SelectItem>
              {STATUSES.map((s) => (
                <SelectItem key={s} value={s}>
                  {s}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <span className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
            {data ? `${data.length} shown` : ""}
          </span>
        </div>

        <div className="overflow-hidden rounded-[14px] border border-brand-line bg-brand-surface">
          <Table>
            <TableHeader>
              <TableRow className="bg-brand-surface-2 hover:bg-brand-surface-2">
                <TableHead>Name</TableHead>
                <TableHead>Cuisine</TableHead>
                <TableHead>Country</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Updated</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading &&
                [0, 1, 2, 3, 4].map((i) => (
                  <TableRow key={i}>
                    <TableCell colSpan={5}>
                      <Skeleton className="h-5 w-full" />
                    </TableCell>
                  </TableRow>
                ))}
              {error && (
                <TableRow>
                  <TableCell colSpan={5} className="text-red-700">
                    Admin API error: {(error as Error).message}
                  </TableCell>
                </TableRow>
              )}
              {data && data.length === 0 && (
                <TableRow>
                  <TableCell
                    colSpan={5}
                    className="py-8 text-center text-brand-muted"
                  >
                    No dishes match.
                  </TableCell>
                </TableRow>
              )}
              {data?.map((d) => (
                <TableRow
                  key={d.id}
                  className="cursor-pointer"
                  onClick={() => setEditing(d)}
                >
                  <TableCell>
                    <div className="font-medium">{d.displayName}</div>
                    {d.description && (
                      <div className="mt-0.5 line-clamp-1 text-xs text-brand-muted">
                        {d.description}
                      </div>
                    )}
                  </TableCell>
                  <TableCell className="text-sm">
                    {d.cuisine ?? (
                      <span className="text-brand-muted">—</span>
                    )}
                  </TableCell>
                  <TableCell>
                    {d.countryCode ? (
                      <Badge
                        variant="secondary"
                        className="font-mono text-[10px]"
                      >
                        {d.countryCode}
                      </Badge>
                    ) : (
                      <span className="text-brand-muted">—</span>
                    )}
                  </TableCell>
                  <TableCell>
                    <StatusPill status={d.status} />
                  </TableCell>
                  <TableCell className="text-right font-mono text-[11px] text-brand-ink-2">
                    {fmtDate(d.updatedAt)}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </div>

      <EditSheet dish={editing} onClose={() => setEditing(null)} />
    </div>
  );
}

function StatusPill({ status }: { status: string }) {
  const tone =
    status === "approved"
      ? "bg-brand-ok/15 text-brand-ok"
      : status === "rejected"
        ? "bg-red-600/15 text-red-700"
        : "bg-brand-surface-2 text-brand-ink-2";
  return (
    <span
      className={`inline-block rounded-full px-2 py-0.5 font-mono text-[10px] uppercase tracking-[0.06em] ${tone}`}
    >
      {status}
    </span>
  );
}

function EditSheet({
  dish,
  onClose,
}: {
  dish: CuratedDish | null;
  onClose: () => void;
}) {
  const qc = useQueryClient();
  const [form, setForm] = useState<Partial<CuratedDish> | null>(null);

  // Sync form when dish changes
  if (dish && form?.id !== dish.id) {
    setForm({ ...dish });
  }

  const save = useMutation({
    mutationFn: async () => {
      if (!form?.id) throw new Error("no id");
      return adminApi.updateCuratedDish({
        id: form.id,
        displayName: form.displayName,
        cuisine: form.cuisine ?? undefined,
        countryCode: form.countryCode ?? undefined,
        courseType: form.courseType ?? undefined,
        description: form.description ?? undefined,
        status: form.status,
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin", "curated-dishes"] });
      qc.invalidateQueries({ queryKey: ["admin", "audit"] });
      onClose();
    },
  });

  return (
    <Sheet open={dish != null} onOpenChange={(o) => !o && onClose()}>
      <SheetContent className="w-[480px] p-0 sm:max-w-lg">
        <SheetHeader className="px-6 pt-6">
          <SheetTitle className="font-serif text-2xl font-medium">
            Edit dish
          </SheetTitle>
          <SheetDescription className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
            curated_dish · id {form?.id ?? "—"}
          </SheetDescription>
        </SheetHeader>

        {form && (
          <div className="space-y-4 px-6 py-5">
            <Field label="Display name">
              <Input
                value={form.displayName ?? ""}
                onChange={(e) =>
                  setForm({ ...form, displayName: e.target.value })
                }
              />
            </Field>
            <div className="grid grid-cols-2 gap-3">
              <Field label="Cuisine">
                <Input
                  value={form.cuisine ?? ""}
                  onChange={(e) =>
                    setForm({ ...form, cuisine: e.target.value })
                  }
                />
              </Field>
              <Field label="Country (ISO-2)">
                <Input
                  value={form.countryCode ?? ""}
                  maxLength={2}
                  onChange={(e) =>
                    setForm({
                      ...form,
                      countryCode: e.target.value.toUpperCase(),
                    })
                  }
                />
              </Field>
            </div>
            <Field label="Course type">
              <Input
                value={form.courseType ?? ""}
                onChange={(e) =>
                  setForm({ ...form, courseType: e.target.value })
                }
              />
            </Field>
            <Field label="Description">
              <Textarea
                rows={5}
                value={form.description ?? ""}
                onChange={(e) =>
                  setForm({ ...form, description: e.target.value })
                }
              />
            </Field>
            <Field label="Status">
              <Select
                value={form.status ?? "draft"}
                onValueChange={(v) => setForm({ ...form, status: v })}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {STATUSES.map((s) => (
                    <SelectItem key={s} value={s}>
                      {s}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </Field>

            {save.error && (
              <div className="rounded-md border border-red-300 bg-red-50 p-3 text-xs text-red-800">
                {(save.error as Error).message}
              </div>
            )}
          </div>
        )}

        <SheetFooter className="border-t border-brand-line px-6 py-4">
          <Button variant="ghost" onClick={onClose} disabled={save.isPending}>
            Cancel
          </Button>
          <Button
            onClick={() => save.mutate()}
            disabled={save.isPending}
            className="bg-brand-ink text-brand-bg hover:bg-brand-ink-2"
          >
            {save.isPending ? "Saving…" : "Save"}
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}

function Field({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div className="space-y-1.5">
      <Label className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
        {label}
      </Label>
      {children}
    </div>
  );
}

function fmtDate(iso: string): string {
  const d = new Date(iso);
  return d.toLocaleString("en-GB", {
    year: "numeric",
    month: "short",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
}
