
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\gametypes_zm\spawnlogic;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\gametypes_zm\_hud_message;



init()
{
    map = getDvar("ui_zm_mapstartlocation");
    switch (map)
    {
    case "transit":
    case "town":
    case "farm":
    case "busdepot":
        level.weaponList = [];
        level.weaponList[1] = "dsr50_zm";
        level.weaponList[2] = "barretm82_zm";
        level.weaponList[3] = "qcw05_zm"; 
        level.weaponList[4] = "ak74u_zm";
        level.weaponList[5] = "mp5k_zm";
        level.weaponList[6] = "pdw57_zm";
        level.weaponList[7] = "fnfal_zm";
        level.weaponList[8] = "m14_zm";
        level.weaponList[9] = "saritch_zm"; 
        level.weaponList[10] = "m16_zm";
        level.weaponList[11] = "tar21_zm";
        level.weaponList[12] = "gl_tar21_zm";
        level.weaponList[13] = "type95_zm";
        level.weaponList[14] = "galil_zm";
        level.weaponList[15] = "xm8_zm"; 
        level.weaponList[16] = "870mcs_zm";
        level.weaponList[17] = "rottweil72_zm"; 
        level.weaponList[18] = "saiga12_zm";
        level.weaponList[19] = "srm1216_zm";
        level.weaponList[20] = "rpd_zm";
        level.weaponList[21] = "hamr_zm";
        level.weaponList[22] = "m1911_zm";
        level.weaponList[23] = "python_zm";
        level.weaponList[24] = "judge_zm";
        level.weaponList[25] = "kard_zm";
        level.weaponList[26] = "fiveseven_zm";
        level.weaponList[27] = "fivesevendw_zm";
        level.weaponList[28] = "beretta93r_zm";
        level.weaponList[29] = "usrpg_zm";
        level.weaponList[30] = "m32_zm";
        level.weaponList[31] = "knife_ballistic_zm";
        level.weaponList[32] = "knife_ballistic_bowie_zm";
        level.weaponList[33] = "knife_ballistic_no_melee_zm";
        level.weaponList[34] = "ray_gun_zm";
        level.weaponList[35] = "raygun_mark2_zm";
    break;
    case "prison":
    case "cellblock":
    case "docks":
    case "showers":
    case "rooftop":
		level.weaponList = [];
        level.weaponList[1] = "dsr50_zm";
		level.weaponList[2] = "barretm82_zm";
        level.weaponList[3] = "svu_zm";
        level.weaponList[4] = "thompson_zm";
        level.weaponList[5] = "mp5k_zm";
        level.weaponList[6] = "pdw57_zm";
        level.weaponList[7] = "uzi_zm";
        level.weaponList[8] = "fnfal_zm";
        level.weaponList[9] = "m14_zm";
        level.weaponList[10] = "tar21_zm";
        level.weaponList[11] = "gl_tar21_zm";
        level.weaponList[12] = "galil_zm";
        level.weaponList[13] = "ak47_zm";
        level.weaponList[14] = "870mcs_zm";
        level.weaponList[15] = "rottweil72_zm"; 
        level.weaponList[16] = "saiga12_zm";
        level.weaponList[17] = "srm1216_zm";
        level.weaponList[18] = "lsat_zm";
        level.weaponList[19] = "minigun_alcatraz_zm"; 
        level.weaponList[20] = "m1911_zm";
        level.weaponList[21] = "judge_zm";
        level.weaponList[22] = "fiveseven_zm";
        level.weaponList[23] = "fivesevendw_zm";
        level.weaponList[24] = "beretta93r_zm";
        level.weaponList[25] = "usrpg_zm";
        level.weaponList[26] = "m32_zm";
        level.weaponList[27] = "knife_ballistic_zm";
        level.weaponList[28] = "knife_ballistic_bowie_zm";
        level.weaponList[29] = "knife_ballistic_no_melee_zm";
        level.weaponList[30] = "ray_gun_zm";
        level.weaponList[31] = "raygun_mark2_zm";
		level.weaponList[32] = "blundergat_zm";
		level.weaponList[33] = "blundersplat_zm"; 

    break;
    case "tomb":
    case "trenches":
    case "crazyplace":
        level.weaponList = [];
        level.weaponList[1] = "dsr50_zm";
        level.weaponList[2] = "ballista_zm";
        level.weaponList[3] = "qcw05_zm"; 
        level.weaponList[4] = "thompson_zm";
        level.weaponList[5] = "ak74u_zm";
        level.weaponList[6] = "ak74u_extclip_zm";
        level.weaponList[7] = "pdw57_zm";
        level.weaponList[8] = "mp40_zm";
        level.weaponList[9] = "mp40_stalker_zm";
        level.weaponList[10] = "evoskorpion_zm"; 
        level.weaponList[11] = "fnfal_zm";
        level.weaponList[12] = "m14_zm";
        level.weaponList[13] = "mp44_zm";
        level.weaponList[14] = "type95_zm";
        level.weaponList[15] = "galil_zm";
        level.weaponList[16] = "scar_zm";
        level.weaponList[17] = "870mcs_zm";
        level.weaponList[18] = "ksg_zm";
        level.weaponList[19] = "srm1216_zm";
        level.weaponList[20] = "mg08_zm";
        level.weaponList[21] = "hamr_zm";
        level.weaponList[22] = "c96_zm"; 
        level.weaponList[23] = "python_zm";
        level.weaponList[24] = "kard_zm";
        level.weaponList[25] = "fiveseven_zm";
        level.weaponList[26] = "fivesevendw_zm";
        level.weaponList[27] = "beretta93r_zm";
        level.weaponList[28] = "beretta93r_extclip_zm";
        level.weaponList[29] = "m32_zm";
        level.weaponList[30] = "ray_gun_zm";
        level.weaponList[31] = "raygun_mark2_zm";
    break;
    case "processing":
    case "maze":
        level.weaponList = [];
        level.weaponList[1] = "dsr50_zm";
        level.weaponList[2] = "barretm82_zm";
        level.weaponList[3] = "svu_zm";
        level.weaponList[4] = "ak74u_zm";
        level.weaponList[5] = "mp5k_zm";
        level.weaponList[6] = "pdw57_zm";
        level.weaponList[7] = "fnfal_zm";
        level.weaponList[8] = "m14_zm";
        level.weaponList[9] = "saritch_zm"; 
        level.weaponList[10] = "m16_zm";
        level.weaponList[11] = "tar21_zm";
        level.weaponList[12] = "gl_tar21_zm";
        level.weaponList[13] = "galil_zm";
        level.weaponList[14] = "an94_zm";
        level.weaponList[15] = "870mcs_zm";
        level.weaponList[16] = "rottweil72_zm"; 
        level.weaponList[17] = "saiga12_zm";
        level.weaponList[18] = "srm1216_zm";
        level.weaponList[19] = "lsat_zm";
        level.weaponList[20] = "hamr_zm";
        level.weaponList[21] = "m1911_zm";
        level.weaponList[22] = "rnma_zm"; 
        level.weaponList[23] = "judge_zm";
        level.weaponList[24] = "kard_zm";
        level.weaponList[25] = "fiveseven_zm";
        level.weaponList[26] = "fivesevendw_zm";
        level.weaponList[27] = "beretta93r_zm";
        level.weaponList[28] = "usrpg_zm";
        level.weaponList[29] = "m32_zm";
        level.weaponList[30] = "knife_ballistic_zm";
        level.weaponList[31] = "knife_ballistic_bowie_zm";
        level.weaponList[32] = "knife_ballistic_no_melee_zm";
        level.weaponList[33] = "ray_gun_zm";
        level.weaponList[34] = "raygun_mark2_zm";
        level.weaponList[35] = "slowgun_zm"; 
    break;
    case "nuked":
    case "nuketown":
        level.weaponList = [];
        level.weaponList[1] = "dsr50_zm";
        level.weaponList[2] = "barretm82_zm";
        level.weaponList[3] = "qcw05_zm"; 
        level.weaponList[4] = "ak74u_zm";
        level.weaponList[5] = "mp5k_zm";
        level.weaponList[6] = "fnfal_zm";
        level.weaponList[7] = "m14_zm";
        level.weaponList[8] = "saritch_zm"; 
        level.weaponList[9] = "m16_zm";
        level.weaponList[10] = "tar21_zm";
        level.weaponList[11] = "gl_tar21_zm";
        level.weaponList[12] = "type95_zm";
        level.weaponList[13] = "galil_zm";
        level.weaponList[14] = "xm8_zm"; 
        level.weaponList[15] = "hk416_zm"; 
        level.weaponList[16] = "870mcs_zm";
        level.weaponList[17] = "rottweil72_zm"; 
        level.weaponList[18] = "saiga12_zm";
        level.weaponList[19] = "srm1216_zm";
        level.weaponList[20] = "rpd_zm";
        level.weaponList[21] = "hamr_zm";
        level.weaponList[22] = "lsat_zm";
        level.weaponList[23] = "m1911_zm";
        level.weaponList[24] = "python_zm";
        level.weaponList[25] = "judge_zm";
        level.weaponList[26] = "kard_zm";
        level.weaponList[27] = "fiveseven_zm";
        level.weaponList[28] = "fivesevendw_zm";
        level.weaponList[29] = "beretta93r_zm";
        level.weaponList[30] = "usrpg_zm";
        level.weaponList[31] = "m32_zm";
        level.weaponList[32] = "knife_ballistic_zm";
        level.weaponList[33] = "knife_ballistic_bowie_zm";
        level.weaponList[34] = "knife_ballistic_no_melee_zm";
        level.weaponList[35] = "ray_gun_zm";
        level.weaponList[36] = "raygun_mark2_zm";
    break;
    case "highrise":
    case "building1top":
    case "redroom":
        level.weaponList = [];
        level.weaponList[1] = "dsr50_zm";
        level.weaponList[2] = "barretm82_zm";
        level.weaponList[3] = "svu_zm";
        level.weaponList[4] = "qcw05_zm"; 
        level.weaponList[5] = "ak74u_zm";
        level.weaponList[6] = "mp5k_zm";
        level.weaponList[7] = "pdw57_zm";
        level.weaponList[8] = "fnfal_zm";
        level.weaponList[9] = "m14_zm";
        level.weaponList[10] = "saritch_zm"; 
        level.weaponList[11] = "m16_zm";
        level.weaponList[12] = "tar21_zm";
        level.weaponList[13] = "gl_tar21_zm";
        level.weaponList[14] = "type95_zm";
        level.weaponList[15] = "galil_zm";
        level.weaponList[16] = "an94_zm";
        level.weaponList[17] = "xm8_zm"; 
        level.weaponList[18] = "870mcs_zm";
        level.weaponList[19] = "rottweil72_zm"; 
        level.weaponList[20] = "saiga12_zm";
        level.weaponList[21] = "srm1216_zm";
        level.weaponList[22] = "rpd_zm";
        level.weaponList[23] = "hamr_zm";
        level.weaponList[24] = "m1911_zm";
        level.weaponList[25] = "python_zm";
        level.weaponList[26] = "judge_zm";
        level.weaponList[27] = "kard_zm";
        level.weaponList[28] = "fiveseven_zm";
        level.weaponList[29] = "fivesevendw_zm";
        level.weaponList[30] = "beretta93r_zm";
        level.weaponList[31] = "usrpg_zm";
        level.weaponList[32] = "m32_zm";
        level.weaponList[33] = "knife_ballistic_zm";
        level.weaponList[34] = "knife_ballistic_bowie_zm";
        level.weaponList[35] = "knife_ballistic_no_melee_zm";
        level.weaponList[36] = "ray_gun_zm";
        level.weaponList[37] = "raygun_mark2_zm";
        level.weaponList[38] = "slipgun_zm"; 
    break;
	}
}

