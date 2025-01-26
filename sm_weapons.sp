#include <sourcemod>
#include <sdktools>
#define PLUGIN_VERSION "01.01"

ConVar g_Cvar_Enable;

public Plugin myinfo =
{
    name        = "MCV Weapon Menu",
    author      = "dr.abc",
    description = "dr.abc",
    version     = PLUGIN_VERSION,
    url         = "in ur face"


}

enum struct WeaponInfo {
    char file[32];
    char name[32];
    char cat[32];
}

char g_aryWeaponNames[][] = {
    "weapon_ak47_bayonet",
    "weapon_ak47",
    "weapon_akm_gp25",
    "weapon_akm",
    "weapon_amd65",
    "weapon_ammobox_us",
    "weapon_ammobox_vc",
    "weapon_aps",
    "weapon_auto5",
    "weapon_baby_browning",
    "weapon_binoculars_us",
    "weapon_binoculars_vc",
    "weapon_blackhawk",
    "weapon_bren",
    "weapon_c4",
    "weapon_c96",
    "weapon_car15_oeg",
    "weapon_car15",
    "weapon_car15s",
    "weapon_china_lake",
    "weapon_cobra",
    "weapon_crossbow",
    "weapon_crowbar",
    "weapon_csg",
    "weapon_csg2",
    "weapon_css",
    "weapon_dp28",
    "weapon_dual_aps",
    "weapon_dual_baby_browning",
    "weapon_dual_blackhawk",
    "weapon_dual_cobra",
    "weapon_dual_hdm",
    "weapon_dual_hp",
    "weapon_dual_lacoste",
    "weapon_dual_lebel",
    "weapon_dual_m1895",
    "weapon_dual_m1911",
    "weapon_dual_m1917",
    "weapon_dual_mac10_sog",
    "weapon_dual_mac10",
    "weapon_dual_mamba",
    "weapon_dual_mk22_mod0",
    "weapon_dual_mk22",
    "weapon_dual_mle1935",
    "weapon_dual_p38",
    "weapon_dual_pb",
    "weapon_dual_pm",
    "weapon_dual_pm63",
    "weapon_dual_ppk",
    "weapon_dual_qspr",
    "weapon_dual_rhogun",
    "weapon_dual_ruby",
    "weapon_dual_swm10",
    "weapon_dual_swm12",
    "weapon_dual_tt33",
    "weapon_dual_type14",
    "weapon_dual_type64p",
    "weapon_dual_uzi_sog",
    "weapon_dual_uzi",
    "weapon_dual_vz23",
    "weapon_dual_vz61e_sog",
    "weapon_dual_vz61e",
    "weapon_dynamite",
    "weapon_f1",
    "weapon_fists",
    "weapon_fm24",
    "weapon_g3",
    "weapon_gasmask_us",
    "weapon_gasmask_vc",
    "weapon_gp25",
    "weapon_hdm",
    "weapon_hp",
    "weapon_k50m",
    "weapon_kar98k_riflegrenade",
    "weapon_kar98k_s",
    "weapon_kar98k_zf41",
    "weapon_kar98k",
    "weapon_kbkg60_riflegrenade",
    "weapon_kbkg60",
    "weapon_kolos",
    "weapon_l1a1_sog",
    "weapon_l1a1",
    "weapon_l2a1",
    "weapon_lacoste",
    "weapon_lebel",
    "weapon_lpo50",
    "weapon_m12",
    "weapon_m14_riflegrenade",
    "weapon_m14",
    "weapon_m16_xm148",
    "weapon_m16a1_m203",
    "weapon_m16a1_sog",
    "weapon_m16a1",
    "weapon_m16mine",
    "weapon_m18",
    "weapon_m1895",
    "weapon_m1897",
    "weapon_m18r",
    "weapon_m1903_riflegrenade",
    "weapon_m1903",
    "weapon_m1903s",
    "weapon_m1905_bayonet",
    "weapon_m1911",
    "weapon_m1917",
    "weapon_m1918_bar",
    "weapon_m1918",
    "weapon_m1919a6_zombie",
    "weapon_m1919a6",
    "weapon_m1928",
    "weapon_m1942",
    "weapon_m1a1_sog",
    "weapon_m1a1",
    "weapon_m1c_riflegrenade",
    "weapon_m1c_sog",
    "weapon_m1c",
    "weapon_m1g_riflegrenade",
    "weapon_m1g",
    "weapon_m1gs",
    "weapon_m203",
    "weapon_m21s",
    "weapon_m26",
    "weapon_m2c_riflegrenade",
    "weapon_m2c_sog",
    "weapon_m2c",
    "weapon_m34",
    "weapon_m37",
    "weapon_m38_riflegrenade",
    "weapon_m38",
    "weapon_m38s",
    "weapon_m3a1_sog",
    "weapon_m3a1",
    "weapon_m40",
    "weapon_m45_sog",
    "weapon_m45",
    "weapon_m50",
    "weapon_m50r",
    "weapon_m55r",
    "weapon_m56",
    "weapon_m60_zombie",
    "weapon_m60",
    "weapon_m601",
    "weapon_m605",
    "weapon_m607_oeg",
    "weapon_m607",
    "weapon_m607s",
    "weapon_m60b",
    "weapon_m60r",
    "weapon_m656",
    "weapon_m6a1",
    "weapon_m7_bayonet",
    "weapon_m72",
    "weapon_m79_sog",
    "weapon_m79",
    "weapon_m8",
    "weapon_m870",
    "weapon_m91_riflegrenade",
    "weapon_m91",
    "weapon_m9a1",
    "weapon_mac10_sog",
    "weapon_mac10",
    "weapon_mamba",
    "weapon_mas36_cr39",
    "weapon_mas36_riflegrenade",
    "weapon_mas36",
    "weapon_mas38",
    "weapon_mas49_riflegrenade",
    "weapon_mas49",
    "weapon_mas49s",
    "weapon_mat49_sog",
    "weapon_mat49",
    "weapon_md63",
    "weapon_medicbox_us",
    "weapon_medicbox_vc",
    "weapon_mg43",
    "weapon_mk22_mod0",
    "weapon_mk22",
    "weapon_mk3a2",
    "weapon_mk4mod0",
    "weapon_mle1935",
    "weapon_molotov",
    "weapon_mp40",
    "weapon_owen_gun",
    "weapon_p38",
    "weapon_pb",
    "weapon_pm",
    "weapon_pm63",
    "weapon_ppk",
    "weapon_pps43",
    "weapon_ppsh41",
    "weapon_ppsh41d",
    "weapon_ptrd",
    "weapon_qspr",
    "weapon_rg42",
    "weapon_rhogun",
    "weapon_robust_sog",
    "weapon_robust",
    "weapon_rp46",
    "weapon_rpd_sog",
    "weapon_rpd",
    "weapon_rpg2",
    "weapon_rpg7",
    "weapon_rpk",
    "weapon_ruby",
    "weapon_shovel_us",
    "weapon_shovel_vc",
    "weapon_sickle",
    "weapon_sks_riflegrenade",
    "weapon_sks",
    "weapon_stenmk2_sog",
    "weapon_stenmk2",
    "weapon_sterling_sog",
    "weapon_sterling",
    "weapon_stg44_zf41",
    "weapon_stg44",
    "weapon_stg44s",
    "weapon_stoner63_b",
    "weapon_stoner63_c",
    "weapon_stoner63_l",
    "weapon_stoner63_r",
    "weapon_stoner63",
    "weapon_svd",
    "weapon_svt40",
    "weapon_svt40s",
    "weapon_swm10",
    "weapon_swm12",
    "weapon_swm76_sog",
    "weapon_swm76",
    "weapon_t223",
    "weapon_tt33",
    "weapon_tul1",
    "weapon_type14",
    "weapon_type17",
    "weapon_type30_bayonet",
    "weapon_type56",
    "weapon_type58",
    "weapon_type63_riflegrenade",
    "weapon_type63_sog",
    "weapon_type63",
    "weapon_type64",
    "weapon_type64p",
    "weapon_type67",
    "weapon_type97",
    "weapon_uzi_sog",
    "weapon_uzi",
    "weapon_v40",
    "weapon_vcpistol",
    "weapon_vz23",
    "weapon_vz58",
    "weapon_vz61e_sog",
    "weapon_vz61e",
    "weapon_welrod",
    "weapon_wrench",
    "weapon_xm148",
    "weapon_xm177_oeg",
    "weapon_xm177",
    "weapon_xm202"
};
WeaponInfo g_aryInfos[sizeof(g_aryWeaponNames)];

