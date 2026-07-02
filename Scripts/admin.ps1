# sudo.ps1
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Command
)

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "powershell.exe"
$psi.Verb = "runas"

if ($Command) {
    $psi.Arguments = "-NoExit -Command " + ($Command -join " ")
} else {
    $psi.Arguments = "-NoExit"
}

[System.Diagnostics.Process]::Start($psi)