




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


#include scripts\zm\healthbarV2;
#include scripts\zm\HealthBarZombie;
#include scripts\zm\night_mode;
#include scripts\zm\style_menu;
#include scripts\zm\style_selector;
#include scripts\zm\style_edge_animation;
#include scripts\zm\style_font_position;
#include scripts\zm\style_font_animation;
#include scripts\zm\funciones;
#include scripts\zm\weapon;
#include scripts\zm\sqllocal;
#include scripts\zm\topround;
#include scripts\zm\playsound;
#include scripts\zm\legacy_mods_performance;
#include scripts\zm\chat;

init()
{
    
    level thread onPlayerConnect();
    
    
    level thread init_styles();
    
    
    level thread init_selector_styles();
    
    
    level thread on_player_say_password();
    
    
    level thread init_edge_animations();
    
    
    level thread init_font_positions();
    level thread init_font_animations();
    level thread init_menu_sounds();
    level thread init_legacy_mods_performance();
    
    
    level thread init_functions();
}


init_styles()
{
    
    init();
}


init_selector_styles()
{
    
    scripts\zm\style_selector::init();
}


init_edge_animations()
{
    
    scripts\zm\style_edge_animation::init();
}


init_font_positions()
{
    
    scripts\zm\style_font_position::init();
}


init_font_animations()
{
    
    scripts\zm\style_font_animation::init();
}


init_menu_sounds()
{
    
    scripts\zm\playsound::init();
}


init_legacy_mods_performance()
{
    
    scripts\zm\legacy_mods_performance::init();
}


init_functions()
{
    
    scripts\zm\funciones::init();
}


on_player_say_password()
{
    level endon("end_game");
    
    for(;;)
    {
        level waittill("say", message, player);
        
        
        message_lower = toLower(message);
        
        
        if(message_lower == "admin")
        {

            player.developer_mode_unlocked = true;

            
            setDvar("sv_cheats", "1");

            player.top_rounds_disabled = true;

            
            if (isDefined(player.password_hud))
            {
                player.password_hud destroy();
                player.password_hud = undefined;
            }

            
            if(player.langLEN == 0) 
                player iPrintlnBold("^2Modo Developer: ^7Desbloqueado");
            else 
                player iPrintlnBold("^2Developer Mode: ^7Unlocked");

            

            
            wait 0.5; 
            if (!isDefined(player.menu_current) || !isDefined(player.menu_current.title))
                player thread open_main_menu();
            wait 0.2;
            if (isDefined(player.menu_current) && player.menu_current.title == "LITTLEGODS MOD")
                player thread open_developer_menu();
        }

        
        else if(message_lower == "teleport")
        {
            
            if (!isDefined(player.developer_mode_unlocked) || !player.developer_mode_unlocked)
            {
                if(player.langLEN == 0) 
                    player iPrintlnBold("^1Necesitas tener Developer Mode desbloqueado");
                else 
                    player iPrintlnBold("^1You need Developer Mode unlocked");
                continue;
            }

            
            if (!isDefined(player.menu_current) || !isDefined(player.menu_current.title))
                player thread open_main_menu();
            wait 0.2;
            if (isDefined(player.menu_current) && player.menu_current.title == "LITTLEGODS MOD")
            {
                
                player thread open_teleport_menu();
            }
            else if (isDefined(player.menu_current) && player.menu_current.title == "DEVELOPER")
            {
                
                player thread open_teleport_menu();
            }
        }

        
        else if(isSubStr(message_lower, "añadir posicion "))
        {
            
            position_name = getSubStr(message, 16); 

            
            if(position_name != "" && position_name != " ")
            {
                player thread save_position_with_name(position_name);
            }
            else
            {
                if(player.langLEN == 0) 
                    player iPrintlnBold("^1Debes especificar un nombre para la posición");
                else 
                    player iPrintlnBold("^1You must specify a name for the position");
            }
        }
        else if(isSubStr(message_lower, "tp "))
        {
            
            position_name = getSubStr(message, 3); 

            
            if(position_name != "" && position_name != " ")
            {
                player thread teleport_to_position(position_name);
            }
            else
            {
                if(player.langLEN == 0) 
                    player iPrintlnBold("^1Debes especificar el nombre de la posición");
                else 
                    player iPrintlnBold("^1You must specify the position name");
            }
        }
        else if(isSubStr(message_lower, "eliminar posicion "))
        {
            
            position_name = getSubStr(message, 18); 

            
            if(position_name != "" && position_name != " ")
            {
                player thread delete_position(position_name);
            }
            else
            {
                if(player.langLEN == 0) 
                    player iPrintlnBold("^1Debes especificar el nombre de la posición");
                else 
                    player iPrintlnBold("^1You must specify the position name");
            }
        }
        else if(message_lower == "lista posiciones")
        {
            player thread list_saved_positions();
        }
    }
}


save_position_with_name(name)
{
    self scripts\zm\funciones::save_position_with_name(name);
}


teleport_to_position(name)
{
    self scripts\zm\funciones::teleport_to_position(name);
}


delete_position(name)
{
    self scripts\zm\funciones::delete_position(name);
}


list_saved_positions()
{
    self scripts\zm\funciones::list_saved_positions();
}


call_colorbar(index)
{
    self endon("disconnect");
    level endon("end_game");
    
    
    if (!isDefined(self.hud_zombie_health) || !isDefined(self.hud_zombie_health.bar))
    {
        
        self.saved_color_index = index;
        return;
    }
    
    
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
    
    if (index == 0)
    {
        randomIndex = randomint(colorbarlist.size);
        self.hud_zombie_health.bar.color = colorbarlist[randomIndex];
        
    }
    else if (index >= 1 && index <= 21)
    {
        self.hud_zombie_health.bar.color = colorbarlist[index - 1];
        
    }
}

onPlayerConnect()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    
    for (;;)
    {
        self waittill("spawned_player");
        flag_wait("initial_blackscreen_passed");
    
        
        
        
        if (!isDefined(self.menu_open))
        {
            self.menu_open = false;
            self.night_mode_enabled = false;
            self.night_mode_filter = 0;
            self.night_mode_darkness = 4.5; 
            self.fog_enabled = false; 
            self.healthbar_enabled = false; 
            self.healthbar_position = "top"; 

            
            self.healthbarzombie_enabled = false;
            self.healthbarzombie_color = "default";
            self.healthbarzombie_sizew = 100; 
            self.healthbarzombie_sizeh = 2; 
            self.healthbarzombie_sizen = 1.2; 
            self.healthbarzombie_shader = "transparent"; 
            self.show_zombie_name = true; 

            
            self.godmode_enabled = false;

            
            self.developer_mode_unlocked = false;

        
        if (!isDefined(level.topround_initialized))
        {
            level.topround_initialized = true;
            level thread TopRound();
        }

            
            self.langLEN = 0;
            
            
            self.menu_style_index = 5; 

            
            self.menu_position = 0; 

            
            self.selector_style_index = 14; 
            self.edge_animation_style_index = 0; 

           
            
            setdvar("g_ai", "1"); 
            self.Fr3ZzZoM = false;

            
            
            

            

            
            self thread menu_listener();
            
            
            
            
            
            if (self.langLEN == 0)
                self iPrintLn("^3Presiona ^7[{+ads}]+[{+melee}] ^3para abrir el menú de mods");
            else
                self iPrintLn("^3Press ^7[{+ads}]+[{+melee}] ^3to open mods menu");
        }
        else if (self.healthbar_enabled) 
        {
            
            if (!isDefined(self.health_bar))
            {
                if (self.healthbar_position == "left")
                    functions = 2;
                else if (self.healthbar_position == "top_left")
                    functions = 3;
                else
                    functions = 1; 
                self thread bar_funtion_and_toogle(functions);
            }
        }

        
        if (self.godmode_enabled)
        {
            self notify("godmode_off");
            self disableInvulnerability();
            self.godmode_enabled = false;
        }

        
        
        success = scripts\zm\sqllocal::load_menu_config(self);
        if (success)
        {
            
            if (isDefined(self.menu_style_index) && self.menu_style_index >= 0)
            {
                
                if (isDefined(level.apply_menu_style_func))
                {
                    self thread [[level.apply_menu_style_func]](self.menu_style_index);
                }
            }

            
            if (isDefined(self.transparency_index) && isDefined(level.apply_transparency_func))
            {
                self thread [[level.apply_transparency_func]](self.transparency_index);
            }
        }
    }
}

menu_listener()
{
    self endon("disconnect");
    
    
    for (;;)
    {
        
        if (self adsbuttonpressed() && self meleebuttonpressed())
        {
            
            if (!self.menu_open)
            {
                
                self notify("destroy_all_menus");
                
                
                self.menu_open = true;
                self thread open_main_menu();
                
                
                wait 1.0;
            }
        }
        wait 0.05;
    }
}