Upgrade_arma(powerup)
{
    self endon("disconnect");

    if (!IsAlive(self))
        return;

        weapon_name = self getcurrentweapon();
    
    
    if (weapon_name == "staff_fire_zm" || weapon_name == "staff_water_zm" || weapon_name == "staff_air_zm" || weapon_name == "staff_lightning_zm")
        {
        return;
            }
    
    
    if (!can_upgrade_weapon(weapon_name))
            {
            return;
        }
    
    
        current_weapon = self GetCurrentWeapon();
    upgrade_name = self get_upgrade_weapon(current_weapon);
    weapon = get_upgrade_weapon(current_weapon, will_upgrade_weapon_as_attachment(current_weapon));
    
    
    self TakeWeapon(current_weapon);
    
    
        self GiveWeapon(weapon);
    
    
        self SwitchToWeapon(weapon);
}

weapon_baston_fire()
{
            self endon("disconnect");
            self TakeWeapon(self GetCurrentWeapon());
            weapon_staff = "staff_fire_zm";
            self GiveWeapon(weapon_staff);
            self SwitchToWeapon(weapon_staff);
}

weapon_baston_hielo()
{
            self endon("disconnect");
            self TakeWeapon(self GetCurrentWeapon());
            weapon_staff = "staff_water_zm";
            self GiveWeapon(weapon_staff);
            self SwitchToWeapon(weapon_staff);
}
weapon_baston_aire()
{
            self endon("disconnect");
            self TakeWeapon(self GetCurrentWeapon());
            weapon_staff = "staff_air_zm";
            self GiveWeapon(weapon_staff);
            self SwitchToWeapon(weapon_staff);
}

