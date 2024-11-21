#include <sourcemod>
#include <sdktools>
#define PLUGIN_VERSION "01.01"

new Handle:g_Cvar_Enable = INVALID_HANDLE
new Handle:g_WeaponMenu
new Handle:g_DualPistolMenu
new Handle:g_PistolMenu
new Handle:g_SMGMenu
new Handle:g_ShotgunMenu
new Handle:g_RifleMenu
new Handle:g_SniperMenu
new Handle:g_MGunMenu
new Handle:g_OtherMenu

public Plugin:myinfo =
{
	name = "MCV Weapon Menu",
	author = "dr.abc",
	description = "dr.abc",
	version = PLUGIN_VERSION,
	url = "in ur face"
}


public OnPluginStart()
{
	RegConsoleCmd("sm_weapons", Command_Weapons, "Open the !weapons Menu");
	g_Cvar_Enable = CreateConVar("sm_weapons_enabled", "0", "Enables or Disables the !weapons Menu", FCVAR_PLUGIN);
}
public OnMapStart()
{
	g_WeaponMenu = BuildWeaponMenu();
	g_PistolMenu = BuildPistolMenu();
	g_DualPistolMenu = BuildDualPistolMenu();
	g_SMGMenu = BuildSMGMenu();
	g_ShotgunMenu = BuildShotgunMenu();
	g_RifleMenu = BuildRifleMenu();
	g_SniperMenu = BuildSniperMenu();
	g_MGunMenu = BuildMGunMenu();
	g_OtherMenu = BuildOtherMenu();
}
public OnMapEnd()
{
	if (g_WeaponMenu != INVALID_HANDLE)
	{
		CloseHandle(g_WeaponMenu);
		g_WeaponMenu = INVALID_HANDLE;
	}
	if (g_PistolMenu != INVALID_HANDLE)
	{
		CloseHandle(g_PistolMenu);
		g_PistolMenu = INVALID_HANDLE;
	}
	if (g_DualPistolMenu != INVALID_HANDLE)
	{
		CloseHandle(g_DualPistolMenu);
		g_DualPistolMenu = INVALID_HANDLE;
	}
	if (g_SMGMenu != INVALID_HANDLE)
	{
		CloseHandle(g_SMGMenu);
		g_SMGMenu = INVALID_HANDLE;
	}
	if (g_ShotgunMenu != INVALID_HANDLE)
	{
		CloseHandle(g_ShotgunMenu);
		g_ShotgunMenu = INVALID_HANDLE;
	}
	if (g_RifleMenu != INVALID_HANDLE)
	{
		CloseHandle(g_RifleMenu);
		g_RifleMenu = INVALID_HANDLE;
	}
	if (g_SniperMenu != INVALID_HANDLE)
	{
		CloseHandle(g_SniperMenu);
		g_SniperMenu = INVALID_HANDLE;
	}
	if (g_MGunMenu != INVALID_HANDLE)
	{
		CloseHandle(g_MGunMenu);
		g_MGunMenu = INVALID_HANDLE;
	}
	if (g_OtherMenu != INVALID_HANDLE)
	{
		CloseHandle(g_OtherMenu);
		g_OtherMenu = INVALID_HANDLE;
	}
}
Handle:BuildWeaponMenu()
{
	new Handle:weapons = CreateMenu(Menu_Weapons);
	AddMenuItem(weapons, "g_PistolMenu", "手枪")
	AddMenuItem(weapons, "g_DualPistolMenu", "双持武器")
	AddMenuItem(weapons, "g_ShotgunMenu", "霰弹枪")
	AddMenuItem(weapons, "g_SMGMenu", "冲锋枪")
	AddMenuItem(weapons, "g_RifleMenu", "步枪")
	AddMenuItem(weapons, "g_SniperMenu", "狙击枪")
	AddMenuItem(weapons, "g_MGunMenu", "机枪")
	AddMenuItem(weapons, "g_OtherMenu", "杂项")
	SetMenuTitle(weapons, "武器菜单:");
	return weapons;
}
Handle:BuildPistolMenu()
{
	new Handle:pistols = CreateMenu(Menu_Pistols);
	AddMenuItem(pistols, "weapon_aps", "APS冲锋手枪");
	AddMenuItem(pistols, "weapon_baby_browning", "婴儿勃朗宁");
	AddMenuItem(pistols, "weapon_c96", "毛瑟C96");
	AddMenuItem(pistols, "weapon_hdm", "HDM");
	AddMenuItem(pistols, "weapon_m1895", "纳甘M1895");
	AddMenuItem(pistols, "weapon_m1911", "M1911A1");
	AddMenuItem(pistols, "weapon_m1917", "M1917");
	AddMenuItem(pistols, "weapon_mk22_mod0", "MK22 Mod0");
	AddMenuItem(pistols, "weapon_mk22", "MK22");
	AddMenuItem(pistols, "weapon_mle1935", "MAS-35S");
	AddMenuItem(pistols, "weapon_p38", "瓦尔特P38");
	AddMenuItem(pistols, "weapon_pb", "PB");
	AddMenuItem(pistols, "weapon_pm", "PM");
	AddMenuItem(pistols, "weapon_swm10", "史密斯威森M10");
	AddMenuItem(pistols, "weapon_swm12", "史密斯威森M12");
	AddMenuItem(pistols, "weapon_tt33", "TT-33");
	AddMenuItem(pistols, "weapon_type14", "南部十四年式");
	AddMenuItem(pistols, "weapon_type17", "晋造17式驳壳枪");
	AddMenuItem(pistols, "weapon_type67", "67式");
	AddMenuItem(pistols, "weapon_vcpistol", "VC手枪");
	SetMenuTitle(pistols, "手枪菜单:");
	return pistols;
}
Handle:BuildDualPistolMenu()
{
	new Handle:dual_pistols = CreateMenu(Menu_DualPistols);
	AddMenuItem(dual_pistols, "weapon_dual_aps", "双持APS");
	AddMenuItem(dual_pistols, "weapon_dual_baby_browning", "双持婴儿勃朗宁");
	AddMenuItem(dual_pistols, "weapon_dual_hdm", "双持HDM");
	AddMenuItem(dual_pistols, "weapon_dual_m1895", "双持纳甘M1895");
	AddMenuItem(dual_pistols, "weapon_dual_m1911", "双持M1911A1");
	AddMenuItem(dual_pistols, "weapon_dual_m1917", "双持M1917");
	AddMenuItem(dual_pistols, "weapon_dual_mac10", "双持MAC10");
	AddMenuItem(dual_pistols, "weapon_dual_mac10_sog", "双持消音MAC10");
	AddMenuItem(dual_pistols, "weapon_dual_mk22_mod0", "双持MK22 Mod0");
	AddMenuItem(dual_pistols, "weapon_dual_mk22", "双持MK22");
	AddMenuItem(dual_pistols, "weapon_dual_mle1935", "双持MAS-35S");
	AddMenuItem(dual_pistols, "weapon_dual_p38", "双持瓦尔特P38");
	AddMenuItem(dual_pistols, "weapon_dual_pb", "双持PB");
	AddMenuItem(dual_pistols, "weapon_dual_pm", "双持PM");
	AddMenuItem(dual_pistols, "weapon_dual_swm10", "双持史密斯威森M10");
	AddMenuItem(dual_pistols, "weapon_dual_swm12", "双持史密斯威森M12");
	AddMenuItem(dual_pistols, "weapon_dual_tt33", "双持TT-33");
	AddMenuItem(dual_pistols, "weapon_dual_type14", "双持南部十四年式");
	AddMenuItem(dual_pistols, "weapon_dual_type67", "双持67式");
	AddMenuItem(dual_pistols, "weapon_dual_uzi", "双持UZI");
	AddMenuItem(dual_pistols, "weapon_dual_uzi_sog", "双持消音UZI");
	AddMenuItem(dual_pistols, "weapon_dual_vz23", "双持VZ.23");
	AddMenuItem(dual_pistols, "weapon_dual_vz61e", "双持VZ.61e蝎式");
	AddMenuItem(dual_pistols, "weapon_dual_vz61e_sog", "双持消音VZ.61e蝎式");
	SetMenuTitle(dual_pistols, "双持手枪菜单:");
	return dual_pistols;
}
Handle:BuildSMGMenu()
{
	new Handle:smgs = CreateMenu(Menu_SMGs);
	AddMenuItem(smgs, "weapon_k50m", "K-50M");
	AddMenuItem(smgs, "weapon_m12", "伯莱塔M12");
	AddMenuItem(smgs, "weapon_m1928", "汤姆逊M1928");
	AddMenuItem(smgs, "weapon_m1a1", "汤姆逊M1A1");
	AddMenuItem(smgs, "weapon_m1a1_sog", "汤姆逊M1A1 特种");
	AddMenuItem(smgs, "weapon_m3a1", "M3A1黄油枪");
	AddMenuItem(smgs, "weapon_m3a1_sog", "M3A1黄油枪 特种");
	AddMenuItem(smgs, "weapon_m45", "卡尔古斯塔夫 M/45");
	AddMenuItem(smgs, "weapon_m45_sog", "卡尔古斯塔夫 M/45 特种");
	AddMenuItem(smgs, "weapon_m50", "麦德森 M/50");
	AddMenuItem(smgs, "weapon_mac10", "MAC10");
	AddMenuItem(smgs, "weapon_mac10_sog", "消音MAC10");
	AddMenuItem(smgs, "weapon_mas38", "MAS38");
	AddMenuItem(smgs, "weapon_mat49", "MAT-49");
	AddMenuItem(smgs, "weapon_mat49_sog", "MAT-49 特种");
	AddMenuItem(smgs, "weapon_mp40", "MP-40");
	AddMenuItem(smgs, "weapon_pps43", "PPS-43");
	AddMenuItem(smgs, "weapon_ppsh41", "PPSH-41");
	AddMenuItem(smgs, "weapon_ppsh41d", "PPSH-41 弹鼓");
	AddMenuItem(smgs, "weapon_stenmk2", "斯登 MK.II");
	AddMenuItem(smgs, "weapon_stenmk2_sog", "斯登 MK.IIS 特种");
	AddMenuItem(smgs, "weapon_swm76", "史密斯威森M76");
	AddMenuItem(smgs, "weapon_swm76_sog", "史密斯威森M76 特种");
	AddMenuItem(smgs, "weapon_type64", "64式微声冲锋枪");
	AddMenuItem(smgs, "weapon_uzi", "UZI");
	AddMenuItem(smgs, "weapon_uzi_sog", "消音UZI");
	AddMenuItem(smgs, "weapon_vz23", "VZ.23");
	AddMenuItem(smgs, "weapon_vz61e", "VZ.61e蝎式");
	AddMenuItem(smgs, "weapon_vz61e_sog", "消音VZ.61e蝎式");
	SetMenuTitle(smgs, "冲锋枪菜单:");
	return smgs;
}
Handle:BuildShotgunMenu()
{
	new Handle:shotguns = CreateMenu(Menu_Shotguns);
	AddMenuItem(shotguns, "weapon_m1897", "M1897堑壕枪");
	AddMenuItem(shotguns, "weapon_m37", "M37堑壕枪");
	AddMenuItem(shotguns, "weapon_m870", "M870");
	AddMenuItem(shotguns, "weapon_robust", "双管霰弹枪");
	AddMenuItem(shotguns, "weapon_robust_sog", "截短双管霰弹枪");
	SetMenuTitle(shotguns, "霰弹枪菜单:");
	return shotguns;
}
Handle:BuildRifleMenu()
{
	new Handle:rifles = CreateMenu(Menu_Rifles);
	AddMenuItem(rifles, "weapon_ak47", "AK47");
	AddMenuItem(rifles, "weapon_ak47_bayonet", "AK47刺刀");
	AddMenuItem(rifles, "weapon_akm", "AKM");
	AddMenuItem(rifles, "weapon_akm_gp25", "AKM-GP25");
	AddMenuItem(rifles, "weapon_amd65", "AMD65");
	AddMenuItem(rifles, "weapon_car15", "XM177E2");
	AddMenuItem(rifles, "weapon_car15s", "XM177E2 4x");
	AddMenuItem(rifles, "weapon_kar98k", "KAR98K");
	AddMenuItem(rifles, "weapon_kbkg60", "KBKG 60");
	AddMenuItem(rifles, "weapon_m14", "M14");
	AddMenuItem(rifles, "weapon_m14_riflegrenade", "M14(枪榴弹)");
	AddMenuItem(rifles, "weapon_m16a1", "M16A1");
	AddMenuItem(rifles, "weapon_m16a1_m203", "M16A1(M203)");
	AddMenuItem(rifles, "weapon_m1903", "M1903春田");
	AddMenuItem(rifles, "weapon_m1903_riflegrenade", "M1903春田(枪榴弹)");
	AddMenuItem(rifles, "weapon_m1918", "M1918A2 BAR");
	AddMenuItem(rifles, "weapon_m1c", "M1卡宾枪");
	AddMenuItem(rifles, "weapon_m1c_sog", "M1卡宾枪 特种");
	AddMenuItem(rifles, "weapon_m1c_riflegrenade", "M1卡宾枪(枪榴弹)");
	AddMenuItem(rifles, "weapon_m1g", "M1加兰德");
	AddMenuItem(rifles, "weapon_m1g_riflegrenade", "M1加兰德(枪榴弹)");
	AddMenuItem(rifles, "weapon_m2c", "M2卡宾枪");
	AddMenuItem(rifles, "weapon_m2c_sog", "M1卡宾枪 特种");
	AddMenuItem(rifles, "weapon_m2c_riflegrenade", "M1卡宾枪(枪榴弹)");
	AddMenuItem(rifles, "weapon_m38", "莫幸纳甘M38");
	AddMenuItem(rifles, "weapon_m38_riflegrenade", "莫幸纳甘M38(枪榴弹)");
	AddMenuItem(rifles, "weapon_m601", "M601");
	AddMenuItem(rifles, "weapon_m607", "XM607");
	AddMenuItem(rifles, "weapon_m607s", "XM607 4X");
	AddMenuItem(rifles, "weapon_m91", "莫幸纳甘M91/30");
	AddMenuItem(rifles, "weapon_m91_riflegrenade", "莫幸纳甘M91/30(枪榴弹)");
	AddMenuItem(rifles, "weapon_mas49", "MAS-49");
	AddMenuItem(rifles, "weapon_mas49_riflegrenade", "MAS-49(枪榴弹)");
	AddMenuItem(rifles, "weapon_mad63", "PM MD.63");
	AddMenuItem(rifles, "weapon_mk4mod0", "MK-4 Mod0");
	AddMenuItem(rifles, "weapon_sks", "SKS");
	AddMenuItem(rifles, "weapon_sks_riflegrenade", "SKS(枪榴弹)");
	AddMenuItem(rifles, "weapon_stg44", "Stg-44");
	AddMenuItem(rifles, "weapon_stg44s", "Stg-44(ZF4瞄具)");
	AddMenuItem(rifles, "weapon_stoner63_l", "斯通纳63A步枪");
	AddMenuItem(rifles, "weapon_stoner63_a", "斯通纳63A卡宾枪");
	AddMenuItem(rifles, "weapon_svt40", "SVT 40");
	AddMenuItem(rifles, "weapon_t223", "H&R T223");
	AddMenuItem(rifles, "weapon_type56", "56-1式");
	AddMenuItem(rifles, "weapon_type63", "63式");
	AddMenuItem(rifles, "weapon_type63_sog", "63式 特种");
	AddMenuItem(rifles, "weapon_type63_riflegrenade", "63式(枪榴弹)");
	AddMenuItem(rifles, "weapon_vz58", "Vz.58");
	AddMenuItem(rifles, "weapon_xm177", "XM177特种");
	SetMenuTitle(rifles, "步枪菜单:");
	return rifles;
}
Handle:BuildSniperMenu()
{
	new Handle:snipers = CreateMenu(Menu_Snipers);
	AddMenuItem(snipers, "weapon_kar98k_s", "KAR98K(ZF39瞄具)");
	AddMenuItem(snipers, "weapon_m1903s", "M1903A4春田");
	AddMenuItem(snipers, "weapon_m1gs", "M1D加兰德");
	AddMenuItem(snipers, "weapon_m21s", "XM21");
	AddMenuItem(snipers, "weapon_m38s", "莫幸纳甘M91/30 PU");
	AddMenuItem(snipers, "weapon_m40", "M40");
	AddMenuItem(snipers, "weapon_m656", "M656");
	AddMenuItem(snipers, "weapon_mas49s", "MAS-49 APX L806");
	AddMenuItem(snipers, "weapon_ptrd", "PTRD-41");
	AddMenuItem(snipers, "weapon_svd", "SVD");
	AddMenuItem(snipers, "weapon_svt40s", "SVT 40(PU瞄具)");
	SetMenuTitle(snipers, "狙击步枪菜单:");
	return snipers;
}
Handle:BuildMGunMenu()
{
	new Handle:mguns = CreateMenu(Menu_MGuns);
	AddMenuItem(mguns, "weapon_bren", "布伦轻机枪");
	AddMenuItem(mguns, "weapon_dp28", "DP-28");
	AddMenuItem(mguns, "weapon_m1918_bar", "M1918A2 BAR");
	AddMenuItem(mguns, "weapon_m1919a6", "M1919A6");
	AddMenuItem(mguns, "weapon_m60", "M60");
	AddMenuItem(mguns, "weapon_m60b", "M60弹链");
	AddMenuItem(mguns, "weapon_rp46", "RP-46");
	AddMenuItem(mguns, "weapon_rpd", "RPD");
	AddMenuItem(mguns, "weapon_rpd_sog", "RPD 特种");
	AddMenuItem(mguns, "weapon_rpk", "RPK");
	AddMenuItem(mguns, "weapon_stoner63_b", "斯通纳63A布伦");
	AddMenuItem(mguns, "weapon_stoner63_l", "斯通纳63A轻机枪");
	AddMenuItem(mguns, "weapon_stoner63", "斯通纳63A轻机枪突击队员型");
	AddMenuItem(mguns, "weapon_tul1", "TUL-1");
	SetMenuTitle(mguns, "机枪菜单:");
	return mguns;
}
Handle:BuildOtherMenu()
{
	new Handle:others = CreateMenu(Menu_Other);
	AddMenuItem(others, "weapon_c4", "C4");
	AddMenuItem(others, "weapon_dynamite", "雷管");
	AddMenuItem(others, "weapon_china_lake", "中国湖榴弹发射器");
	AddMenuItem(others, "weapon_m79", "M79榴弹发射器");
	AddMenuItem(others, "weapon_m79_sog", "M79榴弹发射器 特种");
	AddMenuItem(others, "weapon_m72", "M72 LAW");
	AddMenuItem(others, "weapon_xm202", "XM202 闪光");
	AddMenuItem(others, "weapon_rpg2", "RPG-2");
	AddMenuItem(others, "weapon_rpg7", "RPG-7");
	AddMenuItem(others, "weapon_crossbow", "十字弩");
	AddMenuItem(others, "weapon_crowbar", "撬棍");
	AddMenuItem(others, "weapon_lpo50", "LPO50火焰喷射器");
	AddMenuItem(others, "weapon_m9a1", "M9A1火焰喷射器");
	AddMenuItem(others, "weapon_m8", "M8信号枪");
	AddMenuItem(others, "weapon_type97", "九七式信号拳铳");
	AddMenuItem(others, "weapon_m16mine", "M16绊雷");
	AddMenuItem(others, "weapon_rg42", "RG-42绊雷");
	AddMenuItem(others, "weapon_m18", "M18烟雾弹");
	AddMenuItem(others, "weapon_m18r", "M18烟雾弹(红)");
	AddMenuItem(others, "weapon_m26", "M26破片手雷");
	AddMenuItem(others, "weapon_m6a1", "M6A1毒气手雷");
	AddMenuItem(others, "weapon_molotov", "莫洛托夫燃烧瓶");
	AddMenuItem(others, "weapon_mk3a2", "MK3A2高爆手雷");
	AddMenuItem(others, "weapon_m1942", "M1942开山刀");
	AddMenuItem(others, "weapon_sickle", "镰刀");
	AddMenuItem(others, "weapon_m7_bayonet", "M7刺刀");
	SetMenuTitle(others, "杂项菜单:");
	return others;
}
public Menu_Weapons(Handle:weapons, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(weapons, param2, info, sizeof(info));

		if (StrEqual(info,"g_PistolMenu"))
		{
			DisplayMenu(g_PistolMenu, param1, 20);
			return;
		}
		if (StrEqual(info,"g_DualPistolMenu"))
		{
			DisplayMenu(g_DualPistolMenu, param1, 20);
			return;
		}
		if (StrEqual(info,"g_SMGMenu"))
		{
			DisplayMenu(g_SMGMenu, param1, 20);
			return;
		}
		if (StrEqual(info,"g_ShotgunMenu"))
		{
			DisplayMenu(g_ShotgunMenu, param1, 20);
			return;
		}
		if (StrEqual(info,"g_RifleMenu"))
		{
			DisplayMenu(g_RifleMenu, param1, 20);
			return;
		}
		if (StrEqual(info,"g_SniperMenu"))
		{
			DisplayMenu(g_SniperMenu, param1, 20);
			return;
		}
		if (StrEqual(info,"g_MGunMenu"))
		{
			DisplayMenu(g_MGunMenu, param1, 20);
			return;
		}
		if (StrEqual(info,"g_OtherMenu"))
		{
			DisplayMenu(g_OtherMenu, param1, 20);
			return;
		}
	}
}

