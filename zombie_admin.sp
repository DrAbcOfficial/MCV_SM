#include <topmenus>
#include <adminmenu>
#include <sourcemod>
#include <lib_mcv>

#define PLUGIN_NAME        "Zombie Admin"
#define PLUGIN_DESCRIPTION "全新僵尸权限王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

TopMenu g_pAdminMenu;

public void CategoryHandler(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
    switch (action)
    {
        case TopMenuAction_DisplayTitle, TopMenuAction_DisplayOption: Format(buffer, maxlength, "僵尸命令");
    }
}

public void AdminMenu_Nuke(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id,
                    int param, char[] buffer, int maxlength)
{
    if (action == TopMenuAction_DisplayOption)
        Format(buffer, maxlength, "核平僵尸");
    else if (action == TopMenuAction_SelectOption)
        ServerCommand("sm_zombie_nuke");
}

public void MenuHandler_GiveMoneyAll(Menu menu, MenuAction action, int client, int slot)
{
    if (action == MenuAction_End)
        delete menu;
    else if (action == MenuAction_Select)
    {
        char buffer[64];
        menu.GetItem(slot, buffer, sizeof(buffer));
        int money = StringToInt(buffer);
        for (new i = 1; i <= MaxClients; i++)
        {
            if (MCV_IsClientValid(i))
                ZM_AddMoney(i, money);
        }
        GetClientName(client, buffer, sizeof(buffer));
        PrintToChatAll("管理员%s给所有人打了%d元钱。", buffer, money);
    }
}

public void AdminMenu_MoneyAll(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id,
                        int client, char[] buffer, int maxlength)
{
    if (action == TopMenuAction_DisplayOption)
        Format(buffer, maxlength, "给所有人打钱");
    else if (action == TopMenuAction_SelectOption)
    {
        Menu menu = new Menu(MenuHandler_GiveMoneyAll);
        menu.SetTitle("打多少钱");
        menu.ExitBackButton = true;

        menu.AddItem("10", "10块");
        menu.AddItem("100", "100块");
        menu.AddItem("250", "250块");
        menu.AddItem("500", "500块");
        menu.AddItem("1000", "1000块");
        menu.AddItem("5000", "5000块");
        menu.AddItem("10000", "10000块");
        menu.Display(client, MENU_TIME_FOREVER);
    }
}

public void MenuHandler_GiveMoneyOne(Menu menu, MenuAction action, int client, int slot)
{
    if (action == MenuAction_End)
        delete menu;
    else if (action == MenuAction_Select)
    {
        char index[32];
        menu.GetItem(0, index, sizeof(index));
        int  i = StringToInt(index);
        char buffer[64];
        menu.GetItem(slot, buffer, sizeof(buffer));
        int money = StringToInt(buffer);
        if (MCV_IsClientValid(i))
            ZM_AddMoney(i, money);
        GetClientName(client, buffer, sizeof(buffer));
        PrintToChat(i, "管理员%s给你打了%d元钱。", buffer, money);
    }
}

public void MenuHandler_GiveMoney(Menu menu, MenuAction action, int param1, int param2)
{
    if (action == MenuAction_End)
        delete menu;
    else if (action == MenuAction_Select)
    {
        char info[32], name[32];
        int  userid, target;

        menu.GetItem(param2, info, sizeof(info), _, name, sizeof(name));
        userid = StringToInt(info);

        if ((target = GetClientOfUserId(userid)) == 0)
            PrintToChat(param1, "[SM] 该玩家已不可用");
        else if (!CanUserTarget(param1, target))
            PrintToChat(param1, "[SM] 该玩家无法作为目标");
        else
        {
            char index[32];
            IntToString(target, index, sizeof(index));
            Menu smenu = new Menu(MenuHandler_GiveMoneyOne);
            smenu.SetTitle("打多少钱");
            smenu.AddItem(index, name, ITEMDRAW_DISABLED);
            smenu.AddItem("10", "10块");
            smenu.AddItem("100", "100块");
            smenu.AddItem("250", "250块");
            smenu.AddItem("500", "500块");
            smenu.AddItem("1000", "1000块");
            smenu.AddItem("5000", "5000块");
            smenu.AddItem("10000", "10000块");
            smenu.Display(param1, MENU_TIME_FOREVER);
        }
    }
}

public void AdminMenu_MoneyOne(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id,
                        int client, char[] buffer, int maxlength)
{
    if (action == TopMenuAction_DisplayOption)
        Format(buffer, maxlength, "给某个人打钱");
    else if (action == TopMenuAction_SelectOption)
    {
        Menu menu = new Menu(MenuHandler_GiveMoney);
        menu.SetTitle("给谁打钱?");
        menu.ExitBackButton = CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC, false);

        AddTargetsToMenu2(menu, client, COMMAND_FILTER_NO_BOTS | COMMAND_FILTER_CONNECTED);

        menu.Display(client, MENU_TIME_FOREVER);
    }
}

public void OnAdminMenuReady(Handle hTopmenu)
{
    TopMenu topmenu = TopMenu.FromHandle(hTopmenu);
    if (topmenu == g_pAdminMenu)
        return;
    g_pAdminMenu                    = topmenu
        TopMenuObject menu_commands = g_pAdminMenu.AddCategory("僵尸命令", CategoryHandler);
    if (menu_commands != INVALID_TOPMENUOBJECT)
    {
        g_pAdminMenu.AddItem("sm_zombie_nuke", AdminMenu_Nuke, menu_commands, "sm_zombie_nuke", ADMFLAG_SLAY);
        g_pAdminMenu.AddItem("sm_zombie_money", AdminMenu_MoneyOne, menu_commands, "sm_zombie_money", ADMFLAG_SLAY);
        g_pAdminMenu.AddItem("sm_zombie_money_all", AdminMenu_MoneyAll, menu_commands, "sm_zombie_money_all", ADMFLAG_SLAY);
    }
}

public void OnPluginStart()
{
    TopMenu tmAdminMenu;
    if (LibraryExists("adminmenu") && ((tmAdminMenu = GetAdminTopMenu()) != null))
    {
        OnAdminMenuReady(tmAdminMenu);
    }
}

public void OnPluginEnd()
{
    g_pAdminMenu.Close();
}

public void OnLibraryRemoved(const char[] name)
{
    if (StrEqual(name, "adminmenu", false))
    {
        g_pAdminMenu.Close();
        g_pAdminMenu = null;
    }
}