weapon_baston_relampago()
{
            self endon("disconnect");
            self TakeWeapon(self GetCurrentWeapon());
            weapon_staff = "staff_lightning_zm";
            self GiveWeapon(weapon_staff);
            self SwitchToWeapon(weapon_staff);
}

give_perks_jugger()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_armorvest") && isDefined(level.zombiemode_using_juggernaut_perk) && level.zombiemode_using_juggernaut_perk))
    {
            self doGivePerk("specialty_armorvest");
    }
}

give_perks_revive(player)
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_quickrevive") && isdefined(level.zombiemode_using_revive_perk) && level.zombiemode_using_revive_perk))
    {
            self doGivePerk("specialty_quickrevive");
    }
}

give_perks_speed()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_fastreload") && isDefined(level.zombiemode_using_sleightofhand_perk) && level.zombiemode_using_sleightofhand_perk))
    {
            self doGivePerk("specialty_fastreload");
    }
}

give_perks_dobletap()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_rof") && isdefined(level.zombiemode_using_doubletap_perk) && level.zombiemode_using_doubletap_perk))
    {
            self doGivePerk("specialty_rof");
    }
}

give_perks_correr()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_longersprint") && isDefined(level.zombiemode_using_marathon_perk) && level.zombiemode_using_marathon_perk))
    {
            self doGivePerk("specialty_longersprint");
    }
}
give_perks_mule()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_additionalprimaryweapon") && isDefined(level.zombiemode_using_additionalprimaryweapon_perk) && level.zombiemode_using_additionalprimaryweapon_perk))
    {
            self doGivePerk("specialty_additionalprimaryweapon");
    }
}

