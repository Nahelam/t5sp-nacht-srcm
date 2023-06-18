#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include scripts\sp\zombie_cod5_prototype\zm_spawn_room_only_utils;

main()
{
    ReplaceFunc(maps\zombie_cod5_prototype::include_weapons, ::include_weapons);

    level.func_is_weapon_upgraded = maps\_zombiemode_weapons::is_weapon_upgraded;
    ReplaceFunc(maps\_zombiemode_weapons::is_weapon_upgraded, ::is_weapon_upgraded);
}

init()
{
    level.zombie_weapons["knife_ballistic_zm"].upgrade_name = "knife_ballistic_bowie_upgraded_zm";
    level.zombie_weapons["dragunov_zm"].upgrade_name = undefined;
    level.box = level.chests[0];

    box_disable();
    randomize_spaw_room_chalks();
}

include_weapons()
{
    PrecacheItem("explosive_bolt_zm");
    PrecacheItem("explosive_bolt_upgraded_zm");

    include_weapon("m1911_zm");
    include_weapon("python_zm");
    include_weapon("cz75_zm");
    include_weapon("g11_lps_zm");
    include_weapon("famas_zm");
    include_weapon("spectre_zm");
    include_weapon("cz75dw_zm");
    include_weapon("spas_zm");
    include_weapon("hs10_zm");
    include_weapon("aug_acog_zm");
    include_weapon("galil_zm");
    include_weapon("commando_zm");
    include_weapon("fnfal_zm");
    include_weapon("dragunov_zm", false);
    include_weapon("l96a1_zm");
    include_weapon("rpk_zm");
    include_weapon("hk21_zm");
    include_weapon("m72_law_zm");
    include_weapon("china_lake_zm");
    include_weapon("crossbow_explosive_zm");
    include_weapon("knife_ballistic_zm");
    //include_weapon("knife_ballistic_bowie_zm", false);
    include_weapon("ray_gun_zm");
    include_weapon("thundergun_zm");
    include_weapon("mp40_zm");

    include_weapon("m1911_upgraded_zm", false);
    include_weapon("python_upgraded_zm", false);
    include_weapon("cz75_upgraded_zm", false);
    include_weapon("g11_lps_upgraded_zm", false);
    include_weapon("famas_upgraded_zm", false);
    include_weapon("spectre_upgraded_zm", false);
    include_weapon("cz75dw_upgraded_zm", false);
    include_weapon("spas_upgraded_zm", false);
    include_weapon("hs10_upgraded_zm", false);
    include_weapon("aug_acog_mk_upgraded_zm", false);
    include_weapon("galil_upgraded_zm", false);
    include_weapon("commando_upgraded_zm", false);
    include_weapon("fnfal_upgraded_zm", false);
    //include_weapon("dragunov_upgraded_zm", false);
    include_weapon("l96a1_upgraded_zm", false);
    include_weapon("rpk_upgraded_zm", false);
    include_weapon("hk21_upgraded_zm", false);
    include_weapon("m72_law_upgraded_zm", false);
    include_weapon("china_lake_upgraded_zm", false);
    include_weapon("crossbow_explosive_upgraded_zm", false);
    //include_weapon("knife_ballistic_upgraded_zm", false);
    include_weapon("knife_ballistic_bowie_upgraded_zm", false);
    include_weapon("ray_gun_upgraded_zm", false );
    include_weapon("thundergun_upgraded_zm", false);
    include_weapon("mp40_upgraded_zm", false);

    include_weapon("zombie_cymbal_monkey");

    include_weapon("zombie_m1carbine", true, true);
    include_weapon("zombie_thompson", true, true);
    include_weapon("zombie_kar98k", true, true);
    include_weapon("kar98k_scoped_zombie", true, true);
    include_weapon("stielhandgranate", false, true);
    include_weapon("zombie_doublebarrel", true, true);
    include_weapon("zombie_doublebarrel_sawed", true, true);
    include_weapon("zombie_shotgun", true, true);
    include_weapon("zombie_bar", true, true);

    level._uses_retrievable_ballisitic_knives = true;

    // limited weapons
    maps\_zombiemode_weapons::add_limited_weapon( "thundergun_zm", 1 );
    maps\_zombiemode_weapons::add_limited_weapon( "crossbow_explosive_zm", 1 );
    maps\_zombiemode_weapons::add_limited_weapon( "knife_ballistic_zm", 1 );

    maps\_zombiemode_weapons::add_zombie_weapon("zombie_kar98k", undefined, &"WAW_ZOMBIE_WEAPON_KAR98K_200", 200, "rifle");

    // Semi Auto
    maps\_zombiemode_weapons::add_zombie_weapon("zombie_m1carbine", undefined, &"WAW_ZOMBIE_WEAPON_M1CARBINE_600", 600, "rifle");

    maps\_zombiemode_weapons::add_zombie_weapon("stielhandgranate", undefined, &"WAW_ZOMBIE_WEAPON_STIELHANDGRANATE_250", 250, "grenade", "", 250);

    // Scoped
    maps\_zombiemode_weapons::add_zombie_weapon("kar98k_scoped_zombie", undefined, &"WAW_ZOMBIE_WEAPON_KAR98K_S_750", 750, "sniper");

    // Full Auto
    maps\_zombiemode_weapons::add_zombie_weapon("zombie_thompson", undefined, &"WAW_ZOMBIE_WEAPON_THOMPSON_1200", 1200, "mg");

    // Shotguns
    maps\_zombiemode_weapons::add_zombie_weapon("zombie_doublebarrel", undefined, &"WAW_ZOMBIE_WEAPON_DOUBLEBARREL_1200", 1200, "shotgun");
    maps\_zombiemode_weapons::add_zombie_weapon("zombie_doublebarrel_sawed", undefined, &"WAW_ZOMBIE_WEAPON_DOUBLEBARREL_SAWED_1200", 1200, "shotgun");
    maps\_zombiemode_weapons::add_zombie_weapon("zombie_shotgun", undefined, &"WAW_ZOMBIE_WEAPON_SHOTGUN_1500", 1500, "shotgun");

    maps\_zombiemode_weapons::add_zombie_weapon("zombie_bar", undefined, &"WAW_ZOMBIE_WEAPON_BAR_1800", 1800, "mg");
}

