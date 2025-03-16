#include <sourcemod>
#include <sdktools>
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

public void OnZombiePhaseChanged(int phase)
{
    if (phase == ZM_PHASE_WAITING)
    {
        for (int i = 1; i <= MaxClients; i++)
        {
            if (IsValidEntity(i) && IsClientInGame(i))
            {
                int add = g_pPlayerSurvivedIncome.IntValue;
                ZM_AddMoney(i, add);
                PrintToChat(i, "[MCV]你获得了%d元工资。", add);
            }
        }
    }
}

Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
    if (ZM_GetPhase() == ZM_PHASE_WAITING)
        return Plugin_Continue;
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (IsClientInGame(client))
    {
        int add = g_pPlayerDeathIncome.IntValue;
        ZM_AddMoney(client, add);
        PrintToChat(client, "[MCV]你死了，获得了%d元抚恤金。", add);
    }
    return Plugin_Continue;
}

public void OnPluginStart()
{
    g_pPlayerSurvivedIncome = CreateConVar("sm_zombie_survived_income", "750", "Money when player survived", 0);
    g_pPlayerDeathIncome    = CreateConVar("sm_zombie_died_income", "750", "Money when player died", 0);
    HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
}
