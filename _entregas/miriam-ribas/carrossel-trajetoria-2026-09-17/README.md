# Carrossel Trajetória — "Como eu cheguei aqui"

Míriam Ribas · 55188 · Deputada Estadual · PSD — peça de 17/09/2026 (S2 · ADMIRAR · P3 Caráter).
7 cards em 1080×1350 (4:5) para o feed do Instagram.

Prancha de aprovação (cards, checklist e legenda): https://claude.ai/artifact/PkbwAgs6kbK9pMgNaNm1mj

## Arquivos finais

`miriam_trajetoria_01.png` … `miriam_trajetoria_07.png` — PNG, 1080×1350.

| Card | Conteúdo | Situação |
|---|---|---|
| 01 · Capa | Ninguém começa uma coisa dessas por causa de eleição. | ok (foto 01517) |
| 02 · Origem | Eu me formei em Direito e podia ter aberto escritório. Escolhi atender quem não tinha como pagar. | ok |
| 03 · Dificuldade | Trabalho voluntário não paga conta. Durante muitos anos… depois do meu próprio expediente. | **texto alternativo — validar com a Míriam** |
| 04 · Quase parar | Muita gente me disse pra fazer o que dava dinheiro. Eu continuei fazendo o que dava resultado. | **texto alternativo — validar com a Míriam** |
| 05 · O que virou | Trinta anos depois: 250 famílias · 150 no Viva Leite · 30 mães. Nada disso com verba pública. | **números — conferir com a Cinthia** |
| 06 · Virada | Eu percebi que dá pra resolver quase tudo — se a pessoa conhecer alguém. E quase ninguém conhece alguém. | ok |
| 07 · Fechamento | Por isso eu quero ir pro lugar onde a regra é feita. Míriam Ribas · 55188 | ok (foto 01474) |

Selo legal em todos os cards: ELEIÇÃO 2026 · ALMIRA SOARES RIBAS · DEPUTADO ESTADUAL · CNPJ 68.455.313/0001-78 · PSD.
Sem geração de imagem por IA (só recorte de fundo das fotos do ensaio), então o selo "Conteúdo criado com IA" não se aplica.

## Especificações

- Roxo #3F1C6C (amostrado do logotipo), amarelo #FFD23F, rosa #FE3EB5 (só no logo).
- Tipografia: Outfit 800/900 (títulos) e 600 (apoio). Substitui a fonte do manual, que não estava acessível na sessão.
- Fotos: ensaio 03_Finais — MiriamRibas-01517 (capa) e MiriamRibas-01474 (fechamento).
- Logo branco e dígitos 55188 recortados do PDF "Logotipos mirima ribas".

## Fonte (re-render)

A pasta `fonte/` é autocontida: `gen.py` gera `cards.html` a partir dos textos, `style.css` é o layout, `render.js` tira o print de cada card com Playwright/Chromium.

```bash
cd fonte
python3 gen.py          # gera cards.html
node render.js          # grava out/miriam_trajetoria_01..07.png
```

Requer Node com `playwright` instalado e um Chromium (ajustar `executablePath` em `render.js`).
Para trocar o texto dos cards 3 e 4 quando chegar o insumo real da Míriam, edite as strings em `gen.py` e re-renderize.
