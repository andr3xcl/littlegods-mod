#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm_hud_util;
#include maps\mp\zombies_zm;
#include maps\mp\zombies_zm_utility;
#include maps\mp\zombies_zm_weapons;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies_zm_stats;
#include maps\mp\gametypes_zm_hud_message;
#include maps\mp\zombies_zm_powerups;
#include maps\mp\zombies_zm_perks;
#include maps\mp\zombies_zm_audio;
#include maps\mp\zombies_zm_score;
#include maps\mp\gametypes_globallogic_spawn;
#include maps\mp\gametypes_spectating;
#include maps\mp_tacticalinsertion;
#include maps\mp_challenges;
#include maps\mp\gametypes_globallogic;
#include maps\mp\gametypes_globallogic_ui;
#include maps\mp\_utility;
#include maps\mp\gametypes_persistence;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\gametypes_zm\spawnlogic;
#include maps\mp\gametypes_zm\_hostmigration;


init()
{
    level thread onPlayerConnect();
}


onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}


onPlayerSpawned()
{
    self endon("disconnect");
    
    for(;;)
    {
        self waittill("spawned_player");
        
        
        if(!isDefined(self.godmode_enabled))
        {
            self.godmode_enabled = false;
        }
    }
}


toggle_godmode()
{
    
    if(isDefined(self.is_toggling_godmode))
    {
        wait 0.1;
        return;
    }
    
    self.is_toggling_godmode = true;
    
    
    self.godmode_enabled = !self.godmode_enabled;
    
    if(self.godmode_enabled)
    {
        
        self enableInvulnerability();
        
        
        if(self.langLEN == 0)
            self iPrintLnBold("^2God Mode ACTIVADO");
        else
            self iPrintLnBold("^2God Mode ENABLED");
            
        
        
    }
    else
    {
        
        self disableInvulnerability();
        
        
        if(self.langLEN == 0)
            self iPrintLnBold("^1God Mode DESACTIVADO");
        else
            self iPrintLnBold("^1God Mode DISABLED");
            
        
        self notify("godmode_off");
    }
    
    
    if(isDefined(self.menu_current))
    {
        for(i = 0; i < self.menu_current.items.size; i++)
        {
            if(self.menu_current.items[i].func == ::toggle_godmode)
            {
                status = self.godmode_enabled ? "ON" : "OFF";
                
                if(self.langLEN == 0)
                    self.menu_current.items[i].item setText("God Mode: " + status);
                else
                    self.menu_current.items[i].item setText("God Mode: " + status);
                    
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_godmode = undefined;
}


show_godmode_indicator()
{
    self endon("disconnect");
    self endon("godmode_off");
    
    
    indicator = newClientHudElem(self);
    indicator.alignX = "center";
    indicator.alignY = "bottom";
    indicator.horzAlign = "center";
    indicator.vertAlign = "bottom";
    indicator.x = 0;
    indicator.y = -50;
    indicator.fontScale = 1.2;
    indicator.color = (1, 0.8, 0);
    indicator.alpha = 0.8;
    indicator.hidewheninmenu = 1;
    
    
    if(self.langLEN == 0)
        indicator setText("^3GOD MODE ACTIVO");
    else
        indicator setText("^3GOD MODE ACTIVE");
    
    
    while(true)
    {
        
        for(i = 8; i > 3; i--)
        {
            indicator.alpha = i * 0.1;
            wait 0.1;
        }
        
        for(i = 3; i < 8; i++)
        {
            indicator.alpha = i * 0.1;
            wait 0.1;
        }
        
        wait 0.5;
    }
}


advance_round()
{
    
    if(isDefined(self.is_changing_round))
    {
        wait 0.1;
        return;
    }
    
    self.is_changing_round = true;
    
    
    if(!self.godmode_enabled)
    {
        
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^1Error: Necesitas God Mode para cambiar rondas");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Error: You need God Mode to change rounds");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_changing_round = undefined;
        return;
    }
    
    
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;
    
    
    if(self.target_round >= 255)
    {
        
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^3Ya estás en la ronda máxima (255)");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^3You're already at the maximum round (255)");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_changing_round = undefined;
        return;
    }
        
    
    self.target_round++;
    
    
    if(self.langLEN == 0)
        self iPrintLnBold("^5Ronda objetivo: ^3" + self.target_round + " ^7(Presiona Aplicar)");
    else
        self iPrintLnBold("^5Target round: ^3" + self.target_round + " ^7(Press Apply)");
    
    
    self update_round_menu_text();
    
    wait 0.2;
    self.is_changing_round = undefined;
}


go_back_round()
{
    
    if(isDefined(self.is_changing_round))
    {
        wait 0.1;
        return;
    }
    
    self.is_changing_round = true;
    
    
    if(!self.godmode_enabled)
    {
        
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^1Error: Necesitas God Mode para cambiar rondas");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Error: You need God Mode to change rounds");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_changing_round = undefined;
        return;
    }
    
    
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;
    
    
    if(self.target_round <= 1)
    {
        
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^3Ya estás en la ronda mínima");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^3You're already at the minimum round");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_changing_round = undefined;
        return;
    }
    
    
    self.target_round--;
    
    
    if(self.langLEN == 0)
        self iPrintLnBold("^5Ronda objetivo: ^3" + self.target_round + " ^7(Presiona Aplicar)");
    else
        self iPrintLnBold("^5Target round: ^3" + self.target_round + " ^7(Press Apply)");
    
    
    self update_round_menu_text();
    
    wait 0.2;
    self.is_changing_round = undefined;
}


set_round_255()
{
    
    if(isDefined(self.is_changing_round))
    {
        wait 0.1;
        return;
    }
    
    self.is_changing_round = true;
    
    
    if(!self.godmode_enabled)
    {
        
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^1Error: Necesitas God Mode para cambiar rondas");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Error: You need God Mode to change rounds");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_changing_round = undefined;
        return;
    }
    
    
    self.target_round = 255;
    
    
    if(self.langLEN == 0)
        self iPrintLnBold("^5Ronda objetivo: ^3255 ^7(Presiona Aplicar)");
    else
        self iPrintLnBold("^5Target round: ^3255 ^7(Press Apply)");
    
    
    self update_round_menu_text();
    
    wait 0.2;
    self.is_changing_round = undefined;
}


update_round_menu_text()
{
    if(isDefined(self.menu_current))
    {
        for(i = 0; i < self.menu_current.items.size; i++)
        {
            if(self.menu_current.items[i].func == ::apply_round_change)
            {
                
                if(self.langLEN == 0)
                    self.menu_current.items[i].item setText("Aplicar Ronda: " + self.target_round);
                else
                    self.menu_current.items[i].item setText("Apply Round: " + self.target_round);
                    
                break;
            }
        }
    }
}


