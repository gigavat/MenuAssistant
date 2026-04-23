import type { ReactNode } from "react";

export type Kpi = {
  label: string;
  value: string;
  delta?: string;
};

export function PageHeader({
  eyebrow,
  title,
  sub,
  actions,
  kpis,
}: {
  eyebrow?: string;
  title: string;
  sub?: string;
  actions?: ReactNode;
  kpis?: Kpi[];
}) {
  return (
    <div className="border-b border-brand-line px-8 pb-5 pt-7">
      <div className="flex items-start justify-between gap-6">
        <div className="min-w-0">
          {eyebrow && (
            <div className="font-mono text-[10px] uppercase tracking-[0.1em] text-brand-muted">
              {eyebrow}
            </div>
          )}
          <h1 className="mt-0.5 font-serif text-[32px] font-medium leading-tight -tracking-[0.02em]">
            {title}
          </h1>
          {sub && (
            <p className="mt-2 max-w-xl text-[13px] leading-relaxed text-brand-ink-2">
              {sub}
            </p>
          )}
        </div>
        {actions && <div className="flex shrink-0 gap-2">{actions}</div>}
      </div>
      {kpis && kpis.length > 0 && (
        <div
          className="mt-6 grid overflow-hidden rounded-[10px] border border-brand-line bg-brand-line"
          style={{
            gridTemplateColumns: `repeat(${kpis.length}, minmax(0, 1fr))`,
            gap: 1,
          }}
        >
          {kpis.map((k, i) => (
            <div key={i} className="bg-brand-bg px-4 py-3.5">
              <div className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
                {k.label}
              </div>
              <div className="mt-1 flex items-baseline gap-1.5">
                <span className="font-serif text-2xl font-medium">
                  {k.value}
                </span>
                {k.delta && (
                  <span
                    className={`font-mono text-[11px] ${deltaClass(k.delta)}`}
                  >
                    {k.delta}
                  </span>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function deltaClass(d: string): string {
  if (d.startsWith("+")) return "text-brand-ok";
  if (d.startsWith("-")) return "text-red-600";
  return "text-brand-muted";
}
