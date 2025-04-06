#include <sourcemod>
#include <sdktools>
#define PLUGIN_VERSION "01.01"

Menu      g_ThirdpersonMenu;
ConVar    g_pCheat;
StringMap g_pStored;

public Plugin myinfo =
{
    name        = "MCV Thirdperson Menu",
    author      = "dr.abc",
    description = "dr.abc",
    version     = PLUGIN_VERSION,
    url         = "in ur face"


}

public OnPluginStart()
{
    g_pStored = new StringMap();
    RegConsoleCmd("sm_thirdperson", Command_Thirdperson, "Open the !thirdperson Menu");
    g_ThirdpersonMenu = CreateMenu(Menu_Thirdperson);
    g_pCheat          = FindConVar("sv_cheats");
    AddMenuItem(g_ThirdpersonMenu, "thirdpersonshoulder ", "开启第三人称");
    AddMenuItem(g_ThirdpersonMenu, "firstperson", "关闭第三人称");
    SetMenuTitle(g_ThirdpersonMenu, "第三人称菜单:");
}

public void OnPluginEnd()
{
    g_ThirdpersonMenu.Close();
}

void PerformCheatCommand(int client, char[] cmd)
{
    SendConVarValue(client, g_pCheat, "255");
    ClientCommand(client, cmd);
}

public Action Command_Thirdperson(int client, int args)
{
    if (client)
    {
        if (IsPlayerAlive(client))
            DisplayMenu(g_ThirdpersonMenu, client, 20);
        else
            PrintToChat(client, "\x03 死人不能切换人称哦.");
    }
    return Plugin_Handled
}

public Menu_Thirdperson(Handle weapons, MenuAction action, int client, int slot)
{
    if (action == MenuAction_Select)
    {
        char steamid[64];
        GetClientAuthId(client, AuthId_SteamID64, steamid, sizeof(steamid));

        char info[32];
        GetMenuItem(weapons, slot, info, sizeof(info));

        bool t = info[0] == 't';
        if (g_pStored.ContainsKey(steamid))
        {
            bool s;
            g_pStored.GetValue(steamid, s);
            if (s == t)
            {
                PrintToChat(client, "\x03 你已经在第%s人称了哦~", s ? "三" : "一");
                return;
            }
        }
        PerformCheatCommand(client, info);
        g_pStored.SetValue(steamid, t);
    }
}