"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { PageHeader } from "@/components/page-header";
import { Input } from "@/components/ui/input";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
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
import { adminApi } from "@/lib/api";

const OBJECT_TYPES = ["curated_dish", "translation", "photo"] as const;
const ACTIONS = [
  "edited",
  "status_changed",
  "created",
  "rated_photo",
  "deleted_photo",
] as const;

export default function AuditPage() {
  const [actor, setActor] = useState("");
  const [objectType, setObjectType] = useState("");
  const [action, setAction] = useState("");

  const { data, isLoading, error } = useQuery({
    queryKey: ["admin", "audit", actor, objectType, action],
    queryFn: () =>
      adminApi.listAuditLog({
        actorEmail: actor || null,
        objectType: objectType || null,
        action: action || null,
        limit: 200,
      }),
  });

  return (
    <div>
      <PageHeader
        eyebrow="Access · immutable append-only, 24mo retention"
        title="Audit log"
        sub="Каждая мутация модератора — отдельная строка. Никаких UPDATE/DELETE."
      />

      <div className="p-8">
        <div className="mb-4 flex flex-wrap items-center gap-3">
          <Input
            placeholder="Actor email…"
            value={actor}
            onChange={(e) => setActor(e.target.value)}
            className="max-w-xs"
          />
          <Select
            value={objectType || "all"}
            onValueChange={(v) => setObjectType(v === "all" ? "" : v)}
          >
            <SelectTrigger className="w-44">
              <SelectValue placeholder="object type" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">all types</SelectItem>
              {OBJECT_TYPES.map((t) => (
                <SelectItem key={t} value={t}>
                  {t}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Select
            value={action || "all"}
            onValueChange={(v) => setAction(v === "all" ? "" : v)}
          >
            <SelectTrigger className="w-48">
              <SelectValue placeholder="action" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">all actions</SelectItem>
              {ACTIONS.map((a) => (
                <SelectItem key={a} value={a}>
                  {a}
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
                <TableHead className="w-40">Time</TableHead>
                <TableHead>Actor</TableHead>
                <TableHead>Action</TableHead>
                <TableHead>Object</TableHead>
                <TableHead>Diff</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading &&
                [0, 1, 2, 3].map((i) => (
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
                    No actions recorded in this filter. Audit starts to fill
                    once you approve a dish or edit a translation.
                  </TableCell>
                </TableRow>
              )}
              {data?.map((e, i) => (
                <TableRow key={e.id ?? i}>
                  <TableCell className="font-mono text-[11px] text-brand-muted">
                    {fmtDate(e.timestamp)}
                  </TableCell>
                  <TableCell className="font-mono text-[11px]">
                    {e.actorEmail}
                  </TableCell>
                  <TableCell>
                    <Badge variant="secondary" className="font-mono text-[10px]">
                      {e.action}
                    </Badge>
                  </TableCell>
                  <TableCell className="font-mono text-[11px]">
                    <span className="text-brand-muted">{e.objectType}</span>
                    <span className="ml-1">#{e.objectId}</span>
                  </TableCell>
                  <TableCell>
                    <DiffCell json={e.diff} />
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </div>
    </div>
  );
}

function DiffCell({ json }: { json: string }) {
  const text = renderDiffText(json);
  return (
    <span className="line-clamp-2 font-mono text-[11px] text-brand-ink-2">
      {text}
    </span>
  );
}

function renderDiffText(json: string): string {
  try {
    return summarizeDiff(JSON.parse(json));
  } catch {
    return json;
  }
}

function summarizeDiff(obj: unknown): string {
  if (obj == null || typeof obj !== "object") return String(obj);
  const o = obj as Record<string, unknown>;
  if ("before" in o && "after" in o) {
    const before = (o.before ?? {}) as Record<string, unknown>;
    const after = (o.after ?? {}) as Record<string, unknown>;
    const parts: string[] = [];
    for (const k of Object.keys(after)) {
      if (JSON.stringify(before[k]) !== JSON.stringify(after[k])) {
        parts.push(`${k}: ${fmtVal(before[k])} → ${fmtVal(after[k])}`);
      }
    }
    return parts.join(" · ") || "(no field-level change)";
  }
  if ("from" in o && "to" in o) {
    return `${fmtVal(o.from)} → ${fmtVal(o.to)}`;
  }
  return Object.entries(o)
    .map(([k, v]) => `${k}: ${fmtVal(v)}`)
    .join(" · ");
}

function fmtVal(v: unknown): string {
  if (v == null) return "∅";
  if (typeof v === "string") {
    return v.length > 40 ? `"${v.slice(0, 40)}…"` : `"${v}"`;
  }
  return String(v);
}

function fmtDate(iso: string): string {
  const d = new Date(iso);
  return d.toLocaleString("en-GB", {
    month: "short",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
  });
}
