#include <zombie_core>
#include <sdktools>

#define PLUGIN_NAME        "Zombie Crow"
#define PLUGIN_DESCRIPTION "全新僵尸乌鸦王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

public void OnZombieSpawned(int zombie)
{
    char classname[64];
    GetEntityClassname(zombie, classname, sizeof(classname));
    if (!strcmp(classname, "nb_zombie_crow"))
    {
        DispatchKeyValue(zombie, "mins", "-16 -16 0");
        DispatchKeyValue(zombie, "maxs", "16 16 32");
        SetEntPropFloat(zombie, Prop_Send, "m_flModelScale", 2.0);
    }
}