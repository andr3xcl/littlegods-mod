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
    level endon("end_game");
    level thread on_player_connect();
    level thread command_bar();
    
}
on_player_connect()
{
    self endon( "end_game" );

    for (;;)
    {
        level waittill( "connected", player );
        
        
    }
}
command_bar()
{
    level endon("end_game");
    prefix = "#";
    for (;;)
    {
        level waittill("say", message, player);
        message = toLower(message);
        if (!level.intermission && message[0] == prefix)
        {
            args = strtok(message, " ");
            command = getSubStr(args[0], 1);
            switch (command)
            {
                case "bar":
                if (isDefined(args[1]))
                    {
                    if (args[1] == "top")
                    {
                        functions = 1;
                        player.healthbar_enabled = true; 
                        player.healthbar_position = "top";
                        player thread bar_funtion_and_toogle(functions);
                    }
                    else if (args[1] == "left")
                    {
                        functions = 2;
                        player.healthbar_enabled = true; 
                        player.healthbar_position = "left";
                        player thread bar_funtion_and_toogle(functions);
                    }
                    else if (args[1] == "top_left" || args[1] == "topleft")
                    {
                        functions = 3;
                        player.healthbar_enabled = true; 
                        player.healthbar_position = "top_left";
                        player thread bar_funtion_and_toogle(functions);
                    }
                        else if (args[1] == "off")
                        {
                            functions = 100;
                            player.healthbar_enabled = false; 
                            player thread bar_funtion_and_toogle(functions);
                        }
                    }
                break;
            }
        }
    }
}

bar_funtion_and_toogle(functions)
{
    flag_wait("initial_blackscreen_passed");
    
    
    if(isDefined(self.health_bar))
        self.health_bar render_destroy_elem();

    if(isDefined(self.health_info_text))
        self.health_info_text render_destroy_elem();

    if(isDefined(self.player_info_text))
        self.player_info_text destroy();

    if(isDefined(self.health_current_label))
        self.health_current_label destroy();

    if(isDefined(self.health_max_label))
        self.health_max_label destroy();

    if(isDefined(self.zombies_label))
        self.zombies_label destroy();
        
    
    if(functions == 100)
        return;
    
    
    self.health_bar = self createprimaryprogressbar();
    self.health_info_text = self createFontString("Objective", 1);
    self.player_info_text = self createfontstring("Objective", 1);

    
    self.health_current_label = self createfontstring("Objective", 1);
    self.health_max_label = self createfontstring("Objective", 1);
    self.zombies_label = self createfontstring("Objective", 1);
    
    if(functions == 1) 
    {
        
        self.player_info_text setpoint("CENTER", 0, 0, -220);

        
        self.health_bar.width = 100;
        self.health_bar.height = 2;
        self.health_bar setpoint("CENTER", 0, "CENTER", -210);

        
        self.health_current_label setpoint("CENTER", 0, 0, -204);
        self.health_current_label.label = &"^7HP: ";
        self.health_current_label setvalue(self.health);
        self.health_current_label.x = self.health_bar.x - 35; 

        self.health_max_label setpoint("CENTER", 0, 0, -204);
        self.health_max_label.label = &" / ";
        self.health_max_label setvalue(self.maxhealth);
        self.health_max_label.x = self.health_current_label.x + 25; 

        self.zombies_label setpoint("CENTER", 0, 0, -204);
        self.zombies_label.label = &"^1 - Zombies: ";
        self.zombies_label setvalue(0); 
        self.zombies_label.x = self.health_max_label.x + 30; 

        
        self thread update_zombies();
        self thread bar_health_funtion();
    }
    else if(functions == 2) 
    {
        
        self.player_info_text setpoint("LEFT", "LEFT", 0, 82);

        
        self.health_bar.width = 100;
        self.health_bar.height = 2;
        self.health_bar setpoint("LEFT", "LEFT", 0, 90);

        
        self.health_current_label setpoint("LEFT", "LEFT", 0, 100);
        self.health_current_label.label = &"^7HP: ";
        self.health_current_label setvalue(self.health);

        self.health_max_label setpoint("LEFT", "LEFT", 35, 100);
        self.health_max_label.label = &" / ";
        self.health_max_label setvalue(self.maxhealth);

        self.zombies_label setpoint("LEFT", "LEFT", 65, 100);
        self.zombies_label.label = &"^1 - Zombies: ";
        self.zombies_label setvalue(0); 

        
        self thread bar_health_funtion();
        self thread update_zombies();
    }
    else if(functions == 3) 
    {
        
        self.player_info_text setPoint("TOPLEFT", "TOPLEFT", 10, 22);

        
        self.health_bar.width = 100;
        self.health_bar.height = 2;
        self.health_bar setPoint("TOPLEFT", "TOPLEFT", 10, 35);

        
        self.health_current_label setPoint("TOPLEFT", "TOPLEFT", 10, 40);
        self.health_current_label.label = &"^7HP: ";
        self.health_current_label setvalue(self.health);

        self.health_max_label setPoint("TOPLEFT", "TOPLEFT", 45, 40);
        self.health_max_label.label = &" / ";
        self.health_max_label setvalue(self.maxhealth);
        self.health_max_label.x = self.health_current_label.x + 25; 

        self.zombies_label setPoint("TOPLEFT", "TOPLEFT", 65, 40);
        self.zombies_label.label = &"^1 - Zombies: ";
        self.zombies_label.x = self.health_max_label.x + 30; 
        self.zombies_label setvalue(0); 

        
        self thread bar_health_funtion();
        self thread update_zombies();
    }
}

