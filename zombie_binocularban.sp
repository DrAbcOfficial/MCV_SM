#include <sdkhooks>
#include <sdktools>

#define PLUGIN_NAME        "Zombie binocular"
#define PLUGIN_DESCRIPTION "全新僵尸打狗王一代"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "Dr.Abc",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_DESCRIPTION,
    url         = PLUGIN_DESCRIPTION
};

void RemoveEntityLater(Handle timer, int entity)
{
    if (IsValidEntity(entity))
        RemoveEntity(entity);
}

public void OnEntityCreated(int entity, const char[] classname)
{
    if (!strncmp(classname, "weapon_binoculars", 17))
    {
        CreateTimer(0.1, RemoveEntityLater, entity);
    }
}

public void OnPluginStart()
{
    int entity = 0;
    while (entity != -1)
    {
        entity = FindEntityByClassname(entity, "weapon_binoculars_us");
        if (IsValidEntity(entity))
            RemoveEntity(entity);
    }
    entity = 0;
    while (entity != -1)
    {
        entity = FindEntityByClassname(entity, "weapon_binoculars_vc");
        if (IsValidEntity(entity))
            RemoveEntity(entity);
    }
}