apply_round_change()
{
    
    if(isDefined(self.is_applying_round))
    {
        wait 0.1;
        return;
    }
    
    self.is_applying_round = true;
    
    
    if(!self.godmode_enabled)
    {
        
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^1Error: Necesitas God Mode para cambiar rondas");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Error: You need God Mode to change rounds");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_applying_round = undefined;
        return;
    }
    
    
    if(!isDefined(self.target_round))
    {
        self.target_round = level.round_number;
        
        
        self update_round_menu_text();
        
        wait 0.2;
        self.is_applying_round = undefined;
        return;
    }
    
    
    if(self.target_round == level.round_number)
    {
        
        if(self.langLEN == 0)
            self iPrintLnBold("^3Ya estás en la ronda " + self.target_round);
        else
            self iPrintLnBold("^3You're already in round " + self.target_round);
            
        wait 0.2;
        self.is_applying_round = undefined;
        return;
    }
    
    
    if(self.langLEN == 0)
        self iPrintLnBold("^5Cambiando a ronda ^3" + self.target_round + "^5...");
    else
        self iPrintLnBold("^5Changing to round ^3" + self.target_round + "^5...");
        
    
    self thread zombiekill();
    level.round_number = self.target_round - 1; 
    
    
    if(self.langLEN == 0)
        self iPrintLnBold("^2¡Ronda cambiada a: ^5" + self.target_round + "^2!");
    else
        self iPrintLnBold("^2Round changed to: ^5" + self.target_round + "^2!");
    
    
    self playsound("zmb_round_change");
    
    
    self thread show_round_change_message(self.target_round);
    
    wait 0.5;
    self.is_applying_round = undefined;
}


zombiekill()
{
    self endon("end_game");
    zombs = getaiarray("axis");
    

    if(isDefined(zombs))
    {
        for(i = 0; i < zombs.size; i++)
        {
            zombs[i] dodamage(zombs[i].health * 5000, (0, 0, 0), self);
            wait 0.05;
        }

        if(isDefined(self.dopnuke))
            self dopnuke();
    }
}
dopnuke()
{
    self endon( "end_game" );

    foreach ( player in level.players )
    {
        level thread nuke_powerup( self, player.team );
        player powerup_vo( "nuke" );
        zombies = getaiarray( level.zombie_team );
        player.zombie_nuked = arraysort( zombies, self.origin );
        player notify( "nuke_triggered" );
    }
}

show_round_change_message(round_number)
{
    
    round_text = newClientHudElem(self);
    round_text.alignX = "center";
    round_text.alignY = "middle";
    round_text.horzAlign = "center";
    round_text.vertAlign = "middle";
    round_text.x = 0;
    round_text.y = -50;
    round_text.fontScale = 3.0;
    round_text.color = (1, 0.7, 0);
    round_text.alpha = 0;
    round_text.sort = 1001;
    round_text setText("^3RONDA " + round_number);
    
    
    round_text fadeOverTime(0.5);
    round_text.alpha = 1;
    wait 1.5;
    
    
    round_text fadeOverTime(0.5);
    round_text.alpha = 0;
    wait 0.5;
    
    
    round_text destroy();
} 

