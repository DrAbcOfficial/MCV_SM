#include <sdkhooks>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Persistence"
#define PLUGIN_DESCRIPTION "全新僵尸持续王一代"

// ridiculous, If a player exits and re enters with a different userid, he will lose his money
public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

StringMap g_dicPlayerMoneys;

public void OnMapInit(const char[] mapName)
{
    g_dicPlayerMoneys.Clear();
}

Action Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
    g_dicPlayerMoneys.Clear();
    return Plugin_Continue;
}

public void OnPluginStart()
{
    g_dicPlayerMoneys = new StringMap();
    HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
}

public void OnClientPutInServer(int client)
{
    char buffer[64];
    GetClientAuthId(client, AuthId_SteamID64, buffer, sizeof(buffer));
    if (g_dicPlayerMoneys.ContainsKey(buffer))
    {
        int money = 0;
        g_dicPlayerMoneys.GetValue(buffer, money);
        ZM_SetMoney(client, money);
    }
}

public void OnClientDisconnect(int client)
{
    char buffer[64];
    GetClientAuthId(client, AuthId_SteamID64, buffer, sizeof(buffer));
    g_dicPlayerMoneys.SetValue(buffer, ZM_GetMoney(client));
}