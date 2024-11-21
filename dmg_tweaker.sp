#include <sourcemod>
#include <clientprefs>
#include <sdktools_sound>

public Plugin myinfo =
{
	name = "Damage Tweaker",
	description = "Damage Tweaker",
	author = "Dr.Abc",
	version = "0.0",
	url = "in ur face"
}

Handle g_pDamageTweaker;
public void OnPluginStart()
{
	g_pDamageTweaker = CreateConVar("sk_playerdamage_tweaker", "1.0", "Toggle Player damage amount");
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
}

public Action:Event_PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	int remain = GetEventInt(event, "health");
	if(remain <= 0)
		return Plugin_Continue;
	int health = GetClientHealth(client);
	int dmg = health - remain;
	if(dmg <= 0)
		return Plugin_Continue;
	dmg = dmg * GetConVarFloat(g_pDamageTweaker);
	if(dmg <= 0)
		dmg = 1;
	int value = health - dmg;
	if(value <= 0)
		return Plugin_Continue;
	SetEventInt(event, "health", value);
	SetEntityHealth(client, value);
	return Plugin_Handled;
}