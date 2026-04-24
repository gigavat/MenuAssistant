import { redirect } from "next/navigation";

/**
 * `/validate` без id — редиректим обратно в queue, где admin выбирает
 * конкретный ресторан. Standalone landing для validator'а не нужен.
 */
export default function ValidateIndex() {
  redirect("/queue");
}
