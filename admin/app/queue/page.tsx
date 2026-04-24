"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { PageHeader } from "@/components/page-header";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { adminApi, type MenuQueueEntry } from "@/lib/api";

const STATUSES = [
  "under_review",
  "approved",
  "rejected",
  "legacy",
] as const;

export default function QueuePage() {
  const [status, setStatus] = useState<string>("");
  const [search, setSearch] = useState("");

  const { data, isLoading, error } = useQuery({
    queryKey: ["admin", "queue", status, search],
    queryFn: () =>
      adminApi.listMenuQueue({
        status: status || null,
        search: search || null,
        limit: 200,
      }),
  });

  return (
    <div>
      <PageHeader
        eyebrow="Moderation · parsed menus"
        title="Queue"
        sub="Все рестораны, у которых есть хотя бы одно меню. Click → validator."
      />

      <div className="p-8">
        <div className="mb-4 flex flex-wrap items-center gap-3">
          <Input
            placeholder="Search by restaurant name…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="max-w-sm"
          />
          <Select
            value={status || "all"}
            onValueChange={(v) => setStatus(v === "all" ? "" : v)}
          >
            <SelectTrigger className="w-48">
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
                <TableHead>Restaurant</TableHead>
                <TableHead>City</TableHead>
                <TableHead className="text-right">Pages</TableHead>
                <TableHead className="text-right">Cats</TableHead>
                <TableHead className="text-right">Dishes</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Last change</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading &&
                [0, 1, 2, 3].map((i) => (
                  <TableRow key={i}>
                    <TableCell colSpan={7}>
                      <Skeleton className="h-5 w-full" />
                    </TableCell>
                  </TableRow>
                ))}
              {error && (
                <TableRow>
                  <TableCell colSpan={7} className="text-red-700">
                    Admin API error: {(error as Error).message}
                  </TableCell>
                </TableRow>
              )}
              {data && data.length === 0 && (
                <TableRow>
                  <TableCell
                    colSpan={7}
                    className="py-8 text-center text-brand-muted"
                  >
                    No menus match.
                  </TableCell>
                </TableRow>
              )}
              {data?.map((e) => (
                <QueueRow key={e.restaurantId} entry={e} />
              ))}
            </TableBody>
          </Table>
        </div>
      </div>
    </div>
  );
}

function QueueRow({ entry }: { entry: MenuQueueEntry }) {
  const router = useRouter();
  return (
    <TableRow
      className="cursor-pointer"
      onClick={() => router.push(`/validate/${entry.restaurantId}`)}
    >
      <TableCell className="font-medium">
        {entry.name}
        <div className="mt-0.5 font-mono text-[10px] text-brand-muted">
          id {entry.restaurantId}
        </div>
      </TableCell>
      <TableCell>
        {entry.cityHint ? (
          <div className="flex items-center gap-2">
            <span>{entry.cityHint}</span>
            {entry.countryCode && (
              <Badge variant="secondary" className="font-mono text-[10px]">
                {entry.countryCode}
              </Badge>
            )}
          </div>
        ) : (
          <span className="text-brand-muted">—</span>
        )}
      </TableCell>
      <TableCell className="text-right font-mono text-[11px]">
        {entry.pageCount}
      </TableCell>
      <TableCell className="text-right font-mono text-[11px]">
        {entry.categoryCount}
      </TableCell>
      <TableCell className="text-right font-mono text-[11px]">
        {entry.dishCount}
      </TableCell>
      <TableCell>
        <StatusBadge status={entry.moderationStatus} />
      </TableCell>
      <TableCell className="text-right font-mono text-[11px] text-brand-ink-2">
        {fmtDate(entry.updatedAt ?? entry.parsedAt)}
      </TableCell>
    </TableRow>
  );
}

function StatusBadge({ status }: { status?: string | null }) {
  const label = status ?? "auto";
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
      className={`inline-block rounded-full px-2 py-0.5 font-mono text-[10px] uppercase tracking-[0.06em] ${klass}`}
    >
      {label}
    </span>
  );
}

function fmtDate(iso: string): string {
  const d = new Date(iso);
  return d.toLocaleString("en-GB", {
    month: "short",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
}
