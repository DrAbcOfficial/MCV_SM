#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <zombie_core>
#include <lib_mcv>

#define EF_BONEMERGE       (1 << 0)
#define EF_NOSHADOW        (1 << 4)
#define EF_NORECEIVESHADOW (1 << 6)
#define EF_PARENT_ANIMATES (1 << 9)

public Plugin myinfo =
{
    name        = "Model menu",
    author      = "Dr.Abc",
    description = "僵尸特化人物菜单二代",
    version     = "Model menu",
    url         = "Model menu"
};

// Menus
Menu      g_pRootMenu;
StringMap g_dicMenus;
// Model and list
StringMap g_dicModels;
// Player chosed
StringMap g_dicPlayerModels;

void      ChangePlayerModel(int client, char[] model, char[] c_model)
{
    
    if (ZM_IsClientValid(client) && IsPlayerAlive(client))
    {
        static int table = INVALID_STRING_TABLE;
        if (table == INVALID_STRING_TABLE)
            table = FindStringTable("modelprecache");
        bool save     = LockStringTables(false);
        int  modelidx = FindStringIndex(table, model);
        LockStringTables(save);
        SetEntProp(client, Prop_Send, "m_nModelIndex", modelidx);
        SetEntProp(client, Prop_Send, "m_nBody", 0);
        SetEntityRenderColor(client, 255, 255, 255, 255);
        // SetEntityModel(client, model);
        // SetEntProp(client, Prop_Send, "m_nBody", 0);



        // if (strlen(c_model) > 0)
        // {
        //     int skin = CreateEntityByName("prop_dynamic_override");
        //     DispatchKeyValue(skin, "model", c_model);
        //     DispatchKeyValue(skin, "disablereceiveshadows", "1");
        //     DispatchKeyValue(skin, "disableshadows", "1");
        //     DispatchKeyValue(skin, "solid", "0");
        //     DispatchKeyValue(skin, "spawnflags", "256");
        //     SetEntProp(skin, Prop_Send, "m_CollisionGroup", 11);
        //     DispatchSpawn(skin);
        //     SetEntProp(skin, Prop_Send, "m_fEffects", EF_BONEMERGE | EF_NOSHADOW | EF_NORECEIVESHADOW | EF_PARENT_ANIMATES);
        //     int baseviewmodel = MCV_GetPlayerViewModel(client, 0);

        //     MCV_SetParent(skin, baseviewmodel);
        //     MCV_SetParentAttachment(skin, "SetParentAttachment", "cam", false);
        //     PrintToChatAll("%s %d %d", c_model, skin, baseviewmodel);
        //     SetEntityRenderColor(baseviewmodel, 255, 255, 255, 0);
        //     SetEntityRenderMode(baseviewmodel, RENDER_TRANSALPHA);
        // }
        // else
        // {
        //     int viewmodel = MCV_GetPlayerViewModel(client, 1);
        //     if (IsValidEntity(viewmodel))
        //         RemoveEntity(viewmodel);
        // }

        int team = GetEntProp(client, Prop_Send, "m_iTeamNum");
        if (team == 3)
            SetEntProp(client, Prop_Send, "m_nSkin", 1);
        else
            SetEntProp(client, Prop_Send, "m_nSkin", 0);
    }
}

void ClearMemeory()
{
    g_pRootMenu.RemoveAllItems();
    StringMapSnapshot snap = g_dicMenus.Snapshot();
    char              keys[64];
    for (int i = 0; i < g_dicMenus.Size; i++)
    {
        snap.GetKey(i, keys, sizeof(keys));
        Menu sub;
        g_dicMenus.GetValue(keys, sub);
        sub.Close();
    }
    g_dicMenus.Clear();

    StringMapSnapshot msnap = g_dicModels.Snapshot();
    for (int i = 0; i < msnap.Length; i++)
    {
        msnap.GetKey(i, keys, sizeof(keys));
        StringMap model_info;
        g_dicModels.GetValue(keys, model_info);
        model_info.Clear();
        model_info.Close();
    }
    g_dicModels.Clear();
    g_dicPlayerModels.Clear();
}

void LoadConfig()
{
    ClearMemeory();
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
        char c_hand[PLATFORM_MAX_PATH];
        kv.GetSectionName(name, sizeof(name));
        kv.GetString("model", buffer, sizeof(buffer));
        kv.GetString("c_hand", c_hand, sizeof(c_hand));

        StringMap model_info = new StringMap();
        model_info.SetString("model", buffer);
        model_info.SetString("c_hand", c_hand);

        g_dicModels.SetValue(name, model_info);
        char cat[64];
        kv.GetString("category", cat, sizeof(cat));
        Menu sub;
        if (g_dicMenus.ContainsKey(cat))
        {
            g_dicMenus.GetValue(cat, sub);
        }
        else
        {
            sub = new Menu(MenuHandler_ChangeModel);
            sub.SetTitle(cat);
            g_dicMenus.SetValue(cat, sub);
            g_pRootMenu.AddItem(cat, cat);
        }
        sub.AddItem(buffer, name);
    }
    while (kv.GotoNextKey());
    kv.DeleteThis();
}

public Action Command_ModelMenu(int client, int args)
{
    if (!ZM_IsClientValid(client))
        return Plugin_Handled;
    g_pRootMenu.ExitButton = true;
    g_pRootMenu.Display(client, 240);
    return Plugin_Handled;
}

