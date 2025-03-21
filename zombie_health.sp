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

ConVar g_pNormalHealth;
ConVar g_pArmorHealth;
ConVar g_pBloatHealth;
ConVar g_pBomberHealth;
ConVar g_pBuffaloHealth;
ConVar g_pBurningHealth;
ConVar g_pCrowHealth;
ConVar g_pDogHealth;
ConVar g_pGunHealth;
ConVar g_pHavocHealth;
ConVar g_pOrangeHealth;
ConVar g_pRangedHealth;
ConVar g_pScreamerHealth;
ConVar g_pSlasherHealth;

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
    int type  = ZM_GetZombieType(zombie);
    int amout = 0;
    for (int i = 1; i <= MaxClients; i++)
    {
        if (ZM_IsClientValid(i) && GetClientTeam(i) > 1)
            amout++;
    }
    float ratio = 1.0;
    int   base  = 0;
    switch (type)
    {
        case ZOMBIE_TYPE_INVALID: return;
        case ZOMBIE_TYPE_NORNAML:
        {
            ratio = Logarithm(amout + 1) / 2 + 1;
            base  = g_pNormalHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_ARMOR:
        {
            ratio = 2.5 - (3 / (amout + 1));
            base  = g_pArmorHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_BLOAT:
        {
            ratio = (Logarithm(amout, 2.718) / 3 * 2) + 1;
            base  = g_pBloatHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_BOMBER:
        {
            ratio = 0.033(amout - 1) + 1;
            base  = g_pBomberHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_BUFFALO:
        {
            ratio = 0.133(amout - 1) + 1;
            base  = g_pBuffaloHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_BURNING:
        {
            ratio = 0.033(amout - 1) + 1;
            base  = g_pBurningHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_CROW:
        {
            ratio = 1.0;
            base  = g_pCrowHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_DOG:
        {
            ratio = 2 - (2 / (amout + 1));
            base  = g_pDogHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_GUN:
        {
            ratio = 0.2(amout - 1) + 1;
            base  = g_pGunHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_HAVOC:
        {
            ratio = 0.033(amout - 1) + 1;
            base  = g_pHavocHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_ORANGE:
        {
            ratio = 0.133(amout - 1) + 1;
            base  = g_pOrangeHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_RANGED:
        {
            ratio = 0.1(amout - 1) + 1;
            base  = g_pRangedHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_SCREAMER:
        {
            ratio = 0.2(amout - 1) + 1;
            base  = g_pScreamerHealth.IntValue;
            break;
        }
        case ZOMBIE_TYPE_SLASHER:
        {
            ratio = 0.086(amout - 1) + 1;
            base  = g_pSlasherHealth.IntValue;
            break;
        }
    }

    float health = base * ratio;
    SetEntityHealth(zombie, health);
}

public void OnPluginStart()
{
    g_pNormalHealth   = FindConVar("zombie_health_regular");
    g_pArmorHealth    = FindConVar("zombie_health_armor");
    g_pBloatHealth    = FindConVar("zombie_health_bloat");
    g_pBomberHealth   = FindConVar("zombie_health_bomber");
    g_pBuffaloHealth  = FindConVar("zombie_health_buffalo");
    g_pBurningHealth  = FindConVar("zombie_health_burning");
    g_pCrowHealth     = FindConVar("zombie_health_crow");
    g_pDogHealth      = FindConVar("zombie_health_dog");
    g_pGunHealth      = FindConVar("zombie_health_gun");
    g_pHavocHealth    = FindConVar("zombie_health_havoc");
    g_pOrangeHealth   = FindConVar("zombie_health_orange");
    g_pRangedHealth   = FindConVar("zombie_health_ranged");
    g_pScreamerHealth = FindConVar("zombie_health_screamer");
    g_pSlasherHealth  = FindConVar("zombie_health_slasher");
}

public void OnPluginEnd()
{
}