//Custom Player Skins include file

#if defined _MCVZombie_Core_included
 #endinput
#endif
#define _MCVZombie_Core_included


/**
 * Get Client Money
 *
 * @param client Client index
 * @return client money
 * @error Invalid client.
 */
native int ZM_GetMoney(int client);
/**
 * Set Client Money
 *
 * @param client Client index
 * @param money money
 * @error Invalid client.
 */
native void ZM_SetMoney(int client, int money);
/**
 * Add Client Money
 *
 * @param client Client index
 * @param money money
 * @error Invalid client.
 */
native void ZM_AddMoney(int client, int money);

/**
 * Get Zombie Count
 *
 * @return Zombie Count
 */
native int ZM_GetZombieCount();

/**
 * Get Zombie By Index
 *
 * @param index zombie index
 * @return zombie entity index
 * @error Invalid index.
 */
native int ZM_GetZombieByIndex(int index);


/**
 * Simple native to return the skin's flags
 * NOTE: Check if the player is between 0 and MAXPLAYERS.
 *
 * @param client Client index
 * @return Returns the client index's skin flags.
 */
native CPS_GetFlags(client);

public SharedPlugin:__pl_zombie_core =
{
	name = "Zombie Core",
	file = "zombie_core.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_zombie_core_SetNTVOptional()
{
	MarkNativeAsOptional("ZM_GetMoney");
	MarkNativeAsOptional("ZM_SetMoney");
	MarkNativeAsOptional("ZM_AddMoney");
    MarkNativeAsOptional("ZM_GetZombieCount");
    MarkNativeAsOptional("ZM_GetZombieByIndex");
}
#endif
