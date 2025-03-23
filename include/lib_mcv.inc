#if defined _MCVLibrary_included
    #endinput
#endif
#define _MCVLibrary_included

/**
 * SetParent
 * @param entity entity
 * @param parent parent
 */
stock void MCV_SetParent(int entity, int parent)
{
    SetEntDataEnt2(entity, 0x168, parent);
}
/**
 * SetParentAttachment
 * @param entity entity
 * @param szInputName input name
 * @param szAttachment point
 * @param bMaintainOffset mantian offset
 */
native void MCV_SetParentAttachment(int entity, char[] szInputName, char[] szAttachment, bool bMaintainOffset);

/**
 * SetParentAttachment
 * @param player player
 * @param view view model idnex, 0~2
 * @return vietnam_view model entity index
 */
native int MCV_GetPlayerViewModel(int player, int view);


/**
 * CreateParentAttachment
 * @param player player
 * @param view view model idnex, 0~2
 */
native void MCV_CreatePlayerViewModel(int player, int view);

public SharedPlugin __pl_lib_mcv = {
    name = "Lib MCV",
    file = "lib_mcv.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN

public __pl_lib_mcv_SetNTVOptional()
{
    MarkNativeAsOptional("MCV_SetParentAttachment");
    MarkNativeAsOptional("MCV_GetPlayerViewModel");
    MarkNativeAsOptional("MCV_CreatePlayerViewModel");
}
#endif
