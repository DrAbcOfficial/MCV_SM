#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

public Plugin myinfo =
{
    name        = "Model menu",
    author      = "Dr.Abc",
    description = "Model menu",
    version     = "Model menu",
    url         = "Model menu"
};

Menu      g_pPlayerMenu;
const int MAX_CLIENT_INDEX = 33;

// Model and list
enum struct ModelInfo
{
    char player_model[PLATFORM_MAX_PATH];
    char hand_model[PLATFORM_MAX_PATH];
    char name[64];
}
int       g_iTotalModels = 0;
ModelInfo g_aryModels[256];

// Player chosed
int       g_aryPlayerChosed[MAX_CLIENT_INDEX];

// View Model List
int       g_aryViewModels[MAX_CLIENT_INDEX];

bool      IsValidClient(int client)
{
    if (client > 33 || client < 1)
        return false;
    if (!IsValidEntity(client))
        return false;
    return IsClientInGame(client);
}
void ChangePlayerModel(int client, ModelInfo model)
{
    if (IsPlayerAlive(client))
    {
        SetEntityModel(client, model.player_model);
        int team = GetEntProp(client, Prop_Send, "m_iTeamNum");
        if (team == 3)
        {
            DispatchKeyValue(client, "skin", "1");
            SetEntProp(client, Prop_Send, "m_nSkin", 1);
        }
        else
        {
            DispatchKeyValue(client, "skin", "0");
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
    g_pPlayerMenu.ExitButton = true;
    g_pPlayerMenu.Display(client, 240);
    return Plugin_Handled;
}

public void MenuHandler_ChangeModel(Menu menu, MenuAction action, int client, int slot)
{
    if (action == MenuAction_Select)
    {
        ChangePlayerModel(client, g_aryModels[slot]);
        g_aryPlayerChosed[client] = slot;
        PrintToChat(client, "你正在使用\x03 %s", g_aryModels[slot].name);
        int view = g_aryViewModels[client];
        if(IsValidEntity(view))
        {
           
        }
    }
}

void Timer_LazyChangePlayerModel(Handle timer, int client)
{
    ChangePlayerModel(client, g_aryModels[g_aryPlayerChosed[client]]);
}

Action Event_PlayerSpawnAndClass(Handle event, const char[] name, bool dontBroadcast)
{
    int client     = GetClientOfUserId(GetEventInt(event, "userid"));
    int modelindex = g_aryPlayerChosed[client];
    if (modelindex >= 0)
    {
        CreateTimer(0.1, Timer_LazyChangePlayerModel, client);
    }
    return Plugin_Handled;
}

Action Event_GameEnd(Handle event, const char[] name, bool dontBroadcast)
{
    for (int i = 1; i <= 33; i++)
    {
        if (IsValidClient(i))
        {
            int modelindex = g_aryPlayerChosed[i];
            if (modelindex >= 0)
            {
                CreateTimer(0.1, Timer_LazyChangePlayerModel, i);
            }
        }
    }
    return Plugin_Handled;
}

Action SDKHokk_ViewModelSpawnPost(int entity)
{
    int owner = GetEntDataEnt2(entity, 0x6c4);
    if (IsValidClient(owner))
    {
        g_aryViewModels[owner] = entity;
    }
    return Plugin_Handled;
}

public void OnEntityCreated(int entity, const char[] classname)
{
    if (!strcmp(classname, "vietnam_viewmodel"))
    {
        SDKHook(entity, SDKHook_SpawnPost, SDKHokk_ViewModelSpawnPost);
    }
}

public void OnEntityDestroyed(int entity)
{
    for (int i = 0; i < MAX_CLIENT_INDEX; i++)
    {
        if (g_aryViewModels[i] == entity)
        {
            g_aryViewModels[i] = -1;
            SDKUnhook(entity, SDKHook_SpawnPost, SDKHokk_ViewModelSpawnPost);
            return;
        }
    }
}

public void OnMapInit()
{
    if (g_iTotalModels <= 0)
        return;
    for (int i = 0; i < g_iTotalModels; i++)
    {
        PrecacheModel(g_aryModels[i].player_model, true);
        // not done yet
        // PrecacheModel(g_aryModels[i].hand_model, true);
    }
}

public void OnPluginStart()
{
    // Set Menu Title
    g_pPlayerMenu = new Menu(MenuHandler_ChangeModel);
    g_pPlayerMenu.SetTitle("玩家模型菜单");
    // Read Menu config
    KeyValues kv = CreateKeyValues("models");
    kv.ImportFromFile("cfg/xuebao_models.vdf");
    if (!kv.GotoFirstSubKey())
    {
        return;
    }
    do
    {
        kv.GetString("model", g_aryModels[g_iTotalModels].player_model, sizeof(g_aryModels[g_iTotalModels].player_model));
        kv.GetString("c_hand", g_aryModels[g_iTotalModels].hand_model, sizeof(g_aryModels[g_iTotalModels].hand_model));
        kv.GetString("name", g_aryModels[g_iTotalModels].name, sizeof(g_aryModels[g_iTotalModels].name));

        g_pPlayerMenu.AddItem(g_aryModels[g_iTotalModels].name, g_aryModels[g_iTotalModels].name);
        PrecacheModel(g_aryModels[g_iTotalModels].player_model, true);
        // not done yet
        // PrecacheModel(g_aryModels[g_iTotalModels].hand_model, true);
        g_iTotalModels++;
    }
    while (kv.GotoNextKey());
    // Set up player chosed
    for (int i = 0; i < MAX_CLIENT_INDEX; i++)
    {
        g_aryPlayerChosed[i] = -1;
        g_aryViewModels[i]   = -1;
    }
    HookEvent("player_spawn", Event_PlayerSpawnAndClass, EventHookMode_Post);
    HookEvent("player_class", Event_PlayerSpawnAndClass, EventHookMode_Post);
    HookEvent("game_end", Event_GameEnd, EventHookMode_Post);

    RegConsoleCmd("sm_equip", Command_ModelMenu, "Open Model Menu");
}