#include <sourcemod>
#include <lib_mcv>

#define PLUGIN_NAME        "Zombie DamageReport"
#define PLUGIN_DESCRIPTION "全新僵尸报告王三代"

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

ConVar    g_pEnableRoundReport;
Handle    g_hHudSyncer;

enum struct CReportInfo
{
    int damage;
}

CReportInfo g_pGlobalReportInfo;
CReportInfo g_aryReportInfos[MAXPLAYERS + 1];

public void OnZombieHurt(int attacker, int health, int armor, char[] weapon, int dmg_health, int dmg_armor, int hitgroup, int damagetype)
{
    if (MCV_IsClientValid(attacker))
    {
        g_pGlobalReportInfo.damage += dmg_health;
        g_aryReportInfos[attacker].damage += dmg_health;

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

void ResetReportItems()
{
    g_pGlobalReportInfo.damage = 0;
    for (int i = 0; i < MAXPLAYERS + 1; i++)
    {
        g_aryReportInfos[i].damage = 0;
    }
}

public void OnZombiePhaseChanged(int phase)
{
    if (phase == ZM_PHASE_WAITING)
    {
        int           wave = ZM_GetWaveNum();
        static ConVar zombie_health;
        if (zombie_health == INVALID_HANDLE)
            zombie_health = FindConVar("sm_zombie_health_baseratio");
        float diff       = zombie_health.FloatValue;

        int   mvp_index  = 0;
        int   mvp_damage = 0;
        char  mvp_name[128];
        for (int i = 1; i <= MaxClients; i++)
        {
            if (MCV_IsClientValid(i))
            {
                if (g_aryReportInfos[i].damage > mvp_damage)
                {
                    mvp_damage = g_aryReportInfos[i].damage;
                    mvp_index  = i;
                }
            }
        }
        if (mvp_index > 0)
            GetClientName(mvp_index, mvp_name, sizeof(mvp_name));

        SetHudTextParams(0.55, 0.1, 10.0, 255, 255, 255, 255, 1, 1.0, 0.1, 0.2);
        for (int i = 1; i <= MaxClients; i++)
        {
            if (!IsClientInGame(i) || IsFakeClient(i))
                continue;
            ShowSyncHudText(i, g_hHudSyncer, "回合结束\n  波次：第%d波\n  难度：x%.2f\n  总伤害：%d   \n  回合MVP：%s (%d伤害)\n 你的伤害：%d",
                            wave, diff, g_pGlobalReportInfo.damage, mvp_name, mvp_damage, g_aryReportInfos[i].damage);
        }
        ResetReportItems();
    }
}

public void OnMapInit(const char[] mapName)
{
    ResetReportItems();
}

public void OnPluginStart()
{
    g_dicPlayerDamageReport = new StringMap();
    g_hHudSyncer            = CreateHudSynchronizer();
    RegConsoleCmd("sm_report", Cmd_SwitchDamageReport, "On/Off Damage report");
    g_pEnableRoundReport = CreateConVar("sm_zombie_report", "1", "Enable zombie report when round ended.", 0, true, 0.0, true, 1.0);

    ResetReportItems();
}

public void OnPluginEnd()
{
    g_hHudSyncer.Close();
    g_dicPlayerDamageReport.Close();
    g_pEnableRoundReport.Close();
}