randomize_spaw_room_chalks()
{
    spawn_room_wall_weapons = [];
    spawn_room_wall_weapons[spawn_room_wall_weapons.size] = get_weapon_chalk_nodes("kar98k");
    spawn_room_wall_weapons[spawn_room_wall_weapons.size] = get_weapon_chalk_nodes("m1carbine");

    for (i = 0; i < spawn_room_wall_weapons.size; i++)
    {
        array_func(spawn_room_wall_weapons[i], ::six_feet_under);
    }

    excluded_wall_weapons = [];
    excluded_wall_weapons[excluded_wall_weapons.size] = GetEnt("stielhandgranate", "script_noteworthy");
    excluded_wall_weapons[excluded_wall_weapons.size] = GetEnt("auto42", "target");

    wall_weapons = GetEntArray("weapon_upgrade", "targetname");
    wall_weapons = array_exclude(wall_weapons, excluded_wall_weapons);
    wall_weapons = array_randomize(wall_weapons);

    new_wall_weapons = [];

    for (i = 0; i < spawn_room_wall_weapons.size; i++)
    {
        new_wall_weapons[new_wall_weapons.size] = get_weapon_chalk_nodes(wall_weapons[i].script_noteworthy);
    }

    for (i = 0; i < new_wall_weapons.size; i++)
    {
        new_wall_weapons[i]["weapon_model"] LinkTo(new_wall_weapons[i]["weapon_chalk"]);

        adjust_weapon_chalk_angles(new_wall_weapons[i]["weapon_chalk"]);

        new_wall_weapons[i]["trigger"].origin = spawn_room_wall_weapons[i]["trigger"].initial_origin;
        new_wall_weapons[i]["weapon_chalk"].origin = spawn_room_wall_weapons[i]["weapon_chalk"].initial_origin;

        wait 0.05;

        new_wall_weapons[i]["weapon_model"] Unlink();

        level.zombie_weapons[new_wall_weapons[i]["trigger"].zombie_weapon_upgrade].is_in_box = false;
    }
}

adjust_weapon_chalk_angles(chalk_ent)
{
    switch (chalk_ent.targetname)
    {
        case "doublebarrel_chalk":
            chalk_ent.angles = (0, 180, 0);
            break;
        case "thompson_chalk":
        case "pf355_auto2":
            chalk_ent.angles = (0, 90, 0);
            break;
    }
}

get_weapon_chalk_nodes(weapon)
{
    root_ent = GetEnt(weapon, "script_noteworthy");
    nodes = get_nodes(root_ent);

    weapon_chalk_nodes = [];
    weapon_chalk_nodes["trigger"] = nodes[0];
    weapon_chalk_nodes["weapon_model"] = nodes[1];
    weapon_chalk_nodes["weapon_chalk"] = nodes[2];

    return weapon_chalk_nodes;
}

is_weapon_upgraded(weaponname)
{
    if (!isDefined(level.zombie_weapons[weaponname].upgrade_name))
    {
        return true;
    }

    return [[level.func_is_weapon_upgraded]](weaponname);
}

box_deny()
{
    self endon("box_enable");

    for(;;)
    {
        self waittill("trigger");
        PlaySoundAtPosition("zmb_laugh_child", self.origin);
        wait 10;
    }
}

box_disable()
{
    level.box thread box_deny();
    level.box.disabled = true;
    level.box SetCursorHint("HINT_ACTIVATE");
    level.box SetHintString(&"MENU_5_ROUNDS");
}

box_enable()
{
    level.box notify("box_enable");
    level.box.disabled = false;
    level.box SetCursorHint("HINT_NOICON");
    level.box SetHintString(&"ZOMBIE_RANDOM_WEAPON_950");
}