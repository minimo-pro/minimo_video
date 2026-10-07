// Seeds app-store-screenshots.json with the minimo decks.
//   node scripts/seed-deck.mjs                       (all decks)
//   node scripts/seed-deck.mjs iphone android        (only these decks)
// Re-seeding a deck overwrites edits made to it in the editor.
import fs from "node:fs";

const CANVAS = {
  iphone: { w: 1320, h: 2868, aspect: 1022 / 2082, shots: "/screenshots/apple/iphone/{locale}" },
  ipad: { w: 2064, h: 2752, aspect: 0.77, shots: "/screenshots/apple/ipad/{locale}" },
  android: { w: 1080, h: 1920, aspect: 9 / 19.5, shots: "/screenshots/android/phone/{locale}" },
};

const en = (text) => ({ en: text });
let seq = 0;
const id = (p) => `${p}_${++seq}`;

function deck(device) {
  const c = CANVAS[device];
  const { w: W, h: H } = c;
  const tablet = device === "ipad";
  const u = Math.min(W, H);
  const shot = (name) => `${c.shots}/${name}.png`;

  // Device width as fraction of canvas width; height follows frame aspect.
  const dev = (x, y, wf, rotation = 0) => {
    const width = W * wf;
    return { x: W * x, y: H * y, width, height: width / c.aspect, rotation, zIndex: 3 };
  };
  const centered = (y, wf, rotation = 0) => dev((1 - wf) / 2, y, wf, rotation);
  // Keeps the whole screen visible, for sheets anchored to the bottom.
  const bottom = (wf, margin = 0.025) => centered(1 - margin - (W * wf) / c.aspect / H, wf);
  const caption = (y, h = 0.2) => ({ x: W * 0.06, y: H * y, width: W * 0.88, height: H * h, rotation: 0, zIndex: 6 });

  const phoneW = { iphone: 0.78, ipad: 0.7, android: 0.64 }[device];
  const top = 0.25;
  const heroW = { iphone: 0.86, ipad: 0.8, android: 0.74 }[device];

  const chip = (text, x, y, opts = {}) => ({
    id: id("t"),
    text: en(text),
    fontSize: Math.round(u * (opts.size ?? 0.05)),
    color: opts.color ?? "#FFFFFF",
    background: opts.bg ?? "#FC3636",
    align: "center",
    transform: {
      x: W * x,
      y: H * y,
      width: W * (opts.w ?? 0.4),
      height: u * (opts.size ?? 0.05) * 2.2,
      rotation: opts.rotation ?? 0,
      zIndex: opts.z ?? 8,
    },
  });
  const sticker = (src, x, y, wf, opts = {}) => {
    const width = W * wf;
    return {
      id: id("i"),
      src,
      radius: Math.round(width * (opts.radius ?? 0.08)),
      border: opts.border ?? Math.round(width * 0.035),
      shadow: true,
      fit: "cover",
      transform: {
        x: W * x,
        y: H * y,
        width,
        height: width * (opts.ratio ?? 0.75),
        rotation: opts.rotation ?? 0,
        zIndex: opts.z ?? 7,
      },
    };
  };

  const slides = [];

  // 1. Hero — the main benefit.
  slides.push({
    id: id("s"),
    layout: "hero",
    label: en("free · no ads · no subscription"),
    headline: en("make your videos\nsmaller"),
    highlight: en("smaller"),
    screenshot: shot("01-settings"),
    transforms: { caption: caption(0.055), device: centered(top, heroW, 0) },
    textElements: [chip("−75%", tablet ? 0.68 : 0.62, tablet ? 0.3 : 0.29, { w: 0.34, size: 0.075, rotation: 8 })],
    imageElements: [
      sticker("/photos/dog.jpg", tablet ? 0.02 : -0.04, 0.38, tablet ? 0.22 : 0.3, { rotation: -9 }),
    ],
  });

  // 2. Differentiator — quality stays.
  slides.push({
    id: id("s"),
    layout: "device-bottom",
    label: en("before & after"),
    headline: en("same moments,\nsmaller files"),
    highlight: en("smaller files"),
    screenshot: shot("04-result"),
    transforms: { caption: caption(0.055), device: centered(tablet ? 0.42 : 0.44, phoneW * 0.92) },
    imageElements: [
      {
        ...sticker("/brand/compare.png", tablet ? 0.1 : 0.04, device === "android" ? 0.235 : 0.215, tablet ? 0.8 : 0.92, {
          rotation: -3,
          radius: 0.05,
          border: Math.round(W * 0.018),
          z: 9,
        }),
      },
    ],
  });

  // 3. Batch.
  slides.push({
    id: id("s"),
    layout: "device-top",
    label: en("batch compression"),
    headline: en("shrink them\nall at once"),
    highlight: en("all at once"),
    screenshot: shot("03-progress"),
    transforms: { device: centered(-0.13, phoneW), caption: caption(tablet ? 0.79 : 0.775) },
    imageElements: [
      sticker("/photos/birthday.jpg", tablet ? 0.03 : -0.05, 0.5, tablet ? 0.24 : 0.32, { rotation: -8 }),
      sticker("/photos/mountains.jpg", tablet ? 0.73 : 0.72, 0.56, tablet ? 0.24 : 0.32, { rotation: 7 }),
    ],
  });

  // 4. Privacy — inverted dusk sky.
  slides.push({
    id: id("s"),
    layout: "device-bottom",
    inverted: true,
    label: en("100% on-device"),
    headline: en("your videos\nnever leave\nyour phone"),
    highlight: en("never leave"),
    screenshot: shot("09-result-dark"),
    transforms: { caption: caption(0.055, 0.28), device: centered(tablet ? 0.47 : 0.5, phoneW * 0.9) },
    textElements: [
      chip("no cloud", tablet ? 0.06 : 0.0, tablet ? 0.42 : 0.42, { w: 0.36, size: 0.045, rotation: -6, bg: "rgba(255,255,255,0.92)", color: "#272727" }),
      chip("no account", tablet ? 0.6 : 0.6, tablet ? 0.44 : 0.445, { w: 0.4, size: 0.045, rotation: 5, bg: "rgba(255,255,255,0.92)", color: "#272727" }),
    ],
  });

  // 5. Advanced controls.
  slides.push({
    id: id("s"),
    layout: "device-bottom",
    label: en("advanced mode"),
    headline: en("fine-tune\nevery detail"),
    highlight: en("every detail"),
    screenshot: shot("02-advanced"),
    transforms: { caption: caption(0.055), device: dev(tablet ? 0.12 : 0.06, top + 0.02, phoneW, -4) },
    textElements: [
      chip("HEVC", tablet ? 0.74 : 0.68, 0.36, { w: 0.28, size: 0.05, rotation: 8 }),
      chip("up to 20 Mbps", tablet ? 0.62 : 0.5, 0.5, { w: 0.48, size: 0.042, rotation: -5, bg: "#FFFFFF", color: "#272727" }),
      chip("60 · 30 · 24 fps", tablet ? 0.6 : 0.48, 0.64, { w: 0.5, size: 0.042, rotation: 4, bg: "#FFFFFF", color: "#272727" }),
    ],
  });

  // 6. Feature wall.
  const features =
    device === "android"
      ? ["batch compression", "before & after", "H.264 + HEVC", "share sheet import", "keeps your quality", "13 languages", "dark mode", "open source"]
      : ["batch compression", "before & after", "H.264 + HEVC", "Shortcuts & share sheet", "keeps date & location", "13 languages", "dark mode", "open source"];
  slides.push({
    id: id("s"),
    layout: "no-device",
    label: en("simple · private · free"),
    headline: en("everything you\nneed. nothing\nyou don't"),
    highlight: en("nothing"),
    screenshot: "",
    transforms: { caption: caption(0.07, 0.3) },
    textElements: features.map((f, i) =>
      chip(f, i % 2 ? 0.46 : 0.04, 0.4 + Math.floor(i / 2) * (tablet ? 0.085 : 0.075), {
        w: 0.5,
        size: tablet ? 0.036 : 0.04,
        rotation: [-4, 3, 2, -3, -2, 4, 3, -4][i],
        bg: i === 0 || i === 5 ? "#FC3636" : "#FFFFFF",
        color: i === 0 || i === 5 ? "#FFFFFF" : "#272727",
      }),
    ),
    imageElements: [
      { ...sticker("/app-icon.png", 0.36, tablet ? 0.79 : 0.76, 0.28, { ratio: 1, radius: 0.22, border: 0, rotation: -6 }) },
    ],
  });

  return slides;
}

