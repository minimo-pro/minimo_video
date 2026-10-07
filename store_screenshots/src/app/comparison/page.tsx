"use client";
// Localized comparison sticker, exported at /comparison?locale=ja.
import * as React from "react";
import { storeCopy } from "@/lib/store-copy";

export default function ComparisonPage() {
  const [locale, setLocale] = React.useState("en");
  React.useEffect(() => setLocale(new URLSearchParams(window.location.search).get("locale") || "en"), []);
  const pill: React.CSSProperties = { position: "absolute", top: 40, background: "rgba(0,0,0,.59)", color: "white", fontSize: 64, padding: "14px 32px", borderRadius: 999 };
  return <div style={{ position: "relative", width: 1600, height: 1200, overflow: "hidden", fontFamily: "Pangolin, system-ui, sans-serif" }}>
    <style>{"nextjs-portal{display:none!important} body{margin:0}"}</style>
    <img src="/photos/beach.jpg" alt="" style={{ width: "100%", height: "100%", objectFit: "cover", objectPosition: "center top" }} />
    <div style={{ position: "absolute", top: 0, bottom: 0, left: 796, width: 8, background: "white" }} />
    <div style={{ ...pill, left: 40 }}>{storeCopy("before", locale)} · 612 mb</div>
    <div style={{ ...pill, right: 40 }}>{storeCopy("after", locale)} · 153 mb</div>
    <div style={{ position: "absolute", left: 708, top: 508, width: 184, height: 184, borderRadius: "50%", border: "8px solid white", background: "#FC3636", color: "white", fontSize: 92, display: "grid", placeItems: "center" }}>VS</div>
  </div>;
}
