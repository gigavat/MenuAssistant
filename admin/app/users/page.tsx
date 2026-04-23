"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { PageHeader } from "@/components/page-header";
import { Input } from "@/components/ui/input";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Skeleton } from "@/components/ui/skeleton";
import { adminApi, type AdminUserRow } from "@/lib/api";

export default function UsersPage() {
  const [search, setSearch] = useState("");

  const { data, isLoading, error } = useQuery<AdminUserRow[]>({
    queryKey: ["admin", "users", search],
    queryFn: () => adminApi.listUsers({ search: search || null, limit: 100 }),
  });

  return (
    <div>
      <PageHeader
        eyebrow="Access · B2C Flutter users"
        title="Users"
        sub="Read-only список зарегистрированных пользователей Flutter app. Роли (user/moderator/admin) — отложены в техдолг."
      />

      <div className="p-8">
        <div className="mb-4 flex items-center gap-3">
          <Input
            placeholder="Search by email or name…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="max-w-sm"
          />
          <span className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
            {data ? `${data.length} shown` : ""}
          </span>
        </div>

        <div className="overflow-hidden rounded-[14px] border border-brand-line bg-brand-surface">
          <Table>
            <TableHeader>
              <TableRow className="bg-brand-surface-2 hover:bg-brand-surface-2">
                <TableHead>Email</TableHead>
                <TableHead>Name</TableHead>
                <TableHead>User ID</TableHead>
                <TableHead className="text-right">Registered</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading && (
                <>
                  {[0, 1, 2, 3, 4].map((i) => (
                    <TableRow key={i}>
                      <TableCell colSpan={4}>
                        <Skeleton className="h-5 w-full" />
                      </TableCell>
                    </TableRow>
                  ))}
                </>
              )}
              {error && (
                <TableRow>
                  <TableCell colSpan={4} className="text-red-700">
                    Admin API error: {(error as Error).message}
                  </TableCell>
                </TableRow>
              )}
              {data && data.length === 0 && (
                <TableRow>
                  <TableCell
                    colSpan={4}
                    className="py-8 text-center text-brand-muted"
                  >
                    No users found.
                  </TableCell>
                </TableRow>
              )}
              {data?.map((u) => (
                <TableRow key={u.userId}>
                  <TableCell className="font-medium">
                    {u.email ?? (
                      <span className="text-brand-muted">—</span>
                    )}
                  </TableCell>
                  <TableCell>
                    {u.displayName ?? (
                      <span className="text-brand-muted">—</span>
                    )}
                  </TableCell>
                  <TableCell className="font-mono text-[11px] text-brand-muted">
                    {u.userId.slice(0, 8)}…
                  </TableCell>
                  <TableCell className="text-right font-mono text-[11px] text-brand-ink-2">
                    {fmtDate(u.createdAt)}
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
