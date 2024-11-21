#include <sourcemod>
#include <sdktools>
#define PLUGIN_VERSION "01.01"

public Plugin:myinfo =
{
	name = "MCV Init Health",
	author = "dr.abc",
	description = "dr.abc",
	version = PLUGIN_VERSION,
	url = "in ur face"
}

Handle g_pInitHealth;
public OnPluginStart()
{
	g_pInitHealth = CreateConVar("sk_player_inithealth", "100", "Player init health");
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
}

public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	SetEntityHealth(client, GetConVarInt(g_pInitHealth));
	return Plugin_Continue;
}