const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const path = require('path');
(async () => {
  const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium' });
  const page = await browser.newPage({ viewport: { width: 1080, height: 1350 }, deviceScaleFactor: 1 });
  await page.goto('file://' + path.resolve(__dirname, 'cards.html'));
  await page.evaluate(() => document.fonts.ready);
  await page.waitForTimeout(400);
  const fonts = await page.evaluate(() => Array.from(document.fonts).filter(f=>f.status==='loaded').map(f=>f.family+' '+f.weight));
  console.log('fonts loaded:', [...new Set(fonts)].join(', '));
  const cards = await page.$$('.card');
  for (let i = 0; i < cards.length; i++) {
    await cards[i].screenshot({ path: path.resolve(__dirname, 'out', `miriam_trajetoria_${String(i+1).padStart(2,'0')}.png`) });
  }
  await browser.close(); console.log('rendered', cards.length);
})().catch(e => { console.error(e); process.exit(1); });