stock PerformCheatCommand(client, String:cmd[])
{
	new Handle:cvar = FindConVar("sv_cheats"), bool:enabled = GetConVarBool(cvar), flags = GetConVarFlags(cvar);
	if(!enabled) {
		SetConVarFlags(cvar, flags^(FCVAR_NOTIFY|FCVAR_REPLICATED));
		SetConVarBool(cvar, true);
	}
	FakeClientCommand(client, "give %s", cmd);
	FakeClientCommand(client, "give weapon_ammobox_us");
	if(!enabled) {
		SetConVarBool(cvar, false);
		SetConVarFlags(cvar, flags);
    }
}
public Menu_Pistols(Handle:pistols, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(pistols, param2, info, sizeof(info));

		PerformCheatCommand(param1, info);
	}
}
public Menu_DualPistols(Handle:pistols, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(pistols, param2, info, sizeof(info));

		PerformCheatCommand(param1, info);
	}
}
public Menu_SMGs(Handle:smgs, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(smgs, param2, info, sizeof(info));

		PerformCheatCommand(param1, info);
	}
}
public Menu_Shotguns(Handle:shotguns, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(shotguns, param2, info, sizeof(info));

		PerformCheatCommand(param1, info);
	}
}
public Menu_Rifles(Handle:rifles, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(rifles, param2, info, sizeof(info));

		PerformCheatCommand(param1, info);
	}
}
public Menu_Snipers(Handle:snipers, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(snipers, param2, info, sizeof(info));

		PerformCheatCommand(param1, info);
	}
}
public Menu_MGuns(Handle:mguns, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(mguns, param2, info, sizeof(info));

		PerformCheatCommand(param1, info);
	}
}
public Menu_Other(Handle:mguns, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(mguns, param2, info, sizeof(info));

		PerformCheatCommand(param1, info);
	}
}

public Action:Command_Weapons(client, args)
{
    if (GetConVarInt(g_Cvar_Enable))
    {
        if (client)
        {
            if (IsPlayerAlive(client))
            {
                DisplayMenu(g_WeaponMenu, client, 20);
            }
            else 
				PrintToChat(client, "\x03 死人不能使用武器菜单哦.");
        }
    }
    return Plugin_Handled
}