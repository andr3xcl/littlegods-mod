#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\gametypes_zm\spawnlogic;
#include maps\mp\gametypes_zm\_hostmigration;
init()
{
    level endon("game_ended");
    level thread on_player_connect();
    level thread onPlayerSay();
    level thread monitor_end_game(); 
}
on_player_connect()
{
    level endon( "end_game" );
    for (;;)
    {
        level waittill( "connected", player );


        player thread on_players_spawned();
    
        wait 7.0;
    }
}
on_players_spawned()
{
    self endon( "disconnect" );
    
    
    self thread reset_night_mode_on_end();
    
    first_spawn = true;
    
    for (;;)
    {
        self waittill( "spawned_player" );
        self.nightfix = -1;
        self.fog = 0;
        self.definido_comandos = 0;
        
        
        if (first_spawn)
        {
            first_spawn = false;
            self thread save_default_dvars();
        }

    }
}


save_default_dvars()
{
    wait 0.5; 
    
    
    if (!isDefined(level.default_r_exposureValue))
        level.default_r_exposureValue = 0;
    
    if (!isDefined(level.default_r_lightTweakSunLight))
        level.default_r_lightTweakSunLight = 1;
    
    if (!isDefined(level.default_r_sky_intensity_factor0))
        level.default_r_sky_intensity_factor0 = 1;
}


reset_night_mode_on_end()
{
    
    self waittill_any( "disconnect", "death" );
    
    
    self reset_all_night_mode_dvars();
}


monitor_end_game()
{
    level waittill( "end_game" );
    
    
    foreach(player in level.players)
    {
        if (isDefined(player))
        {
            player reset_all_night_mode_dvars();
        }
    }
}


reset_all_night_mode_dvars()
{
    
    self SetClientDvar("r_filmUseTweaks", 0);
    self SetClientDvar("r_bloomTweaks", 0);
    self SetClientDvar("r_exposureTweak", 0);
    
    
    if (isDefined(level.default_r_exposureValue))
        self SetClientDvar("r_exposureValue", level.default_r_exposureValue);
    else
        self SetClientDvar("r_exposureValue", 0);
    
    if (isDefined(level.default_r_lightTweakSunLight))
        self SetClientDvar("r_lightTweakSunLight", level.default_r_lightTweakSunLight);
    else
        self SetClientDvar("r_lightTweakSunLight", 1);
    
    if (isDefined(level.default_r_sky_intensity_factor0))
        self SetClientDvar("r_sky_intensity_factor0", level.default_r_sky_intensity_factor0);
    else
        self SetClientDvar("r_sky_intensity_factor0", 1);
    
    
    self SetClientDvar("r_filmTweakEnable", 0);
    self SetClientDvar("r_filmTweakInvert", 0);
    self SetClientDvar("r_filmTweakBrightness", 0);
    self SetClientDvar("r_filmTweakContrast", 1);
    self SetClientDvar("r_filmTweakDesaturation", 0);
    self SetClientDvar("r_filmTweakLightTint", "1 1 1");
    self SetClientDvar("r_filmTweakDarkTint", "1 1 1");
    
    
    if (isDefined(self.fog) && self.fog == 1)
    {
        self SetClientDvar("r_fog", "1");
        self SetClientDvar("scr_fog_disable", "0");
        self SetClientDvar("r_fog_disable", "0");
        self SetClientDvar("r_fogSunOpacity", "1");
        self.fog = 0;
    }
    
    
    self.nightfix = -1;
    self.night_mode_enabled = false;
}
night_mode_toggle(i)
{
    self endon("discconnect");
    self.nightfix = 1;
	switch (i)
	{
		case 0:              self thread enable_dark_mode();                           break;
		case 1:              self thread enable_acid_night_mode();                     break;
		case 2:              self thread enable_mystic_purple_night_mode();            break;
		case 3:              self thread enable_apocalyptic_yellow_night_mode();       break;
		case 4:              self thread enable_radioactive_green_night_mode();        break;
		case 5:              self thread enable_bloody_night_mode();                   break;
		case 6:              self thread enable_cold_night_mode();                     break;
		case 7:              self thread enable_extreme_blue_night_mode();             break;
		case 8:              self thread enable_luminous_night_mode();                 break;
		case 9:              self thread enable_warm_night_mode();                     break;
		case 10:             self thread enable_nebulous_night_mode();                 break;
		case 11:             self thread enable_apocalyptic_night_mode();              break;
		case 12:             self thread enable_retro_night_mode();                    break;
		case 13:             self thread enable_ice_night_mode();                      break;
		case 14:             self thread enable_ghost_night_mode();                    break;
		case 15:             self thread enable_starred_night_mode();                  break;
		case 16:             self thread enable_radiant_night_mode();                  break;
		case 17:             self thread enable_storm_night_mode();                    break;
        case 18:             self thread enable_galaxy_night_mode();                   break;
        case 19:             self thread enable_pastel_pink_night_mode();              break;
        case 20:             self thread enable_gray_night_mode();                     break;
        case 21:             self thread enable_cyberpunk_night_mode();               break;
        case 22:             self thread enable_underwater_night_mode();              break;
        case 23:             self thread enable_desert_storm_night_mode();            break;
        case 24:             self thread enable_mystic_forest_night_mode();           break;
        case 25:             self thread enable_volcano_lava_night_mode();            break;
        case 26:             self thread enable_crystal_cave_night_mode();            break;
        case 27:             self thread enable_haunted_house_night_mode();           break;
        case 28:             self thread enable_carnival_circus_night_mode();         break;
        case 29:             self thread enable_alien_space_night_mode();             break;
        case 30:             self thread enable_coral_reef_night_mode();              break;
        case 31:             self thread enable_northern_lights_night_mode();         break;
        case 32:             self thread enable_toxic_waste_night_mode();             break;
        case 33:             self thread enable_ancient_temple_night_mode();          break;
        case 34:             self thread enable_futuristic_city_night_mode();         break;
        case 35:             self thread enable_dream_world_night_mode();             break;
	}

	wait 0.05;
}
set_common_dvars()
{
    if (!isDefined(level.default_r_exposureValue))
        level.default_r_exposureValue = getDvar("r_exposureValue");

    if (!isDefined(level.default_r_lightTweakSunLight))
        level.default_r_lightTweakSunLight = getDvar("r_lightTweakSunLight");

    if (!isDefined(level.default_r_sky_intensity_factor0))
        level.default_r_sky_intensity_factor0 = getDvar("r_sky_intensity_factor0");

    self SetClientDvar("r_filmUseTweaks", 1); self SetClientDvar("r_bloomTweaks", 1); self SetClientDvar("r_exposureTweak", 1);
}