toggle_perk_unlimite(menu)
{
    self endon("disconnect");
    
    
    if (isDefined(self.is_toggling_perk_unlimite))
    {
        wait 0.1;
        return;
    }
    
    self.is_toggling_perk_unlimite = true;
    
    
    if (!isDefined(self.perk_unlimite_active))
        self.perk_unlimite_active = false;
    
    self.perk_unlimite_active = !self.perk_unlimite_active;
    
    
    self playLocalSound("uin_alert_closewindow");
    
    
    if (self.perk_unlimite_active)
    {
        
        level.is_unlimited_perks = true;
        level.perk_purchase_limit = 9;
        
        
        if (self.langLEN == 0) 
            self iPrintlnBold("^2Perk Unlimited: ^7Activado");
        else 
            self iPrintlnBold("^2Perk Unlimited: ^7Enabled");
    }
    else
    {
        
        level.is_unlimited_perks = false;
        level.perk_purchase_limit = 4;
        
        
        if (self.langLEN == 0) 
            self iPrintlnBold("^1Perk Unlimited: ^7Desactivado");
        else 
            self iPrintlnBold("^1Perk Unlimited: ^7Disabled");
    }
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (isDefined(self.menu_current.items[i].func) && self.menu_current.items[i].func == scripts\zm\funciones::toggle_perk_unlimite)
            {
                status = self.perk_unlimite_active ? "ON" : "OFF";
                self.menu_current.items[i].item setText("Perk Unlimited: " + status);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_perk_unlimite = undefined;
}
ThirdPerson()
{
    self endon("disconnect");
    
    
    if (isDefined(self.is_toggling_thirdperson))
    {
        wait 0.1;
        return;
    }
    
    self.is_toggling_thirdperson = true;
    
    
    if (!isDefined(self.TPP))
        self.TPP = false;
    
    
    self.TPP = !self.TPP;
    
    
    self playLocalSound("uin_alert_closewindow");
    
    
    if (self.TPP)
    {
        
        self setclientthirdperson(1);
        
        
        if (self.langLEN == 0) 
            self iPrintlnBold("^2Tercera Persona: ^7Activado");
        else 
            self iPrintlnBold("^2Third Person: ^7Enabled");
    }
    else
    {
        
        self setclientthirdperson(0);
        
        
        if (self.langLEN == 0) 
            self iPrintlnBold("^1Tercera Persona: ^7Desactivado");
        else 
            self iPrintlnBold("^1Third Person: ^7Disabled");
    }
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (isDefined(self.menu_current.items[i].func) && self.menu_current.items[i].func == scripts\zm\funciones::ThirdPerson)
            {
                status = self.TPP ? "ON" : "OFF";
                if (self.langLEN == 0) 
                    self.menu_current.items[i].item setText("Tercera Persona: " + status);
                else 
                    self.menu_current.items[i].item setText("Third Person: " + status);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_thirdperson = undefined;
}


apply_perk_unlimited_saved()
{
    self endon("disconnect");
    
    
    if (isDefined(self.perk_unlimite_active) && self.perk_unlimite_active)
    {
        
        level.is_unlimited_perks = true;
        level.perk_purchase_limit = 9;
        
        
        
    }
}


apply_third_person_saved()
{
    self endon("disconnect");
    
    
    if (isDefined(self.TPP) && self.TPP)
    {
        
        self setclientthirdperson(1);
        
        
        
    }
}


give_10k_points()
{
    self endon("disconnect");

    
    if (isDefined(self.is_giving_points))
    {
        wait 0.1;
        return;
    }

    self.is_giving_points = true;

    
    self maps\mp\zombies\_zm_score::add_to_player_score(10000);

    
    self playLocalSound("uin_alert_popup");

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2+10,000 ^7Puntos");
    else 
        self iPrintlnBold("^2+10,000 ^7Points");

    wait 0.5;
    self.is_giving_points = undefined;
}



toggle_speed()
{
    self endon("disconnect");

    
    if (isDefined(self.is_toggling_speed))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_speed = true;

    
    if (!isDefined(self.speed_boost_enabled))
        self.speed_boost_enabled = false;

    self.speed_boost_enabled = !self.speed_boost_enabled;

    if (self.speed_boost_enabled)
    {
        
        self setMoveSpeedScale(2.0);

        
        if (self.langLEN == 0) 
            self iPrintlnBold("^2Velocidad x2: ^7Activado");
        else 
            self iPrintlnBold("^2Speed x2: ^7Enabled");
    }
    else
    {
        
        self setMoveSpeedScale(1.0);

        
        if (self.langLEN == 0) 
            self iPrintlnBold("^1Velocidad x2: ^7Desactivado");
        else 
            self iPrintlnBold("^1Speed x2: ^7Disabled");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (isDefined(self.menu_current.items[i].func) && self.menu_current.items[i].func == ::toggle_speed)
            {
                status = self.speed_boost_enabled ? "ON" : "OFF";
                self.menu_current.items[i].item setText("Velocidad x2: " + status);
                break;
            }
        }
    }

    wait 0.2;
    self.is_toggling_speed = undefined;
}


init_teleport_system()
{
    if (!isDefined(self.saved_positions))
    {
        self.saved_positions = [];
        self.position_count = 0;
    }
}


save_position_with_name(name)
{
    self endon("disconnect");

    
    self init_teleport_system();

    
    if (!isDefined(name) || name == "" || name == " ")
    {
        if (self.langLEN == 0) 
            self iPrintlnBold("^1Debes especificar un nombre para la posición");
        else 
            self iPrintlnBold("^1You must specify a name for the position");

        self playLocalSound("menu_error");
        return;
    }

    
    for (i = 0; i < self.position_count; i++)
    {
        if (isDefined(self.saved_positions[i]) && self.saved_positions[i].name == name)
        {
            if (self.langLEN == 0) 
                self iPrintlnBold("^1Ya existe una posición con el nombre: ^5" + name);
            else 
                self iPrintlnBold("^1A position with name ^5" + name + " ^1already exists");

            self playLocalSound("menu_error");
            return;
        }
    }

    
    position_data = spawnStruct();
    position_data.name = name;
    position_data.origin = self.origin;
    position_data.angles = self getPlayerAngles();

    
    self.saved_positions[self.position_count] = position_data;
    self.position_count++;

    
    self playLocalSound("uin_alert_popup");

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2Posición ^5" + name + " ^2guardada");
    else 
        self iPrintlnBold("^2Position ^5" + name + " ^2saved");

    wait 0.1;
}


teleport_to_position(name)
{
    self endon("disconnect");

    
    self init_teleport_system();

    
    found = false;
    for (i = 0; i < self.position_count; i++)
    {
        if (isDefined(self.saved_positions[i]) && self.saved_positions[i].name == name)
        {
            
            self setOrigin(self.saved_positions[i].origin);
            self setPlayerAngles(self.saved_positions[i].angles);

            
            self playLocalSound("uin_positive_feedback");

            
            if (self.langLEN == 0) 
                self iPrintlnBold("^2Teleportado a ^5" + name);
            else 
                self iPrintlnBold("^2Teleported to ^5" + name);

            found = true;
            wait 0.1;
            break;
        }
    }

    if (!found)
    {
        if (self.langLEN == 0) 
            self iPrintlnBold("^1No se encontró la posición: ^5" + name);
        else 
            self iPrintlnBold("^1Position not found: ^5" + name);

        self playLocalSound("menu_error");
    }
}


delete_position(name)
{
    self endon("disconnect");

    
    self init_teleport_system();

    
    found = false;
    for (i = 0; i < self.position_count; i++)
    {
        if (isDefined(self.saved_positions[i]) && self.saved_positions[i].name == name)
        {
            
            for (j = i; j < self.position_count - 1; j++)
            {
                self.saved_positions[j] = self.saved_positions[j + 1];
            }
            self.saved_positions[self.position_count - 1] = undefined;
            self.position_count--;

            
            self playLocalSound("uin_alert_popup");

            
            if (self.langLEN == 0) 
                self iPrintlnBold("^1Posición ^5" + name + " ^1eliminada");
            else 
                self iPrintlnBold("^1Position ^5" + name + " ^1deleted");

            found = true;
            wait 0.1;
            break;
        }
    }

    if (!found)
    {
        if (self.langLEN == 0) 
            self iPrintlnBold("^1No se encontró la posición: ^5" + name);
        else 
            self iPrintlnBold("^1Position not found: ^5" + name);

        self playLocalSound("menu_error");
    }
}


list_saved_positions()
{
    self endon("disconnect");

    
    self init_teleport_system();

    if (self.position_count == 0)
    {
        if (self.langLEN == 0) 
            self iPrintlnBold("^1No hay posiciones guardadas");
        else 
            self iPrintlnBold("^1No saved positions");

        return;
    }

    if (self.langLEN == 0) 
        self iPrintlnBold("^5=== POSICIONES GUARDADAS ===");
    else 
        self iPrintlnBold("^5=== SAVED POSITIONS ===");

    wait 0.05;

    for (i = 0; i < self.position_count; i++)
    {
        if (isDefined(self.saved_positions[i]))
        {
            if (self.langLEN == 0) 
                self iPrintln("^3" + (i + 1) + ". ^5" + self.saved_positions[i].name);
            else 
                self iPrintln("^3" + (i + 1) + ". ^5" + self.saved_positions[i].name);

            wait 0.05;
        }
    }

    if (self.langLEN == 0) 
        self iPrintln("^7Escribe '^2tp [nombre]^7' para teleportarte");
    else 
        self iPrintln("^7Type '^2tp [name]^7' to teleport");

    wait 0.05;
}


save_position()
{
    
    timestamp = getTime();
    default_name = "Posicion_" + timestamp;
    self save_position_with_name(default_name);
}

teleport_to_saved()
{
    
    self init_teleport_system();

    if (self.position_count > 0 && isDefined(self.saved_positions[0]))
    {
        self setOrigin(self.saved_positions[0].origin);
        self setPlayerAngles(self.saved_positions[0].angles);

        self playLocalSound("uin_positive_feedback");

        if (self.langLEN == 0) 
            self iPrintlnBold("^2Teleportado a ^5" + self.saved_positions[0].name);
        else 
            self iPrintlnBold("^2Teleported to ^5" + self.saved_positions[0].name);
    }
    else
    {
        if (self.langLEN == 0) 
            self iPrintlnBold("^1No hay posiciones guardadas");
        else 
            self iPrintlnBold("^1No saved positions");

        self playLocalSound("menu_error");
    }
}




spawn_max_ammo()
{
    self endon("disconnect");

    
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("full_ammo", spawn_pos);

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2Powerup ^5Max Ammo ^2spawneado");
    else 
        self iPrintlnBold("^2Powerup ^5Max Ammo ^2spawned");

    
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}


spawn_insta_kill()
{
    self endon("disconnect");

    
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("insta_kill", spawn_pos);

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2Powerup ^5Insta Kill ^2spawneado");
    else 
        self iPrintlnBold("^2Powerup ^5Insta Kill ^2spawned");

    
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}


spawn_carpenter()
{
    self endon("disconnect");

    
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    
    powerup_names = [];
    powerup_names[0] = "carpenter";
    powerup_names[1] = "free_perk";
    powerup_names[2] = "bonus_points";
    spawned = false;

    for (i = 0; i < powerup_names.size; i++)
    {
        powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop(powerup_names[i], spawn_pos);
        if (isDefined(powerup))
        {
            spawned = true;
            break;
        }
        wait 0.05;
    }

    
    if (!spawned)
    {
        
        level thread maps\mp\zombies\_zm_powerups::powerup_drop(spawn_pos);
    }

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2Powerup ^5Carpenter ^2spawneado");
    else 
        self iPrintlnBold("^2Powerup ^5Carpenter ^2spawned");

    
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}


spawn_double_points()
{
    self endon("disconnect");

    
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("double_points", spawn_pos);

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2Powerup ^5Double Points ^2spawneado");
    else 
        self iPrintlnBold("^2Powerup ^5Double Points ^2spawned");

    
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}


spawn_fire_sale()
{
    self endon("disconnect");

    
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("fire_sale", spawn_pos);

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2Powerup ^5Fire Sale ^2spawneado");
    else 
        self iPrintlnBold("^2Powerup ^5Fire Sale ^2spawned");

    
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}


spawn_nuke()
{
    self endon("disconnect");

    
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("nuke", spawn_pos);

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2Powerup ^5Nuke ^2spawneado");
    else 
        self iPrintlnBold("^2Powerup ^5Nuke ^2spawned");

    
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}


spawn_zombie_blood()
{
    self endon("disconnect");

    
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("zombie_blood", spawn_pos);

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2Powerup ^5Zombie Blood ^2spawneado");
    else 
        self iPrintlnBold("^2Powerup ^5Zombie Blood ^2spawned");

    
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}



spawn_all_powerups()
{
    self endon("disconnect");

    
    if (isDefined(self.is_spawning_all_powerups))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_all_powerups = true;

    
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    right = AnglesToRight(player_angles);

    
    powerup_types = [];
    powerup_types[0] = "full_ammo";
    powerup_types[1] = "insta_kill";
    powerup_types[2] = "carpenter";
    powerup_types[3] = "double_points";
    powerup_types[4] = "fire_sale";
    powerup_types[5] = "nuke";
    powerup_types[6] = "zombie_blood";

    
    base_pos = self.origin + forward * 150 + (0, 0, 10);

    for (i = 0; i < powerup_types.size; i++)
    {
        
        angle = (i / powerup_types.size) * 360;
        radius = 80;

        offset_x = cos(angle) * radius;
        offset_y = sin(angle) * radius;

        
        height_offset = i * 15;
        if (powerup_types[i] == "nuke")
        {
            height_offset = i * 15 - 20; 
        }

        spawn_pos = base_pos + (offset_x, offset_y, height_offset);

        
        powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop(powerup_types[i], spawn_pos);

        wait 0.1; 
    }

    
    if (self.langLEN == 0) 
        self iPrintlnBold("^2TODOS los Powerups spawneados enfrente!");
    else 
        self iPrintlnBold("^2ALL Powerups spawned in front!");

    
    self playLocalSound("zmb_round_change");

    wait 1.0;
    self.is_spawning_all_powerups = undefined;
}


spawn_random_powerup()
{
    self endon("disconnect");

    
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    
    powerup_types = [];
    powerup_types[0] = "full_ammo";
    powerup_types[1] = "insta_kill";
    powerup_types[2] = "carpenter";
    powerup_types[3] = "double_points";
    powerup_types[4] = "fire_sale";
    powerup_types[5] = "nuke";
    powerup_types[6] = "zombie_blood";

    
    random_index = randomInt(powerup_types.size);
    selected_powerup = powerup_types[random_index];

    
    if (selected_powerup == "carpenter")
    {
        carpenter_names = [];
        carpenter_names[0] = "carpenter";
        carpenter_names[1] = "free_perk";
        carpenter_names[2] = "bonus_points";
        for (i = 0; i < carpenter_names.size; i++)
        {
            powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop(carpenter_names[i], spawn_pos);
            if (isDefined(powerup))
                break;
            wait 0.05;
        }
    }
    else
    {
        
        powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop(selected_powerup, spawn_pos);
    }

    
    powerup_names = [];
    powerup_names["full_ammo"] = "Max Ammo";
    powerup_names["insta_kill"] = "Insta Kill";
    powerup_names["carpenter"] = "Carpenter";
    powerup_names["double_points"] = "Double Points";
    powerup_names["fire_sale"] = "Fire Sale";
    powerup_names["nuke"] = "Nuke";
    powerup_names["zombie_blood"] = "Zombie Blood";

    
    powerup_name = powerup_names[selected_powerup];
    if (self.langLEN == 0) 
        self iPrintlnBold("^2Powerup Random: ^5" + powerup_name + " ^2spawneado enfrente!");
    else 
        self iPrintlnBold("^2Random Powerup: ^5" + powerup_name + " ^2spawned in front!");

    
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}






toggle_zombie_freeze()
{
    
    if(isDefined(self.is_toggling_freeze))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_freeze = true;

    
    if(!isDefined(self.zombies_frozen))
        self.zombies_frozen = false;

    self.zombies_frozen = !self.zombies_frozen;

    zombies = getAIArray("axis");

    if(self.zombies_frozen)
    {
        
        foreach(zombie in zombies)
        {
            if(isDefined(zombie) && isAlive(zombie))
            {
                zombie setVelocity((0, 0, 0)); 
                zombie.ignoreall = true; 
            }
        }

        
        if(self.langLEN == 0)
            self iPrintLnBold("^3ZOMBIES CONGELADOS");
        else
            self iPrintLnBold("^3ZOMBIES FROZEN");

        
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::toggle_zombie_freeze)
                {
                    status = self.zombies_frozen ? "ON" : "OFF";
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                    else
                        self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                }
            }
        }
    }
    else
    {
        
        foreach(zombie in zombies)
        {
            if(isDefined(zombie) && isAlive(zombie))
            {
                zombie.ignoreall = false; 
            }
        }

        
        if(self.langLEN == 0)
            self iPrintLnBold("^1ZOMBIES DESCONGELADOS");
        else
            self iPrintLnBold("^1ZOMBIES UNFROZEN");

        
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::toggle_zombie_freeze)
                {
                    status = self.zombies_frozen ? "ON" : "OFF";
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                    else
                        self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                }
            }
        }
    }


    self.is_toggling_freeze = undefined;
}


