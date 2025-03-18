#include <sdktools>
#include <zombie_core>

#define PLUGIN_NAME        "Zombie Weapon"
#define PLUGIN_DESCRIPTION "全新僵尸买枪王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

enum struct CWeaponInfo
{
    char classname[64];
    char display[64];
    char category[64];
    int  price;
    int  weight;
}

CWeaponInfo g_aryWeaponInfos[240];

StringMap   g_dicMenus;
Menu        g_pRoot;
ConVar g_pMaxWeight;

void        InitWeaponInfos()
{
    g_aryWeaponInfos[0].classname   = "weapon_ak47";
    g_aryWeaponInfos[0].display     = "AK-47";
    g_aryWeaponInfos[0].category    = "步枪";
    g_aryWeaponInfos[0].price       = 3100;
    g_aryWeaponInfos[0].weight      = 4;

    g_aryWeaponInfos[1].classname   = "weapon_ak47_bayonet";
    g_aryWeaponInfos[1].display     = "6H2刺刀";
    g_aryWeaponInfos[1].category    = "近战武器";
    g_aryWeaponInfos[1].price       = 250;
    g_aryWeaponInfos[1].weight      = 1;

    g_aryWeaponInfos[2].classname   = "weapon_akm";
    g_aryWeaponInfos[2].display     = "AKM";
    g_aryWeaponInfos[2].category    = "步枪";
    g_aryWeaponInfos[2].price       = 2975;
    g_aryWeaponInfos[2].weight      = 4;

    g_aryWeaponInfos[3].classname   = "weapon_akm_gp25";
    g_aryWeaponInfos[3].display     = "AKM BG-15";
    g_aryWeaponInfos[3].category    = "步枪";
    g_aryWeaponInfos[3].price       = 3750;
    g_aryWeaponInfos[3].weight      = 4;

    g_aryWeaponInfos[4].classname   = "weapon_amd65";
    g_aryWeaponInfos[4].display     = "AMD-65";
    g_aryWeaponInfos[4].category    = "卡宾枪";
    g_aryWeaponInfos[4].price       = 2775;
    g_aryWeaponInfos[4].weight      = 4;

    g_aryWeaponInfos[5].classname   = "weapon_ammobox_us";
    g_aryWeaponInfos[5].display     = "弹药箱";
    g_aryWeaponInfos[5].category    = "杂项装备";
    g_aryWeaponInfos[5].price       = 525;
    g_aryWeaponInfos[5].weight      = 0;

    g_aryWeaponInfos[6].classname   = "weapon_ammobox_vc";
    g_aryWeaponInfos[6].display     = "弹药箱";
    g_aryWeaponInfos[6].category    = "杂项装备";
    g_aryWeaponInfos[6].price       = 525;
    g_aryWeaponInfos[6].weight      = 0;

    g_aryWeaponInfos[7].classname   = "weapon_aps";
    g_aryWeaponInfos[7].display     = "APS";
    g_aryWeaponInfos[7].category    = "冲锋手枪";
    g_aryWeaponInfos[7].price       = 1500;
    g_aryWeaponInfos[7].weight      = 2;

    g_aryWeaponInfos[8].classname   = "weapon_auto5";
    g_aryWeaponInfos[8].display     = "勃朗宁 Auto-5";
    g_aryWeaponInfos[8].category    = "霰弹枪";
    g_aryWeaponInfos[8].price       = 2250;
    g_aryWeaponInfos[8].weight      = 3;

    g_aryWeaponInfos[9].classname   = "weapon_baby_browning";
    g_aryWeaponInfos[9].display     = "袖珍勃朗宁";
    g_aryWeaponInfos[9].category    = "手枪";
    g_aryWeaponInfos[9].price       = 350;
    g_aryWeaponInfos[9].weight      = 1;

    g_aryWeaponInfos[10].classname  = "weapon_binoculars_us";
    g_aryWeaponInfos[10].display    = "望远镜";
    g_aryWeaponInfos[10].category   = "杂项装备";
    g_aryWeaponInfos[10].price      = 6500;
    g_aryWeaponInfos[10].weight     = 5;

    g_aryWeaponInfos[11].classname  = "weapon_binoculars_vc";
    g_aryWeaponInfos[11].display    = "望远镜";
    g_aryWeaponInfos[11].category   = "杂项装备";
    g_aryWeaponInfos[11].price      = 6500;
    g_aryWeaponInfos[11].weight     = 5;

    g_aryWeaponInfos[12].classname  = "weapon_blackhawk";
    g_aryWeaponInfos[12].display    = "儒格超级黑鹰";
    g_aryWeaponInfos[12].category   = "左轮手枪";
    g_aryWeaponInfos[12].price      = 700;
    g_aryWeaponInfos[12].weight     = 1;

    g_aryWeaponInfos[13].classname  = "weapon_bren";
    g_aryWeaponInfos[13].display    = "布伦";
    g_aryWeaponInfos[13].category   = "机枪";
    g_aryWeaponInfos[13].price      = 3450;
    g_aryWeaponInfos[13].weight     = 5;

    g_aryWeaponInfos[14].classname  = "weapon_c96";
    g_aryWeaponInfos[14].display    = "毛瑟 C96";
    g_aryWeaponInfos[14].category   = "手枪";
    g_aryWeaponInfos[14].price      = 675;
    g_aryWeaponInfos[14].weight     = 1;

    g_aryWeaponInfos[15].classname  = "weapon_car15";
    g_aryWeaponInfos[15].display    = "XM177E2";
    g_aryWeaponInfos[15].category   = "卡宾枪";
    g_aryWeaponInfos[15].price      = 2700;
    g_aryWeaponInfos[15].weight     = 4;

    g_aryWeaponInfos[16].classname  = "weapon_car15s";
    g_aryWeaponInfos[16].display    = "XM177E2 4x";
    g_aryWeaponInfos[16].category   = "狙击步枪";
    g_aryWeaponInfos[16].price      = 2600;
    g_aryWeaponInfos[16].weight     = 4;

    g_aryWeaponInfos[17].classname  = "weapon_car15_oeg";
    g_aryWeaponInfos[17].display    = "XM177E2 OEG";
    g_aryWeaponInfos[17].category   = "卡宾枪";
    g_aryWeaponInfos[17].price      = 2600;
    g_aryWeaponInfos[17].weight     = 4;

    g_aryWeaponInfos[18].classname  = "weapon_china_lake";
    g_aryWeaponInfos[18].display    = "中国湖泵动榴弹发射器";
    g_aryWeaponInfos[18].category   = "榴弹发射器";
    g_aryWeaponInfos[18].price      = 5750;
    g_aryWeaponInfos[18].weight     = 6;

    g_aryWeaponInfos[19].classname  = "weapon_cobra";
    g_aryWeaponInfos[19].display    = "WEAPON_COBRA";
    g_aryWeaponInfos[19].category   = "冲锋手枪";
    g_aryWeaponInfos[19].price      = 1650;
    g_aryWeaponInfos[19].weight     = 2;

    g_aryWeaponInfos[20].classname  = "weapon_crossbow";
    g_aryWeaponInfos[20].display    = "山民弩";
    g_aryWeaponInfos[20].category   = "杂项装备";
    g_aryWeaponInfos[20].price      = 550;
    g_aryWeaponInfos[20].weight     = 2;

    g_aryWeaponInfos[21].classname  = "weapon_crowbar";
    g_aryWeaponInfos[21].display    = "撬棍";
    g_aryWeaponInfos[21].category   = "近战武器";
    g_aryWeaponInfos[21].price      = 200;
    g_aryWeaponInfos[21].weight     = 1;

    g_aryWeaponInfos[22].classname  = "weapon_csg";
    g_aryWeaponInfos[22].display    = "中式破片手榴弹";
    g_aryWeaponInfos[22].category   = "手榴弹";
    g_aryWeaponInfos[22].price      = 400;
    g_aryWeaponInfos[22].weight     = 0;

    g_aryWeaponInfos[23].classname  = "weapon_csg2";
    g_aryWeaponInfos[23].display    = "中式高爆手榴弹";
    g_aryWeaponInfos[23].category   = "手榴弹";
    g_aryWeaponInfos[23].price      = 425;
    g_aryWeaponInfos[23].weight     = 0;

    g_aryWeaponInfos[24].classname  = "weapon_css";
    g_aryWeaponInfos[24].display    = "RGD-1 烟雾弹";
    g_aryWeaponInfos[24].category   = "手榴弹";
    g_aryWeaponInfos[24].price      = 100;
    g_aryWeaponInfos[24].weight     = 0;

    g_aryWeaponInfos[25].classname  = "weapon_dp28";
    g_aryWeaponInfos[25].display    = "DP-28";
    g_aryWeaponInfos[25].category   = "机枪";
    g_aryWeaponInfos[25].price      = 3800;
    g_aryWeaponInfos[25].weight     = 5;

    g_aryWeaponInfos[26].classname  = "weapon_dual_aps";
    g_aryWeaponInfos[26].display    = "WEAPON_DUAL_APS";
    g_aryWeaponInfos[26].category   = "冲锋手枪";
    g_aryWeaponInfos[26].price      = 3000;
    g_aryWeaponInfos[26].weight     = 2;

    g_aryWeaponInfos[27].classname  = "weapon_dual_baby_browning";
    g_aryWeaponInfos[27].display    = "WEAPON_DUAL_BABY_BROWNING";
    g_aryWeaponInfos[27].category   = "手枪";
    g_aryWeaponInfos[27].price      = 700;
    g_aryWeaponInfos[27].weight     = 2;

    g_aryWeaponInfos[28].classname  = "weapon_dual_blackhawk";
    g_aryWeaponInfos[28].display    = "WEAPON_DUAL_BLACKHAWK";
    g_aryWeaponInfos[28].category   = "左轮手枪";
    g_aryWeaponInfos[28].price      = 1400;
    g_aryWeaponInfos[28].weight     = 2;

    g_aryWeaponInfos[29].classname  = "weapon_dual_hdm";
    g_aryWeaponInfos[29].display    = "WEAPON_DUAL_HDM";
    g_aryWeaponInfos[29].category   = "手枪";
    g_aryWeaponInfos[29].price      = 1200;
    g_aryWeaponInfos[29].weight     = 2;

    g_aryWeaponInfos[30].classname  = "weapon_dual_hp";
    g_aryWeaponInfos[30].display    = "WEAPON_DUAL_HP";
    g_aryWeaponInfos[30].category   = "手枪";
    g_aryWeaponInfos[30].price      = 1150;
    g_aryWeaponInfos[30].weight     = 2;

    g_aryWeaponInfos[31].classname  = "weapon_dual_lebel";
    g_aryWeaponInfos[31].display    = "WEAPON_DUAL_LEBEL";
    g_aryWeaponInfos[31].category   = "左轮手枪";
    g_aryWeaponInfos[31].price      = 1200;
    g_aryWeaponInfos[31].weight     = 2;

    g_aryWeaponInfos[32].classname  = "weapon_dual_m1895";
    g_aryWeaponInfos[32].display    = "WEAPON_DUAL_M1895";
    g_aryWeaponInfos[32].category   = "左轮手枪";
    g_aryWeaponInfos[32].price      = 1400;
    g_aryWeaponInfos[32].weight     = 2;

    g_aryWeaponInfos[33].classname  = "weapon_dual_m1911";
    g_aryWeaponInfos[33].display    = "WEAPON_DUAL_M1911";
    g_aryWeaponInfos[33].category   = "手枪";
    g_aryWeaponInfos[33].price      = 1250;
    g_aryWeaponInfos[33].weight     = 2;

    g_aryWeaponInfos[34].classname  = "weapon_dual_m1917";
    g_aryWeaponInfos[34].display    = "WEAPON_DUAL_M1917";
    g_aryWeaponInfos[34].category   = "左轮手枪";
    g_aryWeaponInfos[34].price      = 1300;
    g_aryWeaponInfos[34].weight     = 2;

    g_aryWeaponInfos[35].classname  = "weapon_dual_mac10";
    g_aryWeaponInfos[35].display    = "WEAPON_DUAL_MAC10";
    g_aryWeaponInfos[35].category   = "冲锋手枪";
    g_aryWeaponInfos[35].price      = 3000;
    g_aryWeaponInfos[35].weight     = 4;

    g_aryWeaponInfos[36].classname  = "weapon_dual_mac10_sog";
    g_aryWeaponInfos[36].display    = "WEAPON_DUAL_MAC10_SOG";
    g_aryWeaponInfos[36].category   = "冲锋手枪";
    g_aryWeaponInfos[36].price      = 2950;
    g_aryWeaponInfos[36].weight     = 4;

    g_aryWeaponInfos[37].classname  = "weapon_dual_mk22";
    g_aryWeaponInfos[37].display    = "WEAPON_DUAL_MK22";
    g_aryWeaponInfos[37].category   = "手枪";
    g_aryWeaponInfos[37].price      = 1150;
    g_aryWeaponInfos[37].weight     = 2;

    g_aryWeaponInfos[38].classname  = "weapon_dual_mk22_mod0";
    g_aryWeaponInfos[38].display    = "WEAPON_DUAL_MK22_MOD0";
    g_aryWeaponInfos[38].category   = "手枪";
    g_aryWeaponInfos[38].price      = 1100;
    g_aryWeaponInfos[38].weight     = 2;

    g_aryWeaponInfos[39].classname  = "weapon_dual_mle1935";
    g_aryWeaponInfos[39].display    = "WEAPON_DUAL_MLE1935";
    g_aryWeaponInfos[39].category   = "手枪";
    g_aryWeaponInfos[39].price      = 1200;
    g_aryWeaponInfos[39].weight     = 2;

    g_aryWeaponInfos[40].classname  = "weapon_dual_p38";
    g_aryWeaponInfos[40].display    = "WEAPON_DUAL_P38";
    g_aryWeaponInfos[40].category   = "手枪";
    g_aryWeaponInfos[40].price      = 1150;
    g_aryWeaponInfos[40].weight     = 2;

    g_aryWeaponInfos[41].classname  = "weapon_dual_pb";
    g_aryWeaponInfos[41].display    = "WEAPON_DUAL_PB";
    g_aryWeaponInfos[41].category   = "手枪";
    g_aryWeaponInfos[41].price      = 1100;
    g_aryWeaponInfos[41].weight     = 2;

    g_aryWeaponInfos[42].classname  = "weapon_dual_pm";
    g_aryWeaponInfos[42].display    = "WEAPON_DUAL_PM";
    g_aryWeaponInfos[42].category   = "手枪";
    g_aryWeaponInfos[42].price      = 1150;
    g_aryWeaponInfos[42].weight     = 2;

    g_aryWeaponInfos[43].classname  = "weapon_dual_pm63";
    g_aryWeaponInfos[43].display    = "WEAPON_DUAL_PM63";
    g_aryWeaponInfos[43].category   = "冲锋手枪";
    g_aryWeaponInfos[43].price      = 3300;
    g_aryWeaponInfos[43].weight     = 4;

    g_aryWeaponInfos[44].classname  = "weapon_dual_ppk";
    g_aryWeaponInfos[44].display    = "WEAPON_DUAL_PPK";
    g_aryWeaponInfos[44].category   = "手枪";
    g_aryWeaponInfos[44].price      = 1100;
    g_aryWeaponInfos[44].weight     = 2;

    g_aryWeaponInfos[45].classname  = "weapon_dual_qspr";
    g_aryWeaponInfos[45].display    = "WEAPON_DUAL_QSPR";
    g_aryWeaponInfos[45].category   = "左轮手枪";
    g_aryWeaponInfos[45].price      = 900;
    g_aryWeaponInfos[45].weight     = 2;

    g_aryWeaponInfos[46].classname  = "weapon_dual_ruby";
    g_aryWeaponInfos[46].display    = "WEAPON_DUAL_RUBY";
    g_aryWeaponInfos[46].category   = "手枪";
    g_aryWeaponInfos[46].price      = 1250;
    g_aryWeaponInfos[46].weight     = 2;

    g_aryWeaponInfos[47].classname  = "weapon_dual_swm10";
    g_aryWeaponInfos[47].display    = "WEAPON_DUAL_SWM10";
    g_aryWeaponInfos[47].category   = "左轮手枪";
    g_aryWeaponInfos[47].price      = 1350;
    g_aryWeaponInfos[47].weight     = 2;

    g_aryWeaponInfos[48].classname  = "weapon_dual_swm12";
    g_aryWeaponInfos[48].display    = "WEAPON_DUAL_SWM12";
    g_aryWeaponInfos[48].category   = "左轮手枪";
    g_aryWeaponInfos[48].price      = 1200;
    g_aryWeaponInfos[48].weight     = 2;

    g_aryWeaponInfos[49].classname  = "weapon_dual_tt33";
    g_aryWeaponInfos[49].display    = "WEAPON_DUAL_TT33";
    g_aryWeaponInfos[49].category   = "手枪";
    g_aryWeaponInfos[49].price      = 1250;
    g_aryWeaponInfos[49].weight     = 2;

    g_aryWeaponInfos[50].classname  = "weapon_dual_type14";
    g_aryWeaponInfos[50].display    = "WEAPON_DUAL_TYPE14";
    g_aryWeaponInfos[50].category   = "手枪";
    g_aryWeaponInfos[50].price      = 1150;
    g_aryWeaponInfos[50].weight     = 2;

    g_aryWeaponInfos[51].classname  = "weapon_dual_type64p";
    g_aryWeaponInfos[51].display    = "WEAPON_DUAL_TYPE64";
    g_aryWeaponInfos[51].category   = "手枪";
    g_aryWeaponInfos[51].price      = 1200;
    g_aryWeaponInfos[51].weight     = 2;

    g_aryWeaponInfos[52].classname  = "weapon_dual_uzi";
    g_aryWeaponInfos[52].display    = "WEAPON_DUAL_UZI";
    g_aryWeaponInfos[52].category   = "冲锋枪";
    g_aryWeaponInfos[52].price      = 3700;
    g_aryWeaponInfos[52].weight     = 6;

    g_aryWeaponInfos[53].classname  = "weapon_dual_uzi_sog";
    g_aryWeaponInfos[53].display    = "WEAPON_DUAL_UZI_SOG";
    g_aryWeaponInfos[53].category   = "冲锋枪";
    g_aryWeaponInfos[53].price      = 3600;
    g_aryWeaponInfos[53].weight     = 6;

    g_aryWeaponInfos[54].classname  = "weapon_dual_vcpistol2";
    g_aryWeaponInfos[54].display    = "WEAPON_DUAL_VCPISTOL2";
    g_aryWeaponInfos[54].category   = "手枪";
    g_aryWeaponInfos[54].price      = 950;
    g_aryWeaponInfos[54].weight     = 2;

    g_aryWeaponInfos[55].classname  = "weapon_dual_vz23";
    g_aryWeaponInfos[55].display    = "WEAPON_DUAL_VZ23";
    g_aryWeaponInfos[55].category   = "冲锋枪";
    g_aryWeaponInfos[55].price      = 4100;
    g_aryWeaponInfos[55].weight     = 6;

    g_aryWeaponInfos[56].classname  = "weapon_dual_vz61e";
    g_aryWeaponInfos[56].display    = "WEAPON_DUAL_VZ61E";
    g_aryWeaponInfos[56].category   = "冲锋手枪";
    g_aryWeaponInfos[56].price      = 2950;
    g_aryWeaponInfos[56].weight     = 4;

    g_aryWeaponInfos[57].classname  = "weapon_dual_vz61e_sog";
    g_aryWeaponInfos[57].display    = "WEAPON_DUAL_VZ61E_SOG";
    g_aryWeaponInfos[57].category   = "冲锋手枪";
    g_aryWeaponInfos[57].price      = 2900;
    g_aryWeaponInfos[57].weight     = 4;

    g_aryWeaponInfos[58].classname  = "weapon_f1";
    g_aryWeaponInfos[58].display    = "F1";
    g_aryWeaponInfos[58].category   = "冲锋枪";
    g_aryWeaponInfos[58].price      = 1950;
    g_aryWeaponInfos[58].weight     = 3;

    g_aryWeaponInfos[59].classname  = "weapon_fm24";
    g_aryWeaponInfos[59].display    = "FM-24/29";
    g_aryWeaponInfos[59].category   = "机枪";
    g_aryWeaponInfos[59].price      = 3450;
    g_aryWeaponInfos[59].weight     = 5;

    g_aryWeaponInfos[60].classname  = "weapon_g3";
    g_aryWeaponInfos[60].display    = "WEAPON_G3";
    g_aryWeaponInfos[60].category   = "步枪";
    g_aryWeaponInfos[60].price      = 3000;
    g_aryWeaponInfos[60].weight     = 4;

    g_aryWeaponInfos[61].classname  = "weapon_gasmask_us";
    g_aryWeaponInfos[61].display    = "M17防毒面具";
    g_aryWeaponInfos[61].category   = "杂项装备";
    g_aryWeaponInfos[61].price      = 350;
    g_aryWeaponInfos[61].weight     = 0;

    g_aryWeaponInfos[62].classname  = "weapon_gasmask_vc";
    g_aryWeaponInfos[62].display    = "65式防毒面具";
    g_aryWeaponInfos[62].category   = "杂项装备";
    g_aryWeaponInfos[62].price      = 350;
    g_aryWeaponInfos[62].weight     = 0;

    g_aryWeaponInfos[63].classname  = "weapon_hdm";
    g_aryWeaponInfos[63].display    = "HDM";
    g_aryWeaponInfos[63].category   = "手枪";
    g_aryWeaponInfos[63].price      = 600;
    g_aryWeaponInfos[63].weight     = 1;

    g_aryWeaponInfos[64].classname  = "weapon_hp";
    g_aryWeaponInfos[64].display    = "勃朗宁大威力";
    g_aryWeaponInfos[64].category   = "手枪";
    g_aryWeaponInfos[64].price      = 675;
    g_aryWeaponInfos[64].weight     = 1;

    g_aryWeaponInfos[65].classname  = "weapon_k50m";
    g_aryWeaponInfos[65].display    = "K-50M";
    g_aryWeaponInfos[65].category   = "冲锋枪";
    g_aryWeaponInfos[65].price      = 1900;
    g_aryWeaponInfos[65].weight     = 3;

    g_aryWeaponInfos[66].classname  = "weapon_kar98k";
    g_aryWeaponInfos[66].display    = "Kar98K";
    g_aryWeaponInfos[66].category   = "卡宾枪";
    g_aryWeaponInfos[66].price      = 1050;
    g_aryWeaponInfos[66].weight     = 3;

    g_aryWeaponInfos[67].classname  = "weapon_kar98k_s";
    g_aryWeaponInfos[67].display    = "Kar98K ZF39";
    g_aryWeaponInfos[67].category   = "狙击步枪";
    g_aryWeaponInfos[67].price      = 1150;
    g_aryWeaponInfos[67].weight     = 3;

    g_aryWeaponInfos[68].classname  = "weapon_kar98k_zf41";
    g_aryWeaponInfos[68].display    = "Kar98k ZF41";
    g_aryWeaponInfos[68].category   = "卡宾枪";
    g_aryWeaponInfos[68].price      = 1250;
    g_aryWeaponInfos[68].weight     = 3;

    g_aryWeaponInfos[69].classname  = "weapon_kbkg60";
    g_aryWeaponInfos[69].display    = "Kbkg wz.60";
    g_aryWeaponInfos[69].category   = "步枪";
    g_aryWeaponInfos[69].price      = 3100;
    g_aryWeaponInfos[69].weight     = 4;

    g_aryWeaponInfos[70].classname  = "weapon_kolos";
    g_aryWeaponInfos[70].display    = "科洛斯便携式防空系统";
    g_aryWeaponInfos[70].category   = "火箭发射器";
    g_aryWeaponInfos[70].price      = 7500;
    g_aryWeaponInfos[70].weight     = 7;

    g_aryWeaponInfos[71].classname  = "weapon_l1a1";
    g_aryWeaponInfos[71].display    = "L1A1";
    g_aryWeaponInfos[71].category   = "步枪";
    g_aryWeaponInfos[71].price      = 3250;
    g_aryWeaponInfos[71].weight     = 4;

    g_aryWeaponInfos[72].classname  = "weapon_l1a1_sog";
    g_aryWeaponInfos[72].display    = "L1A1“The Bitch”特种";
    g_aryWeaponInfos[72].category   = "步枪";
    g_aryWeaponInfos[72].price      = 3175;
    g_aryWeaponInfos[72].weight     = 4;

    g_aryWeaponInfos[73].classname  = "weapon_l2a1";
    g_aryWeaponInfos[73].display    = "L2A1";
    g_aryWeaponInfos[73].category   = "机枪";
    g_aryWeaponInfos[73].price      = 3550;
    g_aryWeaponInfos[73].weight     = 5;

    g_aryWeaponInfos[74].classname  = "weapon_lacoste";
    g_aryWeaponInfos[74].display    = "WEAPON_LACOSTE";
    g_aryWeaponInfos[74].category   = "冲锋手枪";
    g_aryWeaponInfos[74].price      = 1650;
    g_aryWeaponInfos[74].weight     = 2;

    g_aryWeaponInfos[75].classname  = "weapon_lebel";
    g_aryWeaponInfos[75].display    = "MAS-1892";
    g_aryWeaponInfos[75].category   = "左轮手枪";
    g_aryWeaponInfos[75].price      = 675;
    g_aryWeaponInfos[75].weight     = 1;

    g_aryWeaponInfos[76].classname  = "weapon_lpo50";
    g_aryWeaponInfos[76].display    = "LPO-50火焰喷射器";
    g_aryWeaponInfos[76].category   = "杂项装备";
    g_aryWeaponInfos[76].price      = 6000;
    g_aryWeaponInfos[76].weight     = 6;

    g_aryWeaponInfos[77].classname  = "weapon_m12";
    g_aryWeaponInfos[77].display    = "伯莱塔 M12";
    g_aryWeaponInfos[77].category   = "冲锋枪";
    g_aryWeaponInfos[77].price      = 1750;
    g_aryWeaponInfos[77].weight     = 3;

    g_aryWeaponInfos[78].classname  = "weapon_m14";
    g_aryWeaponInfos[78].display    = "M14";
    g_aryWeaponInfos[78].category   = "步枪";
    g_aryWeaponInfos[78].price      = 3175;
    g_aryWeaponInfos[78].weight     = 4;

    g_aryWeaponInfos[79].classname  = "weapon_m16a1";
    g_aryWeaponInfos[79].display    = "M16A1";
    g_aryWeaponInfos[79].category   = "步枪";
    g_aryWeaponInfos[79].price      = 2900;
    g_aryWeaponInfos[79].weight     = 4;

    g_aryWeaponInfos[80].classname  = "weapon_m16a1_m203";
    g_aryWeaponInfos[80].display    = "M16A1 M203";
    g_aryWeaponInfos[80].category   = "步枪";
    g_aryWeaponInfos[80].price      = 3500;
    g_aryWeaponInfos[80].weight     = 4;

    g_aryWeaponInfos[81].classname  = "weapon_m16mine";
    g_aryWeaponInfos[81].display    = "M16绊雷";
    g_aryWeaponInfos[81].category   = "地雷";
    g_aryWeaponInfos[81].price      = 450;
    g_aryWeaponInfos[81].weight     = 2;

    g_aryWeaponInfos[82].classname  = "weapon_m16_xm148";
    g_aryWeaponInfos[82].display    = "M16 XM148";
    g_aryWeaponInfos[82].category   = "步枪";
    g_aryWeaponInfos[82].price      = 3500;
    g_aryWeaponInfos[82].weight     = 4;

    g_aryWeaponInfos[83].classname  = "weapon_m1895";
    g_aryWeaponInfos[83].display    = "纳甘 M1895";
    g_aryWeaponInfos[83].category   = "左轮手枪";
    g_aryWeaponInfos[83].price      = 700;
    g_aryWeaponInfos[83].weight     = 1;

    g_aryWeaponInfos[84].classname  = "weapon_m1897";
    g_aryWeaponInfos[84].display    = "M1897 堑壕枪";
    g_aryWeaponInfos[84].category   = "霰弹枪";
    g_aryWeaponInfos[84].price      = 1850;
    g_aryWeaponInfos[84].weight     = 3;

    g_aryWeaponInfos[85].classname  = "weapon_m18r";
    g_aryWeaponInfos[85].display    = "M18 烟雾弹";
    g_aryWeaponInfos[85].category   = "手榴弹";
    g_aryWeaponInfos[85].price      = 100;
    g_aryWeaponInfos[85].weight     = 0;

    g_aryWeaponInfos[86].classname  = "weapon_m1903";
    g_aryWeaponInfos[86].display    = "春田 M1903";
    g_aryWeaponInfos[86].category   = "栓动步枪";
    g_aryWeaponInfos[86].price      = 1175;
    g_aryWeaponInfos[86].weight     = 3;

    g_aryWeaponInfos[87].classname  = "weapon_m1903s";
    g_aryWeaponInfos[87].display    = "春田 M1903A4";
    g_aryWeaponInfos[87].category   = "狙击步枪";
    g_aryWeaponInfos[87].price      = 1275;
    g_aryWeaponInfos[87].weight     = 3;

    g_aryWeaponInfos[88].classname  = "weapon_m1905_bayonet";
    g_aryWeaponInfos[88].display    = "M1905刺刀";
    g_aryWeaponInfos[88].category   = "近战武器";
    g_aryWeaponInfos[88].price      = 425;
    g_aryWeaponInfos[88].weight     = 1;

    g_aryWeaponInfos[89].classname  = "weapon_m1911";
    g_aryWeaponInfos[89].display    = "M1911A1";
    g_aryWeaponInfos[89].category   = "手枪";
    g_aryWeaponInfos[89].price      = 625;
    g_aryWeaponInfos[89].weight     = 1;

    g_aryWeaponInfos[90].classname  = "weapon_m1917";
    g_aryWeaponInfos[90].display    = "M1917";
    g_aryWeaponInfos[90].category   = "左轮手枪";
    g_aryWeaponInfos[90].price      = 675;
    g_aryWeaponInfos[90].weight     = 1;

    g_aryWeaponInfos[91].classname  = "weapon_m1918";
    g_aryWeaponInfos[91].display    = "M1918A2 BAR";
    g_aryWeaponInfos[91].category   = "步枪";
    g_aryWeaponInfos[91].price      = 3350;
    g_aryWeaponInfos[91].weight     = 4;

    g_aryWeaponInfos[92].classname  = "weapon_m1918_bar";
    g_aryWeaponInfos[92].display    = "M1918A2 BAR";
    g_aryWeaponInfos[92].category   = "机枪";
    g_aryWeaponInfos[92].price      = 3650;
    g_aryWeaponInfos[92].weight     = 5;

    g_aryWeaponInfos[93].classname  = "weapon_m1919a6";
    g_aryWeaponInfos[93].display    = "M1919A6";
    g_aryWeaponInfos[93].category   = "机枪";
    g_aryWeaponInfos[93].price      = 4350;
    g_aryWeaponInfos[93].weight     = 6;

    g_aryWeaponInfos[94].classname  = "weapon_m1919a6_zombie";
    g_aryWeaponInfos[94].display    = "M1919A6";
    g_aryWeaponInfos[94].category   = "机枪";
    g_aryWeaponInfos[94].price      = 4350;
    g_aryWeaponInfos[94].weight     = 4;

    g_aryWeaponInfos[95].classname  = "weapon_m1928";
    g_aryWeaponInfos[95].display    = "汤普森 M1928";
    g_aryWeaponInfos[95].category   = "冲锋枪";
    g_aryWeaponInfos[95].price      = 2300;
    g_aryWeaponInfos[95].weight     = 3;

    g_aryWeaponInfos[96].classname  = "weapon_m1942";
    g_aryWeaponInfos[96].display    = "M1942开山刀";
    g_aryWeaponInfos[96].category   = "近战武器";
    g_aryWeaponInfos[96].price      = 375;
    g_aryWeaponInfos[96].weight     = 1;

    g_aryWeaponInfos[97].classname  = "weapon_m1a1";
    g_aryWeaponInfos[97].display    = "汤普森 M1A1";
    g_aryWeaponInfos[97].category   = "冲锋枪";
    g_aryWeaponInfos[97].price      = 1900;
    g_aryWeaponInfos[97].weight     = 3;

    g_aryWeaponInfos[98].classname  = "weapon_m1a1_sog";
    g_aryWeaponInfos[98].display    = "汤普森 M1A1 特种";
    g_aryWeaponInfos[98].category   = "冲锋枪";
    g_aryWeaponInfos[98].price      = 1800;
    g_aryWeaponInfos[98].weight     = 3;

    g_aryWeaponInfos[99].classname  = "weapon_m1c";
    g_aryWeaponInfos[99].display    = "M1A1 卡宾枪";
    g_aryWeaponInfos[99].category   = "卡宾枪";
    g_aryWeaponInfos[99].price      = 1250;
    g_aryWeaponInfos[99].weight     = 3;

    g_aryWeaponInfos[100].classname = "weapon_m1c_sog";
    g_aryWeaponInfos[100].display   = "M1A1 卡宾枪 特种";
    g_aryWeaponInfos[100].category  = "卡宾枪";
    g_aryWeaponInfos[100].price     = 1150;
    g_aryWeaponInfos[100].weight    = 3;

    g_aryWeaponInfos[101].classname = "weapon_m1g";
    g_aryWeaponInfos[101].display   = "M1 加兰德";
    g_aryWeaponInfos[101].category  = "步枪";
    g_aryWeaponInfos[101].price     = 3300;
    g_aryWeaponInfos[101].weight    = 4;

    g_aryWeaponInfos[102].classname = "weapon_m1gs";
    g_aryWeaponInfos[102].display   = "M1D 加兰德";
    g_aryWeaponInfos[102].category  = "狙击步枪";
    g_aryWeaponInfos[102].price     = 3400;
    g_aryWeaponInfos[102].weight    = 4;

    g_aryWeaponInfos[103].classname = "weapon_m21s";
    g_aryWeaponInfos[103].display   = "XM21";
    g_aryWeaponInfos[103].category  = "狙击步枪";
    g_aryWeaponInfos[103].price     = 3275;
    g_aryWeaponInfos[103].weight    = 4;

    g_aryWeaponInfos[104].classname = "weapon_m26";
    g_aryWeaponInfos[104].display   = "M26 破片手榴弹";
    g_aryWeaponInfos[104].category  = "手榴弹";
    g_aryWeaponInfos[104].price     = 400;
    g_aryWeaponInfos[104].weight    = 0;

    g_aryWeaponInfos[105].classname = "weapon_m2c";
    g_aryWeaponInfos[105].display   = "M2 卡宾枪";
    g_aryWeaponInfos[105].category  = "卡宾枪";
    g_aryWeaponInfos[105].price     = 2500;
    g_aryWeaponInfos[105].weight    = 4;

    g_aryWeaponInfos[106].classname = "weapon_m2c_sog";
    g_aryWeaponInfos[106].display   = "M2 卡宾枪 特种";
    g_aryWeaponInfos[106].category  = "卡宾枪";
    g_aryWeaponInfos[106].price     = 2400;
    g_aryWeaponInfos[106].weight    = 4;

    g_aryWeaponInfos[107].classname = "weapon_m34";
    g_aryWeaponInfos[107].display   = "M34 白磷手榴弹";
    g_aryWeaponInfos[107].category  = "手榴弹";
    g_aryWeaponInfos[107].price     = 475;
    g_aryWeaponInfos[107].weight    = 0;

    g_aryWeaponInfos[108].classname = "weapon_m37";
    g_aryWeaponInfos[108].display   = "伊萨卡 M37 堑壕枪";
    g_aryWeaponInfos[108].category  = "霰弹枪";
    g_aryWeaponInfos[108].price     = 1850;
    g_aryWeaponInfos[108].weight    = 3;

    g_aryWeaponInfos[109].classname = "weapon_m38";
    g_aryWeaponInfos[109].display   = "莫辛 M38";
    g_aryWeaponInfos[109].category  = "卡宾枪";
    g_aryWeaponInfos[109].price     = 1050;
    g_aryWeaponInfos[109].weight    = 3;

    g_aryWeaponInfos[110].classname = "weapon_m38s";
    g_aryWeaponInfos[110].display   = "莫辛 M91/30 PU";
    g_aryWeaponInfos[110].category  = "狙击步枪";
    g_aryWeaponInfos[110].price     = 1250;
    g_aryWeaponInfos[110].weight    = 3;

    g_aryWeaponInfos[111].classname = "weapon_m3a1";
    g_aryWeaponInfos[111].display   = "M3A1 注油枪";
    g_aryWeaponInfos[111].category  = "冲锋枪";
    g_aryWeaponInfos[111].price     = 2125;
    g_aryWeaponInfos[111].weight    = 3;

    g_aryWeaponInfos[112].classname = "weapon_m3a1_sog";
    g_aryWeaponInfos[112].display   = "M3A1 注油枪 特种";
    g_aryWeaponInfos[112].category  = "冲锋枪";
    g_aryWeaponInfos[112].price     = 2075;
    g_aryWeaponInfos[112].weight    = 3;

    g_aryWeaponInfos[113].classname = "weapon_m40";
    g_aryWeaponInfos[113].display   = "M40";
    g_aryWeaponInfos[113].category  = "狙击步枪";
    g_aryWeaponInfos[113].price     = 1275;
    g_aryWeaponInfos[113].weight    = 3;

    g_aryWeaponInfos[114].classname = "weapon_m45";
    g_aryWeaponInfos[114].display   = "卡尔古斯塔夫 m/45";
    g_aryWeaponInfos[114].category  = "冲锋枪";
    g_aryWeaponInfos[114].price     = 1800;
    g_aryWeaponInfos[114].weight    = 3;

    g_aryWeaponInfos[115].classname = "weapon_m45_sog";
    g_aryWeaponInfos[115].display   = "卡尔古斯塔夫 m/45 特种";
    g_aryWeaponInfos[115].category  = "冲锋枪";
    g_aryWeaponInfos[115].price     = 1775;
    g_aryWeaponInfos[115].weight    = 3;

    g_aryWeaponInfos[116].classname = "weapon_m50";
    g_aryWeaponInfos[116].display   = "麦德森 M/50";
    g_aryWeaponInfos[116].category  = "冲锋枪";
    g_aryWeaponInfos[116].price     = 1850;
    g_aryWeaponInfos[116].weight    = 3;

    g_aryWeaponInfos[117].classname = "weapon_m50r";
    g_aryWeaponInfos[117].display   = "雷辛 M50";
    g_aryWeaponInfos[117].category  = "冲锋枪";
    g_aryWeaponInfos[117].price     = 1900;
    g_aryWeaponInfos[117].weight    = 3;

    g_aryWeaponInfos[118].classname = "weapon_m55r";
    g_aryWeaponInfos[118].display   = "雷辛 M55";
    g_aryWeaponInfos[118].category  = "冲锋枪";
    g_aryWeaponInfos[118].price     = 1900;
    g_aryWeaponInfos[118].weight    = 3;

    g_aryWeaponInfos[119].classname = "weapon_m56";
    g_aryWeaponInfos[119].display   = "M56";
    g_aryWeaponInfos[119].category  = "冲锋枪";
    g_aryWeaponInfos[119].price     = 2000;
    g_aryWeaponInfos[119].weight    = 3;

    g_aryWeaponInfos[120].classname = "weapon_m60";
    g_aryWeaponInfos[120].display   = "M60";
    g_aryWeaponInfos[120].category  = "机枪";
    g_aryWeaponInfos[120].price     = 3800;
    g_aryWeaponInfos[120].weight    = 6;

    g_aryWeaponInfos[121].classname = "weapon_m601";
    g_aryWeaponInfos[121].display   = "M601";
    g_aryWeaponInfos[121].category  = "步枪";
    g_aryWeaponInfos[121].price     = 2900;
    g_aryWeaponInfos[121].weight    = 4;

    g_aryWeaponInfos[122].classname = "weapon_m605";
    g_aryWeaponInfos[122].display   = "M605B";
    g_aryWeaponInfos[122].category  = "步枪";
    g_aryWeaponInfos[122].price     = 2900;
    g_aryWeaponInfos[122].weight    = 4;

    g_aryWeaponInfos[123].classname = "weapon_m607";
    g_aryWeaponInfos[123].display   = "M607";
    g_aryWeaponInfos[123].category  = "卡宾枪";
    g_aryWeaponInfos[123].price     = 2700;
    g_aryWeaponInfos[123].weight    = 4;

    g_aryWeaponInfos[124].classname = "weapon_m607s";
    g_aryWeaponInfos[124].display   = "M607 4x";
    g_aryWeaponInfos[124].category  = "狙击步枪";
    g_aryWeaponInfos[124].price     = 2600;
    g_aryWeaponInfos[124].weight    = 4;

    g_aryWeaponInfos[125].classname = "weapon_m607_oeg";
    g_aryWeaponInfos[125].display   = "M607 OEG";
    g_aryWeaponInfos[125].category  = "卡宾枪";
    g_aryWeaponInfos[125].price     = 2600;
    g_aryWeaponInfos[125].weight    = 4;

    g_aryWeaponInfos[126].classname = "weapon_m60b";
    g_aryWeaponInfos[126].display   = "M60 弹链";
    g_aryWeaponInfos[126].category  = "机枪";
    g_aryWeaponInfos[126].price     = 4250;
    g_aryWeaponInfos[126].weight    = 6;

    g_aryWeaponInfos[127].classname = "weapon_m60r";
    g_aryWeaponInfos[127].display   = "雷辛 M60";
    g_aryWeaponInfos[127].category  = "卡宾枪";
    g_aryWeaponInfos[127].price     = 1900;
    g_aryWeaponInfos[127].weight    = 3;

    g_aryWeaponInfos[128].classname = "weapon_m656";
    g_aryWeaponInfos[128].display   = "M656";
    g_aryWeaponInfos[128].category  = "狙击步枪";
    g_aryWeaponInfos[128].price     = 3100;
    g_aryWeaponInfos[128].weight    = 4;

    g_aryWeaponInfos[129].classname = "weapon_m6a1";
    g_aryWeaponInfos[129].display   = "M6A1 毒气弹";
    g_aryWeaponInfos[129].category  = "手榴弹";
    g_aryWeaponInfos[129].price     = 675;
    g_aryWeaponInfos[129].weight    = 0;

    g_aryWeaponInfos[130].classname = "weapon_m72";
    g_aryWeaponInfos[130].display   = "M72 LAW";
    g_aryWeaponInfos[130].category  = "火箭发射器";
    g_aryWeaponInfos[130].price     = 5250;
    g_aryWeaponInfos[130].weight    = 5;

    g_aryWeaponInfos[131].classname = "weapon_m72_zm";
    g_aryWeaponInfos[131].display   = "M72 LAW";
    g_aryWeaponInfos[131].category  = "火箭发射器";
    g_aryWeaponInfos[131].price     = 5250;
    g_aryWeaponInfos[131].weight    = 5;

    g_aryWeaponInfos[132].classname = "weapon_m79";
    g_aryWeaponInfos[132].display   = "M79 榴弹发射器";
    g_aryWeaponInfos[132].category  = "榴弹发射器";
    g_aryWeaponInfos[132].price     = 4175;
    g_aryWeaponInfos[132].weight    = 4;

    g_aryWeaponInfos[133].classname = "weapon_m79_sog";
    g_aryWeaponInfos[133].display   = "M79 榴弹发射器 特种";
    g_aryWeaponInfos[133].category  = "榴弹发射器";
    g_aryWeaponInfos[133].price     = 4175;
    g_aryWeaponInfos[133].weight    = 4;

    g_aryWeaponInfos[134].classname = "weapon_m79_sog_zm";
    g_aryWeaponInfos[134].display   = "M79 榴弹发射器 特种";
    g_aryWeaponInfos[134].category  = "榴弹发射器";
    g_aryWeaponInfos[134].price     = 4175;
    g_aryWeaponInfos[134].weight    = 4;

    g_aryWeaponInfos[135].classname = "weapon_m79_zm";
    g_aryWeaponInfos[135].display   = "M79 榴弹发射器";
    g_aryWeaponInfos[135].category  = "榴弹发射器";
    g_aryWeaponInfos[135].price     = 4175;
    g_aryWeaponInfos[135].weight    = 4;

    g_aryWeaponInfos[136].classname = "weapon_m7_bayonet";
    g_aryWeaponInfos[136].display   = "M7刺刀";
    g_aryWeaponInfos[136].category  = "近战武器";
    g_aryWeaponInfos[136].price     = 250;
    g_aryWeaponInfos[136].weight    = 1;

    g_aryWeaponInfos[137].classname = "weapon_m8";
    g_aryWeaponInfos[137].display   = "M8信号枪";
    g_aryWeaponInfos[137].category  = "信号枪";
    g_aryWeaponInfos[137].price     = 175;
    g_aryWeaponInfos[137].weight    = 1;

    g_aryWeaponInfos[138].classname = "weapon_m870";
    g_aryWeaponInfos[138].display   = "M870";
    g_aryWeaponInfos[138].category  = "霰弹枪";
    g_aryWeaponInfos[138].price     = 1100;
    g_aryWeaponInfos[138].weight    = 3;

    g_aryWeaponInfos[139].classname = "weapon_m91";
    g_aryWeaponInfos[139].display   = "莫辛 M91/30";
    g_aryWeaponInfos[139].category  = "栓动步枪";
    g_aryWeaponInfos[139].price     = 1175;
    g_aryWeaponInfos[139].weight    = 3;

    g_aryWeaponInfos[140].classname = "weapon_m9a1";
    g_aryWeaponInfos[140].display   = "M9A1-7火焰喷射器";
    g_aryWeaponInfos[140].category  = "杂项装备";
    g_aryWeaponInfos[140].price     = 6000;
    g_aryWeaponInfos[140].weight    = 6;

    g_aryWeaponInfos[141].classname = "weapon_mac10";
    g_aryWeaponInfos[141].display   = "MAC-10";
    g_aryWeaponInfos[141].category  = "冲锋手枪";
    g_aryWeaponInfos[141].price     = 1500;
    g_aryWeaponInfos[141].weight    = 2;

    g_aryWeaponInfos[142].classname = "weapon_mac10_sog";
    g_aryWeaponInfos[142].display   = "MAC-10 特种";
    g_aryWeaponInfos[142].category  = "冲锋手枪";
    g_aryWeaponInfos[142].price     = 1475;
    g_aryWeaponInfos[142].weight    = 2;

    g_aryWeaponInfos[143].classname = "weapon_mamba";
    g_aryWeaponInfos[143].display   = "WEAPON_MAMBA";
    g_aryWeaponInfos[143].category  = "手枪";
    g_aryWeaponInfos[143].price     = 625;
    g_aryWeaponInfos[143].weight    = 2;

    g_aryWeaponInfos[144].classname = "weapon_mas36";
    g_aryWeaponInfos[144].display   = "MAS-36";
    g_aryWeaponInfos[144].category  = "栓动步枪";
    g_aryWeaponInfos[144].price     = 2175;
    g_aryWeaponInfos[144].weight    = 3;

    g_aryWeaponInfos[145].classname = "weapon_mas36_cr39";
    g_aryWeaponInfos[145].display   = "MAS-36";
    g_aryWeaponInfos[145].category  = "栓动步枪";
    g_aryWeaponInfos[145].price     = 2175;
    g_aryWeaponInfos[145].weight    = 3;

    g_aryWeaponInfos[146].classname = "weapon_mas38";
    g_aryWeaponInfos[146].display   = "MAS-38";
    g_aryWeaponInfos[146].category  = "冲锋枪";
    g_aryWeaponInfos[146].price     = 1800;
    g_aryWeaponInfos[146].weight    = 3;

    g_aryWeaponInfos[147].classname = "weapon_mas49";
    g_aryWeaponInfos[147].display   = "MAS-49";
    g_aryWeaponInfos[147].category  = "步枪";
    g_aryWeaponInfos[147].price     = 3375;
    g_aryWeaponInfos[147].weight    = 4;

    g_aryWeaponInfos[148].classname = "weapon_mas49s";
    g_aryWeaponInfos[148].display   = "MAS-49 APX L806";
    g_aryWeaponInfos[148].category  = "狙击步枪";
    g_aryWeaponInfos[148].price     = 3425;
    g_aryWeaponInfos[148].weight    = 4;

    g_aryWeaponInfos[149].classname = "weapon_mat49";
    g_aryWeaponInfos[149].display   = "MAT-49";
    g_aryWeaponInfos[149].category  = "冲锋枪";
    g_aryWeaponInfos[149].price     = 1900;
    g_aryWeaponInfos[149].weight    = 3;

    g_aryWeaponInfos[150].classname = "weapon_mat49_sog";
    g_aryWeaponInfos[150].display   = "MAT-49 特种";
    g_aryWeaponInfos[150].category  = "冲锋枪";
    g_aryWeaponInfos[150].price     = 1850;
    g_aryWeaponInfos[150].weight    = 3;

    g_aryWeaponInfos[151].classname = "weapon_md63";
    g_aryWeaponInfos[151].display   = "PM md.63";
    g_aryWeaponInfos[151].category  = "步枪";
    g_aryWeaponInfos[151].price     = 2975;
    g_aryWeaponInfos[151].weight    = 4;

    g_aryWeaponInfos[152].classname = "weapon_medicbox_us";
    g_aryWeaponInfos[152].display   = "医疗包";
    g_aryWeaponInfos[152].category  = "杂项装备";
    g_aryWeaponInfos[152].price     = 575;
    g_aryWeaponInfos[152].weight    = 0;

    g_aryWeaponInfos[153].classname = "weapon_medicbox_vc";
    g_aryWeaponInfos[153].display   = "医疗包";
    g_aryWeaponInfos[153].category  = "杂项装备";
    g_aryWeaponInfos[153].price     = 575;
    g_aryWeaponInfos[153].weight    = 0;

    g_aryWeaponInfos[154].classname = "weapon_mg43";
    g_aryWeaponInfos[154].display   = "MG34";
    g_aryWeaponInfos[154].category  = "机枪";
    g_aryWeaponInfos[154].price     = 3800;
    g_aryWeaponInfos[154].weight    = 5;

    g_aryWeaponInfos[155].classname = "weapon_mk22";
    g_aryWeaponInfos[155].display   = "史密斯威森 M39-2";
    g_aryWeaponInfos[155].category  = "手枪";
    g_aryWeaponInfos[155].price     = 575;
    g_aryWeaponInfos[155].weight    = 1;

    g_aryWeaponInfos[156].classname = "weapon_mk22_mod0";
    g_aryWeaponInfos[156].display   = "Mk22 Mod0";
    g_aryWeaponInfos[156].category  = "手枪";
    g_aryWeaponInfos[156].price     = 550;
    g_aryWeaponInfos[156].weight    = 1;

    g_aryWeaponInfos[157].classname = "weapon_mk3a2";
    g_aryWeaponInfos[157].display   = "MK3A2 高爆手榴弹";
    g_aryWeaponInfos[157].category  = "手榴弹";
    g_aryWeaponInfos[157].price     = 425;
    g_aryWeaponInfos[157].weight    = 0;

    g_aryWeaponInfos[158].classname = "weapon_mk4mod0";
    g_aryWeaponInfos[158].display   = "Mk4 Mod0";
    g_aryWeaponInfos[158].category  = "步枪";
    g_aryWeaponInfos[158].price     = 2800;
    g_aryWeaponInfos[158].weight    = 4;

    g_aryWeaponInfos[159].classname = "weapon_mle1935";
    g_aryWeaponInfos[159].display   = "MAS-35S";
    g_aryWeaponInfos[159].category  = "手枪";
    g_aryWeaponInfos[159].price     = 600;
    g_aryWeaponInfos[159].weight    = 1;

    g_aryWeaponInfos[160].classname = "weapon_molotov";
    g_aryWeaponInfos[160].display   = "燃烧瓶";
    g_aryWeaponInfos[160].category  = "手榴弹";
    g_aryWeaponInfos[160].price     = 775;
    g_aryWeaponInfos[160].weight    = 0;

    g_aryWeaponInfos[161].classname = "weapon_mp40";
    g_aryWeaponInfos[161].display   = "MP-40";
    g_aryWeaponInfos[161].category  = "冲锋枪";
    g_aryWeaponInfos[161].price     = 1950;
    g_aryWeaponInfos[161].weight    = 3;

    g_aryWeaponInfos[162].classname = "weapon_owen_gun";
    g_aryWeaponInfos[162].display   = "欧文";
    g_aryWeaponInfos[162].category  = "冲锋枪";
    g_aryWeaponInfos[162].price     = 1850;
    g_aryWeaponInfos[162].weight    = 3;

    g_aryWeaponInfos[163].classname = "weapon_p38";
    g_aryWeaponInfos[163].display   = "瓦尔特 P38";
    g_aryWeaponInfos[163].category  = "手枪";
    g_aryWeaponInfos[163].price     = 575;
    g_aryWeaponInfos[163].weight    = 1;

    g_aryWeaponInfos[164].classname = "weapon_pb";
    g_aryWeaponInfos[164].display   = "马卡洛夫 PB";
    g_aryWeaponInfos[164].category  = "手枪";
    g_aryWeaponInfos[164].price     = 550;
    g_aryWeaponInfos[164].weight    = 1;

    g_aryWeaponInfos[165].classname = "weapon_pm";
    g_aryWeaponInfos[165].display   = "马卡洛夫 PM";
    g_aryWeaponInfos[165].category  = "手枪";
    g_aryWeaponInfos[165].price     = 575;
    g_aryWeaponInfos[165].weight    = 1;

    g_aryWeaponInfos[166].classname = "weapon_pm63";
    g_aryWeaponInfos[166].display   = "PM-63 Rak";
    g_aryWeaponInfos[166].category  = "冲锋手枪";
    g_aryWeaponInfos[166].price     = 1650;
    g_aryWeaponInfos[166].weight    = 2;

    g_aryWeaponInfos[167].classname = "weapon_ppk";
    g_aryWeaponInfos[167].display   = "瓦尔特 PPK";
    g_aryWeaponInfos[167].category  = "手枪";
    g_aryWeaponInfos[167].price     = 550;
    g_aryWeaponInfos[167].weight    = 1;

    g_aryWeaponInfos[168].classname = "weapon_pps43";
    g_aryWeaponInfos[168].display   = "PPS-43";
    g_aryWeaponInfos[168].category  = "冲锋枪";
    g_aryWeaponInfos[168].price     = 1800;
    g_aryWeaponInfos[168].weight    = 3;

    g_aryWeaponInfos[169].classname = "weapon_ppsh41";
    g_aryWeaponInfos[169].display   = "PPSh-41";
    g_aryWeaponInfos[169].category  = "冲锋枪";
    g_aryWeaponInfos[169].price     = 1750;
    g_aryWeaponInfos[169].weight    = 3;

    g_aryWeaponInfos[170].classname = "weapon_ppsh41d";
    g_aryWeaponInfos[170].display   = "PPSh-41 弹鼓";
    g_aryWeaponInfos[170].category  = "冲锋枪";
    g_aryWeaponInfos[170].price     = 2250;
    g_aryWeaponInfos[170].weight    = 3;

    g_aryWeaponInfos[171].classname = "weapon_ptrd";
    g_aryWeaponInfos[171].display   = "PTRD-41";
    g_aryWeaponInfos[171].category  = "杂项装备";
    g_aryWeaponInfos[171].price     = 3850;
    g_aryWeaponInfos[171].weight    = 6;

    g_aryWeaponInfos[172].classname = "weapon_qspr";
    g_aryWeaponInfos[172].display   = "QSPR";
    g_aryWeaponInfos[172].category  = "左轮手枪";
    g_aryWeaponInfos[172].price     = 450;
    g_aryWeaponInfos[172].weight    = 1;

    g_aryWeaponInfos[173].classname = "weapon_rg42";
    g_aryWeaponInfos[173].display   = "中式绊雷";
    g_aryWeaponInfos[173].category  = "地雷";
    g_aryWeaponInfos[173].price     = 450;
    g_aryWeaponInfos[173].weight    = 2;

    g_aryWeaponInfos[174].classname = "weapon_rhogun";
    g_aryWeaponInfos[174].display   = "WEAPON_RHOGUN";
    g_aryWeaponInfos[174].category  = "冲锋手枪";
    g_aryWeaponInfos[174].price     = 1650;
    g_aryWeaponInfos[174].weight    = 2;

    g_aryWeaponInfos[175].classname = "weapon_robust";
    g_aryWeaponInfos[175].display   = "Robust 222 双管猎枪";
    g_aryWeaponInfos[175].category  = "霰弹枪";
    g_aryWeaponInfos[175].price     = 950;
    g_aryWeaponInfos[175].weight    = 3;

    g_aryWeaponInfos[176].classname = "weapon_robust_sog";
    g_aryWeaponInfos[176].display   = "Robust 222 双管猎枪 被锯掉了";
    g_aryWeaponInfos[176].category  = "霰弹枪";
    g_aryWeaponInfos[176].price     = 900;
    g_aryWeaponInfos[176].weight    = 2;

    g_aryWeaponInfos[177].classname = "weapon_rp46";
    g_aryWeaponInfos[177].display   = "RP-46";
    g_aryWeaponInfos[177].category  = "机枪";
    g_aryWeaponInfos[177].price     = 4100;
    g_aryWeaponInfos[177].weight    = 6;

    g_aryWeaponInfos[178].classname = "weapon_rpd";
    g_aryWeaponInfos[178].display   = "RPD";
    g_aryWeaponInfos[178].category  = "机枪";
    g_aryWeaponInfos[178].price     = 3750;
    g_aryWeaponInfos[178].weight    = 6;

    g_aryWeaponInfos[179].classname = "weapon_rpd_sog";
    g_aryWeaponInfos[179].display   = "RPD 特种";
    g_aryWeaponInfos[179].category  = "机枪";
    g_aryWeaponInfos[179].price     = 3550;
    g_aryWeaponInfos[179].weight    = 6;

    g_aryWeaponInfos[180].classname = "weapon_rpg2";
    g_aryWeaponInfos[180].display   = "RPG-2";
    g_aryWeaponInfos[180].category  = "榴弹发射器";
    g_aryWeaponInfos[180].price     = 4175;
    g_aryWeaponInfos[180].weight    = 4;

    g_aryWeaponInfos[181].classname = "weapon_rpg2_zm";
    g_aryWeaponInfos[181].display   = "RPG-2";
    g_aryWeaponInfos[181].category  = "榴弹发射器";
    g_aryWeaponInfos[181].price     = 4175;
    g_aryWeaponInfos[181].weight    = 4;

    g_aryWeaponInfos[182].classname = "weapon_rpg7";
    g_aryWeaponInfos[182].display   = "RPG-7";
    g_aryWeaponInfos[182].category  = "火箭发射器";
    g_aryWeaponInfos[182].price     = 5250;
    g_aryWeaponInfos[182].weight    = 5;

    g_aryWeaponInfos[183].classname = "weapon_rpg7_zm";
    g_aryWeaponInfos[183].display   = "RPG-7";
    g_aryWeaponInfos[183].category  = "火箭发射器";
    g_aryWeaponInfos[183].price     = 5250;
    g_aryWeaponInfos[183].weight    = 5;

    g_aryWeaponInfos[184].classname = "weapon_rpk";
    g_aryWeaponInfos[184].display   = "RPK";
    g_aryWeaponInfos[184].category  = "机枪";
    g_aryWeaponInfos[184].price     = 3475;
    g_aryWeaponInfos[184].weight    = 6;

    g_aryWeaponInfos[185].classname = "weapon_ruby";
    g_aryWeaponInfos[185].display   = "7.65mm 红宝石";
    g_aryWeaponInfos[185].category  = "手枪";
    g_aryWeaponInfos[185].price     = 625;
    g_aryWeaponInfos[185].weight    = 1;

    g_aryWeaponInfos[186].classname = "weapon_shovel_us";
    g_aryWeaponInfos[186].display   = "AMES 1966工兵铲";
    g_aryWeaponInfos[186].category  = "近战武器";
    g_aryWeaponInfos[186].price     = 375;
    g_aryWeaponInfos[186].weight    = 1;

    g_aryWeaponInfos[187].classname = "weapon_shovel_vc";
    g_aryWeaponInfos[187].display   = "65式工兵铲";
    g_aryWeaponInfos[187].category  = "近战武器";
    g_aryWeaponInfos[187].price     = 375;
    g_aryWeaponInfos[187].weight    = 1;

    g_aryWeaponInfos[188].classname = "weapon_sickle";
    g_aryWeaponInfos[188].display   = "镰刀";
    g_aryWeaponInfos[188].category  = "近战武器";
    g_aryWeaponInfos[188].price     = 375;
    g_aryWeaponInfos[188].weight    = 1;

    g_aryWeaponInfos[189].classname = "weapon_sks";
    g_aryWeaponInfos[189].display   = "SKS";
    g_aryWeaponInfos[189].category  = "卡宾枪";
    g_aryWeaponInfos[189].price     = 1550;
    g_aryWeaponInfos[189].weight    = 3;

    g_aryWeaponInfos[190].classname = "weapon_stenmk2";
    g_aryWeaponInfos[190].display   = "司登 MK.II";
    g_aryWeaponInfos[190].category  = "冲锋枪";
    g_aryWeaponInfos[190].price     = 1900;
    g_aryWeaponInfos[190].weight    = 3;

    g_aryWeaponInfos[191].classname = "weapon_stenmk2_sog";
    g_aryWeaponInfos[191].display   = "司登 MK.IIS 特种";
    g_aryWeaponInfos[191].category  = "冲锋枪";
    g_aryWeaponInfos[191].price     = 1850;
    g_aryWeaponInfos[191].weight    = 3;

    g_aryWeaponInfos[192].classname = "weapon_sterling";
    g_aryWeaponInfos[192].display   = "斯特林 L2A3";
    g_aryWeaponInfos[192].category  = "冲锋枪";
    g_aryWeaponInfos[192].price     = 1900;
    g_aryWeaponInfos[192].weight    = 3;

    g_aryWeaponInfos[193].classname = "weapon_sterling_sog";
    g_aryWeaponInfos[193].display   = "斯特林 L34A1 特种";
    g_aryWeaponInfos[193].category  = "冲锋枪";
    g_aryWeaponInfos[193].price     = 1850;
    g_aryWeaponInfos[193].weight    = 3;

    g_aryWeaponInfos[194].classname = "weapon_stg44";
    g_aryWeaponInfos[194].display   = "StG-44";
    g_aryWeaponInfos[194].category  = "步枪";
    g_aryWeaponInfos[194].price     = 2700;
    g_aryWeaponInfos[194].weight    = 4;

    g_aryWeaponInfos[195].classname = "weapon_stg44s";
    g_aryWeaponInfos[195].display   = "StG-44 ZF4";
    g_aryWeaponInfos[195].category  = "狙击步枪";
    g_aryWeaponInfos[195].price     = 2600;
    g_aryWeaponInfos[195].weight    = 4;

    g_aryWeaponInfos[196].classname = "weapon_stg44_zf41";
    g_aryWeaponInfos[196].display   = "StG-44 ZF41";
    g_aryWeaponInfos[196].category  = "步枪";
    g_aryWeaponInfos[196].price     = 2600;
    g_aryWeaponInfos[196].weight    = 4;

    g_aryWeaponInfos[197].classname = "weapon_stoner63";
    g_aryWeaponInfos[197].display   = "斯通纳 63A 突击队员型";
    g_aryWeaponInfos[197].category  = "机枪";
    g_aryWeaponInfos[197].price     = 3700;
    g_aryWeaponInfos[197].weight    = 6;

    g_aryWeaponInfos[198].classname = "weapon_stoner63_b";
    g_aryWeaponInfos[198].display   = "斯通纳 63A 自动步枪";
    g_aryWeaponInfos[198].category  = "机枪";
    g_aryWeaponInfos[198].price     = 3100;
    g_aryWeaponInfos[198].weight    = 5;

    g_aryWeaponInfos[199].classname = "weapon_stoner63_c";
    g_aryWeaponInfos[199].display   = "斯通纳 63A 卡宾枪";
    g_aryWeaponInfos[199].category  = "卡宾枪";
    g_aryWeaponInfos[199].price     = 2850;
    g_aryWeaponInfos[199].weight    = 4;

    g_aryWeaponInfos[200].classname = "weapon_stoner63_l";
    g_aryWeaponInfos[200].display   = "斯通纳 63A 轻机枪";
    g_aryWeaponInfos[200].category  = "机枪";
    g_aryWeaponInfos[200].price     = 4100;
    g_aryWeaponInfos[200].weight    = 6;

    g_aryWeaponInfos[201].classname = "weapon_stoner63_r";
    g_aryWeaponInfos[201].display   = "斯通纳 63A 步枪";
    g_aryWeaponInfos[201].category  = "步枪";
    g_aryWeaponInfos[201].price     = 3075;
    g_aryWeaponInfos[201].weight    = 4;

    g_aryWeaponInfos[202].classname = "weapon_svd";
    g_aryWeaponInfos[202].display   = "SVD";
    g_aryWeaponInfos[202].category  = "狙击步枪";
    g_aryWeaponInfos[202].price     = 2650;
    g_aryWeaponInfos[202].weight    = 4;

    g_aryWeaponInfos[203].classname = "weapon_svt40";
    g_aryWeaponInfos[203].display   = "AVT-40";
    g_aryWeaponInfos[203].category  = "步枪";
    g_aryWeaponInfos[203].price     = 3150;
    g_aryWeaponInfos[203].weight    = 4;

    g_aryWeaponInfos[204].classname = "weapon_svt40s";
    g_aryWeaponInfos[204].display   = "SVT-40 PU";
    g_aryWeaponInfos[204].category  = "狙击步枪";
    g_aryWeaponInfos[204].price     = 2950;
    g_aryWeaponInfos[204].weight    = 4;

    g_aryWeaponInfos[205].classname = "weapon_swm10";
    g_aryWeaponInfos[205].display   = "史密斯威森 M10";
    g_aryWeaponInfos[205].category  = "左轮手枪";
    g_aryWeaponInfos[205].price     = 675;
    g_aryWeaponInfos[205].weight    = 1;

    g_aryWeaponInfos[206].classname = "weapon_swm12";
    g_aryWeaponInfos[206].display   = "史密斯威森 M12";
    g_aryWeaponInfos[206].category  = "左轮手枪";
    g_aryWeaponInfos[206].price     = 600;
    g_aryWeaponInfos[206].weight    = 1;

    g_aryWeaponInfos[207].classname = "weapon_swm76";
    g_aryWeaponInfos[207].display   = "史密斯威森 M76";
    g_aryWeaponInfos[207].category  = "冲锋枪";
    g_aryWeaponInfos[207].price     = 1950;
    g_aryWeaponInfos[207].weight    = 3;

    g_aryWeaponInfos[208].classname = "weapon_swm76_sog";
    g_aryWeaponInfos[208].display   = "史密斯威森 M76 特种";
    g_aryWeaponInfos[208].category  = "冲锋枪";
    g_aryWeaponInfos[208].price     = 1900;
    g_aryWeaponInfos[208].weight    = 3;

    g_aryWeaponInfos[209].classname = "weapon_t223";
    g_aryWeaponInfos[209].display   = "WEAPON_T223";
    g_aryWeaponInfos[209].category  = "步枪";
    g_aryWeaponInfos[209].price     = 3000;
    g_aryWeaponInfos[209].weight    = 4;

    g_aryWeaponInfos[210].classname = "weapon_tt33";
    g_aryWeaponInfos[210].display   = "TT-33";
    g_aryWeaponInfos[210].category  = "手枪";
    g_aryWeaponInfos[210].price     = 625;
    g_aryWeaponInfos[210].weight    = 1;

    g_aryWeaponInfos[211].classname = "weapon_tul1";
    g_aryWeaponInfos[211].display   = "TUL-1";
    g_aryWeaponInfos[211].category  = "机枪";
    g_aryWeaponInfos[211].price     = 3350;
    g_aryWeaponInfos[211].weight    = 5;

    g_aryWeaponInfos[212].classname = "weapon_type14";
    g_aryWeaponInfos[212].display   = "南部十四年式";
    g_aryWeaponInfos[212].category  = "手枪";
    g_aryWeaponInfos[212].price     = 575;
    g_aryWeaponInfos[212].weight    = 1;

    g_aryWeaponInfos[213].classname = "weapon_type17";
    g_aryWeaponInfos[213].display   = "晋造十七式驳壳枪";
    g_aryWeaponInfos[213].category  = "卡宾枪";
    g_aryWeaponInfos[213].price     = 1250;
    g_aryWeaponInfos[213].weight    = 3;

    g_aryWeaponInfos[214].classname = "weapon_type30_bayonet";
    g_aryWeaponInfos[214].display   = "明治三十年式刺刀";
    g_aryWeaponInfos[214].category  = "近战武器";
    g_aryWeaponInfos[214].price     = 425;
    g_aryWeaponInfos[214].weight    = 1;

    g_aryWeaponInfos[215].classname = "weapon_type56";
    g_aryWeaponInfos[215].display   = "56-1式冲锋枪";
    g_aryWeaponInfos[215].category  = "步枪";
    g_aryWeaponInfos[215].price     = 3100;
    g_aryWeaponInfos[215].weight    = 4;

    g_aryWeaponInfos[216].classname = "weapon_type58";
    g_aryWeaponInfos[216].display   = "58式";
    g_aryWeaponInfos[216].category  = "步枪";
    g_aryWeaponInfos[216].price     = 3100;
    g_aryWeaponInfos[216].weight    = 4;

    g_aryWeaponInfos[217].classname = "weapon_type63";
    g_aryWeaponInfos[217].display   = "63式自动步枪";
    g_aryWeaponInfos[217].category  = "步枪";
    g_aryWeaponInfos[217].price     = 3150;
    g_aryWeaponInfos[217].weight    = 4;

    g_aryWeaponInfos[218].classname = "weapon_type63_sog";
    g_aryWeaponInfos[218].display   = "63式自动步枪 伞兵型";
    g_aryWeaponInfos[218].category  = "步枪";
    g_aryWeaponInfos[218].price     = 3050;
    g_aryWeaponInfos[218].weight    = 4;

    g_aryWeaponInfos[219].classname = "weapon_type64";
    g_aryWeaponInfos[219].display   = "64式微声冲锋枪";
    g_aryWeaponInfos[219].category  = "冲锋枪";
    g_aryWeaponInfos[219].price     = 1625;
    g_aryWeaponInfos[219].weight    = 3;

    g_aryWeaponInfos[220].classname = "weapon_type64p";
    g_aryWeaponInfos[220].display   = "64式微声手枪";
    g_aryWeaponInfos[220].category  = "手枪";
    g_aryWeaponInfos[220].price     = 600;
    g_aryWeaponInfos[220].weight    = 1;

    g_aryWeaponInfos[221].classname = "weapon_type67";
    g_aryWeaponInfos[221].display   = "67式微声手枪";
    g_aryWeaponInfos[221].category  = "手枪";
    g_aryWeaponInfos[221].price     = 350;
    g_aryWeaponInfos[221].weight    = 1;

    g_aryWeaponInfos[222].classname = "weapon_type97";
    g_aryWeaponInfos[222].display   = "九七式信号拳铳";
    g_aryWeaponInfos[222].category  = "信号枪";
    g_aryWeaponInfos[222].price     = 175;
    g_aryWeaponInfos[222].weight    = 1;

    g_aryWeaponInfos[223].classname = "weapon_uzi";
    g_aryWeaponInfos[223].display   = "UZI";
    g_aryWeaponInfos[223].category  = "冲锋枪";
    g_aryWeaponInfos[223].price     = 1850;
    g_aryWeaponInfos[223].weight    = 3;

    g_aryWeaponInfos[224].classname = "weapon_uzi_sog";
    g_aryWeaponInfos[224].display   = "UZI 特种";
    g_aryWeaponInfos[224].category  = "冲锋枪";
    g_aryWeaponInfos[224].price     = 1800;
    g_aryWeaponInfos[224].weight    = 3;

    g_aryWeaponInfos[225].classname = "weapon_v40";
    g_aryWeaponInfos[225].display   = "V-40 袖珍手榴弹";
    g_aryWeaponInfos[225].category  = "手榴弹";
    g_aryWeaponInfos[225].price     = 300;
    g_aryWeaponInfos[225].weight    = 0;

    g_aryWeaponInfos[226].classname = "weapon_vccarbine";
    g_aryWeaponInfos[226].display   = "土制卡宾枪";
    g_aryWeaponInfos[226].category  = "卡宾枪";
    g_aryWeaponInfos[226].price     = 1000;
    g_aryWeaponInfos[226].weight    = 2;

    g_aryWeaponInfos[227].classname = "weapon_vcgrenade";
    g_aryWeaponInfos[227].display   = "土制手榴弹";
    g_aryWeaponInfos[227].category  = "手榴弹";
    g_aryWeaponInfos[227].price     = 350;
    g_aryWeaponInfos[227].weight    = 0;

    g_aryWeaponInfos[228].classname = "weapon_vcpistol";
    g_aryWeaponInfos[228].display   = "土制手枪";
    g_aryWeaponInfos[228].category  = "手枪";
    g_aryWeaponInfos[228].price     = 250;
    g_aryWeaponInfos[228].weight    = 1;

    g_aryWeaponInfos[229].classname = "weapon_vcpistol2";
    g_aryWeaponInfos[229].display   = "土制自动手枪";
    g_aryWeaponInfos[229].category  = "手枪";
    g_aryWeaponInfos[229].price     = 475;
    g_aryWeaponInfos[229].weight    = 1;

    g_aryWeaponInfos[230].classname = "weapon_vcshotgun";
    g_aryWeaponInfos[230].display   = "土制霰弹枪";
    g_aryWeaponInfos[230].category  = "霰弹枪";
    g_aryWeaponInfos[230].price     = 1000;
    g_aryWeaponInfos[230].weight    = 2;

    g_aryWeaponInfos[231].classname = "weapon_vcsmg";
    g_aryWeaponInfos[231].display   = "土制冲锋枪";
    g_aryWeaponInfos[231].category  = "冲锋枪";
    g_aryWeaponInfos[231].price     = 1000;
    g_aryWeaponInfos[231].weight    = 2;

    g_aryWeaponInfos[232].classname = "weapon_vz23";
    g_aryWeaponInfos[232].display   = "vz.48b";
    g_aryWeaponInfos[232].category  = "冲锋枪";
    g_aryWeaponInfos[232].price     = 2050;
    g_aryWeaponInfos[232].weight    = 3;

    g_aryWeaponInfos[233].classname = "weapon_vz58";
    g_aryWeaponInfos[233].display   = "vz.58";
    g_aryWeaponInfos[233].category  = "步枪";
    g_aryWeaponInfos[233].price     = 3175;
    g_aryWeaponInfos[233].weight    = 4;

    g_aryWeaponInfos[234].classname = "weapon_vz61e";
    g_aryWeaponInfos[234].display   = "vz.61 蝎式";
    g_aryWeaponInfos[234].category  = "冲锋手枪";
    g_aryWeaponInfos[234].price     = 1475;
    g_aryWeaponInfos[234].weight    = 2;

    g_aryWeaponInfos[235].classname = "weapon_vz61e_sog";
    g_aryWeaponInfos[235].display   = "vz.61 蝎式 特种";
    g_aryWeaponInfos[235].category  = "冲锋手枪";
    g_aryWeaponInfos[235].price     = 1450;
    g_aryWeaponInfos[235].weight    = 2;

    g_aryWeaponInfos[236].classname = "weapon_welrod";
    g_aryWeaponInfos[236].display   = "维尔洛德 MK.IIA";
    g_aryWeaponInfos[236].category  = "手枪";
    g_aryWeaponInfos[236].price     = 350;
    g_aryWeaponInfos[236].weight    = 1;

    g_aryWeaponInfos[237].classname = "weapon_xm177";
    g_aryWeaponInfos[237].display   = "XM177E2 特种";
    g_aryWeaponInfos[237].category  = "卡宾枪";
    g_aryWeaponInfos[237].price     = 2700;
    g_aryWeaponInfos[237].weight    = 4;

    g_aryWeaponInfos[238].classname = "weapon_xm177_oeg";
    g_aryWeaponInfos[238].display   = "WEAPON_XM177_OEG";
    g_aryWeaponInfos[238].category  = "卡宾枪";
    g_aryWeaponInfos[238].price     = 2600;
    g_aryWeaponInfos[238].weight    = 4;

    g_aryWeaponInfos[239].classname = "weapon_xm202";
    g_aryWeaponInfos[239].display   = "XM202 FLASH";
    g_aryWeaponInfos[239].category  = "火箭发射器";
    g_aryWeaponInfos[239].price     = 7500;
    g_aryWeaponInfos[239].weight    = 7;
}

