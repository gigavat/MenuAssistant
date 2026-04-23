"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { ThemeToggle } from "./theme-toggle";

type NavItem = {
  id: string;
  href: string;
  icon: string;
  label: string;
  count?: number;
  section?: string;
};

/**
 * NAV — порт из design/admin/app.jsx. Counts в handoff'е — mock-числа, в
 * production они будут tanstack-query'ем. Оставляем их пока в UI только
 * для экранов, которые реально реализованы (Phase B — только Dashboard,
 * Users, Restaurants; Moderation/Catalog/Logs станут enabled по мере
 * реализации экранов в Phase C/D).
 */
const NAV: NavItem[] = [
  { id: "dashboard", href: "/dashboard", icon: "◆", label: "Dashboard" },
  {
    id: "queue",
    href: "/queue",
    icon: "▤",
    label: "Queue",
    section: "Moderation",
  },
  { id: "validate", href: "/validate", icon: "▦", label: "Menu validator" },
  { id: "dishreview", href: "/dishes-review", icon: "✦", label: "Dish review" },
  { id: "photos", href: "/photos", icon: "▢", label: "Photo review" },
  {
    id: "translations",
    href: "/translations",
    icon: "A⇄",
    label: "Translations",
  },
  {
    id: "library",
    href: "/library",
    icon: "⌘",
    label: "Dish library",
    section: "Catalog",
  },
  { id: "restaurants", href: "/restaurants", icon: "◧", label: "Restaurants" },
  { id: "users", href: "/users", icon: "○", label: "Users", section: "Access" },
  { id: "logs", href: "/audit", icon: "⋯", label: "Audit log" },
];

export function SideNav() {
  const pathname = usePathname();

  return (
    <aside
      className="sticky top-0 flex h-screen w-[240px] shrink-0 flex-col border-r border-brand-line bg-brand-bg"
    >
      <div className="flex items-center gap-2.5 border-b border-brand-line px-[18px] py-4">
        <div
          className="flex h-[26px] w-[26px] items-center justify-center rounded-[7px] bg-brand-accent font-serif text-[16px] font-bold italic text-white"
        >
          M
        </div>
        <div className="flex flex-col leading-tight">
          <span className="font-serif text-[15px] font-semibold -tracking-[0.01em]">
            MenuAssistant
          </span>
          <span className="font-mono text-[10px] uppercase tracking-[0.1em] text-brand-muted">
            admin · v0.4
          </span>
        </div>
      </div>

      <nav className="flex-1 overflow-auto px-2 py-2.5">
        {NAV.map((n) => {
          const isActive =
            pathname === n.href || pathname?.startsWith(`${n.href}/`);
          return (
            <div key={n.id}>
              {n.section && (
                <div className="px-2.5 pb-1.5 pt-3.5 font-mono text-[10px] uppercase tracking-[0.1em] text-brand-muted">
                  {n.section}
                </div>
              )}
              <Link
                href={n.href}
                className={`mb-px flex items-center gap-2.5 rounded-[7px] px-2.5 py-[7px] text-[13px] transition-colors ${
                  isActive
                    ? "bg-brand-ink text-brand-bg"
                    : "text-brand-ink-2 hover:bg-brand-surface-2"
                }`}
              >
                <span className="w-4 text-center font-mono text-[12px] opacity-80">
                  {n.icon}
                </span>
                <span className="flex-1">{n.label}</span>
                {n.count !== undefined && (
                  <span
                    className={`rounded-full px-1.5 py-0.5 font-mono text-[10px] ${
                      isActive
                        ? "bg-white/15 text-brand-bg"
                        : "bg-brand-surface-2 text-brand-muted"
                    }`}
                  >
                    {n.count}
                  </span>
                )}
              </Link>
            </div>
          );
        })}
      </nav>

      <div className="flex items-center gap-2.5 border-t border-brand-line p-3">
        <div className="flex h-[30px] w-[30px] items-center justify-center rounded-lg bg-brand-accent-soft font-serif font-semibold italic text-brand-accent-ink">
          A
        </div>
        <div className="min-w-0 flex-1">
          <div className="text-[13px] font-medium">Andrey G.</div>
          <div className="truncate font-mono text-[10px] text-brand-muted">
            admin · ru
          </div>
        </div>
        <ThemeToggle />
      </div>
    </aside>
  );
}
