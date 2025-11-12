



#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;





init()
{
    
    level.player_health_display = spawnStruct();
    level.zombie_health_display = spawnStruct();
    level.zombie_counter_display = spawnStruct();

    
    level.legacy_display_mode = "littlegods"; 

    
    level.player_health_display.enabled = false;
    level.player_health_display.x = 10;
    level.player_health_display.y = 50;
    level.player_health_display.fontscale = 1.1;
    level.player_health_display.color = (1, 1, 1); 
    level.player_health_display.alpha = 1.0;
    level.player_health_display.label = "Player Health: ";
    level.player_health_display.color_gradient_enabled = false; 

    
    level.zombie_health_display.enabled = false;
    level.zombie_health_display.x = 10;
    level.zombie_health_display.y = 60;
    level.zombie_health_display.fontscale = 1.1;
    level.zombie_health_display.color = (1, 1, 1); 
    level.zombie_health_display.alpha = 1.0;
    level.zombie_health_display.label = "Zombie Health: ";
    level.zombie_health_display.color_gradient_enabled = false; 

    
    level.zombie_counter_display.enabled = false;
    level.zombie_counter_display.x = 10;
    level.zombie_counter_display.y = 70;
    level.zombie_counter_display.fontscale = 1.1;
    level.zombie_counter_display.color = (1, 1, 1); 
    level.zombie_counter_display.alpha = 1.0;
    level.zombie_counter_display.label = "Zombies: ";
}






get_health_color_code(health_percentage)
{
    
    
    if (health_percentage >= 75)
        return &"^2"; 
    else if (health_percentage >= 50)
        return &"^3"; 
    else if (health_percentage >= 25)
        return &"^3"; 
    else
        return &"^1"; 
}


switch_legacy_display_mode(new_mode)
{
    if (new_mode != "littlegods" && new_mode != "classic")
        return;

    
    level.legacy_display_mode = new_mode;

    
    foreach(player in level.players)
    {
        if (isDefined(player.player_health_hud) && isDefined(player.player_health_value))
            update_player_health_position(player);

        if (isDefined(player.zombie_health_hud) && isDefined(player.zombie_health_value))
            update_zombie_health_position(player);

        if (isDefined(player.zombie_counter_hud) && isDefined(player.zombie_counter_value))
            update_zombie_counter_position(player);
    }
}


update_player_health_position(player)
{
    if (!isDefined(player.player_health_hud) || !isDefined(player.player_health_value))
        return;

    if (level.legacy_display_mode == "classic")
    {
        
        
        player.player_health_hud.x = 200; 
        player.player_health_hud.y = 375; 
        player.player_health_value.x = 255; 
        player.player_health_value.y = 375;
    }
    else
    {
        
        player.player_health_hud.x = level.player_health_display.x;
        player.player_health_hud.y = level.player_health_display.y;
        player.player_health_value.x = level.player_health_display.x + 60;
        player.player_health_value.y = level.player_health_display.y;
    }
}


update_zombie_health_position(player)
{
    if (!isDefined(player.zombie_health_hud) || !isDefined(player.zombie_health_value))
        return;

    if (level.legacy_display_mode == "classic")
    {
        
        
        player.zombie_health_hud.x = 365; 
        player.zombie_health_hud.y = 375; 
        player.zombie_health_value.x = 435; 
        player.zombie_health_value.y = 375;
    }
    else
    {
        
        player.zombie_health_hud.x = level.zombie_health_display.x;
        player.zombie_health_hud.y = level.zombie_health_display.y;
        player.zombie_health_value.x = level.zombie_health_display.x + 60;
        player.zombie_health_value.y = level.zombie_health_display.y;
    }
}


update_zombie_counter_position(player)
{
    if (!isDefined(player.zombie_counter_hud) || !isDefined(player.zombie_counter_value))
        return;

    if (level.legacy_display_mode == "classic")
    {
        
        
        player.zombie_counter_hud.x = 295; 
        player.zombie_counter_hud.y = 365; 
        player.zombie_counter_value.x = 334; 
        player.zombie_counter_value.y = 365;
    }
    else
    {
        
        player.zombie_counter_hud.x = level.zombie_counter_display.x;
        player.zombie_counter_hud.y = level.zombie_counter_display.y;
        player.zombie_counter_value.x = level.zombie_counter_display.x + 60;
        player.zombie_counter_value.y = level.zombie_counter_display.y;
    }
}






