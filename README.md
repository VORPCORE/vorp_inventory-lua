# Inventory System for VORPCore in Lua

## Requirements
- [VORP Core](https://github.com/VORPCORE/VORP-Core/releases)
- [VORP Inputs](https://github.com/VORPCORE/VORP-Inputs/releases)
- [VORP Character](https://github.com/VORPCORE/VORP-Character/releases)

## How to install
* Download the lastest version of VORP Inventory
* Copy and paste ```vorp_inventory``` folder to ```resources/vorp_inventory```
* Add ```ensure vorp_inventory``` to your ```server.cfg``` file
* To change the language go to ```resources/vorp_inventory/Config``` and change the default language, also you will have to edit the html file to change the text on the inventory menu
* Now you are ready!

## Features
* Unique weapons in order not to duplicate them.
* Each weapon has its own ammo and can have diferent type of ammo.
* Each weapon has its own modifications. (:warning: Not implemented yet)
* When dropping or giving a weapon you give it with all the modifications and ammo.
* It also has usable items.
* KLS.

## future features
- metadata
- tooltip on items hover
- hand craft button to craft simple things like `roll cigars`

## Development 

- check VORP [trello](https://trello.com/b/wMq4yOrP/vorp-inventory-lua) where development can be tracked 

![image](https://user-images.githubusercontent.com/87246847/156600012-3901dac7-73f8-4577-a8f5-9a60d7e3150b.png)
<img width="354" alt="image" src="https://user-images.githubusercontent.com/87246847/156600211-cc3fc70f-60bb-4884-971a-1d2ad4fdb8ad.png">
<img width="187" alt="image" src="https://user-images.githubusercontent.com/87246847/164942058-a174d9cb-8563-43fc-84cf-e9b0b1d9aa65.png">


## Wiki
[Wiki VORP Inventory](http://docs.vorpcore.com:3000/vorp-inventory)

## Credits

- To [Val3ro](https://github.com/Val3ro) for the initial work.
- To [Emollit](https://github.com/Emolitt) and [Outsider](https://github.com/outsider31000) for the final work.

also to the creators and [Local9](https://github.com/Local9) for the C# version that this inventory was based on 
