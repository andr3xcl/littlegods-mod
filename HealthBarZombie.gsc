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
#include scripts\zm\Overflow_fix;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\gametypes_zm\spawnlogic;
#include maps\mp\gametypes_zm\_hostmigration;
init()
{
    level thread on_player_connect_player();
    level thread onPlayerSay();
    
    
    
}

on_player_connect_player()
{
    self endon( "end_game" );
    precacheshader( "damage_feedback" );
	self maps\mp\zombies\_zm_spawner::register_zombie_damage_callback(::do_hitmarker);
    self maps\mp\zombies\_zm_spawner::register_zombie_death_event_callback(::do_hitmarker_death);
    for (;;)
    {
        level waittill( "connected", player );
        player thread on_players_spawned();


        player.definido_comandos = 0;
		player.zombieDeathCounter = 0;
        
        
        player.healthbarzombie_active = false;

        player.hud_damagefeedback = newdamageindicatorhudelem( player );
        player.hud_damagefeedback.horzalign = "center";
        player.hud_damagefeedback.vertalign = "middle";
        player.hud_damagefeedback.x = -12;
        player.hud_damagefeedback.y = -12;
        player.hud_damagefeedback.alpha = 0;
        player.hud_damagefeedback.archived = 1;
        player.hud_damagefeedback.color = ( 1, 1, 1 );
        player.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
        player.hud_damagefeedback_red = newdamageindicatorhudelem( player );
        player.hud_damagefeedback_red.horzalign = "center";
        player.hud_damagefeedback_red.vertalign = "middle";
        player.hud_damagefeedback_red.x = -12;
        player.hud_damagefeedback_red.y = -12;
        player.hud_damagefeedback_red.alpha = 0;
        player.hud_damagefeedback_red.archived = 1;
        player.hud_damagefeedback_red.color = ( 1, 0, 0 );
        player.hud_damagefeedback_red setshader( "damage_feedback", 24, 48 );
    }
}
on_players_spawned()
{
    self endon( "disconnect" );
    for (;;)
    {
        self waittill( "spawned_player" );
        self.definido_comandos = 0;
        self.shaderON = 0; 
        self.zombieNAME = 1; 
        self.sizeW = 100;
        self.sizeH = 2;
        self.sizeN = 1; 
        self.langLEN = 1; 
        self.colorcito = (1, 1, 1); 
        
        
        if (isDefined(self.hud_zombie_health))
        {
            self.hud_zombie_health destroy();
            self.hud_zombie_health = undefined;
        }
        
        if (isDefined(self.hud_zombie_name_label))
        {
            self.hud_zombie_name_label destroy();
            self.hud_zombie_name_label = undefined;
        }

        if (isDefined(self.hud_zombie_health_current_label))
        {
            self.hud_zombie_health_current_label destroy();
            self.hud_zombie_health_current_label = undefined;
        }

        if (isDefined(self.hud_zombie_health_max_label))
        {
            self.hud_zombie_health_max_label destroy();
            self.hud_zombie_health_max_label = undefined;
        }
        
        
        self.healthbarzombie_active = false;
    }
}
updatedamagefeedback( mod, inflictor, death )
{
    if( IsDefined( self.disable_hitmarkers ) || !(isplayer( self )) )
    {
        return;
    }

    if( mod != "MOD_HIT_BY_OBJECT" && mod != "MOD_GRENADE_SPLASH" && mod != "MOD_CRUSH" && IsDefined( mod ) )
    {
        if( IsDefined( inflictor ) )
        {
            self playlocalsound( "mpl_hit_alert" );
        }

        if( getdvarintdefault( "redhitmarkers", 1 ) && death )
        {
            self.hud_damagefeedback_red setshader( "damage_feedback", 24, 48 );
            self.hud_damagefeedback_red.alpha = 1;
            self.hud_damagefeedback_red fadeovertime( 1 );
            self.hud_damagefeedback_red.alpha = 0;
            self.zombieDeathCounter++;

            self hud_show_zombie_health(self.targetZombie, true);
        }
        else
        {
            self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
            self.hud_damagefeedback.alpha = 1;
            self.hud_damagefeedback fadeovertime( 1 );
            self.hud_damagefeedback.alpha = 0;
        }

        if (IsDefined(self.targetZombie) && isalive(self.targetZombie))
        {
            self hud_show_zombie_health(self.targetZombie, false);
        }
    }
    return 0;
}

