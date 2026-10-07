"""Export localized decks and banners using installed Chrome.
Requires: python3 -m pip install playwright Pillow
"""
import argparse
import asyncio
import json
import os
from pathlib import Path
from PIL import Image
from playwright.async_api import async_playwright

ROOT = Path(__file__).resolve().parents[1]
DECKS = [('iphone', 1320, 2868, 'apple/iphone-6.9'),
         ('ipad', 2064, 2752, 'apple/ipad-13'),
         ('android', 1080, 1920, 'android/phone')]
BANNERS = [('header', 3840, 1646, 'apple/header'),
           ('search', 3840, 2560, 'apple/search-results'),
           ('play', 1024, 500, 'android/feature-graphic')]


def jobs(state, locales):
    for locale in locales:
        for device, w, h, folder in DECKS:
            for index, _ in enumerate(state['slidesByDevice'][device]):
                yield (f'/preview?device={device}&locale={locale}&bare&from={index}&n=1',
                       w, h, ROOT / 'export' / folder / (locale if locale != 'en' else '') / f'{index+1:02d}.png')
        for kind, w, h, folder in BANNERS:
            yield (f'/creative?kind={kind}&locale={locale}',
                   w, h, ROOT / 'export' / folder / (locale if locale != 'en' else '') / '01.png')


def check(state, locales):
    count = 0
    for _, w, h, path in jobs(state, locales):
        with Image.open(path) as image:
            assert image.size == (w, h), (path, image.size)
            assert image.mode == 'RGB', (path, image.mode)
            assert any(lo != hi for lo, hi in image.getextrema()), f'Blank PNG: {path}'
        count += 1
    print(f'Checked {count} PNGs: dimensions, RGB, nonblank', flush=True)


async def export(state, locales, base):
    semaphore = asyncio.Semaphore(3)
    async with async_playwright() as playwright:
        browser = await playwright.chromium.launch(
            executable_path=os.environ.get('CHROME', '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'),
            headless=True)

        async def render(job):
            url, w, h, path = job
            async with semaphore:
                page = await browser.new_page(viewport={'width': w, 'height': h}, device_scale_factor=1)
                errors = []
                page.on('pageerror', lambda error: errors.append(str(error)))
                try:
                    await page.goto(base + url, wait_until='networkidle')
                    await page.evaluate('document.fonts.ready')
                    await page.wait_for_function('''() => {
                        const images = [...document.images];
                        return images.length > 0 && images.every(img => img.complete && img.naturalWidth > 0);
                    }''')
                    assert not errors, (url, errors)
                    overflow = await page.evaluate("""() => [...document.querySelectorAll('[data-fit-text]')].flatMap(el => {
                        const bounds = el.getBoundingClientRect();
                        const range = document.createRange();
                        range.selectNodeContents(el);
                        return [...range.getClientRects()].some(r => r.left < bounds.left - 2 || r.right > bounds.right + 2)
                            ? [el.innerText] : [];
                    })""")
                    assert not overflow, (url, 'Text overflow', overflow)
                    path.parent.mkdir(parents=True, exist_ok=True)
                    await page.screenshot(path=str(path), animations='disabled')
                    with Image.open(path) as image:
                        image.convert('RGB').save(path)
                    print(path.relative_to(ROOT), flush=True)
                finally:
                    await page.close()

        try:
            # The comparison PNGs must exist before rendering the decks.
            await asyncio.gather(*(render((f'/comparison?locale={locale}', 1600, 1200,
                ROOT / 'public/brand' / f'compare-{locale}.png')) for locale in locales))
            await asyncio.gather(*(render(job) for job in jobs(state, locales)))
        finally:
            await browser.close()
    check(state, locales)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--locales', nargs='+', help='Default: every project locale')
    parser.add_argument('--check', action='store_true', help='Validate existing exports only')
    args = parser.parse_args()
    state = json.loads((ROOT / 'app-store-screenshots.json').read_text())
    locales = args.locales or state['locales']
    assert all(locale in state['locales'] for locale in locales), 'Unknown locale'
    if args.check:
        check(state, locales)
    else:
        asyncio.run(export(state, locales, os.environ.get('BASE', 'http://localhost:3001')))