void InitMenuItem()
{
    for (int i = 0; i < sizeof(g_aryWeaponInfos); i++)
    {
        CWeaponInfo info;
        strcopy(info.category, sizeof(info.category), g_aryWeaponInfos[i].category);
        strcopy(info.classname, sizeof(info.classname), g_aryWeaponInfos[i].classname);
        strcopy(info.display, sizeof(info.display), g_aryWeaponInfos[i].display);
        info.price = g_aryWeaponInfos[i].price;
        info.weight = g_aryWeaponInfos[i].weight;
        Menu        menu;
        if (g_dicMenus.ContainsKey(info.category))
            g_dicMenus.GetValue(info.category, menu);
        else{
            menu = new Menu(MenuHandler_Buy);
            menu.SetTitle(info.category);
            g_pRoot.AddItem(info.category, info.category);
            g_dicMenus.SetValue(info.category, menu);
        }
        char index[8];
        IntToString(i, index, sizeof(index));
        char menu_display[64];
        Format(menu_display, sizeof(menu_display), "%s - %d | %d", info.display, info.price, info.weight)
        menu.AddItem(index, menu_display);
    }
}

bool BuyCheck(int client)
{
    if(client <= 0 || client > MaxClients)
        return false;
    if(!IsClientInGame(client))
        return false;
    if(!IsPlayerAlive(client))
    {
        PrintToChat(client, "你已经是个死人了。");
        return false;
    }
    if(ZM_GetPhase() != ZM_PHASE_WAITING)
    {
        PrintToChat(client, "战斗已经开始，你不能再购买装备。");
        return false;
    }
    return true;
}