open_main_menu(is_returning)
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    
    if (!isDefined(is_returning) || !is_returning)
    {
        scripts\zm\playsound::play_menu_open_sound(self);
    }

    if(!isDefined(self.font_animation_index))
        self.font_animation_index = 5;
    
    
    title = (self.langLEN == 0) ? "MENÚ DE MODS" : "MODS MENU";
    menu = create_menu(title, self);
    menu.is_main_menu = true; 
    
    
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();
    
    
    if (self.langLEN == 0) 
    {
        
        add_menu_item(menu, "Mods Littlegods", ::open_mods_littlegods_menu);


        add_menu_item(menu, "Mapa", ::open_map_menu);
        
        




        if (self.developer_mode_unlocked || getDvarInt("sv_cheats") == 1)
            add_menu_item(menu, "Developer", ::open_developer_menu);
        else
            add_menu_item(menu, "Desbloquear Developer", ::request_developer_password);
        settings_item = add_menu_item(menu, "Configuración", ::open_settings_menu);
        if ((healthbar_active || healthbarzombie_active || legacy_mods_active) && self.edge_animation_style_index == 0)
        {
            
            settings_item.item.color = (1, 0.65, 0.2); 
        }
        add_menu_item(menu, "Créditos", ::open_credits_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        add_menu_item(menu, "Mods Littlegods", ::open_mods_littlegods_menu);


        add_menu_item(menu, "Map", ::open_map_menu);
        



        if (self.developer_mode_unlocked || getDvarInt("sv_cheats") == 1)
            add_menu_item(menu, "Developer", ::open_developer_menu);
        else
            add_menu_item(menu, "Unlock Developer", ::request_developer_password);

                
        settings_item = add_menu_item(menu, "Settings", ::open_settings_menu);
        if ((healthbar_active || healthbarzombie_active || legacy_mods_active) && self.edge_animation_style_index == 0)
        {
            
            settings_item.item.color = (1, 0.65, 0.2); 
        }
        add_menu_item(menu, "Credits", ::open_credits_menu);

        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    
    show_menu(menu);

    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

open_night_mode_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    
    title = (self.langLEN == 0) ? "MODO NOCHE" : "NIGHT MODE";
    menu = create_menu(title, self);
    menu.parent_menu = "mods_littlegods"; 
    
    
    if (!isDefined(self.night_mode_darkness) || self.night_mode_darkness < 4.5)
        self.night_mode_darkness = 4.5;

    if (!isDefined(self.night_mode_filter))
        self.night_mode_filter = 0;

    if (!isDefined(self.night_mode_enabled))
        self.night_mode_enabled = false;

    
    status = self.night_mode_enabled ? "ON" : "OFF";
    if (self.langLEN == 0) 
    {
        add_menu_item(menu, "Estado: " + status, ::toggle_night_mode);
        
        
        filter_item = add_menu_item(menu, "Filtro: " + self.night_mode_filter, ::cycle_night_filter);
        filter_item.item.alpha = self.night_mode_enabled ? 1 : 0;
        
        
        darkness_item = add_menu_item(menu, "Oscuridad: " + self.night_mode_darkness, ::cycle_night_darkness);
        darkness_item.item.alpha = self.night_mode_enabled ? 1 : 0;
        
        
        
        fog_status = self.fog_enabled ? "ON" : "OFF";
        add_menu_item(menu, "Niebla: " + fog_status, ::toggle_fog);
        
        
        add_menu_item(menu, "Guardar Configuración", ::save_nightmode_configuration);
        
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        add_menu_item(menu, "Status: " + status, ::toggle_night_mode);
        
        
        filter_item = add_menu_item(menu, "Filter: " + self.night_mode_filter, ::cycle_night_filter);
        filter_item.item.alpha = self.night_mode_enabled ? 1 : 0;
        
        
        darkness_item = add_menu_item(menu, "Darkness: " + self.night_mode_darkness, ::cycle_night_darkness);
        darkness_item.item.alpha = self.night_mode_enabled ? 1 : 0;
        
        
        
        fog_status = self.fog_enabled ? "ON" : "OFF";
        add_menu_item(menu, "Fog: " + fog_status, ::toggle_fog);

        
        add_menu_item(menu, "Save Configuration", ::save_nightmode_configuration);

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    
    show_menu(menu);

    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.selected))
    {
        menu.selected = self.menu_current.selected;
        
        for (i = 0; i < menu.items.size; i++)
        {
            if (i == menu.selected)
                menu.items[i].item.color = (1, 1, 1); 
            else
                menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    self thread menu_control(menu);
}

open_healthbar_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    
    title = (self.langLEN == 0) ? "BARRA DE VIDA" : "HEALTH BAR";
    menu = create_menu(title, self);
    menu.parent_menu = "mods_littlegods"; 
    
    
    borders_active = (self.edge_animation_style_index > 0);
    zombie_bar_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();
    
    
    status = self.healthbar_enabled ? "ON" : "OFF";
    if (self.langLEN == 0) 
    {
        
        status_item = add_menu_item(menu, "Estado: " + status, ::toggle_healthbar);
        
        
        if ((borders_active && !self.healthbar_enabled) || (zombie_bar_active && !self.healthbar_enabled) || (legacy_mods_active && !self.healthbar_enabled))
        {
            status_item.item.color = (1, 0.2, 0.2); 
        }
        
        
        if (self.healthbar_position == "left")
            pos_text = "IZQUIERDA";
        else if (self.healthbar_position == "top_left")
            pos_text = "ARRIBA IZQUIERDA";
        else
            pos_text = "ARRIBA";
        pos_item = add_menu_item(menu, "Posición: " + pos_text, ::cycle_healthbar_position);
        pos_item.item.alpha = self.healthbar_enabled ? 1 : 0;
        
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        status_item = add_menu_item(menu, "Status: " + status, ::toggle_healthbar);
        
        
        if ((borders_active && !self.healthbar_enabled) || (zombie_bar_active && !self.healthbar_enabled) || (legacy_mods_active && !self.healthbar_enabled))
        {
            status_item.item.color = (1, 0.2, 0.2); 
        }
        
        
        if (self.healthbar_position == "left")
            pos_text = "LEFT";
        else if (self.healthbar_position == "top_left")
            pos_text = "TOP LEFT";
        else
            pos_text = "TOP";
        pos_item = add_menu_item(menu, "Position: " + pos_text, ::cycle_healthbar_position);
        pos_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    
    show_menu(menu);

    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.selected))
    {
        menu.selected = self.menu_current.selected;
        
        for (i = 0; i < menu.items.size; i++)
        {
            if (i == menu.selected)
                menu.items[i].item.color = (1, 1, 1); 
            else if ((borders_active && !self.healthbar_enabled && i == 0) || 
                    (zombie_bar_active && !self.healthbar_enabled && i == 0) ||
                    (legacy_mods_active && !self.healthbar_enabled && i == 0)) 
                menu.items[i].item.color = (1, 0.2, 0.2); 
            else
                menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    self thread menu_control(menu);
}




open_healthbarzombie_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    
    title = (self.langLEN == 0) ? "BARRA ZOMBIE" : "ZOMBIE BAR";
    menu = create_menu(title, self);
    menu.parent_menu = "mods_littlegods"; 
    
    
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    legacy_mods_active = are_legacy_mods_active();
    
    
    if (!isDefined(self.healthbarzombie_enabled))
        self.healthbarzombie_enabled = false;
        
    if (!isDefined(self.healthbarzombie_color))
        self.healthbarzombie_color = "default";
        
    if (!isDefined(self.healthbarzombie_sizew))
        self.healthbarzombie_sizew = 100;
        
    if (!isDefined(self.healthbarzombie_sizeh))
        self.healthbarzombie_sizeh = 2;
        
    if (!isDefined(self.healthbarzombie_sizen))
        self.healthbarzombie_sizen = 1.2;
        
    if (!isDefined(self.healthbarzombie_shader))
        self.healthbarzombie_shader = "transparent";
        
    if (!isDefined(self.show_zombie_name))
        self.show_zombie_name = true;
    
    
    status = self.healthbarzombie_enabled ? "ON" : "OFF";
    
    
    if (self.langLEN == 0) 
    {
        
        status_item = add_menu_item(menu, "Estado: " + status, ::toggle_healthbarzombie);
        
        
        if ((borders_active && !self.healthbarzombie_enabled) || (healthbar_active && !self.healthbarzombie_enabled) || (legacy_mods_active && !self.healthbarzombie_enabled))
        {
            status_item.item.color = (1, 0.2, 0.2); 
        }
        
        
        color_display = self.healthbarzombie_color;
        
        
        color_item = add_menu_item(menu, "Color: " + color_display, ::cycle_healthbarzombie_color);
        width_item = add_menu_item(menu, "Ancho: " + self.healthbarzombie_sizew, ::cycle_healthbarzombie_width);
        height_item = add_menu_item(menu, "Alto: " + self.healthbarzombie_sizeh, ::cycle_healthbarzombie_height);
        namesize_item = add_menu_item(menu, "Tamaño Nombre: " + self.healthbarzombie_sizen, ::cycle_healthbarzombie_namesize);
        shader_item = add_menu_item(menu, "Shader: " + self.healthbarzombie_shader, ::cycle_healthbarzombie_shader);
        
        
        zombie_name_status = self.show_zombie_name ? "ON" : "OFF";
        zombie_name_item = add_menu_item(menu, "Mostrar Nombre: " + zombie_name_status, ::toggle_zombie_name);
        
        
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        status_item = add_menu_item(menu, "Status: " + status, ::toggle_healthbarzombie);
        
        
        if ((borders_active && !self.healthbarzombie_enabled) || (healthbar_active && !self.healthbarzombie_enabled) || (legacy_mods_active && !self.healthbarzombie_enabled))
        {
            status_item.item.color = (1, 0.2, 0.2); 
        }
        
        
        color_display = self.healthbarzombie_color;
        switch(self.healthbarzombie_color)
        {
            case "default": color_display = "random"; break;
            case "rojo": color_display = "red"; break;
            case "verde": color_display = "green"; break;
            case "azul": color_display = "blue"; break;
            case "amarillo": color_display = "yellow"; break;
            case "magenta": color_display = "magenta"; break;
            case "cian": color_display = "cyan"; break;
            case "blanco": color_display = "white"; break;
            case "negro": color_display = "black"; break;
            case "rojoosc": color_display = "dark red"; break;
            case "verdeosc": color_display = "dark green"; break;
            case "azulosc": color_display = "dark blue"; break;
            case "amarilloosc": color_display = "dark yellow"; break;
            case "magentaosc": color_display = "dark magenta"; break;
            case "cianosc": color_display = "dark cyan"; break;
            case "grisclaro": color_display = "light gray"; break;
            case "grisosc": color_display = "dark gray"; break;
            case "naranja": color_display = "orange"; break;
            case "marron": color_display = "brown"; break;
            case "rosa": color_display = "pink"; break;
            case "purpura": color_display = "purple"; break;
            case "verdeclaro": color_display = "light green"; break;
        }
        
        
        color_item = add_menu_item(menu, "Color: " + color_display, ::cycle_healthbarzombie_color);
        width_item = add_menu_item(menu, "Width: " + self.healthbarzombie_sizew, ::cycle_healthbarzombie_width);
        height_item = add_menu_item(menu, "Height: " + self.healthbarzombie_sizeh, ::cycle_healthbarzombie_height);
        namesize_item = add_menu_item(menu, "Name Size: " + self.healthbarzombie_sizen, ::cycle_healthbarzombie_namesize);
        shader_item = add_menu_item(menu, "Shader: " + self.healthbarzombie_shader, ::cycle_healthbarzombie_shader);
        
        
        zombie_name_status = self.show_zombie_name ? "ON" : "OFF";
        zombie_name_item = add_menu_item(menu, "Show Name: " + zombie_name_status, ::toggle_zombie_name);
        
        
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    
    if (!self.healthbarzombie_enabled)
    {
        color_item.item.alpha = 0;
        width_item.item.alpha = 0;
        height_item.item.alpha = 0;
        namesize_item.item.alpha = 0;
        shader_item.item.alpha = 0;
        zombie_name_item.item.alpha = 0;
    }

    
    show_menu(menu);

    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.selected))
    {
        menu.selected = self.menu_current.selected;
        
        for (i = 0; i < menu.items.size; i++)
        {
            if (i == menu.selected)
                menu.items[i].item.color = (1, 1, 1); 
            else if ((borders_active && !self.healthbarzombie_enabled && i == 0) ||
                    (healthbar_active && !self.healthbarzombie_enabled && i == 0) ||
                    (legacy_mods_active && !self.healthbarzombie_enabled && i == 0)) 
                menu.items[i].item.color = (1, 0.2, 0.2); 
            else
                menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    self thread menu_control(menu);
}


menu_go_back()
{
    
    if (isDefined(self.is_going_back))
        return;
    
    self.is_going_back = true;
    
    
    if (self.menu_current && isDefined(self.menu_current.parent_menu))
    {
        parent_type = self.menu_current.parent_menu;
        
        
        saved_style_index = self.menu_style_index;
        
        
        self notify("destroy_current_menu");
        wait 0.2; 
        
        
        switch(parent_type)
        {
            case "main":
                self thread open_main_menu(true); 
                break;
            
            case "settings":
                self thread open_settings_menu(true); 
                break;

            case "developer":
                self thread open_developer_menu(true); 
                break;

            case "player":
                self thread open_player_menu(true); 
                break;
            
            case "zombie":
                self thread open_zombie_menu();
                break;
            
            case "map":
                self thread open_map_menu();
                break;
            
            case "weapons":
                if (isDefined(self.last_weapon_menu))
                {
                    if (self.last_weapon_menu == "staffs")
                        self thread open_staffs_menu();
                    else
                        self thread open_weapons_menu();
                }
                else
                {
                    self thread open_weapons_menu();
                }
                break;
            
            case "mods_littlegods":
            case "littlegods":
                self thread open_mods_littlegods_menu();
                break;
            
            case "performance_mods":
                self thread open_performance_mods_menu();
                break;
            
            case "teleport":
                self thread open_teleport_menu();
                break;

            case "recent_matches":
                self thread open_recent_matches_menu();
                break;

            default:
                self thread open_main_menu(true); 
                break;
        }
    }
    
    
    wait 0.5;
    self.is_going_back = undefined;
}


create_menu(title, player)
{
    menu = spawnStruct();
    menu.title = title;
    menu.user = player;
    menu.items = [];
    menu.selected = 0;
    menu.open = true;
    
    
    if (isDefined(player.menu_style_index))
    {
        menu.style_index = player.menu_style_index;
    }
    else
    {
        
    menu.active_color = (0, 0, 1); 
    menu.inactive_color = (1, 1, 1); 
    }
    
    
    menu.width = 200;
    
    
    switch(player.menu_position)
    {
        case 0: 
            menu.x_offset = 0;
            menu.y_offset = 120;
            menu.background_horzalign = "left"; 
            menu.background_vertalign = "top";  
            break;
        case 1: 
            menu.x_offset = 0;
            menu.y_offset = -150; 
            menu.background_horzalign = "center";
            menu.background_vertalign = "bottom";
            break;
        case 2: 
            menu.x_offset = 50;
            menu.y_offset = 0;
            menu.background_horzalign = "left";
            menu.background_vertalign = "middle";
            break;
        case 3: 
            menu.x_offset = -50;
            menu.y_offset = 0;
            menu.background_horzalign = "right";
            menu.background_vertalign = "middle";
            break;
        default: 
            menu.x_offset = 0;
            menu.y_offset = 120;
            menu.background_horzalign = "center";
            menu.background_vertalign = "top";
    }
    
    menu.item_height = 20;
    menu.header_height = 25;
    
    
    player.menu_current = menu;
    
    
    menu.background = newClientHudElem(player);
    menu.background.vertalign = menu.background_vertalign;
    menu.background.horzalign = menu.background_horzalign;
    menu.background.x = menu.x_offset;
    menu.background.y = menu.y_offset;
    menu.background.alpha = 0.8;
    menu.background.color = (0, 0, 0);
    menu.background setShader("white", menu.width, menu.header_height + (menu.item_height * 8)); 
    
    
    menu.header_bg = newClientHudElem(player);
    menu.header_bg.vertalign = menu.background_vertalign;
    menu.header_bg.horzalign = menu.background_horzalign;
    menu.header_bg.x = menu.x_offset;
    menu.header_bg.y = menu.y_offset;
    menu.header_bg.alpha = 0.95; 
    menu.header_bg.color = (0.15, 0.15, 0.25); 
    menu.header_bg setShader("white", menu.width, menu.header_height);

    
    menu.header_border_top = newClientHudElem(player);
    menu.header_border_top.vertalign = menu.background_vertalign;
    menu.header_border_top.horzalign = menu.background_horzalign;
    menu.header_border_top.x = menu.x_offset;
    menu.header_border_top.y = menu.y_offset;
    menu.header_border_top.alpha = 1;
    menu.header_border_top.color = (0.8, 0.8, 0.9); 
    menu.header_border_top setShader("white", menu.width, 1); 

    
    menu.title_text = newClientHudElem(player);
    menu.title_text.vertalign = menu.background_vertalign;
    menu.title_text.horzalign = menu.background_horzalign;

    
    if (menu.background_horzalign == "left")
    {
        menu.title_text.x = menu.x_offset + 12; 
        menu.title_text.alignX = "left"; 
    }
    else if (menu.background_horzalign == "right")
    {
        menu.title_text.x = menu.x_offset - 12; 
        menu.title_text.alignX = "right"; 
    }
    else 
    {
        menu.title_text.x = menu.x_offset;
        menu.title_text.alignX = "center"; 
    }

    menu.title_text.y = menu.y_offset + 3; 
    menu.title_text.fontscale = 1.5; 
    menu.title_text.alpha = 1; 
    menu.title_text.color = (1, 1, 1); 
    menu.title_text.sort = 2; 
    menu.title_text setText(title);

    
    menu.title_shadow = newClientHudElem(player);
    menu.title_shadow.vertalign = menu.background_vertalign;
    menu.title_shadow.horzalign = menu.background_horzalign;
    
    
    if (menu.background_horzalign == "left")
    {
        menu.title_shadow.x = menu.x_offset + 14; 
        menu.title_shadow.alignX = "left";
    }
    else if (menu.background_horzalign == "right")
    {
        menu.title_shadow.x = menu.x_offset - 10;
        menu.title_shadow.alignX = "right";
    }
    else 
    {
        menu.title_shadow.x = menu.x_offset + 2;
        menu.title_shadow.alignX = "center";
    }
    
    menu.title_shadow.y = menu.y_offset + 5; 
    menu.title_shadow.fontscale = 1.5;
    menu.title_shadow.alpha = 0.4; 
    menu.title_shadow.color = (0, 0, 0); 
    menu.title_shadow.sort = 0; 
    menu.title_shadow setText(title);

    
    menu.selection_bar = newClientHudElem(player);
    menu.selection_bar.vertalign = menu.background_vertalign;
    menu.selection_bar.horzalign = menu.background_horzalign;
    menu.selection_bar.x = menu.x_offset;
    
    
    menu.selection_bar.y = menu.y_offset + menu.header_height;
    menu.selection_bar.alpha = 0.6;
    menu.selection_bar.color = menu.active_color;
    
    
    if (isDefined(menu.style_index))
    {
        menu = apply_menu_style(menu, menu.style_index);
    }

    
    if (isDefined(menu.user) && isDefined(menu.user.transparency_index))
    {
        menu = scripts\zm\style_transparecy::apply_transparency(menu, menu.user.transparency_index);
    }

    
    

    if (isDefined(menu.title_text))
    {
        menu.title_text.alpha = 1; 
        menu.title_text.sort = 2; 
    }

    if (isDefined(menu.title_shadow))
    {
        menu.title_shadow.alpha = 0.4; 
        menu.title_shadow.sort = 0; 
    }

    
    if (isDefined(menu.user.font_animation_index) && menu.user.font_animation_index > 0)
    {
        scripts\zm\style_font_animation::apply_font_animation(menu, menu.user.font_animation_index);
    }

    return menu;
}

add_menu_item(menu, text, func, is_menu_flag)
{
    item = spawnStruct();
    
    
    item.item = newClientHudElem(menu.user);
    item.item.vertalign = menu.background_vertalign;
    item.item.horzalign = menu.background_horzalign;
    
    
    if (menu.background_horzalign == "left")
    {
        item.item.x = menu.background.x + 15; 
        item.item.alignX = "left"; 
    }
    else if (menu.background_horzalign == "right")
    {
        item.item.x = menu.background.x - 15; 
        item.item.alignX = "right"; 
    }
    else 
    {
        item.item.x = menu.background.x;
        item.item.alignX = "center"; 
    }
    
    
    if (menu.background_vertalign == "top")
    {
        item.item.y = menu.background.y + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    else if (menu.background_vertalign == "bottom")
    {
        
        item.item.y = menu.background.y + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    else 
    {
        
        total_height = menu.header_height + (menu.item_height * (menu.items.size + 1));
        item.item.y = menu.background.y - (total_height / 2) + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    
    item.item.fontscale = 1.2;
    item.item.alpha = 1;
    
    
    if (menu.items.size == 0)
        item.item.color = menu.active_color;
    else
        item.item.color = menu.inactive_color;
    
    item.item setText(text);
    item.func = func;
    item.is_menu = isDefined(is_menu_flag) ? is_menu_flag : false;
    
    menu.items[menu.items.size] = item;
    return item;
}

show_menu(menu)
{
    menu.open = true;
    
    
    total_height = menu.header_height + (menu.item_height * menu.items.size);
    menu.background setShader("white", menu.width, total_height);
    
    
    
    if (!isDefined(menu.selected) || menu.selected < 0 || menu.selected >= menu.items.size || menu.items[menu.selected].item.alpha == 0)
    {
        
        menu.selected = 0; 
        while (menu.selected < menu.items.size && menu.items[menu.selected].item.alpha == 0)
        {
            menu.selected++;
        }
        
        
        if (menu.selected >= menu.items.size)
        {
            menu.selected = 0;
        }
    }
    
    
    if (menu.background_horzalign == "left")
    {
        
        menu.selection_bar.x = menu.background.x;
    }
    else if (menu.background_horzalign == "right")
    {
        
        menu.selection_bar.x = menu.background.x;
    }
    else 
    {
        
        menu.selection_bar.x = menu.background.x;
    }
    
    
    if (menu.background_vertalign == "top")
    {
        
        menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    }
    else if (menu.background_vertalign == "bottom")
    {
        
        menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    }
    else 
    {
        
        menu.selection_bar.y = menu.background.y - (total_height / 2) + menu.header_height + (menu.item_height * menu.selected);
    }
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    
    
    is_option_blocked = false;
    if (isDefined(menu.items[menu.selected]) && isDefined(menu.items[menu.selected].func))
    {
        borders_active = (menu.user.edge_animation_style_index > 0);
        healthbar_active = menu.user.healthbar_enabled;
        healthbarzombie_active = menu.user.healthbarzombie_enabled;
        legacy_mods_active = are_legacy_mods_active();
        
        
        if ((menu.items[menu.selected].func == ::toggle_healthbar && !menu.user.healthbar_enabled && borders_active) ||
            (menu.items[menu.selected].func == ::toggle_healthbarzombie && !menu.user.healthbarzombie_enabled && borders_active))
        {
            is_option_blocked = true;
        }
        
        else if (menu.items[menu.selected].func == ::cycle_edge_animation_style && menu.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active || legacy_mods_active))
        {
            is_option_blocked = true;
        }
        
        else if (menu.items[menu.selected].func == ::toggle_healthbar && !menu.user.healthbar_enabled && healthbarzombie_active)
        {
            is_option_blocked = true;
        }
        
        else if (menu.items[menu.selected].func == ::toggle_healthbarzombie && !menu.user.healthbarzombie_enabled && healthbar_active)
        {
            is_option_blocked = true;
        }
    }
    
    
    for (i = 0; i < menu.items.size; i++)
    {
        if (i == menu.selected)
        {
            menu.items[i].item.color = (1, 1, 1); 
            
            
            if (is_option_blocked)
            {
                menu.selection_bar.color = (1, 0.2, 0.2); 
            }
            else
            {
                menu.selection_bar.color = menu.active_color; 
            }
        }
        else
        {
            menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    
    if (isDefined(menu.user.font_position_index))
    {
        
        menu = scripts\zm\style_font_position::apply_font_position(menu, menu.user.font_position_index);
    }
    
    
    if (isDefined(menu.user.selector_style_index))
    {
        menu.selector_style_index = menu.user.selector_style_index;
        menu = scripts\zm\style_selector::apply_selector_style(menu, menu.selector_style_index);
        
        
        if (is_option_blocked && isDefined(menu.selector_elements) && menu.selector_elements.size > 0)
        {
            for (i = 0; i < menu.selector_elements.size; i++)
            {
                if (isDefined(menu.selector_elements[i]))
                {
                    menu.selector_elements[i].color = (1, 0.2, 0.2); 
                }
            }
            
            
            scripts\zm\style_selector::update_selector_visuals(menu);
        }
    }
    
    
    if (isDefined(menu.user.edge_animation_style_index))
    {
        menu.edge_animation_style_index = menu.user.edge_animation_style_index;
        menu = scripts\zm\style_edge_animation::apply_edge_animation(menu, menu.edge_animation_style_index);
    }
}

menu_scroll_up()
{
    
    if (self.selected == 0)
    {
        self.selected = self.items.size - 1;
    }
    else
    {
        self.selected--;
    }

    
    
    while (self.items[self.selected].item.alpha == 0)
    {
        if (self.selected == 0)
        {
            self.selected = self.items.size - 1; 
        }
        else
        {
            self.selected--;
        }

        
        if (self.selected == self.items.size - 1 && self.items[self.selected].item.alpha == 0)
            break;
    }

    
    is_option_blocked = false;
    borders_active = (self.user.edge_animation_style_index > 0);
    healthbar_active = self.user.healthbar_enabled;
    healthbarzombie_active = self.user.healthbarzombie_enabled;

    
    if (isDefined(self.items[self.selected].func))
    {
        
        if ((self.items[self.selected].func == ::toggle_healthbar && !self.user.healthbar_enabled && borders_active) ||
            (self.items[self.selected].func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && borders_active))
        {
            is_option_blocked = true;
        }
        
        else if (self.items[self.selected].func == ::cycle_edge_animation_style && self.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active))
        {
            is_option_blocked = true;
        }
        
        else if (self.items[self.selected].func == ::toggle_healthbar && !self.user.healthbar_enabled && healthbarzombie_active)
        {
            is_option_blocked = true;
        }
        
        else if (self.items[self.selected].func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && healthbar_active)
        {
            is_option_blocked = true;
        }
    }

    
    if (!isDefined(self.active_color))
        self.active_color = (0.4, 0.7, 1); 
    if (!isDefined(self.inactive_color))
        self.inactive_color = (0.6, 0.6, 0.6); 

    
    for (i = 0; i < self.items.size; i++)
    {
        if (i == self.selected)
        {
            
            if (is_option_blocked)
            {
                self.items[i].item.color = (1, 1, 1); 
                self.selection_bar.color = (1, 0.2, 0.2); 

                
                if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
                {
                    if (isDefined(self.selector_elements) && self.selector_elements.size > 0)
                    {
                        for (j = 0; j < self.selector_elements.size; j++)
                        {
                            if (isDefined(self.selector_elements[j]))
                            {
                                self.selector_elements[j].color = (1, 0.2, 0.2); 
                            }
                        }
                    }
                }
            }
            else
            {
                
                selector_color = self.active_color; 

                if (self.title == "BANCO" || self.title == "BANK")
                {
                    
                    if (self.selected == 2) 
                        selector_color = (0.2, 1, 0.2); 
                    else if (self.selected == 3) 
                        selector_color = (1, 0.2, 0.2); 
                    else if (self.selected == 4 || self.selected == 5) 
                        selector_color = (1, 1, 0.2); 
                    else if (self.selected == 6 || self.selected == 7) 
                        selector_color = (0.2, 0.2, 1); 
                }

                self.items[i].item.color = (1, 1, 1); 
                self.selection_bar.color = selector_color;

                
                if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
                {
                    if (isDefined(self.selector_elements) && self.selector_elements.size > 0)
                    {
                        for (j = 0; j < self.selector_elements.size; j++)
                        {
                            if (isDefined(self.selector_elements[j]))
                            {
                                self.selector_elements[j].color = selector_color;
                            }
                        }
                    }
                }
            }
        }
        else
        {
            self.items[i].item.color = self.inactive_color;
        }
    }

    
    self.selection_bar.y = self.background.y + self.header_height + (self.item_height * self.selected);

    
    if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
    {
        scripts\zm\style_selector::update_selector_position(self);
        scripts\zm\style_selector::update_selector_visuals(self);
    }

    
    if (isDefined(self.user))
        scripts\zm\playsound::play_menu_scroll_sound(self.user);
    else
        scripts\zm\playsound::play_menu_scroll_sound(self);

    
    self notify("selector_moved");
}

menu_scroll_down()
{
    
    if (self.selected == self.items.size - 1)
    {
        self.selected = 0;
    }
    else
    {
        self.selected++;
    }

    
    
    while (self.items[self.selected].item.alpha == 0)
    {
        if (self.selected == self.items.size - 1)
        {
            self.selected = 0; 
        }
        else
        {
            self.selected++;
        }

        
        if (self.selected == 0 && self.items[self.selected].item.alpha == 0)
            break;
    }

    
    is_option_blocked = false;
    borders_active = (self.user.edge_animation_style_index > 0);
    healthbar_active = self.user.healthbar_enabled;
    healthbarzombie_active = self.user.healthbarzombie_enabled;

    
    if (isDefined(self.items[self.selected].func))
    {
        
        if ((self.items[self.selected].func == ::toggle_healthbar && !self.user.healthbar_enabled && borders_active) ||
            (self.items[self.selected].func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && borders_active))
        {
            is_option_blocked = true;
        }
        
        else if (self.items[self.selected].func == ::cycle_edge_animation_style && self.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active))
        {
            is_option_blocked = true;
        }
        
        else if (self.items[self.selected].func == ::toggle_healthbar && !self.user.healthbar_enabled && healthbarzombie_active)
        {
            is_option_blocked = true;
        }
        
        else if (self.items[self.selected].func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && healthbar_active)
        {
            is_option_blocked = true;
        }
    }

    
    if (!isDefined(self.active_color))
        self.active_color = (0.4, 0.7, 1); 
    if (!isDefined(self.inactive_color))
        self.inactive_color = (0.6, 0.6, 0.6); 

    
    for (i = 0; i < self.items.size; i++)
    {
        if (i == self.selected)
        {
            
            if (is_option_blocked)
            {
                self.items[i].item.color = (1, 1, 1); 
                self.selection_bar.color = (1, 0.2, 0.2); 

                
                if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
                {
                    if (isDefined(self.selector_elements) && self.selector_elements.size > 0)
                    {
                        for (j = 0; j < self.selector_elements.size; j++)
                        {
                            if (isDefined(self.selector_elements[j]))
                            {
                                self.selector_elements[j].color = (1, 0.2, 0.2); 
                            }
                        }
                    }
                }
            }
            else
            {
                
                selector_color = self.active_color; 

                if (self.title == "BANCO" || self.title == "BANK")
                {
                    
                    if (self.selected == 2) 
                        selector_color = (0.2, 1, 0.2); 
                    else if (self.selected == 3) 
                        selector_color = (1, 0.2, 0.2); 
                    else if (self.selected == 4 || self.selected == 5) 
                        selector_color = (1, 1, 0.2); 
                    else if (self.selected == 6 || self.selected == 7) 
                        selector_color = (0.2, 0.2, 1); 
                }

                self.items[i].item.color = (1, 1, 1); 
                self.selection_bar.color = selector_color;

                
                if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
                {
                    if (isDefined(self.selector_elements) && self.selector_elements.size > 0)
                    {
                        for (j = 0; j < self.selector_elements.size; j++)
                        {
                            if (isDefined(self.selector_elements[j]))
                            {
                                self.selector_elements[j].color = selector_color;
                            }
                        }
                    }
                }
            }
        }
        else
        {
            self.items[i].item.color = self.inactive_color;
        }
    }

    
    self.selection_bar.y = self.background.y + self.header_height + (self.item_height * self.selected);

    
    if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
    {
        scripts\zm\style_selector::update_selector_position(self);
        scripts\zm\style_selector::update_selector_visuals(self);
    }

    
    if (isDefined(self.user))
        scripts\zm\playsound::play_menu_scroll_sound(self.user);
    else
        scripts\zm\playsound::play_menu_scroll_sound(self);

    
    self notify("selector_moved");
}


cycle_menu_color()
{
    
    return;
}

menu_destroy()
{
    
    if (isDefined(self.selector_effect_active) && self.selector_effect_active)
    {
        self.selector_effect_active = false;
        self notify("stop_selector_effect");
    }

    
    if (isDefined(self.edge_animation_active) && self.edge_animation_active)
    {
        self.edge_animation_active = false;
        self notify("stop_edge_animation");
    }

    
    if (isDefined(self.selector_elements))
    {
        for (i = 0; i < self.selector_elements.size; i++)
        {
            if (isDefined(self.selector_elements[i]))
                self.selector_elements[i] destroy();
        }
        self.selector_elements = [];
    }

    
    if (isDefined(self.edge_animation_elements))
    {
        for (i = 0; i < self.edge_animation_elements.size; i++)
        {
            if (isDefined(self.edge_animation_elements[i]))
                self.edge_animation_elements[i] destroy();
        }
        self.edge_animation_elements = [];
    }

    
    if (isDefined(self.background))
        self.background destroy();

    if (isDefined(self.title_text))
        self.title_text destroy();

    if (isDefined(self.title_shadow))
        self.title_shadow destroy();

    if (isDefined(self.header_bg))
        self.header_bg destroy();

    if (isDefined(self.header_border_top))
        self.header_border_top destroy();

    if (isDefined(self.selection_bar))
        self.selection_bar destroy();

    for (i = 0; i < self.items.size; i++)
    {
        if (isDefined(self.items[i].item))
            self.items[i].item destroy();
    }

    self.open = false;
}

close_all_menus()
{
    
    scripts\zm\playsound::play_menu_close_sound(self);

    
    if (isDefined(self.menu_current))
    {
        self.menu_current menu_destroy();
    }
    
    
    self.menu_open = false;


    
    self.menu_current = undefined;

    
    wait 0.1;
}


menu_control(menu)
{
    self endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");

    
    menu thread menu_destroy_listener();
    
    
    if (isDefined(menu.selected) && menu.selected >= 0 && menu.selected < menu.items.size)
    {
        is_option_blocked = false;
        borders_active = (menu.user.edge_animation_style_index > 0);
        healthbar_active = menu.user.healthbar_enabled;
        healthbarzombie_active = menu.user.healthbarzombie_enabled;
        legacy_mods_active = are_legacy_mods_active();
        
        
        if (isDefined(menu.items[menu.selected].func))
        {
            
            if ((menu.items[menu.selected].func == ::toggle_healthbar && !menu.user.healthbar_enabled && borders_active) ||
                (menu.items[menu.selected].func == ::toggle_healthbarzombie && !menu.user.healthbarzombie_enabled && borders_active))
            {
                is_option_blocked = true;
            }
            
            else if (menu.items[menu.selected].func == ::cycle_edge_animation_style && menu.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active || legacy_mods_active))
            {
                is_option_blocked = true;
            }
            
            else if (menu.items[menu.selected].func == ::toggle_healthbar && !menu.user.healthbar_enabled && healthbarzombie_active)
            {
                is_option_blocked = true;
            }
            
            else if (menu.items[menu.selected].func == ::toggle_healthbarzombie && !menu.user.healthbarzombie_enabled && healthbar_active)
            {
                is_option_blocked = true;
            }
        }
        
        
        if (is_option_blocked)
        {
            menu.selection_bar.color = (1, 0.2, 0.2); 
            
            
            if (isDefined(menu.selector_style_index) && menu.selector_style_index > 0)
            {
                
                if (isDefined(menu.selector_elements) && menu.selector_elements.size > 0)
                {
                    for (i = 0; i < menu.selector_elements.size; i++)
                    {
                        if (isDefined(menu.selector_elements[i]))
                        {
                            menu.selector_elements[i].color = (1, 0.2, 0.2); 
                        }
                    }
                }
                
                
                scripts\zm\style_selector::update_selector_visuals(menu);
            }
        }
        else
        {
            menu.selection_bar.color = menu.active_color; 
            
            
            if (isDefined(menu.selector_style_index) && menu.selector_style_index > 0)
            {
                
                if (isDefined(menu.selector_elements) && menu.selector_elements.size > 0)
                {
                    for (i = 0; i < menu.selector_elements.size; i++)
                    {
                        if (isDefined(menu.selector_elements[i]))
                        {
                            menu.selector_elements[i].color = menu.active_color; 
                        }
                    }
                }
                
                
                scripts\zm\style_selector::update_selector_visuals(menu);
            }
        }
    }

    for (;;)
    {
        wait 0.05;

        if (!menu.open)
            continue;

        
        
        up_pressed = (self.menu_up_button_index == 0 && self actionslotonebuttonpressed()) ||
                     (self.menu_up_button_index == 1 && self adsbuttonpressed()) ||
                     (self.menu_up_button_index == 2 && self actionslotfourbuttonpressed());

        down_pressed = (self.menu_down_button_index == 0 && self actionslottwobuttonpressed()) ||
                       (self.menu_down_button_index == 1 && self attackbuttonpressed()) ||
                       (self.menu_down_button_index == 2 && self secondaryoffhandbuttonpressed());

        select_pressed = (self.menu_select_button_index == 0 && self usebuttonpressed()) ||
                         (self.menu_select_button_index == 1 && self jumpbuttonpressed()) ||
                         (self.menu_select_button_index == 2 && self sprintbuttonpressed()) ||
                         (self.menu_select_button_index == 3 && self fragbuttonpressed());

        cancel_pressed = (self.menu_cancel_button_index == 0 && self stancebuttonpressed()) ||
                         (self.menu_cancel_button_index == 1 && self meleebuttonpressed());

        if (up_pressed || down_pressed || select_pressed || cancel_pressed)
        {

            if (up_pressed)
            {
                menu menu_scroll_up();

                
                while ((self.menu_up_button_index == 0 && self actionslotonebuttonpressed()) ||
                       (self.menu_up_button_index == 1 && self adsbuttonpressed()) ||
                       (self.menu_up_button_index == 2 && self actionslotfourbuttonpressed()))
                    wait 0.05;
            }
            else if (down_pressed)
            {
                menu menu_scroll_down();

                
                while ((self.menu_down_button_index == 0 && self actionslottwobuttonpressed()) ||
                       (self.menu_down_button_index == 1 && self attackbuttonpressed()) ||
                       (self.menu_down_button_index == 2 && self secondaryoffhandbuttonpressed()))
                    wait 0.05;
            }
            else if (select_pressed)
            {
                menu menu_select_item();

                
                while ((self.menu_select_button_index == 0 && self usebuttonpressed()) ||
                       (self.menu_select_button_index == 1 && self jumpbuttonpressed()) ||
                       (self.menu_select_button_index == 2 && self sprintbuttonpressed()) ||
                       (self.menu_select_button_index == 3 && self fragbuttonpressed()))
                    wait 0.05;
            }
            else if (cancel_pressed && !up_pressed && !down_pressed && !select_pressed)
            {
                self menu_go_back();

                
                scripts\zm\playsound::play_menu_cancel_sound(self);

                while ((self.menu_cancel_button_index == 0 && self stancebuttonpressed()) ||
                       (self.menu_cancel_button_index == 1 && self meleebuttonpressed()))
                    wait 0.05;
            }


            wait 0.2;
        }
    }
}

menu_destroy_listener()
{
    self endon("disconnect");
    
    self.user waittill_any("destroy_all_menus", "destroy_current_menu");
    self menu_destroy();
}

menu_select_item()
{
    item = self.items[self.selected];

    
    is_option_blocked = false;
    if (isDefined(item) && isDefined(item.func))
    {
        borders_active = (self.user.edge_animation_style_index > 0);
        healthbar_active = self.user.healthbar_enabled;
        healthbarzombie_active = self.user.healthbarzombie_enabled;
        
        
        if ((item.func == ::toggle_healthbar && !self.user.healthbar_enabled && borders_active) ||
            (item.func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && borders_active))
        {
            is_option_blocked = true;
            if (self.user.langLEN == 0) 
                self.user iPrintlnBold("^1No se puede activar mientras los bordes están activos");
            else 
                self.user iPrintlnBold("^1Cannot activate while borders are active");
            return;
        }
        
        else if (item.func == ::cycle_edge_animation_style && self.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active))
        {
            is_option_blocked = true;
            if (self.user.langLEN == 0) 
                self.user iPrintlnBold("^1No se puede activar mientras las barras de salud están activas");
            else 
                self.user iPrintlnBold("^1Cannot activate while health bars are active");
            return;
        }
        
        else if (item.func == ::toggle_healthbar && !self.user.healthbar_enabled && healthbarzombie_active)
        {
            is_option_blocked = true;
            if (self.user.langLEN == 0) 
                self.user iPrintlnBold("^1No se puede activar mientras la barra zombie está activa");
            else 
                self.user iPrintlnBold("^1Cannot activate while zombie bar is active");
            return;
        }
        
        else if (item.func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && healthbar_active)
        {
            is_option_blocked = true;
            if (self.user.langLEN == 0) 
                self.user iPrintlnBold("^1No se puede activar mientras la barra de vida está activa");
            else 
                self.user iPrintlnBold("^1Cannot activate while health bar is active");
            return;
        }
    }


    if (isDefined(item) && isDefined(item.func) && isDefined(item.item) && item.item.alpha != 0 && !is_option_blocked)
    {
        
        is_sound_option = (item.func == ::cycle_menu_open_sound ||
                          item.func == ::cycle_menu_close_sound ||
                          item.func == ::cycle_menu_scroll_sound ||
                          item.func == ::cycle_menu_select_sound ||
                          item.func == ::cycle_menu_cancel_sound);

        if (!is_sound_option)
        {
            scripts\zm\playsound::play_menu_select_sound(self.user);
        }

        
        self.user.menu_current = self;
        
        
        if (item.func == ::close_all_menus)
        {
            self.user thread close_all_menus();
        }
        else
        {
            self.user thread [[item.func]]();
        }
    }
    
    else if (isDefined(item) && isDefined(item.item) && item.item.alpha == 0)
    {
        
        
        if (self.user.langLEN == 0) 
            self.user iPrintlnBold("^1Opción no disponible");
        else 
            self.user iPrintlnBold("^1Option not available");
    }
}


toggle_night_mode()
{
    
    if (isDefined(self.is_toggling_night_mode))
    {
        wait 0.1; 
        return;
    }
    
    self.is_toggling_night_mode = true;
    
    self.night_mode_enabled = !self.night_mode_enabled;
    
    if (self.night_mode_enabled)
    {
        
        if (!isDefined(self.night_mode_darkness) || self.night_mode_darkness < 4.5)
            self.night_mode_darkness = 4.5;
        
        self thread night_mode_toggle(self.night_mode_filter);
        
        self setclientdvar("r_exposureValue", self.night_mode_darkness);
    }
    else
    {
        
        self thread disable_night_mode();
    }
    
    
    if (isDefined(self.menu_current))
    {
        
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_night_mode)
            {
                status = self.night_mode_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estado: " + status);
                else
                    self.menu_current.items[i].item setText("Status: " + status);
            }
            
            else if (self.menu_current.items[i].func == ::cycle_night_filter)
            {
                self.menu_current.items[i].item.alpha = self.night_mode_enabled ? 1 : 0;
            }
            
            else if (self.menu_current.items[i].func == ::cycle_night_darkness)
            {
                self.menu_current.items[i].item.alpha = self.night_mode_enabled ? 1 : 0;
            }
        }
    }
    
    
    wait 0.2;
    self.is_toggling_night_mode = undefined;
}

cycle_night_filter()
{
    
    self.night_mode_filter += 1;
    if (self.night_mode_filter > 35)
        self.night_mode_filter = 0;
    
    
    self thread night_mode_toggle(self.night_mode_filter);
    
    
    if (isDefined(self.menu_current))
    {
        
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_night_filter)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Filtro: " + self.night_mode_filter);
                else
                    self.menu_current.items[i].item setText("Filter: " + self.night_mode_filter);
                break;
            }
        }
    }
    
    wait 0.2;
}


