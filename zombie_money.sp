#include <sourcemod>
#include <sdktools>
#include <zmboie_core>
public Plugin myinfo =
{
    name        = "Zombie Money",
    author      = "Dr.Abc",
    description = "全新僵尸金币王一代",
    version     = "Zombie Money",
    url         = "Zombie Money"
};

ConVar g_pPlayerDeathIncome;
ConVar g_pPlayerSurvivedIncome;


Action    Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
    int  client = GetClientOfUserId(GetEventInt(event, "userid"));
    if(IsClientInGame(client))
    {
        int add = g_pPlayerDeathIncome.IntValue;
        ZM_AddMoney(client, add);
        PrintToChat(client, "[MCV]你死了，获得了%d元抚恤金。", add);
    }
    return Plugin_Continue;
}
Action    Event_PhaseChange(Handle event, const char[] name, bool dontBroadcast)
{
    //0 = buy time
    //1 = fight time
    int  phase = GetEventInt(event, "phase");
    if(phase == 0)
    {
        for(int i = 1; i <= MaxClients; i++)
        {
            if(IsValidEntity(i) && IsClientInGame(i))
            {
                int add= g_pPlayerSurvivedIncome.IntValue;
                ZM_AddMoney(i, add);
                PrintToChat(i, "[MCV]你获得了%d元工资。", add);
            }
        }
    }
    return Plugin_Continue;
}
public void OnPluginStart()
{
    g_pPlayerSurvivedIncome  = CreateConVar("sm_zombie_survived_income", "750", "Money when player survived", 0);
    g_pPlayerDeathIncome = CreateConVar("sm_zombie_died_income", "750", "Money when player died", 0);
    HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
    HookEvent("zm_phase_change", Event_PhaseChange, EventHookMode_Pre);
}
