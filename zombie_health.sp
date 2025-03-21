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

// fair zombie health
// original_health * (player_count * multi_cvar + 1)   ----> wtf?
// Normal   --->  Slow grow, easy to kill, one shot one kill
// f(x) = log(x+1)/2+1
// Armor    --->  Quick grow first, but slow with high player amout, headshot to kill, encourage player aim and shot
// f(x) = 2.5-(3/(x+1))   ---> lim x -> inf = 2.5
// Bloat    --->  Slow grow, but with high base health
// f(x) = (ln(x)/3*2) + 1 
// Bomber   --->  Slow grow, fair health, encourage player kill him first
// f(x) = 0.033(x-1) + 1
// Buffalo  --->  Fair grow, high base health, consider as a mini boss
// f(x) = 0.133(x-1) + 1
// Burning  --->  Slow grow, low health, high speed and high damage, must kill first
// f(x) = 0.033(x-1) + 1
// Crow     --->  Never grow, one shot one kill
// f(x) = n
// Dog      --->  Quick grow first, but slow with high player amout
// f(x) = 2-(2/(x+1))   ---> lim x -> inf = 2
// Gun      --->  Quick grow, this is a mini boss
// f(x) = 0.2(x-1) + 1
// Havoc    --->  Quick grow, and drop money for everyone, this is a boss
// f(x) = 0.2(x-1) + 1
// Orange   --->  Fair grow, with very high base health, and drop money for everyone, this is a boss
// f(x) = 0.133(x-1) + 1
// Ranged   --->  Fair grow, with low health, this one is hard for little amount players
// f(x) = 0.1(x-1) + 1
// Screamer --->  Quick grow, or this one will never has a change to shout
// f(x) = 0.2(x-1) + 1
// Slasher  --->  Fair grow
// f(x) = 0.086(x-1) + 1

public void OnZombieSpawned(int zombie)
{
    int type = ZM_GetZombieType(zombie);
    float ratio = 1.0;

}

public void OnPluginStart()
{

}

public void OnPluginEnd()
{

}