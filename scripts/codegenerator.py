#!/usr/bin/env python3
# coding=utf8
import os
import vdf

szBasePath = "./scripts"
szLangPath = "./vietnam_schinese.txt"
szVarNaem = "g_aryWeaponInfos"

lang = vdf.load(open(szLangPath, encoding="utf8"))["lang"]["Tokens"]
aryDir = os.listdir(szBasePath)
i = 0
for f in aryDir:
    szPath = os.path.join(szBasePath, f)
    data = vdf.load(open(szPath, encoding="utf8"))["WeaponData"]

    if "ZMBuyPrice" in data:
        display_key = str(data["printname"]).removeprefix("#").lower()
        if display_key in lang:
            dispay = lang[display_key]
        else:
            dispay = display_key.upper()
        price = data["ZMBuyPrice"]
        weight = data["ZMWeight"]
        category = data["WeaponType"]

        print("g_aryWeaponInfos[" + str(i) + "].classname = \"" + f.removesuffix(".txt") + "\";")
        print("g_aryWeaponInfos[" + str(i) + "].display = \"" + dispay + "\";")
        print("g_aryWeaponInfos[" + str(i) + "].category = \"" + category + "\";")
        print("g_aryWeaponInfos[" + str(i) + "].price = " + price + ";")
        print("g_aryWeaponInfos[" + str(i) + "].weight = " + weight + ";")
        print()
        i+=1

print(i)
print()