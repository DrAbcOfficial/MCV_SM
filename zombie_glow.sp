#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
public Plugin myinfo =
{
    name        = "Zombie Glow",
    author      = "Dr.Abc",
    description = "全新僵尸高亮王一代",
    version     = "Zombie Glow",
    url         = "Zombie Glow"
};
ArrayList g_aryZombies;
Action    Event_ZombieKilled(Handle event, const char[] name, bool dontBroadcast)
{
    if (g_aryZombies.Length <= 15)
    {
        for (int i = 0; i < g_aryZombies.Length; i++)
        {
            int zombie = g_aryZombies.Get(i);
            if (IsValidEntity(zombie))
            {
                SetEntProp(zombie, Prop_Send, "m_fEffects", 2);
            }
        }
    }
    return Plugin_Continue;
}
public void OnEntityCreated(int entity, const char[] classname)
{
    if (!strncmp(classname, "nb_zombie", 9, false))
    {
        g_aryZombies.Push(entity);
    }
}
public void OnEntityDestroyed(int entity)
{
    for (int i = 0; i < g_aryZombies.Length; i++)
    {
        if (g_aryZombies.Get(i) == entity)
        {
            g_aryZombies.Erase(i);
            return;
        }
    }
}

public Action Command_Nuke(int client, int args)
{
    for (int i = 0; i < g_aryZombies.Length; i++)
    {
        int zombie = g_aryZombies.Get(i);
        SDKHooks_TakeDamage(zombie, 0, 0, 999999999.0);
    }
    PrintToChatAll("[MCV]核平了所有僵尸....");
    return Plugin_Handled;
}
public void OnPluginStart()
{
    g_aryZombies = new ArrayList();
    HookEvent("entity_killed", Event_ZombieKilled, EventHookMode_Post);
    RegAdminCmd("sm_zombie_nuke", Command_Nuke, ADMFLAG_CONFIG, "Nuke all zombie");
}
public void OnPluginEnd()
{
    g_aryZombies.Clear();
}