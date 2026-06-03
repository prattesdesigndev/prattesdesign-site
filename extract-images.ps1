param(
  [string]$HtmlPath = "C:\Users\Vinicius\Downloads\Site PD CLaude Code\index_111.html",
  [string]$OutDir   = "C:\Users\Vinicius\Downloads\Site PD CLaude Code\assets\img",
  [string]$Cwebp    = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Google.Libwebp_Microsoft.Winget.Source_8wekyb3d8bbwe\libwebp-1.6.0-windows-x64\bin\cwebp.exe"
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

function Get-RasterDims {
  param([byte[]]$b, [string]$fmt)
  try {
    if ($fmt -eq 'png') {
      $w = ([int]$b[16] -shl 24) -bor ([int]$b[17] -shl 16) -bor ([int]$b[18] -shl 8) -bor [int]$b[19]
      $h = ([int]$b[20] -shl 24) -bor ([int]$b[21] -shl 16) -bor ([int]$b[22] -shl 8) -bor [int]$b[23]
      return @{ width=$w; height=$h }
    }
    if ($fmt -eq 'jpeg' -or $fmt -eq 'jpg') {
      $i = 2
      while ($i -lt $b.Length - 9) {
        if ($b[$i] -ne 0xFF) { $i++; continue }
        $m = $b[$i+1]
        # SOFn markers (0xC0..0xCF) except 0xC4 DHT, 0xC8 JPG, 0xCC DAC
        if ($m -ge 0xC0 -and $m -le 0xCF -and $m -ne 0xC4 -and $m -ne 0xC8 -and $m -ne 0xCC) {
          $h = ([int]$b[$i+5] -shl 8) -bor [int]$b[$i+6]
          $w = ([int]$b[$i+7] -shl 8) -bor [int]$b[$i+8]
          return @{ width=$w; height=$h }
        }
        if ($m -eq 0xD8 -or $m -eq 0xD9 -or ($m -ge 0xD0 -and $m -le 0xD7)) { $i += 2; continue }
        $segLen = ([int]$b[$i+2] -shl 8) -bor [int]$b[$i+3]
        if ($segLen -lt 2) { return @{ width=0; height=0 } }
        $i = $i + 2 + $segLen
      }
      return @{ width=0; height=0 }
    }
    if ($fmt -eq 'webp') {
      $sig = [System.Text.Encoding]::ASCII.GetString($b, 12, 4)
      if ($sig -eq 'VP8 ') {
        $w = (([int]$b[26]) -bor ([int]$b[27] -shl 8)) -band 0x3FFF
        $h = (([int]$b[28]) -bor ([int]$b[29] -shl 8)) -band 0x3FFF
        return @{ width=$w; height=$h }
      } elseif ($sig -eq 'VP8L') {
        $b1=[int]$b[21]; $b2=[int]$b[22]; $b3=[int]$b[23]; $b4=[int]$b[24]
        $w = ((($b2 -band 0x3F) -shl 8) -bor $b1) + 1
        $h = ((($b4 -band 0x0F) -shl 10) -bor ($b3 -shl 2) -bor (($b2 -shr 6) -band 0x03)) + 1
        return @{ width=$w; height=$h }
      } elseif ($sig -eq 'VP8X') {
        $w = ((([int]$b[24]) -bor ([int]$b[25] -shl 8) -bor ([int]$b[26] -shl 16)) + 1)
        $h = ((([int]$b[27]) -bor ([int]$b[28] -shl 8) -bor ([int]$b[29] -shl 16)) + 1)
        return @{ width=$w; height=$h }
      }
      return @{ width=0; height=0 }
    }
  } catch {
    return @{ width=0; height=0 }
  }
  return @{ width=0; height=0 }
}

function Get-SvgDims {
  param([string]$svg)
  $m = [regex]::Match($svg, 'viewBox\s*=\s*"\s*[\d.\-]+\s+[\d.\-]+\s+([\d.]+)\s+([\d.]+)\s*"')
  if ($m.Success) { return @{ width=[int][math]::Round([double]$m.Groups[1].Value); height=[int][math]::Round([double]$m.Groups[2].Value) } }
  $mw = [regex]::Match($svg, '\bwidth\s*=\s*"([\d.]+)"')
  $mh = [regex]::Match($svg, '\bheight\s*=\s*"([\d.]+)"')
  if ($mw.Success -and $mh.Success) {
    return @{ width=[int][math]::Round([double]$mw.Groups[1].Value); height=[int][math]::Round([double]$mh.Groups[1].Value) }
  }
  return @{ width=0; height=0 }
}

# ---------- Map: line number -> semantic name ----------
# Based on analysis:
#   2844-2920 -> hero gallery (22 JPEGs)
#   2941-2952 -> scrolly carousels (5 JPEGs)
#   2969       -> pain curiosity (WebP)
#   3017,3032,3047 -> service icons (3 SVGs)
#   3105,3119,3133,3147 -> case covers (4 SVGs)

$nameMap = @{}

# Hero gallery
$heroLines = @(2844,2847,2850,2853,2856,2859,2864,2867,2870,2873,2876,2879,2891,2894,2897,2900,2903,2908,2911,2914,2917,2920)
for ($i = 0; $i -lt $heroLines.Count; $i++) {
  $nameMap[[int]$heroLines[$i]] = ('gallery-{0:D2}' -f ($i + 1))
}

# Scrolly carousels
$scrollyLines = @(2941,2942,2943,2951,2952)
for ($i = 0; $i -lt $scrollyLines.Count; $i++) {
  $nameMap[[int]$scrollyLines[$i]] = ('scrolly-{0:D2}' -f ($i + 1))
}

# Pain curiosity
$nameMap[2969] = 'pain-curiosity'

# Service icons
$serviceLines = @(3017,3032,3047)
$serviceNames = @('service-branding','service-social','service-audiovisual')
for ($i = 0; $i -lt $serviceLines.Count; $i++) {
  $nameMap[[int]$serviceLines[$i]] = $serviceNames[$i]
}

# Case covers
$caseLines = @(3105,3119,3133,3147)
for ($i = 0; $i -lt $caseLines.Count; $i++) {
  $nameMap[[int]$caseLines[$i]] = ('case-{0:D2}' -f ($i + 1))
}

# ---------- Read HTML line by line ----------
$lines = [System.IO.File]::ReadAllLines($HtmlPath, [System.Text.UTF8Encoding]::new($false))
Write-Host "Read $($lines.Length) lines from $HtmlPath"

$tmpDir = Join-Path $env:TEMP "pd-extract-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $tmpDir | Out-Null

$report = @()

foreach ($lineNum in ($nameMap.Keys | Sort-Object)) {
  $idx = $lineNum - 1
  $line = $lines[$idx]
  $name = $nameMap[$lineNum]

  # Match data:image URI inside src=""
  $m = [regex]::Match($line, 'src\s*=\s*"data:image/(?<fmt>jpeg|jpg|png|webp|svg\+xml);base64,(?<data>[^"]+)"')
  if (-not $m.Success) {
    Write-Warning "Line $lineNum ($name): no data URI found"
    continue
  }

  $fmt = $m.Groups['fmt'].Value.ToLower()
  $data = $m.Groups['data'].Value

  $bytes = [System.Convert]::FromBase64String($data)

  if ($fmt -eq 'svg+xml') {
    $svgText = [System.Text.Encoding]::UTF8.GetString($bytes)
    $dims = Get-SvgDims $svgText
    $outPath = Join-Path $OutDir "$name.svg"
    [System.IO.File]::WriteAllText($outPath, $svgText, [System.Text.UTF8Encoding]::new($false))
    $relPath = "assets/img/$name.svg"

    $newLine = $line -replace [regex]::Escape($m.Value), ('src="' + $relPath + '" width="' + $dims.width + '" height="' + $dims.height + '" loading="lazy" decoding="async"')
    $lines[$idx] = $newLine

    $report += [pscustomobject]@{
      Line=$lineNum; Name=$name; Format='svg'; Width=$dims.width; Height=$dims.height;
      OriginalKB=[math]::Round($data.Length/1024,1); NewKB=[math]::Round((Get-Item $outPath).Length/1024,1);
      Path=$relPath
    }
    Write-Host ("Line {0}: {1}.svg ({2}x{3})" -f $lineNum, $name, $dims.width, $dims.height)
  } else {
    # Raster: write original, get dims, convert to webp via cwebp
    $origExt = if ($fmt -eq 'jpg') { 'jpeg' } else { $fmt }
    $tmpFile = Join-Path $tmpDir ("$name.$origExt")
    [System.IO.File]::WriteAllBytes($tmpFile, $bytes)

    $dims = Get-RasterDims $bytes $origExt

    if ($origExt -eq 'webp') {
      # Already WebP: just copy to final location
      $outPath = Join-Path $OutDir "$name.webp"
      Copy-Item $tmpFile $outPath -Force
    } else {
      # Convert via cwebp
      $outPath = Join-Path $OutDir "$name.webp"
      # Quality 82 = sweet spot for photographic content (similar visual to JPEG 85, ~30% smaller)
      $cwebpArgs = @('-q', '82', '-m', '6', '-quiet', $tmpFile, '-o', $outPath)
      & $Cwebp @cwebpArgs 2>&1 | Out-Null
      if ($LASTEXITCODE -ne 0 -or -not (Test-Path $outPath)) {
        Write-Warning "cwebp failed for $name (line $lineNum)"
        continue
      }
    }

    $relPath = "assets/img/$name.webp"
    $newLine = $line -replace [regex]::Escape($m.Value), ('src="' + $relPath + '" width="' + $dims.width + '" height="' + $dims.height + '" loading="lazy" decoding="async"')
    $lines[$idx] = $newLine

    $report += [pscustomobject]@{
      Line=$lineNum; Name=$name; Format='webp'; Width=$dims.width; Height=$dims.height;
      OriginalKB=[math]::Round($bytes.Length/1024,1); NewKB=[math]::Round((Get-Item $outPath).Length/1024,1);
      Path=$relPath
    }
    Write-Host ("Line {0}: {1}.webp ({2}x{3}) {3}KB -> {4}KB" -f $lineNum, $name, $dims.width, $dims.height, [math]::Round($bytes.Length/1024,1), [math]::Round((Get-Item $outPath).Length/1024,1))
  }
}

# Write back
[System.IO.File]::WriteAllLines($HtmlPath, $lines, [System.Text.UTF8Encoding]::new($false))

# Cleanup temp
Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue

# Report
"`n=== EXTRACTION REPORT ==="
$report | Format-Table -AutoSize

$totalOriginalKB = ($report | Measure-Object -Property OriginalKB -Sum).Sum
$totalNewKB      = ($report | Measure-Object -Property NewKB -Sum).Sum
"Total bytes extracted (base64 chars): {0:N1} KB" -f $totalOriginalKB
"Total file sizes on disk:             {0:N1} KB" -f $totalNewKB

$origHtmlSize = (Get-Item "$HtmlPath.bak" -ErrorAction SilentlyContinue).Length
$newHtmlSize  = (Get-Item $HtmlPath).Length
"`nNew HTML size: {0:N0} bytes ({1:N1} KB)" -f $newHtmlSize, ($newHtmlSize/1024)
