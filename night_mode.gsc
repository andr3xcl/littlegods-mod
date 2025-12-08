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
    level thread rotate_skydome();
    level thread change_skydome();
    level thread daynightcycle();
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
    if (isDefined(self.defaults_saved))
        return;

    self.defaults_saved = true;
    wait 0.5; 
    
    
    if (!isDefined(level.default_r_exposureValue)) level.default_r_exposureValue = getDvar("r_exposureValue");
    if (!isDefined(level.default_r_lightTweakSunLight)) level.default_r_lightTweakSunLight = getDvar("r_lightTweakSunLight");
    if (!isDefined(level.default_r_sky_intensity_factor0)) level.default_r_sky_intensity_factor0 = getDvar("r_sky_intensity_factor0");
    if (!isDefined(level.default_r_skyColorTemp)) level.default_r_skyColorTemp = getDvar("r_skyColorTemp");
    if (!isDefined(level.default_r_skyRotation)) level.default_r_skyRotation = getDvar("r_skyRotation");
    if (!isDefined(level.default_r_skyTransition)) level.default_r_skyTransition = getDvar("r_skyTransition");
    if (!isDefined(level.default_r_lighttweaksuncolor)) level.default_r_lighttweaksuncolor = getDvar("r_lighttweaksuncolor");
    if (!isDefined(level.default_r_lodScaleRigid)) level.default_r_lodScaleRigid = getDvar("r_lodScaleRigid");
    if (!isDefined(level.default_r_lodScaleSkinned)) level.default_r_lodScaleSkinned = getDvar("r_lodScaleSkinned");
    if (!isDefined(level.default_r_enablePlayerShadow)) level.default_r_enablePlayerShadow = getDvar("r_enablePlayerShadow");
    if (!isDefined(level.default_r_lightTweakSunDirection)) level.default_r_lightTweakSunDirection = getDvar("r_lightTweakSunDirection");
    if (!isDefined(level.default_wind_global_vector)) level.default_wind_global_vector = getDvar("wind_global_vector");
    if (!isDefined(level.default_sm_sunquality)) level.default_sm_sunquality = getDvar("sm_sunquality");
    if (!isDefined(level.default_r_dof_enable)) level.default_r_dof_enable = getDvar("r_dof_enable");
    if (!isDefined(level.default_r_lodBiasRigid)) level.default_r_lodBiasRigid = getDvar("r_lodBiasRigid");
    if (!isDefined(level.default_r_lodBiasSkinned)) level.default_r_lodBiasSkinned = getDvar("r_lodBiasSkinned");
    if (!isDefined(level.default_r_bloomScale)) level.default_r_bloomScale = getDvar("r_bloomScale");
    if (!isDefined(level.default_r_bloomThreshold)) level.default_r_bloomThreshold = getDvar("r_bloomThreshold");
}