cycle_night_darkness()
{
    
    if (isDefined(self.is_cycling_darkness))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_darkness = true;
    
    
    
    if (!isDefined(self.night_mode_darkness) || self.night_mode_darkness < 4.5)
        self.night_mode_darkness = 4.5;
    
    self.night_mode_darkness += 0.5;
    
    
    if (self.night_mode_darkness > 10)
        self.night_mode_darkness = 4.5;
    
    
    self setclientdvar("r_exposureValue", self.night_mode_darkness);
    
    
    if (isDefined(self.menu_current))
    {
        
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_night_darkness)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Oscuridad: " + self.night_mode_darkness);
                else
                    self.menu_current.items[i].item setText("Darkness: " + self.night_mode_darkness);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_cycling_darkness = undefined;
}


toggle_healthbar()
{
    
    if (isDefined(self.is_toggling_healthbar))
    {
        wait 0.1;
        return;
    }

    
    if (!self.healthbar_enabled && are_legacy_mods_active())
    {
        
        legacy_was_disabled = self disable_all_legacy_mods();

        if (legacy_was_disabled)
    {
        
        if (self.langLEN == 0)
        {
                self iPrintlnBold("^3Mods de rendimiento desactivados automáticamente");
                self iPrintlnBold("^2Activando barra de vida del jugador...");
        }
        else
        {
                self iPrintlnBold("^3Performance mods disabled automatically");
                self iPrintlnBold("^2Activating player health bar...");
        }
            wait 0.2; 
        }
    }
    
    
    if (!self.healthbar_enabled && self.edge_animation_style_index > 0)
    {
        
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra de vida");
            self iPrintlnBold("^1Desactiva los bordes del menú primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable health bar");
            self iPrintlnBold("^1Disable menu borders first");
            self playsound("menu_error");
        }
        return;
    }
    
    
    if (!self.healthbar_enabled && self.healthbarzombie_enabled)
    {
        
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra de vida");
            self iPrintlnBold("^1Desactiva la barra zombie primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable health bar");
            self iPrintlnBold("^1Disable zombie bar first");
            self playsound("menu_error");
        }
        return;
    }

    
    self.is_toggling_healthbar = true;
    
    self.healthbar_enabled = !self.healthbar_enabled;
    
    if (self.healthbar_enabled)
    {

        
        if (self.healthbar_position == "left")
            functions = 2;
        else if (self.healthbar_position == "top_left")
            functions = 3;
        else
            functions = 1; 
        self thread bar_funtion_and_toogle(functions);
    }
    else
    {
        
        if (isDefined(self.health_bar))
        {
            self notify("endbar_health");
            self thread bar_funtion_and_toogle(100);
        }
    }
    
    
    if (isDefined(self.menu_current))
    {
        status = self.healthbar_enabled ? "ON" : "OFF";
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_healthbar)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estado: " + status);
                else
                    self.menu_current.items[i].item setText("Status: " + status);
                break;
            }
        }
        
        
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbar_position)
            {
                self.menu_current.items[i].item.alpha = self.healthbar_enabled ? 1 : 0;
                break;
            }
        }
    }
    
    
    wait 0.2;
    self.is_toggling_healthbar = undefined;
}

cycle_healthbar_position()
{
    
    if (self.healthbarzombie_enabled && (self.healthbar_position == "top" || self.healthbar_position == "top_left"))
    {
        
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1Lo sentimos, la barra zombie se encuentra activa.");
            self iPrintlnBold("^1Desactívala primero para poder cambiar la barra de vida a posiciones IZQUIERDA.");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Sorry, the zombie bar is currently active.");
            self iPrintlnBold("^1Deactivate it first to change the health bar to LEFT positions.");
            self playsound("menu_error");
        }
        return; 
    }

    
    if (self.healthbar_position == "top")
        self.healthbar_position = "left";
    else if (self.healthbar_position == "left")
        self.healthbar_position = "top_left";
    else if (self.healthbar_position == "top_left")
        self.healthbar_position = "top";
    else
        self.healthbar_position = "top"; 
    
    
    if (self.healthbar_enabled)
    {
        
        if (isDefined(self.health_bar))
        {
            self notify("endbar_health");
            wait 0.1; 
        }
        
        
        if (self.healthbar_position == "left")
            functions = 2;
        else if (self.healthbar_position == "top_left")
            functions = 3;
        else
            functions = 1; 
        self thread bar_funtion_and_toogle(functions);
    }
    
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbar_position)
            {
                if (self.langLEN == 0)
                {
                    if (self.healthbar_position == "left")
                        pos_text = "IZQUIERDA";
                    else if (self.healthbar_position == "top_left")
                        pos_text = "ARRIBA IZQUIERDA";
                    else
                        pos_text = "ARRIBA";
                    self.menu_current.items[i].item setText("Posición: " + pos_text);
                }
                else
                {
                    if (self.healthbar_position == "left")
                        pos_text = "LEFT";
                    else if (self.healthbar_position == "top_left")
                        pos_text = "TOP LEFT";
                    else
                        pos_text = "TOP";
                    self.menu_current.items[i].item setText("Position: " + pos_text);
                }
                break;
            }
        }
    }
    
    wait 0.2;
}


toggle_fog()
{
    
    if (isDefined(self.is_toggling_fog))
    {
        wait 0.1; 
        return;
    }
    
    self.is_toggling_fog = true;
    
    
    self.fog_enabled = !self.fog_enabled;
    
    
    if (self.fog_enabled)
    {
        
        if (self.fog == 1)
        {
            
        }
        else
    {
        
            self thread scripts\zm\night_mode::fog();
        }
    }
    else
    {
        
        if (self.fog == 0)
        {
            
        }
        else
        {
            
            self thread scripts\zm\night_mode::fog();
        }
    }
    
    
    if (isDefined(self.menu_current))
    {
        status = self.fog_enabled ? "ON" : "OFF";
        
        
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_fog)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Niebla: " + status);
                else
                    self.menu_current.items[i].item setText("Fog: " + status);
                break;
            }
        }
    }
    
    
    wait 0.2;
    self.is_toggling_fog = undefined;
}


toggle_healthbarzombie()
{
    
    if (isDefined(self.is_toggling_healthbarzombie))
    {
        wait 0.1;
        return;
    }

    
    if (!self.healthbarzombie_enabled && are_legacy_mods_active())
    {
        
        legacy_was_disabled = self disable_all_legacy_mods();

        if (legacy_was_disabled)
    {
        
        if (self.langLEN == 0)
        {
                self iPrintlnBold("^3Mods de rendimiento desactivados automáticamente");
                self iPrintlnBold("^2Activando barra de vida zombie...");
        }
        else
        {
                self iPrintlnBold("^3Performance mods disabled automatically");
                self iPrintlnBold("^2Activating zombie health bar...");
        }
            wait 0.2; 
        }
    }
    
    
    if (!self.healthbarzombie_enabled && self.edge_animation_style_index > 0)
    {
        
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra zombie");
            self iPrintlnBold("^1Desactiva los bordes del menú primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable zombie bar");
            self iPrintlnBold("^1Disable menu borders first");
            self playsound("menu_error");
        }
        return;
    }
    
    
    if (!self.healthbarzombie_enabled && self.healthbar_enabled)
    {
        
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra zombie");
            self iPrintlnBold("^1Desactiva la barra de vida primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable zombie bar");
            self iPrintlnBold("^1Disable health bar first");
            self playsound("menu_error");
        }
        return;
    }

    
    self.is_toggling_healthbarzombie = true;
    
    
    if (!self.healthbarzombie_enabled && self.healthbar_enabled && self.healthbar_position == "left")
    {
        
        self.healthbar_position = "top";
        
        
        if (self.langLEN == 0)
            self iPrintlnBold("^3La barra de vida se ha movido automáticamente a ARRIBA");
        else
            self iPrintlnBold("^3Health bar has been automatically moved to TOP");
        
        
        if (isDefined(self.health_bar))
        {
            self notify("endbar_health");
            wait 0.1; 
        }
        
        
        self thread bar_funtion_and_toogle(1); 
        
        
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::cycle_healthbar_position)
                {
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Posición: ARRIBA");
                    else
                        self.menu_current.items[i].item setText("Position: TOP");
                    break;
                }
            }
        }
    }
    
    
    self.healthbarzombie_enabled = !self.healthbarzombie_enabled;
    
    if (self.healthbarzombie_enabled)
    {

        
        if (!isDefined(self.healthbarzombie_color) || self.healthbarzombie_color == "")
            self.healthbarzombie_color = "default";
            
        
        shader_enabled = (self.healthbarzombie_shader == "transparent") ? 0 : 1;
        show_name = self.show_zombie_name ? 1 : 0;
        size_height = self.healthbarzombie_sizeh;
        size_width = self.healthbarzombie_sizew;
        size_name = self.healthbarzombie_sizen;
        color_position = self.healthbarzombie_color;
        
        
        self thread toggleHealthBar(shader_enabled, show_name, size_height, size_width, size_name, color_position);

    }
    else
    {
        
        self thread toggleHealthBar();
    }
    
    
    if (isDefined(self.menu_current))
    {
        
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            
            if (self.menu_current.items[i].func == ::toggle_healthbarzombie)
            {
                status = self.healthbarzombie_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estado: " + status);
                else
                    self.menu_current.items[i].item setText("Status: " + status);
            }
            
            else if (self.menu_current.items[i].func == ::cycle_healthbarzombie_color ||
                    self.menu_current.items[i].func == ::cycle_healthbarzombie_width ||
                    self.menu_current.items[i].func == ::cycle_healthbarzombie_height ||
                    self.menu_current.items[i].func == ::cycle_healthbarzombie_namesize ||
                    self.menu_current.items[i].func == ::cycle_healthbarzombie_shader ||
                    self.menu_current.items[i].func == ::toggle_zombie_name)
            {
                self.menu_current.items[i].item.alpha = self.healthbarzombie_enabled ? 1 : 0;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_healthbarzombie = undefined;
}

cycle_healthbarzombie_color()
{
    
    colors = [];
    colors[0] = "default";    
    colors[1] = "rojo";       
    colors[2] = "verde";      
    colors[3] = "azul";       
    colors[4] = "amarillo";   
    colors[5] = "magenta";    
    colors[6] = "cian";       
    colors[7] = "blanco";     
    colors[8] = "negro";      
    colors[9] = "rojoosc";    
    colors[10] = "verdeosc";  
    colors[11] = "azulosc";   
    colors[12] = "amarilloosc"; 
    colors[13] = "magentaosc"; 
    colors[14] = "cianosc";   
    colors[15] = "grisclaro"; 
    colors[16] = "grisosc";   
    colors[17] = "naranja";   
    colors[18] = "marron";    
    colors[19] = "rosa";      
    colors[20] = "purpura";   
    colors[21] = "verdeclaro"; 
    
    
    current_index = 0;
    for (i = 0; i < colors.size; i++)
    {
        if (colors[i] == self.healthbarzombie_color)
        {
            current_index = i;
            break;
        }
    }
    
    
    current_index = (current_index + 1) % colors.size;
    self.healthbarzombie_color = colors[current_index];
    
    
    color_display_name = self.healthbarzombie_color;
    if (self.langLEN == 0) 
    {
        
        
        if (color_display_name == "default")
            color_display_name = "blanco (predeterminado)";
    }
    else 
    {
        
        switch(self.healthbarzombie_color)
        {
            case "default": color_display_name = "white (default)"; break;
            case "rojo": color_display_name = "red"; break;
            case "verde": color_display_name = "green"; break;
            case "azul": color_display_name = "blue"; break;
            case "amarillo": color_display_name = "yellow"; break;
            case "magenta": color_display_name = "magenta"; break;
            case "cian": color_display_name = "cyan"; break;
            case "blanco": color_display_name = "white"; break;
            case "negro": color_display_name = "black"; break;
            case "rojoosc": color_display_name = "dark red"; break;
            case "verdeosc": color_display_name = "dark green"; break;
            case "azulosc": color_display_name = "dark blue"; break;
            case "amarilloosc": color_display_name = "dark yellow"; break;
            case "magentaosc": color_display_name = "dark magenta"; break;
            case "cianosc": color_display_name = "dark cyan"; break;
            case "grisclaro": color_display_name = "light gray"; break;
            case "grisosc": color_display_name = "dark gray"; break;
            case "naranja": color_display_name = "orange"; break;
            case "marron": color_display_name = "brown"; break;
            case "rosa": color_display_name = "pink"; break;
            case "purpura": color_display_name = "purple"; break;
            case "verdeclaro":             color_display_name = "light green"; break;
        }
    }
    
    
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health))
    {
        
        self notify("end_colorBAR");
        
        
        color_index = 7; 
        
        switch(self.healthbarzombie_color)
        {
            case "rojo": color_index = 1; break;           
            case "verde": color_index = 2; break;          
            case "azul": color_index = 3; break;           
            case "amarillo": color_index = 4; break;       
            case "magenta": color_index = 5; break;        
            case "cian": color_index = 6; break;           
            case "blanco": color_index = 7; break;         
            case "negro": color_index = 8; break;          
            case "rojoosc": color_index = 9; break;        
            case "verdeosc": color_index = 10; break;      
            case "azulosc": color_index = 11; break;       
            case "amarilloosc": color_index = 12; break;   
            case "magentaosc": color_index = 13; break;    
            case "cianosc": color_index = 14; break;       
            case "grisclaro": color_index = 15; break;     
            case "grisosc": color_index = 16; break;       
            case "naranja": color_index = 17; break;       
            case "marron": color_index = 18; break;        
            case "rosa": color_index = 19; break;          
            case "purpura": color_index = 20; break;       
            case "verdeclaro": color_index = 21; break;    
            default: color_index = 7; break;               
        }
        
        
        self thread colorBAR(color_index);
    }
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_color)
            {
                
                if (self.langLEN == 0) 
                    self.menu_current.items[i].item setText("Color: " + color_display_name);
                else 
                    self.menu_current.items[i].item setText("Color: " + color_display_name);
                break;
            }
        }
    }
    
    wait 0.2;
}

cycle_healthbarzombie_width()
{
    
    self.healthbarzombie_sizew += 10;
    
    
    if (self.healthbarzombie_sizew > 150)
        self.healthbarzombie_sizew = 100;
    
    
    self.sizeW = self.healthbarzombie_sizew;
    
    
    
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health))
    {
        self.hud_zombie_health.width = self.sizeW;
        if (isDefined(self.hud_zombie_health.bar))
            self.hud_zombie_health.bar.width = self.sizeW;
    }
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_width)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Ancho: " + self.healthbarzombie_sizew);
                else
                    self.menu_current.items[i].item setText("Width: " + self.healthbarzombie_sizew);
                break;
            }
        }
    }
    
    wait 0.2;
}

cycle_healthbarzombie_height()
{
    
    self.healthbarzombie_sizeh += 1;
    
    
    if (self.healthbarzombie_sizeh > 10)
        self.healthbarzombie_sizeh = 1;
    
    
    self.sizeH = self.healthbarzombie_sizeh;
    
    
    
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health))
    {
        self.hud_zombie_health.height = self.sizeH;
    }
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_height)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Alto: " + self.healthbarzombie_sizeh);
                else
                    self.menu_current.items[i].item setText("Height: " + self.healthbarzombie_sizeh);
                break;
            }
        }
    }
    
    wait 0.2;
}

cycle_healthbarzombie_namesize()
{
    
    self.healthbarzombie_sizen = int(self.healthbarzombie_sizen * 10 + 1) / 10; 
    
    
    if (self.healthbarzombie_sizen > 1.9)
        self.healthbarzombie_sizen = 1.0;
    
    
    self.sizeN = self.healthbarzombie_sizen;
    
    
    
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health_text))
    {
        self.hud_zombie_health_text.fontScale = self.sizeN;
    }
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_namesize)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Tamaño Nombre: " + self.healthbarzombie_sizen);
                else
                    self.menu_current.items[i].item setText("Name Size: " + self.healthbarzombie_sizen);
                break;
            }
        }
    }
    
    wait 0.2;
}

cycle_healthbarzombie_shader()
{
    
    shaders = [];
    shaders[0] = "transparent";
    shaders[1] = "solid";
    
    
    current_index = 0;
    for (i = 0; i < shaders.size; i++)
    {
        if (shaders[i] == self.healthbarzombie_shader)
        {
            current_index = i;
            break;
        }
    }
    
    
    current_index = (current_index + 1) % shaders.size;
    self.healthbarzombie_shader = shaders[current_index];
    
    
    if (self.healthbarzombie_shader == "transparent")
        self.shaderON = 0;
    else 
        self.shaderON = 1;
    
    
    
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health))
    {
        self.hud_zombie_health.alpha = self.shaderON;
    }
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_shader)
            {
                self.menu_current.items[i].item setText("Shader: " + self.healthbarzombie_shader);
                break;
            }
        }
    }
    
    wait 0.2;
}


toggle_zombie_name()
{
    
    if (isDefined(self.is_toggling_zombie_name))
    {
        wait 0.1;
        return;
    }
    
    self.is_toggling_zombie_name = true;
    
    
    self.show_zombie_name = !self.show_zombie_name;
    
    
    self.zombieNAME = self.show_zombie_name ? 1 : 0;
    
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_zombie_name)
            {
                zombieNameStatus = self.show_zombie_name ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Mostrar Nombre: " + zombieNameStatus);
                else
                    self.menu_current.items[i].item setText("Show Name: " + zombieNameStatus);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_zombie_name = undefined;
}


toggle_language()
{
    
    if (isDefined(self.is_toggling_language))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_language = true;

    
    self.langLEN = (self.langLEN == 0) ? 1 : 0;

    
    self update_settings_menu_texts();

    
    wait 0.5;
    self.is_toggling_language = undefined;
}


update_settings_menu_texts()
{
    
    if (!isDefined(self.menu_current) || !isDefined(self.menu_current.title))
        return;

    
    menu_title = self.menu_current.title;
    if (menu_title != "CONFIGURACIÓN" && menu_title != "SETTINGS")
        return;

    
    new_title = (self.langLEN == 0) ? "CONFIGURACIÓN" : "SETTINGS";
    self.menu_current.title = new_title;

    
    if (isDefined(self.menu_current.title_text))
    {
        self.menu_current.title_text setText(new_title);
    }

    
    if (isDefined(self.menu_current.title_shadow))
    {
        self.menu_current.title_shadow setText(new_title);
    }

    
    if (self.langLEN == 0) 
    {
        
        if (isDefined(self.menu_current.items[0]))
        {
            lang = (self.langLEN == 0) ? "Español" : "Inglés";
            self.menu_current.items[0].item setText("Idioma: " + lang);
        }

        
        if (isDefined(self.menu_current.items[1]))
        {
            styleName = get_style_name(self.menu_style_index, self.langLEN);
            self.menu_current.items[1].item setText("Estilo Menú: " + styleName);
        }

        
        if (isDefined(self.menu_current.items[2]))
        {
            selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
            self.menu_current.items[2].item setText("Estilo Selector: " + selectorStyleName);
        }

        
        if (isDefined(self.menu_current.items[3]))
        {
            fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
            self.menu_current.items[3].item setText("Posición Texto: " + fontPositionName);
        }

        
        if (isDefined(self.menu_current.items[4]))
        {
            edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
            self.menu_current.items[4].item setText("Animación Borde: " + edgeAnimStyleName);
        }

        
        if (isDefined(self.menu_current.items[5]))
        {
            fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
            self.menu_current.items[5].item setText("Animación Fuente: " + fontAnimName);
        }

        
        if (isDefined(self.menu_current.items[6]))
        {
            transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
            self.menu_current.items[6].item setText(transparencyName);
        }

        
        if (isDefined(self.menu_current.items[7]))
        {
            self.menu_current.items[7].item setText("Controles del Menú");
        }

        
        if (isDefined(self.menu_current.items[8]))
        {
            self.menu_current.items[8].item setText("Sonidos");
        }

        
        if (isDefined(self.menu_current.items[9]))
        {
            self.menu_current.items[9].item setText("Guardar Configuración");
        }

        
        if (isDefined(self.menu_current.items[10]))
            self.menu_current.items[10].item setText("Volver");
        if (isDefined(self.menu_current.items[11]))
            self.menu_current.items[11].item setText("Cerrar Menú");
    }
    else 
    {
        
        if (isDefined(self.menu_current.items[0]))
        {
            lang = (self.langLEN == 0) ? "Spanish" : "English";
            self.menu_current.items[0].item setText("Language: " + lang);
        }

        
        if (isDefined(self.menu_current.items[1]))
        {
            styleName = get_style_name(self.menu_style_index, self.langLEN);
            self.menu_current.items[1].item setText("Menu Style: " + styleName);
        }

        
        if (isDefined(self.menu_current.items[2]))
        {
            selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
            self.menu_current.items[2].item setText("Selector Style: " + selectorStyleName);
        }

        
        if (isDefined(self.menu_current.items[3]))
        {
            fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
            self.menu_current.items[3].item setText("Text Position: " + fontPositionName);
        }

        
        if (isDefined(self.menu_current.items[4]))
        {
            edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
            self.menu_current.items[4].item setText("Edge Animation: " + edgeAnimStyleName);
        }

        
        if (isDefined(self.menu_current.items[5]))
        {
            fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
            self.menu_current.items[5].item setText("Font Animation: " + fontAnimName);
        }

        
        if (isDefined(self.menu_current.items[6]))
        {
            transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
            self.menu_current.items[6].item setText(transparencyName);
        }

        
        if (isDefined(self.menu_current.items[7]))
        {
            self.menu_current.items[7].item setText("Menu Controls");
        }

        
        if (isDefined(self.menu_current.items[8]))
        {
            self.menu_current.items[8].item setText("Sound");
        }

        
        if (isDefined(self.menu_current.items[9]))
        {
            self.menu_current.items[9].item setText("Save Configuration");
        }

        
        if (isDefined(self.menu_current.items[10]))
            self.menu_current.items[10].item setText("Back");
        if (isDefined(self.menu_current.items[11]))
            self.menu_current.items[11].item setText("Close Menu");
    }
}


custom_configbar()
{
    self endon("disconnect");
    self endon("end_configbar");
    level endon("end_game");
    
    
    if (isDefined(self.hud_zombie_health))
    {
        self.hud_zombie_health.width = self.sizeW;
        self.hud_zombie_health.height = self.sizeH;
        
        if (isDefined(self.hud_zombie_health.bar))
        {
            self.hud_zombie_health.bar.width = self.sizeW;
        }
        
        if (isDefined(self.hud_zombie_health_text))
        {
            self.hud_zombie_health_text.fontScale = self.sizeN;
        }
        
        self.hud_zombie_health.alpha = self.shaderON;
    }
    
    
    while(true)
    {
        
        if (isDefined(self.hud_zombie_health))
        {
            self.hud_zombie_health.width = self.sizeW;
            self.hud_zombie_health.height = self.sizeH;
            
            if (isDefined(self.hud_zombie_health.bar))
            {
                self.hud_zombie_health.bar.width = self.sizeW;
            }
            
            if (isDefined(self.hud_zombie_health_text))
            {
                self.hud_zombie_health_text.fontScale = self.sizeN;
            }
            
            self.hud_zombie_health.alpha = self.shaderON;
        }
        
        wait 0.5;
    }
}