set_map_specific_exposure()
{
    if (level.script == "zm_buried")
    {
        self setclientdvar("r_exposureValue", 5);
    }
    else if (level.script == "zm_tomb")
    {
        self setclientdvar("r_exposureValue", 5);
    }
    else if (level.script == "zm_nuked")
    {
        self setclientdvar("r_exposureValue", 5);
    }
    else if (level.script == "zm_highrise")
    {
        self setclientdvar("r_exposureValue", 5);
    }
	else if (level.script == "zm_transit")
    {
        self setclientdvar("r_exposureValue", 5);
    }
	else if (level.script == "zm_prison")
    {
        self setclientdvar("r_exposureValue", 5);
    }
}


enable_dark_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 ); 
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 ); 
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.05 0.05 0.05 0");
    self SetClientDvar("vc_yl", "0.1 0.1 0.1 0");
    self SetClientDvar("vc_yh", "0.2 0.2 0.2 0");
    self SetClientDvar("vc_rgbl", "0.05 0.05 0.05 0");
    self SetClientDvar("r_exposureValue", 1.0);
    self SetClientDvar("r_lightTweakSunLight", 0.1);
    self SetClientDvar("r_sky_intensity_factor0", 0.1);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
    self thread visual_fix();
}
enable_acid_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 ); 
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.2 0.8 0.2 0");
    self SetClientDvar("vc_yl", "0.1 0.5 0.1 0");
    self SetClientDvar("vc_yh", "0.3 0.9 0.3 0");
    self SetClientDvar("vc_rgbl", "0.2 0.8 0.2 0");
    self SetClientDvar("r_exposureValue", 4.0);
    self SetClientDvar("r_lightTweakSunLight", 1.2);
    self SetClientDvar("r_sky_intensity_factor0", 1.0);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_mystic_purple_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 );
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.5 0 0.5 0");
    self SetClientDvar("vc_yl", "0.4 0 0.4 0");
    self SetClientDvar("vc_yh", "0.6 0 0.6 0");
    self SetClientDvar("vc_rgbl", "0.5 0 0.5 0");
    self SetClientDvar("r_exposureValue", 2.0);
    self SetClientDvar("r_lightTweakSunLight", 0.3);
    self SetClientDvar("r_sky_intensity_factor0", 0.5);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
}

enable_apocalyptic_yellow_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.9 0.7 0.1 0");
    self SetClientDvar("vc_yl", "0.8 0.6 0.1 0");
    self SetClientDvar("vc_yh", "1 0.8 0.2 0");
    self SetClientDvar("vc_rgbl", "0.9 0.7 0.1 0");
    self SetClientDvar("r_exposureValue", 3.0);
    self SetClientDvar("r_lightTweakSunLight", 0.5);
    self SetClientDvar("r_sky_intensity_factor0", 0.3);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_radioactive_green_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.1 0.8 0.1 0");
    self SetClientDvar("vc_yl", "0.1 0.6 0.1 0");
    self SetClientDvar("vc_yh", "0.1 1 0.1 0");
    self SetClientDvar("vc_rgbl", "0.1 0.8 0.1 0");
    self SetClientDvar("r_exposureValue", 2.5);
    self SetClientDvar("r_lightTweakSunLight", 0.4);
    self SetClientDvar("r_sky_intensity_factor0", 0.2);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}
