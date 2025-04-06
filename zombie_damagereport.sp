#include <sourcemod>
#include <lib_mcv>

#define PLUGIN_NAME        "Zombie DamageReport"
#define PLUGIN_DESCRIPTION "全新僵尸报告王一代"

#define BAR_SIZE           10

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

StringMap g_dicPlayerDamageReport;

public void OnZombieHurt(int attacker, int health, int armor, char[] weapon, int dmg_health, int dmg_armor, int hitgroup, int damagetype)
{
    if (MCV_IsClientValid(attacker))
    {
        char buffer[64];
        GetClientAuthId(attacker, AuthId_SteamID64, buffer, sizeof(buffer));
        if (g_dicPlayerDamageReport.ContainsKey(buffer))
        {
            bool on;
            g_dicPlayerDamageReport.GetValue(buffer, on);
            if (on)
                PrintCenterText(attacker, "造成%d伤害, 剩余%d血量", dmg_health, health);
        }
    }
}

Action Cmd_SwitchDamageReport(int client, int args)
{
    char buffer[64];
    GetClientAuthId(client, AuthId_SteamID64, buffer, sizeof(buffer));
    if (args > 0)
    {
        bool on = GetCmdArgInt(1) > 0;
        g_dicPlayerDamageReport.SetValue(buffer, on);
        if (on)
            ReplyToCommand(client, "已开启伤害播报。");
        else
            ReplyToCommand(client, "已关闭伤害播报。");
    }
    else
    {
        if (g_dicPlayerDamageReport.ContainsKey(buffer))
        {
            bool on;
            g_dicPlayerDamageReport.GetValue(buffer, on);
            g_dicPlayerDamageReport.SetValue(buffer, !on);
            if (on)
                ReplyToCommand(client, "已关闭伤害播报。");
            else
                ReplyToCommand(client, "已开启伤害播报。");
        }
        else
        {
            g_dicPlayerDamageReport.SetValue(buffer, true);
            ReplyToCommand(client, "已开启伤害播报。");
        }
    }
    return Plugin_Handled;
}

public void OnPluginStart()
{
    g_dicPlayerDamageReport = new StringMap();
    RegConsoleCmd("sm_report", Cmd_SwitchDamageReport, "On/Off Damage report");
}