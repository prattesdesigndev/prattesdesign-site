$ErrorActionPreference = 'Stop'
$cwebp = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Google.Libwebp_Microsoft.Winget.Source_8wekyb3d8bbwe\libwebp-1.6.0-windows-x64\bin\cwebp.exe"
$outDir = "C:\Users\Vinicius\Downloads\Site PD CLaude Code\assets\img"
$base = "C:\Users\Vinicius\Downloads\Site PD CLaude Code\ARTES ESTÁTICO - WINNER (PORTO)\ARTES ESTÁTICO - WINNER (PORTO)"

$jobs = @(
  # Posts quadrados - tabelas
  @{ in="$base\AUTO\ARTES LOW+HIGH TICKETS\Automóvel Post.png"; out="winner-auto-tabela.webp" },
  @{ in="$base\IMÓVEL\ARTES LOW+HIGH TICKETS\Imóvel Post.png"; out="winner-imovel-tabela.webp" },
  # Posts quadrados individuais - AUTO
  @{ in="$base\AUTO\ARTES INDIVIDUAIS\AUTO HIGH 200K.png"; out="winner-auto-200k.webp" },
  @{ in="$base\AUTO\ARTES INDIVIDUAIS\AUTO HIGH 102.500K.png"; out="winner-auto-102k.webp" },
  @{ in="$base\AUTO\ARTES INDIVIDUAIS\AUTO HIGH 62.500K.png"; out="winner-auto-62k.webp" },
  @{ in="$base\AUTO\ARTES INDIVIDUAIS\AUTO LOW 50K.png"; out="winner-auto-50k.webp" },
  # Posts quadrados individuais - IMÓVEL
  @{ in="$base\IMÓVEL\ARTES INDIVIDUAIS\IMOVEL HIGH 900K.png"; out="winner-imovel-900k.webp" },
  @{ in="$base\IMÓVEL\ARTES INDIVIDUAIS\IMOVEL HIGH 700K.png"; out="winner-imovel-700k.webp" },
  @{ in="$base\IMÓVEL\ARTES INDIVIDUAIS\IMOVEL HIGH 500K.png"; out="winner-imovel-500k.webp" },
  @{ in="$base\IMÓVEL\ARTES INDIVIDUAIS\IMOVEL LOW 300K.png"; out="winner-imovel-300k.webp" },
  # Stories verticais
  @{ in="$base\AUTO\ARTES LOW+HIGH TICKETS\Automóvel Story.png"; out="winner-auto-story.webp" },
  @{ in="$base\IMÓVEL\ARTES LOW+HIGH TICKETS\Imóvel Story.png"; out="winner-imovel-story.webp" },
  @{ in="$base\AUTO\TABELA DE VALORES\Story.png"; out="winner-auto-tabela-story.webp" },
  @{ in="$base\IMÓVEL\TABELA DE VALORES\Story.png"; out="winner-imovel-mega-story.webp" }
)

function Get-PngDims {
  param([string]$path)
  $fs = [System.IO.File]::OpenRead($path)
  try {
    $br = New-Object System.IO.BinaryReader $fs
    $null = $br.ReadBytes(16)
    $wBytes = $br.ReadBytes(4); $hBytes = $br.ReadBytes(4)
    [array]::Reverse($wBytes); [array]::Reverse($hBytes)
    return @{ width=[BitConverter]::ToInt32($wBytes, 0); height=[BitConverter]::ToInt32($hBytes, 0) }
  } finally { $fs.Close() }
}

foreach ($job in $jobs) {
  if (-not (Test-Path $job.in)) { Write-Warning "Missing: $($job.in)"; continue }
  $dims = Get-PngDims $job.in
  $outPath = Join-Path $outDir $job.out
  & $cwebp -q 82 -m 6 -quiet $job.in -o $outPath | Out-Null
  if ($LASTEXITCODE -ne 0 -or -not (Test-Path $outPath)) { Write-Warning "cwebp failed: $($job.out)"; continue }
  $newKB = [math]::Round((Get-Item $outPath).Length/1024, 1)
  "{0,-30} {1}x{2}  ->  {3}KB" -f $job.out, $dims.width, $dims.height, $newKB
}
