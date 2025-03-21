#include <sourcemod>

#define PLUGIN_NAME        "Help Message"
#define PLUGIN_DESCRIPTION "全新帮助王一代"

#define BAR_SIZE           10

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

Action Cmd_PrintHelp(int client, int args)
{
    ReplyToCommand(client, "\x02[音频列表]\x01 !slist  \x03[丢出金钱]\x01 !drop");
    ReplyToCommand(client, "\x04[伤害报告]\x01 !report");
    return Plugin_Handled;
}

public void OnPluginStart()
{
    RegConsoleCmd("sm_server_help", Cmd_PrintHelp, "Print server help message");
}