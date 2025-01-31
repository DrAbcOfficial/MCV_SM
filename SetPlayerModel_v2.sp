#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
    name        = "Model menu",
    author      = "Dr.Abc",
    description = "Model menu",
    version     = "Model menu",
    url         = "Model menu"
};

// Menus
Menu      g_pRootMenu;
StringMap g_dicMenus;

const int MAX_CLIENT_INDEX = 33;

// Model and list
StringMap g_dicModels;

// Player chosed
StringMap g_dicPlayerModels;

bool      IsValidClient(int client)
{
    if (client > 33 || client < 1)
        return false;
    if (!IsValidEntity(client))
        return false;
    return IsClientInGame(client);
}
void ChangePlayerModel(int client, char[] model)
{
    if (IsPlayerAlive(client))
    {
        SetEntityModel(client, model);
        int team = GetEntProp(client, Prop_Send, "m_iTeamNum");
        if (team == 3)
        {
            SetEntProp(client, Prop_Send, "m_nSkin", 1);
        }
        else
        {
            SetEntProp(client, Prop_Send, "m_nSkin", 0);
        }
    }
}

public Action Command_ModelMenu(int client, int args)
{
    if (!IsValidClient(client))
    {
        return Plugin_Handled;
    }
    g_pRootMenu.ExitButton = true;
    g_pRootMenu.Display(client, 240);
    return Plugin_Handled;
}

public void MenuHandler_ChangeModel(Menu menu, MenuAction action, int client, int slot)
{
    if (action == MenuAction_Select)
    {
        char info[PLATFORM_MAX_PATH];
        char display[64];
        int style;
        menu.GetItem(slot, info, sizeof(info), style, display, sizeof(display));
    
        ChangePlayerModel(client, info);
        char steamid[64];
        GetClientAuthId(client, AuthId_SteamID64, steamid, sizeof(steamid));
        g_dicPlayerModels.SetString(steamid, info, true);
        PrintToChat(client, "你正在使用\x03 %s", display);
    }
}

public void MenuHandler_SubMenu(Menu menu, MenuAction action, int client, int slot)
{
    if (action == MenuAction_Select)
    {
        char infobuf[64];
        menu.GetItem(slot, infobuf, sizeof(infobuf));
        if (g_dicMenus.ContainsKey(infobuf))
        {
            Menu sub;
            g_dicMenus.GetValue(infobuf, sub);
            sub.Display(client, 60);
        }
    }
}

void Timer_LazyChangePlayerModel(Handle timer, int client)
{
    char steamid[64];
    GetClientAuthId(client, AuthId_SteamID64, steamid, sizeof(steamid));
    char model[PLATFORM_MAX_PATH];
    g_dicPlayerModels.GetString(steamid, model, sizeof(model));
    ChangePlayerModel(client, model);
}
void Timer_LazyBOTChangePlayerModel(Handle timer, int client)
{
    StringMapSnapshot keys = g_dicModels.Snapshot();
    char              key[64];
    keys.GetKey(GetRandomInt(0, g_dicModels.Size - 1), key, sizeof(key));
    char model[PLATFORM_MAX_PATH];
    g_dicModels.GetString(key, model, sizeof(model));
    ChangePlayerModel(client, model);
}

Action Event_PlayerSpawnAndClass(Handle event, const char[] name, bool dontBroadcast)
{
    int  client = GetClientOfUserId(GetEventInt(event, "userid"));
    char steamid[64];
    GetClientAuthId(client, AuthId_SteamID64, steamid, sizeof(steamid));
    if (g_dicPlayerModels.ContainsKey(steamid))
    {
        CreateTimer(0.1, Timer_LazyChangePlayerModel, client);
    }
    else if (IsFakeClient(client))
    {
        int rand = GetRandomInt(0, 100);
        if (rand > 50)
        {
            CreateTimer(0.1, Timer_LazyBOTChangePlayerModel, client);
        }
    }
    return Plugin_Handled;
}

public void OnMapInit()
{
    if (g_dicModels.Size <= 0)
        return;
    StringMapSnapshot keys = g_dicModels.Snapshot();

    for (int i = 0; i < g_dicModels.Size; i++)
    {
        char key[64];
        char buffer[PLATFORM_MAX_PATH];
        keys.GetKey(i, key, sizeof(key));
        g_dicModels.GetString(key, buffer, sizeof(buffer));
        PrecacheModel(buffer, true);
    }
}

public void OnPluginStart()
{
    g_dicPlayerModels = new StringMap();
    g_dicModels       = new StringMap();
    g_dicMenus        = new StringMap();
    // Set Menu Title
    g_pRootMenu       = new Menu(MenuHandler_SubMenu);
    g_pRootMenu.SetTitle("玩家模型菜单");
    // Read Menu config
    KeyValues kv = CreateKeyValues("models");
    kv.ImportFromFile("cfg/xuebao_models.vdf");
    if (!kv.GotoFirstSubKey())
    {
        return;
    }
    do
    {
        char name[64];
        char buffer[PLATFORM_MAX_PATH];
        kv.GetSectionName(name, sizeof(name));
        kv.GetString("model", buffer, sizeof(buffer));
        g_dicModels.SetString(name, buffer);
        char cat[64];
        kv.GetString("category", cat, sizeof(cat));
        Menu sub;
        if (g_dicMenus.ContainsKey(cat))
        {
            g_dicMenus.GetValue(cat, sub);
        }
        else
        {
            sub = new Menu(MenuHandler_ChangeModel  );
            sub.SetTitle(cat);
            g_dicMenus.SetValue(cat, sub);
            g_pRootMenu.AddItem(cat, cat);
        }
        sub.AddItem(buffer, name);
        if(sub.ItemCount > 10)
        {
            LogError("Category %s has more than 10 models! please create a new category!");
        }

        PrecacheModel(buffer, true);
    }
    while (kv.GotoNextKey());
    kv.DeleteThis();

    HookEvent("player_spawn", Event_PlayerSpawnAndClass, EventHookMode_Post);
    HookEvent("player_class", Event_PlayerSpawnAndClass, EventHookMode_Post);

    RegConsoleCmd("sm_equip", Command_ModelMenu, "Open Model Menu");
}