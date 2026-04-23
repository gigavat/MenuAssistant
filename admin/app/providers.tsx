"use client";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { useState } from "react";

/**
 * TanStack Query wraps всё admin UI. Клиент создаётся в useState чтобы
 * не пересоздаваться на ре-рендер (страница может дернуть провайдер).
 * Всё read-only в MVP — большой staleTime приемлем, список ресторанов
 * меняется редко; мутации Phase C/D сами вызовут invalidate.
 */
export function Providers({ children }: { children: React.ReactNode }) {
  const [client] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 30_000,
            refetchOnWindowFocus: false,
            retry: 1,
          },
        },
      }),
  );
  return <QueryClientProvider client={client}>{children}</QueryClientProvider>;
}
