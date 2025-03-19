#include <sourcemod>

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

public void CategoryHandler(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param,    char[] buffer, int maxlength)
{
    switch (action)
    {
        case TopMenuAction_DisplayTitle, TopMenuAction_DisplayOption: Format(buffer, maxlength, "僵尸命令");
    }
}

public void AdminMenu_Nuke(TopMenu topmenu, TopMenuAction action,TopMenuObject object_id,
					  int param,char[] buffer,int maxlength)
{
    if (action == TopMenuAction_DisplayOption)
        Format(buffer, maxlength, "核平僵尸");
    else if (action == TopMenuAction_SelectOption)
        ServerCommand("sm_zombie_nuke");
}

public void OnAdminMenuReady(Handle topmenu)
{
    TopMenu topmenu = TopMenu.FromHandle(aTopMenu);
    if (topmenu == g_pAdminMenu)
        return;
    g_pAdminMenu = topmenu
    TopMenuObject menu_commands = g_tmTopMenu.AddCategory("僵尸命令", CategoryHandler);
    if (menu_commands != INVALID_TOPMENUOBJECT){
        g_tmTopMenu.AddItem("sm_zombie_nuke", AdminMenu_Nuke, menu_commands, "sm_zombie_nuke", ADMFLAG_SLAY);
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
        g_tmTopMenu = null;
    }
} 