bar_health_funtion()
{
    level endon("end_game");
    self endon("endbar_health");
    self endon("disconnect");
    
    
    map = getDvar("ui_zm_mapstartlocation");
    map_name = "";
    
    switch (map)
    {
        case "tomb": map_name = "ORIGINS"; break;
        case "transit": map_name = "TRANSIT"; break;
        case "town": map_name = "TOWN"; break;
        case "farm": map_name = "FARM"; break;
        case "processing": map_name = "BURIED"; break;
        case "prison": map_name = "PRISON"; break;
        case "nuked": map_name = "NUKETOWN"; break;
        case "rooftop": map_name = "HIGHRISE"; break;
    }
    
    
    self.health_bar.hidewheninmenu = 1;
    self.health_info_text.hidewheninmenu = 1;
    self.player_info_text.hidewheninmenu = 1;
    self.health_current_label.hidewheninmenu = 1;
    self.health_max_label.hidewheninmenu = 1;
    self.zombies_label.hidewheninmenu = 1;

    
    if(isDefined(self.health_bar.barframe))
        self.health_bar.barframe.alpha = 0;

    self.health_bar.hidewheninscope = 1;
    self.health_info_text.hidewheninscope = 1;
    self.player_info_text.hidewheninscope = 1;
    self.health_current_label.hidewheninscope = 1;
    self.health_max_label.hidewheninscope = 1;
    self.zombies_label.hidewheninscope = 1;
    
    
    player_info = self.name + " | " + map_name;
    self.player_info_text setText(player_info);
    
    zombie_count = 0; 
    
    while (true)
    {
        
        if(isDefined(get_round_enemy_array()))
            zombie_count = get_round_enemy_array().size + level.zombie_total;
        
        if (isdefined(self.e_afterlife_corpse))
        {
            
            self.health_bar.bar.alpha = 0;
            
            self.health_bar.barframe.alpha = 0;
            self.health_current_label.alpha = 0;
            self.health_max_label.alpha = 0;
            self.zombies_label.alpha = 0;
            self.player_info_text.alpha = 0;

            wait 0.05;
            continue;
        }

        
        self.health_bar.alpha = 0;
        self.health_bar.bar.alpha = 1;
        
        self.health_bar.barframe.alpha = 0;
        self.health_current_label.alpha = 1;
        self.health_max_label.alpha = 1;
        self.zombies_label.alpha = 1;
        self.player_info_text.alpha = 1;

        
        health_percent = self.health / self.maxhealth;
        self.health_bar updatebar(health_percent);

        
        self.health_current_label setvalue(self.health);
        self.health_max_label setvalue(self.maxhealth);
        self.zombies_label setvalue(zombie_count);

        
        current_color = (0, 1, 0.5); 

        if(self.health <= self.maxhealth && self.health >= 71)
            current_color = (0, 1, 0.5); 
        else if(self.health <= 70 && self.health >= 50)
            current_color = (1, 1, 0); 
        else if(self.health <= 49 && self.health >= 25)
            current_color = (1, 0.5, 0); 
        else if(self.health <= 24 && self.health >= 0)
            current_color = (0.5, 0, 0); 

        
        self.health_current_label.color = current_color;
        self.health_max_label.color = current_color;
        self.health_bar.bar.color = current_color;
        
        wait 0.5;
    }
}

update_zombies()
{
    
    
    level endon("end_game");
    self endon("endbar_health");
    self endon("disconnect");
}

render_destroy_elem()
{
    foreach (child in self.children)
        child render_destroy_elem();

    self destroyelem();
}