do_hitmarker_death()
{
    if( self.attacker != self && isplayer( self.attacker ) && IsDefined( self.attacker ) )
    {
        self.attacker thread updatedamagefeedback( self.damagemod, self.attacker, 1 );
    }
    return 0;
}

do_hitmarker( mod, hitloc, hitorig, player, damage )
{
    if( player != self && isplayer( player ) && IsDefined( player ) )
    {
        player.targetZombie = self;
        player thread updatedamagefeedback( mod, player, 0 );
    }
    return 0;
}
hud_show_zombie_health(entity, isDead)
{
    
    if (!isDefined(self.healthbarzombie_active) || !self.healthbarzombie_active)
        return;
    
    
    if (!isDefined(entity))
        return;
    
    
    name_zombie = entity.zombie_name;
    
    
    if (!isDefined(name_zombie))
    {
        type = "Zombie";
        
        
        if(isDefined(entity.ai_type) && entity.ai_type == "mechz")
        {
            type = "Panzer Soldat";
        }
        else if(isDefined(entity.animname) && entity.animname == "mechz_zombie")
        {
            type = "Panzer Soldat";
        }
        
        else if(self is_panzer_soldat(entity))
        {
            type = "Panzer Soldat";
        }
        else
        {
            
            if(!isDefined(entity.model))
            {
                if(isDefined(entity.zombie_move_speed) && entity.zombie_move_speed == "mechz_speed")
                    type = "Panzer Soldat";
                    
                if(isDefined(entity.script_noteworthy) && (entity.script_noteworthy == "mechz" || entity.script_noteworthy == "mech_zombie"))
                    type = "Panzer Soldat";
            }
            else
            {
                
                switch (entity.model)
                {
                    case "c_zom_dlc3_mech_z": type = "Panzer Soldat"; break;
                    case "c_zom_player_grief_cia_dlc2_fb": type = "Customs"; break;
                    case "c_zom_origins_templar_zombie": type = "Templar"; break;
                    case "c_zom_tomb_crusader_zombie": type = "Crusader"; break;
                    case "c_zom_tomb_templar_zombie": type = "Knight"; break;
                    case "c_zom_zombie_german_guard_frigid": type = "Guard"; break;
                    
                    case "c_zom_mechz": type = "Panzer Soldat"; break;
                    case "mechz_zombie": type = "Panzer Soldat"; break;
                    case "c_zom_mech_zombie": type = "Panzer Soldat"; break;
                    case "zm_mech_zombie": type = "Panzer Soldat"; break;
                    case "c_zom_tomb_mechz": type = "Panzer Soldat"; break;
                    case "c_zom_tomb_mech_zombie": type = "Panzer Soldat"; break;
                    case "c_zom_dlc4_mechz": type = "Panzer Soldat"; break;
                    default: type = "Zombie"; break;
                }
            }
        }
        
        
        
        if (isDefined(entity.isUniqueModel) && entity.isUniqueModel && !isDefined(entity.boss))
            type = "Boss Zombie";
            
        name_zombie = type;
    }
    
    
    max_health = entity.maxhealth;
    health = entity.health;
    percent = health / max_health;
    
    
    if (isDefined(self.hud_zombie_health) && isDefined(self.hud_zombie_name_label) && isDefined(self.hud_zombie_health_current_label) && isDefined(self.hud_zombie_health_max_label))
    {
        
        if (isDefined(isDead) && isDead)
        {
            self.hud_zombie_health updatebar(0);
            if (self.langLEN == 0)
            {
                self.hud_zombie_name_label setText("¡Está muerto!");
                self.hud_zombie_health_current_label.alpha = 0;
                self.hud_zombie_health_max_label.alpha = 0;
            }
            else
            {
                self.hud_zombie_name_label setText("He's dead!");
                self.hud_zombie_health_current_label.alpha = 0;
                self.hud_zombie_health_max_label.alpha = 0;
            }
        }
        else
        {
            
            
            if (!isDefined(self.colorcito))
                self.colorcito = (1, 1, 1);

            
            if (isDefined(self.hud_zombie_health.bar) && self.hud_zombie_health.bar.color != self.colorcito)
                self.hud_zombie_health.bar.color = self.colorcito;

            self.hud_zombie_health updatebar(percent);

            
            if (self.zombieNAME)
            {
                
                self.hud_zombie_name_label setText(name_zombie + "  ");
                self.hud_zombie_health_current_label.alpha = 1;
                self.hud_zombie_health_max_label.alpha = 1;
                self.hud_zombie_health_current_label setvalue(int(health));
                self.hud_zombie_health_max_label setvalue(int(max_health));
            }
            else
            {
                
                self.hud_zombie_name_label setText("");
                self.hud_zombie_health_current_label.alpha = 1;
                self.hud_zombie_health_max_label.alpha = 1;
                self.hud_zombie_health_current_label setvalue(int(health));
                self.hud_zombie_health_max_label setvalue(int(max_health));
            }
        }
    }
    else
    {
        
        self.hud_zombie_health = self createprimaryprogressbar();

        
        self.hud_zombie_name_label = self createfontstring("Objective", 1);
        self.hud_zombie_health_current_label = self createfontstring("Objective", 1);
        self.hud_zombie_health_max_label = self createfontstring("Objective", 1);
        
        
        self.hud_zombie_health setpoint("LEFT", "LEFT", 0, 90);

        
        self.hud_zombie_name_label setpoint("LEFT", "LEFT", 0, 105);

        
        self.hud_zombie_health_current_label setpoint("LEFT", "LEFT", 35, 105);
        self.hud_zombie_health_current_label.label = &"^7^3";
        self.hud_zombie_health_current_label setvalue(int(health));

        self.hud_zombie_health_max_label setpoint("LEFT", "LEFT", 53, 105);
        self.hud_zombie_health_max_label.label = &"^7/^2";
        self.hud_zombie_health_max_label setvalue(int(max_health));

        
        if (!isDefined(self.colorcito))
            self.colorcito = (1, 1, 1);

        
        self.hud_zombie_health.bar.color = self.colorcito;
        self.hud_zombie_health.hidewheninmenu = false;
        self.hud_zombie_name_label.hidewheninmenu = false;
        self.hud_zombie_health_current_label.hidewheninmenu = false;
        self.hud_zombie_health_max_label.hidewheninmenu = false;
        self.hud_zombie_health.alpha = self.shaderON;

        
        self.hud_zombie_health.width = self.sizeW;
        self.hud_zombie_health.height = self.sizeH;
        self.hud_zombie_name_label.fontScale = self.sizeN;
        
        
        if(isDefined(self.hud_zombie_health.barframe))
            self.hud_zombie_health.barframe.alpha = 0;

        
        if (isDefined(isDead) && isDead)
        {
            self.hud_zombie_health updatebar(0);
            if (self.langLEN == 0)
            {
                self.hud_zombie_name_label setText("¡Está muerto!");
                self.hud_zombie_health_current_label.alpha = 0;
                self.hud_zombie_health_max_label.alpha = 0;
            }
            else
            {
                self.hud_zombie_name_label setText("He's dead!");
                self.hud_zombie_health_current_label.alpha = 0;
                self.hud_zombie_health_max_label.alpha = 0;
            }
        }
        else
        {
            
            self.hud_zombie_health updatebar(percent);

            
            if (self.zombieNAME)
            {
                self.hud_zombie_name_label setText(name_zombie + "   ");
                self.hud_zombie_health_current_label.alpha = 1;
                self.hud_zombie_health_max_label.alpha = 1;
                self.hud_zombie_health_current_label setvalue(int(health));
                self.hud_zombie_health_max_label setvalue(int(max_health));
            }
            else
            {
                self.hud_zombie_name_label setText("");
                self.hud_zombie_health_current_label.alpha = 1;
                self.hud_zombie_health_max_label.alpha = 1;
                self.hud_zombie_health_current_label setvalue(int(health));
                self.hud_zombie_health_max_label setvalue(int(max_health));
            }
        }
    }
    
    
    if (isDefined(isDead) && !isDead && health == max_health)
    {
        self.hud_zombie_health fadeovertime(1.5);
        self.hud_zombie_name_label fadeovertime(1.5);
        self.hud_zombie_health_current_label fadeovertime(1.5);
        self.hud_zombie_health_max_label fadeovertime(1.5);
        self.hud_zombie_health.alpha = 0;
        self.hud_zombie_name_label.alpha = 0;
        self.hud_zombie_health_current_label.alpha = 0;
        self.hud_zombie_health_max_label.alpha = 0;
        wait 1.5;
        if (isDefined(self.hud_zombie_health))
        {
            self.hud_zombie_health destroy();
            self.hud_zombie_health = undefined;
        }
        if (isDefined(self.hud_zombie_name_label))
        {
            self.hud_zombie_name_label destroy();
            self.hud_zombie_name_label = undefined;
        }

        if (isDefined(self.hud_zombie_health_current_label))
        {
            self.hud_zombie_health_current_label destroy();
            self.hud_zombie_health_current_label = undefined;
        }

        if (isDefined(self.hud_zombie_health_max_label))
        {
            self.hud_zombie_health_max_label destroy();
            self.hud_zombie_health_max_label = undefined;
        }
    }
}
configbar()
{
    self endon("disconnect");
    level endon("end_game");
    while(true)
    {
        self.hud_zombie_health.width = self.sizeW; 
        self.hud_zombie_health.height = self.sizeH;
        self.hud_zombie_name_label.fontScale = self.sizeN;
        self.hud_zombie_health_current_label.fontScale = self.sizeN;
        self.hud_zombie_health_max_label.fontScale = self.sizeN;
        self.hud_zombie_health.alpha = self.shaderON;
        wait 1;
    }
}
colorBAR(varN)
{
    self endon("disconnect");
    level endon("end_game");
    self endon("end_colorBAR");
    
    
    colorbarlist = [];
    colorbarlist[0] = (1, 0, 0);   
    colorbarlist[1] = (0, 1, 0);   
    colorbarlist[2] = (0, 0, 1);   
    colorbarlist[3] = (1, 1, 0);   
    colorbarlist[4] = (1, 0, 1);   
    colorbarlist[5] = (0, 1, 1);   
    colorbarlist[6] = (1, 1, 1);   
    colorbarlist[7] = (0, 0, 0);   
    colorbarlist[8] = (0.5, 0, 0); 
    colorbarlist[9] = (0, 0.5, 0); 
    colorbarlist[10] = (0, 0, 0.5); 
    colorbarlist[11] = (0.5, 0.5, 0); 
    colorbarlist[12] = (0.5, 0, 0.5); 
    colorbarlist[13] = (0, 0.5, 0.5); 
    colorbarlist[14] = (0.75, 0.75, 0.75); 
    colorbarlist[15] = (0.25, 0.25, 0.25); 
    colorbarlist[16] = (1, 0.5, 0);  
    colorbarlist[17] = (0.5, 0.25, 0); 
    colorbarlist[18] = (1, 0.75, 0.8); 
    colorbarlist[19] = (0.5, 0, 0.25); 
    colorbarlist[20] = (0.5, 1, 0.5); 

    
    if (varN >= 1 && varN <= 21)
    {
        
        self.colorcito = colorbarlist[varN - 1];
        
        
        if (isDefined(self.hud_zombie_health) && isDefined(self.hud_zombie_health.bar))
        {
            self.hud_zombie_health.bar.color = self.colorcito;
        }
    }

    while (true)
    {
        if (isDefined(self.hud_zombie_health) && isDefined(self.hud_zombie_health.bar))
        {
            if (varN == 0)
            {
                
                randomIndex = randomint(colorbarlist.size);
                self.colorcito = colorbarlist[randomIndex];
                self.hud_zombie_health.bar.color = self.colorcito;
            }
            else if (varN >= 1 && varN <= 21)
            {
                
                
                if (self.hud_zombie_health.bar.color != self.colorcito)
                {
                    self.hud_zombie_health.bar.color = self.colorcito;
                }
            }
        }
        wait(0.5);
    }
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
            case "barzm":
                if (!isDefined(args[1])) 
                {
                    player tell("^1ERROR: Command missing parameters.");
                    continue;
                }
                executeBarzmCommand(args, player);
                break;
            case "help":
                player thread helpcommand();
                break;
            case "lang":
                if (!isDefined(args[1])) 
                {
                    player tell("^1ERROR: Command missing parameters.");
                    continue;
                }
                updateLanguage(args, player);
                break;
            default:
                player tell("^1ERROR: Unknown command.");
                break;
            }
        }
    }
}