kill_all_zombies()
{
    
    if(isDefined(self.is_toggling_kill))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_kill = true;

    zombies = getAIArray("axis");
    killed_count = 0;

    foreach(zombie in zombies)
    {
        if(isDefined(zombie) && isAlive(zombie))
        {
            zombie doDamage(zombie.health + 999, zombie.origin);
            killed_count++;
        }
    }

    
    if(self.langLEN == 0)
        self iPrintLnBold("^2ELIMINADOS: ^5" + killed_count + " ^2ZOMBIES");
    else
        self iPrintLnBold("^2KILLED: ^5" + killed_count + " ^2ZOMBIES");

    self.is_toggling_kill = undefined;
}






toggle_unlimited_ammo()
{
    
    if(isDefined(self.is_toggling_ammo))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_ammo = true;

    
    if(!isDefined(self.unlimited_ammo))
        self.unlimited_ammo = false;

    self.unlimited_ammo = !self.unlimited_ammo;

    if(self.unlimited_ammo)
    {
        
        self thread unlimited_ammo_monitor();

        
        if(self.langLEN == 0)
            self iPrintLnBold("^2MUNICIÓN INFINITA ACTIVADA");
        else
            self iPrintLnBold("^2UNLIMITED AMMO ENABLED");

        
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::toggle_unlimited_ammo)
                {
                    status = self.unlimited_ammo ? "ON" : "OFF";
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Munición Infinita: " + status);
                    else
                        self.menu_current.items[i].item setText("Unlimited Ammo: " + status);
                }
            }
        }
    }
    else
    {
        
        self notify("stop_unlimited_ammo");

        
        if(self.langLEN == 0)
            self iPrintLnBold("^1MUNICIÓN INFINITA DESACTIVADA");
        else
            self iPrintLnBold("^1UNLIMITED AMMO DISABLED");

        
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::toggle_unlimited_ammo)
                {
                    status = self.unlimited_ammo ? "ON" : "OFF";
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Munición Infinita: " + status);
                    else
                        self.menu_current.items[i].item setText("Unlimited Ammo: " + status);
                }
            }
        }
    }


    self.is_toggling_ammo = undefined;
}


