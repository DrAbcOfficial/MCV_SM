#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Core"
#define PLUGIN_DESCRIPTION "全新僵尸核心王四代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

// 玩家金币维护
// undefined4 __thiscall CVietnam_Player::GetCredits(CVietnam_Player *this)
// {
//   return *(undefined4 *)(this + 0x21d8);
// }
public int Native_GetMoney(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if (ZM_IsClientValid(client))
    {
        int money = GetEntData(client, 0x21d8);
        return money;
    }
    return INVALID_ENT_REFERENCE;
}

public int Native_SetMoney(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if (ZM_IsClientValid(client))
    {
        int money = GetNativeCell(2);
        SetEntData(client, 0x21d8, money);
    }
    return INVALID_ENT_REFERENCE;
}

public int Native_AddMoney(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if (ZM_IsClientValid(client))
    {
        int money = GetEntData(client, 0x21d8);
        int add   = GetNativeCell(2);
        SetEntData(client, 0x21d8, money + add);
    }
    return INVALID_ENT_REFERENCE;
}

// 玩家重量维护
// undefined4 __thiscall CVietnam_Player::GetCarriedWeaponsWeight(CVietnam_Player *this)
//{
//  return *(undefined4 *)(this + 0x21dc);
//}
public int Native_GetWeight(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if (ZM_IsClientValid(client))
    {
        int weight = GetEntData(client, 0x21dc);
        return weight;
    }
    return INVALID_ENT_REFERENCE;
}

public int Native_SetWeight(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if (ZM_IsClientValid(client))
    {
        int weight = GetNativeCell(2);
        SetEntData(client, 0x21dc, weight);
    }
    return INVALID_ENT_REFERENCE;
}

public int Native_AddWeight(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if (ZM_IsClientValid(client))
    {
        int weight = GetEntData(client, 0x21dc);
        int add    = GetNativeCell(2);
        SetEntData(client, 0x21dc, weight + add);
    }
    return INVALID_ENT_REFERENCE;
}

// 僵尸列表维护及僵尸Spawn Forward
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

GlobalForward g_pZombieSpawnForward;

