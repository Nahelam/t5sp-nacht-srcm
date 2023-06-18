#include maps\_utility;

main()
{
    PrecacheModel("collision_geo_128x128x10");
    ReplaceFunc(maps\_zombiemode_perks::third_person_weapon_upgrade, ::third_person_weapon_upgrade);
}

init()
{
    packapunch_machine_setup();
    packapunch_machine_disable();
}

packapunch_machine_setup()
{
    pap_trig = GetEnt("zombie_door", "targetname");
    pap_trig.targetname = "zombie_vending_upgrade";
    pap_trig.target = "vending_pack_a_punch_1";
    pap_trig.origin = (168.375, 117.132, 187.569);

    level.packapunch_machine = pap_trig;

    pap_machine = spawn_model("zombie_vending_packapunch_on", (169.729, 151.912, 144.916));
    pap_machine.targetname = "vending_pack_a_punch_1";

    pap_clip = spawn_model("collision_geo_128x128x10", (168.451, 127.875, 209.02), (90, 90, 0));
    pap_clip Hide();
}

third_person_weapon_upgrade( current_weapon, origin, angles, packa_rollers, perk_machine )
{
    forward = anglesToForward( angles );
    interact_pos = origin + (forward*-25);
    level notify("pap_fx_start");

    worldgun = spawn( "script_model", interact_pos );
    worldgun.angles  = self.angles;
    worldgun setModel( GetWeaponModel( current_weapon ) );
    worldgun useweaponhidetags( current_weapon );
    worldgun rotateto( angles+(0,90,0), 0.35, 0, 0 );

    offsetdw = ( 3, 3, 3 );
    worldgundw = undefined;
    if ( maps\_zombiemode_weapons::weapon_is_dual_wield( current_weapon ) )
    {
        worldgundw = spawn( "script_model", interact_pos + offsetdw );
        worldgundw.angles  = self.angles;

        worldgundw setModel( maps\_zombiemode_weapons::get_left_hand_weapon_model_name( current_weapon ) );
        worldgundw useweaponhidetags( current_weapon );
        worldgundw rotateto( angles+(0,90,0), 0.35, 0, 0 );
    }

    wait( 0.5 );

    worldgun moveto( origin, 0.5, 0, 0 );
    if ( isdefined( worldgundw ) )
    {
        worldgundw moveto( origin + offsetdw, 0.5, 0, 0 );
    }

    self playsound( "zmb_perks_packa_upgrade" );
    if( isDefined( perk_machine.wait_flag ) )
    {
        perk_machine.wait_flag rotateto( perk_machine.wait_flag.angles+(179, 0, 0), 0.25, 0, 0 );
    }
    wait( 0.35 );

    worldgun delete();
    if ( isdefined( worldgundw ) )
    {
        worldgundw delete();
    }

    wait( 3 );

    self playsound( "zmb_perks_packa_ready" );

    worldgun = spawn( "script_model", origin );
    worldgun.angles  = angles+(0,90,0);
    worldgun setModel( GetWeaponModel( level.zombie_weapons[current_weapon].upgrade_name ) );
    worldgun useweaponhidetags( level.zombie_weapons[current_weapon].upgrade_name );
    worldgun moveto( interact_pos, 0.5, 0, 0 );

    worldgundw = undefined;
    if ( maps\_zombiemode_weapons::weapon_is_dual_wield( level.zombie_weapons[current_weapon].upgrade_name ) )
    {
        worldgundw = spawn( "script_model", origin + offsetdw );
        worldgundw.angles  = angles+(0,90,0);

        worldgundw setModel( maps\_zombiemode_weapons::get_left_hand_weapon_model_name( level.zombie_weapons[current_weapon].upgrade_name ) );
        worldgundw useweaponhidetags( level.zombie_weapons[current_weapon].upgrade_name );
        worldgundw moveto( interact_pos + offsetdw, 0.5, 0, 0 );
    }

    if( isDefined( perk_machine.wait_flag ) )
    {
        perk_machine.wait_flag rotateto( perk_machine.wait_flag.angles-(179, 0, 0), 0.25, 0, 0 );
    }

    wait( 0.5 );

    worldgun moveto( origin, level.packapunch_timeout, 0, 0);
    if ( isdefined( worldgundw ) )
    {
        worldgundw moveto( origin + offsetdw, level.packapunch_timeout, 0, 0);
    }

    worldgun.worldgundw = worldgundw;

    level notify("pap_fx_end");

    return worldgun;
}

packapunch_machine_fx_think()
{
    pap = GetEnt("vending_pack_a_punch_1", "targetname");

    origin_left = pap.origin + (-20, -10, 35);
    origin_middle = pap.origin + (0, -10, 35);
    origin_right = pap.origin + (20, -10, 35);

    for (;;)
    {
        level waittill("pap_fx_start");

        wait 0.9;

        fx_left = SpawnFX(level._effect["powerup_on_solo"], origin_left);
        fx_middle = SpawnFX(level._effect["powerup_on_solo"], origin_middle);
        fx_right = SpawnFX(level._effect["powerup_on_solo"], origin_right);

        TriggerFX(fx_left);
        TriggerFX(fx_middle);
        TriggerFX(fx_right);

        level waittill("pap_fx_end");

        fx_left Delete();
        fx_middle Delete();
        fx_right Delete();

    }
}

packapunch_machine_deny()
{
    self endon("packapunch_machine_enable");

    for (;;)
    {
        self waittill("trigger");
        PlaySoundAtPosition("zmb_perks_packa_deny", self.origin);
        wait 1.5;
    }
}

packapunch_machine_disable()
{
    level.packapunch_machine thread packapunch_machine_deny();
    level.packapunch_machine SetCursorHint("HINT_ACTIVATE");
    level.packapunch_machine SetHintString(&"MENU_15_ROUNDS");
}

packapunch_machine_enable()
{
    level.packapunch_machine notify("packapunch_machine_enable");
    level.packapunch_machine SetCursorHint("HINT_NOICON");
    thread packapunch_machine_fx_think();
    level notify("Pack_A_Punch_on");
}