unlimited_ammo_monitor()
{
    self endon("disconnect");
    self endon("stop_unlimited_ammo");

    while(true)
    {
        wait 0.1;

        if(!isDefined(self) || !isAlive(self))
            continue;

        
        current_weapon = self getCurrentWeapon();
        if(isDefined(current_weapon) && current_weapon != "none")
        {
            self setWeaponAmmoClip(current_weapon, weaponClipSize(current_weapon));
            self giveMaxAmmo(current_weapon);
        }

        
        weapons = self getWeaponsList();
        foreach(weapon in weapons)
        {
            if(isDefined(weapon) && weapon != "none")
            {
                
                is_grenade = false;
                grenade_types = [];
                grenade_types[0] = "frag_grenade_zm";
                grenade_types[1] = "sticky_grenade_zm";
                grenade_types[2] = "cymbal_monkey_zm";
                grenade_types[3] = "emp_grenade_zm";
                grenade_types[4] = "claymore_zm";

                foreach(grenade in grenade_types)
                {
                    if(weapon == grenade)
                    {
                        is_grenade = true;
                        break;
                    }
                }

                
                if(is_grenade)
                {
                    self giveMaxAmmo(weapon);
                }
            }
        }

        
        self setWeaponAmmoClip("frag_grenade_zm", 4);
        self setWeaponAmmoClip("sticky_grenade_zm", 4);

        
        self setWeaponAmmoClip("cymbal_monkey_zm", 4);
        self setWeaponAmmoClip("emp_grenade_zm", 4);
    }
}






toggle_ufo_mode()
{
    
    if(isDefined(self.is_toggling_ufo))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_ufo = true;

    
    if(!isDefined(self.ufo_enabled))
        self.ufo_enabled = false;

    self.ufo_enabled = !self.ufo_enabled;

    if(self.ufo_enabled)
    {
        
        if(isDefined(self.forge_enabled) && self.forge_enabled)
        {
            self.forge_enabled = false;
            self notify("stop_forge_mode");

            if(self.langLEN == 0)
                self iPrintLn("^1FORGE MODE DESACTIVADO (conflicto con UFO)");
            else
                self iPrintLn("^1FORGE MODE DISABLED (conflict with UFO)");

            
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_forge_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        else
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        break;
                    }
                }
            }
        }

        
        if(isDefined(self.aimbot_enabled) && self.aimbot_enabled)
        {
            self.aimbot_enabled = false;
            self notify("stop_aimbot");

            if (self.langLEN == 0)
                self iPrintLn("^1AIMBOT DESACTIVADO (conflicto con UFO)");
            else
                self iPrintLn("^1AIMBOT DISABLED (conflict with UFO)");

            
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_aimbot)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Aimbot: OFF");
                        else
                            self.menu_current.items[i].item setText("Aimbot: OFF");
                        break;
                    }
                }
            }
        }

        
        self thread ufo_mode_monitor();

        
        if(!self.godmode_enabled)
        {
            self enableInvulnerability();
            self.ufo_godmode_activated = true; 
        }

        
        if(self.langLEN == 0)
            self iPrintLnBold("^2MODO UFO ACTIVADO - Presiona [{+frag}] para volar");
        else
            self iPrintLnBold("^2UFO MODE ENABLED - Press [{+frag}] to fly");
    }
    else
    {
        
        self notify("stop_ufo_mode");

        
        if(isDefined(self.ufo_object))
        {
            self.ufo_object delete();
            self.ufo_object = undefined;
        }

        
        if(isDefined(self.fly_enabled) && self.fly_enabled)
        {
            self unlink();
            self.fly_enabled = false;
        }

        
        if(isDefined(self.ufo_godmode_activated) && self.ufo_godmode_activated && !self.godmode_enabled)
        {
            self disableInvulnerability();
            self.ufo_godmode_activated = undefined;
        }

        
        if(self.langLEN == 0)
            self iPrintLnBold("^1MODO UFO DESACTIVADO");
        else
            self iPrintLnBold("^1UFO MODE DISABLED");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_ufo_mode)
            {
                status = self.ufo_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Modo UFO: " + status);
                else
                    self.menu_current.items[i].item setText("UFO Mode: " + status);
            }
        }
    }

    
    wait 0.5;
    self.is_toggling_ufo = undefined;
}


ufo_mode_monitor()
{
    self endon("disconnect");
    self endon("stop_ufo_mode");

    
    if(!isDefined(self.ufo_object))
    {
        self.ufo_object = spawn("script_model", self.origin);
        self.ufo_object setModel("tag_origin");
    }

    self.fly_enabled = false;
    self.last_frag_press = 0; 

    while(true)
    {
        
        if(self fragButtonPressed() && (getTime() - self.last_frag_press) > 500) 
        {
            self.last_frag_press = getTime();

            if(!self.fly_enabled)
            {
                
                self playerLinkTo(self.ufo_object);
                self.fly_enabled = true;

                
                if(!self.godmode_enabled && !isDefined(self.ufo_godmode_activated))
                {
                    self enableInvulnerability();
                    self.ufo_flight_godmode = true; 
                }

                if(self.langLEN == 0)
                    self iPrintLn("^2VOLANDO...");
                else
                    self iPrintLn("^2FLYING...");
            }
            else
            {
                
                self unlink();
                self.fly_enabled = false;

                
                if(isDefined(self.ufo_flight_godmode) && self.ufo_flight_godmode && !self.godmode_enabled)
                {
                    self disableInvulnerability();
                    self.ufo_flight_godmode = undefined;
                }

                if(self.langLEN == 0)
                    self iPrintLn("^1VUELO DETENIDO");
                else
                    self iPrintLn("^1FLIGHT STOPPED");
            }
        }

        if(self.fly_enabled)
        {
            
            fly_origin = self.ufo_object.origin + vectorScale(anglesToForward(self getPlayerAngles()), 20);
            self.ufo_object moveTo(fly_origin, 0.01);
        }

        wait 0.01;
    }
}