public void MenuHandler_Buy(Menu menu, MenuAction action, int client, int slot)
{
    if(!BuyCheck(client))
        return;
    if (action == MenuAction_Select)
    {
        char infobuf[8];
        menu.GetItem(slot, infobuf, sizeof(infobuf));
        int         index = StringToInt(infobuf);
        CWeaponInfo info;
        strcopy(info.category, sizeof(info.category), g_aryWeaponInfos[index].category);
        strcopy(info.classname, sizeof(info.classname), g_aryWeaponInfos[index].classname);
        strcopy(info.display, sizeof(info.display), g_aryWeaponInfos[index].display);
        info.price = g_aryWeaponInfos[index].price;
        info.weight = g_aryWeaponInfos[index].weight;

        int playerCredit = ZM_GetMoney(client);
        if(playerCredit < info.price)
        {
            PrintToChat(client, "你买不起%s，需要%d元，你只有%d元", info.display, info.price, playerCredit);
            return;
        }
        int playerweight = ZM_GetWeight(client);
        int maxWeight = g_pMaxWeight.IntValue;
        if(playerweight + info.weight > maxWeight)
        {
            PrintToChat(client, "你背不动%s，需要%d负重，你现在的负重是%d", info.display, info.weight, playerweight);
            return;
        }

        ZM_AddMoney(client, -info.price);
        //会计算双倍负重
        //ZM_AddWeight(client, info.weight);
        int weapon = CreateEntityByName(info.classname);
        DispatchSpawn(weapon);
        float org[3];
        GetClientAbsOrigin(client, org);
        TeleportEntity(weapon, org);
    }
}

