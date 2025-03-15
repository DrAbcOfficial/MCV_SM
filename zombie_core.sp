#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
public Plugin myinfo =
{
    name        = "Zombie Core",
    author      = "Dr.Abc",
    description = "全新僵尸核心王一代",
    version     = "Zombie Money",
    url         = "Zombie Money"
};
public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
	CreateNative("ZM_GetMoney", Native_GetMoney);
	CreateNative("ZM_SetMoney", Native_SetMoney);
	CreateNative("ZM_AddMoney", Native_AddMoney);

    CreateNative("ZM_GetZombieCount", Native_GetZombieCount);
    CreateNative("ZM_GetZombieByIndex", Native_GetZombieByIndex);

	RegPluginLibrary("CustomPlayerSkins");
	return APLRes_Success;
}


stock bool NativeCheck_IsClientValid(int client) {
	if(client <= 0 || client > MaxClients) {
		ThrowNativeError(SP_ERROR_NATIVE, "Client index %i is invalid", client);
		return false;
	}
	if(!IsClientInGame(client)) {
		ThrowNativeError(SP_ERROR_NATIVE, "Client %i is not in game", client);
		return false;
	}
	return true;
}

// undefined4 __thiscall CVietnam_Player::GetCredits(CVietnam_Player *this)
// {
//   return *(undefined4 *)(this + 0x21d8);
// }
public int Native_GetMoney(Handle plugin, int args)
{
    int client = GetNativeCell(1);
	if(NativeCheck_IsClientValid(client)) {
		int money = GetEntData(client, 0x21d8);
        return money;
	}
	return INVALID_ENT_REFERENCE;
}
public int Native_SetMoney(Handle plugin, int args)
{
    int client = GetNativeCell(1);
	if(NativeCheck_IsClientValid(client)) {
        int money = GetNativeCell(2);
		SetEntData(client, 0x21d8, money);
	}
	return INVALID_ENT_REFERENCE;
}
public int Native_AddMoney(Handle plugin, int args)
{
    int client = GetNativeCell(1);
	if(NativeCheck_IsClientValid(client)) {
        int money = GetEntData(client, 0x21d8);
        int add = GetNativeCell(2);
		SetEntData(client, 0x21d8, money + add);
	}
	return INVALID_ENT_REFERENCE;
}


ArrayList g_aryZombies;
public int Native_GetZombieCount(Handle plugin, int args)
{
    return g_aryZombies.Length;
}
public int Native_GetZombieByIndex(Handle plugin, int args)
{
    int index = GetNativeCell(1);
    if(index >= g_aryZombies.Length)
        return INVALID_ENT_REFERENCE;
    int zombie = g_aryZombies.Get(index);
    return zombie;
}
public void OnEntityCreated(int entity, const char[] classname)
{
    if (!strncmp(classname, "nb_zombie", 9, false))
    {
        g_aryZombies.Push(entity);
    }
}
public void OnEntityDestroyed(int entity)
{
    for (int i = 0; i < g_aryZombies.Length; i++)
    {
        if (g_aryZombies.Get(i) == entity)
        {
            g_aryZombies.Erase(i);
            return;
        }
    }
}


public void OnPluginStart()
{
    g_aryZombies = new ArrayList();
}
public void OnPluginEnd()
{
    g_aryZombies.Clear();
}