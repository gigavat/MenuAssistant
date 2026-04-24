"use client";

import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { PageHeader } from "@/components/page-header";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
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
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { adminApi, type TranslationRow } from "@/lib/api";

const LANGS = ["ru", "pt", "es", "it", "fr", "de"] as const;

export default function TranslationsPage() {
  const [lang, setLang] = useState<string>("ru");
  const [search, setSearch] = useState("");
  const [editing, setEditing] = useState<TranslationRow | null>(null);

  const { data, isLoading, error } = useQuery({
    queryKey: ["admin", "translations", lang, search],
    queryFn: () =>
      adminApi.listTranslations({
        language: lang,
        search: search || null,
        limit: 200,
      }),
  });

  return (
    <div>
      <PageHeader
        eyebrow={`Localization · ${LANGS.length} target languages`}
        title="Translations"
        sub="Claude-сгенерированные переводы. Click row → manual override (source='manual')."
      />

      <div className="p-8">
        <div className="mb-4 flex flex-wrap items-center gap-3">
          <Input
            placeholder="Search by EN or translated name…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="max-w-sm"
          />
          <Select value={lang} onValueChange={setLang}>
            <SelectTrigger className="w-28 font-mono">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {LANGS.map((l) => (
                <SelectItem key={l} value={l} className="font-mono">
                  {l.toUpperCase()}
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
                <TableHead>Dish (EN)</TableHead>
                <TableHead>Translated name</TableHead>
                <TableHead>Source</TableHead>
                <TableHead className="text-right">Status</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading &&
                [0, 1, 2, 3, 4].map((i) => (
                  <TableRow key={i}>
                    <TableCell colSpan={4}>
                      <Skeleton className="h-5 w-full" />
                    </TableCell>
                  </TableRow>
                ))}
              {error && (
                <TableRow>
                  <TableCell colSpan={4} className="text-red-700">
                    Admin API error: {(error as Error).message}
                  </TableCell>
                </TableRow>
              )}
              {data?.map((t) => (
                <TableRow
                  key={`${t.curatedDishId}-${t.language}`}
                  className="cursor-pointer"
                  onClick={() => setEditing(t)}
                >
                  <TableCell className="font-medium">
                    {t.dishDisplayName}
                  </TableCell>
                  <TableCell>
                    {t.name ?? (
                      <span className="italic text-brand-muted">
                        (missing)
                      </span>
                    )}
                  </TableCell>
                  <TableCell>
                    {t.source === "manual" ? (
                      <Badge className="bg-brand-accent-soft font-mono text-[10px] text-brand-accent-ink">
                        manual
                      </Badge>
                    ) : t.source === "claude_auto" ? (
                      <Badge
                        variant="secondary"
                        className="font-mono text-[10px]"
                      >
                        claude
                      </Badge>
                    ) : (
                      <span className="text-brand-muted">—</span>
                    )}
                  </TableCell>
                  <TableCell className="text-right font-mono text-[11px] text-brand-muted">
                    {t.translationId ? `#${t.translationId}` : "new"}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </div>

      <EditSheet row={editing} onClose={() => setEditing(null)} />
    </div>
  );
}

function EditSheet({
  row,
  onClose,
}: {
  row: TranslationRow | null;
  onClose: () => void;
}) {
  const qc = useQueryClient();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");

  if (row && name === "" && description === "") {
    setName(row.name ?? "");
    setDescription(row.description ?? "");
  }

  const save = useMutation({
    mutationFn: async () => {
      if (!row) throw new Error("no row");
      return adminApi.upsertTranslation({
        curatedDishId: row.curatedDishId,
        language: row.language,
        name,
        description,
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin", "translations"] });
      qc.invalidateQueries({ queryKey: ["admin", "audit"] });
      setName("");
      setDescription("");
      onClose();
    },
  });

  return (
    <Sheet
      open={row != null}
      onOpenChange={(o) => {
        if (!o) {
          setName("");
          setDescription("");
          onClose();
        }
      }}
    >
      <SheetContent className="w-[480px] p-0 sm:max-w-lg">
        <SheetHeader className="px-6 pt-6">
          <SheetTitle className="font-serif text-2xl font-medium">
            {row?.dishDisplayName}
          </SheetTitle>
          <SheetDescription className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
            translation · {row?.language?.toUpperCase()} · curated_dish #
            {row?.curatedDishId}
          </SheetDescription>
        </SheetHeader>

        <div className="space-y-4 px-6 py-5">
          <div className="space-y-1.5">
            <Label className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
              Name ({row?.language?.toUpperCase()})
            </Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} />
          </div>
          <div className="space-y-1.5">
            <Label className="font-mono text-[10px] uppercase tracking-[0.08em] text-brand-muted">
              Description ({row?.language?.toUpperCase()})
            </Label>
            <Textarea
              rows={8}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
            />
          </div>
          {save.error && (
            <div className="rounded-md border border-red-300 bg-red-50 p-3 text-xs text-red-800">
              {(save.error as Error).message}
            </div>
          )}
        </div>

        <SheetFooter className="border-t border-brand-line px-6 py-4">
          <Button variant="ghost" onClick={onClose} disabled={save.isPending}>
            Cancel
          </Button>
          <Button
            onClick={() => save.mutate()}
            disabled={save.isPending || !name.trim()}
            className="bg-brand-ink text-brand-bg hover:bg-brand-ink-2"
          >
            {save.isPending ? "Saving…" : "Save manual override"}
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}
