#include <sdkhooks>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Nuke"
#define PLUGIN_DESCRIPTION "全新僵尸核弹王二代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

void Nuke()
{
    for (int i = 0; i < ZM_GetZombieCount(); i++)
    {
        int zb = ZM_GetZombieByIndex(i);
        SDKHooks_TakeDamage(zb, 0, 0, 999999999.0);
    }
}

public Action Command_Nuke(int client, int args)
{
    Nuke();
    PrintToChatAll("[MCV]核平了所有僵尸....");
    return Plugin_Handled;
}

public Action Command_Skip(int client, int args)
{
    Nuke();
    ZM_SetReaminingEnemies(0);
    PrintToChatAll("[MCV]跳过了本波....");
    return Plugin_Handled;
}

public Action Command_Wave(int client, int args)
{
    if (args <= 0)
        return Plugin_Handled;
    int num = GetCmdArgInt(1);
    Nuke();
    ZM_SetReaminingEnemies(0);
    ZM_SetWaveNum(num);
    PrintToChatAll("[MCV]已跳过至%d波.", num);
    return Plugin_Handled;
}

public void OnPluginStart()
{
    RegAdminCmd("sm_zombie_nuke", Command_Nuke, ADMFLAG_CONFIG, "Nuke all zombie");
    RegAdminCmd("sm_zombie_skip", Command_Skip, ADMFLAG_CONFIG, "Skip this wave");
    RegAdminCmd("sm_zombie_wave", Command_Wave, ADMFLAG_CONFIG, "Set wave num");
}