toggle_player_health_display(player)
{
    level.player_health_display.enabled = !level.player_health_display.enabled;

    if (level.player_health_display.enabled)
    {
        create_player_health_display(player);
        player thread update_player_health_display();
    }
    else
    {
        destroy_player_health_display(player);
    }
}


toggle_zombie_health_display(player)
{
    level.zombie_health_display.enabled = !level.zombie_health_display.enabled;

    if (level.zombie_health_display.enabled)
    {
        create_zombie_health_display(player);
        player thread update_zombie_health_display();
    }
    else
    {
        destroy_zombie_health_display(player);
    }
}


toggle_zombie_counter_display(player)
{
    level.zombie_counter_display.enabled = !level.zombie_counter_display.enabled;

    if (level.zombie_counter_display.enabled)
    {
        create_zombie_counter_display(player);
        player thread update_zombie_counter_display();
    }
    else
    {
        destroy_zombie_counter_display(player);
    }
}





create_player_health_display(player)
{
    if (!isDefined(player.player_health_hud))
    {
        
        player.player_health_hud = newClientHudElem(player);
        player.player_health_hud.x = level.player_health_display.x;
        player.player_health_hud.y = level.player_health_display.y;
        player.player_health_hud.fontscale = level.player_health_display.fontscale;
        player.player_health_hud.color = level.player_health_display.color;
        player.player_health_hud.alpha = level.player_health_display.alpha;
        player.player_health_hud setText(level.player_health_display.label);

        
        player.player_health_value = newClientHudElem(player);
        player.player_health_value.x = level.player_health_display.x + 60; 
        player.player_health_value.y = level.player_health_display.y;
        player.player_health_value.fontscale = level.player_health_display.fontscale;
        player.player_health_value.color = level.player_health_display.color;
        player.player_health_value.alpha = level.player_health_display.alpha;
        player.player_health_value.label = &"^2"; 
        player.player_health_value.current_label = &"^2"; 

        
        update_player_health_position(player);
    }
}

create_zombie_health_display(player)
{
    if (!isDefined(player.zombie_health_hud))
    {
        player.zombie_health_hud = newClientHudElem(player);
        player.zombie_health_hud.x = level.zombie_health_display.x;
        player.zombie_health_hud.y = level.zombie_health_display.y;
        player.zombie_health_hud.fontscale = level.zombie_health_display.fontscale;
        player.zombie_health_hud.color = level.zombie_health_display.color;
        player.zombie_health_hud.alpha = level.zombie_health_display.alpha;
        player.zombie_health_hud setText(level.zombie_health_display.label);

        player.zombie_health_value = newClientHudElem(player);
        player.zombie_health_value.x = level.zombie_health_display.x + 60;
        player.zombie_health_value.y = level.zombie_health_display.y;
        player.zombie_health_value.fontscale = level.zombie_health_display.fontscale;
        player.zombie_health_value.color = level.zombie_health_display.color;
        player.zombie_health_value.alpha = level.zombie_health_display.alpha;
        player.zombie_health_value.label = &"^5"; 
        player.zombie_health_value.current_label = &"^5"; 

        
        update_zombie_health_position(player);
    }
}

create_zombie_counter_display(player)
{
    if (!isDefined(player.zombie_counter_hud))
    {
        player.zombie_counter_hud = newClientHudElem(player);
        player.zombie_counter_hud.x = level.zombie_counter_display.x;
        player.zombie_counter_hud.y = level.zombie_counter_display.y;
        player.zombie_counter_hud.fontscale = level.zombie_counter_display.fontscale;
        player.zombie_counter_hud.color = level.zombie_counter_display.color;
        player.zombie_counter_hud.alpha = level.zombie_counter_display.alpha;
        player.zombie_counter_hud setText(level.zombie_counter_display.label);

        player.zombie_counter_value = newClientHudElem(player);
        player.zombie_counter_value.x = level.zombie_counter_display.x + 60;
        player.zombie_counter_value.y = level.zombie_counter_display.y;
        player.zombie_counter_value.fontscale = level.zombie_counter_display.fontscale;
        player.zombie_counter_value.color = level.zombie_counter_display.color;
        player.zombie_counter_value.alpha = level.zombie_counter_display.alpha;
        player.zombie_counter_value.label = &"^1";

        
        update_zombie_counter_position(player);
    }
}





