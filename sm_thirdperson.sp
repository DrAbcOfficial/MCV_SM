#include <sourcemod>
#include <sdktools>
#define PLUGIN_VERSION "01.01"

new Handle:g_ThirdpersonMenu

public Plugin:myinfo =
{
	name = "MCV Thirdperson Menu",
	author = "dr.abc",
	description = "dr.abc",
	version = PLUGIN_VERSION,
	url = "in ur face"
}


public OnPluginStart()
{
	RegConsoleCmd("sm_thirdperson", Command_Thirdperson, "Open the !thirdperson Menu");
}
public OnMapStart()
{
	g_ThirdpersonMenu = BuildThirdpersonMenu();
}
public OnMapEnd()
{
	if (g_ThirdpersonMenu != INVALID_HANDLE)
	{
		CloseHandle(g_ThirdpersonMenu);
		g_ThirdpersonMenu = INVALID_HANDLE;
	}
}
Handle:BuildThirdpersonMenu()
{
	new Handle:thirdperson = CreateMenu(Menu_Thirdperson);
	AddMenuItem(thirdperson, "thirdperson ", "正向第三人称")
	AddMenuItem(thirdperson, "thirdpersonshoulder ", "越肩视角第三人称")
	AddMenuItem(thirdperson, "thirdpersonoverview ", "俯视角第三人称")
	AddMenuItem(thirdperson, "firstperson", "关闭第三人称")
	SetMenuTitle(thirdperson, "第三人称菜单:");
	return thirdperson;
}

stock PerformCheatCommand(client, String:cmd[])
{
	new Handle:cvar = FindConVar("sv_cheats"), bool:enabled = GetConVarBool(cvar), flags = GetConVarFlags(cvar);
	if(!enabled) {
		SetConVarFlags(cvar, flags^(FCVAR_NOTIFY|FCVAR_REPLICATED));
		SetConVarBool(cvar, true);
	}
	FakeClientCommandEx(client, "%s", cmd);
	if(!enabled) {
		SetConVarBool(cvar, false);
		SetConVarFlags(cvar, flags);
    }
}

public Action:Command_Thirdperson(client, args)
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

public Menu_Thirdperson(Handle:weapons, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[32];
		GetMenuItem(weapons, param2, info, sizeof(info));
		PerformCheatCommand(param1, info);
	}
}