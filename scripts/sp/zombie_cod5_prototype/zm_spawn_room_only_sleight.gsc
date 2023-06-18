#include maps\_utility;

main()
{
    ReplaceFunc(maps\_zombiemode_perks::place_additionalprimaryweapon_machine, ::sleight_machine_setup);
}

init()
{
    sleight_machine_disable();
}

sleight_machine_setup()
{
    if (!isDefined(level.zombie_additionalprimaryweapon_machine_origin))
    {
        return;
    }

    machine = Spawn("script_model", level.zombie_additionalprimaryweapon_machine_origin);
    machine.angles = level.zombie_additionalprimaryweapon_machine_angles;
    machine setModel("zombie_vending_sleight_on");
    machine.targetname = "vending_sleight";

    machine_trigger = Spawn("trigger_radius_use", level.zombie_additionalprimaryweapon_machine_origin + (0, 0, 30), 0, 20, 70);
    machine_trigger.targetname = "zombie_vending";
    machine_trigger.target = "vending_sleight";
    machine_trigger.script_noteworthy = "specialty_fastreload";

    level.sleight_machine = machine_trigger;

    if (isDefined(level.zombie_additionalprimaryweapon_machine_clip_origin))
    {
        machine_clip = Spawn("script_model", level.zombie_additionalprimaryweapon_machine_clip_origin);
        machine_clip.angles = level.zombie_additionalprimaryweapon_machine_clip_angles;
        machine_clip setmodel("collision_geo_64x64x256");
        machine_clip Hide();
    }

    level.zombiemode_using_additionalprimaryweapon_perk = true;
}

sleight_machine_disable()
{
    level.sleight_machine thread sleight_machine_deny();
    level.sleight_machine SetCursorHint("HINT_ACTIVATE");
    level.sleight_machine SetHintString(&"MENU_10_ROUNDS");
}

sleight_machine_enable()
{
    level.sleight_machine notify("sleight_machine_enable");
    level.sleight_machine SetCursorHint("HINT_NOICON");
    level notify("sleight_on");
}

sleight_machine_deny()
{
    self endon("sleight_machine_enable");

    for (;;)
    {
        self waittill("trigger");
        PlaySoundAtPosition("evt_bottle_break", self.origin);
        wait 2;
    }
}
