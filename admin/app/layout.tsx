import type { Metadata } from "next";
import { Inter, JetBrains_Mono, Fraunces } from "next/font/google";
import "./globals.css";
import { SideNav } from "@/components/side-nav";
import { InlineThemeScript } from "@/components/theme-toggle";
import { Providers } from "./providers";

const inter = Inter({
  variable: "--font-sans",
  subsets: ["latin", "cyrillic"],
  display: "swap",
});

const jetbrainsMono = JetBrains_Mono({
  variable: "--font-mono-next",
  subsets: ["latin"],
  display: "swap",
});

const fraunces = Fraunces({
  variable: "--font-serif-next",
  subsets: ["latin"],
  display: "swap",
  axes: ["opsz"],
});

export const metadata: Metadata = {
  title: "MenuAssistant Admin",
  description: "Moderation panel",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      data-theme="warm"
      className={`${inter.variable} ${jetbrainsMono.variable} ${fraunces.variable} h-full antialiased`}
    >
      <head>
        <InlineThemeScript />
      </head>
      <body className="min-h-full">
        <Providers>
          <div className="flex min-h-screen">
            <SideNav />
            <main className="flex-1 min-w-0">{children}</main>
          </div>
        </Providers>
      </body>
    </html>
  );
}