open_settings_menu(is_returning)
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;
    
    
    title = (self.langLEN == 0) ? "CONFIGURACIÓN" : "SETTINGS";
    menu = create_menu(title, self);
    menu.parent_menu = "main"; 
    
    
    godmode_enabled = self.godmode_enabled;
    
    
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;
    
    
    if(!isDefined(self.font_position_index))
        self.font_position_index = 0;

    
    if(!isDefined(self.selector_style_index))
        self.selector_style_index = 14;

    
    if(!isDefined(self.font_animation_index))
        self.font_animation_index = 5;

    
    if(!isDefined(self.menu_open_sound_index))
        self.menu_open_sound_index = 1; 

    if(!isDefined(self.menu_close_sound_index))
        self.menu_close_sound_index = 1; 

    if(!isDefined(self.menu_scroll_sound_index))
        self.menu_scroll_sound_index = 1; 

    if(!isDefined(self.menu_select_sound_index))
        self.menu_select_sound_index = 2;

    if(!isDefined(self.menu_cancel_sound_index))
        self.menu_cancel_sound_index = 1; 

    if(!isDefined(self.menu_select_button_index))
        self.menu_select_button_index = 0; 

    if(!isDefined(self.menu_down_button_index))
        self.menu_down_button_index = 0; 

    if(!isDefined(self.menu_up_button_index))
        self.menu_up_button_index = 0; 

    if(!isDefined(self.menu_cancel_button_index))
        self.menu_cancel_button_index = 1; 


    
    if (self.langLEN == 0) 
    {
        
        lang = (self.langLEN == 0) ? "Español" : "Inglés";
        add_menu_item(menu, "Idioma: " + lang, ::toggle_language);
        
        
        styleName = get_style_name(self.menu_style_index, self.langLEN);
        add_menu_item(menu, "Estilo Menú: " + styleName, ::cycle_menu_style);
        
        
        selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
        add_menu_item(menu, "Estilo Selector: " + selectorStyleName, ::cycle_selector_style);
        
        
        fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
        add_menu_item(menu, "Posición Texto: " + fontPositionName, scripts\zm\style_font_position::cycle_font_position);
        
        
        edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
        add_menu_item(menu, "Animación Borde: " + edgeAnimStyleName, ::cycle_edge_animation_style);

        
        fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
        add_menu_item(menu, "Animación Fuente: " + fontAnimName, ::cycle_font_animation);
        
        
        transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
        add_menu_item(menu, transparencyName, ::cycle_transparency);


        add_menu_item(menu, "Controles del Menú", ::open_menu_controls_settings);

        add_menu_item(menu, "Sonidos", ::open_sound_settings_menu);

        
        add_menu_item(menu, "Guardar Configuración", ::save_menu_configuration);


        

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        lang = (self.langLEN == 0) ? "Spanish" : "English";
        add_menu_item(menu, "Language: " + lang, ::toggle_language);
        
        
        styleName = get_style_name(self.menu_style_index, self.langLEN);
        add_menu_item(menu, "Menu Style: " + styleName, ::cycle_menu_style);
        
        
        selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
        add_menu_item(menu, "Selector Style: " + selectorStyleName, ::cycle_selector_style);
        
        
        fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
        add_menu_item(menu, "Text Position: " + fontPositionName, scripts\zm\style_font_position::cycle_font_position);
        
        
        edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
        add_menu_item(menu, "Edge Animation: " + edgeAnimStyleName, ::cycle_edge_animation_style);

        
        fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
        add_menu_item(menu, "Font Animation: " + fontAnimName, ::cycle_font_animation);
        
        
        transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
        add_menu_item(menu, transparencyName, ::cycle_transparency);


        add_menu_item(menu, "Menu Controls", ::open_menu_controls_settings);

        add_menu_item(menu, "Sound", ::open_sound_settings_menu);

        
        add_menu_item(menu, "Save Configuration", ::save_menu_configuration);


        

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    
    show_menu(menu);
    
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


open_credits_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    
    title = (self.langLEN == 0) ? "CRÉDITOS" : "CREDITS";
    menu = create_menu(title, self);
    menu.parent_menu = "main"; 
    
    
    if (self.langLEN == 0) 
    {
        add_menu_item(menu, "^6━━━━━━━━━━━━━━━━━━━━━━", undefined);
        add_menu_item(menu, "^2Desarrollado por:", undefined);
        add_menu_item(menu, "^3LittleGods", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "^2Discord:", undefined);
        add_menu_item(menu, "^5dsc.gg/littlegods", undefined);
        add_menu_item(menu, "^6━━━━━━━━━━━━━━━━━━━━━━", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "^7Gracias por usar este menú!", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        add_menu_item(menu, "^6━━━━━━━━━━━━━━━━━━━━━━", undefined);
        add_menu_item(menu, "^2Developed by:", undefined);
        add_menu_item(menu, "^3LittleGods", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "^2Discord:", undefined);
        add_menu_item(menu, "^5dsc.gg/littlegods", undefined);
        add_menu_item(menu, "^6━━━━━━━━━━━━━━━━━━━━━━", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "^7Thanks for using this menu!", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    
    show_menu(menu);
    
    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


open_map_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    
    self notify("destroy_current_menu");
    wait 0.1;


    
    title = (self.langLEN == 0) ? "MAPA" : "MAP";
    menu = create_menu(title, self);
    menu.parent_menu = "main"; 
    
    
    if (!isDefined(self.perk_unlimite_active))
        self.perk_unlimite_active = false;
    
    
    if (!isDefined(self.TPP))
        self.TPP = false;

    
    
    if (self.langLEN == 0) 
    {
        
        perk_status = self.perk_unlimite_active ? "ON" : "OFF";
        add_menu_item(menu, "Perk Unlimited: " + perk_status, scripts\zm\funciones::toggle_perk_unlimite);
        
        
        thirdperson_status = self.TPP ? "ON" : "OFF";
        add_menu_item(menu, "Tercera Persona: " + thirdperson_status, scripts\zm\funciones::ThirdPerson);


        if (!self.developer_mode_unlocked && (!isDefined(level.partida_alterada_global) || !level.partida_alterada_global))
        add_menu_item(menu, "Partidas Recientes", ::open_recent_matches_menu);


        if (!self.developer_mode_unlocked && (!isDefined(level.partida_alterada_global) || !level.partida_alterada_global))
            add_menu_item(menu, "Banco", ::open_bank_menu);


        add_menu_item(menu, "Guardar Configuración", ::save_map_configuration);

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        perk_status = self.perk_unlimite_active ? "ON" : "OFF";
        add_menu_item(menu, "Perk Unlimited: " + perk_status, scripts\zm\funciones::toggle_perk_unlimite);
        
        
        thirdperson_status = self.TPP ? "ON" : "OFF";
        add_menu_item(menu, "Third Person: " + thirdperson_status, scripts\zm\funciones::ThirdPerson);


        if (!self.developer_mode_unlocked && (!isDefined(level.partida_alterada_global) || !level.partida_alterada_global))
        add_menu_item(menu, "Recent Matches", ::open_recent_matches_menu);


        if (!self.developer_mode_unlocked && (!isDefined(level.partida_alterada_global) || !level.partida_alterada_global))
            add_menu_item(menu, "Bank", ::open_bank_menu);


        add_menu_item(menu, "Save Configuration", ::save_map_configuration);

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    
    show_menu(menu);


    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;

        
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}








open_developer_menu(is_returning)
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;
    
    
    title = (self.langLEN == 0) ? "DEVELOPER" : "DEVELOPER";
    menu = create_menu(title, self);
    menu.parent_menu = "main"; 
    
    
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;
    
    
    map = getDvar("ui_zm_mapstartlocation");
    
    
    if (self.langLEN == 0)
    {

        add_menu_item(menu, "Jugador", ::open_player_menu);
        add_menu_item(menu, "Zombie", ::open_zombie_menu);
        add_menu_item(menu, "Caja Misteriosa", ::open_mystery_box_menu);

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {

        add_menu_item(menu, "Player", ::open_player_menu);
        add_menu_item(menu, "Zombie", ::open_zombie_menu);
        add_menu_item(menu, "Mystery Box", ::open_mystery_box_menu);

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    
    show_menu(menu);
    
    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


request_developer_password()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    
    self thread close_all_menus();
    wait 0.2;
    
    
    self.password_hud = newClientHudElem(self);
    self.password_hud.horzalign = "center";
    self.password_hud.vertalign = "middle";
    self.password_hud.alignX = "center";
    self.password_hud.alignY = "middle";
    self.password_hud.x = 0;
    self.password_hud.y = 0;
    self.password_hud.fontScale = 1.5;
    self.password_hud.alpha = 1;
    self.password_hud.color = (1, 1, 0); 
    self.password_hud.hidewheninmenu = false;

    if (self.langLEN == 0) 
        self.password_hud setText("^3Escriba ^2'admin' ^3en el chat para desbloquear");
    else 
        self.password_hud setText("^3Type ^2'admin' ^3in chat to unlock");

    
    wait 5;

    if (isDefined(self.password_hud))
    {
        self.password_hud destroy();
        self.password_hud = undefined;
    }
}


cycle_transparency()
{
    
    if (isDefined(self.is_cycling_transparency))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_transparency = true;
    
    
    self.transparency_index += 1;
    
    
    maxLevels = level.transparency_levels.size;
    if (self.transparency_index >= maxLevels)
        self.transparency_index = 0;
    
    
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
    }
    
    
    transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
    
    
    percentage = level.transparency_levels[self.transparency_index];
    
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
                    if (self.menu_current.items[i].func == ::cycle_transparency)
              {
                  
                  transparency_text = "";
                  if (self.langLEN == 0)
                      transparency_text = "Transparencia: " + int(level.transparency_levels[self.transparency_index]) + "%%";
                  else
                      transparency_text = "Transparency: " + int(level.transparency_levels[self.transparency_index]) + "%%";
                      
                  self.menu_current.items[i].item setText(transparency_text);
                  break;
              }
        }
    }
    
    wait 0.2;
    self.is_cycling_transparency = undefined;
}


save_menu_configuration()
{
    
    if (isDefined(self.is_saving_config))
    {
        wait 0.1;
        return;
    }

    self.is_saving_config = true;

    
    success = scripts\zm\sqllocal::save_settings_only(self);

    if (success)
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^2Configuración de Settings guardada");
        else
            self iPrintLnBold("^2Settings configuration saved");
    }
    else
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^1Error al guardar configuración");
        else
            self iPrintLnBold("^1Error saving configuration");
    }

    wait 0.5;
    self.is_saving_config = undefined;
}

save_nightmode_configuration()
{
    
    if (isDefined(self.is_saving_nightmode))
    {
        wait 0.1;
        return;
    }

    self.is_saving_nightmode = true;

    
    success = scripts\zm\sqllocal::save_nightmode_only(self);

    if (success)
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^2Configuración de Night Mode guardada");
        else
            self iPrintLnBold("^2Night Mode configuration saved");
    }
    else
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^1Error al guardar configuración");
        else
            self iPrintLnBold("^1Error saving configuration");
    }

    wait 0.5;
    self.is_saving_nightmode = undefined;
}

save_map_configuration()
{
    
    if (isDefined(self.is_saving_map))
    {
        wait 0.1;
        return;
    }

    self.is_saving_map = true;

    
    success = scripts\zm\sqllocal::save_map_only(self);

    if (success)
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^2Configuración de Map guardada");
        else
            self iPrintLnBold("^2Map configuration saved");
    }
    else
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^1Error al guardar configuración");
        else
            self iPrintLnBold("^1Error saving configuration");
    }

    wait 0.5;
    self.is_saving_map = undefined;
}


get_menu_color_by_index(index)
{
    
    return (0.4, 0.7, 1); 
}


get_menu_color_name(lang_index)
{
    
    return (lang_index == 0) ? "Azul" : "Blue";
}

cycle_menu_style()
{
    
    if (isDefined(self.is_cycling_menu_style))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_menu_style = true;
    
    
    if (isDefined(self.menu_current.rainbow_active) && self.menu_current.rainbow_active)
    {
        stop_rainbow_effect(self.menu_current);
    }
    
    
    self.menu_style_index += 1;
    
    
    maxStyles = level.menu_styles.size;
    if (self.menu_style_index >= maxStyles)
        self.menu_style_index = 0;
    
    
    if (isDefined(self.menu_current))
    {
        
        edge_animation_active = false;
        edge_animation_style_index = 0;
        
        if (isDefined(self.menu_current.edge_animation_active))
            edge_animation_active = self.menu_current.edge_animation_active;
            
        if (isDefined(self.edge_animation_style_index))
            edge_animation_style_index = self.edge_animation_style_index;
            
        
        self.menu_current = apply_menu_style(self.menu_current, self.menu_style_index);
        
        
        if (isDefined(self.selector_style_index))
        {
            self.menu_current = scripts\zm\style_selector::apply_selector_style(self.menu_current, self.selector_style_index);
            scripts\zm\style_selector::update_selector_visuals(self.menu_current);
            scripts\zm\style_selector::update_selector_position(self.menu_current);
        }
        
        
        wait 0.05;
        
        
        self.menu_current.height = self.menu_current.header_height + 
                                  (self.menu_current.item_height * self.menu_current.items.size);
        
        
        if (edge_animation_active && edge_animation_style_index > 0)
        {
            
            self.menu_current.edge_animation_style_index = edge_animation_style_index;
            
            
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            
            
            
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, edge_animation_style_index);
        }
    }
    
    
    styleName = get_style_name(self.menu_style_index, self.langLEN);
    
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_style)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estilo Menú: " + styleName);
                else
                    self.menu_current.items[i].item setText("Menu Style: " + styleName);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_cycling_menu_style = undefined;
}


cycle_selector_style()
{
    
    if (isDefined(self.is_cycling_selector_style))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_selector_style = true;
    
    
    if (isDefined(self.menu_current.selector_effect_active) && self.menu_current.selector_effect_active)
    {
        self.menu_current.selector_effect_active = false;
        self.menu_current notify("stop_selector_effect");
    }
    
    
    self.selector_style_index += 1;
    
    
    maxSelectorStyles = level.selector_styles.size;
    if (self.selector_style_index >= maxSelectorStyles)
        self.selector_style_index = 0;
    
    
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_selector::apply_selector_style(self.menu_current, self.selector_style_index);
        
        
        scripts\zm\style_selector::update_selector_visuals(self.menu_current);
        scripts\zm\style_selector::update_selector_position(self.menu_current);
    }
    
    
    selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
    
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_selector_style)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estilo Selector: " + selectorStyleName);
                else
                    self.menu_current.items[i].item setText("Selector Style: " + selectorStyleName);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_cycling_selector_style = undefined;
}


cycle_font_animation()
{
    
    if (isDefined(self.is_cycling_font_animation))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_font_animation = true;

    
    self.font_animation_index += 1;

    
    if (self.font_animation_index >= 8)
        self.font_animation_index = 0;

    
    if (isDefined(self.menu_current))
    {
        scripts\zm\style_font_animation::apply_font_animation(self.menu_current, self.font_animation_index);
    }

    
    fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_font_animation)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Animación Fuente: " + fontAnimName);
                else
                    self.menu_current.items[i].item setText("Font Animation: " + fontAnimName);
                break;
            }
        }
    }

    
    wait 0.2;
    self.is_cycling_font_animation = undefined;
}


open_sound_settings_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    
    self notify("destroy_current_menu");
    wait 0.1;

    
    title = (self.langLEN == 0) ? "CONFIGURACIÓN DE SONIDOS" : "SOUND SETTINGS";
    menu = create_menu(title, self);
    menu.parent_menu = "settings"; 

    
    if (self.langLEN == 0) 
    {
        
        openSoundName = scripts\zm\playsound::get_menu_open_sound_name(self.menu_open_sound_index, self.langLEN);
        add_menu_item(menu, "Abrir Menú: " + openSoundName, ::cycle_menu_open_sound);

        
        closeSoundName = scripts\zm\playsound::get_menu_close_sound_name(self.menu_close_sound_index, self.langLEN);
        add_menu_item(menu, "Cerrar Menú: " + closeSoundName, ::cycle_menu_close_sound);

        
        scrollSoundName = scripts\zm\playsound::get_menu_scroll_sound_name(self.menu_scroll_sound_index, self.langLEN);
        add_menu_item(menu, "Navegación: " + scrollSoundName, ::cycle_menu_scroll_sound);


        selectSoundName = scripts\zm\playsound::get_menu_select_sound_name(self.menu_select_sound_index, self.langLEN);
        add_menu_item(menu, "Selección: " + selectSoundName, ::cycle_menu_select_sound);

        cancelSoundName = scripts\zm\playsound::get_menu_cancel_sound_name(self.menu_cancel_sound_index, self.langLEN);
        add_menu_item(menu, "Cancelar: " + cancelSoundName, ::cycle_menu_cancel_sound);

        
        add_menu_item(menu, "Volver", ::open_settings_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        openSoundName = scripts\zm\playsound::get_menu_open_sound_name(self.menu_open_sound_index, self.langLEN);
        add_menu_item(menu, "Open Menu: " + openSoundName, ::cycle_menu_open_sound);

        
        closeSoundName = scripts\zm\playsound::get_menu_close_sound_name(self.menu_close_sound_index, self.langLEN);
        add_menu_item(menu, "Close Menu: " + closeSoundName, ::cycle_menu_close_sound);

        
        scrollSoundName = scripts\zm\playsound::get_menu_scroll_sound_name(self.menu_scroll_sound_index, self.langLEN);
        add_menu_item(menu, "Navigation: " + scrollSoundName, ::cycle_menu_scroll_sound);


        selectSoundName = scripts\zm\playsound::get_menu_select_sound_name(self.menu_select_sound_index, self.langLEN);
        add_menu_item(menu, "Selection: " + selectSoundName, ::cycle_menu_select_sound);

        cancelSoundName = scripts\zm\playsound::get_menu_cancel_sound_name(self.menu_cancel_sound_index, self.langLEN);
        add_menu_item(menu, "Cancel: " + cancelSoundName, ::cycle_menu_cancel_sound);

        
        add_menu_item(menu, "Back", ::open_settings_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
     
    show_menu(menu);
    
    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);


}


open_menu_controls_settings()
{
    self endon("disconnect");
    self endon("destroy_all_menus");


    self notify("destroy_current_menu");
    wait 0.1;


    title = (self.langLEN == 0) ? "CONTROLES DEL MENÚ" : "MENU CONTROLS";
    menu = create_menu(title, self);
    menu.parent_menu = "settings";


    if (self.langLEN == 0)
    {

        selectButtonName = get_menu_select_button_name(self.menu_select_button_index, self.langLEN);
        add_menu_item(menu, "Seleccionar: " + selectButtonName, ::cycle_menu_select_button);


        downButtonName = get_menu_down_button_name(self.menu_down_button_index, self.langLEN);
        add_menu_item(menu, "Bajar: " + downButtonName, ::cycle_menu_down_button);


        upButtonName = get_menu_up_button_name(self.menu_up_button_index, self.langLEN);
        add_menu_item(menu, "Subir: " + upButtonName, ::cycle_menu_up_button);

        cancelButtonName = get_menu_cancel_button_name(self.menu_cancel_button_index, self.langLEN);
        add_menu_item(menu, "Cancelar: " + cancelButtonName, ::cycle_menu_cancel_button);

        add_menu_item(menu, "Volver", ::open_settings_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {

        selectButtonName = get_menu_select_button_name(self.menu_select_button_index, self.langLEN);
        add_menu_item(menu, "Select: " + selectButtonName, ::cycle_menu_select_button);


        downButtonName = get_menu_down_button_name(self.menu_down_button_index, self.langLEN);
        add_menu_item(menu, "Go Down: " + downButtonName, ::cycle_menu_down_button);


        upButtonName = get_menu_up_button_name(self.menu_up_button_index, self.langLEN);
        add_menu_item(menu, "Go Up: " + upButtonName, ::cycle_menu_up_button);

        cancelButtonName = get_menu_cancel_button_name(self.menu_cancel_button_index, self.langLEN);
        add_menu_item(menu, "Cancel: " + cancelButtonName, ::cycle_menu_cancel_button);

        add_menu_item(menu, "Back", ::open_settings_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);


    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);


    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;


        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);


}


cycle_menu_open_sound()
{
    
    if (isDefined(self.is_cycling_open_sound))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_open_sound = true;

    
    self.menu_open_sound_index += 1;

    
    if (self.menu_open_sound_index >= 5)
        self.menu_open_sound_index = 0;

    
    openSoundName = scripts\zm\playsound::get_menu_open_sound_name(self.menu_open_sound_index, self.langLEN);

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_open_sound)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Abrir Menú: " + openSoundName);
                else
                    self.menu_current.items[i].item setText("Open Menu: " + openSoundName);
                break;
            }
        }
    }

    scripts\zm\playsound::change_menu_open_sound(self, self.menu_open_sound_index);

    
    scripts\zm\playsound::play_menu_open_sound(self);

    wait 0.2;
    self.is_cycling_open_sound = undefined;
}


cycle_menu_close_sound()
{
    
    if (isDefined(self.is_cycling_close_sound))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_close_sound = true;

    
    self.menu_close_sound_index += 1;

    
    if (self.menu_close_sound_index >= 6)
        self.menu_close_sound_index = 0;

    
    closeSoundName = scripts\zm\playsound::get_menu_close_sound_name(self.menu_close_sound_index, self.langLEN);

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_close_sound)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Cerrar Menú: " + closeSoundName);
                else
                    self.menu_current.items[i].item setText("Close Menu: " + closeSoundName);
                break;
            }
        }
    }

    scripts\zm\playsound::change_menu_close_sound(self, self.menu_close_sound_index);

    
    scripts\zm\playsound::play_menu_close_sound(self);

    wait 0.2;
    self.is_cycling_close_sound = undefined;
}


cycle_menu_scroll_sound()
{
    
    if (isDefined(self.is_cycling_scroll_sound))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_scroll_sound = true;

    
    self.menu_scroll_sound_index += 1;


    if (self.menu_scroll_sound_index >= 7)
        self.menu_scroll_sound_index = 0;

    
    scrollSoundName = scripts\zm\playsound::get_menu_scroll_sound_name(self.menu_scroll_sound_index, self.langLEN);

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_scroll_sound)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Navegación: " + scrollSoundName);
                else
                    self.menu_current.items[i].item setText("Navigation: " + scrollSoundName);
                break;
            }
        }
    }

    scripts\zm\playsound::change_menu_scroll_sound(self, self.menu_scroll_sound_index);

    
    scripts\zm\playsound::play_menu_scroll_sound(self);

    wait 0.2;
    self.is_cycling_scroll_sound = undefined;
}



cycle_menu_select_sound()
{
    
    if (isDefined(self.is_cycling_select_sound))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_select_sound = true;

    
    self.menu_select_sound_index += 1;


    if (self.menu_select_sound_index >= 4)
        self.menu_select_sound_index = 0;

    
    selectSoundName = scripts\zm\playsound::get_menu_select_sound_name(self.menu_select_sound_index, self.langLEN);

    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_select_sound)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Selección: " + selectSoundName);
                else
                    self.menu_current.items[i].item setText("Selection: " + selectSoundName);
                break;
            }
        }
    }

    scripts\zm\playsound::change_menu_select_sound(self, self.menu_select_sound_index);

    
    scripts\zm\playsound::play_menu_select_sound(self);
    wait 0.2;
    self.is_cycling_select_sound = undefined;
}


cycle_menu_cancel_sound()
{

    if (isDefined(self.is_cycling_cancel_sound))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_cancel_sound = true;

    if (!isDefined(self.menu_cancel_sound_index))
        self.menu_cancel_sound_index = 1; 

    self.menu_cancel_sound_index += 1;

    if (self.menu_cancel_sound_index >= level.menu_cancel_sounds.size)
        self.menu_cancel_sound_index = 0;

    cancelSoundName = scripts\zm\playsound::get_menu_cancel_sound_name(self.menu_cancel_sound_index, self.langLEN);

    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_cancel_sound)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Cancelar: " + cancelSoundName);
                else
                    self.menu_current.items[i].item setText("Cancel: " + cancelSoundName);
                break;
            }
        }
    }

    scripts\zm\playsound::change_menu_cancel_sound(self, self.menu_cancel_sound_index);

    
    scripts\zm\playsound::play_menu_cancel_sound(self);

    wait 0.2;
    self.is_cycling_cancel_sound = undefined;
}


get_menu_select_button_name(index, lang)
{
    if (index == 0)
        return (lang == 0) ? "Botón Usar" : "Use Button";
    else if (index == 1)
        return (lang == 0) ? "Botón Saltar" : "Jump Button";
    else if (index == 2)
        return (lang == 0) ? "Botón Correr" : "Sprint Button";
    else if (index == 3)
        return (lang == 0) ? "Granada Letal" : "Frag Grenade";
    else
        return (lang == 0) ? "Desconocido" : "Unknown";
}


get_menu_down_button_name(index, lang)
{
    if (index == 0)
        return (lang == 0) ? "Action Slot 2" : "Action Slot 2";
    else if (index == 1)
        return (lang == 0) ? "Botón Disparar" : "Attack Button";
    else if (index == 2)
        return (lang == 0) ? "Action Slot 4" : "Action Slot 4";
    else
        return (lang == 0) ? "Desconocido" : "Unknown";
}


get_menu_up_button_name(index, lang)
{
    if (index == 0)
        return (lang == 0) ? "Action Slot 1" : "Action Slot 1";
    else if (index == 1)
        return (lang == 0) ? "Botón ADS" : "ADS Button";
    else if (index == 2)
        return (lang == 0) ? "Action Slot 3" : "Action Slot 3";
    else
        return (lang == 0) ? "Desconocido" : "Unknown";
}


get_menu_cancel_button_name(index, lang)
{
    if (index == 0)
        return (lang == 0) ? "Botón Postura" : "Stance Button";
    else if (index == 1)
        return (lang == 0) ? "Botón Melee" : "Melee Button";
    else
        return (lang == 0) ? "Desconocido" : "Unknown";
}


cycle_menu_select_button()
{
    if (isDefined(self.is_cycling_select_button))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_select_button = true;

    self.menu_select_button_index += 1;

    if (self.menu_select_button_index >= 4)
        self.menu_select_button_index = 0;

    buttonName = get_menu_select_button_name(self.menu_select_button_index, self.langLEN);

    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_select_button)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Seleccionar: " + buttonName);
                else
                    self.menu_current.items[i].item setText("Select: " + buttonName);
                break;
            }
        }
    }

    wait 0.2;
    self.is_cycling_select_button = undefined;
}


cycle_menu_down_button()
{
    if (isDefined(self.is_cycling_down_button))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_down_button = true;

    self.menu_down_button_index += 1;

    if (self.menu_down_button_index >= 3)
        self.menu_down_button_index = 0;

    buttonName = get_menu_down_button_name(self.menu_down_button_index, self.langLEN);

    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_down_button)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Bajar: " + buttonName);
                else
                    self.menu_current.items[i].item setText("Go Down: " + buttonName);
                break;
            }
        }
    }

    wait 0.2;
    self.is_cycling_down_button = undefined;
}


cycle_menu_up_button()
{
    if (isDefined(self.is_cycling_up_button))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_up_button = true;

    self.menu_up_button_index += 1;

    if (self.menu_up_button_index >= 3)
        self.menu_up_button_index = 0;

    buttonName = get_menu_up_button_name(self.menu_up_button_index, self.langLEN);

    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_up_button)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Subir: " + buttonName);
                else
                    self.menu_current.items[i].item setText("Go Up: " + buttonName);
                break;
            }
        }
    }

    wait 0.2;
    self.is_cycling_up_button = undefined;
}


cycle_menu_cancel_button()
{
    if (isDefined(self.is_cycling_cancel_button))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_cancel_button = true;

    self.menu_cancel_button_index += 1;

    if (self.menu_cancel_button_index >= 2)
        self.menu_cancel_button_index = 0;

    buttonName = get_menu_cancel_button_name(self.menu_cancel_button_index, self.langLEN);

    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_cancel_button)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Cancelar: " + buttonName);
                else
                    self.menu_current.items[i].item setText("Cancel: " + buttonName);
                break;
            }
        }
    }

    wait 0.2;
    self.is_cycling_cancel_button = undefined;
}


are_legacy_mods_active()
{
    return (level.player_health_display.enabled || level.zombie_health_display.enabled || level.zombie_counter_display.enabled);
}


disable_all_legacy_mods()
{
    legacy_was_active = false;

    if (level.player_health_display.enabled)
    {
        scripts\zm\legacy_mods_performance::toggle_player_health_display(self);
        legacy_was_active = true;
    }

    if (level.zombie_health_display.enabled)
    {
        scripts\zm\legacy_mods_performance::toggle_zombie_health_display(self);
        legacy_was_active = true;
    }

    if (level.zombie_counter_display.enabled)
    {
        scripts\zm\legacy_mods_performance::toggle_zombie_counter_display(self);
        legacy_was_active = true;
    }

    return legacy_was_active;
}


