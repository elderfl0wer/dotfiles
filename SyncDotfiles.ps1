<#
    SyncDotfiles.ps1

    Syncs your live config folders into your dotfiles repo.
    Run this any time you want the repo to reflect your current setup,
    then git add/commit/push as normal (or let the script do it — see bottom).
#>

# ---- CONFIG: add more folders here as you collect them ----
# Format: @{ Source = "..."; Dest = "..."; Exclude = @("file1", "folder1") }
$Mappings = @(
    @{
        Source  = "C:\Users\shrey\AppData\Local\nvim"
        Dest    = "C:\Users\shrey\dotfiles\neovim"
        Exclude = @("lazy-lock.json", ".git")
    },
    @{
        Source  = "C:\Scripts"
        Dest    = "C:\Users\shrey\dotfiles\Scripts"
        Exclude = @(".git")
    }
)

# ---- SYNC ----
foreach ($m in $Mappings) {
    $src = $m.Source
    $dst = $m.Dest

    if (-not (Test-Path $src)) {
        Write-Warning "Source not found, skipping: $src"
        continue
    }

    if (-not (Test-Path $dst)) {
        New-Item -ItemType Directory -Path $dst -Force | Out-Null
    }

    Write-Host "Syncing $src -> $dst" -ForegroundColor Cyan

    # robocopy: /MIR mirrors the folder (adds new + updated files, removes deleted ones)
    # /XF excludes specific files, /XD excludes specific directories
    $excludeFiles = $m.Exclude | Where-Object { -not (Test-Path (Join-Path $src $_) -PathType Container) }
    $excludeDirs  = $m.Exclude | Where-Object { Test-Path (Join-Path $src $_) -PathType Container }

    $roboArgs = @($src, $dst, "/MIR", "/NFL", "/NDL", "/NJH", "/NJS")

    if ($excludeFiles.Count -gt 0) {
        $roboArgs += "/XF"
        $roboArgs += $excludeFiles
    }
    if ($excludeDirs.Count -gt 0) {
        $roboArgs += "/XD"
        $roboArgs += ($excludeDirs | ForEach-Object { Join-Path $src $_ })
    }

    robocopy @roboArgs | Out-Null
    # robocopy's own exit codes 0-7 all mean "success" (files copied/mirrored fine)
    if ($LASTEXITCODE -ge 8) {
        Write-Error "robocopy failed for $src (exit code $LASTEXITCODE)"
    }
}

Write-Host "`nDone syncing." -ForegroundColor Green

# ---- OPTIONAL: auto commit + push ----
# Uncomment below if you want this script to also commit and push automatically.
# Leave commented if you'd rather review changes in git before committing yourself.

# Push-Location "C:\Users\shrey\dotfiles"
# git add .
# git commit -m "Update dotfiles $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
# git push
# Pop-Location
