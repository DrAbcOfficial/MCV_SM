#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <zmboie_core>

public Plugin myinfo =
{
    name        = "Zombie Glow",
    author      = "Dr.Abc",
    description = "全新僵尸高亮王一代",
    version     = "Zombie Glow",
    url         = "Zombie Glow"
};
Action Event_ZombieKilled(Handle event, const char[] name, bool dontBroadcast)
{
    int count = ZM_GetZombieCount();
    if (count <= 15)
    {
        for (int i = 0; i < count; i++)
        {
            int zombie = ZM_GetZombieByIndex(i);
            if (IsValidEntity(zombie))
            {
                SetEntProp(zombie, Prop_Send, "m_fEffects", 2);
            }
        }
    }
    return Plugin_Continue;
}

public Action Command_Nuke(int client, int args)
{
    for (int i = 0; i < ZM_GetZombieCount(); i++)
    {
        SDKHooks_TakeDamage(ZM_GetZombieByIndex(i), 0, 0, 999999999.0);
    }
    PrintToChatAll("[MCV]核平了所有僵尸....");
    return Plugin_Handled;
}

public void OnPluginStart()
{
    HookEvent("entity_killed", Event_ZombieKilled, EventHookMode_Post);
    RegAdminCmd("sm_zombie_nuke", Command_Nuke, ADMFLAG_CONFIG, "Nuke all zombie");
}