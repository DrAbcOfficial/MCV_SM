#include <sdkhooks>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Nuke"
#define PLUGIN_DESCRIPTION "全新僵尸核弹王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

public Action Command_Nuke(int client, int args)
{
    for (int i = 0; i < ZM_GetZombieCount(); i++)
    {
        int zb = ZM_GetZombieByIndex(i);
        SDKHooks_TakeDamage(zb, 0, 0, 999999999.0);
    }
    PrintToChatAll("[MCV]核平了所有僵尸....");
    return Plugin_Handled;
}

public void OnPluginStart()
{
    RegAdminCmd("sm_zombie_nuke", Command_Nuke, ADMFLAG_CONFIG, "Nuke all zombie");
}