reset_night_mode_on_end()
{
    self waittill( "disconnect" );
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
    
    
    if (isDefined(level.default_r_exposureValue)) self apply_night_vision_exposure(level.default_r_exposureValue);
    else self apply_night_vision_exposure(0);
    
    if (isDefined(level.default_r_lightTweakSunLight)) self SetClientDvar("r_lightTweakSunLight", level.default_r_lightTweakSunLight);
    if (isDefined(level.default_r_sky_intensity_factor0)) self SetClientDvar("r_sky_intensity_factor0", level.default_r_sky_intensity_factor0);
    if (isDefined(level.default_r_skyColorTemp)) self SetClientDvar("r_skyColorTemp", level.default_r_skyColorTemp);
    if (isDefined(level.default_r_skyRotation)) self SetClientDvar("r_skyRotation", level.default_r_skyRotation);
    if (isDefined(level.default_r_skyTransition)) self SetClientDvar("r_skyTransition", level.default_r_skyTransition);
    if (isDefined(level.default_r_lighttweaksuncolor)) self SetClientDvar("r_lighttweaksuncolor", level.default_r_lighttweaksuncolor);
    if (isDefined(level.default_r_lodScaleRigid)) self SetClientDvar("r_lodScaleRigid", level.default_r_lodScaleRigid);
    if (isDefined(level.default_r_lodScaleSkinned)) self SetClientDvar("r_lodScaleSkinned", level.default_r_lodScaleSkinned);
    if (isDefined(level.default_r_enablePlayerShadow)) self SetClientDvar("r_enablePlayerShadow", level.default_r_enablePlayerShadow);
    if (isDefined(level.default_r_lightTweakSunDirection)) self SetClientDvar("r_lightTweakSunDirection", level.default_r_lightTweakSunDirection);
    if (isDefined(level.default_wind_global_vector)) self SetClientDvar("wind_global_vector", level.default_wind_global_vector);
    if (isDefined(level.default_sm_sunquality)) self SetClientDvar("sm_sunquality", level.default_sm_sunquality);
    if (isDefined(level.default_r_dof_enable)) self SetClientDvar("r_dof_enable", level.default_r_dof_enable);
    if (isDefined(level.default_r_lodBiasRigid)) self SetClientDvar("r_lodBiasRigid", level.default_r_lodBiasRigid);
    if (isDefined(level.default_r_lodBiasSkinned)) self SetClientDvar("r_lodBiasSkinned", level.default_r_lodBiasSkinned);
    if (isDefined(level.default_r_bloomScale)) self SetClientDvar("r_bloomScale", level.default_r_bloomScale);
    if (isDefined(level.default_r_bloomThreshold)) self SetClientDvar("r_bloomThreshold", level.default_r_bloomThreshold);

    
    self SetClientDvar( "vc_fgm", "1 1 1 1" );
    self SetClientDvar( "vc_fbm", "0 0 0 0" );
    self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar( "vc_yh", "0 0 0 0" );
    self SetClientDvar( "vc_yl", "0 0 0 0" );
    self SetClientDvar( "vc_rgbh", "0 0 0 0" );
    self SetClientDvar( "vc_rgbl", "0 0 0 0" );

    
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
    self endon("disconnect");
    self notify("disable_nightmode");
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
        self setclientdvar( "r_skyRotation", 1 );
		self setclientdvar( "r_skyTransition", 0 );
		self apply_night_vision_exposure(4.8);
		self setclientdvar( "r_skyColorTemp", 85000 );
		self setclientdvar( "r_sky_intensity_factor0", 4 );
		self setclientdvar( "r_lighttweaksunlight", 30 );
		self setclientdvar( "r_lighttweaksuncolor", "0.1 0.07 0.2" );
    }
    else if (level.script == "zm_tomb")
    {
        self setclientdvar( "r_skyRotation", 0 );
		self setclientdvar( "r_skyTransition", 0 );
		self apply_night_vision_exposure(5.2);
		self setclientdvar( "r_sky_intensity_factor0", 5 );
		self setclientdvar( "r_lighttweaksunlight", 20 );
		self setClientDvar( "r_bloomtweaks", 1 );
		self setclientdvar( "r_lighttweaksuncolor", "0.002 0.07 0.1" );
    }
    else if (level.script == "zm_nuked")
    {
        self setclientdvar( "r_skyTransition", 0 );
		self setclientdvar( "r_skyRotation", 0 );
		self apply_night_vision_exposure(6.4);
		self setclientdvar( "r_skyColorTemp", 25000 );
		self setclientdvar( "r_sky_intensity_factor0", 1 );
		self setclientdvar( "r_lighttweaksunlight", 42 );
		self setclientdvar( "r_lighttweaksuncolor", "0.2 0.2 0.5" );
        self setClientDvar( "r_bloomtweaks", 1 );
    }
    else if (level.script == "zm_highrise")
    {
        self setclientdvar( "r_skyRotation", 1 );
		self setclientdvar( "r_skyTransition", 0 );
		self apply_night_vision_exposure(6.1);
		self setclientdvar( "r_skyColorTemp", 85000 );
		self setclientdvar( "r_sky_intensity_factor0", 2.6 );
		self setclientdvar( "r_lighttweaksunlight", 30 );
		self setclientdvar( "r_lighttweaksuncolor", "0.1 0.07 0.2" );
    }
	else if (level.script == "zm_transit")
    {
        self apply_night_vision_exposure(5);
    }
	else if (level.script == "zm_prison")
    {
		self setClientDvar("r_lodScaleRigid", 1);
		self setClientDvar("r_lodScaleSkinned", 1);
		self setclientdvar("r_enablePlayerShadow", 1);
		self setclientdvar("r_filmUseTweaks", 1);
		self setclientdvar("r_exposureTweak", 1);
		self setclientdvar("r_lightTweakSunLight", 15);
		self setclientdvar("r_sky_intensity_factor0", 2);
		self setclientdvar("r_lightTweakSunDirection", (250, 200, 10));
		self setclientdvar("wind_global_vector", (300, 220, 100));
		self setclientdvar("sm_sunquality", 2);

		self setclientdvar("r_skyRotation", 0);
		self setclientdvar("r_skyTransition", 0);
		self apply_night_vision_exposure(5.7);
		self setclientdvar("r_skyColorTemp", 25000);
		self setclientdvar("r_sky_intensity_factor0", 2);
		self setclientdvar("r_lighttweaksunlight", 15);
		self setClientDvar("r_bloomtweaks", 1);
		self setclientdvar("r_lighttweaksuncolor", "0.1 0.2 2.5");
    }
}


