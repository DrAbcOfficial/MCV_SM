#include <smmem>
#include <sdktools>
#include <lib_mcv>

#define PLUGIN_NAME        "Lib MCV"
#define PLUGIN_DESCRIPTION "全新MCV运行库王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

DynLib g_pServerLib;
Handle g_hSetParentAttachment;

public int Native_SetParentAttachment(Handle plugin, int args)
{
    int entity = GetNativeCell(1);
    int cmd_length;
    GetNativeStringLength(2, cmd_length);
    cmd_length++;
    char[] cmd = new char[cmd_length];
    GetNativeString(2, cmd, cmd_length);
    int attach_length;
    GetNativeStringLength(3, attach_length);
    attach_length++;
    char[] attach = new char[attach_length];
    GetNativeString(3, attach, attach_length);
    bool offset = GetNativeCell(4);
    SDKCall(g_hSetParentAttachment, entity, cmd, attach, offset);
    return INVALID_ENT_REFERENCE;
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateNative("MCV_SetParentAttachment", Native_SetParentAttachment);
    RegPluginLibrary("Lib MCV");
    return APLRes_Success;
}

public void OnPluginStart()
{
    g_pServerLib                = new DynLib("./vietnam/bin/linux64/server");
    Address setparentattachment = g_pServerLib.ResolveSymbol("_ZN11CBaseEntity19SetParentAttachmentEPKcS1_b");
    StartPrepSDKCall(SDKCall_Entity);
    PrepSDKCall_SetAddress(setparentattachment);
    PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
    PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
    PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
    g_hSetParentAttachment = EndPrepSDKCall();
}

public void OnPluginEnd()
{
    delete g_pServerLib;
    delete g_hSetParentAttachment;
}