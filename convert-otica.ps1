$ErrorActionPreference = 'Stop'
$cwebp = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Google.Libwebp_Microsoft.Winget.Source_8wekyb3d8bbwe\libwebp-1.6.0-windows-x64\bin\cwebp.exe"
$outDir = "C:\Users\Vinicius\Downloads\Site PD CLaude Code\assets\img"

$src = "C:\Users\Vinicius\Downloads\Ótica Marília-20250820T225337Z-1-001\Ótica Marília\09. Mockups"

# Mapping: source file -> output name (semantic)
$jobs = @(
  @{ in="$src\MKP 4\MKP 4.png"; out="otica-marilia-fachada.webp" },
  @{ in="$src\MKP 5\MKP 5.png"; out="otica-marilia-estojo.webp" },
  @{ in="$src\MKP 6\MKP 6.png"; out="otica-marilia-sacolas.webp" },
  @{ in="$src\MKP 8\MKP 8.png"; out="otica-marilia-uniforme.webp" }
)

function Get-PngDims {
  param([string]$path)
  $fs = [System.IO.File]::OpenRead($path)
  try {
    $br = New-Object System.IO.BinaryReader $fs
    $null = $br.ReadBytes(16)  # skip signature + IHDR length + IHDR type
    $wBytes = $br.ReadBytes(4)
    $hBytes = $br.ReadBytes(4)
    [array]::Reverse($wBytes)
    [array]::Reverse($hBytes)
    return @{ width=[BitConverter]::ToInt32($wBytes, 0); height=[BitConverter]::ToInt32($hBytes, 0) }
  } finally { $fs.Close() }
}

foreach ($job in $jobs) {
  if (-not (Test-Path $job.in)) { Write-Warning "Missing: $($job.in)"; continue }
  $dims = Get-PngDims $job.in
  $outPath = Join-Path $outDir $job.out
  & $cwebp -q 82 -m 6 -quiet $job.in -o $outPath 2>&1 | Out-Null
  if ($LASTEXITCODE -ne 0 -or -not (Test-Path $outPath)) {
    Write-Warning "cwebp failed: $($job.out)"
    continue
  }
  $origKB = [math]::Round((Get-Item $job.in).Length/1024, 1)
  $newKB  = [math]::Round((Get-Item $outPath).Length/1024, 1)
  "{0,-32} {1}x{2}  {3}KB -> {4}KB" -f $job.out, $dims.width, $dims.height, $origKB, $newKB
}