enable_dark_mode()
{
	self endon("disconnect");
    set_common_dvars();
	
	self setClientDvar("r_lodScaleRigid", 1);
	self setClientDvar("r_lodScaleSkinned", 1);
	self setclientdvar("r_enablePlayerShadow", 1);
	self setclientdvar( "r_filmUseTweaks", 1 );
	self setclientdvar( "r_bloomTweaks", 1 );
	self setclientdvar( "r_exposureTweak", 1 );
    
    
    self SetClientDvar( "vc_fgm", "1 1 1 1" );
    self SetClientDvar( "vc_fbm", "0 0 0 0" );
    self SetClientDvar( "vc_fsm", "1 1 1 1" );
    self SetClientDvar( "vc_yh", "0 0 0 0" );
    self SetClientDvar( "vc_yl", "0 0 0 0" );
    self SetClientDvar( "vc_rgbh", "0 0 0 0" );
    self SetClientDvar( "vc_rgbl", "0 0 0 0" );

	self apply_night_vision_exposure( 3.5 );
	self setclientdvar( "r_lightTweakSunLight", 15 ); 
	self setclientdvar( "r_sky_intensity_factor0", 3 ); 
    self setclientdvar( "r_lightTweakSunDirection", ( 300, 250, 12 ) );
    self setclientdvar( "wind_global_vector", ( 300, 220, 100 ) );
    self setclientdvar( "sm_sunquality", 2 );
	
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
    self apply_night_vision_exposure(4.0);
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
    self apply_night_vision_exposure(2.0);
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
    self apply_night_vision_exposure(3.0);
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
    self apply_night_vision_exposure(2.5);
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
    self apply_night_vision_exposure(1.5 );
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
    self apply_night_vision_exposure(1.5);
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
    self apply_night_vision_exposure(1.8);
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
    self apply_night_vision_exposure(2.0);
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
    self apply_night_vision_exposure(2.5);
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
    self apply_night_vision_exposure(2.2);
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
    self apply_night_vision_exposure(3.0);
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
    self apply_night_vision_exposure(2.0);
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
    self apply_night_vision_exposure(1.8);
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
    self apply_night_vision_exposure(2.5);
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
    self apply_night_vision_exposure(2.0);
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
    self apply_night_vision_exposure(2.0);
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
    self apply_night_vision_exposure(1.8);
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
    self apply_night_vision_exposure(2.5);
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
    self apply_night_vision_exposure(2.8);
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
    self apply_night_vision_exposure(2.2);
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

    self apply_night_vision_exposure(3.2);
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

    self apply_night_vision_exposure(1.5);
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

    self apply_night_vision_exposure(2.8);
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

    self apply_night_vision_exposure(1.8);
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

    self apply_night_vision_exposure(3.5);
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

    self apply_night_vision_exposure(2.0);
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

    self apply_night_vision_exposure(1.2);
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

    self apply_night_vision_exposure(3.0);
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

    self apply_night_vision_exposure(2.5);
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

    self apply_night_vision_exposure(1.7);
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

    self apply_night_vision_exposure(1.9);
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

    self apply_night_vision_exposure(2.7);
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

    self apply_night_vision_exposure(2.3);
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

    self apply_night_vision_exposure(2.8);
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

    self apply_night_vision_exposure(2.4);
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
    self reset_all_night_mode_dvars();
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
                            player.night_mode_darkness = i;
                            player apply_night_vision_exposure( i );
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

apply_night_vision_exposure(value)
{
    if (isDefined(self.night_mode_darkness) && self.night_mode_darkness >= 4.5)
    {
        self SetClientDvar("r_exposureValue", self.night_mode_darkness);
    }
    else
    {
        self SetClientDvar("r_exposureValue", value);
    }
}

rotate_skydome()
{
    
    if (level.script == "zm_tomb" || level.script == "zm_prison")
        return;

    angle = 360;

    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        
        angle = angle - 0.025;

        
        if (angle <= 0)
        {
            
            angle = 360 + angle;
        }

        self setclientdvar("r_skyRotation", angle);
        wait 0.1;
    }
}


