param([string]$Command)

Get-Command $Command | Select-Object -ExpandProperty Source