StringMap  g_dicMenues;

Menu       g_pRootMenu;

char       g_aryPlayerSavedWeapon[32][33];

Action     Command_Weapons(int client, int args)
{
    if (GetConVarInt(g_Cvar_Enable))
    {
        if (client)
        {
            if (IsPlayerAlive(client))
            {
                g_pRootMenu.Display(client, 20);
            }
            else
                PrintToChat(client, "\x03 死人不能使用武器菜单哦.");
        }
    }
    return Plugin_Handled
}

void Timer_LazyGiveWeapon(Handle timer, int client)
{
    PerformCheatCommand(client, g_aryPlayerSavedWeapon[client]);
}

Action Event_PlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
    if (!GetConVarInt(g_Cvar_Enable))
        return Plugin_Handled;
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (strlen(g_aryPlayerSavedWeapon[client]) > 0)
    {
        CreateTimer(0.1, Timer_LazyGiveWeapon, client);
    }
    return Plugin_Handled;
}

public void OnPluginStart()
{
    g_dicMenues = new StringMap();
    RegConsoleCmd("sm_weapons", Command_Weapons, "Open the !weapons Menu");
    g_Cvar_Enable = CreateConVar("sm_weapons_enabled", "0", "Enables or Disables the !weapons Menu", FCVAR_PLUGIN);
    HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);

    g_pRootMenu = new Menu(Menu_OpenSubMenu);
    g_pRootMenu.SetTitle("选枪菜单：");
	
    for (int i = 0; i < sizeof(g_aryWeaponNames); i++)
    {
        char buffer[PLATFORM_MAX_PATH];
        Format(buffer, sizeof(buffer), "scripts/%s.txt", g_aryWeaponNames[i]);
        KeyValues kv = new KeyValues("temp weapon");
        kv.ImportFromFile(buffer);
        kv.GetString("printname", g_aryInfos[i].name, sizeof(g_aryInfos[i].name));
        kv.GetString("WeaponType", g_aryInfos[i].cat, sizeof(g_aryInfos[i].cat));
        delete kv;
        strcopy(g_aryInfos[i].file, sizeof(g_aryInfos[i].file), g_aryWeaponNames[i]);

        if (g_dicMenues.ContainsKey(g_aryInfos[i].cat))
        {
            Menu m;
            g_dicMenues.GetValue(g_aryInfos[i].cat, m);
            m.AddItem(g_aryInfos[i].file, g_aryInfos[i].name);
        }
        else
        {
            Menu m = new Menu(Menu_PerformWeapon);
            m.SetTitle(g_aryInfos[i].cat);
            m.AddItem(g_aryInfos[i].file, g_aryInfos[i].name);
            g_dicMenues.SetValue(g_aryInfos[i].cat, m);
            g_pRootMenu.AddItem(g_aryInfos[i].cat, g_aryInfos[i].cat);
        }
    }
}