executeBarzmCommand(args, player)
{
    if (args[1] == "color")
    {
        updateColor(args, player);
    }
    else if (args[1] == "name")
    {
        updateNameZombie(args, player);
    }
    else if (args[1] == "sizew")
    {
        updateSizeW(args, player);
    }
    else if (args[1] == "sizeh")
    {
        updateSizeH(args, player);
    }
    else if (args[1] == "sizen")
    {
        updateSizeN(args, player);
    }
    else if (args[1] == "shader")
    {
        updateShader(args, player);
    }
    else
    {
        player tell("^1ERROR: Invalid barzm option.");
    }
}
updateNameZombie(args, player)
{
    if (!isdefined(args[2]))
    {
        player tell("^1ERROR -> ^1#barzm name <value>");
        return;
    }
    varN = int(args[2]);
    if (varN >= 0 && varN <= 1)
    {
        player.zombieNAME = varN;
        if(player.langLEN == 0)
        {
            if(varN == 0)
            {
                player tell("Zombie nombre off");
            }
            else if(varN == 1)
            {
                player tell("Zombie nombre on");
            }
        }else if(player.langLEN == 1)
        {
            if(varN == 0)
            {
                player tell("Zombie name off");
            }
            else if(varN == 1)
            {
                player tell("Zombie name on");
            }
        }
    }
    else
    {
        player tell("^1ERROR VALUE -> 0 a 1");
    }
}
updateColor(args, player)
{
    if (!isdefined(args[2]))
    {
        player tell("^1ERROR -> ^1#barzm color <value>");
        return;
    }
    varN = int(args[2]);
    if (varN >= 0 && varN <= 21)
    {
        player notify("end_colorBAR");
        player thread colorBAR(varN);
    }
}

