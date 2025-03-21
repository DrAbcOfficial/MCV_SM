#include <sourcemod>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Money"
#define PLUGIN_DESCRIPTION "全新僵尸金币王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

ConVar g_pPlayerDeathIncome;
ConVar g_pPlayerSurvivedIncome;
ConVar g_pPlayerHeadshotIncome;
ConVar g_pPlayerBackblastIncome;

public void OnZombiePhaseChanged(int phase)
{
    if (phase == ZM_PHASE_WAITING)
    {
        for (int i = 1; i <= MaxClients; i++)
        {
            if (ZM_IsClientValid(i))
            {
                int add = g_pPlayerSurvivedIncome.IntValue;
                ZM_AddMoney(i, add);
                PrintCenterText(i, "你获得了%d元工资。", add);
            }
        }
    }
}

public void OnZombieKilled(int zombie, char[] classname, int attacker, char[] weapon_name, char[] weapon_id, 
                        int damagebits, bool headshot, bool backblast, int penetrated, float killdistance)
{
    if(headshot)
    {
        int add = g_pPlayerHeadshotIncome.IntValue;
        ZM_AddMoney(attacker, add);
        PrintCenterText(attacker, "爆头奖励%d元！", add);
    }
    if(backblast)
    {
        int add = g_pPlayerBackblastIncome.IntValue;
        ZM_AddMoney(attacker, add);
        PrintCenterText(attacker, "尾气击杀！奖励%d元。", add);
    }
}

Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
    if (ZM_GetPhase() == ZM_PHASE_WAITING)
        return Plugin_Continue;
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (ZM_IsClientValid(client))
    {
        int add = g_pPlayerDeathIncome.IntValue;
        ZM_AddMoney(client, add);
        PrintCenterText(client, "你死了，获得了%d元抚恤金。", add);
    }
    return Plugin_Continue;
}

public void OnPluginStart()
{
    g_pPlayerSurvivedIncome = CreateConVar("sm_zombie_survived_income", "500", "Money when player survived", 0);
    g_pPlayerDeathIncome    = CreateConVar("sm_zombie_died_income", "750", "Money when player died", 0);
    g_pPlayerHeadshotIncome    = CreateConVar("sm_zombie_headshot_income", "100", "Money when headshot", 0);
    g_pPlayerBackblastIncome    = CreateConVar("sm_zombie_backblast_income", "1500", "Money when backblast", 0);
    HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
}

public void OnPluginEnd()
{
    g_pPlayerSurvivedIncome.Close();
    g_pPlayerDeathIncome.Close();
    g_pPlayerHeadshotIncome.Close();
    g_pPlayerBackblastIncome.Close();
    UnhookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
}
