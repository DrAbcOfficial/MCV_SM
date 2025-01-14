#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "1.5"

#pragma semicolon 1

new Third[MAXPLAYERS+1];

public Plugin:myinfo = 
{
	name = "Thirdperson",
	author = "shavit",
	description = "Allow players/admins to toggle thirdperson on themselves/players.",
	version = PLUGIN_VERSION,
	url = "https://forums.alliedmods.net/member.php?u=163134"
}

public OnPluginStart()
{
	new Handle:Version = CreateConVar("sm_thirdperson_version", PLUGIN_VERSION, "Thirdperson's version", FCVAR_NOTIFY|FCVAR_PLUGIN|FCVAR_DONTRECORD);
	SetConVarString(Version, PLUGIN_VERSION, _, true);
	
	RegConsoleCmd("sm_thirdperson", Command_TP, "Toggle thirdperson");
	
	HookEvent("player_death", Player_Death);
	HookEvent("player_spawn", Player_Death);
	
	LoadTranslations("common.phrases");
	
	AutoExecConfig();
}



public Action:Command_TP(client, args)
{
	if(!IsValidClient(client))
	{
		return Plugin_Handled;
	}
	
	new target = client, String:arg1[MAX_TARGET_LENGTH];
	
	GetCmdArg(1, arg1, MAX_TARGET_LENGTH);
	
	
	if(CheckCommandAccess(client, "tptarget", ADMFLAG_SLAY) && args == 1)
	{
		target = FindTarget(client, arg1);
			
		if(target == -1)
		{
				return Plugin_Handled;
		}
			
		if(IsValidClient(target, true))
			{
				ShowActivity(client, "toggled thirdperson to %s for the player %N", client, Third[target]? "enabled":"disabled", target);
			}
			
			else if(!IsPlayerAlive(target))
			{
				ReplyToCommand(client, "\x04[SM]\x01 The target has to be alive.");
			}
			
			return Plugin_Handled;
	}
	
	if(IsValidClient(target, true))
	{
		Toggle(target);
		ReplyToCommand(client, "\x04[SM]\x01 You are in %sperson.", Third[client]? "third":"first");
		
		return Plugin_Handled;
	}
	
	else if(!IsPlayerAlive(target))
	{
		ReplyToCommand(client, "\x04[SM]\x01 You have to be alive to toggle your thirdperson mode.");
		
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action:Player_Death(Handle:event, String:name[], bool:dontBroadcast)
{
	OnClientPutInServer(GetClientOfUserId(GetEventInt(event, "userid")));
	
	return Plugin_Continue;
}

public OnClientPutInServer(client)
{
	Third[client] = false;
}

public Toggle(client)
{
	if(!Third[client])
	{
		SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", 0);
		SetEntProp(client, Prop_Send, "m_iObserverMode", 1);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 0);
		SetEntProp(client, Prop_Send, "m_iFOV", 120);
		Third[client] = true;
	}
	
	else
	{
		SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", client);
		SetEntProp(client, Prop_Send, "m_iObserverMode", 0);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 1);
		SetEntProp(client, Prop_Send, "m_iFOV", 90);
		Third[client] = false;
	}
}

stock bool:IsValidClient(client, bool:bAlive = false)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (bAlive == false || IsPlayerAlive(client)))
	{
		return true;
	}
	
	return false;
}