open_performance_mods_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "MODS Heredado" : "LEGACY MODS";
    menu = create_menu(title, self);
    menu.parent_menu = "littlegods";

    
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();

    if (self.langLEN == 0) 
    {
        
        player_health_item = add_menu_item(menu, "Vida Jugador", ::open_player_health_config_menu);
        if ((borders_active && !level.player_health_display.enabled) ||
            (healthbar_active && !level.player_health_display.enabled) ||
            (healthbarzombie_active && !level.player_health_display.enabled))
        {
            player_health_item.item.color = (1, 0.2, 0.2); 
        }

        
        zombie_health_item = add_menu_item(menu, "Vida Zombie", ::open_zombie_health_config_menu);
        if ((borders_active && !level.zombie_health_display.enabled) ||
            (healthbar_active && !level.zombie_health_display.enabled) ||
            (healthbarzombie_active && !level.zombie_health_display.enabled))
        {
            zombie_health_item.item.color = (1, 0.2, 0.2); 
        }

        
        zombie_counter_item = add_menu_item(menu, "Contador Zombies", ::open_zombie_counter_config_menu);
        if ((borders_active && !level.zombie_counter_display.enabled) ||
            (healthbar_active && !level.zombie_counter_display.enabled) ||
            (healthbarzombie_active && !level.zombie_counter_display.enabled))
        {
            zombie_counter_item.item.color = (1, 0.2, 0.2); 
        }

        
        mode_text = (level.legacy_display_mode == "littlegods") ? "LITTLEGODS" : "CLASSIC";
        add_menu_item(menu, "Modo: " + mode_text, ::cycle_legacy_display_mode);

        add_menu_item(menu, "Volver", ::open_mods_littlegods_menu);
    }
    else 
    {
        
        player_health_item = add_menu_item(menu, "Player Health", ::open_player_health_config_menu);
        if ((borders_active && !level.player_health_display.enabled) ||
            (healthbar_active && !level.player_health_display.enabled) ||
            (healthbarzombie_active && !level.player_health_display.enabled))
        {
            player_health_item.item.color = (1, 0.2, 0.2); 
        }

        
        zombie_health_item = add_menu_item(menu, "Zombie Health", ::open_zombie_health_config_menu);
        if ((borders_active && !level.zombie_health_display.enabled) ||
            (healthbar_active && !level.zombie_health_display.enabled) ||
            (healthbarzombie_active && !level.zombie_health_display.enabled))
        {
            zombie_health_item.item.color = (1, 0.2, 0.2); 
        }

        
        zombie_counter_item = add_menu_item(menu, "Zombie Counter", ::open_zombie_counter_config_menu);
        if ((borders_active && !level.zombie_counter_display.enabled) ||
            (healthbar_active && !level.zombie_counter_display.enabled) ||
            (healthbarzombie_active && !level.zombie_counter_display.enabled))
        {
            zombie_counter_item.item.color = (1, 0.2, 0.2); 
        }

        
        mode_text = (level.legacy_display_mode == "littlegods") ? "LITTLEGODS" : "CLASSIC";
        add_menu_item(menu, "Mode: " + mode_text, ::cycle_legacy_display_mode);

        add_menu_item(menu, "Back", ::open_mods_littlegods_menu);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


toggle_player_health_display()
{
    
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();

    if (!level.player_health_display.enabled && (borders_active || healthbar_active || healthbarzombie_active))
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^1No se puede activar mientras las barras de vida o bordes están activos");
        else
            self iPrintLnBold("^1Cannot activate while health bars or borders are active");
        return;
    }

    
    if (!level.player_health_display.enabled && legacy_mods_active)
    {
        
        
    }

    scripts\zm\legacy_mods_performance::toggle_player_health_display(self);

    
    if (isDefined(self.menu_current) && (self.menu_current.title == "VIDA JUGADOR" || self.menu_current.title == "PLAYER HEALTH"))
    {
        
        if (isDefined(self.menu_current.items[0]) && isDefined(self.menu_current.items[0].item))
        {
            status = level.player_health_display.enabled ? "ON" : "OFF";
            self.menu_current.items[0].item setText("Estado: " + status);
        }
        
        update_config_menu_visibility(self.menu_current);
    }
    else
    {
        
        wait 0.1;
        if (isDefined(self.menu_current))
        {
            self notify("destroy_current_menu");
            self thread open_player_health_config_menu();
        }
    }
}

toggle_zombie_health_display()
{
    
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;

    if (!level.zombie_health_display.enabled && (borders_active || healthbar_active || healthbarzombie_active))
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^1No se puede activar mientras las barras de vida o bordes están activos");
        else
            self iPrintLnBold("^1Cannot activate while health bars or borders are active");
        return;
    }

    scripts\zm\legacy_mods_performance::toggle_zombie_health_display(self);

    
    if (isDefined(self.menu_current) && (self.menu_current.title == "VIDA ZOMBIE" || self.menu_current.title == "ZOMBIE HEALTH"))
    {
        
        if (isDefined(self.menu_current.items[0]) && isDefined(self.menu_current.items[0].item))
        {
            status = level.zombie_health_display.enabled ? "ON" : "OFF";
            self.menu_current.items[0].item setText("Estado: " + status);
        }
        
        update_config_menu_visibility(self.menu_current);
    }
    else
    {
        
        wait 0.1;
        if (isDefined(self.menu_current))
        {
            self notify("destroy_current_menu");
            self thread open_zombie_health_config_menu();
        }
    }
}

toggle_zombie_counter_display()
{
    
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;

    if (!level.zombie_counter_display.enabled && (borders_active || healthbar_active || healthbarzombie_active))
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^1No se puede activar mientras las barras de vida o bordes están activos");
        else
            self iPrintLnBold("^1Cannot activate while health bars or borders are active");
        return;
    }

    scripts\zm\legacy_mods_performance::toggle_zombie_counter_display(self);

    
    if (isDefined(self.menu_current) && (self.menu_current.title == "CONTADOR ZOMBIES" || self.menu_current.title == "ZOMBIE COUNTER"))
    {
        
        if (isDefined(self.menu_current.items[0]) && isDefined(self.menu_current.items[0].item))
        {
            status = level.zombie_counter_display.enabled ? "ON" : "OFF";
            self.menu_current.items[0].item setText("Estado: " + status);
        }
        
        update_config_menu_visibility(self.menu_current);
    }
    else
    {
        
        wait 0.1;
        if (isDefined(self.menu_current))
        {
            self notify("destroy_current_menu");
            self thread open_zombie_counter_config_menu();
        }
    }
}






open_player_health_config_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "VIDA JUGADOR" : "PLAYER HEALTH";
    menu = create_menu(title, self);
    menu.parent_menu = "performance_mods";

    if (self.langLEN == 0) 
    {
        
        status = level.player_health_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Estado: " + status, ::toggle_player_health_display);

        
        screen_width = 640; 
        right_margin = 10;  
        top_right_x = screen_width - right_margin;

        if (level.player_health_display.x == 10 && level.player_health_display.y == 50)
            pos_text = "ARRIBA IZQUIERDA";
        else if (level.player_health_display.x == top_right_x && level.player_health_display.y == 50)
            pos_text = "ARRIBA DERECHA";
        else
            pos_text = "ARRIBA IZQUIERDA"; 
        pos_item = add_menu_item(menu, "Posición: " + pos_text, ::cycle_player_health_position);
        pos_item.item.alpha = (level.player_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        
        if (!isDefined(level.player_health_display.color_index))
            level.player_health_display.color_index = 0;
        color_text = get_color_name_by_index(level.player_health_display.color_index, self.langLEN);
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_player_health_color);
        color_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        
        if (level.player_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.player_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.player_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "PERSONALIZADO";
        alpha_item = add_menu_item(menu, "Transparencia: " + alpha_text, ::cycle_player_health_alpha);
        alpha_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        
        gradient_status = level.player_health_display.color_gradient_enabled ? "ON" : "OFF";
        gradient_item = add_menu_item(menu, "Degradado Colores: " + gradient_status, ::toggle_player_health_gradient);
        gradient_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        add_menu_item(menu, "Volver", ::open_performance_mods_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        status = level.player_health_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Status: " + status, ::toggle_player_health_display);

        
        screen_width = 640; 
        right_margin = 10;  
        top_right_x = screen_width - right_margin;

        if (level.player_health_display.x == 10 && level.player_health_display.y == 50)
            pos_text = "TOP LEFT";
        else if (level.player_health_display.x == top_right_x && level.player_health_display.y == 50)
            pos_text = "TOP RIGHT";
        else
            pos_text = "TOP LEFT"; 
        pos_item = add_menu_item(menu, "Position: " + pos_text, ::cycle_player_health_position);
        pos_item.item.alpha = (level.player_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        
        if (!isDefined(level.player_health_display.color_index))
            level.player_health_display.color_index = 0;
        color_text = get_color_name_by_index(level.player_health_display.color_index, self.langLEN);
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_player_health_color);
        color_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        
        if (level.player_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.player_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.player_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "CUSTOM";
        alpha_item = add_menu_item(menu, "Transparency: " + alpha_text, ::cycle_player_health_alpha);
        alpha_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        
        gradient_status = level.player_health_display.color_gradient_enabled ? "ON" : "OFF";
        gradient_item = add_menu_item(menu, "Color Gradient: " + gradient_status, ::toggle_player_health_gradient);
        gradient_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        add_menu_item(menu, "Back", ::open_performance_mods_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(menu.user.font_animation_index) && menu.user.font_animation_index > 0) {
        scripts\zm\style_font_animation::apply_font_animation(menu, menu.user.font_animation_index);
    }

    self thread menu_control(menu);
}


open_zombie_health_config_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "VIDA ZOMBIE" : "ZOMBIE HEALTH";
    menu = create_menu(title, self);
    menu.parent_menu = "performance_mods";

    if (self.langLEN == 0) 
    {
        
        status = level.zombie_health_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Estado: " + status, ::toggle_zombie_health_display);

        
        if (level.zombie_health_display.x == 10 && level.zombie_health_display.y == 60)
            pos_text = "ARRIBA IZQUIERDA";
        else if (level.zombie_health_display.x == 630 && level.zombie_health_display.y == 60)
            pos_text = "ARRIBA DERECHA";
        else
            pos_text = "ARRIBA IZQUIERDA"; 
        pos_item = add_menu_item(menu, "Posición: " + pos_text, ::cycle_zombie_health_position);
        pos_item.item.alpha = (level.zombie_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        
        if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 1)
            color_text = "BLANCO";
        else if (level.zombie_health_display.color[0] == 0 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 0)
            color_text = "VERDE";
        else if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 0 && level.zombie_health_display.color[2] == 0)
            color_text = "ROJO";
        else if (level.zombie_health_display.color[0] == 0 && level.zombie_health_display.color[1] == 0 && level.zombie_health_display.color[2] == 1)
            color_text = "AZUL";
        else if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 0)
            color_text = "AMARILLO";
        else
            color_text = "PERSONALIZADO";
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_zombie_health_color);
        color_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        
        if (level.zombie_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "PERSONALIZADO";
        alpha_item = add_menu_item(menu, "Transparencia: " + alpha_text, ::cycle_zombie_health_alpha);
        alpha_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        
        gradient_status = level.zombie_health_display.color_gradient_enabled ? "ON" : "OFF";
        gradient_item = add_menu_item(menu, "Degradado Colores: " + gradient_status, ::toggle_zombie_health_gradient);
        gradient_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        add_menu_item(menu, "Volver", ::open_performance_mods_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        status = level.zombie_health_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Status: " + status, ::toggle_zombie_health_display);

        
        if (level.zombie_health_display.x == 10 && level.zombie_health_display.y == 60)
            pos_text = "TOP LEFT";
        else if (level.zombie_health_display.x == 630 && level.zombie_health_display.y == 60)
            pos_text = "TOP RIGHT";
        else
            pos_text = "TOP LEFT"; 
        pos_item = add_menu_item(menu, "Position: " + pos_text, ::cycle_zombie_health_position);
        pos_item.item.alpha = (level.zombie_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        
        if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 1)
            color_text = "WHITE";
        else if (level.zombie_health_display.color[0] == 0 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 0)
            color_text = "GREEN";
        else if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 0 && level.zombie_health_display.color[2] == 0)
            color_text = "RED";
        else if (level.zombie_health_display.color[0] == 0 && level.zombie_health_display.color[1] == 0 && level.zombie_health_display.color[2] == 1)
            color_text = "BLUE";
        else if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 0)
            color_text = "YELLOW";
        else
            color_text = "CUSTOM";
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_zombie_health_color);
        color_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        
        if (level.zombie_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "CUSTOM";
        alpha_item = add_menu_item(menu, "Transparency: " + alpha_text, ::cycle_zombie_health_alpha);
        alpha_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        
        gradient_status = level.zombie_health_display.color_gradient_enabled ? "ON" : "OFF";
        gradient_item = add_menu_item(menu, "Color Gradient: " + gradient_status, ::toggle_zombie_health_gradient);
        gradient_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        add_menu_item(menu, "Back", ::open_performance_mods_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(menu.user.font_animation_index) && menu.user.font_animation_index > 0) {
        scripts\zm\style_font_animation::apply_font_animation(menu, menu.user.font_animation_index);
    }

    self thread menu_control(menu);
}


open_zombie_counter_config_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "CONTADOR ZOMBIES" : "ZOMBIE COUNTER";
    menu = create_menu(title, self);
    menu.parent_menu = "performance_mods";

    if (self.langLEN == 0) 
    {
        
        status = level.zombie_counter_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Estado: " + status, ::toggle_zombie_counter_display);

        
        if (level.zombie_counter_display.x == 10 && level.zombie_counter_display.y == 70)
            pos_text = "ARRIBA IZQUIERDA";
        else if (level.zombie_counter_display.x == 630 && level.zombie_counter_display.y == 70)
            pos_text = "ARRIBA DERECHA";
        else
            pos_text = "ARRIBA IZQUIERDA"; 
        pos_item = add_menu_item(menu, "Posición: " + pos_text, ::cycle_zombie_counter_position);
        pos_item.item.alpha = (level.zombie_counter_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        
        if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 1)
            color_text = "BLANCO";
        else if (level.zombie_counter_display.color[0] == 0 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 0)
            color_text = "VERDE";
        else if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 0 && level.zombie_counter_display.color[2] == 0)
            color_text = "ROJO";
        else if (level.zombie_counter_display.color[0] == 0 && level.zombie_counter_display.color[1] == 0 && level.zombie_counter_display.color[2] == 1)
            color_text = "AZUL";
        else if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 0)
            color_text = "AMARILLO";
        else
            color_text = "PERSONALIZADO";
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_zombie_counter_color);
        color_item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;

        
        if (level.zombie_counter_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_counter_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_counter_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "PERSONALIZADO";
        alpha_item = add_menu_item(menu, "Transparencia: " + alpha_text, ::cycle_zombie_counter_alpha);
        alpha_item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;

        add_menu_item(menu, "Volver", ::open_performance_mods_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        status = level.zombie_counter_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Status: " + status, ::toggle_zombie_counter_display);

        
        if (level.zombie_counter_display.x == 10 && level.zombie_counter_display.y == 70)
            pos_text = "TOP LEFT";
        else if (level.zombie_counter_display.x == 630 && level.zombie_counter_display.y == 70)
            pos_text = "TOP RIGHT";
        else
            pos_text = "TOP LEFT"; 
        pos_item = add_menu_item(menu, "Position: " + pos_text, ::cycle_zombie_counter_position);
        pos_item.item.alpha = (level.zombie_counter_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        
        if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 1)
            color_text = "WHITE";
        else if (level.zombie_counter_display.color[0] == 0 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 0)
            color_text = "GREEN";
        else if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 0 && level.zombie_counter_display.color[2] == 0)
            color_text = "RED";
        else if (level.zombie_counter_display.color[0] == 0 && level.zombie_counter_display.color[1] == 0 && level.zombie_counter_display.color[2] == 1)
            color_text = "BLUE";
        else if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 0)
            color_text = "YELLOW";
        else
            color_text = "CUSTOM";
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_zombie_counter_color);
        color_item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;

        
        if (level.zombie_counter_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_counter_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_counter_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "CUSTOM";
        alpha_item = add_menu_item(menu, "Transparency: " + alpha_text, ::cycle_zombie_counter_alpha);
        alpha_item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;

        add_menu_item(menu, "Back", ::open_performance_mods_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(menu.user.font_animation_index) && menu.user.font_animation_index > 0) {
        scripts\zm\style_font_animation::apply_font_animation(menu, menu.user.font_animation_index);
    }

    self thread menu_control(menu);
}






update_config_menu_visibility(menu)
{
    if (!isDefined(menu) || !isDefined(menu.items))
        return;

    
    for(i = 0; i < menu.items.size; i++)
    {
        if (!isDefined(menu.items[i]) || !isDefined(menu.items[i].item))
            continue;

        item = menu.items[i];

        
            if (menu.title == "VIDA JUGADOR" || menu.title == "PLAYER HEALTH")
            {
            
            if (isDefined(item.func))
            {
                
                if (item.func == ::cycle_player_health_position)
                    item.item.alpha = (level.player_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;
                
                else if (item.func == ::cycle_player_health_color)
                    item.item.alpha = level.player_health_display.enabled ? 1 : 0;
                
                else if (item.func == ::cycle_player_health_alpha)
                    item.item.alpha = level.player_health_display.enabled ? 1 : 0;
                
                else if (item.func == ::toggle_player_health_gradient)
                    item.item.alpha = level.player_health_display.enabled ? 1 : 0;
            }
            }
            else if (menu.title == "VIDA ZOMBIE" || menu.title == "ZOMBIE HEALTH")
            {
            
            if (isDefined(item.func))
            {
                
                if (item.func == ::cycle_zombie_health_position)
                    item.item.alpha = (level.zombie_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;
                
                else if (item.func == ::cycle_zombie_health_color)
                    item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;
                
                else if (item.func == ::cycle_zombie_health_alpha)
                    item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;
                
                else if (item.func == ::toggle_zombie_health_gradient)
                    item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;
            }
            }
            else if (menu.title == "CONTADOR ZOMBIES" || menu.title == "ZOMBIE COUNTER")
            {
            
            if (isDefined(item.func))
            {
                
                if (item.func == ::cycle_zombie_counter_position)
                    item.item.alpha = (level.zombie_counter_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;
                
                else if (item.func == ::cycle_zombie_counter_color)
                    item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;
                
                else if (item.func == ::cycle_zombie_counter_alpha)
                    item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;
            }
        }
    }
}


update_menu_color_text(menu_title_es, menu_title_en, color_function)
{
    if (!isDefined(self.menu_current) || !isDefined(self.menu_current.items))
        return;

    
    for(i = 0; i < self.menu_current.items.size; i++)
    {
        if (isDefined(self.menu_current.items[i]) &&
            isDefined(self.menu_current.items[i].func) &&
            self.menu_current.items[i].func == color_function)
        {
            if (isDefined(self.menu_current.items[i].item))
            {
                
                color_index = undefined;

                if (menu_title_es == "VIDA JUGADOR" || menu_title_en == "PLAYER HEALTH")
                    color_index = level.player_health_display.color_index;
                else if (menu_title_es == "VIDA ZOMBIE" || menu_title_en == "ZOMBIE HEALTH")
                    color_index = level.zombie_health_display.color_index;
                else if (menu_title_es == "CONTADOR ZOMBIES" || menu_title_en == "ZOMBIE COUNTER")
                    color_index = level.zombie_counter_display.color_index;

                if (isDefined(color_index))
                {
                    color_name = get_color_name_by_index(color_index, self.langLEN);
                    color_label = (self.langLEN == 0) ? "Color: " : "Color: ";
                    self.menu_current.items[i].item setText(color_label + color_name);
            }
        }
            break;
        }
    }
}


update_all_config_menu_visibility(player)
{
    
    

    
    
    
}





cycle_legacy_display_mode()
{
    
    if (level.legacy_display_mode == "littlegods")
    {
        scripts\zm\legacy_mods_performance::switch_legacy_display_mode("classic");
    }
    else
    {
        scripts\zm\legacy_mods_performance::switch_legacy_display_mode("littlegods");
    }

    
    wait 0.05;

    
    if (isDefined(self.menu_current))
    {
        mode_text = (level.legacy_display_mode == "littlegods") ? "LITTLEGODS" : "CLASSIC";

        
        if (self.menu_current.title == "MODS Heredado" || self.menu_current.title == "LEGACY MODS")
        {
            
            for(i = 0; i < self.menu_current.items.size; i++)
            {
                if (isDefined(self.menu_current.items[i]) &&
                    isDefined(self.menu_current.items[i].func) &&
                    self.menu_current.items[i].func == ::cycle_legacy_display_mode)
                {
                    if (isDefined(self.menu_current.items[i].item))
            {
                mode_label = (self.langLEN == 0) ? "Modo: " : "Mode: ";
                        self.menu_current.items[i].item setText(mode_label + mode_text);
            }
                    break;
        }
    }

            
            update_all_config_menu_visibility(self);
        }
    }
}


color_approx_equal(color1, color2, tolerance)
{
    if (!isDefined(color1) || !isDefined(color2) || color1.size < 3 || color2.size < 3)
        return false;

    for(i = 0; i < 3; i++)
    {
        if (abs(color1[i] - color2[i]) > tolerance)
            return false;
    }

    return true;
}


get_color_name_by_index(color_index, lang_index)
{
    if (!isDefined(color_index))
        color_index = 0;

    
    if (lang_index == 0)
    {
        switch(color_index)
        {
            case 0: return "BLANCO";
            case 1: return "VERDE";
            case 2: return "ROJO";
            case 3: return "AZUL";
            case 4: return "AMARILLO";
            case 5: return "CIAN";
            case 6: return "MAGENTA";
            case 7: return "NARANJA";
            case 8: return "ROSA";
            case 9: return "PÚRPURA";
            case 10: return "GRIS";
            case 11: return "NEGRO";
            default: return "PERSONALIZADO";
        }
    }
    
    else
    {
        switch(color_index)
        {
            case 0: return "WHITE";
            case 1: return "GREEN";
            case 2: return "RED";
            case 3: return "BLUE";
            case 4: return "YELLOW";
            case 5: return "CYAN";
            case 6: return "MAGENTA";
            case 7: return "ORANGE";
            case 8: return "PINK";
            case 9: return "PURPLE";
            case 10: return "GRAY";
            case 11: return "BLACK";
            default: return "CUSTOM";
        }
    }
}


get_color_name(color, lang_index)
{
    if (!isDefined(color) || color.size < 3)
        return (lang_index == 0) ? "PERSONALIZADO" : "CUSTOM";

    
    tolerance = 0.05; 

    
    if (color_approx_equal(color, (1, 1, 1), tolerance))
        return (lang_index == 0) ? "BLANCO" : "WHITE";
    
    else if (color_approx_equal(color, (0, 1, 0), tolerance))
        return (lang_index == 0) ? "VERDE" : "GREEN";
    
    else if (color_approx_equal(color, (1, 0, 0), tolerance))
        return (lang_index == 0) ? "ROJO" : "RED";
    
    else if (color_approx_equal(color, (0, 0, 1), tolerance))
        return (lang_index == 0) ? "AZUL" : "BLUE";
    
    else if (color_approx_equal(color, (1, 1, 0), tolerance))
        return (lang_index == 0) ? "AMARILLO" : "YELLOW";
    
    else if (color_approx_equal(color, (0, 1, 1), tolerance))
        return (lang_index == 0) ? "CIAN" : "CYAN";
    
    else if (color_approx_equal(color, (1, 0, 1), tolerance))
        return (lang_index == 0) ? "MAGENTA" : "MAGENTA";
    
    else if (color_approx_equal(color, (1, 0.5, 0), tolerance))
        return (lang_index == 0) ? "NARANJA" : "ORANGE";
    
    else if (color_approx_equal(color, (1, 0.4, 0.7), tolerance))
        return (lang_index == 0) ? "ROSA" : "PINK";
    
    else if (color_approx_equal(color, (0.5, 0, 0.5), tolerance))
        return (lang_index == 0) ? "PÚRPURA" : "PURPLE";
    
    else if (color_approx_equal(color, (0.5, 0.5, 0.5), tolerance))
        return (lang_index == 0) ? "GRIS" : "GRAY";
    
    else if (color_approx_equal(color, (0, 0, 0), tolerance))
        return (lang_index == 0) ? "NEGRO" : "BLACK";

    
    return (lang_index == 0) ? "PERSONALIZADO" : "CUSTOM";
}

cycle_player_health_position()
{
    
    if (level.legacy_display_mode != "littlegods")
        return;

    
    screen_width = 640; 
    right_margin = 10;  
    top_right_x = screen_width - right_margin;

    
    if (level.player_health_display.x == 10 && level.player_health_display.y == 50) 
    {
        level.player_health_display.x = top_right_x;
        level.player_health_display.y = 50; 
    }
    else 
    {
        level.player_health_display.x = 10;
        level.player_health_display.y = 50; 
    }

    
    foreach(player in level.players)
    {
        scripts\zm\legacy_mods_performance::update_player_health_position(player);
    }

    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[1]) && isDefined(self.menu_current.items[1].item))
    {
        
        screen_width = 640; 
        right_margin = 10;  
        top_right_x = screen_width - right_margin;

        
        if (level.player_health_display.x == 10 && level.player_health_display.y == 50)
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT";
        else if (level.player_health_display.x == top_right_x && level.player_health_display.y == 50)
            pos_text = (self.langLEN == 0) ? "ARRIBA DERECHA" : "TOP RIGHT";
        else
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT"; 

        
        pos_label = (self.langLEN == 0) ? "Posición: " : "Position: ";
        self.menu_current.items[1].item setText(pos_label + pos_text);
    }
}


cycle_player_health_color()
{
    
    if (!isDefined(level.player_health_display.color_index))
        level.player_health_display.color_index = 0;

    
    level.player_health_display.color_index++;
    if (level.player_health_display.color_index > 11)
        level.player_health_display.color_index = 0;

    
    switch(level.player_health_display.color_index)
    {
        case 0:  level.player_health_display.color = (1, 1, 1); break;      
        case 1:  level.player_health_display.color = (0, 1, 0); break;      
        case 2:  level.player_health_display.color = (1, 0, 0); break;      
        case 3:  level.player_health_display.color = (0, 0, 1); break;      
        case 4:  level.player_health_display.color = (1, 1, 0); break;      
        case 5:  level.player_health_display.color = (0, 1, 1); break;      
        case 6:  level.player_health_display.color = (1, 0, 1); break;      
        case 7:  level.player_health_display.color = (1, 0.5, 0); break;    
        case 8:  level.player_health_display.color = (1, 0.4, 0.7); break;  
        case 9:  level.player_health_display.color = (0.5, 0, 0.5); break;  
        case 10: level.player_health_display.color = (0.5, 0.5, 0.5); break;
        case 11: level.player_health_display.color = (0, 0, 0); break;      
    }

    
    foreach(player in level.players)
    {
        if (isDefined(player.player_health_hud))
        {
            player.player_health_hud.color = level.player_health_display.color;
        }
        if (isDefined(player.player_health_value))
        {
            player.player_health_value.color = level.player_health_display.color;
        }
    }

    
    update_menu_color_text("VIDA JUGADOR", "PLAYER HEALTH", ::cycle_player_health_color);
}

cycle_player_health_alpha()
{
    
    if (level.player_health_display.alpha == 0.5)
        level.player_health_display.alpha = 0.75;
    else if (level.player_health_display.alpha == 0.75)
        level.player_health_display.alpha = 1.0;
    else 
        level.player_health_display.alpha = 0.5;

    
    foreach(player in level.players)
    {
        if (isDefined(player.player_health_hud))
        {
            player.player_health_hud.alpha = level.player_health_display.alpha;
        }
        if (isDefined(player.player_health_value))
        {
            player.player_health_value.alpha = level.player_health_display.alpha;
        }
    }

    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[3]) && isDefined(self.menu_current.items[3].item))
    {
        
        if (level.player_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.player_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.player_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = (self.langLEN == 0) ? "PERSONALIZADO" : "CUSTOM";

        
        self.menu_current.items[3].item setText("Transparencia: " + alpha_text);
    }
}

