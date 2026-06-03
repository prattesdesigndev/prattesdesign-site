param(
  [string]$HtmlPath = "C:\Users\Vinicius\Downloads\Site PD CLaude Code\index_111.html"
)

$ErrorActionPreference = 'Stop'
$lines = [System.IO.File]::ReadAllLines($HtmlPath, [System.Text.UTF8Encoding]::new($false))

# 1) Remove duplicate trailing `loading="lazy"` (when there's already one earlier in the same tag)
#    Pattern: `loading="lazy" ... alt="..." loading="lazy"` -> remove the trailing one
$dupCount = 0
for ($i = 0; $i -lt $lines.Length; $i++) {
  $l = $lines[$i]
  # Match a tag that contains two `loading="lazy"` separated by other attrs
  if ($l -match 'loading="lazy".*?loading="lazy"') {
    # Remove the LAST occurrence on this line
    $idx = $l.LastIndexOf('loading="lazy"')
    if ($idx -gt 0) {
      $before = $l.Substring(0, $idx)
      $after  = $l.Substring($idx + 'loading="lazy"'.Length)
      # Also clean up the orphan space left behind
      $l = ($before -replace '\s+$', ' ') + $after.TrimStart()
      $lines[$i] = $l
      $dupCount++
    }
  }
}
Write-Host "Removed $dupCount duplicate loading=lazy attributes"

# 2) Hero gallery (lines 2844..2920): change loading=lazy -> eager (above-the-fold).
#    Add fetchpriority="high" to first 6 (gallery-01..06)
$heroLines = @(2844,2847,2850,2853,2856,2859,2864,2867,2870,2873,2876,2879,2891,2894,2897,2900,2903,2908,2911,2914,2917,2920)
$priorityLines = $heroLines[0..5]   # first 6
$heroFixed = 0
foreach ($lineNum in $heroLines) {
  $i = $lineNum - 1
  $l = $lines[$i]
  if ($l -match 'loading="lazy"') {
    $l = $l -replace 'loading="lazy"', 'loading="eager"'
    if ($priorityLines -contains $lineNum) {
      # insert fetchpriority="high" after width/height/loading
      $l = $l -replace '(loading="eager")', '$1 fetchpriority="high"'
    }
    $lines[$i] = $l
    $heroFixed++
  }
}
Write-Host "Hero gallery: $heroFixed images set to eager (first 6 with fetchpriority=high)"

[System.IO.File]::WriteAllLines($HtmlPath, $lines, [System.Text.UTF8Encoding]::new($false))
Write-Host "Done. New size: $((Get-Item $HtmlPath).Length) bytes"