public void ZombieSpawn_Post(int entity)
{
    Call_StartForward(g_pZombieSpawnForward);
    Call_PushCell(entity);
    Call_Finish();
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
GlobalForward g_pZombieKilledPostForward;
Action        Event_ZombieKilled(Handle event, const char[] name, bool dontBroadcast)
{
    char othertype[64];
    GetEventString(event, "othertype", othertype, sizeof(othertype));
    if (!strncmp(othertype, "nb_zombie", 9))
    {
        int  zombie   = GetEventInt(event, "otherid");
        int  attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
        char weaponname[64];
        GetEventString(event, "weapon", weaponname, sizeof(weaponname));
        char weapon_itemid[64];
        GetEventString(event, "weapon_itemid", weapon_itemid, sizeof(weapon_itemid));
        int   damagebits   = GetEventInt(event, "damagetype");
        bool  headshot     = GetEventBool(event, "headshot");
        bool  backblast    = GetEventBool(event, "backblast");
        int   penetrated   = GetEventInt(event, "penetrated");
        float killdistance = GetEventFloat(event, "killdistance");

        Call_StartForward(g_pZombieKilledForward);
        Call_PushCell(zombie);
        Call_PushString(othertype);
        Call_PushCell(attacker);
        Call_PushString(weaponname);
        Call_PushString(weapon_itemid);
        Call_PushCell(damagebits);
        Call_PushCell(headshot);
        Call_PushCell(backblast);
        Call_PushCell(penetrated);
        Call_PushCell(killdistance);
        Call_Finish();

        Call_StartForward(g_pZombieKilledPostForward);
        Call_PushCell(zombie);
        Call_PushStringEx(othertype, sizeof(othertype), SM_PARAM_STRING_UTF8 | SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
        Call_PushCell(attacker);
        Call_PushStringEx(weaponname, sizeof(weaponname), SM_PARAM_STRING_UTF8 | SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
        Call_PushStringEx(weapon_itemid, sizeof(weapon_itemid), SM_PARAM_STRING_UTF8 | SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
        Call_PushCell(damagebits);
        Call_PushCell(headshot);
        Call_PushCell(backblast);
        Call_PushCell(penetrated);
        Call_PushCell(killdistance);
        Call_Finish();

        SetEventString(event, "othertype", othertype);
        SetEventString(event, "weapon", weaponname);
        SetEventString(event, "weapon_itemid", weapon_itemid);
    }
    return Plugin_Continue;
}

//金币创建及PickupForward
#define CASH_MODEL "models/entities/money_pack.mdl"
ArrayList g_aryCashes;

public int Native_GetCashCount(Handle plugin, int args)
{
    return g_aryCashes.Length;
}

public int Native_GetCashByIndex(Handle plugin, int args)
{
    int index = GetNativeCell(1);
    if (index >= g_aryCashes.Length)
        return INVALID_ENT_REFERENCE;
    int c = g_aryCashes.Get(index);
    return c;
}
GlobalForward g_pCashPickupForward;
Action        OnCashTouched(int entity, int other)
{
    if (other > 0 && other <= MaxClients && ZM_IsClientValid(other))
    {
        int owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
        int count = GetEntData(entity, 0x304);

        Call_StartForward(g_pCashPickupForward);
        Call_PushCell(entity);
        Call_PushCell(other);
        Call_PushCellRef(owner);
        Call_PushCellRef(count);
        Call_Finish();

        ZM_AddMoney(other, count);
        RemoveEntity(entity);
    }
    return Plugin_Handled;
}
// native int ZM_CreateCash(int owner, int count, const float[] org,
//                           const float[] ang, const float[] vec)
public int Native_CreateCash(Handle plugin, int args)
{
    int   owner = GetNativeCell(1);
    int   count = GetNativeCell(2);
    float org[3];
    GetNativeArray(3, org, 3);
    float ang[3];
    GetNativeArray(4, ang, 3);
    float vec[3];
    GetNativeArray(5, vec, 3);

    int cash = CreateEntityByName("physics_prop");
    DispatchKeyValue(cash, "model", CASH_MODEL);
    DispatchKeyValue(cash, "disablereceiveshadows", "1");
    DispatchKeyValue(cash, "disableshadows", "1");
    DispatchKeyValue(cash, "mins", "-16 -16 -24");
    DispatchKeyValue(cash, "maxs", "16 16 24");
    DispatchSpawn(cash);
    if (IsValidEntity(owner))
    {
        SetEntProp(cash, Prop_Send, "m_hOwnerEntity", owner);
        SetEntityOwner(cash, owner);
    }
    SetEntityHealth(cash, count);
    SetEntPropFloat(cash, Prop_Send, "m_flModelScale", 1.3);
    TeleportEntity(cash, org, ang, vec);
    SDKHook(cash, SDKHook_Touch, OnCashTouched);
    return cash;
}

// Basic forward
void ClearCache()
{
    for (int i = 0; i < g_aryZombies.Length; i++)
    {
        SDKUnhook(i, SDKHook_SpawnPost, ZombieSpawn_Post);
    }
    for (int i = 0; i < g_aryCashes.Length; i++)
    {
        SDKUnhook(i, SDKHook_Touch, OnCashTouched);
    }
    g_aryCashes.Clear();
    g_aryZombies.Clear();
}

public void OnEntityCreated(int entity, const char[] classname)
{
    if (!strncmp(classname, "nb_zombie", 9, false))
    {
        g_aryZombies.Push(entity);
        SDKHook(entity, SDKHook_SpawnPost, ZombieSpawn_Post);
    }
}

public void OnEntityDestroyed(int entity)
{
    int z = g_aryZombies.FindValue(entity);
    if (z != -1)
    {
        SDKUnhook(entity, SDKHook_SpawnPost, ZombieSpawn_Post);
        g_aryZombies.Erase(z);
    }

    int c = g_aryCashes.FindValue(entity);
    if (c != -1)
    {
        g_aryCashes.Erase(c);
        SDKUnhook(entity, SDKHook_Touch, OnCashTouched);
    }
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateNative("ZM_GetMoney", Native_GetMoney);
    CreateNative("ZM_SetMoney", Native_SetMoney);
    CreateNative("ZM_AddMoney", Native_AddMoney);

    CreateNative("ZM_GetWeight", Native_GetWeight);
    CreateNative("ZM_SetWeight", Native_SetWeight);
    CreateNative("ZM_AddWeight", Native_AddWeight);

    CreateNative("ZM_GetZombieCount", Native_GetZombieCount);
    CreateNative("ZM_GetZombieByIndex", Native_GetZombieByIndex);

    CreateNative("ZM_GetPhase", Native_GetZombiePhase);

    CreateNative("ZM_GetCashCount", Native_GetCashCount);
    CreateNative("ZM_GetCashByIndex", Native_GetCashByIndex);
    CreateNative("ZM_CreateCash", Native_CreateCash);

    RegPluginLibrary("Zombie Core");
    return APLRes_Success;
}

public void OnPluginStart()
{
    g_aryZombies               = new ArrayList();
    g_aryCashes                = new ArrayList();

    g_pZombieSpawnForward      = new GlobalForward("OnZombieSpawned", ET_Ignore, Param_Cell);

    g_pPhaseChangedForward     = new GlobalForward("OnZombiePhaseChanged", ET_Ignore, Param_Cell);

    g_pZombieKilledForward     = new GlobalForward("OnZombieKilled", ET_Ignore, Param_Cell, Param_String, Param_Cell,
                                                   Param_String, Param_String, Param_Cell, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
    g_pZombieKilledPostForward = new GlobalForward("OnZombieKilledPost", ET_Ignore, Param_Cell, Param_String, Param_Cell,
                                                   Param_String, Param_String, Param_Cell, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
    g_pCashPickupForward       = new GlobalForward("OnCashPickup", ET_Ignore, Param_Cell, Param_Cell, Param_CellByRef, Param_CellByRef);

    HookEvent("zm_phase_change", Event_PhaseChange, EventHookMode_Pre);
    HookEvent("other_death", Event_ZombieKilled, EventHookMode_Pre);
}

public void OnMapInit(const char[] mapName)
{
    ClearCache();
    PrecacheModel(CASH_MODEL);
}

public void OnPluginEnd()
{
    ClearCache();
    g_pPhaseChangedForward.Close();
    g_pZombieKilledForward.Close();
    g_pZombieKilledPostForward.Close();
    g_pCashPickupForward.Close();
}