give_perks_cherry()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_grenadepulldeath") && isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_grenadepulldeath"])))
    {
            self doGivePerk("specialty_grenadepulldeath");
    }
}

give_perks_deashot()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_deadshot") && isDefined(level.zombiemode_using_deadshot_perk) && level.zombiemode_using_deadshot_perk))
    {
            self doGivePerk("specialty_deadshot");
    }
}

give_perks_phd()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_flakjacket") && isDefined(level._custom_perks["specialty_flakjacket"]) && (level.script != "zm_buried")))
    {
            self doGivePerk("specialty_flakjacket");
    }
}

give_perk_sensor() 
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if(!(self hasperk("specialty_nomotionsensor") && isdefined(level._custom_perks["specialty_nomotionsensor"]) && (level._custom_perks["specialty_nomotionsensor"])))
    {
            self doGivePerk("specialty_nomotionsensor");
    }
}

give_perk_tumba()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_scavenger") && isDefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk))
    {
            self doGivePerk("specialty_scavenger");
        }
}

give_perk_whoswho()
{
    if(self player_is_in_laststand() || self.sessionstate == "spectator")
        return;
    
    if (!(self hasperk("specialty_finalstand") && isDefined(level.zombiemode_using_chugabud_perk) && level.zombiemode_using_chugabud_perk))
    {
        self doGivePerk("specialty_finalstand");
    }
}




