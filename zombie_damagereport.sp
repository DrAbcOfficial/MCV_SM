#include <sourcemod>
#include <lib_mcv>

#define PLUGIN_NAME        "Zombie DamageReport"
#define PLUGIN_DESCRIPTION "全新僵尸报告王二代"

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
int       g_iAllDealedDamage;
StringMap g_dicPlayerDealedDamage;
Handle    g_hHudSyncer;

public void OnZombieHurt(int attacker, int health, int armor, char[] weapon, int dmg_health, int dmg_armor, int hitgroup, int damagetype)
{
    if (MCV_IsClientValid(attacker))
    {
        g_iAllDealedDamage += dmg_health;
        char buffer[64];
        GetClientAuthId(attacker, AuthId_SteamID64, buffer, sizeof(buffer));
        if (g_dicPlayerDamageReport.ContainsKey(buffer))
        {
            bool on;
            g_dicPlayerDamageReport.GetValue(buffer, on);
            if (on)
                PrintCenterText(attacker, "造成%d伤害, 剩余%d血量", dmg_health, health);
        }

        int dealedDamage = 0;
        if (g_dicPlayerDealedDamage.ContainsKey(buffer))
            g_dicPlayerDealedDamage.GetValue(buffer, dealedDamage);
        g_dicPlayerDealedDamage.SetValue(buffer, dealedDamage + dmg_health);
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

public void OnZombiePhaseChanged(int phase)
{
    if (phase == ZM_PHASE_WAITING)
    {
        int           wave = ZM_GetWaveNum();
        static ConVar zombie_health;
        if (zombie_health == INVALID_HANDLE)
            zombie_health = FindConVar("sm_zombie_health_baseratio");
        float             diff = zombie_health.FloatValue;

        char              mvp_steamid[64];
        int               mvp_damage = 0;
        StringMapSnapshot keys       = g_dicPlayerDealedDamage.Snapshot();
        for (int i = 0; i <= keys.Length; i++)
        {
            char steamid[64];
            int  damage;
            keys.GetKey(i, steamid, sizeof(steamid));
            g_dicPlayerDealedDamage.GetValue(steamid, damage);
            if (damage > mvp_damage)
            {
                mvp_damage = damage;
                strcopy(mvp_steamid, sizeof(mvp_steamid), steamid);
            }
        }
        char mvp_name[128];
        for (int i = 1; i <= MaxClients; i++)
        {
            if (MCV_IsClientValid(i))
            {
                char buffer[64];
                GetClientAuthId(i, AuthId_SteamID64, buffer, sizeof(buffer));
                if (!strcmp(buffer, mvp_steamid))
                {
                    GetClientName(i, mvp_name, sizeof(mvp_name));
                    break;
                }
            }
        }
        SetHudTextParams(0.7, 0.1, 10.0, 255, 255, 255, 255, 1, 1.0, 0.1, 0.2);
        for (int i = 1; i <= MaxClients; i++)
        {
            if (!IsClientInGame(i) || IsFakeClient(i))
                continue;
            ShowSyncHudText(i, g_hHudSyncer, "回合结束\n  波次：第%d波\n  难度：x%.2f\n  总伤害：%d   \n  回合MVP：%s (%d伤害)",
                            wave - 1, diff, g_iAllDealedDamage, mvp_name, mvp_damage);
        }
        g_iAllDealedDamage = 0;
        g_dicPlayerDealedDamage.Clear();
    }
}

public void OnPluginStart()
{
    g_dicPlayerDamageReport = new StringMap();
    g_dicPlayerDealedDamage = new StringMap();
    g_hHudSyncer            = CreateHudSynchronizer();
    RegConsoleCmd("sm_report", Cmd_SwitchDamageReport, "On/Off Damage report");
    g_pEnableRoundReport = CreateConVar("sm_zombie_report", "1", "Enable zombie report when round ended.", 0, true, 0.0, true, 1.0);
}

public void OnPluginEnd()
{
    g_hHudSyncer.Close();
    g_dicPlayerDamageReport.Close();
    g_dicPlayerDealedDamage.Close();
    g_pEnableRoundReport.Close();
}