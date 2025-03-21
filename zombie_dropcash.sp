#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie DropCash"
#define PLUGIN_DESCRIPTION "全新僵尸丢钱王二代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

ArrayList g_aryCashed;
ConVar    g_pCashCount;

public void OnCashPickup(int cash, int other, int& owner, int& count)
{
    int index = g_aryCashed.FindValue(cash);
    if (index != -1)
    {
        if (other != owner && ZM_IsClientValid(owner))
        {
            char buffer[64];
            GetClientName(owner, buffer, sizeof(buffer));
            PrintToChat(other, "你捡到了来自%s丢出的%d元钞票，快谢谢他吧！", buffer, count);
        }
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
    int count = g_pCashCount.IntValue;
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
    float org[3];
    float ang[3];
    float vec[3];
    GetClientAbsAngles(client, ang);
    GetClientAbsOrigin(client, org);
    GetAngleVectors(ang, vec, NULL_VECTOR, NULL_VECTOR);
    vec[2] = 300.0;
    vec[0] *= 300;
    vec[1] *= 300;
    ZM_AddMoney(client, -count);
    int cash = ZM_CreateCash(client, count, org, ang, vec);
    g_aryCashed.Push(cash);
    return Plugin_Handled;
}

public void MapInit(const char[] mapname)
{
    g_aryCashed.Clear();
}

public void OnPluginStart()
{
    g_aryCashed  = new ArrayList();
    g_pCashCount = CreateConVar("sm_zombie_default_cash_count", "500", "Default count for drop cash", 0);
    RegConsoleCmd("sm_zombie_dropcash", Command_DropMoney, "Drop money");
    HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
}