toggle_forge_mode()
{
    if (isDefined(self.is_toggling_forge))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_forge = true;

    if (!isDefined(self.forge_enabled))
        self.forge_enabled = false;

    self.forge_enabled = !self.forge_enabled;

    if (self.forge_enabled)
    {
        
        if(isDefined(self.ufo_enabled) && self.ufo_enabled)
        {
            self.ufo_enabled = false;
            self notify("stop_ufo_mode");

            
            if(isDefined(self.ufo_object))
            {
                self.ufo_object delete();
                self.ufo_object = undefined;
            }

            
            if(isDefined(self.fly_enabled) && self.fly_enabled)
            {
                self unlink();
                self.fly_enabled = false;
            }

            
            if(isDefined(self.ufo_godmode_activated) && self.ufo_godmode_activated && !self.godmode_enabled)
            {
                self disableInvulnerability();
                self.ufo_godmode_activated = undefined;
            }

            if (self.langLEN == 0)
                self iPrintLn("^1MODO UFO DESACTIVADO (conflicto con Forge)");
            else
                self iPrintLn("^1UFO MODE DISABLED (conflict with Forge)");

            
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_ufo_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Modo UFO: OFF");
                        else
                            self.menu_current.items[i].item setText("UFO Mode: OFF");
                        break;
                    }
                }
            }
        }

        
        if(isDefined(self.aimbot_enabled) && self.aimbot_enabled)
        {
            self.aimbot_enabled = false;
            self notify("stop_aimbot");

            if (self.langLEN == 0)
                self iPrintLn("^1AIMBOT DESACTIVADO (conflicto con Forge)");
            else
                self iPrintLn("^1AIMBOT DISABLED (conflict with Forge)");

            
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_aimbot)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Aimbot: OFF");
                        else
                            self.menu_current.items[i].item setText("Aimbot: OFF");
                        break;
                    }
                }
            }
        }

        self thread forge_mode_monitor();

        if (self.langLEN == 0)
            self iPrintLnBold("^2FORGE MODE ACTIVADO - Apunta con el mouse para mover objetos o zombies");
        else
            self iPrintLnBold("^2FORGE MODE ENABLED - Aim with mouse to move objects or zombies");
    }
    else
    {
        self notify("stop_forge_mode");

        if (self.langLEN == 0)
            self iPrintLnBold("^1FORGE MODE DESACTIVADO");
        else
            self iPrintLnBold("^1FORGE MODE DISABLED");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            item = self.menu_current.items[i];
            if (item.func == ::toggle_forge_mode)
            {
                status = self.forge_enabled ? "ON" : "OFF";
                item.item setText("Forge Mode: " + status);
            }
        }
    }

    self.is_toggling_forge = undefined;
}




forge_mode_monitor()
{
    self endon("disconnect");
    self endon("stop_forge_mode");

    picked_object = undefined;
    smooth_pos = undefined;
    rot_angle = 0;

    while (true)
    {
        
        if (self adsButtonPressed())
        {
            if (!isDefined(picked_object))
            {
                start_pos = self getTagOrigin("j_head");
                end_pos = start_pos + vectorScale(anglesToForward(self getPlayerAngles()), 1000);
                trace = bulletTrace(start_pos, end_pos, true, self);

                if (isDefined(trace["entity"]) && trace["entity"] != self)
                {
                    obj = trace["entity"];

                    if (isDefined(obj) && isDefined(obj.origin))
                    {
                        picked_object = obj;
                        smooth_pos = obj.origin;

                    
                    }
                }
            }

            
            if (isDefined(picked_object) && isDefined(picked_object.origin))
            {
                start_pos = self getTagOrigin("j_head");
                desired_pos = start_pos + vectorScale(anglesToForward(self getPlayerAngles()), 200);
                smooth_pos = vectorLerp(smooth_pos, desired_pos, 0.25);
                picked_object.origin = smooth_pos;

                if (isDefined(level._effect["powerup_grabbed"]))
                    playFX(level._effect["powerup_grabbed"], smooth_pos);
            }
        }
        else
        {
            
            if (isDefined(picked_object))
            {
                picked_object = undefined;
                smooth_pos = undefined;

            }
        }

        
        if (self fragButtonPressed() && isDefined(picked_object))
        {
            rot_angle += 15;
            if (rot_angle >= 360)
                rot_angle = 0;

            current_angles = picked_object.angles;
            new_angles = (current_angles[0], current_angles[1] + 15, current_angles[2]);
            picked_object.angles = new_angles;
        }

        wait 0.02;
    }
}




vectorLerp(start, end, frac)
{
    return ((start[0] + (end[0] - start[0]) * frac),
            (start[1] + (end[1] - start[1]) * frac),
            (start[2] + (end[2] - start[2]) * frac));
}


toggle_jetpack()
{
    
    if(isDefined(self.is_toggling_jetpack))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_jetpack = true;

    
    if(!isDefined(self.jetpack_enabled))
        self.jetpack_enabled = false;

    self.jetpack_enabled = !self.jetpack_enabled;

    if(self.jetpack_enabled)
    {
        
        self thread jetpack_monitor();

        
        if(self.langLEN == 0)
            self iPrintLnBold("^2JETPACK ACTIVADO - Salta para volar");
        else
            self iPrintLnBold("^2JETPACK ENABLED - Jump to fly");
    }
    else
    {
        
        self notify("stop_jetpack");

        
        if(self.langLEN == 0)
            self iPrintLnBold("^1JETPACK DESACTIVADO");
        else
            self iPrintLnBold("^1JETPACK DISABLED");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_jetpack)
            {
                status = self.jetpack_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("JetPack: " + status);
                else
                    self.menu_current.items[i].item setText("JetPack: " + status);
            }
        }
    }

    self.is_toggling_jetpack = undefined;
}


jetpack_monitor()
{
    self endon("disconnect");
    self endon("stop_jetpack");

    self.jetpack_fuel = 100; 

    while(true)
    {
        if(self jumpButtonPressed() && self.jetpack_fuel > 0 && !self isOnGround())
        {
            
            playFX(level._effect["lght_marker_flare"], self getTagOrigin("J_Ankle_RI"));
            playFX(level._effect["lght_marker_flare"], self getTagOrigin("J_Ankle_LE"));

            
            earthquake(0.15, 0.2, self getTagOrigin("j_spine4"), 50);

            
            if(self getVelocity()[2] < 300)
            {
                self setVelocity(self getVelocity() + (0, 0, 60));
            }

            self.jetpack_fuel--;

            
            if(self.jetpack_fuel % 20 == 0)
            {
                if(self.langLEN == 0)
                    self iPrintLnBold("Combustible: " + self.jetpack_fuel);
                else
                    self iPrintLnBold("Fuel: " + self.jetpack_fuel);
            }
        }

        
        if(self.jetpack_fuel < 100 && !self jumpButtonPressed())
        {
            self.jetpack_fuel++;
        }

        wait 0.05;
    }
}






