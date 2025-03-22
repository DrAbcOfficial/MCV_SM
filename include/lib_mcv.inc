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
    SetEntDataEnt(entity, 0x168, parent);
}
/**
 * SetParentAttachment
 * @param entity entity
 * @param szInputName input name
 * @param szAttachment point
 * @param bMaintainOffset mantian offset
 */
native void MCV_SetParentAttachment(int entity, char[] szInputName, char[] szAttachment, bool bMaintainOffset);

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
}
#endif
