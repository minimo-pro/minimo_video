import copy from "./store-copy.json";

export function storeCopy(text: string, locale: string): string {
  const translations = copy as Record<string, Record<string, string>>;
  return translations[locale]?.[text] ?? translations.en[text] ?? text;
}
