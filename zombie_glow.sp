#include <sourcemod>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Glow"
#define PLUGIN_DESCRIPTION "全新僵尸高亮王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

ConVar g_pGlowCount;

public void OnZombieKilled(int zombie, int attacker, int inflictor, int damagebits)
{
    int count = ZM_GetZombieCount();
    if (count <= g_pGlowCount.IntValue)
    {
        for (int i = 0; i < count; i++)
        {
            int z = ZM_GetZombieByIndex(i);
            if (IsValidEntity(z))
            {
                float org[3];
                GetEntPropVector(z, Prop_Send, "m_vecOrigin", org);
                Event event = CreateEvent("player_ping");
                if (event == null)
                    return;
                event.SetInt("userid", 0);
                event.SetInt("entityid", z);
                event.SetFloat("x", org[0]);
                event.SetFloat("y", org[1]);
                event.SetFloat("z", org[2]);
                event.Fire();
            }
        }
    }
}

public void OnPluginStart()
{
    g_pGlowCount = CreateConVar("sm_zombie_glow_count", "15", "Count that zombie mark glow", 0);
}