enable_bloody_night_mode()
{
	self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 ); 
    self SetClientDvar( "vc_rgbh", "0.6 0 0 0" );
    self SetClientDvar( "vc_yl", "0.15 0 0 0" ); 
    self SetClientDvar( "vc_yh", "0.2 0 0 0" );
    self SetClientDvar( "vc_rgbl", "0.6 0 0 0" );
    self SetClientDvar( "r_exposureValue", 1.5 );
    self SetClientDvar( "r_lightTweakSunLight", 0.3 );
    self SetClientDvar( "r_sky_intensity_factor0", 0 );
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
	set_map_specific_exposure();
	self thread visual_fix();
}
enable_cold_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 );
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.2 0.2 0.5 0");
    self SetClientDvar("vc_yl", "0.2 0.2 0.5 0");
    self SetClientDvar("vc_yh", "0.3 0.3 0.6 0");
    self SetClientDvar("vc_rgbl", "0.1 0.1 0.4 0");
    self SetClientDvar("r_exposureValue", 1.5);
    self SetClientDvar("r_lightTweakSunLight", 0.3);
    self SetClientDvar("r_sky_intensity_factor0", 0.4);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_extreme_blue_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 );
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.1 0.1 0.8 0");
    self SetClientDvar("vc_yl", "0.1 0.1 0.6 0");
    self SetClientDvar("vc_yh", "0.2 0.2 1 0");
    self SetClientDvar("vc_rgbl", "0.1 0.1 0.8 0");
    self SetClientDvar("r_exposureValue", 1.8);
    self SetClientDvar("r_lightTweakSunLight", 0.2);
    self SetClientDvar("r_sky_intensity_factor0", 0.3);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}







enable_luminous_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 ); 
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.5 0.5 0.9 0");
    self SetClientDvar("vc_yl", "0.5 0.5 0.9 0");
    self SetClientDvar("vc_yh", "0.6 0.6 1 0");
    self SetClientDvar("vc_rgbl", "0.4 0.4 0.8 0");
    self SetClientDvar("r_exposureValue", 2.0);
    self SetClientDvar("r_lightTweakSunLight", 0.6);
    self SetClientDvar("r_sky_intensity_factor0", 0.6);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_warm_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.9 0.6 0.2 0");
    self SetClientDvar("vc_yl", "0.8 0.5 0.1 0");
    self SetClientDvar("vc_yh", "1 0.7 0.2 0");
    self SetClientDvar("vc_rgbl", "0.7 0.5 0.2 0");
    self SetClientDvar("r_exposureValue", 2.5);
    self SetClientDvar("r_lightTweakSunLight", 0.8);
    self SetClientDvar("r_sky_intensity_factor0", 0.5);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_nebulous_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "r_filmUseTweaks", 1 ); 
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.6 0.6 0.7 0");
    self SetClientDvar("vc_yl", "0.5 0.5 0.6 0");
    self SetClientDvar("vc_yh", "0.7 0.7 0.8 0");
    self SetClientDvar("vc_rgbl", "0.5 0.5 0.6 0");
    self SetClientDvar("r_exposureValue", 2.2);
    self SetClientDvar("r_lightTweakSunLight", 0.4);
    self SetClientDvar("r_sky_intensity_factor0", 0.3);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_apocalyptic_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.8 0.1 0.1 0");
    self SetClientDvar("vc_yl", "0.6 0.1 0.1 0");
    self SetClientDvar("vc_yh", "1 0.3 0.3 0");
    self SetClientDvar("vc_rgbl", "0.7 0.1 0.1 0");
    self SetClientDvar("r_exposureValue", 3.0);
    self SetClientDvar("r_lightTweakSunLight", 0.5);
    self SetClientDvar("r_sky_intensity_factor0", 0.4);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_retro_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 ); 
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.2 0.5 0.1 0");
    self SetClientDvar("vc_yl", "0.2 0.5 0.1 0");
    self SetClientDvar("vc_yh", "0.3 0.6 0.2 0");
    self SetClientDvar("vc_rgbl", "0.1 0.4 0.1 0");
    self SetClientDvar("r_exposureValue", 2.0);
    self SetClientDvar("r_lightTweakSunLight", 0.4);
    self SetClientDvar("r_sky_intensity_factor0", 0.2);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_ice_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 ); 
    self SetClientDvar( "r_bloomTweaks", 1 );
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.1 0.5 0.8 0");
    self SetClientDvar("vc_yl", "0.1 0.4 0.7 0");
    self SetClientDvar("vc_yh", "0.2 0.6 1 0");
    self SetClientDvar("vc_rgbl", "0.1 0.5 0.8 0");
    self SetClientDvar("r_exposureValue", 1.8);
    self SetClientDvar("r_lightTweakSunLight", 0.3);
    self SetClientDvar("r_sky_intensity_factor0", 0.4);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_ghost_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.8 0.8 0.9 0");
    self SetClientDvar("vc_yl", "0.7 0.7 0.8 0");
    self SetClientDvar("vc_yh", "0.9 0.9 1 0");
    self SetClientDvar("vc_rgbl", "0.6 0.6 0.8 0");
    self SetClientDvar("r_exposureValue", 2.5);
    self SetClientDvar("r_lightTweakSunLight", 0.4);
    self SetClientDvar("r_sky_intensity_factor0", 0.5);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_starred_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.2 0.2 0.5 0");
    self SetClientDvar("vc_yl", "0.2 0.2 0.5 0");
    self SetClientDvar("vc_yh", "0.3 0.3 0.6 0");
    self SetClientDvar("vc_rgbl", "0.1 0.1 0.4 0");
    self SetClientDvar("r_exposureValue", 2.0);
    self SetClientDvar("r_lightTweakSunLight", 0.5);
    self SetClientDvar("r_sky_intensity_factor0", 0.5);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_radiant_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 ); 
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.5 0.8 0.1 0");
    self SetClientDvar("vc_yl", "0.4 0.7 0.1 0");
    self SetClientDvar("vc_yh", "0.6 0.9 0.2 0");
    self SetClientDvar("vc_rgbl", "0.5 0.8 0.1 0");
    self SetClientDvar("r_exposureValue", 2.0);
    self SetClientDvar("r_lightTweakSunLight", 0.5);
    self SetClientDvar("r_sky_intensity_factor0", 0.5);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}