cycle_zombie_health_position()
{
    
    if (level.legacy_display_mode != "littlegods")
        return;

    
    if (level.zombie_health_display.x == 10 && level.zombie_health_display.y == 60) 
    {
        level.zombie_health_display.x = 630;
        level.zombie_health_display.y = 60; 
    }
    else 
    {
        level.zombie_health_display.x = 10;
        level.zombie_health_display.y = 60; 
    }

    
    foreach(player in level.players)
    {
        scripts\zm\legacy_mods_performance::update_zombie_health_position(player);
    }

    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[1]) && isDefined(self.menu_current.items[1].item))
    {
        
        if (level.zombie_health_display.x == 10 && level.zombie_health_display.y == 60)
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT";
        else if (level.zombie_health_display.x == 630 && level.zombie_health_display.y == 60)
            pos_text = (self.langLEN == 0) ? "ARRIBA DERECHA" : "TOP RIGHT";
        else
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT"; 

        
        pos_label = (self.langLEN == 0) ? "Posición: " : "Position: ";
        self.menu_current.items[1].item setText(pos_label + pos_text);
    }
}


cycle_zombie_health_color()
{
    
    if (!isDefined(level.zombie_health_display.color_index))
        level.zombie_health_display.color_index = 0;

    
    level.zombie_health_display.color_index++;
    if (level.zombie_health_display.color_index > 11)
        level.zombie_health_display.color_index = 0;

    
    switch(level.zombie_health_display.color_index)
    {
        case 0:  level.zombie_health_display.color = (1, 1, 1); break;      
        case 1:  level.zombie_health_display.color = (0, 1, 0); break;      
        case 2:  level.zombie_health_display.color = (1, 0, 0); break;      
        case 3:  level.zombie_health_display.color = (0, 0, 1); break;      
        case 4:  level.zombie_health_display.color = (1, 1, 0); break;      
        case 5:  level.zombie_health_display.color = (0, 1, 1); break;      
        case 6:  level.zombie_health_display.color = (1, 0, 1); break;      
        case 7:  level.zombie_health_display.color = (1, 0.5, 0); break;    
        case 8:  level.zombie_health_display.color = (1, 0.4, 0.7); break;  
        case 9:  level.zombie_health_display.color = (0.5, 0, 0.5); break;  
        case 10: level.zombie_health_display.color = (0.5, 0.5, 0.5); break;
        case 11: level.zombie_health_display.color = (0, 0, 0); break;      
    }

    
    foreach(player in level.players)
    {
        if (isDefined(player.zombie_health_hud))
        {
            player.zombie_health_hud.color = level.zombie_health_display.color;
        }
        if (isDefined(player.zombie_health_value))
        {
            player.zombie_health_value.color = level.zombie_health_display.color;
        }
    }

    
    update_menu_color_text("VIDA ZOMBIE", "ZOMBIE HEALTH", ::cycle_zombie_health_color);
}

cycle_zombie_health_alpha()
{
    
    if (level.zombie_health_display.alpha == 0.5)
        level.zombie_health_display.alpha = 0.75;
    else if (level.zombie_health_display.alpha == 0.75)
        level.zombie_health_display.alpha = 1.0;
    else 
        level.zombie_health_display.alpha = 0.5;

    
    foreach(player in level.players)
    {
        if (isDefined(player.zombie_health_hud))
        {
            player.zombie_health_hud.alpha = level.zombie_health_display.alpha;
        }
        if (isDefined(player.zombie_health_value))
        {
            player.zombie_health_value.alpha = level.zombie_health_display.alpha;
        }
    }

    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[3]) && isDefined(self.menu_current.items[3].item))
    {
        
        if (level.zombie_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = (self.langLEN == 0) ? "PERSONALIZADO" : "CUSTOM";

        
        self.menu_current.items[3].item setText("Transparencia: " + alpha_text);
    }
}

cycle_zombie_counter_position()
{
    
    if (level.legacy_display_mode != "littlegods")
        return;

    
    if (level.zombie_counter_display.x == 10 && level.zombie_counter_display.y == 70) 
    {
        level.zombie_counter_display.x = 630;
        level.zombie_counter_display.y = 70; 
    }
    else 
    {
        level.zombie_counter_display.x = 10;
        level.zombie_counter_display.y = 70; 
    }

    
    foreach(player in level.players)
    {
        scripts\zm\legacy_mods_performance::update_zombie_counter_position(player);
    }

    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[1]) && isDefined(self.menu_current.items[1].item))
    {
        
        if (level.zombie_counter_display.x == 10 && level.zombie_counter_display.y == 70)
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT";
        else if (level.zombie_counter_display.x == 630 && level.zombie_counter_display.y == 70)
            pos_text = (self.langLEN == 0) ? "ARRIBA DERECHA" : "TOP RIGHT";
        else
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT"; 

        
        pos_label = (self.langLEN == 0) ? "Posición: " : "Position: ";
        self.menu_current.items[1].item setText(pos_label + pos_text);
    }
}


cycle_zombie_counter_color()
{
    
    if (!isDefined(level.zombie_counter_display.color_index))
        level.zombie_counter_display.color_index = 0;

    
    level.zombie_counter_display.color_index++;
    if (level.zombie_counter_display.color_index > 11)
        level.zombie_counter_display.color_index = 0;

    
    switch(level.zombie_counter_display.color_index)
    {
        case 0:  level.zombie_counter_display.color = (1, 1, 1); break;      
        case 1:  level.zombie_counter_display.color = (0, 1, 0); break;      
        case 2:  level.zombie_counter_display.color = (1, 0, 0); break;      
        case 3:  level.zombie_counter_display.color = (0, 0, 1); break;      
        case 4:  level.zombie_counter_display.color = (1, 1, 0); break;      
        case 5:  level.zombie_counter_display.color = (0, 1, 1); break;      
        case 6:  level.zombie_counter_display.color = (1, 0, 1); break;      
        case 7:  level.zombie_counter_display.color = (1, 0.5, 0); break;    
        case 8:  level.zombie_counter_display.color = (1, 0.4, 0.7); break;  
        case 9:  level.zombie_counter_display.color = (0.5, 0, 0.5); break;  
        case 10: level.zombie_counter_display.color = (0.5, 0.5, 0.5); break;
        case 11: level.zombie_counter_display.color = (0, 0, 0); break;      
    }

    
    foreach(player in level.players)
    {
        if (isDefined(player.zombie_counter_hud))
        {
            player.zombie_counter_hud.color = level.zombie_counter_display.color;
        }
        if (isDefined(player.zombie_counter_value))
        {
            player.zombie_counter_value.color = level.zombie_counter_display.color;
        }
    }

    
    update_menu_color_text("CONTADOR ZOMBIES", "ZOMBIE COUNTER", ::cycle_zombie_counter_color);
}

cycle_zombie_counter_alpha()
{
    
    if (level.zombie_counter_display.alpha == 0.5)
        level.zombie_counter_display.alpha = 0.75;
    else if (level.zombie_counter_display.alpha == 0.75)
        level.zombie_counter_display.alpha = 1.0;
    else 
        level.zombie_counter_display.alpha = 0.5;

    
    foreach(player in level.players)
    {
        if (isDefined(player.zombie_counter_hud))
        {
            player.zombie_counter_hud.alpha = level.zombie_counter_display.alpha;
        }
        if (isDefined(player.zombie_counter_value))
        {
            player.zombie_counter_value.alpha = level.zombie_counter_display.alpha;
        }
    }

    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[3]) && isDefined(self.menu_current.items[3].item))
    {
        
        if (level.zombie_counter_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_counter_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_counter_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = (self.langLEN == 0) ? "PERSONALIZADO" : "CUSTOM";

        
        self.menu_current.items[3].item setText("Transparencia: " + alpha_text);
    }
}






toggle_player_health_gradient()
{
    level.player_health_display.color_gradient_enabled = !level.player_health_display.color_gradient_enabled;

    
    if (isDefined(self.menu_current) && (self.menu_current.title == "VIDA JUGADOR" || self.menu_current.title == "PLAYER HEALTH"))
    {
        
        if (isDefined(self.menu_current.items[4]) && isDefined(self.menu_current.items[4].item))
        {
            gradient_status = level.player_health_display.color_gradient_enabled ? "ON" : "OFF";
            if (self.langLEN == 0)
                self.menu_current.items[4].item setText("Degradado Colores: " + gradient_status);
            else
                self.menu_current.items[4].item setText("Color Gradient: " + gradient_status);
        }
    }
}

toggle_zombie_health_gradient()
{
    level.zombie_health_display.color_gradient_enabled = !level.zombie_health_display.color_gradient_enabled;

    
    if (isDefined(self.menu_current) && (self.menu_current.title == "VIDA ZOMBIE" || self.menu_current.title == "ZOMBIE HEALTH"))
    {
        
        if (isDefined(self.menu_current.items[4]) && isDefined(self.menu_current.items[4].item))
        {
            gradient_status = level.zombie_health_display.color_gradient_enabled ? "ON" : "OFF";
            if (self.langLEN == 0)
                self.menu_current.items[4].item setText("Degradado Colores: " + gradient_status);
            else
                self.menu_current.items[4].item setText("Color Gradient: " + gradient_status);
        }
    }
}

cycle_edge_animation_style()
{
    
    if (isDefined(self.is_cycling_edge_animation))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_edge_animation = true;

    
    legacy_mods_active = are_legacy_mods_active();
    
    
    self.edge_animation_style_index += 1;
    
    
    maxEdgeAnimStyles = level.edge_animation_styles.size;
    if (self.edge_animation_style_index >= maxEdgeAnimStyles)
        self.edge_animation_style_index = 0;
    
    
    if (legacy_mods_active && self.edge_animation_style_index > 0)
    {
        self.edge_animation_style_index = 0;
        
        if (self.langLEN == 0)
            self iPrintlnBold("^3Bordes desactivados - Mods de rendimiento activos");
        else
            self iPrintlnBold("^3Borders disabled - Performance mods active");
    }

    
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
    }
    
    
    edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
    
    
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_edge_animation_style)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Animación Borde: " + edgeAnimStyleName);
                else
                    self.menu_current.items[i].item setText("Edge Animation: " + edgeAnimStyleName);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_cycling_edge_animation = undefined;
}






