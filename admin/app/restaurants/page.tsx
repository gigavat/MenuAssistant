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
import { Badge } from "@/components/ui/badge";
import { adminApi, type Restaurant } from "@/lib/api";

export default function RestaurantsPage() {
  const [search, setSearch] = useState("");

  const { data, isLoading, error } = useQuery<Restaurant[]>({
    queryKey: ["admin", "restaurants", search],
    queryFn: () =>
      adminApi.listRestaurants({ search: search || null, limit: 100 }),
  });

  return (
    <div>
      <PageHeader
        eyebrow="Catalog · global restaurants"
        title="Restaurants"
        sub='Global catalog после dedup. "Claim" column — hidden до Sprint 6 (B2B).'
      />

      <div className="p-8">
        <div className="mb-4 flex items-center gap-3">
          <Input
            placeholder="Search by name…"
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
                <TableHead>Name</TableHead>
                <TableHead>City</TableHead>
                <TableHead>Country</TableHead>
                <TableHead>Currency</TableHead>
                <TableHead className="text-right">Added</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading && (
                <>
                  {[0, 1, 2, 3, 4].map((i) => (
                    <TableRow key={i}>
                      <TableCell colSpan={5}>
                        <Skeleton className="h-5 w-full" />
                      </TableCell>
                    </TableRow>
                  ))}
                </>
              )}
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
                    No restaurants found.
                  </TableCell>
                </TableRow>
              )}
              {data?.map((r) => (
                <TableRow key={r.id}>
                  <TableCell className="font-medium">{r.name}</TableCell>
                  <TableCell>
                    {r.cityHint ?? (
                      <span className="text-brand-muted">—</span>
                    )}
                  </TableCell>
                  <TableCell>
                    {r.countryCode ? (
                      <Badge variant="secondary" className="font-mono text-[10px]">
                        {r.countryCode}
                      </Badge>
                    ) : (
                      <span className="text-brand-muted">—</span>
                    )}
                  </TableCell>
                  <TableCell className="font-mono text-[11px]">
                    {r.currency}
                  </TableCell>
                  <TableCell className="text-right font-mono text-[11px] text-brand-ink-2">
                    {fmtDate(r.createdAt)}
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
  });
}
