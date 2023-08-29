#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;
#include scripts\sp\zombie_cod5_prototype\zm_spawn_room_only_utils;

main()
{
    ReplaceFunc(maps\zombie_cod5_prototype::check_solo_game, ::do_nothing);
    ReplaceFunc(maps\zombie_cod5_prototype::pistol_rank_setup, ::pistol_rank_setup);

    ReplaceFunc(maps\_zombiemode_spawner::set_run_speed, ::set_run_speed);
    ReplaceFunc(maps\_zombiemode_spawner::tear_into_building, ::do_nothing);

    SetDvar("mutator_noBoards", "1");
}

init()
{
    level.zombie_custom_think_logic = ::zombie_think;

    level._overrideActorDamage = level.overrideActorDamage;
    level.overrideActorDamage = ::actor_damage_override;

    level.max_zombie_func = ::max_zombie;

    level.zombie_vars["zombie_spawn_delay"] = 0;
    level.zombie_vars["zombie_between_round_time"] = 0;

    level thread round_watcher();
    level thread alcohol();
    level thread on_player_connected();
}

on_player_connected()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread on_player_spawned();
    }
}

on_player_spawned()
{
    self waittill("spawned_player");
    self VisionSetNaked("zombie", 5);
    self.drunk = false;
}

add_start_zone_spawner(spawner)
{
    level.zones["start_zone"].spawners[level.zones["start_zone"].spawners.size] = spawner;
}

add_start_zone_rise_location(location)
{
    level.zones["start_zone"].rise_locations[level.zones["start_zone"].rise_locations.size] = location;
}

crawlers_enable()
{
    door_enable();
    box_zone_spawners_enable();
}

door_enable()
{
    door = GetEnt("auto34", "targetname");
    door MoveZ(25, 1.0);
    play_sound_at_pos("door_slide_open", door.origin);
    door ConnectPaths();
}

box_zone_spawners_enable()
{
    origin = (950, 700, 1);
    spawners = GetEntArray("box_zone_spawners", "targetname");
    for (i = 0; i < spawners.size; i++)
    {
        spawners[i].origin = origin + ((-50 * i), 0, 0);
        spawners[i].crawlers_only = true;
        add_start_zone_spawner(spawners[i]);
    }
}

risers_enable()
{
    interior_spawners_start_index = 75;

    origins = [];
    origins[origins.size] = (29, -749, 19);
    origins[origins.size] = (78, -439, 6);
    origins[origins.size] = (52, -200, 7);
    origins[origins.size] = (160, -43, 69);
    origins[origins.size] = (158, 403, 1);
    origins[origins.size] = (301, 511, 7);

    for (i = 0; i < origins.size; i++)
    {
        interior_spawner = GetEnt("auto" + (interior_spawners_start_index + i), "target");
        interior_spawner.origin = origins[i];
        interior_spawner.riser = true;
        add_start_zone_spawner(interior_spawner);
        add_start_zone_rise_location(interior_spawner);
    }
}

zombie_think()
{
    self thread actual_zombie_think();
    return true;
}

actual_zombie_think()
{
    wait 0.05;

    find_flesh_struct_string = undefined;

    if (isDefined(self.crawlers_only) || isDefined(self.riser))
    {
        find_flesh_struct_string = "find_flesh";

        self.zone_name = "start_zone";
        self.target = undefined;

        if (isDefined(self.crawlers_only))
        {
            self.crawl_anim_override = ::crawl_anim_override;
            self thread on_zombie_emerged();
        }
        else if (isDefined(self.riser))
        {
            self thread maps\_zombiemode_spawner::do_zombie_rise();
            self waittill("risen");
        }
    }

    self notify("zombie_custom_think_done", find_flesh_struct_string);
}

on_zombie_emerged()
{
    self waittill("completed_emerging_into_playable_area");
    self thread maps\_zombiemode_spawner::make_crawler();
    self SetPhysParams(15, 0, 24);
    self.no_powerups = true;
}

crawl_anim_override()
{
    self.run_combatanim = level.scr_anim[self.animname]["crawl4"];
    self.crouchRunAnim = level.scr_anim[self.animname]["crawl4"];
    self.crouchrun_combatanim = level.scr_anim[self.animname]["crawl4"];
    self thread animscripts\zombie_death::do_gib();
}

actor_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, modelIndex, psOffsetTime)
{
    if ((weapon == "dragunov_zm" || weapon == "dragunov_upgraded_zm") && (maps\_zombiemode::is_headshot(weapon, sHitLoc, meansofdeath)))
    {
        damage = self.health + 666;
    }

    return self [[level._overrideActorDamage]](inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, modelIndex, psOffsetTime);
}

drunk_noises()
{
    self endon("disconnect");
    self endon("sober");

    for (;;)
    {
        wait RandomIntRange(5, 15);
        if (self.sessionstate == "playing")
        {
            self PlaySound("evt_belch");
        }
    }
}

get_drunk()
{
    self endon("disconnect");

    self.drunk = true;
    self PlaySound("evt_perk_bottle_open");
    wait 0.5;
    self PlaySound("evt_perk_swallow");
    self SetWaterSheeting(true);

    drunk_time = RandomIntRange(120, 300);

    self thread drunk_noises();

    wait drunk_time;

    self notify("sober");
    self SetWaterSheeting(false);
    if (self.sessionstate == "playing")
    {
        self PlaySound("vox_plr_1_nomoney_0");
    }
    self.drunk = false;
}

alcohol()
{
    bottle = spawn_model("static_berlin_winebottle", (-73.5627, 548.432, 54.5113));
    bottle_trig = Spawn("trigger_radius", bottle.origin, 0, 10, 10);

    for (;;)
    {
        bottle_trig waittill("trigger", who);
        if (is_player_valid(who) && !who.drunk && who UseButtonPressed() && who is_facing(bottle_trig, 0.90))
        {
            who thread get_drunk();
            wait 0.5;
        }
    }
}

max_zombie(max)
{
    return max;
}

set_run_speed()
{
    self.zombie_move_speed = "sprint";
}

round_watcher()
{
    for(;;)
    {
        level waittill("start_of_round");

        switch (level.round_number)
        {
            case 5:
                scripts\sp\zombie_cod5_prototype\zm_spawn_room_only_weapons::box_enable();
                break;
            case 7:
                risers_enable();
                break;
            case 10:
                scripts\sp\zombie_cod5_prototype\zm_spawn_room_only_sleight::sleight_machine_enable();
                break;
            case 12:
                crawlers_enable();
                break;
            case 15:
                scripts\sp\zombie_cod5_prototype\zm_spawn_room_only_pap::packapunch_machine_enable();
                break;
            case 19:
                level thread ammo_drop_watch();
        }
    }
}

ammo_drop_watch()
{
    for (;;)
    {
        level waittill("start_of_round");

        if ((level.round_number % 3) == 0)
        {
            level thread maps\_zombiemode_powerups::specific_powerup_drop("full_ammo", (-168, -834, 4));
        }
    }
}

pistol_rank_setup()
{
    flag_init("_start_zm_pistol_rank");
    flag_wait("all_players_connected");
    flag_set( "_start_zm_pistol_rank" );
}