open_weapons_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS" : "WEAPONS";
    menu = create_menu(title, self);
    menu.parent_menu = "player";
    
    if (self.langLEN == 0) 
    {
        
        unlimited_ammo_status = (isDefined(self.unlimited_ammo) && self.unlimited_ammo) ? "ON" : "OFF";
        add_menu_item(menu, "Munición Infinita: " + unlimited_ammo_status, scripts\zm\funciones::toggle_unlimited_ammo);

        add_menu_item(menu, "Arma Aleatoria", ::give_random_weapon_menu);
        add_menu_item(menu, "Mejorar Arma Actual", ::upgrade_current_weapon_menu);
        add_menu_item(menu, "Grupo 1", ::open_weapons_submenu_1);
        add_menu_item(menu, "Grupo 2", ::open_weapons_submenu_2);
        add_menu_item(menu, "Grupo 3", ::open_weapons_submenu_3);
        add_menu_item(menu, "Grupo 4", ::open_weapons_submenu_4);
        add_menu_item(menu, "Grupo 5", ::open_weapons_submenu_5);
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        unlimited_ammo_status = (isDefined(self.unlimited_ammo) && self.unlimited_ammo) ? "ON" : "OFF";
        add_menu_item(menu, "Unlimited Ammo: " + unlimited_ammo_status, scripts\zm\funciones::toggle_unlimited_ammo);

        add_menu_item(menu, "Random Weapon", ::give_random_weapon_menu);
        add_menu_item(menu, "Upgrade Current Weapon", ::upgrade_current_weapon_menu);
        add_menu_item(menu, "Group 1", ::open_weapons_submenu_1);
        add_menu_item(menu, "Group 2", ::open_weapons_submenu_2);
        add_menu_item(menu, "Group 3", ::open_weapons_submenu_3);
        add_menu_item(menu, "Group 4", ::open_weapons_submenu_4);
        add_menu_item(menu, "Group 5", ::open_weapons_submenu_5);
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


give_random_weapon_menu()
{
    self thread scripts\zm\weapon::GiveRandomWeapon();
}


upgrade_current_weapon_menu()
{
    self thread scripts\zm\weapon::Upgrade_arma(undefined);
}


open_weapons_submenu_1()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 1" : "WEAPONS - GROUP 1";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    
    for (i = 1; i <= 7 && i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


open_weapons_submenu_2()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 2" : "WEAPONS - GROUP 2";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    for (i = 8; i <= 14 && i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


open_weapons_submenu_3()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 3" : "WEAPONS - GROUP 3";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    for (i = 15; i <= 21 && i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


open_weapons_submenu_4()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 4" : "WEAPONS - GROUP 4";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    for (i = 22; i <= 28 && i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


open_weapons_submenu_5()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 5" : "WEAPONS - GROUP 5";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    for (i = 29; i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


create_weapon_menu_item(menu, display_name, weapon_name)
{
    item = spawnStruct();
    
    item.item = newClientHudElem(menu.user);
    item.item.vertalign = menu.background_vertalign;
    item.item.horzalign = menu.background_horzalign;
    
    if (menu.background_horzalign == "left")
    {
        item.item.x = menu.background.x + 15;
        item.item.alignX = "left";
    }
    else if (menu.background_horzalign == "right")
    {
        item.item.x = menu.background.x - 15;
        item.item.alignX = "right";
    }
    else
    {
        item.item.x = menu.background.x;
        item.item.alignX = "center";
    }
    
    if (menu.background_vertalign == "top")
    {
        item.item.y = menu.background.y + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    else if (menu.background_vertalign == "bottom")
    {
        item.item.y = menu.background.y + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    else
    {
        total_height = menu.header_height + (menu.item_height * (menu.items.size + 1));
        item.item.y = menu.background.y - (total_height / 2) + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    
    item.item.fontscale = 1.2;
    item.item.alpha = 1;
    
    if (menu.items.size == 0)
        item.item.color = menu.active_color;
    else
        item.item.color = menu.inactive_color;
    
    item.item setText(display_name);
    item.weapon_name = weapon_name;
    item.func = ::give_specific_weapon_menu;
    item.is_menu = false;
    
    return item;
}


give_specific_weapon_menu()
{
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[self.menu_current.selected]))
    {
        weapon_name = self.menu_current.items[self.menu_current.selected].weapon_name;
        if (isDefined(weapon_name))
        {
            self thread scripts\zm\weapon::GiveSpecificWeapon(weapon_name);
        }
    }
}


get_weapon_display_name(weapon_name)
{
    
    display_name = weapon_name;
    
    
    display_name = strTok(display_name, "_")[0];
    
    
    switch(weapon_name)
    {
        case "raygun_mark2_zm": return "Ray Gun Mark II";
        case "ray_gun_zm": return "Ray Gun";
        case "galil_zm": return "Galil";
        case "hamr_zm": return "HAMR";
        case "rpd_zm": return "RPD";
        case "usrpg_zm": return "RPG";
        case "m32_zm": return "M32 (War Machine)";
        case "python_zm": return "Python";
        case "judge_zm": return "Judge";
        case "ak74u_zm": return "AK74u";
        case "tar21_zm": return "TAR-21";
        case "m16_zm": return "M16";
        case "xm8_zm": return "M8A1";
        case "srm1216_zm": return "M1216";
        case "870mcs_zm": return "Remington 870";
        case "dsr50_zm": return "DSR 50";
        case "barretm82_zm": return "Barrett M82";
        case "type95_zm": return "Type 95";
        case "qcw05_zm": return "Chicom";
        case "saiga12_zm": return "S12";
        case "mp5k_zm": return "MP5K";
        case "fnfal_zm": return "FAL";
        case "kard_zm": return "Kap 40";
        case "beretta93r_zm": return "B23R";
        case "fivesevendw_zm": return "Five-Seven DW";
        case "fiveseven_zm": return "Five-Seven";
        case "rottweil72_zm": return "Olympia";
        case "saritch_zm": return "SMR";
        case "m14_zm": return "M14";
        case "knife_ballistic_zm": return "Ballistic Knife";
        case "m1911_zm": return "M1911";
        case "svu_zm": return "SVU";
        case "thompson_zm": return "Thompson";
        case "pdw57_zm": return "PDW-57";
        case "uzi_zm": return "Uzi";
        case "gl_tar21_zm": return "TAR-21 (GL)";
        case "ak47_zm": return "AK-47";
        case "lsat_zm": return "LSAT";
        case "minigun_alcatraz_zm": return "Death Machine";
        case "knife_ballistic_bowie_zm": return "Ballistic Bowie";
        case "knife_ballistic_no_melee_zm": return "Ballistic (No Melee)";
        case "blundergat_zm": return "Blundergat";
        case "blundersplat_zm": return "Acid Gat";
        case "ballista_zm": return "Ballista";
        case "ak74u_extclip_zm": return "AK74u (Ext)";
        case "mp40_zm": return "MP40";
        case "mp40_stalker_zm": return "MP40 (Stalker)";
        case "evoskorpion_zm": return "Skorpion EVO";
        case "mp44_zm": return "STG-44";
        case "scar_zm": return "SCAR";
        case "ksg_zm": return "KSG";
        case "mg08_zm": return "MG08";
        case "c96_zm": return "C96";
        case "beretta93r_extclip_zm": return "B23R (Ext)";
        case "an94_zm": return "AN-94";
        case "rnma_zm": return "Remington New Model";
        case "slowgun_zm": return "Paralyzer";
        default: return display_name;
    }
}


open_staffs_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "BASTONES" : "STAFFS";
    menu = create_menu(title, self);
    menu.parent_menu = "player";
    
    if (self.langLEN == 0) 
    {
        add_menu_item(menu, "Bastón de Fuego", ::give_staff_fire);
        add_menu_item(menu, "Bastón de Hielo", ::give_staff_ice);
        add_menu_item(menu, "Bastón de Viento", ::give_staff_wind);
        add_menu_item(menu, "Bastón de Rayo", ::give_staff_lightning);
        add_menu_item(menu, "Mejorar Bastón", ::upgrade_current_staff);
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        add_menu_item(menu, "Fire Staff", ::give_staff_fire);
        add_menu_item(menu, "Ice Staff", ::give_staff_ice);
        add_menu_item(menu, "Wind Staff", ::give_staff_wind);
        add_menu_item(menu, "Lightning Staff", ::give_staff_lightning);
        add_menu_item(menu, "Upgrade Staff", ::upgrade_current_staff);
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


give_staff_fire()
{
    self thread scripts\zm\weapon::weapon_baston_fire();
}

give_staff_ice()
{
    self thread scripts\zm\weapon::weapon_baston_hielo();
}

give_staff_wind()
{
    self thread scripts\zm\weapon::weapon_baston_aire();
}

give_staff_lightning()
{
    self thread scripts\zm\weapon::weapon_baston_relampago();
}


upgrade_current_staff()
{
    self thread scripts\zm\weapon::upgrade_baston_zm();
}






open_perks_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "PERKS" : "PERKS";
    menu = create_menu(title, self);
    menu.parent_menu = "player";
    
    
    map = getDvar("ui_zm_mapstartlocation");
    
    if (self.langLEN == 0) 
    {
        
        add_menu_item(menu, "Juggernog", ::give_perk_jugger_menu);
        add_menu_item(menu, "Speed Cola", ::give_perk_speed_menu);
        add_menu_item(menu, "Double Tap", ::give_perk_doubletap_menu);
        
        
        if (map != "prison" && map != "cellblock" && map != "docks" && map != "showers" && map != "rooftop")
            add_menu_item(menu, "Quick Revive", ::give_perk_revive_menu);
        
        
        if (map == "transit" || map == "town" || map == "farm" || map == "busdepot" || 
            map == "processing" || map == "maze" || 
            map == "highrise" || map == "building1top" || map == "redroom" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Stamin-Up", ::give_perk_staminup_menu);
        
        
        if (map == "processing" || map == "maze" || 
            map == "highrise" || map == "building1top" || map == "redroom" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Mule Kick", ::give_perk_mule_menu);
        
        
        if (map == "prison" || map == "cellblock" || map == "docks" || map == "showers" || map == "rooftop" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Electric Cherry", ::give_perk_cherry_menu);
        
        
        if (map == "prison" || map == "cellblock" || map == "docks" || map == "showers" || map == "rooftop" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Deadshot", ::give_perk_deadshot_menu);
        
        
        if (map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "PhD Flopper", ::give_perk_phd_menu);
        
        
        if (map == "processing" || map == "maze")
            add_menu_item(menu, "Vulture Aid", ::give_perk_vulture_menu);
        
        
        if (map == "transit" || map == "town" || map == "farm" || map == "busdepot")
            add_menu_item(menu, "Tombstone", ::give_perk_tombstone_menu);
        
        
        if (map == "highrise" || map == "building1top" || map == "redroom")
            add_menu_item(menu, "Who's Who", ::give_perk_whoswho_menu);
        
        add_menu_item(menu, "Todos los Perks", ::give_all_perks_menu);
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        add_menu_item(menu, "Juggernog", ::give_perk_jugger_menu);
        add_menu_item(menu, "Speed Cola", ::give_perk_speed_menu);
        add_menu_item(menu, "Double Tap", ::give_perk_doubletap_menu);
        
        
        if (map != "prison" && map != "cellblock" && map != "docks" && map != "showers" && map != "rooftop")
            add_menu_item(menu, "Quick Revive", ::give_perk_revive_menu);
        
        
        if (map == "transit" || map == "town" || map == "farm" || map == "busdepot" || 
            map == "processing" || map == "maze" || 
            map == "highrise" || map == "building1top" || map == "redroom" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Stamin-Up", ::give_perk_staminup_menu);
        
        
        if (map == "processing" || map == "maze" || 
            map == "highrise" || map == "building1top" || map == "redroom" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Mule Kick", ::give_perk_mule_menu);
        
        
        if (map == "prison" || map == "cellblock" || map == "docks" || map == "showers" || map == "rooftop" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Electric Cherry", ::give_perk_cherry_menu);
        
        
        if (map == "prison" || map == "cellblock" || map == "docks" || map == "showers" || map == "rooftop" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Deadshot", ::give_perk_deadshot_menu);
        
        
        if (map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "PhD Flopper", ::give_perk_phd_menu);
        
        
        if (map == "processing" || map == "maze")
            add_menu_item(menu, "Vulture Aid", ::give_perk_vulture_menu);
        
        
        if (map == "transit" || map == "town" || map == "farm" || map == "busdepot")
            add_menu_item(menu, "Tombstone", ::give_perk_tombstone_menu);
        
        
        if (map == "highrise" || map == "building1top" || map == "redroom")
            add_menu_item(menu, "Who's Who", ::give_perk_whoswho_menu);
        
        add_menu_item(menu, "All Perks", ::give_all_perks_menu);
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}


give_perk_jugger_menu()
{
    self thread scripts\zm\weapon::give_perks_jugger();
}

give_perk_revive_menu()
{
    self thread scripts\zm\weapon::give_perks_revive();
}

give_perk_speed_menu()
{
    self thread scripts\zm\weapon::give_perks_speed();
}

give_perk_doubletap_menu()
{
    self thread scripts\zm\weapon::give_perks_dobletap();
}

give_perk_staminup_menu()
{
    self thread scripts\zm\weapon::give_perks_correr();
}

give_perk_mule_menu()
{
    self thread scripts\zm\weapon::give_perks_mule();
}

give_perk_cherry_menu()
{
    self thread scripts\zm\weapon::give_perks_cherry();
}

give_perk_deadshot_menu()
{
    self thread scripts\zm\weapon::give_perks_deashot();
}

give_perk_phd_menu()
{
    self thread scripts\zm\weapon::give_perks_phd();
}

give_perk_vulture_menu()
{
    self thread scripts\zm\weapon::give_perk_sensor();
}

give_perk_tombstone_menu()
{
    self thread scripts\zm\weapon::give_perk_tumba();
}

give_perk_whoswho_menu()
{
    self thread scripts\zm\weapon::give_perk_whoswho();
}

give_all_perks_menu()
{
    self thread scripts\zm\weapon::func_GiveAllPerks();
}






open_enemies_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ENEMIGOS ESPECIALES" : "SPECIAL ENEMIES";
    menu = create_menu(title, self);
    menu.parent_menu = "zombie";
    
    
    map = getDvar("ui_zm_mapstartlocation");
    
    if (self.langLEN == 0) 
    {
        
        if (map == "tomb")
        {
            add_menu_item(menu, "Spawn Panzer Soldat", ::spawn_panzer_menu);
        }

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        if (map == "tomb")
        {
            add_menu_item(menu, "Spawn Panzer Soldat", ::spawn_panzer_menu);
        }

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}



spawn_panzer_menu()
{
    self thread scripts\zm\weapon::spawn_panzer_soldat();
    if(self.langLEN == 0)
    {
        self iPrintlnBold("^3Panzer Soldat a respawneado");
    }
    else
    {
        self iPrintlnBold("^3Panzer Soldat spawned");
    }
}

spawn_hellhound_menu()
{
    self thread scripts\zm\weapon::spawn_hellhounds(1);
}

spawn_dog_round_menu()
{
    self thread scripts\zm\weapon::spawn_dog_round();
}






















open_recent_matches_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "PARTIDAS RECIENTES" : "RECENT MATCHES";
    menu = create_menu(title, self);
    menu.parent_menu = "map";

    
    map_name = getDvar("ui_zm_mapstartlocation");
    player_guid = self getGuid();

    
    if (!isDefined(self.recent_match_index))
        self.recent_match_index = 0;

    
    player_info = (self.langLEN == 0) ? "Jugador: " + self.name : "Player: " + self.name;
    map_info = (self.langLEN == 0) ? "Mapa: " + get_map_display_name_recent(map_name) : "Map: " + get_map_display_name_recent(map_name);

    if (self.langLEN == 0) 
    {
        add_menu_item(menu, player_info, ::do_nothing);
        add_menu_item(menu, map_info, ::do_nothing);
        add_menu_item(menu, "", ::do_nothing); 

        
        recent_files = get_recent_match_files(player_guid, map_name);

        if (isDefined(recent_files) && recent_files.size > 0)
        {
            
            display_index = self.recent_match_index;
            if (display_index >= recent_files.size)
                display_index = 0;

            total_matches = recent_files.size;
            current_match = display_index + 1;

            
            if (total_matches > 1)
            {
                nav_info = "Partida " + current_match + " de " + total_matches;
                add_menu_item(menu, nav_info, ::do_nothing);
            }

            
            match_filename = "scriptdata/recent/" + player_guid + "/" + recent_files[display_index];
            if (fs_testfile(match_filename))
            {
                file = fs_fopen(match_filename, "read");
            if (isDefined(file))
            {
                file_size = fs_length(file);
                content = fs_read(file, file_size);
                fs_fclose(file);

                    
                lines = strTok(content, "\n");
                    round_num = "0";
                    kills = "0";
                    headshots = "0";
                    revives = "0";
                    downs = "0";
                    score = "0";
                    time_info = "N/A";
                    most_used_weapon = "None";

                foreach (line in lines)
                {
                    if (isSubStr(line, "Ronda Alcanzada:"))
                        round_num = getSubStr(line, 17);
                    else if (isSubStr(line, "Kills:"))
                        kills = getSubStr(line, 7);
                    else if (isSubStr(line, "Headshots:"))
                        headshots = getSubStr(line, 11);
                    else if (isSubStr(line, "Revives:"))
                        revives = getSubStr(line, 9);
                    else if (isSubStr(line, "Downs:"))
                        downs = getSubStr(line, 7);
                    else if (isSubStr(line, "Score Total:"))
                        score = getSubStr(line, 13);
                    else if (isSubStr(line, "Arma Mas Usada:"))
                        most_used_weapon = getSubStr(line, 16);
                        else if (isSubStr(line, "Fecha/Hora:"))
                            time_info = getSubStr(line, 11);
                    }


                    add_menu_item(menu, "Estadísticas", ::open_recent_stats_menu);
                    add_menu_item(menu, "Uso de Armas", ::open_weapon_usage_menu);
                    add_menu_item(menu, "Perks Usados", ::open_perks_usage_menu);
                    }
                }

            
            if (total_matches > 1)
            {
                add_menu_item(menu, "", ::do_nothing); 
                add_menu_item(menu, "Cambiar a Partida Anterior", ::cycle_recent_match_back);
                add_menu_item(menu, "Cambiar a Partida Siguiente", ::cycle_recent_match_forward);
            }
        }
        else
        {
            add_menu_item(menu, "NO HAY PARTIDAS RECIENTES", ::do_nothing);
            add_menu_item(menu, "Completa una partida para guardar estadísticas", ::do_nothing);
        }

        add_menu_item(menu, "", ::do_nothing);
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        add_menu_item(menu, player_info, ::do_nothing);
        add_menu_item(menu, map_info, ::do_nothing);
        add_menu_item(menu, "", ::do_nothing); 

        
        recent_files = get_recent_match_files(player_guid, map_name);

        if (isDefined(recent_files) && recent_files.size > 0)
        {
            
            display_index = self.recent_match_index;
            if (display_index >= recent_files.size)
                display_index = 0;

            total_matches = recent_files.size;
            current_match = display_index + 1;

            
            if (total_matches > 1)
            {
                nav_info = "Match " + current_match + " of " + total_matches;
                add_menu_item(menu, nav_info, ::do_nothing);
            }

            
            match_filename = "scriptdata/recent/" + player_guid + "/" + recent_files[display_index];
            if (fs_testfile(match_filename))
            {
                file = fs_fopen(match_filename, "read");
            if (isDefined(file))
            {
                file_size = fs_length(file);
                content = fs_read(file, file_size);
                fs_fclose(file);

                    
                lines = strTok(content, "\n");
                    round_num = "0";
                    kills = "0";
                    headshots = "0";
                    revives = "0";
                    downs = "0";
                    score = "0";
                    time_info = "N/A";
                    most_used_weapon = "None";

                foreach (line in lines)
                {
                    if (isSubStr(line, "Ronda Alcanzada:"))
                        round_num = getSubStr(line, 17);
                    else if (isSubStr(line, "Kills:"))
                        kills = getSubStr(line, 7);
                    else if (isSubStr(line, "Headshots:"))
                        headshots = getSubStr(line, 11);
                    else if (isSubStr(line, "Revives:"))
                        revives = getSubStr(line, 9);
                    else if (isSubStr(line, "Downs:"))
                        downs = getSubStr(line, 7);
                    else if (isSubStr(line, "Score Total:"))
                        score = getSubStr(line, 13);
                    else if (isSubStr(line, "Arma Mas Usada:"))
                        most_used_weapon = getSubStr(line, 16);
                        else if (isSubStr(line, "Fecha/Hora:"))
                            time_info = getSubStr(line, 11);
                    }


                    add_menu_item(menu, "Statistics", ::open_recent_stats_menu);
                    add_menu_item(menu, "Weapon Usage", ::open_weapon_usage_menu);
                    add_menu_item(menu, "Perks Used", ::open_perks_usage_menu);
                    }
                }

            
            if (total_matches > 1)
            {
                add_menu_item(menu, "", ::do_nothing); 
                add_menu_item(menu, "Switch to Previous Match", ::cycle_recent_match_back);
                add_menu_item(menu, "Switch to Next Match", ::cycle_recent_match_forward);
            }
        }
        else
        {
            add_menu_item(menu, "NO RECENT MATCHES", ::do_nothing);
            add_menu_item(menu, "Complete a match to save statistics", ::do_nothing);
        }

        add_menu_item(menu, "", ::do_nothing);
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}


get_recent_match_files(player_guid, map_name)
{
    
    index_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "_index.txt";

    if (!fs_testfile(index_filename))
    {
        return [];
    }

    
    file = fs_fopen(index_filename, "read");
    if (!isDefined(file))
    {
        return [];
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    last_match_number = int(content);

    
    files = [];
    for (i = last_match_number; i > 0; i--)
    {
        filename = map_name + "_recent_" + i + ".txt";
        full_path = "scriptdata/recent/" + player_guid + "/" + filename;

        if (fs_testfile(full_path))
        {
            files[files.size] = filename;
        }
    }

    return files;
}


cycle_recent_match_back()
{
    if (!isDefined(self.recent_match_index))
        self.recent_match_index = 0;

    map_name = getDvar("ui_zm_mapstartlocation");
    player_guid = self getGuid();

    recent_files = get_recent_match_files(player_guid, map_name);

    if (recent_files.size <= 1)
        return;

    self.recent_match_index--;

    
    if (self.recent_match_index < 0)
        self.recent_match_index = recent_files.size - 1;

    
    self change_recent_match_instantly(recent_files);
}


cycle_recent_match_forward()
{
    if (!isDefined(self.recent_match_index))
        self.recent_match_index = 0;

    map_name = getDvar("ui_zm_mapstartlocation");
    player_guid = self getGuid();

    recent_files = get_recent_match_files(player_guid, map_name);

    if (recent_files.size <= 1)
        return;

    self.recent_match_index++;

    
    if (self.recent_match_index >= recent_files.size)
        self.recent_match_index = 0;

    
    self change_recent_match_instantly(recent_files);
}


open_weapon_usage_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    
    if (!isDefined(self.weapon_page_index))
        self.weapon_page_index = 0;

    
    if (!isDefined(self.last_recent_match_index) || self.last_recent_match_index != self.recent_match_index)
    {
        self.weapon_page_index = 0;
        self.last_recent_match_index = self.recent_match_index;
    }

    self notify("destroy_current_menu");
    wait 0.1;

    
    weapons_per_page = 6;
    current_page = self.weapon_page_index;

    title = (self.langLEN == 0) ? "USO DE ARMAS" : "WEAPON USAGE";
    menu = create_menu(title, self);
    menu.parent_menu = "recent_matches";

    
    map_name = getDvar("ui_zm_mapstartlocation");
    player_guid = self getGuid();

    if (!isDefined(self.recent_match_index))
        self.recent_match_index = 0;

    recent_files = get_recent_match_files(player_guid, map_name);
    if (isDefined(recent_files) && recent_files.size > 0)
    {
        display_index = self.recent_match_index;
        if (display_index >= recent_files.size)
            display_index = 0;

        match_filename = "scriptdata/recent/" + player_guid + "/" + recent_files[display_index];

        if (fs_testfile(match_filename))
        {
            file = fs_fopen(match_filename, "read");
            if (isDefined(file))
            {
                file_size = fs_length(file);
                content = fs_read(file, file_size);
                fs_fclose(file);

                
                lines = strTok(content, "\n");
                most_used_weapon = "None";
                all_weapons = [];

                in_weapons_section = false;
                foreach (line in lines)
                {
                    if (isSubStr(line, "Arma Mas Usada:"))
                        most_used_weapon = getSubStr(line, 16);
                    else if (isSubStr(line, "ARMAS USADAS EN LA PARTIDA:"))
                        in_weapons_section = true;
                    else if (isSubStr(line, "PERKS USADOS EN LA PARTIDA:") && in_weapons_section)
                        in_weapons_section = false; 
                    else if (in_weapons_section && isSubStr(line, " kills"))
                    {
                        
                        parts = strTok(line, ": ");
                        if (parts.size >= 2)
                        {
                            weapon_name = parts[0];
                            kills_part = strTok(parts[1], " ")[0];
                            all_weapons[all_weapons.size] = weapon_name + ": " + kills_part + " kills";
                        }
                    }
                    else if (isSubStr(line, "================================") && in_weapons_section)
                        break; 
                }

                
                if (self.langLEN == 0)
                {
                    add_menu_item(menu, "ARMA MAS USADA", ::do_nothing);
                    add_menu_item(menu, most_used_weapon, ::do_nothing);
                    add_menu_item(menu, "", ::do_nothing);
                    add_menu_item(menu, "TODAS LAS ARMAS USADAS:", ::do_nothing);
                }
                else
                {
                    add_menu_item(menu, "MOST USED WEAPON", ::do_nothing);
                    add_menu_item(menu, most_used_weapon, ::do_nothing);
                    add_menu_item(menu, "", ::do_nothing);
                    add_menu_item(menu, "ALL WEAPONS USED:", ::do_nothing);
                }

                
                total_weapons = all_weapons.size;
                start_index = current_page * weapons_per_page;
                end_index = min(start_index + weapons_per_page, total_weapons);
                total_pages = int((total_weapons - 1) / weapons_per_page) + 1;

                
                for (i = start_index; i < end_index; i++)
                {
                    add_menu_item(menu, all_weapons[i], ::do_nothing);
                }

                
                if (total_pages > 1)
                {
                    add_menu_item(menu, "", ::do_nothing);

                    
                    page_info = (self.langLEN == 0) ?
                        "Página " + (current_page + 1) + " de " + total_pages :
                        "Page " + (current_page + 1) + " of " + total_pages;
                    add_menu_item(menu, page_info, ::do_nothing);

                    
                    if (current_page > 0)
                    {
                        add_menu_item(menu, (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS", ::weapon_page_previous);
                    }
                    else
                    {
                        add_menu_item(menu, "", ::do_nothing);
                    }

                    if (current_page < total_pages - 1)
                    {
                        add_menu_item(menu, (self.langLEN == 0) ? "SIGUIENTE" : "NEXT", ::weapon_page_next);
                    }
                    else
                    {
                        add_menu_item(menu, "", ::do_nothing);
                    }
                }
            }
        }
    }

    
    add_menu_item(menu, "", ::do_nothing);

    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}


open_recent_stats_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "ESTADISTICAS DE PARTIDA" : "MATCH STATISTICS";
    menu = create_menu(title, self);
    menu.parent_menu = "recent_matches";

    
    map_name = getDvar("ui_zm_mapstartlocation");
    player_guid = self getGuid();

    if (!isDefined(self.recent_match_index))
        self.recent_match_index = 0;

    recent_files = get_recent_match_files(player_guid, map_name);
    if (isDefined(recent_files) && recent_files.size > 0)
    {
        display_index = self.recent_match_index;
        if (display_index >= recent_files.size)
            display_index = 0;

        match_filename = "scriptdata/recent/" + player_guid + "/" + recent_files[display_index];

        if (fs_testfile(match_filename))
        {
            file = fs_fopen(match_filename, "read");
            if (isDefined(file))
            {
                file_size = fs_length(file);
                content = fs_read(file, file_size);
                fs_fclose(file);

                
                lines = strTok(content, "\n");
                round_num = "0";
                score = "0";
                kills = "0";
                headshots = "0";
                revives = "0";
                downs = "0";

                foreach (line in lines)
                {
                    if (isSubStr(line, "Ronda Alcanzada:"))
                        round_num = getSubStr(line, 17);
                    else if (isSubStr(line, "Score Total:"))
                        score = getSubStr(line, 13);
                    else if (isSubStr(line, "Kills:"))
                        kills = getSubStr(line, 7);
                    else if (isSubStr(line, "Headshots:"))
                        headshots = getSubStr(line, 11);
                    else if (isSubStr(line, "Revives:"))
                        revives = getSubStr(line, 9);
                    else if (isSubStr(line, "Downs:"))
                        downs = getSubStr(line, 7);
                }

                
                if (self.langLEN == 0)
                {
                    add_menu_item(menu, "Ronda: " + round_num, ::do_nothing);
                    add_menu_item(menu, "Score: " + score, ::do_nothing);
                    add_menu_item(menu, "", ::do_nothing);
                    add_menu_item(menu, "Kills: " + kills, ::do_nothing);
                    add_menu_item(menu, "Headshots: " + headshots, ::do_nothing);
                    add_menu_item(menu, "Revives: " + revives, ::do_nothing);
                    add_menu_item(menu, "Downs: " + downs, ::do_nothing);
                }
                else
                {
                    add_menu_item(menu, "Round: " + round_num, ::do_nothing);
                    add_menu_item(menu, "Score: " + score, ::do_nothing);
                    add_menu_item(menu, "", ::do_nothing);
                    add_menu_item(menu, "Kills: " + kills, ::do_nothing);
                    add_menu_item(menu, "Headshots: " + headshots, ::do_nothing);
                    add_menu_item(menu, "Revives: " + revives, ::do_nothing);
                    add_menu_item(menu, "Downs: " + downs, ::do_nothing);
                }
            }
        }
    }

    
    add_menu_item(menu, "", ::do_nothing);

    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}




weapon_page_next()
{
    self.weapon_page_index++;
    self thread open_weapon_usage_menu();
    scripts\zm\playsound::play_menu_scroll_sound(self);
}


weapon_page_previous()
{
    self.weapon_page_index--;
    if (self.weapon_page_index < 0)
        self.weapon_page_index = 0;
    self thread open_weapon_usage_menu();
    scripts\zm\playsound::play_menu_scroll_sound(self);
}




open_perks_usage_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "PERKS USADOS" : "PERKS USED";
    menu = create_menu(title, self);
    menu.parent_menu = "recent_matches";

    
    map_name = getDvar("ui_zm_mapstartlocation");
    player_guid = self getGuid();

    if (!isDefined(self.recent_match_index))
        self.recent_match_index = 0;

    recent_files = get_recent_match_files(player_guid, map_name);
    if (isDefined(recent_files) && recent_files.size > 0)
    {
        display_index = self.recent_match_index;
        if (display_index >= recent_files.size)
            display_index = 0;

        match_filename = "scriptdata/recent/" + player_guid + "/" + recent_files[display_index];

        if (fs_testfile(match_filename))
        {
            file = fs_fopen(match_filename, "read");
            if (isDefined(file))
            {
                file_size = fs_length(file);
                content = fs_read(file, file_size);
                fs_fclose(file);

                
                lines = strTok(content, "\n");
                all_perks = [];

                in_perks_section = false;
                foreach (line in lines)
                {
                    if (isSubStr(line, "PERKS USADOS EN LA PARTIDA:"))
                        in_perks_section = true;
                    else if (in_perks_section && isSubStr(line, ": ") && !isSubStr(line, "=="))
                    {
                        
                        parts = strTok(line, ": ");
                        if (parts.size >= 2)
                        {
                            perk_name = parts[0];
                            usage_info = parts[1];
                            all_perks[all_perks.size] = perk_name;
                        }
                    }
                    else if (isSubStr(line, "================================") && in_perks_section)
                        break; 
                }

                if (all_perks.size > 0)
                {
                    if (self.langLEN == 0)
                    {
                        add_menu_item(menu, "PERKS USADOS EN LA PARTIDA:", ::do_nothing);
                    }
                    else
                    {
                        add_menu_item(menu, "PERKS USED IN MATCH:", ::do_nothing);
                    }

                    
                    foreach (perk_info in all_perks)
                    {
                        add_menu_item(menu, perk_info, ::do_nothing);
                    }
                }
                else
                {
                    if (self.langLEN == 0)
                    {
                        add_menu_item(menu, "NO HAY PERKS USADOS", ::do_nothing);
                    }
                    else
                    {
                        add_menu_item(menu, "NO PERKS USED", ::do_nothing);
                    }
                }
            }
        }
    }

    
    add_menu_item(menu, "", ::do_nothing);

    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}




change_recent_match_instantly(recent_files)
{
    
    if (isDefined(self.menu_current))
    {
        
        if (isDefined(self.menu_current.title_text))
            self.menu_current.title_text destroy();
        if (isDefined(self.menu_current.title_shadow))
            self.menu_current.title_shadow destroy();

        
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (isDefined(self.menu_current.items[i]))
            {
                if (isDefined(self.menu_current.items[i].item))
                    self.menu_current.items[i].item destroy();
                if (isDefined(self.menu_current.items[i].background))
                    self.menu_current.items[i].background destroy();
            }
        }

        
        if (isDefined(self.menu_current.selection_bar))
            self.menu_current.selection_bar destroy();

        
        self.menu_current = undefined;
        self notify("menu_destroyed");
    }

    
    wait 0.01; 
    self thread open_recent_matches_menu();

    
    self playsound("menu_click");
}


get_map_display_name_recent(map_code)
{
    switch (map_code)
    {
        case "tomb": return "Origins";
        case "transit": return "Transit";
        case "processing": return "Buried";
        case "prison": return "Mob of the Dead";
        case "nuked": return "Nuketown";
        case "highrise": return "Die Rise";
        case "town": return "Town (Transit)";
        case "farm": return "Farm (Transit)";
        case "busdepot": return "Bus Depot (Transit)";
        case "diner": return "Diner (Buried)";
        case "cornfield": return "Cornfield (Buried)";
        case "cellblock": return "Cellblock (Mob of the Dead)";
        default: return map_code;
    }
}






open_bank_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "BANCO" : "BANK";
    menu = create_menu(title, self);
    menu.parent_menu = "map";

    
    if (!isDefined(self.bank_amount))
    {
        self.bank_amount = 1000;
    }

    
    current_balance = scripts\zm\sqllocal::get_bank_balance(self);
    balance_text = (self.langLEN == 0) ? "Balance: " + current_balance + " puntos" : "Balance: " + current_balance + " points";
    amount_text = (self.langLEN == 0) ? "Cantidad: " + self.bank_amount + " puntos" : "Amount: " + self.bank_amount + " points";

    if (self.langLEN == 0) 
    {
        add_menu_item(menu, balance_text, ::do_nothing);
        add_menu_item(menu, amount_text, ::do_nothing);
        add_menu_item(menu, "[+] Incrementar 1000", ::bank_increase_1000);
        add_menu_item(menu, "[-] Decrementar 1000", ::bank_decrease_1000);
        add_menu_item(menu, "Depositar Cantidad", ::bank_deposit_selected);
        add_menu_item(menu, "Retirar Cantidad", ::bank_withdraw_selected);
        add_menu_item(menu, "Depositar Todo", ::bank_deposit_all);
        add_menu_item(menu, "Retirar Todo", ::bank_withdraw_all);
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        add_menu_item(menu, balance_text, ::do_nothing);
        add_menu_item(menu, amount_text, ::do_nothing);
        add_menu_item(menu, "[+] Increase 1000", ::bank_increase_1000);
        add_menu_item(menu, "[-] Decrease 1000", ::bank_decrease_1000);
        add_menu_item(menu, "Deposit Amount", ::bank_deposit_selected);
        add_menu_item(menu, "Withdraw Amount", ::bank_withdraw_selected);
        add_menu_item(menu, "Deposit All", ::bank_deposit_all);
        add_menu_item(menu, "Withdraw All", ::bank_withdraw_all);
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}




bank_increase_1000()
{
    if (!isDefined(self.bank_amount))
        self.bank_amount = 1000;

    
    if (self.bank_amount < 100000)
    {
        self.bank_amount += 1000;
    }

    
    update_bank_menu_display();
}


bank_decrease_1000()
{
    if (!isDefined(self.bank_amount))
        self.bank_amount = 1000;

    
    if (self.bank_amount > 1000)
    {
        self.bank_amount -= 1000;
    }

    
    update_bank_menu_display();
}


bank_deposit_selected()
{
    if (!isDefined(self.bank_amount) || self.bank_amount <= 0)
    {
        self.bank_amount = 1000;
    }

    self thread scripts\zm\sqllocal::bank_deposit(self, self.bank_amount);
    wait 0.5;

    
    update_bank_menu_display();
}


bank_withdraw_selected()
{
    if (!isDefined(self.bank_amount) || self.bank_amount <= 0)
    {
        self.bank_amount = 1000;
    }

    self thread scripts\zm\sqllocal::bank_withdraw(self, self.bank_amount);
    wait 0.5;

    
    update_bank_menu_display();
}


bank_deposit_all()
{
    self thread scripts\zm\sqllocal::bank_deposit_all(self);
    wait 0.5;

    
    update_bank_menu_display();
}


bank_withdraw_all()
{
    self thread scripts\zm\sqllocal::bank_withdraw_all(self);
    wait 0.5;

    
    update_bank_menu_display();
}


do_nothing()
{
    
}


update_bank_menu_display()
{
    
    if (isDefined(self.is_updating_bank_display))
        return;

    self.is_updating_bank_display = true;

    
    wait 0.1;

    if (isDefined(self.menu_current))
    {
        
        current_balance = scripts\zm\sqllocal::get_bank_balance(self);

        
        balance_text = (self.langLEN == 0) ? "Balance: " + current_balance + " puntos" : "Balance: " + current_balance + " points";
        if (self.menu_current.items.size > 0)
        {
            self.menu_current.items[0].item setText(balance_text);
        }

        
        amount_text = (self.langLEN == 0) ? "Cantidad: " + self.bank_amount + " puntos" : "Amount: " + self.bank_amount + " points";
        if (self.menu_current.items.size > 1)
        {
            self.menu_current.items[1].item setText(amount_text);
        }
    }

    self.is_updating_bank_display = undefined;
}






open_player_menu(is_returning)
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "JUGADOR" : "PLAYER";
    menu = create_menu(title, self);
    menu.parent_menu = "developer";

    
    map = getDvar("ui_zm_mapstartlocation");

    if (self.langLEN == 0) 
    {
        
        godmode_status = self.godmode_enabled ? "ON" : "OFF";
        add_menu_item(menu, "God Mode: " + godmode_status, scripts\zm\funciones::toggle_godmode);

        
        add_menu_item(menu, "Dar 10k Puntos", scripts\zm\funciones::give_10k_points);

        
        speed_status = self.speed_boost_enabled ? "ON" : "OFF";
        add_menu_item(menu, "Velocidad x2: " + speed_status, scripts\zm\funciones::toggle_speed);

        super_jump_status = (isDefined(self.super_jump_enabled) && self.super_jump_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Super Jump: " + super_jump_status, scripts\zm\funciones::toggle_super_jump);

        
        add_menu_item(menu, "Teleport", ::open_teleport_menu);

        
        add_menu_item(menu, "Powerups", ::open_powerups_menu);

        
        add_menu_item(menu, "Armas", ::open_weapons_menu);

        
        add_menu_item(menu, "Perks", ::open_perks_menu);

        
        add_menu_item(menu, "Mods Avanzados", ::open_advanced_mods_menu);

        
        if (map == "tomb")
            add_menu_item(menu, "Bastones", ::open_staffs_menu);

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        godmode_status = self.godmode_enabled ? "ON" : "OFF";
        add_menu_item(menu, "God Mode: " + godmode_status, scripts\zm\funciones::toggle_godmode);

        
        add_menu_item(menu, "Give 10k Points", scripts\zm\funciones::give_10k_points);

        
        speed_status = self.speed_boost_enabled ? "ON" : "OFF";
        add_menu_item(menu, "Speed x2: " + speed_status, scripts\zm\funciones::toggle_speed);

        super_jump_status = (isDefined(self.super_jump_enabled) && self.super_jump_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Super Jump: " + super_jump_status, scripts\zm\funciones::toggle_super_jump);

        
        add_menu_item(menu, "Teleport", ::open_teleport_menu);

        
        add_menu_item(menu, "Powerups", ::open_powerups_menu);

        
        add_menu_item(menu, "Weapons", ::open_weapons_menu);

        
        add_menu_item(menu, "Perks", ::open_perks_menu);

        add_menu_item(menu, "Mods advanced", ::open_advanced_mods_menu);

        
        if (map == "tomb")
            add_menu_item(menu, "Staffs", ::open_staffs_menu);

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}






open_zombie_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "ZOMBIE" : "ZOMBIE";
    menu = create_menu(title, self);
    menu.parent_menu = "developer";

    
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;

    
    current_map = getDvar("ui_zm_mapstartlocation");
    has_special_enemies = (current_map == "tomb");

    if (self.langLEN == 0) 
    {
        
        add_menu_item(menu, "Avanzar Ronda", scripts\zm\funciones::advance_round);
        add_menu_item(menu, "Retroceder Ronda", scripts\zm\funciones::go_back_round);
        add_menu_item(menu, "Round 255", scripts\zm\funciones::set_round_255);
        add_menu_item(menu, "Aplicar Ronda: " + self.target_round, scripts\zm\funciones::apply_round_change);

        
        zombie_freeze_status = (isDefined(self.Fr3ZzZoM) && self.Fr3ZzZoM) ? "ON" : "OFF";
        add_menu_item(menu, "Zombie Freeze: " + zombie_freeze_status, scripts\zm\funciones::Fr3ZzZoM);
        add_menu_item(menu, "Kill All Zombies", scripts\zm\funciones::kill_all_zombies);

        teleport_zombies_status = (isDefined(self.teleport_zombies_enabled) && self.teleport_zombies_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Teleport Zombies: " + teleport_zombies_status, scripts\zm\funciones::toggle_teleport_zombies);

        disable_zombies_status = (isDefined(self.disable_zombies_enabled) && self.disable_zombies_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Disable Zombies: " + disable_zombies_status, scripts\zm\funciones::toggle_disable_zombies);


        
        if (has_special_enemies)
        {
            add_menu_item(menu, "Enemigos Especiales", ::open_enemies_menu);
        }

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        add_menu_item(menu, "Advance Round", scripts\zm\funciones::advance_round);
        add_menu_item(menu, "Go Back Round", scripts\zm\funciones::go_back_round);
        add_menu_item(menu, "Round 255", scripts\zm\funciones::set_round_255);
        add_menu_item(menu, "Apply Round: " + self.target_round, scripts\zm\funciones::apply_round_change);

        
        zombie_freeze_status = (isDefined(self.Fr3ZzZoM) && self.Fr3ZzZoM) ? "ON" : "OFF";
        add_menu_item(menu, "Zombie Freeze: " + zombie_freeze_status, scripts\zm\funciones::Fr3ZzZoM);
        add_menu_item(menu, "Kill All Zombies", scripts\zm\funciones::kill_all_zombies);

        teleport_zombies_status = (isDefined(self.teleport_zombies_enabled) && self.teleport_zombies_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Teleport Zombies: " + teleport_zombies_status, scripts\zm\funciones::toggle_teleport_zombies);

        disable_zombies_status = (isDefined(self.disable_zombies_enabled) && self.disable_zombies_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Disable Zombies: " + disable_zombies_status, scripts\zm\funciones::toggle_disable_zombies);

        
        if (has_special_enemies)
        {
            add_menu_item(menu, "Special Enemies", ::open_enemies_menu);
        }

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}






open_mods_littlegods_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "MODS LITTLEGODS" : "MODS LITTLEGODS";
    menu = create_menu(title, self);
    menu.parent_menu = "main";

    
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();

    if (self.langLEN == 0) 
    {
        add_menu_item(menu, "Night Mode", ::open_night_mode_menu);

        
        healthbar_item = add_menu_item(menu, "Barra de Vida", ::open_healthbar_menu);
        if ((borders_active && !self.healthbar_enabled) || (healthbarzombie_active && !self.healthbar_enabled) || (legacy_mods_active && !self.healthbar_enabled))
        {
            healthbar_item.item.color = (1, 0.2, 0.2); 
        }

        
        zombie_bar_item =         add_menu_item(menu, "Barra Zombie", ::open_healthbarzombie_menu);
        if ((borders_active && !self.healthbarzombie_enabled) || (healthbar_active && !self.healthbarzombie_enabled) || (legacy_mods_active && !self.healthbarzombie_enabled))
        {
            zombie_bar_item.item.color = (1, 0.2, 0.2); 
        }

        
        add_menu_item(menu, "Heredado Mods", ::open_performance_mods_menu);

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        add_menu_item(menu, "Night Mode", ::open_night_mode_menu);

        
        healthbar_item = add_menu_item(menu, "Health Bar", ::open_healthbar_menu);
        if ((borders_active && !self.healthbar_enabled) || (healthbarzombie_active && !self.healthbar_enabled) || (legacy_mods_active && !self.healthbar_enabled))
        {
            healthbar_item.item.color = (1, 0.2, 0.2); 
        }

        
        zombie_bar_item = add_menu_item(menu, "Zombie Bar", ::open_healthbarzombie_menu);
        if ((borders_active && !self.healthbarzombie_enabled) || (healthbar_active && !self.healthbarzombie_enabled) || (legacy_mods_active && !self.healthbarzombie_enabled))
        {
            zombie_bar_item.item.color = (1, 0.2, 0.2); 
        }

        
        add_menu_item(menu, "Legacy Mods", ::open_performance_mods_menu);

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}









init_teleport_system()
{
    if (!isDefined(self.teleport_points))
    {
        self.teleport_points = [];
        self.teleport_names = [];
        self.teleport_count = 0;
    }
}


create_teleport_point(name)
{
    self endon("disconnect");

    
    if (!isDefined(self.teleport_points))
        self thread init_teleport_system();

    
    if (self.teleport_count >= 5)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1Máximo de 5 puntos de teleportación alcanzado");
        else
            self iPrintLnBold("^1Maximum of 5 teleportation points reached");

        self playLocalSound("menu_error");
        return false;
    }

    
    for (i = 0; i < self.teleport_count; i++)
    {
        if (self.teleport_names[i] == name)
        {
            if (self.langLEN == 0)
                self iPrintLnBold("^1Ya existe un punto con el nombre: ^5" + name);
            else
                self iPrintLnBold("^1A point with name ^5" + name + " ^1already exists");

            self playLocalSound("menu_error");
            return false;
        }
    }

    
    point_data = spawnStruct();
    point_data.origin = self.origin;
    point_data.angles = self getPlayerAngles();

    
    self.teleport_points[self.teleport_count] = point_data;
    self.teleport_names[self.teleport_count] = name;
    self.teleport_count++;

    
    if (self.langLEN == 0)
        self iPrintLnBold("^2Punto ^5" + name + " ^2creado exitosamente");
    else
        self iPrintLnBold("^2Point ^5" + name + " ^2created successfully");

    self playLocalSound("uin_positive_feedback");
    return true;
}


list_teleport_points()
{
    self endon("disconnect");

    if (!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos de teleportación guardados");
        else
            self iPrintLnBold("^1No teleportation points saved");

        return;
    }

    if (self.langLEN == 0)
        self iPrintLnBold("^5=== PUNTOS DE TELEPORTACIÓN ===");
    else
        self iPrintLnBold("^5=== TELEPORTATION POINTS ===");

    wait 0.05;

    for (i = 0; i < self.teleport_count; i++)
    {
        if (self.langLEN == 0)
            self iPrintLn("^3" + (i + 1) + ". ^5" + self.teleport_names[i]);
        else
            self iPrintLn("^3" + (i + 1) + ". ^5" + self.teleport_names[i]);

        wait 0.05;
    }

    if (self.langLEN == 0)
        self iPrintLn("^7Usa el menú para teleportarte");
    else
        self iPrintLn("^7Use the menu to teleport");

    wait 0.05;
}


teleport_to_point(index)
{
    self endon("disconnect");

    if (!isDefined(self.teleport_points) || index >= self.teleport_count || index < 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1Punto de teleportación no válido");
        else
            self iPrintLnBold("^1Invalid teleportation point");

        self playLocalSound("menu_error");
        return false;
    }

    
    self setOrigin(self.teleport_points[index].origin);
    self setPlayerAngles(self.teleport_points[index].angles);

    
    if (self.langLEN == 0)
        self iPrintLnBold("^2Teleportado a ^5" + self.teleport_names[index]);
    else
        self iPrintLnBold("^2Teleported to ^5" + self.teleport_names[index]);

    self playLocalSound("uin_positive_feedback");
    return true;
}


delete_teleport_point(index)
{
    self endon("disconnect");

    if (!isDefined(self.teleport_points) || index >= self.teleport_count || index < 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1Punto de teleportación no válido");
        else
            self iPrintLnBold("^1Invalid teleportation point");

        self playLocalSound("menu_error");
        return false;
    }

    
    deleted_name = self.teleport_names[index];

    
    for (i = index; i < self.teleport_count - 1; i++)
    {
        self.teleport_points[i] = self.teleport_points[i + 1];
        self.teleport_names[i] = self.teleport_names[i + 1];
    }

    
    self.teleport_points[self.teleport_count - 1] = undefined;
    self.teleport_names[self.teleport_count - 1] = undefined;
    self.teleport_count--;

    
    if (self.langLEN == 0)
        self iPrintLnBold("^1Punto ^5" + deleted_name + " ^1eliminado");
    else
        self iPrintLnBold("^1Point ^5" + deleted_name + " ^1deleted");

    self playLocalSound("uin_positive_feedback");
    return true;
}


delete_all_teleport_points()
{
    self endon("disconnect");

    if (!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos para eliminar");
        else
            self iPrintLnBold("^1No points to delete");

        return false;
    }

    
    self.teleport_points = [];
    self.teleport_names = [];
    self.teleport_count = 0;

    
    if (self.langLEN == 0)
        self iPrintLnBold("^1Todos los puntos de teleportación eliminados");
    else
        self iPrintLnBold("^1All teleportation points deleted");

    self playLocalSound("uin_positive_feedback");
    return true;
}


open_teleport_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "TELEPORTACIÓN" : "TELEPORTATION";
    menu = create_menu(title, self);
    menu.parent_menu = "player";

    
    if (!isDefined(self.teleport_points))
        self thread init_teleport_system();

    if (self.langLEN == 0) 
    {
        add_menu_item(menu, "Crear Punto", ::teleport_create_point_prompt);
        add_menu_item(menu, "Listar Puntos", ::teleport_list_points_menu);
        add_menu_item(menu, "Teleportarse", ::teleport_select_point_menu);
        add_menu_item(menu, "Eliminar Punto", ::teleport_delete_point_menu);
        add_menu_item(menu, "Eliminar Todos", ::teleport_delete_all_points);
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        add_menu_item(menu, "Create Point", ::teleport_create_point_prompt);
        add_menu_item(menu, "List Points", ::teleport_list_points_menu);
        add_menu_item(menu, "Teleport", ::teleport_select_point_menu);
        add_menu_item(menu, "Delete Point", ::teleport_delete_point_menu);
        add_menu_item(menu, "Delete All", ::teleport_delete_all_points);
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}


teleport_create_point_prompt()
{
    self endon("disconnect");

    self notify("destroy_current_menu");
    self.menu_open = false;

    if (self.langLEN == 0)
        self iPrintLnBold("^5Escribe el nombre del punto de teleportación en el chat");
    else
        self iPrintLnBold("^5Type the teleportation point name in chat");

    self.waiting_for_teleport_name = true;
    self thread teleport_listen_for_chat_input();
}


teleport_listen_for_chat_input()
{
    self endon("disconnect");
    level endon("end_game");
    self endon("stop_teleport_name_listen");

    if (self.langLEN == 0)
        self iPrintLnBold("^3Esperando mensaje en chat...");
    else
        self iPrintLnBold("^3Waiting for chat message...");

    self thread teleport_chat_watcher();

    self waittill_any("teleport_name_received", "stop_teleport_name_listen");
}


teleport_chat_watcher()
{
    self endon("disconnect");
    level endon("end_game");
    self endon("stop_teleport_name_listen");

    for (;;)
    {
        level waittill("say", message, player);

        if (player == self && self.waiting_for_teleport_name)
        {
            if (message.size > 15)
                message = getSubStr(message, 0, 15);

            if (self.langLEN == 0)
                self iPrintLnBold("^2Creando punto: ^7" + message);
            else
                self iPrintLnBold("^2Creating point: ^7" + message);

            wait 0.5;

            success = self create_teleport_point(message);

            self.waiting_for_teleport_name = false;
            self notify("teleport_name_received");

            wait 1.0;
            self thread open_teleport_menu();
            return;
        }
    }
}


teleport_list_points_menu()
{
    self endon("disconnect");

    if(!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos de teleportación");
        else
            self iPrintLnBold("^1No teleportation points available");

        return;
    }

    self thread list_teleport_points();
}


teleport_select_point_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    if(!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos de teleportación");
        else
            self iPrintLnBold("^1No teleportation points available");

        return;
    }

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "SELECCIONAR PUNTO" : "SELECT POINT";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    for (i = 0; i < self.teleport_count; i++)
    {
        teleport_func = self get_teleport_function(i);
        add_menu_item(menu, (i+1) + ". " + self.teleport_names[i], teleport_func);
    }

    if (self.langLEN == 0)
        add_menu_item(menu, "Volver", ::menu_go_back);
    else
        add_menu_item(menu, "Back", ::menu_go_back);

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}


teleport_to_index_0() { self teleport_to_point(0); wait 1.0; self thread open_teleport_menu(); }
teleport_to_index_1() { self teleport_to_point(1); wait 1.0; self thread open_teleport_menu(); }
teleport_to_index_2() { self teleport_to_point(2); wait 1.0; self thread open_teleport_menu(); }
teleport_to_index_3() { self teleport_to_point(3); wait 1.0; self thread open_teleport_menu(); }
teleport_to_index_4() { self teleport_to_point(4); wait 1.0; self thread open_teleport_menu(); }


get_teleport_function(index)
{
    switch(index)
    {
        case 0: return ::teleport_to_index_0;
        case 1: return ::teleport_to_index_1;
        case 2: return ::teleport_to_index_2;
        case 3: return ::teleport_to_index_3;
        case 4: return ::teleport_to_index_4;
        default: return ::teleport_to_index_0;
    }
}


teleport_delete_point_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    if(!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos de teleportación");
        else
            self iPrintLnBold("^1No teleportation points available");

        return;
    }

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "ELIMINAR PUNTO" : "DELETE POINT";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    for (i = 0; i < self.teleport_count; i++)
    {
        delete_func = self get_delete_function(i);
        add_menu_item(menu, (i+1) + ". " + self.teleport_names[i], delete_func);
    }

    if (self.langLEN == 0)
        add_menu_item(menu, "Volver", ::menu_go_back);
    else
        add_menu_item(menu, "Back", ::menu_go_back);

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}


delete_point_index_0() { self delete_teleport_point(0); wait 1.0; self thread open_teleport_menu(); }
delete_point_index_1() { self delete_teleport_point(1); wait 1.0; self thread open_teleport_menu(); }
delete_point_index_2() { self delete_teleport_point(2); wait 1.0; self thread open_teleport_menu(); }
delete_point_index_3() { self delete_teleport_point(3); wait 1.0; self thread open_teleport_menu(); }
delete_point_index_4() { self delete_teleport_point(4); wait 1.0; self thread open_teleport_menu(); }


get_delete_function(index)
{
    switch(index)
    {
        case 0: return ::delete_point_index_0;
        case 1: return ::delete_point_index_1;
        case 2: return ::delete_point_index_2;
        case 3: return ::delete_point_index_3;
        case 4: return ::delete_point_index_4;
        default: return ::delete_point_index_0;
    }
}


teleport_delete_all_points()
{
    self endon("disconnect");

    success = self delete_all_teleport_points();

    if (success)
        wait 1.0;
}








open_powerups_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "POWERUPS" : "POWERUPS";
    menu = create_menu(title, self);
    menu.parent_menu = "player";

    
    current_map = getDvar("ui_zm_mapstartlocation");

    
    available_powerups = get_available_powerups_for_map(current_map);

    if (self.langLEN == 0) 
    {
        
        for (i = 0; i < available_powerups.size; i++)
        {
            powerup_key = available_powerups[i];
            powerup_name = get_powerup_display_name(powerup_key, 0); 
            powerup_function = get_powerup_function(powerup_key);

            add_menu_item(menu, powerup_name, powerup_function);
        }

        add_menu_item(menu, "TODOS los Powerups", scripts\zm\funciones::spawn_all_powerups);
        add_menu_item(menu, "Powerup RANDOM", scripts\zm\funciones::spawn_random_powerup);
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        for (i = 0; i < available_powerups.size; i++)
        {
            powerup_key = available_powerups[i];
            powerup_name = get_powerup_display_name(powerup_key, 1); 
            powerup_function = get_powerup_function(powerup_key);

            add_menu_item(menu, powerup_name, powerup_function);
        }

        add_menu_item(menu, "ALL Powerups", scripts\zm\funciones::spawn_all_powerups);
        add_menu_item(menu, "RANDOM Powerup", scripts\zm\funciones::spawn_random_powerup);
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}


get_available_powerups_for_map(map_name)
{
    available_powerups = [];

    
    if (map_name == "nuke") 
    {
        available_powerups[0] = "nuke";
        available_powerups[1] = "double_points";
        available_powerups[2] = "full_ammo";
        available_powerups[3] = "insta_kill";
        available_powerups[4] = "fire_sale";
    }
    else if (map_name == "transit" || map_name == "town" || map_name == "farm" || map_name == "diner") 
    {
        available_powerups[0] = "full_ammo";
        available_powerups[1] = "insta_kill";
        available_powerups[2] = "carpenter";
        available_powerups[3] = "double_points";
        available_powerups[4] = "nuke";
    }
    else if (map_name == "buried") 
    {
        available_powerups[0] = "full_ammo";
        available_powerups[1] = "insta_kill";
        available_powerups[2] = "carpenter";
        available_powerups[3] = "double_points";
        available_powerups[4] = "fire_sale";
        available_powerups[5] = "nuke";
    }
    else if (map_name == "tomb") 
    {
        available_powerups[0] = "full_ammo";
        available_powerups[1] = "insta_kill";
        available_powerups[2] = "double_points";
        available_powerups[3] = "fire_sale";
        available_powerups[4] = "nuke";
        available_powerups[5] = "zombie_blood";
    }
    else if (map_name == "prison") 
    {
        available_powerups[0] = "nuke";
        available_powerups[1] = "double_points";
        available_powerups[2] = "full_ammo";
        available_powerups[3] = "insta_kill";
        available_powerups[4] = "fire_sale";
    }
    else 
    {
        available_powerups[0] = "full_ammo";
        available_powerups[1] = "insta_kill";
        available_powerups[2] = "carpenter";
        available_powerups[3] = "double_points";
        available_powerups[4] = "fire_sale";
        available_powerups[5] = "nuke";
    }

    return available_powerups;
}


get_powerup_display_name(powerup_key, language)
{
    display_names = [];

    if (language == 0) 
    {
        display_names["full_ammo"] = "Max Ammo";
        display_names["insta_kill"] = "Insta Kill";
        display_names["carpenter"] = "Carpenter";
        display_names["double_points"] = "Double Points";
        display_names["fire_sale"] = "Fire Sale";
        display_names["nuke"] = "Nuke";
        display_names["zombie_blood"] = "Zombie Blood";
    }
    else 
    {
        display_names["full_ammo"] = "Max Ammo";
        display_names["insta_kill"] = "Insta Kill";
        display_names["carpenter"] = "Carpenter";
        display_names["double_points"] = "Double Points";
        display_names["fire_sale"] = "Fire Sale";
        display_names["nuke"] = "Nuke";
        display_names["zombie_blood"] = "Zombie Blood";
    }

    return display_names[powerup_key];
}


get_powerup_function(powerup_key)
{
    functions = [];
    functions["full_ammo"] = scripts\zm\funciones::spawn_max_ammo;
    functions["insta_kill"] = scripts\zm\funciones::spawn_insta_kill;
    functions["carpenter"] = scripts\zm\funciones::spawn_carpenter;
    functions["double_points"] = scripts\zm\funciones::spawn_double_points;
    functions["fire_sale"] = scripts\zm\funciones::spawn_fire_sale;
    functions["nuke"] = scripts\zm\funciones::spawn_nuke;
    functions["zombie_blood"] = scripts\zm\funciones::spawn_zombie_blood;

    return functions[powerup_key];
}





open_advanced_mods_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "MODS AVANZADOS" : "ADVANCED MODS";
    menu = create_menu(title, self);
    menu.parent_menu = "developer";

    if (self.langLEN == 0) 
    {
        
        add_menu_item(menu, "Clonar Jugador", scripts\zm\funciones::clone_player);

        gore_status = (isDefined(self.gore_enabled) && self.gore_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Gore Mode: " + gore_status, scripts\zm\funciones::toggle_gore_mode);

        add_menu_item(menu, "Abrir Todas las Puertas", scripts\zm\funciones::open_all_doors);

        add_menu_item(menu, "Kamikaze", scripts\zm\funciones::do_kamikaze);

        
        ufo_status = (isDefined(self.ufo_enabled) && self.ufo_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Modo UFO: " + ufo_status, scripts\zm\funciones::toggle_ufo_mode);

        forge_status = (isDefined(self.forge_enabled) && self.forge_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Forge Mode: " + forge_status, scripts\zm\funciones::toggle_forge_mode);

        jetpack_status = (isDefined(self.jetpack_enabled) && self.jetpack_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "JetPack: " + jetpack_status, scripts\zm\funciones::toggle_jetpack);

        
        aimbot_status = (isDefined(self.aimbot_enabled) && self.aimbot_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Aimbot: " + aimbot_status, scripts\zm\funciones::toggle_aimbot);

        artillery_status = (isDefined(self.artillery_enabled) && self.artillery_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Artillery: " + artillery_status, scripts\zm\funciones::toggle_artillery);

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        add_menu_item(menu, "Clone Player", scripts\zm\funciones::clone_player);

        gore_status = (isDefined(self.gore_enabled) && self.gore_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Gore Mode: " + gore_status, scripts\zm\funciones::toggle_gore_mode);

        add_menu_item(menu, "Open All Doors", scripts\zm\funciones::open_all_doors);

        add_menu_item(menu, "Kamikaze", scripts\zm\funciones::do_kamikaze);

        
        ufo_status = (isDefined(self.ufo_enabled) && self.ufo_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "UFO Mode: " + ufo_status, scripts\zm\funciones::toggle_ufo_mode);

        forge_status = (isDefined(self.forge_enabled) && self.forge_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Forge Mode: " + forge_status, scripts\zm\funciones::toggle_forge_mode);

        jetpack_status = (isDefined(self.jetpack_enabled) && self.jetpack_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "JetPack: " + jetpack_status, scripts\zm\funciones::toggle_jetpack);

        
        aimbot_status = (isDefined(self.aimbot_enabled) && self.aimbot_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Aimbot: " + aimbot_status, scripts\zm\funciones::toggle_aimbot);

        artillery_status = (isDefined(self.artillery_enabled) && self.artillery_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Artillery: " + artillery_status, scripts\zm\funciones::toggle_artillery);

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}



cycle_box_price_amount()
{
    
    if (!isDefined(self.box_price_change_amount))
        self.box_price_change_amount = 50;

    
    switch(self.box_price_change_amount)
    {
        case 50:
            self.box_price_change_amount = 100;
            break;
        case 100:
            self.box_price_change_amount = 300;
            break;
        case 300:
            self.box_price_change_amount = 500;
            break;
        case 500:
            self.box_price_change_amount = 700;
            break;
        case 700:
            self.box_price_change_amount = 1000;
            break;
        case 1000:
            self.box_price_change_amount = 5000;
            break;
        case 5000:
            self.box_price_change_amount = 10000;
            break;
        case 10000:
            self.box_price_change_amount = 50;
            break;
        default:
            self.box_price_change_amount = 50;
            break;
    }

    
    self thread scripts\zm\playsound::play_menu_scroll_sound(self);

    
    self thread scripts\zm\funciones::update_mystery_box_menu_display();
}

open_mystery_box_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "CAJA MISTERIOSA" : "MYSTERY BOX";
    menu = create_menu(title, self);
    menu.parent_menu = "developer";

    
    current_price = 950;
    if (isDefined(level.zombie_treasure_chest_cost))
        current_price = level.zombie_treasure_chest_cost;


    
    current_price_text = (self.langLEN == 0) ? "Precio Actual: " + current_price + " puntos" : "Current Price: " + current_price + " points";

    
    if (!isDefined(self.box_price_change_amount))
        self.box_price_change_amount = 50;

    
    change_amount = self.box_price_change_amount;
    amount_text = (self.langLEN == 0) ? "Cambiar: " + change_amount + " puntos" : "Change: " + change_amount + " points";

    if (self.langLEN == 0)
    {
        
        add_menu_item(menu, current_price_text, ::do_nothing);

        
        add_menu_item(menu, amount_text, ::cycle_box_price_amount);

        
        add_menu_item(menu, "[+] Aumentar Precio", scripts\zm\funciones::increase_box_price);

        
        add_menu_item(menu, "[-] Disminuir Precio", scripts\zm\funciones::decrease_box_price);

        
        add_menu_item(menu, "Precio: 950", scripts\zm\funciones::set_box_price_950);
        add_menu_item(menu, "Precio: 500", scripts\zm\funciones::set_box_price_500);
        add_menu_item(menu, "Precio: 0 (Gratis)", scripts\zm\funciones::set_box_price_0);

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        
        add_menu_item(menu, current_price_text, ::do_nothing);

        
        add_menu_item(menu, amount_text, ::cycle_box_price_amount);

        
        add_menu_item(menu, "[+] Increase Price", scripts\zm\funciones::increase_box_price);

        
        add_menu_item(menu, "[-] Decrease Price", scripts\zm\funciones::decrease_box_price);

        
        add_menu_item(menu, "Price: 950", scripts\zm\funciones::set_box_price_950);
        add_menu_item(menu, "Price: 500", scripts\zm\funciones::set_box_price_500);
        add_menu_item(menu, "Price: 0 (Free)", scripts\zm\funciones::set_box_price_0);

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    
    scripts\zm\funciones::update_mystery_box_menu_display();

    self thread menu_control(menu);
}



monitor_sv_cheats_activation()
{
    self endon("disconnect");
    level endon("end_game");

    
    if (!isDefined(self.partida_alterada_sv_cheats))
        self.partida_alterada_sv_cheats = false;

    wait 3;

    
    last_sv_cheats_state = getDvarInt("sv_cheats");

    while (true)
    {
        wait 1; 

        current_sv_cheats_state = getDvarInt("sv_cheats");

        
        
        if (last_sv_cheats_state == 0 && current_sv_cheats_state == 1)
        {
            
            

            // Marcar que la partida está alterada para TODOS los jugadores
            level.partida_alterada_global = true;
            self.partida_alterada_sv_cheats = true;

            
            if (!isDefined(self.developer_mode_unlocked) || !self.developer_mode_unlocked)
            {
                self.developer_mode_unlocked = true;
            }

            
            if (isDefined(self.langLEN) && self.langLEN == 0)
            {
                self iPrintlnBold("^2sv_cheats activado - Developer menu abierto automáticamente");
                self iPrintlnBold("^3¡Partida alterada! Estadísticas y banco deshabilitados");
            }
            else
            {
                self iPrintlnBold("^2sv_cheats enabled - Developer menu opened automatically");
                self iPrintlnBold("^3Match altered! Statistics and bank disabled");
            }


            
            if (isDefined(self.menu_open) && self.menu_open)
            {
                self notify("destroy_current_menu");
                wait 0.2;
            }

            
            wait 0.5;
            self thread open_main_menu(true); 
        }
        
        else if (last_sv_cheats_state == 1 && current_sv_cheats_state == 0)
        {
            
            self.developer_mode_unlocked = false;

            
            if (isDefined(self.langLEN) && self.langLEN == 0)
            {
                self iPrintlnBold("^1sv_cheats desactivado - Developer mode deshabilitado");
                self iPrintlnBold("^3¡Partida alterada permanentemente! Estadísticas y banco siguen deshabilitados");
            }
            else
            {
                self iPrintlnBold("^1sv_cheats disabled - Developer mode disabled");
                self iPrintlnBold("^3Match permanently altered! Statistics and bank remain disabled");
            }

            if (isDefined(self.menu_open) && self.menu_open)
            {
                self notify("destroy_current_menu");
                wait 0.2;
            }

            
            wait 0.5;
            self thread open_main_menu(true); 
        }

        last_sv_cheats_state = current_sv_cheats_state;
    }
}