change_skydome()
{
    
    tempValue = 6500;

    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        
        tempValue = tempValue + 1.626;

        
        if (tempValue >= 25000)
        {
            tempValue = tempValue - 23350;
        }

        self setclientdvar("r_skyColorTemp", tempValue);
        wait 0.1;
    }
}


daynightcycle()
{
    level endon("game_ended");
    self endon("disconnect");

    
    if (!(level.script == "zm_buried" || level.script == "zm_highrise"))
        return;

    
    baseExp = 3;
    baseBleed = 3;
    baseLight = 20;

    currentExp = baseExp;
    currentBleed = baseBleed;
    currentLight = baseLight;

    nightExpMax = 5.723;
    nightLightMax = 30;
    nightBleedMax = 5.7;

    dayExpMin = 3.85;
    dayLightMin = 15;
    dayBleedMin = 3;

    for(;;)
    {
        flag_wait("power_on");

        foreach(p in getplayers())
        {
            
            idxNight = randomintrange(1, 48);

            if (currentBleed == dayBleedMin && currentLight == dayLightMin && currentExp == dayExpMin && idxNight == 24)
            {
                for(;;)
                {
                    currentBleed += 0.08;
                    currentLight += 0.08;
                    currentExp += 0.05;

                    if (currentExp > nightExpMax) currentExp = nightExpMax;
                    if (currentLight > nightLightMax) currentLight = nightLightMax;
                    if (currentBleed > nightBleedMax) currentBleed = nightBleedMax;

                    p apply_night_vision_exposure(currentExp);
                    p setclientdvar("r_lightTweakSunLight", currentLight);
                    p setclientdvar("r_sky_intensity_factor0", currentBleed);

                    if (currentExp == nightExpMax && currentLight == nightLightMax && currentBleed == nightBleedMax)
                    {
                        for(i = 2; i <= 8; i++)
                        {
                            p setclientdvar("vc_yl", "0 0 0." + i + " 0");
                            wait 0.15;
                        }
                        break;
                    }
                    wait 0.005;
                }
            }

            
            idxDay = randomintrange(1, 24);

            if (currentBleed == nightBleedMax && currentLight == nightLightMax && currentExp == nightExpMax && idxDay == 12)
            {
                for(;;)
                {
                    currentBleed -= 0.1;
                    currentLight -= 0.1;
                    currentExp -= 0.05;

                    if (currentExp < dayExpMin) currentExp = dayExpMin;
                    if (currentLight < dayLightMin) currentLight = dayLightMin;
                    if (currentBleed < dayBleedMin) currentBleed = dayBleedMin;

                    p apply_night_vision_exposure(currentExp);
                    p setclientdvar("r_lightTweakSunLight", currentLight);
                    p setclientdvar("r_sky_intensity_factor0", currentBleed);

                    if (currentExp == dayExpMin && currentLight == dayLightMin && currentBleed == dayBleedMin)
                    {
                        for(j = 8; j >= 1; j--)
                        {
                            p setclientdvar("vc_yl", "0 0 0." + j + " 0");
                            wait 0.2;
                        }
                        break;
                    }

                    wait 0.005;
                }
            }
        }

        wait 13;
    }
}

