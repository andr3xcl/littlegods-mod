#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include scripts\zm\sqllocal;
#include scripts\zm\map_location;

/**
 * LittleGods Player Health Bar V2 (without zombie bar)
 */
init()
{
    level thread on_player_connect();
    
    foreach(player in level.players)
    {
        if(isDefined(player) && isPlayer(player))
            player thread start_clean_health_bar();
    }
}

on_player_connect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread start_clean_health_bar();
    }
}

start_clean_health_bar()
{
    self endon("disconnect");
    self notify("stop_health_bar");
    self endon("stop_health_bar");
    flag_wait("initial_blackscreen_passed");
    
    // 1. Cleanup all previous HUD elements
    if(isDefined(self.hb_bar)) self.hb_bar destroyelem();
    if(isDefined(self.health_bar)) self.health_bar destroyelem();
    
    if(isDefined(self.hb_text_top)) self.hb_text_top destroy();
    if(isDefined(self.hb_text_bottom)) self.hb_text_bottom destroy();
    if(isDefined(self.health_info_text)) self.health_info_text destroy();
    if(isDefined(self.player_info_text)) self.player_info_text destroy();
    if(isDefined(self.health_current_label)) self.health_current_label destroy();
    if(isDefined(self.health_max_label)) self.health_max_label destroy();
    if(isDefined(self.zombies_label)) self.zombies_label destroy();

    if(isDefined(self.barframe)) self.barframe destroy();
    if(isDefined(self.background)) self.background destroy();
    if(isDefined(self.bg)) self.bg destroy();

    // 1.5 Setup dynamic layout variables
    pos = "right";
    if (isDefined(self.healthbar_position))
        pos = self.healthbar_position;

    // Default: RIGHT (Bottom-Right of screen)
    alignX = "right";
    alignY = "bottom";
    horzAlign = "right";
    vertAlign = "bottom";
    
    bar_x = -20;
    bar_y = -123;
    
    top_text_x = -20;
    top_text_y = -130;
    
    bottom_text_x = -20;
    bottom_text_y = -110;
    
    if (pos == "left")
    {
        alignX = "left";
        alignY = "bottom";
        horzAlign = "left";
        vertAlign = "bottom";
        
        bar_x = 20;
        bar_y = -123;
        
        top_text_x = 20;
        top_text_y = -130;
        
        bottom_text_x = 20;
        bottom_text_y = -110;
    }
    else if (pos == "top")
    {
        alignX = "center";
        alignY = "top";
        horzAlign = "center";
        vertAlign = "top";
        
        bar_x = 0;
        bar_y = 35;
        
        top_text_x = 0;
        top_text_y = 20;
        
        bottom_text_x = 0;
        bottom_text_y = 45;
    }
    else if (pos == "top_left")
    {
        alignX = "left";
        alignY = "top";
        horzAlign = "left";
        vertAlign = "top";
        
        bar_x = 20;
        bar_y = 35;
        
        top_text_x = 20;
        top_text_y = 20;
        
        bottom_text_x = 20;
        bottom_text_y = 45;
    }

    bar_width = 100;
    if (isDefined(self.healthbar_width))
        bar_width = self.healthbar_width;

    bar_height = 4;
    if (isDefined(self.healthbar_height))
        bar_height = self.healthbar_height;

    font_scale = 1.2;
    if (isDefined(self.healthbar_font_scale))
        font_scale = self.healthbar_font_scale;

    shader_alpha = 0;
    if (isDefined(self.healthbar_shader) && self.healthbar_shader)
        shader_alpha = 0.5;

    // 2. Create Progress Bar
    self.hb_bar = self createprimaryprogressbar();
    self.hb_bar.width = bar_width;
    self.hb_bar.height = bar_height;
    
    self.hb_bar.alignX = alignX;
    self.hb_bar.alignY = alignY;
    self.hb_bar.horzAlign = horzAlign;
    self.hb_bar.vertAlign = vertAlign;
    self.hb_bar.x = bar_x;
    self.hb_bar.y = bar_y;
    
    self.hb_bar.bar.alignX = alignX;
    self.hb_bar.bar.alignY = alignY;
    self.hb_bar.bar.horzAlign = horzAlign;
    self.hb_bar.bar.vertAlign = vertAlign;
    self.hb_bar.bar.x = bar_x;
    self.hb_bar.bar.y = bar_y;
    
    if(isDefined(self.hb_bar.barframe))
        self.hb_bar.barframe.alpha = shader_alpha;
    
    if(isDefined(self.hb_bar.bg))
        self.hb_bar.bg.alpha = shader_alpha;

    if(isDefined(self.hb_bar.background))
        self.hb_bar.background.alpha = shader_alpha;
    
    // 3. Create Top Text (Name | Location)
    self.hb_text_top = self createfontstring("Objective", font_scale);
    self.hb_text_top.alignX = alignX;
    self.hb_text_top.alignY = alignY;
    self.hb_text_top.horzAlign = horzAlign;
    self.hb_text_top.vertAlign = vertAlign;
    self.hb_text_top.x = top_text_x;
    self.hb_text_top.y = top_text_y;
    
    // 4. Create Bottom Text (Zombies | Bank | HP)
    self.hb_text_bottom = self createfontstring("Objective", font_scale);
    self.hb_text_bottom.alignX = alignX;
    self.hb_text_bottom.alignY = alignY;
    self.hb_text_bottom.horzAlign = horzAlign;
    self.hb_text_bottom.vertAlign = vertAlign;
    self.hb_text_bottom.x = bottom_text_x;
    self.hb_text_bottom.y = bottom_text_y;
    
    // Global HUD settings
    self.hb_bar.hidewheninmenu = true;
    self.hb_text_top.hidewheninmenu = true;
    self.hb_text_bottom.hidewheninmenu = true;
    self.hb_bar.hidewheninscope = true;
    
    self.hb_bar.alpha = 0;

    while(true)
    {
        // Safety check for Afterlife (Mob of the Dead)
        if (isdefined(self.e_afterlife_corpse))
        {
            self.hb_bar.bar.alpha = 0;
            self.hb_text_top.alpha = 0;
            self.hb_text_bottom.alpha = 0;
            wait 0.1;
            continue;
        }
        
        // Hide everything if the health bar is disabled from menu
        if (!isDefined(self.healthbar_enabled) || !self.healthbar_enabled)
        {
            self.hb_bar.bar.alpha = 0;
            self.hb_text_top.alpha = 0;
            self.hb_text_bottom.alpha = 0;
            wait 0.2;
            continue;
        }

        self.hb_bar.bar.alpha = 1;
        self.hb_text_top.alpha = 1;
        self.hb_text_bottom.alpha = 1;

        // --- Data Collection ---
        display_health = (isDefined(self.health) && isAlive(self)) ? self.health : 0;
        if(self maps\mp\zombies\_zm_laststand::player_is_in_laststand()) display_health = 0;
        
        zombie_count = 0;
        if(isDefined(get_round_enemy_array()))
            zombie_count = get_round_enemy_array().size + level.zombie_total;
            
        bank_balance = get_bank_balance(self);
        current_zone = self get_current_zone();
        zone_display = get_clean_zone_name(current_zone);
        
        // --- Update Progress Bar ---
        percent = display_health / self.maxhealth;
        if(percent > 1) percent = 1;
        if(percent < 0) percent = 0;
        
        self.hb_bar updatebar(percent);
        
        // Color Logic
        hp_color = (0, 1, 0.5); // Green-ish
        if(display_health <= 30) hp_color = (1, 0, 0); // Red
        else if(display_health <= 70) hp_color = (1, 1, 0); // Yellow
        
        self.hb_bar.bar.color = hp_color;
        
        // --- Update Texts ---
        top_str = self.name + " ^7| ^8" + zone_display;
        bottom_str = "^7Zombies ^1" + zombie_count + " ^7| ^3$^8" + bank_balance + " ^7| ^2" + display_health;
        
        self.hb_text_top setTextUnlimited(top_str);
        self.hb_text_bottom setTextUnlimited(bottom_str);
        
        wait 0.2;
    }
}

get_clean_zone_name(zone_id)
{
    if(!isDefined(zone_id) || zone_id == "") return "Unknown Area";
    
    name = scripts\zm\map_location::get_zone_display_name(zone_id);
    if(isDefined(name) && name != "") return name;
    
    return zone_id;
}

fetch_healthbar_config()
{
    self thread start_clean_health_bar();
}

restore_healthbar()
{
    self thread start_clean_health_bar();
}

bar_funtion_and_toogle(dummy)
{
    self thread start_clean_health_bar();
}