enable_storm_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 ); 
    self SetClientDvar( "r_bloomTweaks", 1 );
    self SetClientDvar( "r_exposureTweak", 1 ); 
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.3 0.3 0.4 0");
    self SetClientDvar("vc_yl", "0.3 0.3 0.5 0");
    self SetClientDvar("vc_yh", "0.4 0.4 0.6 0");
    self SetClientDvar("vc_rgbl", "0.2 0.2 0.3 0");
    self SetClientDvar("r_exposureValue", 1.8);
    self SetClientDvar("r_lightTweakSunLight", 0.4);
    self SetClientDvar("r_sky_intensity_factor0", 0.6);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.5);
    set_map_specific_exposure();
	self thread visual_fix();
}
enable_galaxy_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 ); 
    self SetClientDvar( "r_bloomTweaks", 1 ); 
    self SetClientDvar( "r_exposureTweak", 1 ); 
	self SetClientDvar( "vc_fbm", "0 0 0 0" );
	self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar("vc_rgbh", "0.4 0.1 0.7 0");
    self SetClientDvar("vc_yl", "0.3 0.1 0.5 0");
    self SetClientDvar("vc_yh", "0.5 0.2 0.8 0");
    self SetClientDvar("vc_rgbl", "0.3 0.1 0.5 0");
    self SetClientDvar("r_exposureValue", 2.5);
    self SetClientDvar("r_lightTweakSunLight", 0.6);
    self SetClientDvar("r_sky_intensity_factor0", 0.7);
    self SetClientDvar("r_bloomScale", 1.7);
    self SetClientDvar("r_bloomThreshold", 0.4);
    self SetClientDvar("r_filmTweakBrightness", 10);
    self SetClientDvar("r_filmTweakContrast", 5);
    self thread visual_fix();
    set_map_specific_exposure();
}
enable_pastel_pink_night_mode()
{
    self endon("disconnect");
    set_common_dvars();
	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 );
    self SetClientDvar( "r_exposureTweak", 1 );
    self SetClientDvar("vc_rgbh", "0.9 0.6 0.7 0");
    self SetClientDvar("vc_yl", "0.8 0.5 0.6 0");
    self SetClientDvar("vc_yh", "0.95 0.7 0.8 0");
    self SetClientDvar("vc_rgbl", "0.8 0.5 0.6 0");
    self SetClientDvar("r_exposureValue", 2.8);
    self SetClientDvar("r_lightTweakSunLight", 0.7);
    self SetClientDvar("r_sky_intensity_factor0", 0.8);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.3);
    self SetClientDvar("r_filmTweakBrightness", 10);
    self SetClientDvar("r_filmTweakContrast", 7);
    self thread visual_fix();
    set_map_specific_exposure();
}
enable_gray_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

	self SetClientDvar( "r_dof_enable", 0 );
	self SetClientDvar( "r_lodBiasRigid", -1000 );
	self SetClientDvar( "r_lodBiasSkinned", -1000 );
	self SetClientDvar( "r_enablePlayerShadow", 1 );
	self SetClientDvar( "r_skyTransition", 1 );
	self SetClientDvar( "sm_sunquality", 2 );
	self SetClientDvar( "r_filmUseTweaks", 1 );
    self SetClientDvar( "r_bloomTweaks", 1 );
    self SetClientDvar( "r_exposureTweak", 1 );
    self SetClientDvar("vc_rgbh", "0.5 0.5 0.5 0");
    self SetClientDvar("vc_yl", "0.4 0.4 0.4 0");
    self SetClientDvar("vc_yh", "0.6 0.6 0.6 0");
    self SetClientDvar("vc_rgbl", "0.4 0.4 0.4 0");
    self SetClientDvar("r_exposureValue", 2.2);
    self SetClientDvar("r_lightTweakSunLight", 0.5);
    self SetClientDvar("r_sky_intensity_factor0", 0.6);
    self SetClientDvar("r_bloomScale", 5);
    self SetClientDvar("r_bloomThreshold", 10);
    self SetClientDvar("r_filmTweakBrightness", 10);
    self SetClientDvar("r_filmTweakContrast", 7);
    self thread visual_fix();
    set_map_specific_exposure();
}