toggle_aimbot()
{
    
    if(isDefined(self.is_toggling_aimbot))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_aimbot = true;

    
    if(!isDefined(self.aimbot_enabled))
        self.aimbot_enabled = false;

    self.aimbot_enabled = !self.aimbot_enabled;

    if(self.aimbot_enabled)
    {
        
        if(isDefined(self.teleport_zombies_enabled) && self.teleport_zombies_enabled)
        {
            self.teleport_zombies_enabled = false;
            self notify("teleport_zombies_off");

            if (self.langLEN == 0)
                self iPrintLnBold("^1TELEPORT ZOMBIES DESACTIVADO (conflicto con Aimbot)");
            else
                self iPrintLnBold("^1TELEPORT ZOMBIES DISABLED (conflict with Aimbot)");

            
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_teleport_zombies)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Teleport Zombies: OFF");
                        else
                            self.menu_current.items[i].item setText("Teleport Zombies: OFF");
                        break;
                    }
                }
            }
        }

        
        if(isDefined(self.ufo_enabled) && self.ufo_enabled)
        {
            self.ufo_enabled = false;
            self notify("stop_ufo_mode");

            
            if(isDefined(self.ufo_object))
            {
                self.ufo_object delete();
                self.ufo_object = undefined;
            }

            
            if(isDefined(self.fly_enabled) && self.fly_enabled)
            {
                self unlink();
                self.fly_enabled = false;
            }

            
            if(isDefined(self.ufo_godmode_activated) && self.ufo_godmode_activated && !self.godmode_enabled)
            {
                self disableInvulnerability();
                self.ufo_godmode_activated = undefined;
            }

            if (self.langLEN == 0)
                self iPrintLnBold("^1MODO UFO DESACTIVADO (conflicto con Aimbot)");
            else
                self iPrintLnBold("^1UFO MODE DISABLED (conflict with Aimbot)");

            
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_ufo_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Modo UFO: OFF");
                        else
                            self.menu_current.items[i].item setText("UFO Mode: OFF");
                        break;
                    }
                }
            }
        }

        
        if(isDefined(self.forge_enabled) && self.forge_enabled)
        {
            self.forge_enabled = false;
            self notify("stop_forge_mode");

            if (self.langLEN == 0)
                self iPrintLnBold("^1FORGE MODE DESACTIVADO (conflicto con Aimbot)");
            else
                self iPrintLnBold("^1FORGE MODE DISABLED (conflict with Aimbot)");

            
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_forge_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        else
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        break;
                    }
                }
            }
        }

        
        self thread aimbot_monitor();

        
        if(self.langLEN == 0)
            self iPrintLnBold("^2AIMBOT ACTIVADO");
        else
            self iPrintLnBold("^2AIMBOT ENABLED");
    }
    else
    {
        
        self notify("stop_aimbot");

        
        if(self.langLEN == 0)
            self iPrintLnBold("^1AIMBOT DESACTIVADO");
        else
            self iPrintLnBold("^1AIMBOT DISABLED");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_aimbot)
            {
                status = self.aimbot_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Aimbot: " + status);
                else
                    self.menu_current.items[i].item setText("Aimbot: " + status);
            }
        }
    }

    self.is_toggling_aimbot = undefined;
}


aimbot_monitor()
{
    self endon("disconnect");
    self endon("stop_aimbot");

    while(true)
    {
        if(self adsButtonPressed())
        {
            
            zombies = getAIArray("axis");
            closest_zombie = undefined;
            closest_distance = 999999;

            foreach(zombie in zombies)
            {
                if(isDefined(zombie) && isAlive(zombie))
                {
                    distance = distance(self.origin, zombie.origin);
                    if(distance < closest_distance)
                    {
                        closest_distance = distance;
                        closest_zombie = zombie;
                    }
                }
            }

            
            if(isDefined(closest_zombie))
            {
                head_pos = closest_zombie getTagOrigin("j_head");
                angles = vectorToAngles(head_pos - self getTagOrigin("j_head"));
                self setPlayerAngles(angles);

                
                if(isDefined(self.aimbot_auto_fire) && self.aimbot_auto_fire)
                {
                    magicBullet(self getCurrentWeapon(), self getTagOrigin("j_head"), head_pos, self);
                }
            }
        }

        wait 0.05;
    }
}


toggle_artillery()
{
    
    if(isDefined(self.is_toggling_artillery))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_artillery = true;

    
    if(!isDefined(self.artillery_enabled))
        self.artillery_enabled = false;

    self.artillery_enabled = !self.artillery_enabled;

    if(self.artillery_enabled)
    {
        
        self thread artillery_monitor();

        
        if(self.langLEN == 0)
            self iPrintLnBold("^2ARTILLERIA ACTIVADA");
        else
            self iPrintLnBold("^2ARTILLERY ENABLED");
    }
    else
    {
        
        self notify("stop_artillery");

        
        if(self.langLEN == 0)
            self iPrintLnBold("^1ARTILLERIA DESACTIVADA");
        else
            self iPrintLnBold("^1ARTILLERY DISABLED");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_artillery)
            {
                status = self.artillery_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Artillery: " + status);
                else
                    self.menu_current.items[i].item setText("Artillery: " + status);
            }
        }
    }

    self.is_toggling_artillery = undefined;
}


artillery_monitor()
{
    self endon("disconnect");
    self endon("stop_artillery");

    while(true)
    {
        
        x = randomIntRange(-2000, 2000);
        y = randomIntRange(-2000, 2000);
        z = randomIntRange(1100, 1200);

        target_pos = (x, y, z);

        
        playFX(loadFX("explosions/fx_default_explosion"), target_pos);
        playFX(level._effect["def_explosion"], target_pos);

        
        radiusDamage(target_pos, 500, 1000, 300, self);

        
        playSoundAtPosition("evt_nuke_flash", target_pos);

        
        earthquake(2.5, 2, target_pos, 300);

        wait 0.01; 
    }
}






clone_player()
{
    self iprintln("Clone ^2Spawned!");
    self ClonePlayer(9999);
}



toggle_auto_revive()
{
    if(!isDefined(level.auto_revive_enabled) || level.auto_revive_enabled == false)
    {
        level.auto_revive_enabled = true;
        self thread auto_revive_monitor();
        self iPrintln("Auto Revive [^2ON^7]");
    }
    else
    {
        level.auto_revive_enabled = false;
        self iPrintln("Auto Revive [^1OFF^7]");
        self notify("auto_revive_off");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_auto_revive)
            {
                status = level.auto_revive_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Auto Revive: " + status);
                else
                    self.menu_current.items[i].item setText("Auto Revive: " + status);
            }
        }
    }
}

auto_revive_monitor()
{
    self endon("disconnect");
    self endon("auto_revive_off");

    for(;;)
    {
        self thread revive_all_players();
        wait 0.05;
    }
}

revive_all_players()
{
    self endon("auto_revive_off");

    foreach(player in level.players)
    {
        if(isDefined(player.revivetrigger))
        {
            player.revivetrigger setinvisibletoall();
            player notify("revive_trigger");
            player.revivetrigger delete();
            player reviveplayer();
            player.laststand = undefined;
            player [[level.spawnplayer]]();
        }
    }
}


toggle_gore_mode()
{
    if(!isDefined(self.gore_enabled) || self.gore_enabled == false)
    {
        self.gore_enabled = true;
        self iPrintlnBold("Gore Mode [^2ON^7]");
        self thread gore_effects();
    }
    else
    {
        self.gore_enabled = false;
        self iPrintlnBold("Gore Mode [^1OFF^7]");
        self notify("gore_off");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_gore_mode)
            {
                status = self.gore_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Gore Mode: " + status);
                else
                    self.menu_current.items[i].item setText("Gore Mode: " + status);
            }
        }
    }
}

gore_effects()
{
    self endon("disconnect");
    self endon("gore_off");

    while(isDefined(self.gore_enabled) && self.gore_enabled)
    {
        foreach(player in level.players)
        {
            player endon("gore_off");
            playFx(level._effect["headshot"], player getTagOrigin("j_head"));
            playFx(level._effect["headshot"], player getTagOrigin("J_neck"));
            playFx(level._effect["headshot"], player getTagOrigin("J_Shoulder_LE"));
            playFx(level._effect["headshot"], player getTagOrigin("J_Shoulder_RI"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_Shoulder_LE"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_Shoulder_RI"));
            playFx(level._effect["headshot"], player getTagOrigin("J_Ankle_RI"));
            playFx(level._effect["headshot"], player getTagOrigin("J_Ankle_LE"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_Ankle_RI"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_Ankle_LE"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_wrist_RI"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_wrist_LE"));
            playFx(level._effect["headshot"], player getTagOrigin("J_SpineLower"));
            wait 0.05;
        }
        wait 1.0; 
    }
}


