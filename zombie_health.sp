#include <sourcemod>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Health"
#define PLUGIN_DESCRIPTION "全新僵尸血量王二代"

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

// fair zombie health
// original_health * (player_count * multi_cvar + 1)   ----> wtf?
// Normal   --->  Slow grow, easy to kill, one shot one kill
// f(x) = log(x+1)/2+1
// Armor    --->  Quick grow first, but slow with high player amout, headshot to kill, encourage player aim and shot
// f(x) = (ln(x)/3*2) + 1
// Bloate   --->  Slow grow, but with high base health
// f(x) = 
// Bomber   --->  Slow grow, fair health, encourage player kill him first
// f(x) = 
// Buffalo  --->  Fair grow, high base health, consider as a mini boss
// f(x) = 
// Burning  --->  Slow grow, low health, high speed and high damage, must kill first
// f(x) = 
// Crow     --->  Never grow, one shot one kill
// f(x) = n
// Dog      --->  Quick grow first, but slow with high player amout
// f(x) = 
// Gun      --->  Quick grow, this is a mini boss
// f(x) = 
// Havoc    --->  Quick grow, and drop money for everyone, this is a boss
// f(x) = 
// Orange   --->  Fair grow, with very high base health, and drop money for everyone, this is a boss
// f(x) = 
// Ranged   --->  Fair grow, with low health, this one is hard for little amount players
// f(x) = 
// Screamer --->  Quick grow, or this one will never has a change to shout
// f(x) = 
// Slasher  --->  Fair grow
// f(x) = 

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