updateSizeW(args, player)
{
    if (!isdefined(args[2]))
    {
        player tell("^1ERROR -> ^1#barzm sizew <value>");
        return;
    }
    varN = int(args[2]);
    if (varN >= 50 && varN <= 105)
    {
        player.sizeW = varN;
        confirmSize("width", varN, player);
    }
    else
    {
        player tell("^1ERROR VALUE -> 50 a 105");
    }
}

updateSizeH(args, player)
{
    if (!isdefined(args[2]))
    {
        player tell("^1ERROR -> ^1#barzm sizeh <value>");
        return;
    }
    varN = int(args[2]);
    if (varN >= 2 && varN <= 4)
    {
        player.sizeH = varN;
        confirmSize("height", varN, player);
    }
    else
    {
        player tell("^1ERROR VALUE -> 2 a 4");
    }
}

updateSizeN(args, player)
{
    if (!isdefined(args[2]))
    {
        player tell("^1ERROR -> ^1#barzm sizen <value>");
        return;
    }
    varN = float(args[2]);
    if (varN >= 1 && varN <= 1.4)
    {
        player.sizeN = varN;
        confirmSize("font size", varN, player);
    }
    else
    {
        player tell("^1ERROR VALUE -> 1 a 1.4");
    }
}

updateShader(args, player)
{
    if (!isdefined(args[2]))
    {
        player tell("^1ERROR -> ^1#barzm shader <0 - 1>");
        return;
    }
    varN = int(args[2]);
    if (varN >= 0 && varN <= 1)
    {
        player.shaderON = varN;
        confirmShader(varN, player);
    }
    else
    {
        player tell("^1ERROR VALUE -> 0 a 1");
    }
}