enable_cyberpunk_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);

    
    self SetClientDvar("vc_rgbh", "0.8 0.2 1.0 0");
    self SetClientDvar("vc_yl", "0.2 0.8 1.0 0");
    self SetClientDvar("vc_yh", "1.0 0.4 0.8 0");
    self SetClientDvar("vc_rgbl", "0.6 0.2 0.8 0");

    self SetClientDvar("r_exposureValue", 3.2);
    self SetClientDvar("r_lightTweakSunLight", 0.8);
    self SetClientDvar("r_sky_intensity_factor0", 0.9);
    self SetClientDvar("r_bloomScale", 2.0);
    self SetClientDvar("r_bloomThreshold", 0.6);
    self SetClientDvar("r_filmTweakBrightness", 15);
    self SetClientDvar("r_filmTweakContrast", 8);
    self SetClientDvar("r_filmTweakDesaturation", 0.3);

    self thread visual_fix();
    set_map_specific_exposure();
}


enable_underwater_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.1 0.3 0.8 0");
    self SetClientDvar("vc_yl", "0.1 0.2 0.6 0");
    self SetClientDvar("vc_yh", "0.2 0.4 1.0 0");
    self SetClientDvar("vc_rgbl", "0.1 0.2 0.5 0");

    self SetClientDvar("r_exposureValue", 1.5);
    self SetClientDvar("r_lightTweakSunLight", 0.2);
    self SetClientDvar("r_sky_intensity_factor0", 0.3);
    self SetClientDvar("r_bloomScale", 1.8);
    self SetClientDvar("r_bloomThreshold", 0.4);
    self SetClientDvar("r_filmTweakBrightness", -5);
    self SetClientDvar("r_filmTweakContrast", 12);
    self SetClientDvar("r_filmTweakDesaturation", 0.4);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_desert_storm_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.8 0.6 0.2 0");
    self SetClientDvar("vc_yl", "0.6 0.4 0.1 0");
    self SetClientDvar("vc_yh", "1.0 0.8 0.3 0");
    self SetClientDvar("vc_rgbl", "0.5 0.3 0.1 0");

    self SetClientDvar("r_exposureValue", 2.8);
    self SetClientDvar("r_lightTweakSunLight", 0.7);
    self SetClientDvar("r_sky_intensity_factor0", 0.8);
    self SetClientDvar("r_bloomScale", 1.3);
    self SetClientDvar("r_bloomThreshold", 0.5);
    self SetClientDvar("r_filmTweakBrightness", 8);
    self SetClientDvar("r_filmTweakContrast", 6);
    self SetClientDvar("r_filmTweakDesaturation", 0.1);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_mystic_forest_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.1 0.6 0.2 0");
    self SetClientDvar("vc_yl", "0.1 0.4 0.1 0");
    self SetClientDvar("vc_yh", "0.2 0.8 0.3 0");
    self SetClientDvar("vc_rgbl", "0.1 0.3 0.1 0");

    self SetClientDvar("r_exposureValue", 1.8);
    self SetClientDvar("r_lightTweakSunLight", 0.3);
    self SetClientDvar("r_sky_intensity_factor0", 0.4);
    self SetClientDvar("r_bloomScale", 2.2);
    self SetClientDvar("r_bloomThreshold", 0.3);
    self SetClientDvar("r_filmTweakBrightness", -3);
    self SetClientDvar("r_filmTweakContrast", 10);
    self SetClientDvar("r_filmTweakDesaturation", 0.6);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_volcano_lava_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "1.0 0.2 0.1 0");
    self SetClientDvar("vc_yl", "0.8 0.1 0.1 0");
    self SetClientDvar("vc_yh", "1.0 0.4 0.2 0");
    self SetClientDvar("vc_rgbl", "0.6 0.1 0.1 0");

    self SetClientDvar("r_exposureValue", 3.5);
    self SetClientDvar("r_lightTweakSunLight", 1.0);
    self SetClientDvar("r_sky_intensity_factor0", 0.7);
    self SetClientDvar("r_bloomScale", 2.5);
    self SetClientDvar("r_bloomThreshold", 0.7);
    self SetClientDvar("r_filmTweakBrightness", 12);
    self SetClientDvar("r_filmTweakContrast", 9);
    self SetClientDvar("r_filmTweakDesaturation", 0.2);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_crystal_cave_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.3 0.5 1.0 0");
    self SetClientDvar("vc_yl", "0.2 0.3 0.8 0");
    self SetClientDvar("vc_yh", "0.4 0.6 1.0 0");
    self SetClientDvar("vc_rgbl", "0.2 0.2 0.6 0");

    self SetClientDvar("r_exposureValue", 2.0);
    self SetClientDvar("r_lightTweakSunLight", 0.4);
    self SetClientDvar("r_sky_intensity_factor0", 0.5);
    self SetClientDvar("r_bloomScale", 2.8);
    self SetClientDvar("r_bloomThreshold", 0.5);
    self SetClientDvar("r_filmTweakBrightness", 5);
    self SetClientDvar("r_filmTweakContrast", 11);
    self SetClientDvar("r_filmTweakDesaturation", 0.5);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_haunted_house_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.3 0.7 0.3 0");
    self SetClientDvar("vc_yl", "0.2 0.5 0.2 0");
    self SetClientDvar("vc_yh", "0.4 0.8 0.4 0");
    self SetClientDvar("vc_rgbl", "0.1 0.3 0.1 0");

    self SetClientDvar("r_exposureValue", 1.2);
    self SetClientDvar("r_lightTweakSunLight", 0.1);
    self SetClientDvar("r_sky_intensity_factor0", 0.2);
    self SetClientDvar("r_bloomScale", 1.2);
    self SetClientDvar("r_bloomThreshold", 0.2);
    self SetClientDvar("r_filmTweakBrightness", -8);
    self SetClientDvar("r_filmTweakContrast", 14);
    self SetClientDvar("r_filmTweakDesaturation", 0.7);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_carnival_circus_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "1.0 0.8 0.2 0");
    self SetClientDvar("vc_yl", "0.8 0.2 0.8 0");
    self SetClientDvar("vc_yh", "1.0 1.0 0.4 0");
    self SetClientDvar("vc_rgbl", "0.6 0.4 0.1 0");

    self SetClientDvar("r_exposureValue", 3.0);
    self SetClientDvar("r_lightTweakSunLight", 0.9);
    self SetClientDvar("r_sky_intensity_factor0", 1.0);
    self SetClientDvar("r_bloomScale", 2.2);
    self SetClientDvar("r_bloomThreshold", 0.6);
    self SetClientDvar("r_filmTweakBrightness", 10);
    self SetClientDvar("r_filmTweakContrast", 7);
    self SetClientDvar("r_filmTweakDesaturation", 0.1);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_alien_space_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.2 0.9 0.6 0");
    self SetClientDvar("vc_yl", "0.1 0.7 0.4 0");
    self SetClientDvar("vc_yh", "0.3 1.0 0.8 0");
    self SetClientDvar("vc_rgbl", "0.1 0.5 0.3 0");

    self SetClientDvar("r_exposureValue", 2.5);
    self SetClientDvar("r_lightTweakSunLight", 0.6);
    self SetClientDvar("r_sky_intensity_factor0", 0.8);
    self SetClientDvar("r_bloomScale", 2.5);
    self SetClientDvar("r_bloomThreshold", 0.4);
    self SetClientDvar("r_filmTweakBrightness", 8);
    self SetClientDvar("r_filmTweakContrast", 9);
    self SetClientDvar("r_filmTweakDesaturation", 0.3);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_coral_reef_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.1 0.6 0.8 0");
    self SetClientDvar("vc_yl", "0.1 0.4 0.6 0");
    self SetClientDvar("vc_yh", "0.2 0.8 1.0 0");
    self SetClientDvar("vc_rgbl", "0.1 0.3 0.5 0");

    self SetClientDvar("r_exposureValue", 1.7);
    self SetClientDvar("r_lightTweakSunLight", 0.3);
    self SetClientDvar("r_sky_intensity_factor0", 0.4);
    self SetClientDvar("r_bloomScale", 2.0);
    self SetClientDvar("r_bloomThreshold", 0.3);
    self SetClientDvar("r_filmTweakBrightness", -2);
    self SetClientDvar("r_filmTweakContrast", 13);
    self SetClientDvar("r_filmTweakDesaturation", 0.4);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_northern_lights_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.3 0.8 0.9 0");
    self SetClientDvar("vc_yl", "0.1 0.6 0.7 0");
    self SetClientDvar("vc_yh", "0.5 1.0 1.0 0");
    self SetClientDvar("vc_rgbl", "0.2 0.5 0.6 0");

    self SetClientDvar("r_exposureValue", 1.9);
    self SetClientDvar("r_lightTweakSunLight", 0.4);
    self SetClientDvar("r_sky_intensity_factor0", 0.5);
    self SetClientDvar("r_bloomScale", 2.8);
    self SetClientDvar("r_bloomThreshold", 0.4);
    self SetClientDvar("r_filmTweakBrightness", 3);
    self SetClientDvar("r_filmTweakContrast", 10);
    self SetClientDvar("r_filmTweakDesaturation", 0.6);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_toxic_waste_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.8 0.9 0.2 0");
    self SetClientDvar("vc_yl", "0.6 0.7 0.1 0");
    self SetClientDvar("vc_yh", "1.0 1.0 0.3 0");
    self SetClientDvar("vc_rgbl", "0.5 0.6 0.1 0");

    self SetClientDvar("r_exposureValue", 2.7);
    self SetClientDvar("r_lightTweakSunLight", 0.6);
    self SetClientDvar("r_sky_intensity_factor0", 0.7);
    self SetClientDvar("r_bloomScale", 1.8);
    self SetClientDvar("r_bloomThreshold", 0.5);
    self SetClientDvar("r_filmTweakBrightness", 6);
    self SetClientDvar("r_filmTweakContrast", 8);
    self SetClientDvar("r_filmTweakDesaturation", 0.2);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_ancient_temple_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.8 0.5 0.2 0");
    self SetClientDvar("vc_yl", "0.6 0.3 0.1 0");
    self SetClientDvar("vc_yh", "1.0 0.7 0.3 0");
    self SetClientDvar("vc_rgbl", "0.5 0.3 0.1 0");

    self SetClientDvar("r_exposureValue", 2.3);
    self SetClientDvar("r_lightTweakSunLight", 0.5);
    self SetClientDvar("r_sky_intensity_factor0", 0.6);
    self SetClientDvar("r_bloomScale", 1.5);
    self SetClientDvar("r_bloomThreshold", 0.4);
    self SetClientDvar("r_filmTweakBrightness", 4);
    self SetClientDvar("r_filmTweakContrast", 9);
    self SetClientDvar("r_filmTweakDesaturation", 0.3);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_futuristic_city_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.7 0.8 1.0 0");
    self SetClientDvar("vc_yl", "0.5 0.6 0.8 0");
    self SetClientDvar("vc_yh", "0.9 1.0 1.0 0");
    self SetClientDvar("vc_rgbl", "0.4 0.5 0.7 0");

    self SetClientDvar("r_exposureValue", 2.8);
    self SetClientDvar("r_lightTweakSunLight", 0.7);
    self SetClientDvar("r_sky_intensity_factor0", 0.9);
    self SetClientDvar("r_bloomScale", 2.0);
    self SetClientDvar("r_bloomThreshold", 0.6);
    self SetClientDvar("r_filmTweakBrightness", 12);
    self SetClientDvar("r_filmTweakContrast", 7);
    self SetClientDvar("r_filmTweakDesaturation", 0.1);

    set_map_specific_exposure();
    self thread visual_fix();
}