func_GiveAllPerks()
{
    if (isDefined(level.zombiemode_using_juggernaut_perk) && level.zombiemode_using_juggernaut_perk)
         self doGivePerk("specialty_armorvest");
    if (isDefined(level.zombiemode_using_sleightofhand_perk) && level.zombiemode_using_sleightofhand_perk)
      self doGivePerk("specialty_fastreload");
    if (isDefined(level.zombiemode_using_revive_perk) && level.zombiemode_using_revive_perk)
       self doGivePerk("specialty_quickrevive");
    if (isDefined(level.zombiemode_using_doubletap_perk) && level.zombiemode_using_doubletap_perk) 
       self doGivePerk("specialty_rof");
    if (isDefined(level.zombiemode_using_marathon_perk) && level.zombiemode_using_marathon_perk)
        self doGivePerk("specialty_longersprint");
    if(isDefined(level.zombiemode_using_additionalprimaryweapon_perk) && level.zombiemode_using_additionalprimaryweapon_perk)
        self doGivePerk("specialty_additionalprimaryweapon");
    if (isDefined(level.zombiemode_using_deadshot_perk) && level.zombiemode_using_deadshot_perk)
        self doGivePerk("specialty_deadshot");
    if (isDefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk)
        self doGivePerk("specialty_scavenger");
    if (isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_flakjacket"]) && (level.script != "zm_buried"))
        self doGivePerk("specialty_flakjacket");
    if (isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_nomotionsensor"]))
        self doGivePerk("specialty_nomotionsensor");
    if (isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_grenadepulldeath"]))
        self doGivePerk("specialty_grenadepulldeath");
    if (isDefined(level.zombiemode_using_chugabud_perk) && level.zombiemode_using_chugabud_perk)
        self doGivePerk("specialty_finalstand");
}

doGivePerk(perk)
{
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self endon("perk_abort_drinking");
    if (!(self hasperk(perk) || (self maps\mp\zombies\_zm_perks::has_perk_paused(perk))))
    {
        gun = self maps\mp\zombies\_zm_perks::perk_give_bottle_begin(perk);
        evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
        if (evt == "weapon_change_complete")
            self thread maps\mp\zombies\_zm_perks::wait_give_perk(perk, 1);
        self maps\mp\zombies\_zm_perks::perk_give_bottle_end(gun, perk);
        if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
            return;
        self notify("burp");
    }
}
upgrade_baston_zm()
{
    self endon("disconnect");
    
                if (self player_is_in_laststand() || self.sessionstate == "spectator")
        return;

        current = self GetCurrentWeapon();
    which = "";
        
            if (current == "staff_fire_zm")
                    which = "staff_fire_upgraded_zm";
    else if (current == "staff_water_zm")
        which = "staff_water_upgraded_zm";
    else if (current == "staff_air_zm")
        which = "staff_air_upgraded_zm";
    else if (current == "staff_lightning_zm")
        which = "staff_lightning_upgraded_zm";
    else
        return;

                    self thread giveUpgradedStaffs(which);
                }

giveUpgradedStaffs(which)
{
	self TakeWeapon(self GetCurrentWeapon());
    self giveweapon( which, 0, self calcweaponoptions( 40, 0, 0, 0));
    self switchtoweapon(which);
    self setactionslot(3, "weapon", "staff_revive_zm");
    self giveweapon("staff_revive_zm");
    self setweaponammostock("staff_revive_zm", 3);
    self setweaponammoclip("staff_revive_zm", 1);
    self givemaxammo("staff_revive_zm");
}


GiveSpecificWeapon(weapon_name)
{
    if (!IsAlive(self))
        return;

    self endon("disconnect");
    
    
    self TakeWeapon(self GetCurrentWeapon());
    
    
    self GiveWeapon(weapon_name);
    
    
    self SwitchToWeapon(weapon_name);
}


GiveRandomWeapon()
{
    if (!IsAlive(self))
        return;

    self endon("disconnect");
    
    currentWeapon = self GetCurrentWeapon();
    
    
    randomWeaponIndex = randomInt(level.weaponList.size);
    randomWeaponName = level.weaponList[randomWeaponIndex];
    
    
    while (randomWeaponName == currentWeapon)
    {
        randomWeaponIndex = randomInt(level.weaponList.size);
        randomWeaponName = level.weaponList[randomWeaponIndex];
    }
    
    
	self TakeWeapon(self GetCurrentWeapon());
    
    
    self GiveWeapon(randomWeaponName);
    
    
    self SwitchToWeapon(randomWeaponName);
}






spawn_panzer_soldat()
{
    
    level.mechz_left_to_spawn = 1;
    level.mechz_spawned = 0;
    level notify("spawn_mechz", self.origin);
}


spawn_hellhounds(amount)
{
    if (!isDefined(amount))
        amount = 1;
    
    for (i = 0; i < amount; i++)
    {
        spawn_pos = self.origin + (randomIntRange(-100, 100), randomIntRange(-100, 100), 0);
        dog = maps\mp\zombies\_zm_ai_dogs::special_dog_spawn(spawn_pos);
        wait 0.5;
    }
}


spawn_dog_round()
{
    level thread maps\mp\zombies\_zm_ai_dogs::dog_round_start();
}