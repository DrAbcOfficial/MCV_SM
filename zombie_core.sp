#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Core"
#define PLUGIN_DESCRIPTION "全新僵尸核心王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateNative("ZM_GetMoney", Native_GetMoney);
    CreateNative("ZM_SetMoney", Native_SetMoney);
    CreateNative("ZM_AddMoney", Native_AddMoney);

    CreateNative("ZM_GetZombieCount", Native_GetZombieCount);
    CreateNative("ZM_GetZombieByIndex", Native_GetZombieByIndex);

    CreateNative("ZM_GetPhase", Native_GetZombiePhase);

    RegPluginLibrary("Zombie Core");
    return APLRes_Success;
}

stock bool NativeCheck_IsClientValid(int client)
{
    if (client <= 0 || client > MaxClients)
    {
        ThrowNativeError(SP_ERROR_NATIVE, "Client index %i is invalid", client);
        return false;
    }
    if (!IsClientInGame(client))
    {
        ThrowNativeError(SP_ERROR_NATIVE, "Client %i is not in game", client);
        return false;
    }
    return true;
}

// 玩家金币维护
// undefined4 __thiscall CVietnam_Player::GetCredits(CVietnam_Player *this)
// {
//   return *(undefined4 *)(this + 0x21d8);
// }
public int Native_GetMoney(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if (NativeCheck_IsClientValid(client))
    {
        int money = GetEntData(client, 0x21d8);
        return money;
    }
    return INVALID_ENT_REFERENCE;
}

public int Native_SetMoney(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if (NativeCheck_IsClientValid(client))
    {
        int money = GetNativeCell(2);
        SetEntData(client, 0x21d8, money);
    }
    return INVALID_ENT_REFERENCE;
}

public int Native_AddMoney(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if (NativeCheck_IsClientValid(client))
    {
        int money = GetEntData(client, 0x21d8);
        int add   = GetNativeCell(2);
        SetEntData(client, 0x21d8, money + add);
    }
    return INVALID_ENT_REFERENCE;
}

// 僵尸列表维护
ArrayList g_aryZombies;

public int Native_GetZombieCount(Handle plugin, int args)
{
    return g_aryZombies.Length;
}

public int Native_GetZombieByIndex(Handle plugin, int args)
{
    int index = GetNativeCell(1);
    if (index >= g_aryZombies.Length)
        return INVALID_ENT_REFERENCE;
    int zombie = g_aryZombies.Get(index);
    return zombie;
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

int           g_iZombiePhase = ZM_PHASE_WAITING;
GlobalForward g_pPhaseChangedForward;
//僵尸状态维护
Action        Event_PhaseChange(Handle event, const char[] name, bool dontBroadcast)
{
    // 0 = buy time
    // 1 = fight time
    g_iZombiePhase = GetEventInt(event, "phase");

    Call_StartForward(g_pPhaseChangedForward);
    Call_PushCell(g_iZombiePhase);
    Call_Finish();

    return Plugin_Continue;
}

public int Native_GetZombiePhase(Handle plugin, int args)
{
    return g_iZombiePhase;
}

// 僵尸死亡forward
GlobalForward g_pZombieKilledForward;
Action        Event_ZombieKilled(Handle event, const char[] name, bool dontBroadcast)
{
    int  zombie = GetEventInt(event, "entindex_killed");
    char classname[64];
    GetEntityClassname(zombie, classname, sizeof(classname));
    if (!strncmp(classname, "nb_zombie", 9))
    {
        int attacker   = GetEventInt(event, "entindex_attacker");
        int inflictor  = GetEventInt(event, "entindex_inflictor");
        int damagebits = GetEventInt(event, "damagebits");
        Call_StartForward(g_pZombieKilledForward);
        Call_PushCell(zombie);
        Call_PushCell(attacker);
        Call_PushCell(inflictor);
        Call_PushCell(damagebits);
        Call_Finish();
    }
    return Plugin_Continue;
}

public void OnPluginStart()
{
    g_aryZombies           = new ArrayList();

    g_pPhaseChangedForward = new GlobalForward("OnZombiePhaseChanged", ET_Ignore, Param_Cell);

    g_pZombieKilledForward = new GlobalForward("OnZombieKilled", ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Cell);

    HookEvent("zm_phase_change", Event_PhaseChange, EventHookMode_Pre);
    HookEvent("entity_killed", Event_ZombieKilled, EventHookMode_Post);
}

public void OnPluginEnd()
{
    g_aryZombies.Clear();
}