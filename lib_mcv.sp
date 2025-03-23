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
Handle g_hCBasePlayerGetViewModel;
Handle g_hCBasePlayerCreateViewModel;

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

public int Native_GetPlayerViewModel(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    int pass = GetNativeCell(2);
    int view = SDKCall(g_hCBasePlayerGetViewModel, client, pass);
    return view;
}

public int Native_CreatePlayerViewModel(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    int pass = GetNativeCell(2);
    SDKCall(g_hCBasePlayerCreateViewModel, client, pass);
    return INVALID_ENT_REFERENCE;
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateNative("MCV_SetParentAttachment", Native_SetParentAttachment);
    CreateNative("MCV_GetPlayerViewModel", Native_GetPlayerViewModel);
    CreateNative("MCV_CreatePlayerViewModel", Native_CreatePlayerViewModel);
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

    Address getviewmodel = g_pServerLib.ResolveSymbol("_ZNK15CVietnam_Player19GetVietnamViewmodelEi");
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetAddress(getviewmodel);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
    g_hCBasePlayerGetViewModel = EndPrepSDKCall();  

    Address createviewmodel = g_pServerLib.ResolveSymbol("_ZN15CVietnam_Player15CreateViewModelEi");
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetAddress(createviewmodel);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    g_hCBasePlayerCreateViewModel = EndPrepSDKCall();
}

public void OnPluginEnd()
{
    g_pServerLib.Close();
    g_hSetParentAttachment.Close();
    g_hCBasePlayerGetViewModel.Close();
    g_hCBasePlayerCreateViewModel.Close();
}