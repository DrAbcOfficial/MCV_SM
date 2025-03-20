#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie DropCash"
#define PLUGIN_DESCRIPTION "全新僵尸丢钱王一代"
#define CASH_MODEL         "models/entities/money_pack.mdl"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

ArrayList g_aryCashed;

Action    OnCashTouched(int entity, int other)
{
    
    if (other > 0 && other <= MaxClients && IsClientInGame(other))
    {
        int owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
        int count = GetEntData(entity, 0x304);
        if (other != owner)
        {
            char buffer[64];
            GetClientName(owner, buffer, sizeof(buffer));
            PrintToChat(other, "你捡到了来自%s丢出的%d元钞票，快谢谢他吧！", buffer, count);
        }
        ZM_AddMoney(other, count);
        RemoveEntity(entity);
    }
    return Plugin_Handled;
}

public void OnEntityDestroyed(int entity)
{
    if (g_aryCashed.FindValue(entity) != -1)
    {
        g_aryCashed.Erase(entity);
        SDKUnhook(entity, SDKHook_Touch, OnCashTouched);
    }
}

Action Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
    for (int i = 0; i < g_aryCashed.Length; i++)
    {
        int cash = g_aryCashed.Get(i);
        RemoveEntity(cash);
    }
    g_aryCashed.Clear();
    return Plugin_Continue;
}

public Action Command_DropMoney(int client, int args)
{
    int count = 500;
    if (args > 0)
    {
        count = GetCmdArgInt(1);
        if (count <= 0)
        {
            ReplyToCommand(client, "不想撒钱就不要丢嘛");
            return Plugin_Continue;
        }
    }
    int money = ZM_GetMoney(client);
    if (money < count)
    {
        ReplyToCommand(client, "丢啊，无钱还充大佬打%d元啊", count);
        return Plugin_Handled;
    }
    int cash = CreateEntityByName("physics_prop");
    DispatchKeyValue(cash, "model", CASH_MODEL);
    DispatchKeyValue(cash, "disablereceiveshadows", "1");
    DispatchKeyValue(cash, "disableshadows", "1");
    DispatchKeyValue(cash, "mins", "-16 -16 -24");
    DispatchKeyValue(cash, "maxs", "16 16 24");
    DispatchSpawn(cash);
    SetEntityOwner(cash, client);
    SetEntityHealth(cash, count);
    SetEntProp(cash, Prop_Send, "m_hOwnerEntity", client);
    SetEntPropFloat(cash, Prop_Send, "m_flModelScale", 1.3);
    float org[3];
    float ang[3];
    float vec[3];
    GetClientAbsAngles(client, ang);
    GetClientAbsOrigin(client, org);
    GetAngleVectors(ang, vec, NULL_VECTOR, NULL_VECTOR);
    vec[2] = 300.0;
    vec[0] *= 300;
    vec[1] *= 300;
    TeleportEntity(cash, org, ang, vec);
    SDKHook(cash, SDKHook_Touch, OnCashTouched);
    ZM_AddMoney(client, -count);
    return Plugin_Handled;
}

public void OnPluginStart()
{
    g_aryCashed = new ArrayList();
    RegConsoleCmd("sm_zombie_dropcash", Command_DropMoney, "Drop money");
    HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
}

public void OnMapInit(const char[] mapName)
{
    g_aryCashed.Clear();
    PrecacheModel(CASH_MODEL);
}