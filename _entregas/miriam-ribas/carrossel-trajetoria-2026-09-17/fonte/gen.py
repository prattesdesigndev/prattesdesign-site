# Generates cards.html for the 7-card carousel
import html
LEGAL="ELEIÇÃO 2026 · ALMIRA SOARES RIBAS · DEPUTADO ESTADUAL · CNPJ 68.455.313/0001-78 · PSD"
cards=[]
def top(n, right_html=None):
    r = right_html if right_html is not None else f'<div class="pill">Como eu cheguei aqui · {n:02d}/07</div>'
    return f'<div class="top"><img class="logo" src="brand/logo_white_stack.png"><div>{r}</div></div>'
def legal(): return f'<div class="legal">{LEGAL}</div>'
def heart(cls=""): return f'<img class="bgheart {cls}" src="brand/heart_outline_white.png">'

# CARD 1 — capa
cards.append(f'''
<section class="card c1">
  {heart("h1")}
  <img class="photo" src="cuts/01517_clean.png">
  {top(1,'<div class="pill pill-y">ARRASTE <span class="arr">→</span></div>')}
  <div class="body b1">
    <div class="bar"></div>
    <h1 class="h hxl">Ninguém começa uma coisa dessas por causa de <em>eleição.</em></h1>
  </div>
  {legal()}
</section>''')

# CARD 2 — origem
cards.append(f'''
<section class="card">
  {heart("h2")}
  {top(2)}
  <div class="body">
    <div class="bar"></div>
    <h1 class="h">Eu me formei em Direito e podia ter aberto escritório.</h1>
    <p class="p">Escolhi atender <em>quem não tinha como pagar.</em></p>
  </div>
  {legal()}
</section>''')

# CARD 3 — dificuldade (alternativo)
cards.append(f'''
<section class="card">
  {heart("h3")}
  {top(3)}
  <div class="body">
    <div class="bar"></div>
    <h1 class="h">Trabalho voluntário <em>não paga conta.</em></h1>
    <p class="p">Durante muitos anos, o que eu fazia pelas famílias eu fazia depois do meu próprio expediente.</p>
  </div>
  {legal()}
</section>''')

# CARD 4 — quase parar (alternativo)
cards.append(f'''
<section class="card">
  {heart("h2")}
  {top(4)}
  <div class="body">
    <div class="bar"></div>
    <h1 class="h">Muita gente me disse pra fazer o que dava dinheiro.</h1>
    <p class="p">Eu continuei fazendo <em>o que dava resultado.</em></p>
  </div>
  {legal()}
</section>''')

# CARD 5 — o que virou
cards.append(f'''
<section class="card">
  {heart("h3")}
  {top(5)}
  <div class="body b5">
    <div class="bar"></div>
    <div class="eyebrow">Trinta anos depois:</div>
    <div class="stat"><div class="num">250</div><div class="lbl">famílias com orientação jurídica</div></div>
    <div class="stat"><div class="num">150</div><div class="lbl">pessoas no Viva Leite</div></div>
    <div class="stat"><div class="num">30</div><div class="lbl">mães em geração de renda</div></div>
    <div class="rule"></div>
    <p class="p p5">Nada disso com <em>verba pública.</em></p>
  </div>
  {legal()}
</section>''')

# CARD 6 — a virada
cards.append(f'''
<section class="card">
  {heart("h2")}
  {top(6)}
  <div class="body">
    <div class="bar"></div>
    <h1 class="h">Eu percebi que dá pra resolver quase tudo — <em>se a pessoa conhecer alguém.</em></h1>
    <p class="p">E quase ninguém conhece alguém.</p>
  </div>
  {legal()}
</section>''')

# CARD 7 — fechamento
cards.append(f'''
<section class="card c7">
  {heart("h7")}
  <img class="photo photo7" src="cuts/01474_clean.png">
  {top(7,'<div class="pill">Como eu cheguei aqui · 07/07</div>')}
  <div class="body b7">
    <div class="bar"></div>
    <h1 class="h">Por isso eu quero ir pro lugar <em>onde a regra é feita.</em></h1>
    <div class="sign">
      <img class="signlogo" src="brand/logo_white_stack.png">
      <img class="signnum" src="brand/digits_55188_yellow.png">
    </div>
  </div>
  {legal()}
</section>''')

css = open("style.css").read()
doc = f'''<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><title>Carrossel Trajetória — Míriam Ribas</title>
<link rel="stylesheet" href="fonts.css"><style>{css}</style></head><body>{"".join(cards)}</body></html>'''
open("cards.html","w").write(doc); print("cards.html ok", len(doc))