enable_dream_world_night_mode()
{
    self endon("disconnect");
    set_common_dvars();

    self SetClientDvar("r_dof_enable", 0);
    self SetClientDvar("r_lodBiasRigid", -1000);
    self SetClientDvar("r_lodBiasSkinned", -1000);
    self SetClientDvar("r_enablePlayerShadow", 1);
    self SetClientDvar("r_skyTransition", 1);
    self SetClientDvar("sm_sunquality", 2);
    self SetClientDvar("r_filmUseTweaks", 1);
    self SetClientDvar("r_bloomTweaks", 1);
    self SetClientDvar("r_exposureTweak", 1);
    self SetClientDvar("vc_fbm", "0 0 0 0");
    self SetClientDvar("vc_fsm", "1 1 1 1");

    
    self SetClientDvar("vc_rgbh", "0.9 0.4 0.8 0");
    self SetClientDvar("vc_yl", "0.7 0.3 0.6 0");
    self SetClientDvar("vc_yh", "1.0 0.6 1.0 0");
    self SetClientDvar("vc_rgbl", "0.6 0.2 0.5 0");

    self SetClientDvar("r_exposureValue", 2.4);
    self SetClientDvar("r_lightTweakSunLight", 0.5);
    self SetClientDvar("r_sky_intensity_factor0", 0.7);
    self SetClientDvar("r_bloomScale", 2.5);
    self SetClientDvar("r_bloomThreshold", 0.3);
    self SetClientDvar("r_filmTweakBrightness", 7);
    self SetClientDvar("r_filmTweakContrast", 8);
    self SetClientDvar("r_filmTweakDesaturation", 0.4);

    set_map_specific_exposure();
    self thread visual_fix();
}
disable_night_mode() 
{
	self notify( "disable_nightmode" );
	self.night = 0;
	self.nightfix = 0;
	self SetClientDvar( "r_filmUseTweaks", 0 );
	self SetClientDvar( "r_bloomTweaks", 0 );
	self SetClientDvar( "r_exposureTweak", 0 );
	self SetClientDvar( "r_filmUseTweaks", 0 );
    self SetClientDvar( "r_bloomTweaks", 0 );
    self SetClientDvar( "r_exposureTweak", 0 );
	self SetClientDvar( "vc_rgbh", "0 0 0 0" );
	self SetClientDvar( "vc_yl", "0 0 0 0" );
	self SetClientDvar( "vc_yh", "0 0 0 0" );
	self SetClientDvar( "vc_rgbl", "0 0 0 0" );
	self SetClientDvar( "r_exposureValue", int( level.default_r_exposureValue ) );
	self SetClientDvar( "r_lightTweakSunLight", int( level.default_r_lightTweakSunLight ) );
	self SetClientDvar( "r_sky_intensity_factor0", int( level.default_r_sky_intensity_factor0 ) );
}

