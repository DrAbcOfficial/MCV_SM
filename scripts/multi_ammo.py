#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import vdf

basePath = "./scripts"
files = os.listdir(basePath)

multi = 2.5

for f in files:
    path = os.path.join(basePath, f)
    d = vdf.load(open(path))
    if "clip_size" in d["WeaponData"]:
        c = str(d["WeaponData"]["clip_size"]).split("/")
        if len(c) > 1:
            i = int(c[1])
            if i > 0:
                d["WeaponData"]["clip_size"] = c[0] + "/" +str(int(i*multi))

    if "clip2_size" in d["WeaponData"]:
        c = str(d["WeaponData"]["clip2_size"]).split("/")
        if len(c) > 1:
            i = int(c[1])
            if i > 0:
                d["WeaponData"]["clip2_size"] = c[0] + "/" +str(int(i*multi))
    if "default_clip2" in d["WeaponData"]:
        c = int(d["WeaponData"]["default_clip2"])
        if c > 0:
            d["WeaponData"]["default_clip2"] = str(int(c*multi))
    
    text = vdf.dumps(d, pretty=True)
    with open(os.path.join("./new", f), 'w') as new:
        new.write(text)

