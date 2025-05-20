#define PLUGIN_NAME        "Auto amounter"
#define PLUGIN_DESCRIPTION "全新自动工坊挂载王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

enum PHASE
{
    NOT_AMOUNT,
    AMOUNTED,
    ALL_DONE
}

PHASE g_iPhase = NOT_AMOUNT;
char  originalMapname[64];

public void OnMapStart()
{
    switch (g_iPhase)
    {
        case NOT_AMOUNT:
        {
            ServerCommand("exec mapgroup_workshop.cfg");
            char mapName[64];
            GetCurrentMap(mapName, sizeof(mapName));
            strcopy(originalMapname, sizeof(originalMapname), mapName);
            g_iPhase = AMOUNTED;
        }
        case AMOUNTED:
        {
            ServerCommand("map %s", originalMapname);
            g_iPhase = ALL_DONE;
        }
    }
}

char g_szRejectReason[] = "服务器还在启动中……稍后再来吧！";
public bool OnClientConnect(int client, char[] rejectmsg, int maxlen)
{
    if (g_iPhase != ALL_DONE)
    {
        strcopy(rejectmsg, maxlen, g_szRejectReason);
        return false;
    }
    return true;
}