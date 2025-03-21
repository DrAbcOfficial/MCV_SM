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
 * Get Client Weight
 *
 * @param client Client index
 * @return client weight
 * @error Invalid client.
 */
native int  ZM_GetWeight(int client);
/**
 * Set Client Money
 *
 * @param client Client index
 * @param Weight Weight
 * @error Invalid client.
 */
native void ZM_SetWeight(int client, int weight);
/**
 * Add Client Money
 *
 * @param client Client index
 * @param Weight Weight
 * @error Invalid client.
 */
native void ZM_AddWeight(int client, int weight);

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

/**
 * Get cash entity count
 *
 * @return zombie entity index
 */
native int ZM_GetCashCount();
/**
 * Get Case entity By Index
 *
 * @param index Case index
 * @return cash entity index
 * @error Invalid index.
 */
native int ZM_GetCashByIndex(int index);
/**
 * Create cash entity
 *
 * @param owner owner entity index, can be -1
 * @param count how much this cash pile worth?
 * @param org origin
 * @param ang angles
 * @param vec velocity
 * @return cash entity index
 */
native int ZM_CreateCash(int owner, int count, const float[] org, 
                          const float[] ang, const float[] vec);

forward void OnZombieSpawned(int zombie);

forward void OnZombieKilled(int zombie, char[] classname, int attacker, char[] weapon_name,
                            char[] weapon_id, int damagebits, bool headshot, bool backblast,
                            int penetrated, float killdistance);
forward void OnZombieKilledPost(int zombie, char[] classname, int attacker, char[] weapon_name,
                            char[] weapon_id, int damagebits, bool headshot, bool backblast,
                            int penetrated, float killdistance);
forward void OnCashPickup(int cash, int other, int& owner, int& count);
/**
 * Is player valid?
 *
 * @param client client index
 * @return true or false
 */
stock bool ZM_IsClientValid(int client)
{
    if(!IsValidEntity(client))
        return false;
    if (client <= 0 || client > MaxClients)
        return false;
    if (!IsClientInGame(client))
        return false;
    return true;
}

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

    MarkNativeAsOptional("ZM_GetWeight");
    MarkNativeAsOptional("ZM_SetWeight");
    MarkNativeAsOptional("ZM_AddWeight");

    MarkNativeAsOptional("ZM_GetZombieCount");
    MarkNativeAsOptional("ZM_GetZombieByIndex");

    MarkNativeAsOptional("ZM_GetPhase");

    MarkNativeAsOptional("ZM_GetCashCount");
    MarkNativeAsOptional("ZM_GetCashByIndex");
    MarkNativeAsOptional("ZM_CreateCash");
}
#endif
