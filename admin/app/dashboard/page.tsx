"use client";

import { useQuery } from "@tanstack/react-query";
import { PageHeader, type Kpi } from "@/components/page-header";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { adminApi, type AdminMetrics } from "@/lib/api";

export default function DashboardPage() {
  const { data, isLoading, error } = useQuery<AdminMetrics>({
    queryKey: ["admin", "metrics"],
    queryFn: adminApi.getMetrics,
  });

  const kpis: Kpi[] = [
    { label: "Restaurants", value: fmt(data?.totalRestaurants) },
    { label: "Menus parsed", value: fmt(data?.totalMenus) },
    { label: "Users", value: fmt(data?.totalUsers) },
    { label: "Dish catalog", value: fmt(data?.totalDishesInCatalog) },
    { label: "Curated dishes", value: fmt(data?.totalCuratedDishes) },
    {
      label: "LLM spend",
      value:
        data === undefined
          ? "—"
          : `$${data.totalLlmCostUsd.toFixed(2)}`,
    },
  ];

  return (
    <div>
      <PageHeader
        eyebrow="Overview · live data from Serverpod"
        title="Dashboard"
        sub="Real counts from the production DB. Activity log, charts — см. Phase C/D."
        kpis={isLoading ? undefined : kpis}
      />

      <div className="grid gap-4 p-8 md:grid-cols-2">
        {isLoading && (
          <>
            <Skeleton className="h-40 w-full rounded-[14px]" />
            <Skeleton className="h-40 w-full rounded-[14px]" />
          </>
        )}
        {error && (
          <Card className="border-red-300 bg-red-50/40 md:col-span-2">
            <CardHeader>
              <CardTitle className="text-red-700">Admin API error</CardTitle>
            </CardHeader>
            <CardContent className="font-mono text-xs text-red-800">
              {(error as Error).message}
              <div className="mt-3 text-brand-ink-2">
                Check that Serverpod is running with{" "}
                <code>ADMIN_DEV_BYPASS=true</code> and that{" "}
                <code>NEXT_PUBLIC_ADMIN_DEV_EMAIL</code> is set to an email
                present in the <code>admin_user</code> table.
              </div>
            </CardContent>
          </Card>
        )}

        {data && (
          <>
            <Card>
              <CardHeader>
                <CardTitle className="font-serif text-xl font-medium">
                  Queue snapshot
                </CardTitle>
              </CardHeader>
              <CardContent className="text-sm text-brand-ink-2">
                В Phase A список pending меню ещё не собирается. Queue / Menu
                validator экраны приедут в Phase D вместе с approval state
                machine (`moderationStatus`, `approvalStatus`).
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="font-serif text-xl font-medium">
                  Admin scope
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-2 text-sm text-brand-ink-2">
                <p>
                  Identity — через Cloudflare Access заголовок
                  `Cf-Access-Authenticated-User-Email`. В dev режиме
                  `ADMIN_DEV_BYPASS=true` принимает
                  `_adminEmail` query param.
                </p>
                <p className="font-mono text-[11px]">
                  POST /admin/&lt;method&gt; + JSON body
                </p>
              </CardContent>
            </Card>
          </>
        )}
      </div>
    </div>
  );
}

function fmt(n: number | undefined): string {
  if (n === undefined) return "—";
  return n.toLocaleString("en-US").replace(/,/g, " ");
}