const only = process.argv.slice(2);
const file = new URL("../app-store-screenshots.json", import.meta.url);

if (only.length) {
  const saved = JSON.parse(fs.readFileSync(file, "utf8"));
  for (const device of only) saved.slidesByDevice[device] = deck(device);
  fs.writeFileSync(file, JSON.stringify(saved, null, 2) + "\n");
  console.log("seeded", Object.fromEntries(only.map((d) => [d, saved.slidesByDevice[d].length])));
  process.exit(0);
}

const state = {
  schemaVersion: 2,
  appName: "minimo (video)",
  themeId: "minimo-sky",
  connectedCanvas: false,
  locales: ["en"],
  locale: "en",
  device: "iphone",
  orientation: "portrait",
  appIcon: "/app-icon.png",
  slidesByDevice: {
    iphone: deck("iphone"),
    ipad: deck("ipad"),
    android: deck("android"),
    "android-7": [],
    "android-10": [],
    "feature-graphic": [
      {
        id: id("s"),
        layout: "feature-graphic",
        label: en(""),
        headline: en("make videos smaller.\nno cloud. no subscription."),
        screenshot: "",
        background: "/brand/sky-square.png",
      },
    ],
  },
};

fs.writeFileSync(file, JSON.stringify(state, null, 2) + "\n");
console.log("seeded", Object.fromEntries(Object.entries(state.slidesByDevice).map(([k, v]) => [k, v.length])));
