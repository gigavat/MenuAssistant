"use client";

import { useSyncExternalStore } from "react";

type Theme = "warm" | "sage" | "midnight";

const STORAGE_KEY = "admin-theme";

function readTheme(): Theme {
  if (typeof document === "undefined") return "warm";
  const attr = document.documentElement.getAttribute("data-theme");
  if (attr === "sage" || attr === "midnight") return attr;
  return "warm";
}

function subscribe(cb: () => void): () => void {
  if (typeof document === "undefined") return () => {};
  const observer = new MutationObserver(cb);
  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ["data-theme"],
  });
  return () => observer.disconnect();
}

/**
 * Переключает `data-theme` на <html> циклом warm → sage → midnight.
 * Persistence — localStorage. Используем useSyncExternalStore чтобы
 * читать DOM как source-of-truth без setState-in-effect антипаттерна.
 * Первичная синхронизация с localStorage делается в <head> до hydration
 * через [InlineThemeScript].
 */
export function ThemeToggle() {
  const theme = useSyncExternalStore(
    subscribe,
    readTheme,
    () => "warm" as Theme,
  );

  const next = (t: Theme): Theme =>
    t === "warm" ? "sage" : t === "sage" ? "midnight" : "warm";

  const toggle = () => {
    const n = next(theme);
    document.documentElement.setAttribute("data-theme", n);
    try {
      localStorage.setItem(STORAGE_KEY, n);
    } catch {
      // приват-режим или отключённое хранилище — не фейлим UX.
    }
  };

  const glyph = theme === "warm" ? "☀" : theme === "sage" ? "❦" : "☾";

  return (
    <button
      onClick={toggle}
      title={`theme: ${theme} → click for next`}
      aria-label="toggle theme"
      className="flex h-[22px] w-[22px] shrink-0 items-center justify-center rounded-full border border-brand-line bg-brand-surface-2 text-[11px] text-brand-ink hover:bg-brand-line"
    >
      {glyph}
    </button>
  );
}

/**
 * Блокирующий script в <head>, выставляющий data-theme из localStorage
 * ДО того как React hydrate'ит страницу. Без этого user увидит flash
 * warm-темы даже если выбрал midnight.
 */
export function InlineThemeScript() {
  const js = `(function(){try{var t=localStorage.getItem('${STORAGE_KEY}');if(t==='sage'||t==='midnight'){document.documentElement.setAttribute('data-theme',t);}}catch(_){}})();`;
  return <script dangerouslySetInnerHTML={{ __html: js }} />;
}