visual_fix()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "disable_nightmode" );
	if( level.script == "zm_buried" )
	{
		while( getDvar( "r_sky_intensity_factor0" ) != 0 )
		{	
			self SetClientDvar( "r_lightTweakSunLight", 1 );
			self SetClientDvar( "r_sky_intensity_factor0", 0 );
			wait 0.05;
		}
	}
	else if( level.script == "zm_prison" || level.script == "zm_tomb" )
	{
		while( getDvar( "r_lightTweakSunLight" ) != 0 )
		{
			for( i = getDvar( "r_lightTweakSunLight" ); i >= 0; i = ( i - 0.05 ) )
			{
				self SetClientDvar( "r_lightTweakSunLight", i );
				wait 0.05;
			}
			wait 0.05;
		}
	}
	else return;
}
fog()
{
	self endon("disconnect");
	wait 0.5;
	if (self.fog == 0)
	{
		self.fog++;
		self SetClientDvar("r_fog", "0");
		self SetClientDvar("scr_fog_disable", "1");
		self SetClientDvar("r_fog_disable", "1");
		self SetClientDvar("r_fogSunOpacity", "0");
	}
	else if (self.fog == 1)
	{
		self.fog--;
		self SetClientDvar("r_fog", "1");
		self SetClientDvar("scr_fog_disable", "0");
		self SetClientDvar("r_fog_disable", "0");
		self SetClientDvar("r_fogSunOpacity", "1");
	}
}