destroy_player_health_display(player)
{
    if (isDefined(player.player_health_hud))
    {
        player.player_health_hud destroy();
        player.player_health_hud = undefined;
    }
    if (isDefined(player.player_health_value))
    {
        player.player_health_value destroy();
        player.player_health_value = undefined;
    }
}

destroy_zombie_health_display(player)
{
    if (isDefined(player.zombie_health_hud))
    {
        player.zombie_health_hud destroy();
        player.zombie_health_hud = undefined;
    }
    if (isDefined(player.zombie_health_value))
    {
        player.zombie_health_value destroy();
        player.zombie_health_value = undefined;
    }
}

destroy_zombie_counter_display(player)
{
    if (isDefined(player.zombie_counter_hud))
    {
        player.zombie_counter_hud destroy();
        player.zombie_counter_hud = undefined;
    }
    if (isDefined(player.zombie_counter_value))
    {
        player.zombie_counter_value destroy();
        player.zombie_counter_value = undefined;
    }
}





update_player_health_display()
{
    self endon("disconnect");
    self endon("player_health_display_disabled");

    while(level.player_health_display.enabled)
    {
        if (isDefined(self.player_health_value) && isPlayer(self))
        {
            current_health = self.health;
            max_health = self.maxhealth;

            
            if (level.player_health_display.color_gradient_enabled && max_health > 0)
            {
                
                health_percentage = (current_health / max_health) * 100;
                new_label = get_health_color_code(health_percentage);
            }
            else
            {
                
                new_label = get_health_color_code(100); 
            }

            
            if (!isDefined(self.player_health_value.current_label) || self.player_health_value.current_label != new_label)
            {
                
                if (isDefined(self.player_health_value))
                {
                    self.player_health_value destroy();
                }

                
                self.player_health_value = newClientHudElem(self);
                self.player_health_value.fontscale = level.player_health_display.fontscale;
                self.player_health_value.color = level.player_health_display.color;
                self.player_health_value.alpha = level.player_health_display.alpha;
                self.player_health_value.label = new_label;
                self.player_health_value.current_label = new_label;

                
                
                update_player_health_position(self);
            }

            
            self.player_health_value setValue(current_health);
        }

        wait 0.1; 
    }
}