confirmSize(type, value, player)
{
    if(player.langLEN == 1) 
    {
        player tell("^2Bar adjusted: " + type + " " + value);
    }
    else if(player.langLEN == 0) 
    {
        player tell("^2Barra ajustada: " + type + " " + value);
    }
}

confirmShader(value, player)
{
    if(player.langLEN == 1) 
    {
        player tell("^2Shader adjusted: " + value);
    }
    else if(player.langLEN == 0) 
    {
        player tell("^2Shader ajustado: " + value);
    }
}

updateLanguage(args, player)
{
    if (isDefined(args[1]))
    {
        if (args[1] == "en" || args[1] == "EN")
        {
            if (player.langLEN != 1)
            {
                player.langLEN = 1;
                player tell("The script has been translated to English.");
            }
            else
            {
                player tell("The script is already in English.");
            }
        }
        else if (args[1] == "es" || args[1] == "ES")
        {
            if (player.langLEN != 0)
            {
                player.langLEN = 0;
                player tell("El script ha sido traducido al Español.");
            }
            else
            {
                player tell("El script ya está en Español.");
            }
        }
    }
}



helpcommand()
{
    if(self.definido_comandos == 1)
    {
        if(self.langLEN == 1)
        {
            self tell("Wait for the commands to finish displaying");
        }
        else if(self.langLEN == 0)
        {
            self tell("Espera a que se terminen de mostrar los comandos");
        }
    }
    else if(self.definido_comandos == 0)
    {
        
        self.definido_comandos = 1;

        
        hud = create_simple_hud_element();
        hud.x = 0.1; hud.y = 0.1; hud.fontScale = 1; 

        
        if(self.langLEN == 1)
        {
            hud setText("^1#^7barzm ^6color ^7<^30-21^7> <- Change color\n^1#^7barzm ^6sizew ^7<^350-105^7> <- Ancho\n^1#^7barzm ^6name ^7<^30-1^7> <- Zombie Nombre");
        }
        else if(self.langLEN == 0)
        {
            hud setText("^1#^7barzm ^6color ^7<^30-21^7> <- Cambia color\n^1#^7barzm ^6sizew ^7<^350-105^7> <- Ancho\n^1#^7barzm ^6name ^7<^30-1^7> <- Zombie Nombre");
        }
        wait(10); 

        
        if(self.langLEN == 1)
        {
            hud setText("^1#^7barzm ^6sizeh ^7<^32-4^7> <- Height\n^1#^7barzm ^6sizen ^7<^31-1.4^7> <- Font size\n^3^1#^7barzm ^6shader <^30-1> ^7<- Black shader");
        }
        else if(self.langLEN == 0)
        {
            hud setText("^1#^7barzm ^6sizeh ^7<^32-4^7> <- Altura\n^1#^7barzm ^6sizen ^7<^31-1.4^7> <- Tamaño de fuente\n^1#^4barzm ^6shader <^30-1> ^7<- Shader negro");
        }
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


toggleHealthBar(shader_enabled, show_name, size_height, size_width, size_name, color_position)
{
    self endon("disconnect");
    level endon("end_game");
    
    
    self notify("toggling_health_bar");
    self endon("toggling_health_bar");
    
    
    if (!isDefined(shader_enabled))
    {
        
        self notify("stop_zombie_health_config");
        
        
        if (isDefined(self.hud_zombie_health))
        {
            if (isDefined(self.hud_zombie_health.bar))
            {
                self.hud_zombie_health.bar destroy();
                self.hud_zombie_health.bar = undefined;
            }
                
            self.hud_zombie_health destroy();
            self.hud_zombie_health = undefined;
        }
        
        
        if (isDefined(self.hud_zombie_name_label))
        {
            self.hud_zombie_name_label destroy();
            self.hud_zombie_name_label = undefined;
        }

        if (isDefined(self.hud_zombie_health_current_label))
        {
            self.hud_zombie_health_current_label destroy();
            self.hud_zombie_health_current_label = undefined;
        }

        if (isDefined(self.hud_zombie_health_max_label))
        {
            self.hud_zombie_health_max_label destroy();
            self.hud_zombie_health_max_label = undefined;
        }
        
        
        self.healthbarzombie_active = false;
        
        
        self notify("end_colorBAR");
            
        return;
    }
    
    
    if (isDefined(self.healthbarzombie_active) && self.healthbarzombie_active)
    {
        self notify("stop_zombie_health_config");
        
        if (isDefined(self.hud_zombie_health))
        {
            if (isDefined(self.hud_zombie_health.bar))
            {
                self.hud_zombie_health.bar destroy();
                self.hud_zombie_health.bar = undefined;
            }
                
            self.hud_zombie_health destroy();
            self.hud_zombie_health = undefined;
        }
        
        if (isDefined(self.hud_zombie_name_label))
        {
            self.hud_zombie_name_label destroy();
            self.hud_zombie_name_label = undefined;
        }

        if (isDefined(self.hud_zombie_health_current_label))
        {
            self.hud_zombie_health_current_label destroy();
            self.hud_zombie_health_current_label = undefined;
        }

        if (isDefined(self.hud_zombie_health_max_label))
        {
            self.hud_zombie_health_max_label destroy();
            self.hud_zombie_health_max_label = undefined;
        }
        
        
        self notify("end_colorBAR");
        
        
        wait 0.05;
    }
    
    
    if (!isDefined(shader_enabled))
        shader_enabled = self.shaderON;
    else
        self.shaderON = shader_enabled;
        
    if (!isDefined(show_name))
        show_name = self.zombieNAME;
    else
        self.zombieNAME = show_name;
        
    if (!isDefined(size_height))
        size_height = self.sizeH;
    else
        self.sizeH = size_height;
        
    if (!isDefined(size_width))
        size_width = self.sizeW;
    else
        self.sizeW = size_width;
        
    if (!isDefined(size_name))
        size_name = self.sizeN;
    else
        self.sizeN = size_name;
    
    
    
    
    
    
    self notify("end_colorBAR");
    
    
    if (!isDefined(self.colorcito))
        self.colorcito = (1, 1, 1);
    
    
    if (isDefined(color_position) && color_position != "default")
    {
        
        color_index = 0; 
        
        
        if(color_position == "rojo")
            color_index = 1;
        else if(color_position == "verde")
            color_index = 2;
        else if(color_position == "azul")
            color_index = 3;
        else if(color_position == "amarillo")
            color_index = 4;
        else if(color_position == "magenta")
            color_index = 5;
        else if(color_position == "cian")
            color_index = 6;
        else if(color_position == "blanco")
            color_index = 7;
        else if(color_position == "negro")
            color_index = 8;
        else if(color_position == "rojoosc")
            color_index = 9;
        else if(color_position == "verdeosc")
            color_index = 10;
        else if(color_position == "azulosc")
            color_index = 11;
        else if(color_position == "amarilloosc")
            color_index = 12;
        else if(color_position == "magentaosc")
            color_index = 13;
        else if(color_position == "cianosc")
            color_index = 14;
        else if(color_position == "grisclaro")
            color_index = 15;
        else if(color_position == "grisosc")
            color_index = 16;
        else if(color_position == "naranja")
            color_index = 17;
        else if(color_position == "marron")
            color_index = 18;
        else if(color_position == "rosa")
            color_index = 19;
        else if(color_position == "purpura")
            color_index = 20;
        else if(color_position == "verdeclaro")
            color_index = 21;
        else
            color_index = 7; 
        
        
        self thread colorBAR(color_index);
    }
    else
    {
        
        self thread colorBAR(7);
    }
    
    
    self.healthbarzombie_active = true;
    
    
    self thread maintain_zombie_health_config();
}


maintain_zombie_health_config()
{
    self endon("disconnect");
    self endon("stop_zombie_health_config");
    level endon("end_game");
    
    
    self notify("stop_previous_maintain_config");
    self endon("stop_previous_maintain_config");
    
    while(true)
    {
        if (isDefined(self.hud_zombie_health))
        {
            
            if (isDefined(self.hud_zombie_health.width) && isDefined(self.sizeW))
                self.hud_zombie_health.width = self.sizeW;
                
            if (isDefined(self.hud_zombie_health.height) && isDefined(self.sizeH))
                self.hud_zombie_health.height = self.sizeH;
                
            if (isDefined(self.hud_zombie_health.alpha) && isDefined(self.shaderON))
                self.hud_zombie_health.alpha = self.shaderON;
                
            
            if (isDefined(self.hud_zombie_health.bar))
            {
                if (isDefined(self.hud_zombie_health.bar.width) && isDefined(self.sizeW))
                    self.hud_zombie_health.bar.width = self.sizeW;
            }
        }
        
        if (isDefined(self.hud_zombie_name_label) && isDefined(self.sizeN))
        {
            if (isDefined(self.hud_zombie_name_label.fontScale))
                self.hud_zombie_name_label.fontScale = self.sizeN;
        }
        
        if (isDefined(self.hud_zombie_health_current_label) && isDefined(self.sizeN))
        {
            if (isDefined(self.hud_zombie_health_current_label.fontScale))
                self.hud_zombie_health_current_label.fontScale = self.sizeN;
        }
        
        if (isDefined(self.hud_zombie_health_max_label) && isDefined(self.sizeN))
        {
            if (isDefined(self.hud_zombie_health_max_label.fontScale))
                self.hud_zombie_health_max_label.fontScale = self.sizeN;
        }
        
        wait 0.25; 
    }
}


destroy_zombie_health_bar()
{
    
    self notify("stop_zombie_health_config");
    self notify("end_colorBAR");
    
    
    if (isDefined(self.hud_zombie_health))
    {
        if (isDefined(self.hud_zombie_health.bar))
            self.hud_zombie_health.bar destroy();
            
        self.hud_zombie_health destroy();
        self.hud_zombie_health = undefined;
    }
    
    
    if (isDefined(self.hud_zombie_name_label))
    {
        self.hud_zombie_name_label destroy();
        self.hud_zombie_name_label = undefined;
    }

    if (isDefined(self.hud_zombie_health_current_label))
    {
        self.hud_zombie_health_current_label destroy();
        self.hud_zombie_health_current_label = undefined;
    }

    if (isDefined(self.hud_zombie_health_max_label))
    {
        self.hud_zombie_health_max_label destroy();
        self.hud_zombie_health_max_label = undefined;
    }
    
    
    self.healthbarzombie_active = false;
}


is_panzer_soldat(entity)
{
    
    if(isDefined(entity.model))
    {
        
        panzer_models = [];
        panzer_models[0] = "c_zom_dlc3_mech_z";
        panzer_models[1] = "c_zom_mechz";
        panzer_models[2] = "mechz_zombie";
        panzer_models[3] = "c_zom_mech_zombie";
        panzer_models[4] = "zm_mech_zombie";
        panzer_models[5] = "c_zom_tomb_mechz";
        panzer_models[6] = "c_zom_tomb_mech_zombie";
        panzer_models[7] = "c_zom_dlc4_mechz";
        
        
        for(i = 0; i < panzer_models.size; i++)
        {
            if(entity.model == panzer_models[i])
                return true;
        }
    }
    
    
    if(isDefined(entity.spawner))
    {
        if(isDefined(entity.spawner.classname) && (entity.spawner.classname == "mechz_zombie" || entity.spawner.classname == "mech_zombie" || entity.spawner.classname == "zombie_mechz"))
            return true;
    }
    
    
    if(isDefined(entity.zombie_move_speed) && entity.zombie_move_speed == "mechz_speed")
        return true;
        
    if(isDefined(entity.mechz) && entity.mechz)
        return true;
        
    if(isDefined(entity.is_mechz) && entity.is_mechz)
        return true;
    
    
    if(isDefined(entity.zombie_type) && (entity.zombie_type == "mechz" || entity.zombie_type == "mech_zombie"))
        return true;
    
    return false;
}

