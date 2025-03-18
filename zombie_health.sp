#include <sourcemod>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Health"
#define PLUGIN_DESCRIPTION "全新僵尸血量王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

ConVar g_pZombieHealth;
ConVar g_pZombieBurningHealth;


public void OnZombieSpawned(int zombie)
{
    char classname[64];
    GetEntityClassname(zombie, classname, sizeof(classname));
    if(!strcmp(classname, "nb_zombie"))
        SetEntityHealth(zombie, g_pZombieHealth.IntValue);
    else if(!strcmp(classname, "nb_zombie_burning"))
        SetEntityHealth(zombie, g_pZombieBurningHealth.IntValue);

}

public void OnPluginStart()
{
    g_pZombieHealth = CreateConVar("sm_zombie_health", "60", "Normal zombie health", 0);
    g_pZombieBurningHealth = CreateConVar("sm_zombie_burning_health", "60", "Normal zombie health", 0);
}

public void OnPluginEnd()
{
    g_pZombieHealth.Close();
    g_pZombieBurningHealth.Close();
}