void RemoveBox(Handle timer, int box)
{
    if (IsValidEntity(box))
    {
        RemoveEntity(box);
    }
}
void PerformCheatCommand(int client, char[] cmd)
{
    ConVar cvar    = FindConVar("sv_cheats");
    bool   enabled = GetConVarBool(cvar);
    int    flags   = GetConVarFlags(cvar);
    if (!enabled)
    {
        SetConVarFlags(cvar, flags ^ (FCVAR_NOTIFY | FCVAR_REPLICATED));
        SetConVarBool(cvar, true);
    }
    FakeClientCommand(client, "give %s", cmd);
    int team = GetEntProp(client, Prop_Send, "m_iTeamNum");
    int box  = -1;
    if (team == 3)
    {
        box = CreateEntityByName("item_ammobox_vc");
    }
    else
    {
        box = CreateEntityByName("item_ammobox_us");
    }
    if (IsValidEntity(box))
    {
        DispatchSpawn(box);
        float org[3];
        GetClientAbsOrigin(client, org);
        TeleportEntity(box, org);
        CreateTimer(3.5, RemoveBox, box);
    }

    if (!enabled)
    {
        SetConVarBool(cvar, false);
        SetConVarFlags(cvar, flags);
    }
}

public void Menu_PerformWeapon(Menu menu, MenuAction action, int client, int param2)
{
    if (action == MenuAction_Select)
    {
        char info[32];
        menu.GetItem(param2, info, sizeof(info));
        PerformCheatCommand(client, info);
        strcopy(g_aryPlayerSavedWeapon[client], sizeof(g_aryPlayerSavedWeapon[client]), info);
    }
}

public void Menu_OpenSubMenu(Menu menu, MenuAction action, int param1, int param2)
{
    if (action == MenuAction_Select)
    {
        char info[32];
        menu.GetItem(param2, info, sizeof(info));
        if (g_dicMenues.ContainsKey(info))
        {
            Menu m;
            g_dicMenues.GetValue(info, m);
            m.Display(param1, 20);
        }
    }
}