public void MenuHandler_SubMenu(Menu menu, MenuAction action, int client, int slot)
{
    if(!BuyCheck(client))
        return;
    if (action == MenuAction_Select)
    {
        char infobuf[64];
        menu.GetItem(slot, infobuf, sizeof(infobuf));
        if (g_dicMenus.ContainsKey(infobuf))
        {
            Menu sub;
            g_dicMenus.GetValue(infobuf, sub);
            sub.Display(client, 60);
        }
    }
}

public Action Command_OpenMenu(int client, int args)
{
    if(!BuyCheck(client))
        return Plugin_Handled;
    g_pRoot.Display(client, 60);
    return Plugin_Handled;
}

public void OnPluginStart()
{
    g_pRoot    = new Menu(MenuHandler_SubMenu);
    g_pRoot.SetTitle("购买菜单")
    g_dicMenus = new StringMap();
    g_pMaxWeight = FindConVar("vietnam_zombies_max_carry_weight");
    InitWeaponInfos();
    InitMenuItem();

    RegConsoleCmd("sm_zombie_buy", Command_OpenMenu, "Open Buy Menu");
}

public void OnPluginEnd()
{
    g_dicMenus.Clear();
    g_dicMenus.Close();
    g_pRoot.Close();
    g_pMaxWeight.Close();
}