open_all_doors()
{
    setdvar("zombie_unlock_all", 1);
    wait 0.5;
    self iPrintlnBold("Open all the doors ^2Success");

    triggers = strTok("zombie_doors|zombie_door|zombie_airlock_buy|zombie_debris|flag_blocker|window_shutter|zombie_trap", "|");

    for(a = 0; a < triggers.size; a++)
    {
        trigger = getEntArray(triggers[a], "targetname");
        for(b = 0; b < trigger.size; b++)
        {
            trigger[b] notify("trigger");
        }
    }
}


toggle_super_jump()
{
    if(!isDefined(self.super_jump_enabled) || self.super_jump_enabled == false)
    {
        self.super_jump_enabled = true;
        self thread super_jump_monitor();
        self iPrintlnBold("Super Jump [^2ON^7]");
    }
    else
    {
        self.super_jump_enabled = false;
        self notify("super_jump_off");
        self iPrintlnBold("Super Jump [^1OFF^7]");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_super_jump)
            {
                status = self.super_jump_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Super Jump: " + status);
                else
                    self.menu_current.items[i].item setText("Super Jump: " + status);
                break;
            }
        }
    }
}

super_jump_monitor()
{
    self endon("disconnect");
    self endon("super_jump_off");

    for(;;)
    {
        foreach(player in level.players)
        {
            if(player getVelocity()[2] > 150 && !player isOnGround())
            {
                player setVelocity(player getVelocity() + (0, 0, 38));
            }
        }
        wait 0.001;
    }
}


do_kamikaze()
{
    self iPrintlnBold("Kamikaze send to your ^2position");

    kam = spawn("script_model", self.origin + (5000, 1000, 10000));
    kam setModel("defaultvehicle");
    kam.angles = vectorToAngles((kam.origin) - (self.origin)) - (180, 0, 180);
    kam moveTo(self.origin, 3.5, 2, 1.5);
    kam waittill("movedone");

    earthquake(2.5, 2, kam.origin, 300);
    playFx(level._effect["thunder"], kam.origin);
    playFx(loadFx("explosions/fx_default_explosion"), kam.origin);
    playFx(loadFx("explosions/fx_default_explosion"), kam.origin + (0, 20, 50));

    wait 0.1;
    playFx(loadFx("explosions/fx_default_explosion"), kam.origin);
    playFx(loadFx("explosions/fx_default_explosion"), kam.origin + (0, 20, 50));

    radiusDamage(kam.origin, 500, 1000, 300, self);
    kam delete();
}






Fr3ZzZoM()
{
    self endon("disconnect");
    level endon("end_game");
    
    if(isDefined(self.is_toggling_freeze))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_freeze = true;

    if(self.Fr3ZzZoM == false)
    {
        self iPrintlnBold("Freeze Zombies [^2ON^7]");
        setdvar("g_ai", "0");
        self.Fr3ZzZoM = true;
    }
    else
    {
        self iPrintlnBold("Freeze Zombies [^1OFF^7]");
        setdvar("g_ai", "1");
        self.Fr3ZzZoM = false;
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::Fr3ZzZoM)
            {
                status = self.Fr3ZzZoM ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                else
                    self.menu_current.items[i].item setText("Zombie Freeze: " + status);
            }
        }
    }

    self.is_toggling_freeze = undefined;
}



toggle_teleport_zombies()
{
    
    if(isDefined(self.is_toggling_teleport))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_teleport = true;

    if(!isDefined(self.teleport_zombies_enabled) || self.teleport_zombies_enabled == false)
    {
        
        if(isDefined(self.forge_enabled) && self.forge_enabled)
        {
            self.forge_enabled = false;
            self notify("stop_forge_mode");

            if (self.langLEN == 0)
                self iPrintLnBold("^1FORGE MODE DESACTIVADO (conflicto con Teleport Zombies)");
            else
                self iPrintLnBold("^1FORGE MODE DISABLED (conflict with Teleport Zombies)");

            
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_forge_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        else
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        break;
                    }
                }
            }
        }

        
        if(isDefined(self.aimbot_enabled) && self.aimbot_enabled)
        {
            self.aimbot_enabled = false;
            self notify("stop_aimbot");

            if (self.langLEN == 0)
                self iPrintLnBold("^1AIMBOT DESACTIVADO (conflicto con Teleport Zombies)");
            else
                self iPrintLnBold("^1AIMBOT DISABLED (conflict with Teleport Zombies)");
        }

        self.teleport_zombies_enabled = true;
        self iPrintlnBold("Teleport Zombies To Crosshairs [^2ON^7]");
        self thread teleport_zombies_monitor();
    }
    else
    {
        self.teleport_zombies_enabled = false;
        self iPrintlnBold("Teleport Zombies To Crosshairs [^1OFF^7]");
        self notify("teleport_zombies_off");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_teleport_zombies)
            {
                status = self.teleport_zombies_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Teleport Zombies: " + status);
                else
                    self.menu_current.items[i].item setText("Teleport Zombies: " + status);
            }
        }
    }

    self.is_toggling_teleport = undefined;
}

teleport_zombies_monitor()
{
    self endon("disconnect");
    self endon("teleport_zombies_off");

    for(;;)
    {
        self waittill("weapon_fired");

        zombs = getAiSpeciesArray("axis", "all");
        eye = self getEye();
        vec = anglesToForward(self getPlayerAngles());
        end = (vec[0] * 100000000, vec[1] * 100000000, vec[2] * 100000000);
        teleport_loc = bulletTrace(eye, end, 0, self)["position"];

        for(i = 0; i < zombs.size; i++)
        {
            zombs[i] forceTeleport(teleport_loc);
            if(isDefined(zombs[i].reset_attack_spot))
            {
                zombs[i] maps\mp\zombies\_zm_spawner::reset_attack_spot();
            }
        }
        wait 0.05;
    }
}


toggle_disable_zombies()
{
    
    if(isDefined(self.is_toggling_disable))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_disable = true;

    if(!isDefined(self.disable_zombies_enabled) || self.disable_zombies_enabled == false)
    {
        self.disable_zombies_enabled = true;
        self thread disable_zombies_monitor();
        self iPrintlnBold("Disable Zombies [^2ON^7]");
    }
    else
    {
        self.disable_zombies_enabled = false;
        self iPrintlnBold("Disable Zombies [^1OFF^7]");
        level notify("enable_zombies");
    }

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_disable_zombies)
            {
                status = self.disable_zombies_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Disable Zombies: " + status);
                else
                    self.menu_current.items[i].item setText("Disable Zombies: " + status);
            }
        }
    }

    self.is_toggling_disable = undefined;
}

disable_zombies_monitor()
{
    level endon("enable_zombies");

    while(isDefined(self.disable_zombies_enabled) && self.disable_zombies_enabled)
    {
        zombs = getAiArray("axis");
        level.zombie_total = 0;

        if(isDefined(zombs))
        {
            for(i = 0; i < zombs.size; i++)
            {
                zombs[i] doDamage(zombs[i].health * 5000, (0, 0, 0), self);
                wait 0.05;
            }
        }

        wait 0.1;
    }
}



