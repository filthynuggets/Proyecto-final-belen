$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3

$yesterday = (Get-Date) - (New-TimeSpan -Day 1)

try
{
    $CritEvents = Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-Known Folders API Service'; Level= 2,1; StartTime=$Yesterday } -ErrorAction SilentlyContinue | Measure-Object -Line | Out-String
    $CritNbEv = $CritEvents -replace '\D+',''
}
catch
{
}

try
{
    $WarnEvents = Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-Known Folders API Service'; Level= 3; StartTime=$Yesterday } -ErrorAction SilentlyContinue | Measure-Object -Line | Out-String
    $WarnNbEv = $WarnEvents -replace '\D+',''
}
catch
{
}

try
{
    $OkEvents = Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-Known Folders API Service'; Level= 4; StartTime=$Yesterday } -ErrorAction SilentlyContinue | Measure-Object -Line | Out-String
    $OkNbEv = $OkEvents -replace '\D+',''
}
catch
{
}



if (($CritNbEv -eq $Null -and $CritEvents -eq $Null) -or $CritNbEv -eq 0)
{
$CritNbEv = 0
}

if ($WarnNbEv -eq $Null -and $WarnEvents -eq $Null )
{
    $WarnNbEv = 0
}

if ($OkNbEv -eq $Null -and $OkEvents -eq $Null )
{
    $OkNbEv = 0
}

if ($CritNbEv -ne 0 ) {
    $message = "CRITICAL - Found {0} errors in Microsoft-Windows-Backup event log" -f $CritNbEv
    Write-Host $message
    exit $returnStateCritical
}

if ($WarnNbEv -ne 0) {
    $message = "WARNING - Found {0} warning in Microsoft-Windows-Backup event log" -f $WarnNbEv
    Write-Host $message
    exit $returnStateWarning
}

if ($OkNbEv -ne 0 ) {
    $message = "OK - No errors in Microsoft-Windows-Backup log "
    Write-Host $message
    exit $returnStateOK
}

Write-Host "UNKNOW - Not found backups events"
exit $returnStateUnknown
