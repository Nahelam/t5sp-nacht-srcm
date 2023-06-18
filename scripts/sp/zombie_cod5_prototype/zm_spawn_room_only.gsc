#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;
#include scripts\sp\zombie_cod5_prototype\zm_spawn_room_only_utils;

main()
{
    ReplaceFunc(maps\zombie_cod5_prototype::check_solo_game, ::do_nothing);
    ReplaceFunc(maps\zombie_cod5_prototype::pistol_rank_setup, ::pistol_rank_setuup);

    ReplaceFunc(maps\_zombiemode_spawner::set_run_speed, ::set_run_speed);
    ReplaceFunc(maps\_zombiemode_spawner::tear_into_building, ::do_nothing);

    SetDvar("mutator_noBoards", "1");
}

init()
{
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
            case 10:
                scripts\sp\zombie_cod5_prototype\zm_spawn_room_only_sleight::sleight_machine_enable();
                break;
            case 15:
                scripts\sp\zombie_cod5_prototype\zm_spawn_room_only_pap::packapunch_machine_enable();
                break;
        }
    }
}

pistol_rank_setuup()
{
    flag_init("_start_zm_pistol_rank");
    flag_wait("all_players_connected");

    /*
    players = GetPlayers();
    if ( players.size == 1 )
    {
        solo = true;
        flag_set( "solo_game" );
        level.solo_lives_given = 0;
        players[0].lives = 0;
        level maps\_zombiemode::zombiemode_solo_last_stand_pistol();
    }
    */

    flag_set( "_start_zm_pistol_rank" );
}
