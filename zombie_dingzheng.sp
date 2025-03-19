#include <sourcemod>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie DingZheng"
#define PLUGIN_DESCRIPTION "全新僵尸顶针王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

char g_aryYYDZ[][] = {
    "一盐",
    "if",
    "英语",
    "盈余",
    "隐喻",
    "驿员",
    "易淹",
    "义演",
    "抑烟",
    "姻缘",
    "一夜",
    "肄业",
    "一叶",
    "遗言",
    "银叶",
    "银验",
    "鱼油",
    "狱友",
    "溢砚",
    "医牙",
    "抑炎",
    "夷颜",
    "已阉",
    "医研",
    "易腌",
    "一元",
    "一眼",
    "友谊",
    "渔业",
    "玉叶",
    "雨夜",
    "玉液",
    "益业",
    "移岩",
    "亿元",
    "蚁晏",
    "议员",
    "翼檐",
    "异衍",
    "溢堰",
    "义眼",
    "抑郁",
    "易衍",
    "鹬蚌",
    "泳衣",
    "庸医",
    "勇毅",
    "用以",
    "永益",
    "业炎",
    "寓言",
    "语言",
    "预言",
    "雨燕",
    "预演",
    "预研",
    "鱼眼",
    "浴盐",
    "玉艳",
    "乙焰",
    "伊彦",
    "E延",
    "抑言",
    "艳阳",
    "亿烟",
    "欲冶",
    "译言",
    "羿眼",
    "遗言",
    "艺演",
    "狱阎",
    "疫严",
    "彝烟",
    "营业",
    "鹰眼",
    "硬岩",
    "樱眼",
    "药研",
    "遇缘",
    "易游",
    "野猿",
    "YY",
    "厌欲",
    "义勇",
    "驿验",
    "依原",
    "应用",
    "已赢",
    "一印",
    "厌氧",
    "洋洋",
    "样样",
    "越狱",
    "粤语",
    "越语",
    "月余",
    "渔验",
    "裔验",
    "易圆",
    "要元",
    "愚演",
    "怡颜",
    "疑疫",
    "音乐",
    "验孕",
    "燕云",
    "烟云",
    "译遗",
    "岩羊",
    "一样",
    "异样",
    "颐养",
    "怡养",
    "有用",
    "又要",
    "优雅",
    "友谊",
    "优异",
    "游泳",
    "鱿鱼",
    "有缘",
    "幽幽",
    "有约",
    "诱因",
    "右翼",
    "忧郁",
    "有眼",
    "原油",
    "元婴",
    "援引",
    "元音",
    "语音",
    "御用",
    "尹悦"
};

Action Event_ZombieKilled(Handle event, const char[] name, bool dontBroadcast)
{
    char othertype[64];
    GetEventString(event, "othertype", othertype, sizeof(othertype));
    if (!strncmp(othertype, "nb_zombie", 9))
    {
        int random = GetRandomInt(0, sizeof(g_aryYYDZ) - 1);
        char yydz[16];
        Format(yydz, sizeof(yydz), "%s顶针", g_aryYYDZ[random]);
        SetEventString(event, "othertype", yydz);
    }
    return Plugin_Continue;
}

public void OnPluginStart()
{
    HookEvent("other_death", Event_ZombieKilled, EventHookMode_Pre);
}

public void OnPluginEnd()
{
    UnhookEvent("other_death", Event_ZombieKilled, EventHookMode_Pre);
}