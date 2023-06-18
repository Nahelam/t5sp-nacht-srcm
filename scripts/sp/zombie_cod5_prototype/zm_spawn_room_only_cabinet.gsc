#include maps\_utility;

main()
{
    PrecacheModel("dest_test_cabinet_main_dmg0");
    PrecacheModel("collision_geo_32x32x128");
}

init()
{
    weapon_cabinet_setup();
}

weapon_cabinet_setup()
{
    cabinet = spawn_model("dest_test_cabinet_main_dmg0", (-133.466, -297.756, 0.947258), (0, 180, 0));

    cabinet_clip = spawn_model("collision_geo_32x32x128", (-133.494, -301.507, 24.2256));
    cabinet_clip Hide();

    weap = "dragunov_zm";

    weapon_cabinet_use = GetEnt("weapon_cabinet_use", "targetname");
    weapon_cabinet_use.zombie_weapon_upgrade = weap;

    weap_s = level.zombie_weapons[weap];
    weapon_cabinet_use.zombie_cost = weap_s.cost;

    weapon_cabinet_use SetHintString(&"WAW_ZOMBIE_WEAPONCOSTAMMO", weap_s.cost, weap_s.ammo_cost);
    weapon_cabinet_use.origin = (-133.066, -282.656, 58.3473);
    weapon_cabinet_use.angles = (0, 90, 0);

    models = GetEntArray("script_model", "classname");
    cabinet_snipers = [];

    for (i = 0; i < models.size; i++)
    {
        if (models[i].model == "weapon_mp_kar98_scoped_rifle")
        {
            cabinet_snipers[cabinet_snipers.size] = models[i];
            models[i] SetModel("t5_weapon_dragunov_world");
        }
    }

    level.manip_ent = cabinet_snipers[0];

    cabinet_snipers[0].origin = (-142.685, -302.756, 46.1777);
    cabinet_snipers[0].angles = (270.803, 355.434, 5.36451);

    cabinet_snipers[1].origin = (-124.247, -302.756, 46.1777);
    cabinet_snipers[1].angles = (270.803, 175.234, 5.3647);

    cabinet_doors = GetEntArray("pf5_auto2", "targetname");

    cabinet_doors[0].origin = (-149.766, -287.756, 52.7472);
    cabinet_doors[0].angles = (0, 180, 0);

    cabinet_doors[1].origin = (-117.466, -287.756, 52.7472);
    cabinet_doors[1].angles = (0, 180, 0);

    weapon_cabinet_use thread cabinet_hint();
}

cabinet_hint()
{
    for (;;)
    {
        self SetHintString("^3HEADSHOT ^7= ^1KILL (EVERYTIME!)^7");
        wait 2;
        self SetHintString(&"WAW_ZOMBIE_WEAPONCOSTAMMO", 2500, 1250);
        wait 2;
    }
}