public Action Command_ReloadCfg(int client, int args)
{
    LoadConfig();
    Precache();
    return Plugin_Handled;
}

public void MenuHandler_ChangeModel(Menu menu, MenuAction action, int client, int slot)
{
    if (action == MenuAction_Cancel)
        g_pRootMenu.Display(client, 60);
    else if (action == MenuAction_Select)
    {
        char info[PLATFORM_MAX_PATH];
        char display[64];
        int  style;
        menu.GetItem(slot, info, sizeof(info), style, display, sizeof(display));

        char steamid[64];
        GetClientAuthId(client, AuthId_SteamID64, steamid, sizeof(steamid));
        g_dicPlayerModels.SetString(steamid, display, true);

        char             model[PLATFORM_MAX_PATH];
        char             c_hand[PLATFORM_MAX_PATH];
        static StringMap model_info;
        g_dicModels.GetValue(display, model_info);
        model_info.GetString("model", model, sizeof(model));
        model_info.GetString("c_hand", c_hand, sizeof(c_hand));

        ChangePlayerModel(client, model, c_hand);
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
            sub.ExitBackButton = true;
            sub.Display(client, 60);
        }
    }
}

void Timer_LazyChangePlayerModel(Handle timer, int client)
{
    char steamid[64];
    GetClientAuthId(client, AuthId_SteamID64, steamid, sizeof(steamid));
    char info[64];
    g_dicPlayerModels.GetString(steamid, info, sizeof(info));

    char             model[PLATFORM_MAX_PATH];
    char             c_hand[PLATFORM_MAX_PATH];
    static StringMap model_info;
    g_dicModels.GetValue(info, model_info);
    model_info.GetString("model", model, sizeof(model));
    model_info.GetString("c_hand", c_hand, sizeof(c_hand));

    ChangePlayerModel(client, model, c_hand);
}
void Timer_LazyBOTChangePlayerModel(Handle timer, int client)
{
    StringMapSnapshot keys = g_dicModels.Snapshot();
    char              key[64];
    keys.GetKey(GetRandomInt(0, g_dicModels.Size - 1), key, sizeof(key));
    char             model[PLATFORM_MAX_PATH];
    char             c_hand[PLATFORM_MAX_PATH];
    static StringMap model_info;
    g_dicModels.GetValue(key, model_info);
    model_info.GetString("model", model, sizeof(model));
    model_info.GetString("c_hand", c_hand, sizeof(c_hand));
    ChangePlayerModel(client, model, c_hand);
}

Action Event_PlayerSpawnAndClass(Handle event, const char[] name, bool dontBroadcast)
{
    int  client = GetClientOfUserId(GetEventInt(event, "userid"));
    char steamid[64];
    GetClientAuthId(client, AuthId_SteamID64, steamid, sizeof(steamid));
    if (IsFakeClient(client))
    {
        int rand = GetRandomInt(0, 100);
        if (rand > 50)
        {
            CreateTimer(0.1, Timer_LazyBOTChangePlayerModel, client);
        }
    }
    else if (g_dicPlayerModels.ContainsKey(steamid))
    {
        CreateTimer(0.1, Timer_LazyChangePlayerModel, client);
    }
    return Plugin_Handled;
}

void Precache()
{
    if (g_dicModels.Size <= 0)
        return;
    StringMapSnapshot keys = g_dicModels.Snapshot();
    for (int i = 0; i < keys.Length; i++)
    {
        char key[64];
        char buffer[PLATFORM_MAX_PATH];
        keys.GetKey(i, key, sizeof(key));
        static StringMap model_info;
        g_dicModels.GetValue(key, model_info);
        model_info.GetString("model", buffer, sizeof(buffer));
        PrecacheModel(buffer);
        model_info.GetString("c_hand", buffer, sizeof(buffer));
        if (strlen(buffer) > 0)
            PrecacheModel(buffer);
    }
}

public void OnMapInit()
{
    Precache();
}

public void OnPluginStart()
{
    g_dicPlayerModels = new StringMap();
    g_dicModels       = new StringMap();
    g_dicMenus        = new StringMap();
    // Set Menu Title
    g_pRootMenu       = new Menu(MenuHandler_SubMenu);
    g_pRootMenu.SetTitle("玩家模型菜单");

    LoadConfig();

    HookEvent("player_spawn", Event_PlayerSpawnAndClass, EventHookMode_Post);
    HookEvent("player_class", Event_PlayerSpawnAndClass, EventHookMode_Post);

    RegConsoleCmd("sm_equip", Command_ModelMenu, "Open Model Menu");
    RegAdminCmd("sm_models_reload", Command_ReloadCfg, ADMFLAG_CONFIG, "Reload Model Menu");
}

public void OnPluginEnd()
{
    ClearMemeory();
    g_dicPlayerModels.Close();
    StringMapSnapshot keys = g_dicModels.Snapshot();
    for (int i = 0; i < keys.Length; i++)
    {
        char key[64];
        keys.GetKey(i, key, sizeof(key));
        static StringMap model_info;
        g_dicModels.GetValue(key, model_info);
        model_info.Close();
    }
    g_dicModels.Close();
    g_dicMenus.Close();
    g_pRootMenu.Close();
}