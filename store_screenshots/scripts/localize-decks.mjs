// Fill existing decks without changing their composition.
import fs from "node:fs";
const copy = JSON.parse(fs.readFileSync(new URL("../src/lib/store-copy.json", import.meta.url)));
const locales = fs.readdirSync(new URL("../../lib/l10n/", import.meta.url))
  .filter((name) => /^intl_.+\.arb$/.test(name)).map((name) => name.slice(5, -4));
locales.sort((a, b) => a === "en" ? -1 : b === "en" ? 1 : a.localeCompare(b));
const file = new URL("../app-store-screenshots.json", import.meta.url);
const state = JSON.parse(fs.readFileSync(file));
function translate(field) {
  if (!field?.en) return field;
  for (const locale of locales) {
    const value = copy[locale]?.[field.en];
    if (!value) throw new Error(`Missing ${locale}: ${field.en}`);
    field[locale] = value;
  }
  return field;
}
for (const slides of Object.values(state.slidesByDevice)) {
  for (const slide of slides) {
    for (const key of ["label", "headline", "highlight"]) translate(slide[key]);
    for (const element of slide.textElements || []) translate(element.text);
    for (const element of slide.imageElements || []) {
      if (element.src === "/brand/compare.png") element.src = "/brand/compare-{locale}.png";
    }
  }
}
state.locales = locales;
fs.writeFileSync(file, JSON.stringify(state, null, 2) + "\n");
console.log(`Localized ${locales.length} locales: ${locales.join(", ")}`);