update_zombie_health_display()
{
    self endon("disconnect");
    self endon("zombie_health_display_disabled");

    while(level.zombie_health_display.enabled)
    {
        if (isDefined(self.zombie_health_value))
        {
            
            closest_zombie = get_closest_zombie_to_player(self);

            if (isDefined(closest_zombie) && isAlive(closest_zombie))
            {
                zombie_health = closest_zombie.health;
                max_zombie_health = closest_zombie.maxhealth; 

                
                if (level.zombie_health_display.color_gradient_enabled && max_zombie_health > 0)
                {
                    
                    health_percentage = (zombie_health / max_zombie_health) * 100;
                    new_label = get_health_color_code(health_percentage);
                }
                else
                {
                    
                    new_label = &"^5";
                }

                
                if (!isDefined(self.zombie_health_value.current_label) || self.zombie_health_value.current_label != new_label)
                {
                    
                    if (isDefined(self.zombie_health_value))
                    {
                        self.zombie_health_value destroy();
                    }

                    
                    self.zombie_health_value = newClientHudElem(self);
                    self.zombie_health_value.fontscale = level.zombie_health_display.fontscale;
                    self.zombie_health_value.color = level.zombie_health_display.color;
                    self.zombie_health_value.alpha = level.zombie_health_display.alpha;
                    self.zombie_health_value.label = new_label;
                    self.zombie_health_value.current_label = new_label;

                    
                    
                    update_zombie_health_position(self);
                }

                self.zombie_health_value setValue(zombie_health);
            }
            else
            {
                
                if (level.zombie_health_display.color_gradient_enabled)
                {
                    new_label = get_health_color_code(0); 
                }
                else
                {
                    new_label = &"^5"; 
                }

                
                if (!isDefined(self.zombie_health_value.current_label) || self.zombie_health_value.current_label != new_label)
                {
                    
                    if (isDefined(self.zombie_health_value))
                    {
                        self.zombie_health_value destroy();
                    }

                    
                    self.zombie_health_value = newClientHudElem(self);
                    self.zombie_health_value.fontscale = level.zombie_health_display.fontscale;
                    self.zombie_health_value.color = level.zombie_health_display.color;
                    self.zombie_health_value.alpha = level.zombie_health_display.alpha;
                    self.zombie_health_value.label = new_label;
                    self.zombie_health_value.current_label = new_label;

                    
                    if (level.legacy_display_mode == "classic")
                    {
                        self.zombie_health_value.x = 100; 
                        self.zombie_health_value.y = 340;
                    }
                    else
                    {
                        self.zombie_health_value.x = level.zombie_health_display.x + 60;
                        self.zombie_health_value.y = level.zombie_health_display.y;
                    }
                }

                self.zombie_health_value setValue(0);
            }
        }

        wait 0.1;
    }
}

update_zombie_counter_display()
{
    self endon("disconnect");
    self endon("zombie_counter_display_disabled");

    while(level.zombie_counter_display.enabled)
    {
        if (isDefined(self.zombie_counter_value))
        {
            
            zombie_count = get_zombie_count();
            self.zombie_counter_value setValue(zombie_count);
        }

        wait 0.5; 
    }
}





get_closest_zombie_to_player(player)
{
    zombies = getAIArray("axis");

    if (!isDefined(zombies) || zombies.size == 0)
        return undefined;

    closest_zombie = undefined;
    closest_distance = 999999;

    foreach (zombie in zombies)
    {
        if (isDefined(zombie) && isAlive(zombie))
        {
            distance = distance(player.origin, zombie.origin);
            if (distance < closest_distance)
            {
                closest_distance = distance;
                closest_zombie = zombie;
            }
        }
    }

    return closest_zombie;
}

get_zombie_count()
{
    zombies = getAIArray("axis");
    count = 0;

    if (isDefined(zombies))
    {
        foreach (zombie in zombies)
        {
            if (isDefined(zombie) && isAlive(zombie))
                count++;
        }
    }

    return count;
}






set_player_health_position(x, y)
{
    level.player_health_display.x = x;
    level.player_health_display.y = y;

    
    foreach (player in level.players)
    {
        if (isDefined(player.player_health_hud))
        {
            player.player_health_hud.x = x;
            player.player_health_hud.y = y;
        }
        if (isDefined(player.player_health_value))
        {
            player.player_health_value.x = x + 120;
            player.player_health_value.y = y;
        }
    }
}


set_player_health_fontscale(scale)
{
    level.player_health_display.fontscale = scale;

    foreach (player in level.players)
    {
        if (isDefined(player.player_health_hud))
            player.player_health_hud.fontscale = scale;
        if (isDefined(player.player_health_value))
            player.player_health_value.fontscale = scale;
    }
}


set_player_health_color(color)
{
    level.player_health_display.color = color;

    foreach (player in level.players)
    {
        if (isDefined(player.player_health_hud))
            player.player_health_hud.color = color;
        if (isDefined(player.player_health_value))
            player.player_health_value.color = color;
    }
}








cleanup_all_displays()
{
    foreach (player in level.players)
    {
        destroy_player_health_display(player);
        destroy_zombie_health_display(player);
        destroy_zombie_counter_display(player);
    }
}


on_player_disconnect()
{
    self notify("player_health_display_disabled");
    self notify("zombie_health_display_disabled");
    self notify("zombie_counter_display_disabled");

    destroy_player_health_display(self);
    destroy_zombie_health_display(self);
    destroy_zombie_counter_display(self);
}
