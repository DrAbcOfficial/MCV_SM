// Custom Player Skins include file

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
native int  ZM_GetMoney(int client);
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
native int  ZM_GetZombieCount();

/**
 * Get Zombie By Index
 *
 * @param index zombie index
 * @return zombie entity index
 * @error Invalid index.
 */
native int  ZM_GetZombieByIndex(int index);

#define ZM_PHASE_WAITING 0
#define ZM_PHASE_COMBAT  1

forward void OnZombiePhaseChanged(int phase);

/**
 * Get now game phase
 *
 * @return phase ZM_PHASE_WAITING or ZM_PHASE_COMBAT
 */
native int   ZM_GetPhase();

forward void OnZombieKilled(int zombie, char[] classname, int attacker, char[] weapon_name,
                            char[] weapon_id, int damagebits, bool headshot, bool backblast,
                            int penetrated, float killdistance);

public SharedPlugin __pl_zombie_core = {
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
    MarkNativeAsOptional("ZM_GetPhase");
}
#endif
