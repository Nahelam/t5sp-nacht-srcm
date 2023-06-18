#include common_scripts\utility;
#include scripts\sp\zombie_cod5_prototype\zm_spawn_room_only_utils;

init()
{
    move_radio();
    move_nades();
    move_box();

    delete_spawn_debris();
}

delete_spawn_debris()
{
    ents1 = GetEntArray("upstairs_blocker", "target");
    ents2 = GetEntArray("upstairs_blocker", "targetname");

    ents = array_combine(ents1, ents2);
    array_delete(ents);

    level notify("junk purchased");
}

move_box()
{
    treasure_chest_use = GetEnt("treasure_chest_use", "targetname");
    treasure_chest_use.origin = (162.365, -573.104, 104.69);
    treasure_chest_use.angles = (7.10757, 142.501, -12.3118);

    chest_lid = GetEnt("chest_lid", "targetname");
    chest_lid.origin = (186.352, -573.326, 99.938);
    chest_lid.angles = (354.125, 88.9348, -12.938);

    chest_origin = GetEnt("chest_origin", "targetname");
    chest_origin.origin = (178.049, -571.4, 82.7229);
    chest_origin.angles = (12.8689, 177.588, -6.02682);

    chest_box = GetEnt("chest_box", "targetname");
    chest_box.origin = (178.726, -571.113, 79.8144);
    chest_box.angles = (-5.8749, 88.9348, -12.938);
}

move_nades()
{
    weapon_upgrade = GetEnt("stielhandgranate", "script_noteworthy");
    weapon_upgrade.origin = (40, -120, 190);

    stielhandgranate = GetEnt("stielhandgranate", "targetname");
    stielhandgranate.origin = (38, -121.8, 187);

    stielhandgranate_chalk = GetEnt("stielhandgranate_chalk", "targetname");
    stielhandgranate_chalk.origin = (40, -121, 190);
}

move_radio()
{
    kzmb = GetEnt("kzmb", "targetname");
    kzmb.origin = (116.011, -140.33, 67.4998);
    kzmb.angles = (5, 181, -2);
}
