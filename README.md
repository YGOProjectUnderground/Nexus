# Project Underground updates for EDOPro  

This repository provides updates for custom cards in [Project Ignis: EDOPro](https://github.com/edo9300/edopro), maintained by **Project Underground**.

Pull requests are not accepted here. If you want to contribute, please refer to our guidelines from [CardScripts](https://github.com/YGOProjectUnderground/CardScripts) and [VaultCDB](https://github.com/YGOProjectUnderground/VaultCDB).

## How to receive cards & updates  

To enable updates from this repository, follow these steps:  

1. Locate your **config folder** (see below).  
2. Create a file named **`user_configs.json`** inside the `config` folder.  
3. Copy and paste the following JSON content into `user_configs.json`:  

```json
{
	"repos": [
		{
			"url": "https://github.com/YGOProjectUnderground/Nexus.git",
			"repo_name": "Nexus updates",
			"repo_path": "./repositories/nexus",
			"data_path": "",
			"script_path": "script",
			"core_path": "bin",
			"has_core": true,
			"should_update": true,
			"should_read": true
		}
	]
}
```  

4. Open `configs.json` in the same `config` folder.  
5. Find the `"has_core"` setting and change its value to `false`. This ensures EDOPro uses our core instead of the default Project Ignis core.  

## Where to find the config folder  

- **Windows**: `This PC > (C:) > ProjectIgnis > config`  
- **Mac**: `Applications > ProjectIgnis > config`  
- **Android**: `EDOPro > config` (in the uppermost directory of your device's internal storage)  