toggle_fog_saved()
{
	self endon("disconnect");
	wait 0.3;
	
	
	self.fog = 1;
	self.fog_enabled = true; 
	self SetClientDvar("r_fog", "0");
	self SetClientDvar("scr_fog_disable", "1");
	self SetClientDvar("r_fog_disable", "1");
	self SetClientDvar("r_fogSunOpacity", "0");
}
onPlayerSay()
{
    level endon("end_game");
    prefix = "#";
    for (;;)
    {
        level waittill("say", message, player);
        message = toLower(message);
        guild_name = player getGuid();
        if (!level.intermission && message[0] == prefix)
        {
            args = strtok(message, " ");
            command = getSubStr(args[0], 1);
            switch (command)
            {
            case "valuenight":
            case "vanight":
                if (isDefined(args[1]))
                {
                    if(player.nightfix == 0)
                    {
                        player iPrintln("Execute the command #night on");
                    }
                    else{
                        i = Float(args[1]);
                        if(i >= 4.5 && i <= 10)
                        {
                            player iPrintln("The darkness has been adjusted " + i );
                            player setclientdvar("r_exposureValue", i);
                        }
                        else
                        {
                            player iPrintln("The valid configuration is from 4.5 to 10");
                        }
                    }
                }
                break;
            case "filter":
                if(isDefined(args[1]))
                {
                    if(player.nightfix > 0 && player.nightfix <= 1)
                    {
                        i = int(args[1]);
                        if(i >=0 && i <= 35)
                        {
                            player thread night_mode_toggle(i);
                        }
                        else
                        {
                            player iPrintln("Available filters from 0 to 35");
                        }
                    }
                }
                break;
            case "night":
                if(isDefined(args[1]))
                {
                    if(args[1] == "d" || args[1] == "disable")
                    {
                        player thread disable_night_mode();
                        self.nightfix = 2;
                    }
                    else if(args[1] == "on")
                    {

                        self.nightfix = 0;
                        i = 0;
                        player thread night_mode_toggle(i);
                        self iPrintln("Night mode activated");
                    }
                }
                break;
            case "fog":
                player thread fog();
                break;
            case "command":
                player thread helpcommand();
                break;

            }
        }
    }
}
helpcommand()
{
    if(self.definido_comandos == 1)
    {
        self iPrintln("Wait for the commands to finish displaying");
    }
    else if(self.definido_comandos == 0)
    {
        
        self.definido_comandos = 1;
        
        hud = create_simple_hud_element();hud.x = 0.1;hud.y = 0.1; hud.fontScale = 1; 

        hud setText("^7Help command\n^3#^4night on ^7<-Active Night mode, default filter ^20\n^3#^4night d or disable ^7<- disable night\n^3#^4filter ^20^7 to ^235 ^7<- active filter\n^3#^4vanight ^7or ^3#^4valuenight ^24.5 ^7or ^210 ^7<-adjust dvar night");
        wait(10); 
        hud setText("^3#^4fog ^7<-desactive or active fog\n^3#^4bar top ^7<-Active bar health top\n^3#^4bar left ^7<-Active bar health left\n^3#^4bar off ^7<-desactive bar health");
        wait(10);
        hud destroy();
        self.definido_comandos = 0;
    } 

}

create_simple_hud_element()
{
    hudElem = newclienthudelem(self);
    hudElem.elemtype = "icon";
    hudElem.font = "default";
    hudElem.fontscale = 1;
    
    hudElem.alpha = 1;
    hudElem.alignx = "left";
    hudElem.aligny = "top";
    hudElem.hidewheninmenu = false;
    return hudElem;
}
