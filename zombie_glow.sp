#include <sourcemod>
#include <sdktools>
#include <lib_mcv>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Glow"
#define PLUGIN_DESCRIPTION "全新僵尸高亮王一代"
#define GLOW_MODEL         "models/tools/axis/axis.mdl"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

ConVar    g_pGlowCount;

ArrayList g_aryGlowEntity;

void      ClearGlowEntity()
{
    for (int i = 0; i < g_aryGlowEntity.Length; i++)
    {
        int ent = g_aryGlowEntity.Get(i);
        if (IsValidEntity(ent))
            RemoveEntity(ent);
    }
    g_aryGlowEntity.Clear();
}

public void OnZombieKilled(int zombie, char[] classname, int attacker, char[] weapon_name, char[] weapon_id, int damagebits, bool headshot, bool backblast, int penetrated, float killdistance)
{
    int count = ZM_GetZombieCount();
    if (count <= g_pGlowCount.IntValue)
    {
        ClearGlowEntity();
        for (int i = 0; i < count; i++)
        {
            int z = ZM_GetZombieByIndex(i);
            if (IsValidEntity(z))
            {
                int skin = CreateEntityByName("prop_dynamic");
                DispatchKeyValue(skin, "model", GLOW_MODEL);
                DispatchKeyValue(skin, "disablereceiveshadows", "1");
                DispatchKeyValue(skin, "disableshadows", "1");
                DispatchKeyValue(skin, "solid", "0");
                DispatchKeyValue(skin, "spawnflags", "256");
                SetEntProp(skin, Prop_Send, "m_CollisionGroup", 11);
                DispatchSpawn(skin);
                SetEntityRenderMode(skin, RENDER_TRANSADD);
                SetEntityRenderColor(skin, 255, 255, 255, 0);
                SetEntPropFloat(skin, Prop_Send, "m_flGlowMaxDist", 8192.0);
                SetEntProp(skin, Prop_Send, "m_bShouldGlow", 1);
                SetEntProp(skin, Prop_Send, "m_clrGlow", 0xFFFFFFFF);
                SetEntPropFloat(skin, Prop_Send, "m_flModelScale", 2.0);
                MCV_FollowEntity(skin, z, false);
                g_aryGlowEntity.Push(skin);
            }
        }
    }
}

public void OnZombiePhaseChanged(int phase)
{
    if (phase == ZM_PHASE_WAITING)
        ClearGlowEntity();
}

public void OnMapInit(const char[] mapName)
{
    g_aryGlowEntity.Clear();
    PrecacheModel(GLOW_MODEL);
}

public void OnPluginStart()
{
    g_aryGlowEntity = new ArrayList();
    g_pGlowCount    = CreateConVar("sm_zombie_glow_count", "15", "Count that zombie mark glow", 0);
}

public void OnPluginEnd()
{
    g_aryGlowEntity.Close();
    g_pGlowCount.Close();
}