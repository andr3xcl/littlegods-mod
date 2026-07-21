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
#include scripts\zm\style_shaders_menu;
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
    level thread scripts\zm\chat::init();
    
    
    
    
    
    level thread init_edge_animations();
    
    
    level thread init_font_positions();
    level thread init_font_animations();
    level thread init_menu_sounds();
    level thread init_legacy_mods_performance();
    
    
    level thread init_functions();
    
    
    level thread init_strings();
    level thread init_function_registry();
    
    level.player_out_of_playable_area_monitor = 0;
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


watch_password_chat()
{
    self endon("disconnect");
    
    for(;;)
    {
        level waittill("say", message, player);
        
        if(player != self)
            continue;
            
        
        if (isDefined(self.is_changing_dev_pass) && self.is_changing_dev_pass)
        {
            self thread watch_dev_password_chat(message);
            continue;
        }
            
        message_lower = toLower(message);
        
        
        pass = "admin";
        if (isDefined(self.dev_password))
            pass = self.dev_password;
            
        if(message_lower == pass)
        {
            if (!isDefined(self.developer_mode_unlocked) || !self.developer_mode_unlocked)
            {
                self.developer_mode_unlocked = true;
                if(self.langLEN == 0) 
                    self iPrintlnBold("^2Modo Developer: ^7Desbloqueado");
                else 
                    self iPrintlnBold("^2Developer Mode: ^7Unlocked");
                
                wait 0.5;
                
                self thread open_developer_menu();
            }
            else
            {
                if(self.langLEN == 0) 
                    self iPrintlnBold("^2Modo Developer: ^7Ya desbloqueado");
                else 
                    self iPrintlnBold("^2Developer Mode: ^7Already Unlocked");
                    
                wait 0.5;
                self thread open_developer_menu();
            }
        }
        else if(message_lower == "teleport")
        {
            if (!isDefined(self.developer_mode_unlocked) || !self.developer_mode_unlocked)
            {
                if(self.langLEN == 0) 
                    self iPrintlnBold("^1Necesitas tener Developer Mode desbloqueado");
                else 
                    self iPrintlnBold("^1You need Developer Mode unlocked");
                continue;
            }

            
            wait 0.2;
            self thread open_teleport_menu();
        }
        
        
        else if(isSubStr(message_lower, "añadir posicion "))
        {
            position_name = getSubStr(message, 16); 
            if(position_name != "" && position_name != " ")
                self thread save_position_with_name(position_name);
            else
            {
                if(self.langLEN == 0) self iPrintlnBold("^1Debes especificar un nombre para la posición");
                else self iPrintlnBold("^1You must specify a name for the position");
            }
        }
        else if(isSubStr(message_lower, "tp "))
        {
            position_name = getSubStr(message, 3); 
            if(position_name != "" && position_name != " ")
                self thread teleport_to_position(position_name);
            else
            {
                if(self.langLEN == 0) self iPrintlnBold("^1Debes especificar el nombre de la posición");
                else self iPrintlnBold("^1You must specify the position name");
            }
        }
        else if(isSubStr(message_lower, "eliminar posicion "))
        {
            position_name = getSubStr(message, 18); 
            if(position_name != "" && position_name != " ")
                self thread delete_position(position_name);
            else
            {
                if(self.langLEN == 0) self iPrintlnBold("^1Debes especificar el nombre de la posición");
                else self iPrintlnBold("^1You must specify the position name");
            }
        }
        else if(message_lower == "lista posiciones")
        {
            self thread list_saved_positions();
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
        
        if (!isDefined(level.player_init_status))
            level.player_init_status = [];
            
        player_guid = self getGuid();
        
        if (!isDefined(level.player_init_status[player_guid]))
        {
            self.match_config_prompted = undefined;
            self.profile_prompted = undefined;
            self.current_profile_name = undefined;
            
            self.menu_style_index = 5;
            self.selector_style_index = 14;
            self.edge_animation_style_index = 0;
            self.font_position_index = 0;
            self.font_animation_index = 0;
            self.transparency_index = 5;
            self.background_shader_index = -1;
            self.header_shader_index = -1;
            self.selection_shader_index = -1;
            self.menu_glow_enabled = false;
            
            self.dev_password = "admin";
            
            level.player_init_status[player_guid] = true;
        }
    
    
        if (!isDefined(self.menu_open))
        {
            self.menu_open = false;
            self.night_mode_enabled = false;
            self.night_mode_filter = 0;
            self.night_mode_darkness = 4.5; 
            self.fog_enabled = false; 
            self.healthbar_enabled = false; 
            self.healthbar_position = "left"; 

            
            self.healthbarzombie_enabled = false;
            self.healthbarzombie_color = "default";
            self.healthbarzombie_sizew = 100; 
            self.healthbarzombie_sizeh = 2; 
            self.healthbarzombie_sizen = 1.2; 
            self.healthbarzombie_shader = "transparent"; 
            self.show_zombie_name = true; 

            
            self.godmode_enabled = false;

            
            self.developer_mode_unlocked = false;
            
            
            self thread watch_password_chat();

        
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
            
            if (!isDefined(self.menu_glow_enabled))
                self.menu_glow_enabled = false;

            
            if (!isDefined(self.menu_style_index))
                self.menu_style_index = 5; 

            if (!isDefined(self.transparency_index))
                self.transparency_index = 5; 
            
            if (!isDefined(self.background_shader_index))
                self.background_shader_index = -1; 
                
            if (!isDefined(self.header_shader_index))
                self.header_shader_index = -1;
                
            if (!isDefined(self.selection_shader_index))
                self.selection_shader_index = -1;

           
            
            setdvar("g_ai", "1"); 
            self.Fr3ZzZoM = false;

            
            
            

            

            
            if(!isDefined(self.menu_select_button_index))
                self.menu_select_button_index = 0; 
            if(!isDefined(self.menu_down_button_index))
                self.menu_down_button_index = 0; 
            if(!isDefined(self.menu_up_button_index))
                self.menu_up_button_index = 0; 
            if(!isDefined(self.menu_cancel_button_index))
                self.menu_cancel_button_index = 1;

            if (!isDefined(self.dev_password))
                self.dev_password = "admin";

            self thread menu_listener();
            
            if (self.langLEN == 0)
                self iPrintLn("^3Presiona ^7[{+ads}]+[{+melee}] ^3para abrir el menú de mods");
            else
                self iPrintLn("^3Press ^7[{+ads}]+[{+melee}] ^3to open mods menu");

            
            self thread init_teleport_system();
        }

        
        
        self.healthbar_enabled = false;
        if (!isDefined(self.healthbar_position)) self.healthbar_position = "left";
        if (!isDefined(self.healthbar_width)) self.healthbar_width = 100;
        if (!isDefined(self.healthbar_height)) self.healthbar_height = 4;
        if (!isDefined(self.healthbar_shader)) self.healthbar_shader = false;
        if (!isDefined(self.healthbar_font_scale)) self.healthbar_font_scale = 1.2;

        
        if (self.godmode_enabled)
        {
            self notify("godmode_off");
            self disableInvulnerability();
            self.godmode_enabled = false;
        }

        
        
        
        
        
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

        
        if (self.healthbar_enabled) 
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
    }
}

menu_listener()
{
    self endon("disconnect");
    
    
    wait 1.5;
    
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

    self notify("destroy_current_menu");
    wait 0.1;
    
    
    
    if (!isDefined(self.language_defined))
    {
        scripts\zm\sqllocal::load_menu_config(self);
        
        
        self.menu_style_index = 5;
        self.selector_style_index = 14;
        self.edge_animation_style_index = 0;
        self.font_position_index = 0;
        self.font_animation_index = 0;
        self.transparency_index = 5;
        self.background_shader_index = -1;
        self.header_shader_index = -1;
        self.selection_shader_index = -1;
        self.menu_glow_enabled = false;
    }
    
    
    
    if (!isDefined(self.language_defined) || !self.language_defined)
    {
         
         
         self thread open_language_selection_menu();
         return;
    }

    
    if (!isDefined(self.match_config_prompted) && (!isDefined(is_returning) || !is_returning))
    {
        self.match_config_prompted = true; 
        
        match_configs = scripts\zm\sqllocal::get_player_match_configs(self);
        if (match_configs.size > 0)
        {
            self thread open_startup_match_config_menu();
            return;
        }
    }

    
    if (!isDefined(self.profile_prompted) && (!isDefined(is_returning) || !is_returning))
    {
        self.profile_prompted = true; 
        
        profiles = scripts\zm\sqllocal::get_player_profiles(self);
        if (profiles.size > 0)
        {
            self thread open_startup_profile_menu();
            return;
        }
    }

    
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
        add_menu_item(menu, "Developer", ::open_developer_menu);
        settings_item = add_menu_item(menu, "Configuración", ::open_settings_menu);
        if ((healthbar_active || healthbarzombie_active || legacy_mods_active) && self.edge_animation_style_index == 0)
        {
            
            settings_item.item.color = (1, 0.65, 0.2); 
        }
        add_menu_item(menu, "Créditos", ::open_credits_menu);
        add_menu_item(menu, "Cuenta", ::open_account_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        
        add_menu_item(menu, "Mods Littlegods", ::open_mods_littlegods_menu);


        add_menu_item(menu, "Map", ::open_map_menu);
        add_menu_item(menu, "Developer", ::open_developer_menu);

                
        settings_item = add_menu_item(menu, "Settings", ::open_settings_menu);
        if ((healthbar_active || healthbarzombie_active || legacy_mods_active) && self.edge_animation_style_index == 0)
        {
            
            settings_item.item.color = (1, 0.65, 0.2); 
        }
        add_menu_item(menu, "Credits", ::open_credits_menu);
        add_menu_item(menu, "Account", ::open_account_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    if (isDefined(self.transparency_index))
    {
        menu = scripts\zm\style_transparecy::apply_transparency(menu, self.transparency_index);
    }
    
    menu = scripts\zm\style_shaders_menu::apply_menu_shaders(menu);
    
    show_menu(menu);

    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
    }
    
    menu.items[menu.selected].item.color = (1, 1, 1);
    
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
        else if (self.healthbar_position == "top")
            pos_text = "ARRIBA";
        else
            pos_text = "DERECHA";
        pos_item = add_menu_item(menu, "Posición: " + pos_text, ::cycle_healthbar_position);
        pos_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        shader_item = add_menu_item(menu, "Sombreado: " + (self.healthbar_shader ? "ON" : "OFF"), ::toggle_healthbar_shader);
        shader_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        width_item = add_menu_item(menu, "Ancho: " + self.healthbar_width, ::cycle_healthbar_width);
        width_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        height_item = add_menu_item(menu, "Alto: " + self.healthbar_height, ::cycle_healthbar_height);
        height_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        font_item = add_menu_item(menu, "Fuente: " + self.healthbar_font_scale, ::cycle_healthbar_font_scale);
        font_item.item.alpha = self.healthbar_enabled ? 1 : 0;

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
        else if (self.healthbar_position == "top")
            pos_text = "TOP";
        else
            pos_text = "RIGHT";
        pos_item = add_menu_item(menu, "Position: " + pos_text, ::cycle_healthbar_position);
        pos_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        shader_item = add_menu_item(menu, "Shader: " + (self.healthbar_shader ? "ON" : "OFF"), ::toggle_healthbar_shader);
        shader_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        width_item = add_menu_item(menu, "Width: " + self.healthbar_width, ::cycle_healthbar_width);
        width_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        height_item = add_menu_item(menu, "Height: " + self.healthbar_height, ::cycle_healthbar_height);
        height_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        font_item = add_menu_item(menu, "Font Scale: " + self.healthbar_font_scale, ::cycle_healthbar_font_scale);
        font_item.item.alpha = self.healthbar_enabled ? 1 : 0;

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
    
    
    if (!isDefined(self.menu_current) || !isDefined(self.menu_current.parent_menu))
    {
        self.is_going_back = undefined;
        return;
    }
    
    parent_type = self.menu_current.parent_menu;
    
    
    self notify("destroy_current_menu");
    wait 0.15; 
    
    
    self.is_going_back = undefined;
    
    
    switch(parent_type)
    {
        case "main":
            self thread open_main_menu(true); 
            break;
        
        case "settings":
            self thread open_settings_menu(true); 
            break;

        case "account":
            self thread open_account_menu();
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
            
        case "teleport_categories":
                self thread open_teleport_categories_menu();
                break;

        case "recent_matches":
            self thread open_recent_matches_menu();
            break;

        case "manage_profiles":
            self thread open_manage_profiles_menu();
            break;

        case "startup_profile":
            self thread open_startup_profile_menu();
            break;
        
        case "save_profiles_0":
        case "save_profiles_1":
        case "save_profiles_2":
            save_type = int(strTok(parent_type, "_")[2]);
            self thread open_save_profiles_menu(save_type);
            break;

        case "match_startup":
            self thread open_startup_match_config_menu();
            break;

        case "match_profiles":
            self thread open_match_profiles_menu();
            break;

        case "match_load":
            self thread open_load_match_configs_menu();
            break;

        default:
            self thread open_main_menu(true); 
            break;
    }
}


create_menu(title, player)
{
    
    if (isDefined(player.menu_current))
    {
        player.menu_current menu_destroy();
    }

    
    if (isDefined(player.adding_to_cat))
    {
        if (!isSubStr(title, "["))
            title = "^3[SEL] ^7" + title;
    }
    
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

    
    hide_title = scripts\zm\style_shaders_menu::should_hide_title_for_logo_shader(player);
    menu.title_text.alpha = hide_title ? 0 : 1;
    menu.title_text.color = (1, 1, 1);
    menu.title_text.sort = 2;
    
    if (isDefined(player.menu_glow_enabled) && player.menu_glow_enabled)
    {
        menu.title_text.glowAlpha = 0.1;
        menu.title_text.glowColor = (1, 1, 1);
    }
    
    menu.title_text setTextUnlimited(title);

    
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
    menu.title_shadow setTextUnlimited(title);

    
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
        
        hide_title = scripts\zm\style_shaders_menu::should_hide_title_for_logo_shader(menu.user);
        menu.title_text.alpha = hide_title ? 0 : 1;
        menu.title_text.sort = 2;
    }

    if (isDefined(menu.title_shadow))
    {
        menu.title_shadow.alpha = hide_title ? 0 : 0.4;
        menu.title_shadow.sort = 0;
    }

    
    if (isDefined(menu.user.font_animation_index) && menu.user.font_animation_index > 0)
    {
        scripts\zm\style_font_animation::apply_font_animation(menu, menu.user.font_animation_index);
    }

    return menu;
}

add_menu_item(menu, text, func, arg, arg2, arg3)
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

    if (isDefined(menu.user.menu_glow_enabled) && menu.user.menu_glow_enabled)
    {
        item.item.glowAlpha = 0.1;
        
    }
    
    
    if (menu.items.size == 0)
        item.item.color = menu.active_color;
    else
        item.item.color = menu.inactive_color;

    if (isDefined(menu.user.menu_glow_enabled) && menu.user.menu_glow_enabled)
    {
        item.item.glowColor = item.item.color;
    }
    
    item.item setTextUnlimited(text);
    item.func = func;
    item.arg = arg;
    item.arg2 = arg2;
    item.arg3 = arg3;
    item.is_menu = false;
    
    menu.items[menu.items.size] = item;
    return item;
}

add_menu_item_value(menu, text, func, arg, initial_value)
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

    if (isDefined(menu.user.menu_glow_enabled) && menu.user.menu_glow_enabled)
    {
        item.item.glowAlpha = 0.1;
    }
    
    
    if (menu.items.size == 0)
        item.item.color = menu.active_color;
    else
        item.item.color = menu.inactive_color;

    if (isDefined(menu.user.menu_glow_enabled) && menu.user.menu_glow_enabled)
    {
        item.item.glowColor = item.item.color;
    }
    
    
    item.label_text = text;
    item.item setTextUnlimited(text + initial_value);
    
    item.func = func;
    item.arg = arg;
    item.is_menu = false;
    
    menu.items[menu.items.size] = item;
    return item;
}

show_menu(menu)
{
    menu.open = true;
    
    
    total_height = menu.header_height + (menu.item_height * menu.items.size);
    menu.background setShader("white", menu.width, total_height);
    
    
    if (isDefined(menu.user))
    {
        menu = scripts\zm\style_shaders_menu::apply_menu_shaders(menu);
    }
    
    
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
    
    
    if (isDefined(menu.user) && isDefined(menu.user.selection_shader_index) && menu.user.selection_shader_index >= 0)
    {
        shader_name = scripts\zm\style_shaders_menu::get_selector_shader_by_index(menu.user.selection_shader_index);
        menu.selection_bar setShader(shader_name, menu.width, menu.item_height);
    }
    
    
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

        if (isDefined(menu.user.menu_glow_enabled) && menu.user.menu_glow_enabled)
        {
            menu.items[i].item.glowColor = menu.items[i].item.color;
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

        if (isDefined(self.user.menu_glow_enabled) && self.user.menu_glow_enabled)
        {
            self.items[i].item.glowColor = self.items[i].item.color;
        }
    }

    
    self.selection_bar.y = self.background.y + self.header_height + (self.item_height * self.selected);

    
    if (isDefined(self.user) && isDefined(self.user.selection_shader_index) && self.user.selection_shader_index >= 0)
    {
        shader_name = scripts\zm\style_shaders_menu::get_selector_shader_by_index(self.user.selection_shader_index);
        self.selection_bar setShader(shader_name, self.width, self.item_height);
    }

    
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

        if (isDefined(self.user.menu_glow_enabled) && self.user.menu_glow_enabled)
        {
            self.items[i].item.glowColor = self.items[i].item.color;
        }
    }

    
    self.selection_bar.y = self.background.y + self.header_height + (self.item_height * self.selected);

    
    if (isDefined(self.user) && isDefined(self.user.selection_shader_index) && self.user.selection_shader_index >= 0)
    {
        shader_name = scripts\zm\style_shaders_menu::get_selector_shader_by_index(self.user.selection_shader_index);
        self.selection_bar setShader(shader_name, self.width, self.item_height);
    }

    
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
    
    
    self.user.is_going_back = undefined;
    
    
    self notify("destroy_current_menu");
}

close_all_menus()
{
    
    scripts\zm\playsound::play_menu_close_sound(self);

    
    if (isDefined(self.menu_current))
    {
        self.menu_current menu_destroy();
    }
    
    
    self.menu_open = false;
    self.is_going_back = undefined;


    
    self.menu_current = undefined;

    
    wait 0.1;
}


menu_control(menu)
{
    self notify("new_menu_control");
    self endon("new_menu_control");
    self.is_going_back = undefined; 
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

        if (!isDefined(self.menu_up_button_index)) self.menu_up_button_index = 0;
        if (!isDefined(self.menu_down_button_index)) self.menu_down_button_index = 0;
        if (!isDefined(self.menu_select_button_index)) self.menu_select_button_index = 0;
        if (!isDefined(self.menu_cancel_button_index)) self.menu_cancel_button_index = 1;

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
                
                
                held_time = 0;
                while ((self.menu_up_button_index == 0 && self actionslotonebuttonpressed()) ||
                       (self.menu_up_button_index == 1 && self adsbuttonpressed()) ||
                       (self.menu_up_button_index == 2 && self actionslotfourbuttonpressed()))
                {
                    wait 0.05;
                    held_time += 0.05;
                    if (held_time > 0.3) 
                    {
                        menu menu_scroll_up();
                        wait 0.1; 
                    }
                }
            }
            else if (down_pressed)
            {
                menu menu_scroll_down();
                
                
                held_time = 0;
                while ((self.menu_down_button_index == 0 && self actionslottwobuttonpressed()) ||
                       (self.menu_down_button_index == 1 && self attackbuttonpressed()) ||
                       (self.menu_down_button_index == 2 && self secondaryoffhandbuttonpressed()))
                {
                    wait 0.05;
                    held_time += 0.05;
                    if (held_time > 0.3) 
                    {
                        menu menu_scroll_down();
                        wait 0.1; 
                    }
                }
            }
            else if (select_pressed)
            {
                
                while ((self.menu_select_button_index == 0 && self usebuttonpressed()) ||
                       (self.menu_select_button_index == 1 && self jumpbuttonpressed()) ||
                       (self.menu_select_button_index == 2 && self sprintbuttonpressed()) ||
                       (self.menu_select_button_index == 3 && self fragbuttonpressed()))
                    wait 0.05;

                menu menu_select_item();
            }
            else if (cancel_pressed && !up_pressed && !down_pressed && !select_pressed)
            {
                
                while ((self.menu_cancel_button_index == 0 && self stancebuttonpressed()) ||
                       (self.menu_cancel_button_index == 1 && self meleebuttonpressed()))
                    wait 0.05;

                self thread menu_go_back();
                scripts\zm\playsound::play_menu_cancel_sound(self);
            }
            
            
            wait 0.05;
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
            
            if (isDefined(self.user.adding_to_cat))
            {
                reg_key = get_registry_key_by_func(item.func);
                if (isDefined(reg_key))
                {
                    if (reg_key == "give_weapon" && isDefined(item.weapon_name))
                    {
                        reg_key = "WPN|" + item.weapon_name;
                    }
                    else if (reg_key == "give_weapon" && isDefined(item.arg))
                    {
                        reg_key = "WPN|" + item.arg;
                    }
                    
                    self.user thread add_item_to_custom_category_from_nav(self.user.adding_to_cat, reg_key);
                    return;
                }
            }
            
            
            if (isDefined(self.user.selecting_match_start_weapon) && self.user.selecting_match_start_weapon)
            {
                
                if (item.func == ::give_specific_weapon_menu || item.func == ::give_random_weapon_menu)
                {
                    
                    w_name = undefined;
                    if (item.func == ::give_random_weapon_menu) w_name = "random";
                    else if (isDefined(item.weapon_name)) w_name = item.weapon_name;
                    else if (isDefined(item.arg)) w_name = item.arg;
                    
                    if (isDefined(w_name))
                    {
                        self.user.selecting_match_start_weapon = undefined; 
                        self.user thread prompt_match_start_weapon_upgrade(self.user.match_config_editing_name, w_name);
                        return;
                    }
                }
            }
            
            
            if (isDefined(self.user.selecting_match_start_weapon_camo) && self.user.selecting_match_start_weapon_camo)
            {
                 if (item.func == ::apply_camo_menu)
                 {
                     camo_idx = undefined;
                     if (isDefined(item.camo_index)) camo_idx = item.camo_index;
                     
                     
                     if (isDefined(camo_idx))
                     {
                         self.user.selecting_match_start_weapon_camo = undefined; 
                         self.user thread match_config_set_weapon_final(camo_idx);
                         return;
                     }
                 }
            }
            
            if (isDefined(item.arg3))
                self.user thread [[item.func]](item.arg, item.arg2, item.arg3);
            else if (isDefined(item.arg2))
                self.user thread [[item.func]](item.arg, item.arg2);
            else if (isDefined(item.arg))
                self.user thread [[item.func]](item.arg);
            else
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
                    self.menu_current.items[i].item setTextUnlimited("Estado: " + status);
                else
                    self.menu_current.items[i].item setTextUnlimited("Status: " + status);
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
                    self.menu_current.items[i].item setTextUnlimited("Filtro: " + self.night_mode_filter);
                else
                    self.menu_current.items[i].item setTextUnlimited("Filter: " + self.night_mode_filter);
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
                    self.menu_current.items[i].item setTextUnlimited("Oscuridad: " + self.night_mode_darkness);
                else
                    self.menu_current.items[i].item setTextUnlimited("Darkness: " + self.night_mode_darkness);
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

    
    if (!self.healthbar_enabled && scripts\zm\style_shaders_menu::has_active_shaders(self))
    {
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra de vida");
            self iPrintlnBold("^1Desactiva los shaders del menú primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable health bar");
            self iPrintlnBold("^1Disable menu shaders first");
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
                    self.menu_current.items[i].item setTextUnlimited(self.healthbar_enabled ? level.strings["status_on_es"] : level.strings["status_off_es"]);
                else
                    self.menu_current.items[i].item setTextUnlimited(self.healthbar_enabled ? level.strings["status_on_en"] : level.strings["status_off_en"]);
                break;
            }
        }
        
        
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbar_position ||
                self.menu_current.items[i].func == ::toggle_healthbar_shader || self.menu_current.items[i].func == ::cycle_healthbar_width || 
                self.menu_current.items[i].func == ::cycle_healthbar_height || 
                self.menu_current.items[i].func == ::cycle_healthbar_font_scale)
            {
                self.menu_current.items[i].item.alpha = self.healthbar_enabled ? 1 : 0;
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

    
    if (self.healthbar_position == "right")
        self.healthbar_position = "left";
    else if (self.healthbar_position == "left")
        self.healthbar_position = "top_left";
    else if (self.healthbar_position == "top_left")
        self.healthbar_position = "top";
    else
        self.healthbar_position = "right"; 
    
    
    if (self.healthbar_enabled)
    {
        self thread bar_funtion_and_toogle(0);
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
                    else if (self.healthbar_position == "top")
                        pos_text = "ARRIBA";
                    else
                        pos_text = "DERECHA";
                    self.menu_current.items[i].item setTextUnlimited("Posición: " + pos_text);
                }
                else
                {
                    if (self.healthbar_position == "left")
                        pos_text = "LEFT";
                    else if (self.healthbar_position == "top_left")
                        pos_text = "TOP LEFT";
                    else if (self.healthbar_position == "top")
                        pos_text = "TOP";
                    else
                        pos_text = "RIGHT";
                    self.menu_current.items[i].item setTextUnlimited("Position: " + pos_text);
                }
                break;
            }
        }
    }
    
    wait 0.2;
}

cycle_healthbar_font_scale()
{
    if (!isDefined(self.healthbar_font_scale))
        self.healthbar_font_scale = 1.1;

    self.healthbar_font_scale += 0.1;
    if (self.healthbar_font_scale > 1.35) 
        self.healthbar_font_scale = 1.0;

    if (self.healthbar_enabled)
        self thread bar_funtion_and_toogle(0);

    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbar_font_scale)
            {
                self.menu_current.items[i].item setTextUnlimited((self.langLEN == 0 ? "Fuente: " : "Font Scale: ") + self.healthbar_font_scale);
                break;
            }
        }
    }
}

toggle_healthbar_shader()
{
    if (!isDefined(self.healthbar_shader))
        self.healthbar_shader = false;

    self.healthbar_shader = !self.healthbar_shader;
    
    if (self.healthbar_enabled)
        self thread bar_funtion_and_toogle(0);
    
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_healthbar_shader)
            {
                status = self.healthbar_shader ? "ON" : "OFF";
                self.menu_current.items[i].item setTextUnlimited((self.langLEN == 0 ? "Sombreado: " : "Shader: ") + status);
                break;
            }
        }
    }
}

cycle_healthbar_width()
{
    if (!isDefined(self.healthbar_width))
        self.healthbar_width = 100;

    self.healthbar_width += 10;
    if (self.healthbar_width > 120)
        self.healthbar_width = 50;

    if (self.healthbar_enabled)
        self thread bar_funtion_and_toogle(0);

    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbar_width)
            {
                self.menu_current.items[i].item setTextUnlimited((self.langLEN == 0 ? "Ancho: " : "Width: ") + self.healthbar_width);
                break;
            }
        }
    }
}

cycle_healthbar_height()
{
    if (!isDefined(self.healthbar_height))
        self.healthbar_height = 2;

    self.healthbar_height += 1;
    if (self.healthbar_height > 4)
        self.healthbar_height = 1;

    if (self.healthbar_enabled)
        self thread bar_funtion_and_toogle(0);

    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbar_height)
            {
                self.menu_current.items[i].item setTextUnlimited((self.langLEN == 0 ? "Alto: " : "Height: ") + self.healthbar_height);
                break;
            }
        }
    }
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
                    self.menu_current.items[i].item setTextUnlimited(self.fog_enabled ? level.strings["fog_on_es"] : level.strings["fog_off_es"]);
                else
                    self.menu_current.items[i].item setTextUnlimited(self.fog_enabled ? level.strings["fog_on_en"] : level.strings["fog_off_en"]);
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

    
    if (!self.healthbarzombie_enabled && scripts\zm\style_shaders_menu::has_active_shaders(self))
    {
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra zombie");
            self iPrintlnBold("^1Desactiva los shaders del menú primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable zombie bar");
            self iPrintlnBold("^1Disable menu shaders first");
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
                        self.menu_current.items[i].item setTextUnlimited("Posición: ARRIBA");
                    else
                        self.menu_current.items[i].item setTextUnlimited("Position: TOP");
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
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setTextUnlimited(self.healthbarzombie_enabled ? level.strings["status_on_es"] : level.strings["status_off_es"]);
                else
                    self.menu_current.items[i].item setTextUnlimited(self.healthbarzombie_enabled ? level.strings["status_on_en"] : level.strings["status_off_en"]);
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
                    self.menu_current.items[i].item setTextUnlimited("Color: " + color_display_name);
                else 
                    self.menu_current.items[i].item setTextUnlimited("Color: " + color_display_name);
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
                    self.menu_current.items[i].item setTextUnlimited("Ancho: " + self.healthbarzombie_sizew);
                else
                    self.menu_current.items[i].item setTextUnlimited("Width: " + self.healthbarzombie_sizew);
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
                    self.menu_current.items[i].item setTextUnlimited("Alto: " + self.healthbarzombie_sizeh);
                else
                    self.menu_current.items[i].item setTextUnlimited("Height: " + self.healthbarzombie_sizeh);
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
                    self.menu_current.items[i].item setTextUnlimited("Tamaño Nombre: " + self.healthbarzombie_sizen);
                else
                    self.menu_current.items[i].item setTextUnlimited("Name Size: " + self.healthbarzombie_sizen);
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
                self.menu_current.items[i].item setTextUnlimited("Shader: " + self.healthbarzombie_shader);
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
                    self.menu_current.items[i].item setTextUnlimited("Mostrar Nombre: " + zombieNameStatus);
                else
                    self.menu_current.items[i].item setTextUnlimited("Show Name: " + zombieNameStatus);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_zombie_name = undefined;
}


toggle_language(source_menu)
{
    
    if (isDefined(self.is_toggling_language))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_language = true;

    self.langLEN = (self.langLEN == 0) ? 1 : 0;
    
    
    self.language_defined = true;
    
    
    scripts\zm\sqllocal::save_menu_config(self);

    
    if (isDefined(source_menu) && source_menu == "account")
    {
        self thread open_account_menu();
    }
    else if (isDefined(source_menu) && source_menu == "first_time")
    {
        
        if (self.langLEN == 0) self iPrintLnBold("^2Idioma Establecido: ^7Español");
        else self iPrintLnBold("^2Language Set: ^7English");
        
        wait 0.5;
        self thread open_main_menu();
    }
    else
    {
        
        self thread open_settings_menu(true, 0);
    }

    
    wait 0.5;
    self.is_toggling_language = undefined;
}

open_language_selection_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    
    title = "LANGUAGE / IDIOMA";
    menu = create_menu(title, self);
    
    
    add_menu_item(menu, "Español", ::toggle_language_specific, 0); 
    add_menu_item(menu, "English", ::toggle_language_specific, 1); 
    
    show_menu(menu);
    self thread menu_control(menu);
}

toggle_language_specific(lang_index)
{
    self.langLEN = lang_index;
    self.language_defined = true;
    
    scripts\zm\sqllocal::save_menu_config(self);
    
    if (self.langLEN == 0) self iPrintLnBold("^2Idioma Establecido: ^7Español");
    else self iPrintLnBold("^2Language Set: ^7English");
    
    wait 0.5;
    self thread open_main_menu();
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
        self.menu_current.title_text setTextUnlimited(new_title);
    }

    
    if (isDefined(self.menu_current.title_shadow))
    {
        self.menu_current.title_shadow setTextUnlimited(new_title);
    }

    
    if (self.langLEN == 0) 
    {
        
        if (isDefined(self.menu_current.items[0]))
        {
            lang = (self.langLEN == 0) ? "Español" : "Inglés";
            self.menu_current.items[0].item setTextUnlimited("Idioma: " + lang);
        }

        
        if (isDefined(self.menu_current.items[1]))
        {
            styleName = get_style_name(self.menu_style_index, self.langLEN);
            count_str = " (" + (self.menu_style_index + 1) + "/" + level.menu_styles.size + ")";
            self.menu_current.items[1].item setTextUnlimited("Estilo Menú: " + styleName + count_str);
        }

        
        if (isDefined(self.menu_current.items[2]))
        {
            selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
            count_str = " (" + (self.selector_style_index + 1) + "/" + level.selector_styles.size + ")";
            self.menu_current.items[2].item setTextUnlimited("Estilo Selector: " + selectorStyleName + count_str);
        }

        
        if (isDefined(self.menu_current.items[3]))
        {
            fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
            self.menu_current.items[3].item setTextUnlimited("Posición Texto: " + fontPositionName);
        }

        
        if (isDefined(self.menu_current.items[4]))
        {
            edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
            self.menu_current.items[4].item setTextUnlimited("Animación Borde: " + edgeAnimStyleName);
        }

        
        if (isDefined(self.menu_current.items[5]))
        {
            fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
            self.menu_current.items[5].item setTextUnlimited("Animación Fuente: " + fontAnimName);
        }

        
        if (isDefined(self.menu_current.items[6]))
        {
            transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
            self.menu_current.items[6].item setTextUnlimited(transparencyName);
        }

        
        if (isDefined(self.menu_current.items[7]))
        {
            glow_status = self.menu_glow_enabled ? "ON" : "OFF";
            self.menu_current.items[7].item setTextUnlimited("Brillo Menú: " + glow_status);
        }

        if (isDefined(self.menu_current.items[8]))
        {
            self.menu_current.items[8].item setTextUnlimited("Dimensiones del Menú");
        }

        if (isDefined(self.menu_current.items[9]))
        {
            self.menu_current.items[9].item setTextUnlimited("Shaders del Menú");
        }

        if (isDefined(self.menu_current.items[10]))
        {
            self.menu_current.items[10].item setTextUnlimited("Controles del Menú");
        }

        if (isDefined(self.menu_current.items[11]))
        {
            self.menu_current.items[11].item setTextUnlimited("Sonidos");
        }

        if (isDefined(self.menu_current.items[12]))
        {
            self.menu_current.items[12].item setTextUnlimited("Guardar Configuración");
        }

        if (isDefined(self.menu_current.items[13]))
            self.menu_current.items[13].item setTextUnlimited("Volver");
        if (isDefined(self.menu_current.items[14]))
            self.menu_current.items[14].item setTextUnlimited("Cerrar Menú");
    }
    else 
    {
        
        if (isDefined(self.menu_current.items[0]))
        {
            lang = (self.langLEN == 0) ? "Spanish" : "English";
            self.menu_current.items[0].item setTextUnlimited("Language: " + lang);
        }

        
        if (isDefined(self.menu_current.items[1]))
        {
            styleName = get_style_name(self.menu_style_index, self.langLEN);
            count_str = " (" + (self.menu_style_index + 1) + "/" + level.menu_styles.size + ")";
            self.menu_current.items[1].item setTextUnlimited("Menu Style: " + styleName + count_str);
        }

        
        if (isDefined(self.menu_current.items[2]))
        {
            selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
            count_str = " (" + (self.selector_style_index + 1) + "/" + level.selector_styles.size + ")";
            self.menu_current.items[2].item setTextUnlimited("Selector Style: " + selectorStyleName + count_str);
        }

        
        if (isDefined(self.menu_current.items[3]))
        {
            fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
            self.menu_current.items[3].item setTextUnlimited("Text Position: " + fontPositionName);
        }

        
        if (isDefined(self.menu_current.items[4]))
        {
            edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
            self.menu_current.items[4].item setTextUnlimited("Edge Animation: " + edgeAnimStyleName);
        }

        
        if (isDefined(self.menu_current.items[5]))
        {
            fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
            self.menu_current.items[5].item setTextUnlimited("Font Animation: " + fontAnimName);
        }

        
        if (isDefined(self.menu_current.items[6]))
        {
            transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
            self.menu_current.items[6].item setTextUnlimited(transparencyName);
        }

        
        if (isDefined(self.menu_current.items[7]))
        {
            glow_status = self.menu_glow_enabled ? "ON" : "OFF";
            self.menu_current.items[7].item setTextUnlimited("Menu Glow: " + glow_status);
        }

        if (isDefined(self.menu_current.items[8]))
        {
            self.menu_current.items[8].item setTextUnlimited("Menu Dimensions");
        }

        if (isDefined(self.menu_current.items[9]))
        {
            self.menu_current.items[9].item setTextUnlimited("Menu Shaders");
        }

        if (isDefined(self.menu_current.items[10]))
        {
            self.menu_current.items[10].item setTextUnlimited("Menu Controls");
        }

        if (isDefined(self.menu_current.items[11]))
        {
            self.menu_current.items[11].item setTextUnlimited("Sound");
        }

        if (isDefined(self.menu_current.items[12]))
        {
            self.menu_current.items[12].item setTextUnlimited("Save Configuration");
        }

        if (isDefined(self.menu_current.items[13]))
            self.menu_current.items[13].item setTextUnlimited("Back");
        if (isDefined(self.menu_current.items[14]))
            self.menu_current.items[14].item setTextUnlimited("Close Menu");
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


open_settings_menu(is_returning, state_page)
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;
    
    
    if (!isDefined(state_page)) state_page = 0;
    
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
        if (state_page == 0)
        {
            
            
            
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
            
            
            
            
            
            add_menu_item(menu, ">> Siguiente Página", ::open_settings_menu, true, 1);
        }
        else if (state_page == 1)
        {
            
            glow_status = self.menu_glow_enabled ? "ON" : "OFF";
            add_menu_item(menu, "Brillo Menú: " + glow_status, ::toggle_menu_glow);
    
            add_menu_item(menu, "Dimensiones del Menú", ::open_menu_dimensions_settings);
            add_menu_item(menu, "Shaders del Menú", ::open_menu_shaders_settings);
            add_menu_item(menu, "Controles del Menú", ::open_menu_controls_settings);
            add_menu_item(menu, "Sonidos", ::open_sound_settings_menu);
            
            add_menu_item(menu, "Guardar Configuración", ::open_save_profiles_menu);
            add_menu_item(menu, "Gestionar Perfiles", ::open_manage_profiles_menu);
            
            
            add_menu_item(menu, "<< Anterior Página", ::open_settings_menu, true, 0);
        }

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else 
    {
        if (state_page == 0)
        {
            
            
            
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
            
            
            add_menu_item(menu, ">> Next Page", ::open_settings_menu, true, 1);
        }
        else if (state_page == 1)
        {
            
            glow_status = self.menu_glow_enabled ? "ON" : "OFF";
            add_menu_item(menu, "Menu Glow: " + glow_status, ::toggle_menu_glow);
    
            add_menu_item(menu, "Menu Dimensions", ::open_menu_dimensions_settings);
            add_menu_item(menu, "Menu Shaders", ::open_menu_shaders_settings);
            add_menu_item(menu, "Menu Controls", ::open_menu_controls_settings);
            add_menu_item(menu, "Sound", ::open_sound_settings_menu);
            
            add_menu_item(menu, "Save Configuration", ::open_save_profiles_menu);
            add_menu_item(menu, "Manage Profiles", ::open_manage_profiles_menu);
            
            
            add_menu_item(menu, "<< Previous Page", ::open_settings_menu, true, 0);
        }

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

    if (!isDefined(self.show_coords))
        self.show_coords = false;

    
    
    if (self.langLEN == 0) 
    {
        
        perk_status = self.perk_unlimite_active ? "ON" : "OFF";
        add_menu_item(menu, "Perk Unlimited: " + perk_status, scripts\zm\funciones::toggle_perk_unlimite);
        
        
        thirdperson_status = self.TPP ? "ON" : "OFF";
        add_menu_item(menu, "Tercera Persona: " + thirdperson_status, scripts\zm\funciones::ThirdPerson);

        
        coords_status = self.show_coords ? "ON" : "OFF";
        add_menu_item(menu, "Coordenadas Pantalla: " + coords_status, scripts\zm\funciones::toggle_coords);


        add_menu_item(menu, "Partidas Recientes", ::open_recent_matches_menu);


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

        
        coords_status = self.show_coords ? "ON" : "OFF";
        add_menu_item(menu, "Screen Coordinates: " + coords_status, scripts\zm\funciones::toggle_coords);


        add_menu_item(menu, "Recent Matches", ::open_recent_matches_menu);


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

    
    if (!isDefined(self.developer_mode_unlocked) || !self.developer_mode_unlocked)
    {
        
        self thread close_all_menus();
        if (self.langLEN == 0) self iPrintLnBold("^1Acceso Denegado. ^7Escribe la contraseña en el chat.");
        else self iPrintLnBold("^1Access Denied. ^7Type the password in chat.");
        
        
        if (isDefined(self.dev_password) && self.dev_password == "admin")
        {
            wait 2;
            if (self.langLEN == 0) self iPrintLn("^3Tip: ^7La contraseña por defecto es ^2admin");
            else self iPrintLn("^3Tip: ^7Default password is ^2admin");
        }
        return;
    }

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
        add_menu_item(menu, "Config.gods", ::open_match_profiles_menu);
        
        if (!isDefined(self.adding_to_cat))
            add_menu_item(menu, "Mis Categorías", ::open_custom_dev_categories_menu);
            
        add_menu_item(menu, "Modo Foto", scripts\zm\funciones::toggle_photo_mode);

        if (isDefined(self.adding_to_cat))
            add_menu_item(menu, "^1CANCELAR SELECCIÓN", ::cancel_nav_selection);
        else
            add_menu_item(menu, "Volver", ::menu_go_back);
            
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {

        add_menu_item(menu, "Player", ::open_player_menu);
        add_menu_item(menu, "Zombie", ::open_zombie_menu);
        add_menu_item(menu, "Mystery Box", ::open_mystery_box_menu);
        add_menu_item(menu, "Config.gods", ::open_match_profiles_menu);
        
        if (!isDefined(self.adding_to_cat))
            add_menu_item(menu, "My Categories", ::open_custom_dev_categories_menu);
            
        add_menu_item(menu, "Photo Mode", scripts\zm\funciones::toggle_photo_mode);

        if (isDefined(self.adding_to_cat))
            add_menu_item(menu, "^1CANCEL SELECTION", ::cancel_nav_selection);
        else
            add_menu_item(menu, "Back", ::menu_go_back);
            
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    
    show_menu(menu);
    
    
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
    }
    
    menu.items[menu.selected].item.color = (1, 1, 1);
    
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
        self.password_hud setTextUnlimited("^3Escriba ^2'admin' ^3en el chat para desbloquear");
    else 
        self.password_hud setTextUnlimited("^3Type ^2'admin' ^3in chat to unlock");

    
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
                      
                  self.menu_current.items[i].item setTextUnlimited(transparency_text);
                  break;
              }
        }
    }
    
    wait 0.2;
    self.is_cycling_transparency = undefined;
}

toggle_menu_glow()
{
    self.menu_glow_enabled = !self.menu_glow_enabled;
    
    if (self.langLEN == 0)
        self iPrintln("^2Brillo del Menú: " + (self.menu_glow_enabled ? "ACTIVADO" : "DESACTIVADO"));
    else
        self iPrintln("^2Menu Glow: " + (self.menu_glow_enabled ? "ENABLED" : "DISABLED"));

    if (isDefined(self.menu_current))
    {
        
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_menu_glow)
            {
                glow_status = self.menu_glow_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setTextUnlimited("Brillo Menú: " + glow_status); 
                else
                    self.menu_current.items[i].item setTextUnlimited("Menu Glow: " + glow_status);
                break;
            }
        }

        
        glowAlpha = self.menu_glow_enabled ? 0.1 : 0;

        if (isDefined(self.menu_current.title_text))
        {
            self.menu_current.title_text.glowAlpha = glowAlpha;
            if (self.menu_glow_enabled)
                self.menu_current.title_text.glowColor = (1, 1, 1);
        }

        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (isDefined(self.menu_current.items[i].item))
            {
                self.menu_current.items[i].item.glowAlpha = glowAlpha;
                if (self.menu_glow_enabled)
                {
                    self.menu_current.items[i].item.glowColor = self.menu_current.items[i].item.color;
                }
            }
        }
    }
}


save_menu_configuration()
{
    self thread open_save_profiles_menu(0);
}

open_save_profiles_menu(save_type)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    if (!isDefined(save_type)) save_type = 0;
    
    comp_name = "";
    if (save_type == 1) comp_name = (self.langLEN == 0) ? " (NIGHTMODE)" : " (NIGHTMODE)";
    else if (save_type == 2) comp_name = (self.langLEN == 0) ? " (MAPA)" : " (MAP)";
    
    title = (self.langLEN == 0) ? "GUARDAR PERFIL" + comp_name : "SAVE PROFILE" + comp_name;
    menu = create_menu(title, self);
    
    if (save_type == 0) menu.parent_menu = "settings";
    else if (save_type == 1) menu.parent_menu = "nightmode";
    else if (save_type == 2) menu.parent_menu = "map";
    
    if (save_type == 0) add_menu_item(menu, (self.langLEN == 0) ? "Crear Nuevo Perfil" : "Create New Profile", ::prompt_create_profile, save_type);
    add_menu_item(menu, (self.langLEN == 0) ? "Actualizar Existente" : "Update Existing", ::open_overwrite_profile_menu, save_type);
    add_menu_item(menu, (self.langLEN == 0) ? "Guardar Default (Auto)" : "Save Default (Auto)", ::save_default_config_action, save_type);
    
    if (save_type == 0) add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_settings_menu, true);
    else if (save_type == 1) add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_night_mode_menu, true);
    else if (save_type == 2) add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_map_menu, true);
    
    show_menu(menu);
    self thread menu_control(menu);
}

save_default_config_action(save_type)
{
    success = false;
    if (save_type == 0) success = scripts\zm\sqllocal::save_settings_only(self);
    else if (save_type == 1) success = scripts\zm\sqllocal::save_nightmode_only(self);
    else if (save_type == 2) success = scripts\zm\sqllocal::save_map_only(self);
    
    if (success)
    {
        if (self.langLEN == 0) self iPrintLnBold("^2Configuración Default guardada");
        else self iPrintLnBold("^2Default configuration saved");
    }
    wait 0.5;
    self thread open_save_profiles_menu(save_type);
}

prompt_create_profile(save_type)
{
    self endon("disconnect");
    self thread close_all_menus();
    
    if (!isDefined(save_type)) save_type = 0;
    
    if (self.langLEN == 0)
        self iPrintLnBold("Escribe el nombre del perfil en el chat");
    else
        self iPrintLnBold("Type the profile name in chat");
        
    self.is_typing_profile_name = true;
    self thread watch_profile_name_chat(save_type);
}

watch_profile_name_chat(save_type)
{
    self endon("disconnect");
    self endon("stop_typing_profile");
    
    if (!isDefined(save_type)) save_type = 0;
    
    while (isDefined(self.is_typing_profile_name) && self.is_typing_profile_name)
    {
        level waittill("say", message, player);
        
        if (player != self)
            continue;
            
        if (!isDefined(message) || message == "")
            continue;
            
        message = trim_string(message);
        if (message == "")
            continue;
            
        success = false;
        if (save_type == 0) success = scripts\zm\sqllocal::save_menu_profile(self, message);
        else if (save_type == 1) success = scripts\zm\sqllocal::save_menu_profile_selective(self, message, true, true, true); 
        else if (save_type == 2) success = scripts\zm\sqllocal::save_menu_profile_selective(self, message, true, true, true);
        
        if (success)
        {
            if (self.langLEN == 0) self iPrintLnBold("^2Perfil '" + message + "' guardado");
            else self iPrintLnBold("^2Profile '" + message + "' saved");
        }
        
        self.is_typing_profile_name = false;
        wait 0.5;
        self thread open_save_profiles_menu(save_type);
        return;
    }
}

open_overwrite_profile_menu(save_type)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    if (!isDefined(save_type)) save_type = 0;
    
    title = (self.langLEN == 0) ? "ACTUALIZAR PERFIL" : "UPDATE PROFILE";
    menu = create_menu(title, self);
    menu.parent_menu = "save_profiles_" + save_type;
    
    profiles = scripts\zm\sqllocal::get_player_profiles(self);
    
    if (profiles.size > 0)
    {
        foreach (p in profiles)
        {
            add_menu_item(menu, p, ::overwrite_profile_action, p, save_type);
        }
    }
    else
    {
        add_menu_item(menu, (self.langLEN == 0) ? "Sin perfiles" : "No profiles", ::do_nothing);
    }
    
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_save_profiles_menu, save_type);
    
    show_menu(menu);
    self thread menu_control(menu);
}

overwrite_profile_action(profile_name, save_type)
{
    if (!isDefined(save_type)) save_type = 0;
    
    success = false;
    if (save_type == 0) success = scripts\zm\sqllocal::save_menu_profile(self, profile_name);
    else if (save_type == 1) success = scripts\zm\sqllocal::save_menu_profile_selective(self, profile_name, false, true, false);
    else if (save_type == 2) success = scripts\zm\sqllocal::save_menu_profile_selective(self, profile_name, false, false, true);
    
    if (success)
    {
        if (self.langLEN == 0) self iPrintLnBold("^2Perfil '" + profile_name + "' actualizado");
        else self iPrintLnBold("^2Profile '" + profile_name + "' updated");
    }
    wait 0.5;
    self thread open_overwrite_profile_menu(save_type);
}

save_nightmode_configuration()
{
    self thread open_save_profiles_menu(1);
}

save_map_configuration()
{
    self thread open_save_profiles_menu(2);
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
        
        
        self.menu_current = scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);
        
        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);
        
        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }
        
        if (isDefined(self.selector_style_index))
        {
            self.menu_current = scripts\zm\style_selector::apply_selector_style(self.menu_current, self.selector_style_index);
            scripts\zm\style_selector::update_selector_visuals(self.menu_current);
            scripts\zm\style_selector::update_selector_position(self.menu_current);
        }
        
        
        if (isDefined(self.menu_current.items))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (isDefined(self.menu_current.items[i].item))
                {
                    if (i == self.menu_current.selected)
                        self.menu_current.items[i].item.color = (1, 1, 1);
                    else
                        self.menu_current.items[i].item.color = self.menu_current.inactive_color;

                    if (isDefined(self.menu_glow_enabled) && self.menu_glow_enabled)
                    {
                        self.menu_current.items[i].item.glowColor = self.menu_current.items[i].item.color;
                    }
                }
            }
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
                count_str = " (" + (self.menu_style_index + 1) + "/" + level.menu_styles.size + ")";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setTextUnlimited("Estilo Menú: " + styleName + count_str);
                else
                    self.menu_current.items[i].item setTextUnlimited("Menu Style: " + styleName + count_str);
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
                count_str = " (" + (self.selector_style_index + 1) + "/" + level.selector_styles.size + ")";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setTextUnlimited("Estilo Selector: " + selectorStyleName + count_str);
                else
                    self.menu_current.items[i].item setTextUnlimited("Selector Style: " + selectorStyleName + count_str);
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
                    self.menu_current.items[i].item setTextUnlimited("Animación Fuente: " + fontAnimName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Font Animation: " + fontAnimName);
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
                    self.menu_current.items[i].item setTextUnlimited("Abrir Menú: " + openSoundName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Open Menu: " + openSoundName);
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
                    self.menu_current.items[i].item setTextUnlimited("Cerrar Menú: " + closeSoundName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Close Menu: " + closeSoundName);
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
                    self.menu_current.items[i].item setTextUnlimited("Navegación: " + scrollSoundName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Navigation: " + scrollSoundName);
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
                    self.menu_current.items[i].item setTextUnlimited("Selección: " + selectSoundName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Selection: " + selectSoundName);
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
                    self.menu_current.items[i].item setTextUnlimited("Cancelar: " + cancelSoundName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Cancel: " + cancelSoundName);
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
                    self.menu_current.items[i].item setTextUnlimited("Seleccionar: " + buttonName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Select: " + buttonName);
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
                    self.menu_current.items[i].item setTextUnlimited("Bajar: " + buttonName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Go Down: " + buttonName);
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
                    self.menu_current.items[i].item setTextUnlimited("Subir: " + buttonName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Go Up: " + buttonName);
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
                    self.menu_current.items[i].item setTextUnlimited("Cancelar: " + buttonName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Cancel: " + buttonName);
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

    if (!level.player_health_display.enabled && (borders_active || healthbar_active || healthbarzombie_active || scripts\zm\style_shaders_menu::has_active_shaders(self)))
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^1No se puede activar mientras las barras de vida, bordes o shaders están activos");
        else
            self iPrintLnBold("^1Cannot activate while health bars, borders or shaders are active");
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
            self.menu_current.items[0].item setTextUnlimited("Estado: " + status);
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

    if (!level.zombie_health_display.enabled && (borders_active || healthbar_active || healthbarzombie_active || scripts\zm\style_shaders_menu::has_active_shaders(self)))
    {
        
        if (self.langLEN == 0)
            self iPrintLnBold("^1No se puede activar mientras las barras de vida, bordes o shaders están activos");
        else
            self iPrintLnBold("^1Cannot activate while health bars, borders or shaders are active");
        return;
    }

    scripts\zm\legacy_mods_performance::toggle_zombie_health_display(self);

    
    if (isDefined(self.menu_current) && (self.menu_current.title == "VIDA ZOMBIE" || self.menu_current.title == "ZOMBIE HEALTH"))
    {
        
        if (isDefined(self.menu_current.items[0]) && isDefined(self.menu_current.items[0].item))
        {
            status = level.zombie_health_display.enabled ? "ON" : "OFF";
            self.menu_current.items[0].item setTextUnlimited("Estado: " + status);
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

    if (!level.zombie_counter_display.enabled && (borders_active || healthbar_active || healthbarzombie_active || scripts\zm\style_shaders_menu::has_active_shaders(self)))
    {

        if (self.langLEN == 0)
            self iPrintLnBold("^1No se puede activar mientras las barras de vida, bordes o shaders están activos");
        else
            self iPrintLnBold("^1Cannot activate while health bars, borders or shaders are active");
        return;
    }

    scripts\zm\legacy_mods_performance::toggle_zombie_counter_display(self);

    
    if (isDefined(self.menu_current) && (self.menu_current.title == "CONTADOR ZOMBIES" || self.menu_current.title == "ZOMBIE COUNTER"))
    {
        
        if (isDefined(self.menu_current.items[0]) && isDefined(self.menu_current.items[0].item))
        {
            status = level.zombie_counter_display.enabled ? "ON" : "OFF";
            self.menu_current.items[0].item setTextUnlimited("Estado: " + status);
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
                    self.menu_current.items[i].item setTextUnlimited(color_label + color_name);
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
                        self.menu_current.items[i].item setTextUnlimited(mode_label + mode_text);
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
        self.menu_current.items[1].item setTextUnlimited(pos_label + pos_text);
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

        
        self.menu_current.items[3].item setTextUnlimited("Transparencia: " + alpha_text);
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
        self.menu_current.items[1].item setTextUnlimited(pos_label + pos_text);
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

        
        self.menu_current.items[3].item setTextUnlimited("Transparencia: " + alpha_text);
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
        self.menu_current.items[1].item setTextUnlimited(pos_label + pos_text);
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

        
        self.menu_current.items[3].item setTextUnlimited("Transparencia: " + alpha_text);
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
                self.menu_current.items[4].item setTextUnlimited("Degradado Colores: " + gradient_status);
            else
                self.menu_current.items[4].item setTextUnlimited("Color Gradient: " + gradient_status);
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
                self.menu_current.items[4].item setTextUnlimited("Degradado Colores: " + gradient_status);
            else
                self.menu_current.items[4].item setTextUnlimited("Color Gradient: " + gradient_status);
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

    
    if (scripts\zm\style_shaders_menu::has_active_shaders(self))
    {
        if (self.langLEN == 0)
            self iPrintlnBold("^1No se puede activar animación de borde mientras hay shaders activos");
        else
            self iPrintlnBold("^1Cannot activate edge animation while shaders are active");
        self.is_cycling_edge_animation = undefined;
        return;
    }
    
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
                    self.menu_current.items[i].item setTextUnlimited("Animación Borde: " + edgeAnimStyleName);
                else
                    self.menu_current.items[i].item setTextUnlimited("Edge Animation: " + edgeAnimStyleName);
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
    if (isDefined(self.selecting_match_start_weapon) && self.selecting_match_start_weapon)
    {
        title = "^3[SEL] ^7" + title;
    }
    
    menu = create_menu(title, self);
    menu.parent_menu = "player";
    
    if (self.langLEN == 0) 
    {
        
        if (!isDefined(self.selecting_match_start_weapon))
        {
            unlimited_ammo_status = (isDefined(self.unlimited_ammo) && self.unlimited_ammo) ? "ON" : "OFF";
            add_menu_item(menu, "Munición Infinita: " + unlimited_ammo_status, scripts\zm\funciones::toggle_unlimited_ammo);
        }

        add_menu_item(menu, "Arma Aleatoria", ::give_random_weapon_menu);
        
        if (!isDefined(self.selecting_match_start_weapon))
        {
            add_menu_item(menu, "Mejorar Arma Actual", ::upgrade_current_weapon_menu);
            
            insta_reload_status = (isDefined(self.insta_reload_enabled) && self.insta_reload_enabled) ? "ON" : "OFF";
            add_menu_item(menu, "Insta-Reload: " + insta_reload_status, scripts\zm\funciones::toggle_insta_reload);
            
            add_menu_item(menu, "Soltar Arma", scripts\zm\funciones::drop_current_weapon);
            
            add_menu_item(menu, "Camuflajes", ::open_camo_menu);
        }
        
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
        if (!isDefined(self.selecting_match_start_weapon))
        {
            unlimited_ammo_status = (isDefined(self.unlimited_ammo) && self.unlimited_ammo) ? "ON" : "OFF";
            add_menu_item(menu, "Unlimited Ammo: " + unlimited_ammo_status, scripts\zm\funciones::toggle_unlimited_ammo);
        }

        add_menu_item(menu, "Random Weapon", ::give_random_weapon_menu);
        
        if (!isDefined(self.selecting_match_start_weapon))
        {
            add_menu_item(menu, "Upgrade Current Weapon", ::upgrade_current_weapon_menu);

            insta_reload_status = (isDefined(self.insta_reload_enabled) && self.insta_reload_enabled) ? "ON" : "OFF";
            add_menu_item(menu, "Insta-Reload: " + insta_reload_status, scripts\zm\funciones::toggle_insta_reload);
            
            add_menu_item(menu, "Drop Weapon", scripts\zm\funciones::drop_current_weapon);
            
            add_menu_item(menu, "Camouflages", ::open_camo_menu);
        }
        
        add_menu_item(menu, "Group 1", ::open_weapons_submenu_1);
        add_menu_item(menu, "Group 2", ::open_weapons_submenu_2);
        add_menu_item(menu, "Group 3", ::open_weapons_submenu_3);
        add_menu_item(menu, "Group 4", ::open_weapons_submenu_4);
        add_menu_item(menu, "Group 5", ::open_weapons_submenu_5);
        
        if (!isDefined(self.selecting_match_start_weapon))
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
        if (!isDefined(self.selecting_match_start_weapon))
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
        if (!isDefined(self.selecting_match_start_weapon))
            add_menu_item(menu, "Volver", ::menu_go_back);
            
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        if (!isDefined(self.selecting_match_start_weapon))
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
        if (!isDefined(self.selecting_match_start_weapon))
            add_menu_item(menu, "Volver", ::menu_go_back);
            
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        if (!isDefined(self.selecting_match_start_weapon))
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
        if (!isDefined(self.selecting_match_start_weapon))
            add_menu_item(menu, "Volver", ::menu_go_back);
            
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        if (!isDefined(self.selecting_match_start_weapon))
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
        if (!isDefined(self.selecting_match_start_weapon))
            add_menu_item(menu, "Volver", ::menu_go_back);
            
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        if (!isDefined(self.selecting_match_start_weapon))
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
    
    item.item setTextUnlimited(display_name);
    item.weapon_name = weapon_name;
    item.func = ::give_specific_weapon_menu;
    item.is_menu = false;
    
    return item;
}


give_specific_weapon_menu(weapon_name)
{
    if (!isDefined(weapon_name))
    {
        if (isDefined(self.menu_current) && isDefined(self.menu_current.items[self.menu_current.selected]))
            weapon_name = self.menu_current.items[self.menu_current.selected].weapon_name;
    }
    
    if (isDefined(weapon_name))
    {
        self thread scripts\zm\weapon::GiveSpecificWeapon(weapon_name);
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


open_camo_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "CAMUFLAJES" : "CAMOUFLAGES";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    
    available_camos = scripts\zm\weapon::get_available_camos_for_map();
    
    
    for (i = 0; i < available_camos.size; i++)
    {
        camo_index = available_camos[i];
        camo_name = get_camo_display_name(camo_index, self.langLEN);
        
        
        item = add_menu_item(menu, camo_name, ::apply_camo_menu);
        item.camo_index = camo_index;
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


apply_camo_menu()
{
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[self.menu_current.selected]))
    {
        camo_index = self.menu_current.items[self.menu_current.selected].camo_index;
        if (isDefined(camo_index))
        {
            self thread scripts\zm\weapon::apply_weapon_camo(camo_index);
        }
    }
}


get_camo_display_name(camo_index, lang_index)
{
    switch(camo_index)
    {
        case 39:
            return "OG PAP";
        case 40:
            return "MOB PAP";
        case 41:
            return "Aqua";
        case 42:
            return "Breach";
        case 43:
            if (lang_index == 0)
                return "Coyote";
            else
                return "Coyote";
        case 44:
            return "Glam";
        case 45:
            if (lang_index == 0)
                return "PAP Origins";
            else
                return "Origins PAP";
        default:
            return "Unknown";
    }
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

            
            match_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + recent_files[display_index];
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
                    add_menu_item(menu, "Transacciones Bancarias", ::open_bank_transactions_menu);
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

            
            match_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + recent_files[display_index];
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
                    add_menu_item(menu, "Bank Transactions", ::open_bank_transactions_menu);
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
    
    index_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + map_name + "_index.txt";

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
        full_path = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + filename;

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

        match_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + recent_files[display_index];

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
                    
                    if (isSubStr(line, "Most Used:"))
                        most_used_weapon = trim_string(getSubStr(line, 11));
                    else if (isSubStr(line, "ARMAS USADAS EN LA PARTIDA:"))
                        in_weapons_section = true;
                    else if (isSubStr(line, "PERKS USADOS EN LA PARTIDA:") && in_weapons_section)
                        in_weapons_section = false; 
                    else if (in_weapons_section)
                    {
                        
                        if (isSubStr(line, "|"))
                        {
                            parts = strTok(line, "|");
                            if (parts.size >= 3)
                            {
                                weapon_name = parts[0];
                                kills = parts[1];
                                headshots = parts[2];
                                
                                
                                time_display = "N/A";
                                if (parts.size >= 4)
                                {
                                    time_data = parts[3];
                                    if (time_data != "")
                                    {
                                        kill_events = strTok(time_data, ";");
                                        if (kill_events.size > 0)
                                        {
                                            last_event = kill_events[kill_events.size - 1];
                                            event_parts = strTok(last_event, ",");
                                            if (event_parts.size > 0)
                                            {
                                                
                                                time_display = event_parts[0];
                                            }
                                        }
                                    }
                                }
                                
                                
                                weapon_obj = spawnStruct();
                                weapon_obj.display = weapon_name + " | " + time_display + " | " + kills + " | " + headshots;
                                weapon_obj.name = weapon_name;
                                weapon_obj.kills = kills;
                                weapon_obj.headshots = headshots;
                                weapon_obj.raw_data = (parts.size >= 4) ? parts[3] : "";
                                
                                all_weapons[all_weapons.size] = weapon_obj;
                            }
                        }
                        
                        else if (isSubStr(line, " kills"))
                        {
                            parts = strTok(line, ": ");
                            if (parts.size >= 2)
                            {
                                weapon_name = parts[0];
                                kills_part = strTok(parts[1], " ")[0];
                                
                                
                                weapon_obj = spawnStruct();
                                weapon_obj.display = weapon_name + ": " + kills_part + " kills";
                                weapon_obj.name = weapon_name;
                                weapon_obj.kills = kills_part;
                                weapon_obj.headshots = "0";
                                weapon_obj.raw_data = "";
                                
                                all_weapons[all_weapons.size] = weapon_obj;
                            }
                        }
                        
                        else if (isSubStr(line, "================================"))
                        {
                            break;
                        }
                    } 
                }

                
                if (self.langLEN == 0)
                {
                    add_menu_item(menu, "ARMA MAS USADA", ::do_nothing);
                    add_menu_item(menu, most_used_weapon, ::do_nothing);
                    add_menu_item(menu, "", ::do_nothing);
                    add_menu_item(menu, "ARMA | TIEMPO | KILLS | HS", ::do_nothing);
                }
                else
                {
                    add_menu_item(menu, "MOST USED WEAPON", ::do_nothing);
                    add_menu_item(menu, most_used_weapon, ::do_nothing);
                    add_menu_item(menu, "", ::do_nothing);
                    add_menu_item(menu, "WEAPON | TIME | KILLS | HS", ::do_nothing);
                }

                
                total_weapons = all_weapons.size;
                start_index = current_page * weapons_per_page;
                end_index = min(start_index + weapons_per_page, total_weapons);
                total_pages = int((total_weapons - 1) / weapons_per_page) + 1;

                
                for (i = start_index; i < end_index; i++)
                {
                    
                    if (!isDefined(self.weapon_data_cache))
                        self.weapon_data_cache = [];
                    
                    self.weapon_data_cache[i] = all_weapons[i];
                    
                    
                    params = spawnStruct();
                    params.weapon_index = i;
                    params.filename = match_filename;
                    
                    add_menu_item(menu, all_weapons[i].display, ::open_weapon_detail_view, params);
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



open_weapon_detail_view(params)
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    weapon_index = params.weapon_index;
    
    
    if (!isDefined(self.weapon_data_cache) || !isDefined(self.weapon_data_cache[weapon_index]))
    {
        self iPrintlnBold("^1Error: Weapon data not found");
        return;
    }
    
    weapon_data = self.weapon_data_cache[weapon_index];
    weapon_name = weapon_data.name;
    
    title = weapon_name;
    menu = create_menu(title, self);
    menu.parent_menu = "recent_matches";
    
    
    header_text = weapon_name + " - " + weapon_data.kills + " kills, " + weapon_data.headshots + " HS";
    add_menu_item(menu, header_text, ::do_nothing);
    add_menu_item(menu, "", ::do_nothing);
    
    
    if (weapon_data.raw_data != "")
    {
        kill_events = strTok(weapon_data.raw_data, ";");
        
        if (kill_events.size > 0)
        {
            
            column_header = (self.langLEN == 0) ? "TIEMPO | RONDA | HS" : "TIME | ROUND | HS";
            add_menu_item(menu, column_header, ::do_nothing);
            
            
            if (!isDefined(self.weapon_detail_page_index))
                self.weapon_detail_page_index = 0;
                
            kills_per_page = 5;
            total_kills = kill_events.size;
            current_page = self.weapon_detail_page_index;
            total_pages = int((total_kills - 1) / kills_per_page) + 1;
            
            if (current_page >= total_pages)
            {
                current_page = 0;
                self.weapon_detail_page_index = 0;
            }
            
            start_index = current_page * kills_per_page;
            end_index = min(start_index + kills_per_page, total_kills);
            
            
            for (i = start_index; i < end_index; i++)
            {
                event_parts = strTok(kill_events[i], ",");
                if (event_parts.size >= 3)
                {
                    
                    time_str = event_parts[0];
                    is_headshot = event_parts[1];
                    round_num = event_parts[2];
                    
                    
                    hs_str = (is_headshot == "1") ? "YES" : "NO";
                    
                    
                    kill_line = time_str + " | R" + round_num + " | " + hs_str;
                    add_menu_item(menu, kill_line, ::do_nothing);
                }
            }
            
            
            if (total_pages > 1)
            {
                add_menu_item(menu, "", ::do_nothing);
                
                page_info = (self.langLEN == 0) ? 
                    "Pagina " + (current_page + 1) + "/" + total_pages :
                    "Page " + (current_page + 1) + "/" + total_pages;
                add_menu_item(menu, page_info, ::do_nothing);
                
                if (current_page > 0)
                    add_menu_item(menu, (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS", ::weapon_detail_page_prev);
                    
                if (current_page < total_pages - 1)
                    add_menu_item(menu, (self.langLEN == 0) ? "SIGUIENTE" : "NEXT", ::weapon_detail_page_next);
            }
        }
        else
        {
            add_menu_item(menu, (self.langLEN == 0) ? "SIN DATOS DETALLADOS" : "NO DETAILED DATA", ::do_nothing);
        }
    }
    else
    {
        add_menu_item(menu, (self.langLEN == 0) ? "SIN DATOS DETALLADOS" : "NO DETAILED DATA", ::do_nothing);
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

weapon_detail_page_next()
{
    if (!isDefined(self.weapon_detail_page_index))
        self.weapon_detail_page_index = 0;
    self.weapon_detail_page_index++;
    
    
    self thread menu_go_back();
}

weapon_detail_page_prev()
{
    if (!isDefined(self.weapon_detail_page_index))
        self.weapon_detail_page_index = 0;
    self.weapon_detail_page_index--;
    if (self.weapon_detail_page_index < 0)
        self.weapon_detail_page_index = 0;
    
    
    self thread menu_go_back();
}


stats_cat_page_next()
{
    if (!isDefined(self.stats_cat_page_index))
        self.stats_cat_page_index = 0;
    self.stats_cat_page_index++;
    self thread open_recent_stats_menu();
}

stats_cat_page_prev()
{
    if (!isDefined(self.stats_cat_page_index))
        self.stats_cat_page_index = 0;
    self.stats_cat_page_index--;
    if (self.stats_cat_page_index < 0)
        self.stats_cat_page_index = 0;
    self thread open_recent_stats_menu();
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

        match_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + recent_files[display_index];

        if (fs_testfile(match_filename))
        {
            file = fs_fopen(match_filename, "read");
            if (isDefined(file))
            {
                file_size = fs_length(file);
                content = fs_read(file, file_size);
                fs_fclose(file);

                
                
                
                lines = strTok(content, "\n");
                
                
                round_num = "N/A";
                duration = "N/A";
                
                foreach (line in lines)
                {
                    if (isSubStr(line, "Ronda Alcanzada:")) target_str = "Ronda Alcanzada:";
                    else if (isSubStr(line, "Ronda:")) target_str = "Ronda:";
                    else if (isSubStr(line, "Round:")) target_str = "Round:";
                    else target_str = undefined;
                    
                    if (isDefined(target_str) && isSubStr(line, target_str) && round_num == "N/A")
                        round_num = getSubStr(line, target_str.size + 1);
                        
                    if (isSubStr(line, "Duracion:"))
                        duration = getSubStr(line, 10);
                }
                
                
                header_info = (self.langLEN == 0) ? "Ronda: " + round_num : "Round: " + round_num;
                if (duration != "N/A")
                    header_info += (self.langLEN == 0) ? " | Tiempo: " + duration : " | Time: " + duration;
                    
                add_menu_item(menu, header_info, ::do_nothing);
                add_menu_item(menu, "", ::do_nothing); 

                
                categories_found = [];
                current_cat = "";
                
                foreach (line in lines)
                {
                    line = trim_string(line);
                    
                    if (line.size > 2 && line[0] == "[" && line[line.size-1] == "]")
                    {
                        current_cat = line;
                        categories_found[categories_found.size] = current_cat;
                    }
                }
                
                
                
                all_categories = [];
                foreach (cat in categories_found)
                {
                    all_categories[all_categories.size] = cat;
                }
                
                
                has_weapons = false;
                foreach (line in lines)
                {
                    if (isSubStr(line, "ARMAS USADAS EN LA PARTIDA"))
                    {
                        has_weapons = true;
                        break;
                    }
                }
                
                if (has_weapons)
                {
                    all_categories[all_categories.size] = "ARMAS";
                }
                
                
                if (!isDefined(self.stats_cat_page_index))
                    self.stats_cat_page_index = 0;
                    
                items_per_page = 5; 
                current_page = self.stats_cat_page_index;
                total_items_list = all_categories.size;
                total_pages = int((total_items_list - 1) / items_per_page) + 1;
                
                if (current_page >= total_pages)
                {
                    current_page = 0;
                    self.stats_cat_page_index = 0;
                }
                
                start_index = current_page * items_per_page;
                end_index = min(start_index + items_per_page, total_items_list);
                
                
                for (i = start_index; i < end_index; i++)
                {
                    cat_item = all_categories[i];
                    
                    if (cat_item == "ARMAS")
                    {
                        params = spawnStruct();
                        params.filename = match_filename;
                        params.category = "ARMAS";
                        
                        wep_text = (self.langLEN == 0) ? "Armas Usadas ->" : "Weapons Used ->";
                        add_menu_item(menu, wep_text, ::open_stats_category_view, params);
                    }
                    else
                    {
                        display_name = get_category_display_name(cat_item, self.langLEN);
                        
                        params = spawnStruct();
                        params.filename = match_filename;
                        params.category = cat_item;
                        
                        add_menu_item(menu, display_name + " ->", ::open_stats_category_view, params);
                    }
                }
                
                
                if (total_pages > 1)
                {
                    add_menu_item(menu, "", ::do_nothing);
                    
                    if (current_page > 0)
                    {
                         text_prev = (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS";
                         add_menu_item(menu, text_prev, ::stats_cat_page_prev);
                    }
                    
                    if (current_page < total_pages - 1)
                    {
                         text_next = (self.langLEN == 0) ? "SIGUIENTE" : "NEXT";
                         add_menu_item(menu, text_next, ::stats_cat_page_next);
                    }
                    
                    page_info = (self.langLEN == 0) ? "Pagina " + (current_page + 1) + "/" + total_pages : "Page " + (current_page + 1) + "/" + total_pages;
                    add_menu_item(menu, page_info, ::do_nothing);
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


open_stats_category_view(params)
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    filename = params.filename;
    category = params.category;
    
    title_text = get_category_display_name(category, self.langLEN);
    menu = create_menu(title_text, self);
    menu.parent_menu = "recent_stats_menu"; 
    
    
    if (fs_testfile(filename))
    {
        file = fs_fopen(filename, "read");
        if (isDefined(file))
        {
            file_size = fs_length(file);
            content = fs_read(file, file_size);
            fs_fclose(file);
            
            lines = strTok(content, "\n");
            
            if (category == "ARMAS")
            {
                parse_weapons_category(menu, lines);
            }
            else
            {
                parse_stats_category(menu, lines, category);
            }
        }
    }
    
    add_menu_item(menu, "", ::do_nothing);
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::open_recent_stats_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::open_recent_stats_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    self thread menu_control(menu);
}

parse_stats_category(menu, lines, target_cat)
{
    in_category = false;
    
    
    
    
    foreach (line in lines)
    {
        
        line = trim_string(line);
        
        
        if (line.size > 2 && line[0] == "[" && line[line.size-1] == "]")
        {
            if (line == target_cat)
            {
                in_category = true;
                continue;
            }
            else if (in_category)
            {
                
                break;
            }
        }
        
        if (in_category && isDefined(line) && line != "")
        {
             add_menu_item(menu, line, ::do_nothing);
        }
    }
}


trim_string(str)
{
    if (!isDefined(str) || str == "")
        return "";
        
    
    while (str.size > 0)
    {
        last_char = str[str.size - 1];
        if (last_char == " " || last_char == "\t" || last_char == "\n" || last_char == "\r")
            str = getSubStr(str, 0, str.size - 1);
        else
            break;
    }
    
    
    while (str.size > 0)
    {
        first_char = str[0];
        if (first_char == " " || first_char == "\t" || first_char == "\n" || first_char == "\r")
            str = getSubStr(str, 1);
        else
            break;
    }
    
    return str;
}

parse_weapons_category(menu, lines)
{
    in_weapons = false;
    
    foreach (line in lines)
    {
        line = trim_string(line);
        
        if (isSubStr(line, "ARMAS USADAS EN LA PARTIDA"))
        {
            in_weapons = true;
            continue;
        }
        
        if (!in_weapons) continue;
        
        if (line.size > 2 && line[0] == "[" && line[line.size-1] == "]")
            break;
            
        if (isDefined(line) && line != "")
        {
            
            if (isSubStr(line, "|"))
            {
                parts = strTok(line, "|");
                if (parts.size >= 3)
                {
                    
                    weapon_name = parts[0];
                    kills = parts[1];
                    headshots = parts[2];
                    
                    clean_name = get_base_name(weapon_name);
                    display = clean_name + ": " + kills + " kills (" + headshots + " HS)";
                    add_menu_item(menu, display, ::do_nothing);
                }
            }
            else
            {
                add_menu_item(menu, line, ::do_nothing);
            }
        }
    }
}

get_base_name(weapon_name)
{
    
    
    if (isSubStr(weapon_name, "+"))
        return getSubStr(weapon_name, 0, weapon_name.size - 1); 
        
    return weapon_name;
}

get_category_display_name(category, lang)
{
    display = category;
    
    switch(category)
    {
        case "[GENERAL]": 
            display = (lang == 0) ? "GENERAL" : "GENERAL"; 
            break;
        case "[COMBAT]": 
            display = (lang == 0) ? "COMBATE" : "COMBAT"; 
            break;
        case "[SURVIVAL & ECONOMY]": 
            display = (lang == 0) ? "SUPERVIVENCIA Y ECONOMÍA" : "SURVIVAL & ECONOMY"; 
            break;
        case "[MAGIC BOX & PAP]": 
            display = (lang == 0) ? "CAJA Y MEJORA" : "MAGIC BOX & PAP"; 
            break;
        case "[POWERUPS]": 
            display = (lang == 0) ? "POWERUPS" : "POWERUPS"; 
            break;
        case "[PERKS DRANK COUNTERS]": 
            display = (lang == 0) ? "PERKS BEBIDOS" : "PERKS CONSUMED"; 
            break;
        case "[EQUIPMENT]": 
            display = (lang == 0) ? "EQUIPAMIENTO" : "EQUIPMENT"; 
            break;
        case "[MAP SPECIFIC]": 
            display = (lang == 0) ? "ESPECÍFICO DEL MAPA" : "MAP SPECIFIC"; 
            break;
        case "[PERSISTENT UPGRADES]": 
            display = (lang == 0) ? "MEJORAS PERSISTENTES" : "PERSISTENT UPGRADES"; 
            break;
        case "[CHEAT FLAGS DETECTED]": 
            display = (lang == 0) ? "FLAGS DE CHEATS" : "CHEAT FLAGS"; 
            break;
        case "[MOB OF THE DEAD STATS]": 
            display = (lang == 0) ? "ESTADÍSTICAS MOTD" : "MOTD STATS"; 
            break;
        case "[BURIED STATS]": 
            display = (lang == 0) ? "ESTADÍSTICAS BURIED" : "BURIED STATS"; 
            break;
        case "[ORIGINS STATS]": 
            display = (lang == 0) ? "ESTADÍSTICAS ORIGINS" : "ORIGINS STATS"; 
            break;
        case "[ROUND DURATIONS]": 
            display = (lang == 0) ? "DURACIÓN DE RONDAS" : "ROUND DURATIONS"; 
            break;
        case "ARMAS":
            display = (lang == 0) ? "ARMAS USADAS" : "WEAPONS USED";
            break;
        default:
             display = category;
             break;
    }
    
    if (!isDefined(display))
        display = "Unknown Category";
        
    return display;
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
open_bank_transactions_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "TRANSACCIONES" : "TRANSACTIONS";
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

        match_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + recent_files[display_index];

        if (fs_testfile(match_filename))
        {
            file = fs_fopen(match_filename, "read");
            if (isDefined(file))
            {
                file_size = fs_length(file);
                content = fs_read(file, file_size);
                fs_fclose(file);

                
                lines = strTok(content, "\n");
                all_transactions = [];

                in_transactions_section = false;
                foreach (line in lines)
                {
                    if (isSubStr(line, "TRANSACCIONES BANCARIAS:"))
                        in_transactions_section = true;
                    else if (in_transactions_section && isSubStr(line, "--------------------------------"))
                        continue; 
                    else if (isSubStr(line, "[ROUND DURATIONS]") && in_transactions_section)
                        break; 
                    else if (isSubStr(line, "================================") && in_transactions_section)
                        break; 
                    else if (in_transactions_section && line != "")
                    {
                        all_transactions[all_transactions.size] = line;
                    }
                }

                if (all_transactions.size > 0)
                {
                    
                    
                    
                    transactions_per_page = 6;
                    
                    if (!isDefined(self.transaction_page_index))
                        self.transaction_page_index = 0;

                    
                    if (!isDefined(self.last_recent_match_index_trans) || self.last_recent_match_index_trans != self.recent_match_index)
                    {
                        self.transaction_page_index = 0;
                        self.last_recent_match_index_trans = self.recent_match_index;
                    }

                    total_transactions = all_transactions.size;
                    start_index = self.transaction_page_index * transactions_per_page;
                    end_index = min(start_index + transactions_per_page, total_transactions);
                    total_pages = int((total_transactions - 1) / transactions_per_page) + 1;

                    for (i = start_index; i < end_index; i++)
                    {
                        add_menu_item(menu, all_transactions[i], ::do_nothing);
                    }

                    if (total_pages > 1)
                    {
                        add_menu_item(menu, "", ::do_nothing);
                        
                        page_info = (self.langLEN == 0) ?
                            "Página " + (self.transaction_page_index + 1) + " de " + total_pages :
                            "Page " + (self.transaction_page_index + 1) + " of " + total_pages;
                        add_menu_item(menu, page_info, ::do_nothing);

                        if (self.transaction_page_index > 0)
                            add_menu_item(menu, (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS", ::transaction_page_previous);
                        
                        if (self.transaction_page_index < total_pages - 1)
                            add_menu_item(menu, (self.langLEN == 0) ? "SIGUIENTE" : "NEXT", ::transaction_page_next);
                    }
                }
                else
                {
                    if (self.langLEN == 0)
                    {
                        add_menu_item(menu, "NO HAY TRANSACCIONES", ::do_nothing);
                    }
                    else
                    {
                        add_menu_item(menu, "NO TRANSACTIONS", ::do_nothing);
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

transaction_page_next()
{
    self.transaction_page_index++;
    self thread open_bank_transactions_menu();
    scripts\zm\playsound::play_menu_scroll_sound(self);
}

transaction_page_previous()
{
    self.transaction_page_index--;
    if (self.transaction_page_index < 0)
        self.transaction_page_index = 0;
    self thread open_bank_transactions_menu();
    scripts\zm\playsound::play_menu_scroll_sound(self);
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
        add_menu_item_value(menu, "Balance: ", ::do_nothing, undefined, current_balance);
        add_menu_item_value(menu, "Cantidad: ", ::do_nothing, undefined, self.bank_amount);
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
        add_menu_item_value(menu, "Balance: ", ::do_nothing, undefined, current_balance);
        add_menu_item_value(menu, "Amount: ", ::do_nothing, undefined, self.bank_amount);
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

        
        if (self.menu_current.items.size > 0)
        {
            
            
            label = self.menu_current.items[0].label_text;
            if (isDefined(label))
                self.menu_current.items[0].item setTextUnlimited(label + current_balance);
            else
                self.menu_current.items[0].item setValue(current_balance);
        }

        
        if (self.menu_current.items.size > 1)
        {
            
            label = self.menu_current.items[1].label_text;
            if (isDefined(label))
                self.menu_current.items[1].item setTextUnlimited(label + self.bank_amount);
            else
                self.menu_current.items[1].item setValue(self.bank_amount);
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
    }
    
    menu.items[menu.selected].item.color = (1, 1, 1);

    self thread menu_control(menu);
}









init_teleport_system()
{
    
    loaded_count = scripts\zm\sqllocal::load_teleport_points(self);
    
    
    loaded_categories = scripts\zm\sqllocal::load_teleport_categories(self);
    
    
    if (!isDefined(self.teleport_points))
    {
        self.teleport_points = [];
        self.teleport_names = [];
        self.teleport_count = 0;
    }
    
    if (!isDefined(self.teleport_categories))
    {
        self.teleport_categories = [];
    }
}



create_teleport_point(name, category)
{
    self endon("disconnect");

    
    if (!isDefined(self.teleport_points))
        self thread init_teleport_system();

    
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
    point_data.category = (isDefined(category) ? category : "");

    
    self.teleport_points[self.teleport_count] = point_data;
    self.teleport_names[self.teleport_count] = name;
    self.teleport_count++;

    
    save_success = scripts\zm\sqllocal::save_teleport_point(self, name, point_data.origin, point_data.angles, point_data.category);

    
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

    
    scripts\zm\sqllocal::delete_teleport_point_persistent(self, deleted_name);

    
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

    
    scripts\zm\sqllocal::delete_all_teleport_points_persistent(self);

    
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
        add_menu_item(menu, "Crear Categoría", ::teleport_create_category_prompt);
        add_menu_item(menu, "^5Categorías", ::open_teleport_categories_menu);
        
        add_menu_item(menu, "Listar Puntos Globales", ::teleport_list_points_menu);
        add_menu_item(menu, "Teleportarse a Global", ::teleport_select_point_menu);
        add_menu_item(menu, "Locate zone", ::open_locate_zone_menu);
        add_menu_item(menu, "Eliminar Punto", ::teleport_delete_point_menu);
        add_menu_item(menu, "Eliminar Todos", ::teleport_delete_all_points);
        add_menu_item(menu, "Volver", ::menu_go_back);
    }
    else 
    {
        add_menu_item(menu, "Create Point", ::teleport_create_point_prompt);
        add_menu_item(menu, "Create Category", ::teleport_create_category_prompt);
        add_menu_item(menu, "^5Categories", ::open_teleport_categories_menu);
        
        add_menu_item(menu, "List Global Points", ::teleport_list_points_menu);
        add_menu_item(menu, "Teleport to Global", ::teleport_select_point_menu);
        add_menu_item(menu, "Locate zone", ::open_locate_zone_menu);
        add_menu_item(menu, "Delete Point", ::teleport_delete_point_menu);
        add_menu_item(menu, "Delete All", ::teleport_delete_all_points);
        add_menu_item(menu, "Back", ::menu_go_back);
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


open_teleport_categories_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    
    if (!isDefined(self.tele_cat_page))
        self.tele_cat_page = 0;

    title = ((self.langLEN == 0) ? "CATEGORÍAS" : "CATEGORIES") + " [" + (self.tele_cat_page + 1) + "]";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    if (isDefined(self.teleport_categories) && self.teleport_categories.size > 0)
    {
        items_per_page = 7;
        start_index = self.tele_cat_page * items_per_page;
        end_index = start_index + items_per_page;
        if (end_index > self.teleport_categories.size)
            end_index = self.teleport_categories.size;
            
        total_pages = int((self.teleport_categories.size - 1) / items_per_page) + 1;

        for (i = start_index; i < end_index; i++)
        {
            category = self.teleport_categories[i];
            add_menu_item(menu, "^5[CAT] ^7" + category, ::open_category_submenu, category);
        }

        if (total_pages > 1)
        {
            add_menu_item(menu, "----------------------", ::do_nothing);
            if (self.tele_cat_page > 0)
                add_menu_item(menu, (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS", ::navigate_tele_cat_page, -1);
            if (end_index < self.teleport_categories.size)
                add_menu_item(menu, (self.langLEN == 0) ? "SIGUIENTE" : "NEXT", ::navigate_tele_cat_page, 1);
        }
    }
    else
    {
        if (self.langLEN == 0) add_menu_item(menu, "^1Sin categorías", ::menu_go_back);
        else add_menu_item(menu, "^1No categories", ::menu_go_back);
    }

    add_menu_item(menu, "Volver", ::menu_go_back);
    
    show_menu(menu);
    self thread menu_control(menu);
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

            self.waiting_for_teleport_name = false;
            self notify("teleport_name_received");

            wait 0.5;
            self thread prompt_category_for_point(message);
            return;
        }
    }
}

prompt_category_for_point(point_name)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "¿Asignar Categoría?" : "Assign Category?";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    if (self.langLEN == 0)
    {
        add_menu_item(menu, "No, sin categoría", ::create_teleport_point_with_cat, point_name, "");
        add_menu_item(menu, "Nueva Categoría...", ::teleport_create_cat_for_point_prompt, point_name);
        
        if (isDefined(self.teleport_categories) && self.teleport_categories.size > 0)
        {
            foreach (category in self.teleport_categories)
            {
                add_menu_item(menu, category, ::create_teleport_point_with_cat, point_name, category);
            }
        }
    }
    else
    {
        add_menu_item(menu, "No, no category", ::create_teleport_point_with_cat, point_name, "");
        add_menu_item(menu, "New Category...", ::teleport_create_cat_for_point_prompt, point_name);
        
        if (isDefined(self.teleport_categories) && self.teleport_categories.size > 0)
        {
            foreach (category in self.teleport_categories)
            {
                add_menu_item(menu, category, ::create_teleport_point_with_cat, point_name, category);
            }
        }
    }

    show_menu(menu);
    self thread menu_control(menu);
}

create_teleport_point_with_cat(point_name, category)
{
    self thread create_teleport_point(point_name, category);
    wait 0.5;
    self thread open_teleport_menu();
}

teleport_create_category_prompt()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    self.menu_open = false;

    if (self.langLEN == 0)
        self iPrintLnBold("^5Escribe el nombre de la categoría en el chat (Max 15 char)");
    else
        self iPrintLnBold("^5Type the category name in chat (Max 15 char)");

    self.waiting_for_category_name = true;
    self thread category_chat_watcher();
}

category_chat_watcher()
{
    self endon("disconnect");
    level endon("end_game");
    
    for (;;)
    {
        level waittill("say", message, player);

        if (player == self && isDefined(self.waiting_for_category_name) && self.waiting_for_category_name)
        {
            if (message.size > 15)
                message = getSubStr(message, 0, 15);

            self.waiting_for_category_name = false;
            
            scripts\zm\sqllocal::save_teleport_category(self, message);
            self thread init_teleport_system(); 
            
            if (self.langLEN == 0)
                self iPrintLnBold("^2Categoría creada: ^7" + message);
            else
                self iPrintLnBold("^2Category created: ^7" + message);

            wait 1.0;
            self thread open_teleport_menu();
            return;
        }
    }
}

teleport_create_cat_for_point_prompt(point_name)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    self.menu_open = false;

    if (self.langLEN == 0)
        self iPrintLnBold("^5Escribe el nombre de la NUEVA categoría en el chat");
    else
        self iPrintLnBold("^5Type the NEW category name in chat");

    self.waiting_for_point_cat_name = true;
    self thread category_for_point_chat_watcher(point_name);
}

category_for_point_chat_watcher(point_name)
{
    self endon("disconnect");
    level endon("end_game");
    
    for (;;)
    {
        level waittill("say", message, player);

        if (player == self && isDefined(self.waiting_for_point_cat_name) && self.waiting_for_point_cat_name)
        {
            if (message.size > 15)
                message = getSubStr(message, 0, 15);

            self.waiting_for_point_cat_name = false;
            
            scripts\zm\sqllocal::save_teleport_category(self, message);
            self thread init_teleport_system(); 
            
            wait 0.5;
            self thread create_teleport_point_with_cat(point_name, message);
            return;
        }
    }
}


teleport_list_points_menu()
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

    
    if (!isDefined(self.tele_list_page))
        self.tele_list_page = 0;

    title = ((self.langLEN == 0) ? "LISTA DE PUNTOS" : "POINTS LIST") + " [" + (self.tele_list_page + 1) + "]";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    items_per_page = 7;
    start_index = self.tele_list_page * items_per_page;
    end_index = start_index + items_per_page;
    if (end_index > self.teleport_count)
        end_index = self.teleport_count;
        
    total_pages = int((self.teleport_count - 1) / items_per_page) + 1;

    for (i = start_index; i < end_index; i++)
    {
        add_menu_item(menu, (i+1) + ". " + self.teleport_names[i], ::do_nothing);
    }

    if (total_pages > 1)
    {
        add_menu_item(menu, "----------------------", ::do_nothing);
        if (self.tele_list_page > 0)
            add_menu_item(menu, (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS", ::navigate_tele_list_page, -1);
        if (end_index < self.teleport_count)
            add_menu_item(menu, (self.langLEN == 0) ? "SIGUIENTE" : "NEXT", ::navigate_tele_list_page, 1);
    }

    if (self.langLEN == 0)
        add_menu_item(menu, "Volver", ::menu_go_back);
    else
        add_menu_item(menu, "Back", ::menu_go_back);

    show_menu(menu);
    self thread menu_control(menu);
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

    
    if (!isDefined(self.tele_global_page))
        self.tele_global_page = 0;

    title = ((self.langLEN == 0) ? "SELECCIONAR PUNTO" : "SELECT POINT") + " [" + (self.tele_global_page + 1) + "]";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    if (isDefined(self.teleport_points) && self.teleport_count > 0)
    {
        items_per_page = 7;
        start_index = self.tele_global_page * items_per_page;
        end_index = start_index + items_per_page;
        if (end_index > self.teleport_count)
            end_index = self.teleport_count;
            
        total_pages = int((self.teleport_count - 1) / items_per_page) + 1;

        for (i = start_index; i < end_index; i++)
        {
            item = add_menu_item(menu, (i+1) + ". " + self.teleport_names[i], ::teleport_to_selected_point);
            item.teleport_index = i;
        }

        if (total_pages > 1)
        {
            add_menu_item(menu, "----------------------", ::do_nothing);
            if (self.tele_global_page > 0)
                add_menu_item(menu, (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS", ::navigate_tele_global_page, -1);
            if (end_index < self.teleport_count)
                add_menu_item(menu, (self.langLEN == 0) ? "SIGUIENTE" : "NEXT", ::navigate_tele_global_page, 1);
        }
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


teleport_to_selected_point()
{
    self endon("disconnect");
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items))
    {
        selected_item = self.menu_current.items[self.menu_current.selected];
        
        
        if (isDefined(selected_item.teleport_index))
        {
            index = selected_item.teleport_index;
            self teleport_to_point(index);
            wait 1.0;
            self thread open_teleport_menu();
        }
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

    
    if (!isDefined(self.tele_del_page))
        self.tele_del_page = 0;

    title = ((self.langLEN == 0) ? "ELIMINAR PUNTO" : "DELETE POINT") + " [" + (self.tele_del_page + 1) + "]";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    if (isDefined(self.teleport_points) && self.teleport_count > 0)
    {
        items_per_page = 7;
        start_index = self.tele_del_page * items_per_page;
        end_index = start_index + items_per_page;
        if (end_index > self.teleport_count)
            end_index = self.teleport_count;
            
        total_pages = int((self.teleport_count - 1) / items_per_page) + 1;

        for (i = start_index; i < end_index; i++)
        {
            item = add_menu_item(menu, (i+1) + ". " + self.teleport_names[i], ::delete_selected_point);
            item.teleport_index = i;
        }

        if (total_pages > 1)
        {
            add_menu_item(menu, "----------------------", ::do_nothing);
            if (self.tele_del_page > 0)
                add_menu_item(menu, (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS", ::navigate_tele_del_page, -1);
            if (end_index < self.teleport_count)
                add_menu_item(menu, (self.langLEN == 0) ? "SIGUIENTE" : "NEXT", ::navigate_tele_del_page, 1);
        }
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


delete_selected_point()
{
    self endon("disconnect");
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items))
    {
        selected_item = self.menu_current.items[self.menu_current.selected];
        
        
        if (isDefined(selected_item.teleport_index))
        {
            index = selected_item.teleport_index;
            self delete_teleport_point(index);
            wait 1.0;
            self thread open_teleport_menu();
        }
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

    
    
    
    for (;;)
    {
        wait 999;
    }
}

open_menu_dimensions_settings()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "DIMENSIONES DEL MENÚ" : "MENU DIMENSIONS";
    menu = create_menu(title, self);
    menu.parent_menu = "settings";

    
    if (!isDefined(self.custom_menu_width))
        self.custom_menu_width = 175;

    if (!isDefined(self.custom_menu_margin_x))
        self.custom_menu_margin_x = 0;

    if (!isDefined(self.custom_menu_margin_y))
        self.custom_menu_margin_y = 40;

    if (!isDefined(self.custom_menu_item_height))
        self.custom_menu_item_height = 18;

    if (!isDefined(self.custom_menu_header_height))
        self.custom_menu_header_height = 24;

    if (self.langLEN == 0)
    {
        
        add_menu_item(menu, "Ancho [+]: " + self.custom_menu_width, ::increase_menu_width);
        add_menu_item(menu, "Ancho [-]: " + self.custom_menu_width, ::decrease_menu_width);

        
        add_menu_item(menu, "Margen X [+]: " + self.custom_menu_margin_x, ::increase_menu_margin_x);
        add_menu_item(menu, "Margen X [-]: " + self.custom_menu_margin_x, ::decrease_menu_margin_x);

        
        add_menu_item(menu, "Margen Y [+]: " + self.custom_menu_margin_y, ::increase_menu_margin_y);
        add_menu_item(menu, "Margen Y [-]: " + self.custom_menu_margin_y, ::decrease_menu_margin_y);

        
        add_menu_item(menu, "Altura Item [+]: " + self.custom_menu_item_height, ::increase_menu_item_height);
        add_menu_item(menu, "Altura Item [-]: " + self.custom_menu_item_height, ::decrease_menu_item_height);

        
        add_menu_item(menu, "Altura Header [+]: " + self.custom_menu_header_height, ::increase_menu_header_height);
        add_menu_item(menu, "Altura Header [-]: " + self.custom_menu_header_height, ::decrease_menu_header_height);

        add_menu_item(menu, "Restaurar Predeterminados", ::reset_menu_dimensions);
        add_menu_item(menu, "Volver", ::open_settings_menu);
    }
    else
    {
        
        add_menu_item(menu, "Width [+]: " + self.custom_menu_width, ::increase_menu_width);
        add_menu_item(menu, "Width [-]: " + self.custom_menu_width, ::decrease_menu_width);

        
        add_menu_item(menu, "Margin X [+]: " + self.custom_menu_margin_x, ::increase_menu_margin_x);
        add_menu_item(menu, "Margin X [-]: " + self.custom_menu_margin_x, ::decrease_menu_margin_x);

        
        add_menu_item(menu, "Margin Y [+]: " + self.custom_menu_margin_y, ::increase_menu_margin_y);
        add_menu_item(menu, "Margin Y [-]: " + self.custom_menu_margin_y, ::decrease_menu_margin_y);

        
        add_menu_item(menu, "Item Height [+]: " + self.custom_menu_item_height, ::increase_menu_item_height);
        add_menu_item(menu, "Item Height [-]: " + self.custom_menu_item_height, ::decrease_menu_item_height);

        
        add_menu_item(menu, "Header Height [+]: " + self.custom_menu_header_height, ::increase_menu_header_height);
        add_menu_item(menu, "Header Height [-]: " + self.custom_menu_header_height, ::decrease_menu_header_height);

        add_menu_item(menu, "Reset to Default", ::reset_menu_dimensions);
        add_menu_item(menu, "Back", ::open_settings_menu);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    
    menu = scripts\zm\style_menu::apply_custom_dimensions(menu);

    
    menu = scripts\zm\style_shaders_menu::apply_menu_shaders(menu);

    
    if (isDefined(self.transparency_index))
    {
        menu = scripts\zm\style_transparecy::apply_transparency(menu, self.transparency_index);
    }

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);


}

increase_menu_width()
{
    current_width = self.custom_menu_width;
    new_width = current_width + 25;

    if (new_width > 350)
        new_width = 350;

    scripts\zm\style_menu::set_custom_menu_width(self, new_width);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.width = new_width;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

decrease_menu_width()
{
    current_width = self.custom_menu_width;
    new_width = current_width - 25;

    if (new_width < 100)
        new_width = 100;

    scripts\zm\style_menu::set_custom_menu_width(self, new_width);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.width = new_width;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

increase_menu_margin_x()
{
    current_margin = self.custom_menu_margin_x;
    new_margin = current_margin + 20;

    if (new_margin > 600)
        new_margin = 600;

    scripts\zm\style_menu::set_custom_menu_margin_x(self, new_margin);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.margin_x = new_margin;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

decrease_menu_margin_x()
{
    current_margin = self.custom_menu_margin_x;
    new_margin = current_margin - 20;

    if (new_margin < 0)
        new_margin = 0;

    scripts\zm\style_menu::set_custom_menu_margin_x(self, new_margin);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.margin_x = new_margin;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

increase_menu_margin_y()
{
    current_margin = self.custom_menu_margin_y;
    new_margin = current_margin + 20;

    if (new_margin > 200)
        new_margin = 200;

    scripts\zm\style_menu::set_custom_menu_margin_y(self, new_margin);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.margin_y = new_margin;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

decrease_menu_margin_y()
{
    current_margin = self.custom_menu_margin_y;
    new_margin = current_margin - 20;

    if (new_margin < 0)
        new_margin = 0;

    scripts\zm\style_menu::set_custom_menu_margin_y(self, new_margin);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.margin_y = new_margin;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

increase_menu_item_height()
{
    current_height = self.custom_menu_item_height;
    new_height = current_height + 2;

    if (new_height > 28)
        new_height = 28;

    scripts\zm\style_menu::set_custom_menu_item_height(self, new_height);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.item_height = new_height;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

decrease_menu_item_height()
{
    current_height = self.custom_menu_item_height;
    new_height = current_height - 2;

    if (new_height < 10)
        new_height = 10;

    scripts\zm\style_menu::set_custom_menu_item_height(self, new_height);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.item_height = new_height;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

increase_menu_header_height()
{
    current_height = self.custom_menu_header_height;
    new_height = current_height + 2;

    if (new_height > 50)
        new_height = 50;

    scripts\zm\style_menu::set_custom_menu_header_height(self, new_height);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.header_height = new_height;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

decrease_menu_header_height()
{
    current_height = self.custom_menu_header_height;
    new_height = current_height - 2;

    if (new_height < 15)
        new_height = 15;

    scripts\zm\style_menu::set_custom_menu_header_height(self, new_height);
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.header_height = new_height;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}

update_selector_position_after_dimension_change(menu)
{
    if (!isDefined(menu) || !isDefined(menu.selection_bar))
        return;

    
    menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);

    
    if (isDefined(menu.selector_style_index) && menu.selector_style_index > 0)
    {
        scripts\zm\style_selector::update_selector_position(menu);
        scripts\zm\style_selector::update_selector_visuals(menu);
    }
}

update_dimensions_menu_display()
{
    if (!isDefined(self.menu_current))
        return;

    
    menu = self.menu_current;

    if (self.langLEN == 0)
    {
        
        if (isDefined(menu.items[0]) && isDefined(menu.items[0].item))
            menu.items[0].item setTextUnlimited("Ancho [+]: " + self.custom_menu_width);
        if (isDefined(menu.items[1]) && isDefined(menu.items[1].item))
            menu.items[1].item setTextUnlimited("Ancho [-]: " + self.custom_menu_width);

        if (isDefined(menu.items[2]) && isDefined(menu.items[2].item))
            menu.items[2].item setTextUnlimited("Margen X [+]: " + self.custom_menu_margin_x);
        if (isDefined(menu.items[3]) && isDefined(menu.items[3].item))
            menu.items[3].item setTextUnlimited("Margen X [-]: " + self.custom_menu_margin_x);

        if (isDefined(menu.items[4]) && isDefined(menu.items[4].item))
            menu.items[4].item setTextUnlimited("Margen Y [+]: " + self.custom_menu_margin_y);
        if (isDefined(menu.items[5]) && isDefined(menu.items[5].item))
            menu.items[5].item setTextUnlimited("Margen Y [-]: " + self.custom_menu_margin_y);

        if (isDefined(menu.items[6]) && isDefined(menu.items[6].item))
            menu.items[6].item setTextUnlimited("Altura Item [+]: " + self.custom_menu_item_height);
        if (isDefined(menu.items[7]) && isDefined(menu.items[7].item))
            menu.items[7].item setTextUnlimited("Altura Item [-]: " + self.custom_menu_item_height);

        if (isDefined(menu.items[8]) && isDefined(menu.items[8].item))
            menu.items[8].item setTextUnlimited("Altura Header [+]: " + self.custom_menu_header_height);
        if (isDefined(menu.items[9]) && isDefined(menu.items[9].item))
            menu.items[9].item setTextUnlimited("Altura Header [-]: " + self.custom_menu_header_height);
    }
    else
    {
        
        if (isDefined(menu.items[0]) && isDefined(menu.items[0].item))
            menu.items[0].item setTextUnlimited("Width [+]: " + self.custom_menu_width);
        if (isDefined(menu.items[1]) && isDefined(menu.items[1].item))
            menu.items[1].item setTextUnlimited("Width [-]: " + self.custom_menu_width);

        if (isDefined(menu.items[2]) && isDefined(menu.items[2].item))
            menu.items[2].item setTextUnlimited("Margin X [+]: " + self.custom_menu_margin_x);
        if (isDefined(menu.items[3]) && isDefined(menu.items[3].item))
            menu.items[3].item setTextUnlimited("Margin X [-]: " + self.custom_menu_margin_x);

        if (isDefined(menu.items[4]) && isDefined(menu.items[4].item))
            menu.items[4].item setTextUnlimited("Margin Y [+]: " + self.custom_menu_margin_y);
        if (isDefined(menu.items[5]) && isDefined(menu.items[5].item))
            menu.items[5].item setTextUnlimited("Margin Y [-]: " + self.custom_menu_margin_y);

        if (isDefined(menu.items[6]) && isDefined(menu.items[6].item))
            menu.items[6].item setTextUnlimited("Item Height [+]: " + self.custom_menu_item_height);
        if (isDefined(menu.items[7]) && isDefined(menu.items[7].item))
            menu.items[7].item setTextUnlimited("Item Height [-]: " + self.custom_menu_item_height);

        if (isDefined(menu.items[8]) && isDefined(menu.items[8].item))
            menu.items[8].item setTextUnlimited("Header Height [+]: " + self.custom_menu_header_height);
        if (isDefined(menu.items[9]) && isDefined(menu.items[9].item))
            menu.items[9].item setTextUnlimited("Header Height [-]: " + self.custom_menu_header_height);
    }
}

reset_menu_dimensions()
{
    scripts\zm\style_menu::reset_custom_dimensions(self);
    self iPrintln((self.langLEN == 0) ? "^2Dimensiones restauradas a valores predeterminados" : "^2Dimensions reset to default values");
    update_dimensions_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current.width = 175;
        self.menu_current.margin_x = 263;
        self.menu_current.margin_y = 180;
        self.menu_current.item_height = 18;
        self.menu_current.header_height = 22;
        scripts\zm\style_menu::apply_custom_dimensions(self.menu_current);

        
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);

        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }

        
        if (isDefined(self.edge_animation_style_index) && self.edge_animation_style_index > 0)
        {
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
        }

        update_selector_position_after_dimension_change(self.menu_current);
    }
}





open_menu_shaders_settings()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "SHADERS DEL MENÚ" : "MENU SHADERS";
    menu = create_menu(title, self);
    menu.parent_menu = "settings";

    
    if (!isDefined(self.background_shader_index))
        self.background_shader_index = -1;
    if (!isDefined(self.header_shader_index))
        self.header_shader_index = -1;
    if (!isDefined(self.selection_shader_index))
        self.selection_shader_index = -1;

    if (self.langLEN == 0)
    {
        
        bg_name = scripts\zm\style_shaders_menu::get_background_shader_display_name(self.background_shader_index, 0);
        add_menu_item(menu, "Shader Fondo: " + bg_name, ::cycle_background_shader_menu);

        header_name = scripts\zm\style_shaders_menu::get_header_shader_display_name(self.header_shader_index, 0);
        add_menu_item(menu, "Shader Header: " + header_name, ::cycle_header_shader_menu);

        selection_name = scripts\zm\style_shaders_menu::get_selector_shader_display_name(self.selection_shader_index, 0);
        add_menu_item(menu, "Shader Selector: " + selection_name, ::cycle_selection_shader_menu);

        add_menu_item(menu, "Restaurar Predeterminados", ::reset_menu_shaders);
        add_menu_item(menu, "Volver", ::open_settings_menu);
    }
    else
    {
        
        bg_name = scripts\zm\style_shaders_menu::get_background_shader_display_name(self.background_shader_index, 1);
        add_menu_item(menu, "Background Shader: " + bg_name, ::cycle_background_shader_menu);

        header_name = scripts\zm\style_shaders_menu::get_header_shader_display_name(self.header_shader_index, 1);
        add_menu_item(menu, "Header Shader: " + header_name, ::cycle_header_shader_menu);

        selection_name = scripts\zm\style_shaders_menu::get_selector_shader_display_name(self.selection_shader_index, 1);
        add_menu_item(menu, "Selector Shader: " + selection_name, ::cycle_selection_shader_menu);

        add_menu_item(menu, "Reset to Default", ::reset_menu_shaders);
        add_menu_item(menu, "Back", ::open_settings_menu);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    
    menu = scripts\zm\style_menu::apply_custom_dimensions(menu);

    
    if (isDefined(self.transparency_index))
    {
        menu = scripts\zm\style_transparecy::apply_transparency(menu, self.transparency_index);
    }

    
    menu = scripts\zm\style_shaders_menu::apply_menu_shaders(menu);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

cycle_background_shader_menu()
{
    scripts\zm\style_shaders_menu::cycle_background_shader(self);
    update_shaders_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);
        
        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }
    }
}

cycle_header_shader_menu()
{
    scripts\zm\style_shaders_menu::cycle_header_shader(self);
    update_shaders_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);
        
        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }
    }
}

cycle_selection_shader_menu()
{
    scripts\zm\style_shaders_menu::cycle_selection_shader(self);
    update_shaders_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);
        
        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }
    }
}

update_shaders_menu_display()
{
    if (!isDefined(self.menu_current))
        return;

    menu = self.menu_current;

    if (self.langLEN == 0)
    {
        
        if (isDefined(menu.items[0]) && isDefined(menu.items[0].item))
        {
            bg_name = scripts\zm\style_shaders_menu::get_background_shader_display_name(self.background_shader_index, 0);
            menu.items[0].item setTextUnlimited("Shader Fondo: " + bg_name);
        }

        if (isDefined(menu.items[1]) && isDefined(menu.items[1].item))
        {
            header_name = scripts\zm\style_shaders_menu::get_header_shader_display_name(self.header_shader_index, 0);
            menu.items[1].item setTextUnlimited("Shader Header: " + header_name);
        }

        if (isDefined(menu.items[2]) && isDefined(menu.items[2].item))
        {
            selection_name = scripts\zm\style_shaders_menu::get_selector_shader_display_name(self.selection_shader_index, 0);
            menu.items[2].item setTextUnlimited("Shader Selector: " + selection_name);
        }
    }
    else
    {
        
        if (isDefined(menu.items[0]) && isDefined(menu.items[0].item))
        {
            bg_name = scripts\zm\style_shaders_menu::get_background_shader_display_name(self.background_shader_index, 1);
            menu.items[0].item setTextUnlimited("Background Shader: " + bg_name);
        }

        if (isDefined(menu.items[1]) && isDefined(menu.items[1].item))
        {
            header_name = scripts\zm\style_shaders_menu::get_header_shader_display_name(self.header_shader_index, 1);
            menu.items[1].item setTextUnlimited("Header Shader: " + header_name);
        }

        if (isDefined(menu.items[2]) && isDefined(menu.items[2].item))
        {
            selection_name = scripts\zm\style_shaders_menu::get_selector_shader_display_name(self.selection_shader_index, 1);
            menu.items[2].item setTextUnlimited("Selector Shader: " + selection_name);
        }
    }
}

reset_menu_shaders()
{
    scripts\zm\style_shaders_menu::reset_all_shaders(self);
    self iPrintln((self.langLEN == 0) ? "^2Shaders restaurados a valores predeterminados" : "^2Shaders reset to default values");
    update_shaders_menu_display();

    
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_shaders_menu::apply_menu_shaders(self.menu_current);
        
        
        if (isDefined(self.transparency_index))
        {
            self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
        }
    }
}



init_strings()
{
    level.strings = [];
    
    
    level.strings["status_on_es"] = "Estado: ON";
    level.strings["status_off_es"] = "Estado: OFF";
    level.strings["status_on_en"] = "Status: ON";
    level.strings["status_off_en"] = "Status: OFF";
    
    
    level.strings["fog_on_es"] = "Niebla: ON";
    level.strings["fog_off_es"] = "Niebla: OFF";
    level.strings["fog_on_en"] = "Fog: ON";
    level.strings["fog_off_en"] = "Fog: OFF";
    
    
    level.strings["tpp_on_es"] = "Tercera Persona: ON";
    level.strings["tpp_off_es"] = "Tercera Persona: OFF";
    level.strings["tpp_on_en"] = "Third Person: ON";
    level.strings["tpp_off_en"] = "Third Person: OFF";
    
    
    level.strings["perk_on_es"] = "Perk Unlimited: ON";
    level.strings["perk_off_es"] = "Perk Unlimited: OFF";
    level.strings["perk_on_en"] = "Perk Unlimited: ON";
    level.strings["perk_off_en"] = "Perk Unlimited: OFF";
    
    
    level.strings["zname_on_es"] = "Mostrar Nombre: ON";
    level.strings["zname_off_es"] = "Mostrar Nombre: OFF";
    level.strings["zname_on_en"] = "Show Name: ON";
    level.strings["zname_off_en"] = "Show Name: OFF";
}





open_locate_zone_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    map_raw = getDvar("mapname");
    map_name = tolower(map_raw);
    
    
    if (!isDefined(self.tele_zone_page))
        self.tele_zone_page = 0;

    title = ((self.langLEN == 0) ? "LOCATE ZONE" : "LOCATE ZONE") + " [" + (self.tele_zone_page + 1) + "]";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    
    zones = get_map_zones(map_name);
    
    if (zones.size > 0)
    {
        items_per_page = 7;
        start_index = self.tele_zone_page * items_per_page;
        end_index = start_index + items_per_page;
        if (end_index > zones.size)
            end_index = zones.size;
            
        total_pages = int((zones.size - 1) / items_per_page) + 1;

        for (i = start_index; i < end_index; i++)
        {
            add_menu_item(menu, zones[i].name, ::locate_zone_teleport).zone_origin = zones[i].origin;
        }

        if (total_pages > 1)
        {
            add_menu_item(menu, "----------------------", ::do_nothing);
            if (self.tele_zone_page > 0)
                add_menu_item(menu, (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS", ::navigate_locate_zone_page, -1);
            if (end_index < zones.size)
                add_menu_item(menu, (self.langLEN == 0) ? "SIGUIENTE" : "NEXT", ::navigate_locate_zone_page, 1);
        }
    }
    else
    {
        if (self.langLEN == 0) add_menu_item(menu, "^1No hay ubicaciones", ::menu_go_back);
        else add_menu_item(menu, "^1No locations available", ::menu_go_back);
    }

    add_menu_item(menu, "Volver", ::menu_go_back);
    add_menu_item(menu, "Cerrar Menú", ::close_all_menus);

    show_menu(menu);
    self thread menu_control(menu);
}

locate_zone_teleport()
{
    self endon("disconnect");
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items))
    {
        selected_item = self.menu_current.items[self.menu_current.selected];
        if (isDefined(selected_item.zone_origin))
        {
            self setOrigin(selected_item.zone_origin);
            if (self.langLEN == 0) self iPrintLnBold("^2Teleportado a zona");
            else self iPrintLnBold("^2Teleported to zone");
            self playLocalSound("uin_positive_feedback");
            wait 0.2;
        }
    }
}





open_category_submenu(category)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    
    if (!isDefined(self.tele_cat_sub_page))
        self.tele_cat_sub_page = 0;

    
    cat_points = [];
    cat_point_indices = [];
    for (i = 0; i < self.teleport_count; i++)
    {
        if (isDefined(self.teleport_points[i].category) && self.teleport_points[i].category == category)
        {
            cat_points[cat_points.size] = self.teleport_names[i];
            cat_point_indices[cat_point_indices.size] = i;
        }
    }

    title = "^5" + category + " [" + (self.tele_cat_sub_page + 1) + "]";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport_categories";

    if (cat_points.size > 0)
    {
        items_per_page = 7;
        start_index = self.tele_cat_sub_page * items_per_page;
        end_index = start_index + items_per_page;
        if (end_index > cat_points.size)
            end_index = cat_points.size;
            
        total_pages = int((cat_points.size - 1) / items_per_page) + 1;

        for (i = start_index; i < end_index; i++)
        {
            add_menu_item(menu, cat_points[i], ::category_teleport_handler, cat_point_indices[i], category);
        }

        if (total_pages > 1)
        {
            add_menu_item(menu, "----------------------", ::do_nothing);
            if (self.tele_cat_sub_page > 0)
                add_menu_item(menu, (self.langLEN == 0) ? "ANTERIOR" : "PREVIOUS", ::navigate_tele_cat_sub_page, -1, category);
            if (end_index < cat_points.size)
                add_menu_item(menu, (self.langLEN == 0) ? "SIGUIENTE" : "NEXT", ::navigate_tele_cat_sub_page, 1, category);
        }
    }
    else
    {
        if (self.langLEN == 0) add_menu_item(menu, "^1Sin puntos en esta categoría", ::menu_go_back);
        else add_menu_item(menu, "^1No points in this category", ::menu_go_back);
    }

    add_menu_item(menu, "----------------------", ::menu_go_back);
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Agregar punto existente", ::menu_add_existing_to_category, category);
        add_menu_item(menu, "Eliminar punto de categoría", ::menu_remove_from_category, category);
        add_menu_item(menu, "^1Eliminar Categoría", ::menu_delete_category, category);
        add_menu_item(menu, "Volver", ::open_teleport_menu);
    }
    else
    {
        add_menu_item(menu, "Add existing point", ::menu_add_existing_to_category, category);
        add_menu_item(menu, "Remove point from category", ::menu_remove_from_category, category);
        add_menu_item(menu, "^1Delete Category", ::menu_delete_category, category);
        add_menu_item(menu, "Back", ::open_teleport_menu);
    }

    show_menu(menu);
    self thread menu_control(menu);
}

category_teleport_handler(index, category)
{
    self thread teleport_to_point_index(index);
    wait 0.2;
    self thread open_category_submenu(category);
}

menu_add_existing_to_category(category)
{
    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "Agregar a " + category : "Add to " + category;
    menu = create_menu(title, self);
    menu.parent_menu = "category_" + category;

    found = false;
    for (i = 0; i < self.teleport_count; i++)
    {
        point = self.teleport_points[i];
        if (!isDefined(point.category) || point.category == "")
        {
            add_menu_item(menu, self.teleport_names[i], ::action_add_point_to_category, i, category);
            found = true;
        }
    }

    if (!found)
    {
        if (self.langLEN == 0) add_menu_item(menu, "^1No hay puntos globales", ::menu_go_back);
        else add_menu_item(menu, "^1No global points available", ::menu_go_back);
    }
    
    add_menu_item(menu, "Volver", ::open_category_submenu, category);

    show_menu(menu);
    self thread menu_control(menu);
}

action_add_point_to_category(index, category)
{
    point_name = self.teleport_names[index];
    scripts\zm\sqllocal::update_point_category_persistent(self, point_name, category);
    self.teleport_points[index].category = category;
    
    if (self.langLEN == 0) self iPrintLnBold("^2Punto agregado a " + category);
    else self iPrintLnBold("^2Point added to " + category);
    
    wait 0.2;
    self thread menu_add_existing_to_category(category);
}

menu_remove_from_category(category)
{
    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "Quitar de " + category : "Remove from " + category;
    menu = create_menu(title, self);
    menu.parent_menu = "category_" + category;

    found = false;
    for (i = 0; i < self.teleport_count; i++)
    {
        point = self.teleport_points[i];
        if (isDefined(point.category) && point.category == category)
        {
            add_menu_item(menu, self.teleport_names[i], ::action_remove_point_from_category, i, category);
            found = true;
        }
    }

    add_menu_item(menu, "Volver", ::open_category_submenu, category);

    show_menu(menu);
    self thread menu_control(menu);
}

action_remove_point_from_category(index, category)
{
    point_name = self.teleport_names[index];
    scripts\zm\sqllocal::update_point_category_persistent(self, point_name, "");
    self.teleport_points[index].category = "";
    
    if (self.langLEN == 0) self iPrintLnBold("^1Punto removido de " + category);
    else self iPrintLnBold("^1Point removed from " + category);
    
    wait 0.2;
    self thread menu_remove_from_category(category);
}

menu_delete_category(category)
{
    scripts\zm\sqllocal::delete_teleport_category_persistent(self, category);
    
    
    for (i = 0; i < self.teleport_count; i++)
    {
        if (isDefined(self.teleport_points[i].category) && self.teleport_points[i].category == category)
            self.teleport_points[i].category = "";
    }
    
    
    self.teleport_categories = scripts\zm\sqllocal::load_teleport_categories(self);
    
    if (self.langLEN == 0) self iPrintLnBold("^1Categoría eliminada");
    else self iPrintLnBold("^1Category deleted");
    
    wait 0.2;
    self thread open_teleport_menu();
}


teleport_to_point_index(index)
{
    self endon("disconnect");
    
    if (!isDefined(self.teleport_points) || !isDefined(self.teleport_points[index]))
        return;
        
    point = self.teleport_points[index];
    name = self.teleport_names[index];
    
    self setOrigin(point.origin);
    self setPlayerAngles(point.angles);
    
    if (self.langLEN == 0)
        self iPrintLnBold("^2Teleportado a: ^5" + name);
    else
        self iPrintLnBold("^2Teleported to: ^5" + name);
        
    self playLocalSound("uin_positive_feedback");
}

get_map_zones(map_name)
{
    zones = [];
    switch(map_name)
    {
        case "zm_transit":
        case "transit":
            zones[0] = spawnStruct(); zones[0].name = "Bus Depot"; zones[0].origin = (-7108, 4680, -65);
            zones[1] = spawnStruct(); zones[1].name = "Bus Depot Prison"; zones[1].origin = (-6165, 3893, 119);
            zones[2] = spawnStruct(); zones[2].name = "Tunnel"; zones[2].origin = (-11475, -2321, 200);
            zones[3] = spawnStruct(); zones[3].name = "Dinner"; zones[3].origin = (-5010, -7189, -57);
            zones[4] = spawnStruct(); zones[4].name = "Farm"; zones[4].origin = (6987, -5692, -50);
            zones[5] = spawnStruct(); zones[5].name = "Nach der Toten"; zones[5].origin = (13781, -1013, -185);
            zones[6] = spawnStruct(); zones[6].name = "Pylon"; zones[6].origin = (7480, -474, -190);
            zones[7] = spawnStruct(); zones[7].name = "Engine"; zones[7].origin = (11129, 7896, -570);
            zones[8] = spawnStruct(); zones[8].name = "Forest House"; zones[8].origin = (5138, 6892, -23);
            zones[9] = spawnStruct(); zones[9].name = "Town"; zones[9].origin = (1241, -120, -50);
            zones[10] = spawnStruct(); zones[10].name = "Town Ninepins"; zones[10].origin = (2237, -1404, -49);
            zones[11] = spawnStruct(); zones[11].name = "Town Apartment"; zones[11].origin = (2329, 238, 88.125);
            zones[12] = spawnStruct(); zones[12].name = "Packer Punch"; zones[12].origin = (1946, -183, -303);
            break;

        case "zm_prison":
        case "prison":
            zones[0] = spawnStruct(); zones[0].name = "Start Room"; zones[0].origin = (1226, 10597, 1336);
            zones[1] = spawnStruct(); zones[1].name = "Start Room Prison"; zones[1].origin = (1711, 10323, 1336);
            zones[2] = spawnStruct(); zones[2].name = "Prison Roof"; zones[2].origin = (952, 9414, 1704);
            zones[3] = spawnStruct(); zones[3].name = "Prison Spiral Staircase"; zones[3].origin = (-21, 7879, -127);
            zones[4] = spawnStruct(); zones[4].name = "Spiral Staircase Center"; zones[4].origin = (414, 8436, 832);
            zones[5] = spawnStruct(); zones[5].name = "Harbor"; zones[5].origin = (-425, 5418, -71);
            zones[6] = spawnStruct(); zones[6].name = "Harbor Tower"; zones[6].origin = (-39, 5572, 593);
            zones[7] = spawnStruct(); zones[7].name = "Bars on the Harbor"; zones[7].origin = (-678, 6983, 240);
            zones[8] = spawnStruct(); zones[8].name = "Dog Point 1"; zones[8].origin = (826.87, 9672.88, 1443.13);
            zones[9] = spawnStruct(); zones[9].name = "Dog Point 2"; zones[9].origin = (3731.16, 9705.97, 1532.84);
            zones[10] = spawnStruct(); zones[10].name = "Dog Point 3"; zones[10].origin = (49.1354, 6093.95, 19.5609);
            break;

        case "zm_nuked":
        case "nuketown":
        case "nuked":
            zones[0] = spawnStruct(); zones[0].name = "Bus"; zones[0].origin = (-125, 350, -49);
            zones[1] = spawnStruct(); zones[1].name = "Green House"; zones[1].origin = (-623, 417, -56);
            zones[2] = spawnStruct(); zones[2].name = "Green House Office"; zones[2].origin = (-623, 417, 80);
            zones[3] = spawnStruct(); zones[3].name = "Green House Prison"; zones[3].origin = (-800, 850, 73);
            zones[4] = spawnStruct(); zones[4].name = "Green House Garden"; zones[4].origin = (-1557, 387, -64);
            zones[5] = spawnStruct(); zones[5].name = "Green House Garage"; zones[5].origin = (-910, 178, -56);
            zones[6] = spawnStruct(); zones[6].name = "Yellow House"; zones[6].origin = (729, 208, -56);
            zones[7] = spawnStruct(); zones[7].name = "Yellow House Office"; zones[7].origin = (729, 208, 80);
            zones[8] = spawnStruct(); zones[8].name = "Yellow House Garage"; zones[8].origin = (783, 615, -56.8);
            zones[9] = spawnStruct(); zones[9].name = "Yellow House Garage Roof"; zones[9].origin = (926, 638, 110);
            zones[10] = spawnStruct(); zones[10].name = "Yellow House Garden"; zones[10].origin = (1585, 389, -63);
            zones[11] = spawnStruct(); zones[11].name = "Yellow House Perk"; zones[11].origin = (1203, 1051, -80);
            zones[12] = spawnStruct(); zones[12].name = "Nuketown Prison"; zones[12].origin = (375, -359, -60);
            zones[13] = spawnStruct(); zones[13].name = "Nuketown Out of Map"; zones[13].origin = (52, -866, -57);
            zones[14] = spawnStruct(); zones[14].name = "Black Hole Out of Map"; zones[14].origin = (2143, 2326, -887);
            break;

        case "zm_highrise":
        case "highrise":
            zones[0] = spawnStruct(); zones[0].name = "Spawn Area"; zones[0].origin = (1464.25, 1377.69, 3397.46);
            zones[1] = spawnStruct(); zones[1].name = "Slide"; zones[1].origin = (2084.26, 2573.54, 3050.59);
            zones[2] = spawnStruct(); zones[2].name = "Broken Elevator"; zones[2].origin = (3700.51, 2173.41, 2575.47);
            zones[3] = spawnStruct(); zones[3].name = "Red Room"; zones[3].origin = (3176.08, 1426.12, 1298.53);
            zones[4] = spawnStruct(); zones[4].name = "Bank/Power"; zones[4].origin = (2614.06, 30.8681, 1296.13);
            zones[5] = spawnStruct(); zones[5].name = "Roof"; zones[5].origin = (1965.23, 151.344, 2880.13);
            zones[6] = spawnStruct(); zones[6].name = "Mainroom"; zones[6].origin = (2067.99, 1385.92, 3040.13);
            break;

        case "zm_buried":
        case "buried":
            zones[0] = spawnStruct(); zones[0].name = "Spawn Area"; zones[0].origin = (-2689.08, -761.858, 1360.13);
            zones[1] = spawnStruct(); zones[1].name = "Underspawn Area"; zones[1].origin = (-957.409, -351.905, 288.125);
            zones[2] = spawnStruct(); zones[2].name = "Bank House"; zones[2].origin = (2614.06, 30.8681, 1296.13);
            zones[3] = spawnStruct(); zones[3].name = "Leroy Cell"; zones[3].origin = (-1081.72, 830.04, 8.125);
            zones[4] = spawnStruct(); zones[4].name = "Bar Saloon"; zones[4].origin = (790.854, -1433.25, 56.125);
            zones[5] = spawnStruct(); zones[5].name = "Middle Maze"; zones[5].origin = (4920.74, 454.216, 4.125);
            zones[6] = spawnStruct(); zones[6].name = "Power"; zones[6].origin = (710.08, -591.387, 143.443);
            break;

        case "zm_tomb":
        case "tomb":
            zones[0] = spawnStruct(); zones[0].name = "Pack a punch"; zones[0].origin = (-199.079, -11.0947, 320.125);
            zones[1] = spawnStruct(); zones[1].name = "Room with Staffs"; zones[1].origin = (6.8478, -13.7044, -751.875);
            zones[2] = spawnStruct(); zones[2].name = "Tank"; zones[2].origin = (160.635, -2755.65, 43.5474);
            zones[3] = spawnStruct(); zones[3].name = "Tank Second spot"; zones[3].origin = (-86.3847, 4654.54, -288.052);
            zones[4] = spawnStruct(); zones[4].name = "No Mans land"; zones[4].origin = (-760.179, 1121.94, 119.175);
            zones[5] = spawnStruct(); zones[5].name = "Inside Church"; zones[5].origin = (459.258, -2644.85, 365.342);
            zones[6] = spawnStruct(); zones[6].name = "Generator 1"; zones[6].origin = (2170.5, 4660.37, -299.875);
            zones[7] = spawnStruct(); zones[7].name = "Generator 2"; zones[7].origin = (-356.707, 3579.11, -291.875);
            zones[8] = spawnStruct(); zones[8].name = "Generator 3"; zones[8].origin = (518.721, 2500.87, -121.875);
            zones[9] = spawnStruct(); zones[9].name = "Generator 4"; zones[9].origin = (2372.42, 101.088, 120.125);
            zones[10] = spawnStruct(); zones[10].name = "Generator 5"; zones[10].origin = (-2493.36, 178.245, 236.625);
            zones[11] = spawnStruct(); zones[11].name = "Generator 6"; zones[11].origin = (952.098, -3554.39, 306.125);
            zones[12] = spawnStruct(); zones[12].name = "Crazy place lightning"; zones[12].origin = (9621.84, -6989.4, -345.875);
            zones[13] = spawnStruct(); zones[13].name = "Crazy place ice"; zones[13].origin = (11242.1, -7033.06, -345.875);
            zones[14] = spawnStruct(); zones[14].name = "Crazy place air"; zones[14].origin = (11285.9, -8679.08, -407.875);
            zones[15] = spawnStruct(); zones[15].name = "Crazy place fire"; zones[15].origin = (9429.59, -8560.03, -397.875);
            zones[16] = spawnStruct(); zones[16].name = "Mule kick"; zones[16].origin = (-3.33877, -405.654, -493.875);
            zones[17] = spawnStruct(); zones[17].name = "Juggernog"; zones[17].origin = (2329.01, -176.799, 139.125);
            zones[18] = spawnStruct(); zones[18].name = "Quick revive"; zones[18].origin = (2359.2, 5039.69, -303.875);
            zones[19] = spawnStruct(); zones[19].name = "Speed cola"; zones[19].origin = (890.851, 3223.45, -171.024);
            zones[20] = spawnStruct(); zones[20].name = "Stamin-up"; zones[20].origin = (-2399.83, 3.22381, 233.342);
            break;
    }
    return zones;
}

navigate_locate_zone_page(direction)
{
    self.tele_zone_page += direction;
    self thread open_locate_zone_menu();
}

navigate_tele_cat_page(direction)
{
    self.tele_cat_page += direction;
    self thread open_teleport_categories_menu();
}

navigate_tele_cat_sub_page(direction, category)
{
    self.tele_cat_sub_page += direction;
    self thread open_category_submenu(category);
}

navigate_tele_global_page(direction)
{
    self.tele_global_page += direction;
    self thread teleport_select_point_menu();
}

navigate_tele_list_page(direction)
{
    self.tele_list_page += direction;
    self thread teleport_list_points_menu();
}


navigate_tele_del_page(direction)
{
    self.tele_del_page += direction;
    self thread teleport_delete_point_menu();
}





init_function_registry()
{
    level.func_registry = [];
    
    
    add_to_registry("godmode", "God Mode", "God Mode", scripts\zm\funciones::toggle_godmode);
    add_to_registry("ufo", "Modo UFO", "UFO Mode", scripts\zm\funciones::toggle_ufo_mode);
    add_to_registry("money", "Dar 10k Puntos", "Give 10k Points", scripts\zm\funciones::give_10k_points);
    add_to_registry("speed", "Velocidad x2", "Speed x2", scripts\zm\funciones::toggle_speed);
    add_to_registry("jump", "Super Salto", "Super Jump", scripts\zm\funciones::toggle_super_jump);
    add_to_registry("unl_ammo", "Munición Infinita", "Unlimited Ammo", scripts\zm\funciones::toggle_unlimited_ammo);
    add_to_registry("insta_reload", "Insta-Reload", "Insta-Reload", scripts\zm\funciones::toggle_insta_reload);
    add_to_registry("drops", "Soltar Arma", "Drop Weapon", scripts\zm\funciones::drop_current_weapon);
    
    
    add_to_registry("wpn_rand", "Arma Aleatoria", "Random Weapon", ::give_random_weapon_menu);
    add_to_registry("wpn_upg", "Mejorar Arma", "Upgrade Weapon", ::upgrade_current_weapon_menu);
    
    
    add_to_registry("round", "Avanzar Ronda", "Advance Round", scripts\zm\funciones::advance_round);
    add_to_registry("round_back", "Retroceder Ronda", "Go Back Round", scripts\zm\funciones::go_back_round);
    add_to_registry("round_255", "Round 255", "Round 255", scripts\zm\funciones::set_round_255);
    add_to_registry("round_apply", "Aplicar Ronda", "Apply Round", scripts\zm\funciones::apply_round_change);
    add_to_registry("killall", "Matar Zombies", "Kill All Zombies", scripts\zm\funciones::kill_all_zombies);
    add_to_registry("z_freeze", "Congelar Zombies", "Zombie Freeze", scripts\zm\funciones::Fr3ZzZoM);
    add_to_registry("z_teleport", "Teletransportar Zombies", "Teleport Zombies", scripts\zm\funciones::toggle_teleport_zombies);
    add_to_registry("z_disable", "Desactivar Zombies", "Disable Zombies", scripts\zm\funciones::toggle_disable_zombies);
    add_to_registry("unl_perk", "Perks Infinitos", "Unlimited Perks", scripts\zm\funciones::toggle_perk_unlimite);
    add_to_registry("tpp", "Tercera Persona", "Third Person", scripts\zm\funciones::ThirdPerson);
    add_to_registry("photo", "Modo Foto", "Photo Mode", scripts\zm\funciones::toggle_photo_mode);
    
    
    add_to_registry("ammo", "Munición Máxima", "Max Ammo", scripts\zm\funciones::spawn_max_ammo);
    add_to_registry("powerups", "Todos los Powerups", "All Powerups", scripts\zm\funciones::spawn_all_powerups);
    add_to_registry("powerup_rand", "Powerup Aleatorio", "Random Powerup", scripts\zm\funciones::spawn_random_powerup);
    
    
    add_to_registry("box_inc", "Aumentar Precio Caja", "Increase Box Price", scripts\zm\funciones::increase_box_price);
    add_to_registry("box_dec", "Disminuir Precio Caja", "Decrease Box Price", scripts\zm\funciones::decrease_box_price);
    add_to_registry("box_950", "Caja: 950", "Box: 950", scripts\zm\funciones::set_box_price_950);
    add_to_registry("box_500", "Caja: 500", "Box: 500", scripts\zm\funciones::set_box_price_500);
    add_to_registry("box_0", "Caja: Gratis", "Box: Free", scripts\zm\funciones::set_box_price_0);
    
    
    add_to_registry("give_weapon", "Dar Arma", "Give Weapon", ::give_specific_weapon_menu);
    
    
    add_to_registry("p_insta", "Insta-Kill", "Insta-Kill", scripts\zm\funciones::spawn_insta_kill);
    add_to_registry("p_carp", "Carpintero", "Carpenter", scripts\zm\funciones::spawn_carpenter);
    add_to_registry("p_double", "Doble Puntos", "Double Points", scripts\zm\funciones::spawn_double_points);
    add_to_registry("p_fire", "Fire Sale", "Fire Sale", scripts\zm\funciones::spawn_fire_sale);
    add_to_registry("p_nuke", "Bomba Nuclear", "Nuke", scripts\zm\funciones::spawn_nuke);
    add_to_registry("p_blood", "Sangre Zombie", "Zombie Blood", scripts\zm\funciones::spawn_zombie_blood);
    
    
    add_to_registry("clone", "Clonar Jugador", "Clone Player", scripts\zm\funciones::clone_player);
    add_to_registry("gore", "Modo Gore", "Gore Mode", scripts\zm\funciones::toggle_gore_mode);
    add_to_registry("doors", "Abrir Puertas", "Open Doors", scripts\zm\funciones::open_all_doors);
    add_to_registry("kami", "Kamikaze", "Kamikaze", scripts\zm\funciones::do_kamikaze);
    add_to_registry("forge", "Modo Forge", "Forge Mode", scripts\zm\funciones::toggle_forge_mode);
    add_to_registry("jetpack", "Jetpack", "Jetpack", scripts\zm\funciones::toggle_jetpack);
    
    
    add_to_registry("perk_jug", "Juggernog", "Juggernog", ::give_perk_jugger_menu);
    add_to_registry("perk_speed", "Speed Cola", "Speed Cola", ::give_perk_speed_menu);
    add_to_registry("perk_dt", "Double Tap", "Double Tap", ::give_perk_doubletap_menu);
    add_to_registry("perk_rev", "Quick Revive", "Quick Revive", ::give_perk_revive_menu);
    add_to_registry("perk_stamin", "Stamin-Up", "Stamin-Up", ::give_perk_staminup_menu);
    add_to_registry("perk_mule", "Mule Kick", "Mule Kick", ::give_perk_mule_menu);
    add_to_registry("perk_cherry", "Electric Cherry", "Electric Cherry", ::give_perk_cherry_menu);
    add_to_registry("perk_dead", "Deadshot", "Deadshot", ::give_perk_deadshot_menu);
    add_to_registry("perk_phd", "PhD Flopper", "PhD Flopper", ::give_perk_phd_menu);
    add_to_registry("perk_vultra", "Vulture Aid", "Vulture Aid", ::give_perk_vulture_menu);
    add_to_registry("perk_tomb", "Tombstone", "Tombstone", ::give_perk_tombstone_menu);
    add_to_registry("perk_who", "Who's Who", "Who's Who", ::give_perk_whoswho_menu);
    add_to_registry("perk_all", "Todos los Perks", "All Perks", ::give_all_perks_menu);
    
    
    add_to_registry("staff_fire", "Bastón Fuego", "Fire Staff", ::give_staff_fire);
    add_to_registry("staff_ice", "Bastón Hielo", "Ice Staff", ::give_staff_ice);
    add_to_registry("staff_wind", "Bastón Viento", "Wind Staff", ::give_staff_wind);
    add_to_registry("staff_lite", "Bastón Rayo", "Lightning Staff", ::give_staff_lightning);
    add_to_registry("staff_upg", "Mejorar Bastón", "Upgrade Staff", ::upgrade_current_staff);
}

add_to_registry(key, name_es, name_en, func)
{
    struct = spawnStruct();
    struct.name_es = name_es;
    struct.name_en = name_en;
    struct.func = func;
    level.func_registry[key] = struct;
}

open_custom_dev_categories_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "MIS CATEGORÍAS" : "MY CATEGORIES";
    menu = create_menu(title, self);
    menu.parent_menu = "developer";
    
    
    categories = scripts\zm\sqllocal::load_custom_dev_categories(self);
    
    add_menu_item(menu, (self.langLEN == 0) ? "^2+ Crear Categoría" : "^2+ Create Category", ::prompt_create_custom_dev_category);
    
    if (categories.size > 0)
    {
        add_menu_item(menu, "----------------------", ::do_nothing);
        foreach (cat in categories)
        {
            add_menu_item(menu, "^5[CAT] ^7" + cat, ::open_custom_dev_submenu, cat);
        }
    }
    else
    {
        add_menu_item(menu, (self.langLEN == 0) ? "^1Sin categorías" : "^1No categories", ::do_nothing);
    }
    
    add_menu_item(menu, "----------------------", ::do_nothing);
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::menu_go_back);
    
    show_menu(menu);
    self thread menu_control(menu);
}

prompt_create_custom_dev_category()
{
    self endon("disconnect");
    self thread close_all_menus();
    
    if (self.langLEN == 0)
        self iPrintLnBold("Escribe el nombre de la categoría en el chat");
    else
        self iPrintLnBold("Type the category name in chat");
        
    self.is_typing_dev_cat = true;
    self thread watch_dev_cat_chat();
}

watch_dev_cat_chat()
{
    self endon("disconnect");
    self endon("stop_typing_dev_cat");
    
    while (isDefined(self.is_typing_dev_cat) && self.is_typing_dev_cat)
    {
        level waittill("say", message, player);
        
        if (player != self)
            continue;
            
        if (!isDefined(message) || message == "")
            continue;
            
        
        message = trim_string(message);
        if (message == "")
            continue;
            
        success = scripts\zm\sqllocal::save_custom_dev_category(self, message);
        
        if (success)
        {
            if (self.langLEN == 0) self iPrintLnBold("^2Categoría '" + message + "' creada");
            else self iPrintLnBold("^2Category '" + message + "' created");
        }
        else
        {
            if (self.langLEN == 0) self iPrintLnBold("^1Error: Categoría ya existe o fallo al guardar");
            else self iPrintLnBold("^1Error: Category already exists or save failed");
        }
        
        self.is_typing_dev_cat = false;
        wait 0.5;
        self thread open_custom_dev_categories_menu();
        return;
    }
}

open_custom_dev_submenu(category)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    
    self.adding_to_cat = undefined;
    
    title = "^5" + category;
    menu = create_menu(title, self);
    menu.parent_menu = "custom_dev_categories";
    
    items = scripts\zm\sqllocal::load_custom_dev_items(self, category);
    
    add_menu_item(menu, (self.langLEN == 0) ? "^2+ Agregar Opción" : "^2+ Add Option", ::start_navigation_selection, category);
    
    if (items.size > 0)
    {
        add_menu_item(menu, "----------------------", ::do_nothing);
        foreach (key in items)
        {
            reg = level.func_registry[key];
            if (isDefined(reg))
            {
                name = (self.langLEN == 0) ? reg.name_es : reg.name_en;
                add_menu_item(menu, name, reg.func);
            }
            else if (isSubStr(key, "WPN|"))
            {
                weapon_name = getSubStr(key, 4);
                display_name = get_weapon_display_name(weapon_name);
                add_menu_item(menu, display_name, ::give_specific_weapon_menu, weapon_name);
            }
        }
    }
    
    add_menu_item(menu, "----------------------", ::do_nothing);
    add_menu_item(menu, (self.langLEN == 0) ? "^1Eliminar Items" : "^1Delete Items", ::open_delete_items_submenu, category);
    add_menu_item(menu, (self.langLEN == 0) ? "^1Eliminar Categoría" : "^1Delete Category", ::delete_custom_dev_category, category);
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_custom_dev_categories_menu);
    
    show_menu(menu);
    self thread menu_control(menu);
}

add_item_to_custom_category(category, key)
{
    success = scripts\zm\sqllocal::save_custom_dev_item(self, category, key);
    
    if (success)
    {
        if (self.langLEN == 0) self iPrintLnBold("^2Opción agregada");
        else self iPrintLnBold("^2Option added");
    }
    else
    {
        if (self.langLEN == 0) self iPrintLnBold("^1Opción ya está en la categoría");
        else self iPrintLnBold("^1Option already in category");
    }
    
    wait 0.2;
    self thread open_custom_dev_submenu(category);
}

open_delete_items_submenu(category)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ELIMINAR DE " + category : "DELETE FROM " + category;
    menu = create_menu(title, self);
    menu.parent_menu = "custom_dev_submenu_" + category;
    
    items = scripts\zm\sqllocal::load_custom_dev_items(self, category);
    
    if (items.size > 0)
    {
        foreach (key in items)
        {
            reg = level.func_registry[key];
            if (isDefined(reg))
            {
                name = (self.langLEN == 0) ? reg.name_es : reg.name_en;
                add_menu_item(menu, "^1[DEL] ^7" + name, ::delete_item_from_custom_category, category, key);
            }
        }
    }
    else
    {
        add_menu_item(menu, (self.langLEN == 0) ? "^1Sin items" : "^1No items", ::do_nothing);
    }
    
    add_menu_item(menu, "----------------------", ::do_nothing);
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_custom_dev_submenu, category);
    
    show_menu(menu);
    self thread menu_control(menu);
}

delete_item_from_custom_category(category, key)
{
    scripts\zm\sqllocal::remove_custom_dev_item_persistent(self, category, key);
    if (self.langLEN == 0) self iPrintLnBold("^1Opción eliminada");
    else self iPrintLnBold("^1Option deleted");
    
    wait 0.2;
    self thread open_delete_items_submenu(category);
}

delete_custom_dev_category(category)
{
    scripts\zm\sqllocal::delete_custom_dev_category_persistent(self, category);
    if (self.langLEN == 0) self iPrintLnBold("^1Categoría eliminada");
    else self iPrintLnBold("^1Category deleted");
    
    wait 0.2;
    self thread open_custom_dev_categories_menu();
}

get_registry_key_by_func(func)
{
    keys = getArrayKeys(level.func_registry);
    foreach (key in keys)
    {
        if (level.func_registry[key].func == func)
            return key;
    }
    return undefined;
}

start_navigation_selection(category)
{
    self.adding_to_cat = category;
    
    if (self.langLEN == 0)
        self iPrintLnBold("^3Modo Selección: ^7Navega y selecciona la opción");
    else
        self iPrintLnBold("^3Selection Mode: ^7Navigate and select the option");
        
    self thread open_developer_menu();
}

add_item_to_custom_category_from_nav(category, key)
{
    
    if (key == "give_weapon")
    {
        if (isDefined(self.menu_current) && isDefined(self.menu_current.items[self.menu_current.selected]))
        {
            weapon_name = self.menu_current.items[self.menu_current.selected].weapon_name;
            if (isDefined(weapon_name))
            {
                key = "WPN|" + weapon_name;
            }
        }
    }
    
    success = scripts\zm\sqllocal::save_custom_dev_item(self, category, key);
    
    if (success)
    {
        if (self.langLEN == 0) self iPrintLnBold("^2Opción agregada a ^7" + category);
        else self iPrintLnBold("^2Option added to ^7" + category);
    }
    
    self.adding_to_cat = undefined;
    wait 0.5;
    self thread open_custom_dev_submenu(category);
}

cancel_nav_selection()
{
    category = self.adding_to_cat;
    self.adding_to_cat = undefined;
    
    if (isDefined(category))
        self thread open_custom_dev_submenu(category);
    else
        self thread open_developer_menu();
}

open_startup_profile_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "SELECCIÓN DE PERFIL" : "PROFILE SELECTION";
    menu = create_menu(title, self);
    
    add_menu_item(menu, (self.langLEN == 0) ? "Cargar Default" : "Load Default", ::load_default_startup);
    add_menu_item(menu, (self.langLEN == 0) ? "Cargar Perfil..." : "Load Profile...", ::open_load_profiles_menu);
    add_menu_item(menu, (self.langLEN == 0) ? "Continuar sin Cargar" : "Continue without Loading", ::open_main_menu, true);
    
    show_menu(menu);
    self thread menu_control(menu);
}

load_default_startup()
{
    self notify("destroy_current_menu");
    wait 0.1;

    scripts\zm\sqllocal::load_menu_config(self);
    if (self.langLEN == 0) self iPrintLnBold("^2Configuración Default cargada");
    else self iPrintLnBold("^2Default configuration loaded");
    
    
    if (isDefined(self.menu_style_index) && isDefined(level.apply_menu_style_func))
        self thread [[level.apply_menu_style_func]](self.menu_style_index);
        
    self thread open_main_menu(true);
}

open_manage_profiles_menu(from_account)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    
    if (isDefined(from_account) && from_account)
    {
        self thread open_load_profiles_menu_from_account();
        return;
    }
    
    title = (self.langLEN == 0) ? "GESTIONAR PERFILES" : "MANAGE PROFILES";
    menu = create_menu(title, self);
    menu.parent_menu = "settings";
    
    add_menu_item(menu, (self.langLEN == 0) ? "Cargar Perfil" : "Load Profile", ::open_load_profiles_menu);
    add_menu_item(menu, (self.langLEN == 0) ? "Eliminar Perfil" : "Delete Profile", ::open_delete_profile_menu);
    
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_settings_menu, true);
    
    show_menu(menu);
    self thread menu_control(menu);
}

open_load_profiles_menu_from_account()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "^3[SEL] ^7CARGAR PERFIL" : "^3[SEL] ^7LOAD PROFILE";
    menu = create_menu(title, self);
    menu.parent_menu = "account";
    
    profiles = scripts\zm\sqllocal::get_player_profiles(self);
    
    if (profiles.size > 0)
    {
        foreach (p in profiles)
        {
            add_menu_item(menu, p, ::load_profile_action, p);
        }
    }
    else
    {
        add_menu_item(menu, (self.langLEN == 0) ? "Sin perfiles" : "No profiles", ::do_nothing);
    }
    
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::menu_go_back);
    
    show_menu(menu);
    self thread menu_control(menu);
}

open_load_profiles_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "CARGAR PERFIL" : "LOAD PROFILE";
    menu = create_menu(title, self);
    
    
    if (isDefined(self.profile_prompted) && self.profile_prompted)
        menu.parent_menu = "manage_profiles";
    else
        menu.parent_menu = "startup_profile";
    
    profiles = scripts\zm\sqllocal::get_player_profiles(self);
    
    if (profiles.size > 0)
    {
        foreach (p in profiles)
        {
            add_menu_item(menu, p, ::load_profile_action, p);
        }
    }
    else
    {
        add_menu_item(menu, (self.langLEN == 0) ? "Sin perfiles" : "No profiles", ::do_nothing);
    }
    
    if (menu.parent_menu == "startup_profile")
        add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_startup_profile_menu);
    else
        add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_manage_profiles_menu);
    
    show_menu(menu);
    self thread menu_control(menu);
}

load_profile_action(profile_name)
{
    self notify("destroy_current_menu");
    wait 0.1;

    success = scripts\zm\sqllocal::load_menu_profile(self, profile_name);
    if (success)
    {
        
        self.current_profile_name = profile_name;
        
        if (self.langLEN == 0) self iPrintLnBold("^2Perfil '" + profile_name + "' cargado");
        else self iPrintLnBold("^2Profile '" + profile_name + "' loaded");
        
        
        if (isDefined(self.menu_style_index) && isDefined(level.apply_menu_style_func))
            self thread [[level.apply_menu_style_func]](self.menu_style_index);
    }
    wait 0.5;
    self thread open_main_menu(true);
}

open_delete_profile_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ELIMINAR PERFIL" : "DELETE PROFILE";
    menu = create_menu(title, self);
    menu.parent_menu = "manage_profiles";
    
    profiles = scripts\zm\sqllocal::get_player_profiles(self);
    
    if (profiles.size > 0)
    {
        foreach (p in profiles)
        {
            add_menu_item(menu, "^1[ELIMINAR] ^7" + p, ::delete_profile_action, p);
        }
    }
    else
    {
        add_menu_item(menu, (self.langLEN == 0) ? "Sin perfiles" : "No profiles", ::do_nothing);
    }
    
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_manage_profiles_menu);
    
    show_menu(menu);
    self thread menu_control(menu);
}

delete_profile_action(profile_name)
{
    success = scripts\zm\sqllocal::delete_menu_profile(self, profile_name);
    if (success)
    {
        if (self.langLEN == 0) self iPrintLnBold("^1Perfil '" + profile_name + "' eliminado");
        else self iPrintLnBold("^1Profile '" + profile_name + "' deleted");
    }
    wait 0.5;
    self thread open_delete_profile_menu();
}






open_match_profiles_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = "CONFIG.GODS";
    menu = create_menu(title, self);
    menu.parent_menu = "developer";
    
    add_menu_item(menu, (self.langLEN == 0) ? "Crear Nueva Config." : "Create New Match Config.", ::prompt_create_match_config);
    add_menu_item(menu, (self.langLEN == 0) ? "Gestionar Configs." : "Manage Match Configs.", ::open_load_match_configs_menu);
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::menu_go_back);
    
    show_menu(menu);
    self thread menu_control(menu);
}

prompt_create_match_config()
{
    self notify("destroy_current_menu");
    wait 0.1;
    
    if (self.langLEN == 0) self iPrintLnBold("Escribe el nombre de la configuración en el chat");
    else self iPrintLnBold("Type the name of the match config in chat");
    
    self.is_typing_match_cfg = true;
    self thread watch_match_config_name_chat();
}

watch_match_config_name_chat()
{
    self endon("disconnect");
    self endon("stop_typing_match_cfg");
    
    while (isDefined(self.is_typing_match_cfg) && self.is_typing_match_cfg)
    {
        level waittill("say", message, player);
        if (player != self) continue;
        if (!isDefined(message) || message == "") continue;
        
        message = scripts\zm\sqllocal::trim_string(message);
        if (message == "") continue;
        
        success = scripts\zm\sqllocal::save_match_config(self, message);
        if (success)
        {
            if (self.langLEN == 0) self iPrintLnBold("^2Config. '" + message + "' creada");
            else self iPrintLnBold("^2Match Config. '" + message + "' created");
        }
        
        self.is_typing_match_cfg = false;
        wait 0.5;
        self thread open_match_config_editor(message);
        return;
    }
}

open_load_match_configs_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "CARGAR CONFIG." : "LOAD CONFIG.";
    menu = create_menu(title, self);
    menu.parent_menu = "match_profiles";
    
    configs = scripts\zm\sqllocal::get_player_match_configs(self);
    if (configs.size == 0)
    {
        add_menu_item(menu, (self.langLEN == 0) ? "Sin Configuraciones" : "No Match Configurations", ::open_match_profiles_menu);
    }
    else
    {
        foreach (cfg in configs)
        {
            if (cfg != "")
            {
                display_name = cfg;
                if (isDefined(self.current_match_config_name) && self.current_match_config_name == cfg)
                {
                    display_name = "^2[SELEC] ^7" + display_name;
                }
                add_menu_item(menu, display_name, ::open_match_config_editor, cfg);
            }
        }
    }
    
    add_menu_item(menu, (self.langLEN == 0) ? "Eliminar alguna..." : "Delete configuration...", ::open_delete_match_config_menu);
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::menu_go_back);
    
    show_menu(menu);
    self thread menu_control(menu);
}

open_match_config_editor(config_name, skip_load)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.2; 
    
    
    if (!isDefined(skip_load) || !skip_load)
    {
        scripts\zm\sqllocal::load_match_config(self, config_name, false); 
        
        
        if (isDefined(self.temp_config))
            self.temp_config.config_name_ref = config_name;
    }
    
    
    t = self.temp_config; 
    if (!isDefined(t)) 
    {
        t = spawnStruct();
        t.maxhealth = self.maxhealth;
        t.score = self.score;
        t.box_cost = self.box_cost;
        t.start_weapon = self.start_weapon;
        t.start_perks = self.start_perks;
    }
    
    title = "EDITOR: " + config_name;
    menu = create_menu(title, self);
    menu.parent_menu = "match_load";
    
    add_menu_item(menu, (self.langLEN == 0) ? "Vida Máxima: " + t.maxhealth : "Max Health: " + t.maxhealth, ::prompt_match_config_numeric, config_name, "max_health", t.maxhealth);
    add_menu_item(menu, (self.langLEN == 0) ? "Puntos Iniciales: " + t.score : "Starting Score: " + t.score, ::prompt_match_config_numeric, config_name, "starting_score", t.score);
    add_menu_item(menu, (self.langLEN == 0) ? "Costo Caja: " + t.box_cost : "Box Cost: " + t.box_cost, ::prompt_match_config_numeric, config_name, "box_cost", t.box_cost);
    
    
    weapon_display = (isDefined(t.start_weapon)) ? get_weapon_display_name(t.start_weapon) : "Default";
    if (isDefined(t.start_weapon) && isDefined(t.start_weapon_upgraded) && t.start_weapon_upgraded)
        weapon_display += " (UP)";
        
    add_menu_item(menu, (self.langLEN == 0) ? "Arma Inicial: " + weapon_display : "Start Weapon: " + weapon_display, ::select_match_start_weapon, config_name);
    
    
    perks_count = 0;
    if (isDefined(t.start_perks) && t.start_perks != "")
    {
        perks_count = strTok(t.start_perks, ",").size;
    }
    
    perks_status = (perks_count > 0) ? "(" + perks_count + ")" : "None";
    add_menu_item(menu, (self.langLEN == 0) ? "Ventajas Iniciales: " + perks_status : "Start Perks: " + perks_status, ::open_match_config_perks_menu, config_name);
    
    add_menu_item(menu, (self.langLEN == 0) ? "^2GUARDAR CAMBIOS" : "^2SAVE CHANGES", ::save_match_config_action, config_name);
    add_menu_item(menu, (self.langLEN == 0) ? "^3APLICAR CONFIGURACIÓN" : "^3APPLY CONFIGURATION", ::apply_match_config_action, config_name);
    
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_load_match_configs_menu);
    
    show_menu(menu);
    self thread menu_control(menu);
}



apply_match_config_action(config_name)
{
    scripts\zm\sqllocal::apply_match_config_from_temp(self);
    
    if (self.langLEN == 0) self iPrintLnBold("^2Configuración Aplicada");
    else self iPrintLnBold("^2Configuration Applied");
    
    self thread open_match_config_editor(config_name, true);
}

prompt_match_config_numeric(config_name, setting, current_val)
{
    self notify("destroy_current_menu");
    wait 0.1;
    
    if (self.langLEN == 0) self iPrintLnBold("Escribe el valor para '" + setting + "' (Actual: " + current_val + ")");
    else self iPrintLnBold("Type value for '" + setting + "' (Current: " + current_val + ")");
    
    self.is_typing_numeric = true;
    self thread watch_match_config_numeric_chat(config_name, setting);
}

watch_match_config_numeric_chat(config_name, key)
{
    self endon("disconnect");
    self endon("stop_typing_numeric");
    
    while (isDefined(self.is_typing_numeric) && self.is_typing_numeric)
    {
        level waittill("say", message, player);
        if (player != self) continue;
        if (!isDefined(message) || message == "") continue;
        
        message = scripts\zm\sqllocal::trim_string(message);
        val = int(message);
        
        
        if (!isDefined(self.temp_config)) self.temp_config = spawnStruct();
        t = self.temp_config;
        
        if (key == "max_health") t.maxhealth = val;
        else if (key == "starting_score") t.score = val;
        else if (key == "box_cost") t.box_cost = val;
        else if (key == "wunderfizz_cost") t.wunderfizz_cost = val; 
        
        self.is_typing_numeric = false;
        wait 0.5;
        
        self thread open_match_config_editor(config_name, true);
        return;
    }
}

save_match_config_action(config_name)
{
    
    
    
    
    success = scripts\zm\sqllocal::save_match_config_from_temp(self, config_name);
    if (success)
    {
        if (self.langLEN == 0) self iPrintLnBold("^2Cambios guardados en archivo (No aplicados)");
        else self iPrintLnBold("^2Changes saved to file (Not applied)");
    }
    self thread open_match_config_editor(config_name, true);
}



delete_match_config_action(config_name)
{
    success = scripts\zm\sqllocal::delete_match_config(self, config_name);
    if (success)
    {
        if (self.langLEN == 0) self iPrintLnBold("^1Config. '" + config_name + "' eliminada");
        else self iPrintLnBold("^1Match Config. '" + config_name + "' deleted");
    }
    wait 0.5;
    
    
    configs = scripts\zm\sqllocal::get_player_match_configs(self);
    if (configs.size > 0)
    {
        self thread open_delete_match_config_menu();
    }
    else
    {
        if (self.langLEN == 0) self iPrintLnBold("^3No quedan configuraciones, redirigiendo a crear...");
        else self iPrintLnBold("^3No configurations left, redirecting to create...");
        wait 1;
        self thread open_match_profiles_menu(); 
    }
}

open_startup_match_config_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "CONFIG. DE PARTIDA" : "MATCH CONFIGURATION";
    menu = create_menu(title, self);
    
    add_menu_item(menu, (self.langLEN == 0) ? "Cargar Configuración..." : "Load Configuration...", ::open_load_match_configs_startup_menu);
    add_menu_item(menu, (self.langLEN == 0) ? "Saltar" : "Skip", ::skip_match_config_startup);
    
    show_menu(menu);
    self thread menu_control(menu);
}

open_load_match_configs_startup_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "CARGAR CONFIG." : "LOAD CONFIG.";
    menu = create_menu(title, self);
    menu.parent_menu = "match_startup";
    
    configs = scripts\zm\sqllocal::get_player_match_configs(self);
    if (configs.size > 0)
    {
        foreach (cfg in configs)
        {
            if (cfg != "")
                add_menu_item(menu, cfg, ::load_match_config_startup_action, cfg);
        }
    }
    else
    {
        add_menu_item(menu, (self.langLEN == 0) ? "^1Sin configuraciones" : "^1No configurations", ::do_nothing);
    }
    
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_startup_match_config_menu);
    
    show_menu(menu);
    self thread menu_control(menu);
}

load_match_config_startup_action(config_name)
{
    success = scripts\zm\sqllocal::load_match_config(self, config_name);
    if (success)
    {
        if (self.langLEN == 0) self iPrintLnBold("^2Config. '" + config_name + "' cargada");
        else self iPrintLnBold("^2Match Config. '" + config_name + "' loaded");
    }
    
    self.match_config_prompted = true;
    self thread open_main_menu(false);
}

skip_match_config_startup()
{
    self.match_config_prompted = true;
    self thread open_main_menu(false);
}

open_delete_match_config_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ELIMINAR CONFIG." : "DELETE CONFIG.";
    menu = create_menu(title, self);
    menu.parent_menu = "match_load";
    
    configs = scripts\zm\sqllocal::get_player_match_configs(self);
    foreach (cfg in configs)
    {
        if (cfg != "")
            add_menu_item(menu, cfg, ::delete_match_config_action, cfg);
    }
    
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_load_match_configs_menu);
    
    show_menu(menu);
    self thread menu_control(menu);
}

open_account_menu()
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "DATOS DE CUENTA" : "ACCOUNT DATA";
    menu = create_menu(title, self);
    menu.parent_menu = "main";
    
    
    name = isDefined(self.name) ? self.name : "Unknown";
    guid = self getGuid();
    
    add_menu_item(menu, (self.langLEN == 0) ? "Nombre: " + name : "Name: " + name, ::do_nothing);
    add_menu_item(menu, (self.langLEN == 0) ? "GUID: " + guid : "GUID: " + guid, ::do_nothing);
    
    add_menu_item(menu, "----------------------", ::do_nothing);
    
    
    bank_value = 0;
    if (isDefined(level.bank_account_value))
        bank_value = level.bank_account_value;
    
    add_menu_item(menu, (self.langLEN == 0) ? "^3Banco: ^7" + bank_value : "^3Bank: ^7" + bank_value, ::do_nothing);
    
    
    current_profile = (self.langLEN == 0) ? "Ninguno" : "None";
    if (isDefined(self.current_profile_name) && self.current_profile_name != "")
        current_profile = "^2" + self.current_profile_name;
    
    add_menu_item(menu, (self.langLEN == 0) ? "Profile Activo: " + current_profile : "Active Profile: " + current_profile, ::do_nothing);
    
    
    add_menu_item(menu, (self.langLEN == 0) ? "^5Cambiar Profile..." : "^5Switch Profile...", ::open_manage_profiles_menu, true);
    
    add_menu_item(menu, "----------------------", ::do_nothing);
    
    
    lang = (self.langLEN == 0) ? "Español" : "English";
    add_menu_item(menu, (self.langLEN == 0) ? "Idioma: " + lang : "Language: " + lang, ::toggle_language, "account");
    
    add_menu_item(menu, "----------------------", ::do_nothing);
    
    
    add_menu_item(menu, (self.langLEN == 0) ? "Ajustes Developer..." : "Developer Settings...", ::open_developer_settings_menu);
    
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::menu_go_back);
    
    show_menu(menu);
    self thread menu_control(menu);
}

open_developer_settings_menu()
{
    self endon("disconnect");
    
    
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "AJUSTES DEV" : "DEV SETTINGS";
    menu = create_menu(title, self);
    menu.parent_menu = "account";
    
    
    current_pass = isDefined(self.dev_password) ? self.dev_password : "admin";
    
    add_menu_item(menu, (self.langLEN == 0) ? "Pass Actual: " + current_pass : "Current Pass: " + current_pass, ::do_nothing);
    add_menu_item(menu, (self.langLEN == 0) ? "Cambiar Contraseña" : "Change Password", ::prompt_change_dev_password);
    
    if (isDefined(self.dev_password) && self.dev_password != "admin")
    {
        add_menu_item(menu, (self.langLEN == 0) ? "^1Deshabilitar Pass" : "^1Disable Pass", ::disable_dev_password_action);
    }
    
    add_menu_item(menu, (self.langLEN == 0) ? "Volver" : "Back", ::open_account_menu);
    
    show_menu(menu);
    self thread menu_control(menu);
}

prompt_change_dev_password()
{
    self endon("disconnect");
    self thread close_all_menus();
    
    if (self.langLEN == 0) self iPrintLnBold("Escribe la ^2Nueva ^7contraseña en el chat");
    else self iPrintLnBold("Type the ^2New ^7password in chat");
    
    self.is_changing_dev_pass = true;
    self.dev_pass_step = 1; 
}

disable_dev_password_action()
{
    self.dev_password = "admin";
    
    filename = undefined;
    if (isDefined(self.current_profile_name) && self.current_profile_name != "")
        filename = "scriptdata/profiles/" + self getGuid() + "/" + self.current_profile_name + ".txt";
        
    scripts\zm\sqllocal::save_menu_config(self, filename, true); 
    
    if (self.langLEN == 0) self iPrintLnBold("^2Seguridad deshabilitada");
    else self iPrintLnBold("^2Security disabled");
    
    self thread open_developer_settings_menu();
}

watch_dev_password_chat(message)
{
    self endon("disconnect");
    
    if (!isDefined(self.is_changing_dev_pass) || !self.is_changing_dev_pass)
        return;
        
    msg = scripts\zm\sqllocal::trim_string(message);
    
    if (msg == "" || msg == "!cancel")
    {
        self.is_changing_dev_pass = false;
        if (self.langLEN == 0) self iPrintLnBold("^1Cancelado");
        else self iPrintLnBold("^1Cancelled");
        wait 0.5;
        self thread open_developer_settings_menu();
        return;
    }
    
    if (self.dev_pass_step == 1)
    {
        self.temp_dev_pass = msg;
        self.dev_pass_step = 2;
        
        if (self.langLEN == 0) self iPrintLnBold("Escribe la contraseña ^2Nuevamente ^7para confirmar");
        else self iPrintLnBold("Type the password ^2Again ^7to confirm");
    }
    else if (self.dev_pass_step == 2)
    {
        if (msg == self.temp_dev_pass)
        {
            self.dev_password = msg;
            self.is_changing_dev_pass = false;
            self.developer_mode_unlocked = false; 
            
            filename = undefined;
            if (isDefined(self.current_profile_name) && self.current_profile_name != "")
                filename = "scriptdata/profiles/" + self getGuid() + "/" + self.current_profile_name + ".txt";
                
            scripts\zm\sqllocal::save_menu_config(self, filename, true);
            
            if (self.langLEN == 0) self iPrintLnBold("^2Contraseña actualizada. ^7Escríbela de nuevo para entrar.");
            else self iPrintLnBold("^2Password updated. ^7Type it again to enter.");
            
            wait 0.5;
            self thread open_account_menu(); 
        }
        else
        {
            self.is_changing_dev_pass = false;
            if (self.langLEN == 0) self iPrintLnBold("^1Las contraseñas no coinciden. Reintenta.");
            else self iPrintLnBold("^1Passwords do not match. Try again.");
            
            wait 0.5;
            self thread open_developer_settings_menu();
        }
    }
}

select_match_start_weapon(config_name)
{
    self.selecting_match_start_weapon = true;
    self.match_config_editing_name = config_name;
    
    if (self.langLEN == 0) self iPrintLnBold("^2Selecciona el arma en el menú...");
    else self iPrintLnBold("^2Select weapon from menu...");
    
    self thread open_weapons_menu();
}

prompt_match_start_weapon_upgrade(config_name, weapon_name)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "¿MEJORADA?" : "UPGRADED?";
    menu = create_menu(title, self);
    
    add_menu_item(menu, (self.langLEN == 0) ? "Si" : "Yes", ::select_match_start_weapon_camo, config_name, weapon_name, true);
    add_menu_item(menu, (self.langLEN == 0) ? "No" : "No", ::select_match_start_weapon_camo, config_name, weapon_name, false);
    
    show_menu(menu);
    self thread menu_control(menu);
}

select_match_start_weapon_camo(config_name, weapon_name, upgraded)
{
    self.selecting_match_start_weapon_camo = true;
    self.temp_config_name = config_name;
    self.temp_config_weapon = weapon_name;
    self.temp_config_upgraded = upgraded;
    
    if (self.langLEN == 0) self iPrintLnBold("^2Selecciona el Camuflaje...");
    else self iPrintLnBold("^2Select Camouflage...");
    
    self thread open_camo_menu();
}

match_config_set_weapon_final(camo_index)
{
    config_name = self.temp_config_name;
    
    
    if (!isDefined(self.temp_config)) self.temp_config = spawnStruct();
    self.temp_config.start_weapon = self.temp_config_weapon;
    self.temp_config.start_weapon_upgraded = self.temp_config_upgraded;
    self.temp_config.start_weapon_camo = camo_index;
    
    
    self.temp_config_name = undefined;
    self.temp_config_weapon = undefined;
    self.temp_config_upgraded = undefined;
    
    if (self.langLEN == 0) self iPrintLnBold("^2Arma establecida");
    else self iPrintLnBold("^2Weapon set");
    
    self thread open_match_config_editor(config_name, true); 
}

open_match_config_perks_menu(config_name)
{
    self endon("disconnect");
    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "VENTAJAS INICIALES" : "STARTING PERKS";
    menu = create_menu(title, self);
    menu.match_config_name = config_name;
    
    
    active_perks = [];
    t = self.temp_config;
    if (isDefined(t) && isDefined(t.start_perks) && t.start_perks != "")
    {
        current_list = strTok(t.start_perks, ",");
        foreach(perk in current_list)
            active_perks[perk] = true;
    }
    
    
    perk_defs = [];
    perk_defs[0] = spawnStruct(); perk_defs[0].key = "specialty_armorvest"; perk_defs[0].name = "Juggernog"; perk_defs[0].check = "level.zombiemode_using_juggernaut_perk";
    perk_defs[1] = spawnStruct(); perk_defs[1].key = "specialty_fastreload"; perk_defs[1].name = "Speed Cola"; perk_defs[1].check = "level.zombiemode_using_sleightofhand_perk";
    perk_defs[2] = spawnStruct(); perk_defs[2].key = "specialty_quickrevive"; perk_defs[2].name = "Quick Revive"; perk_defs[2].check = "level.zombiemode_using_revive_perk";
    perk_defs[3] = spawnStruct(); perk_defs[3].key = "specialty_rof"; perk_defs[3].name = "Double Tap"; perk_defs[3].check = "level.zombiemode_using_doubletap_perk";
    perk_defs[4] = spawnStruct(); perk_defs[4].key = "specialty_longersprint"; perk_defs[4].name = "Stamin-Up"; perk_defs[4].check = "level.zombiemode_using_marathon_perk";
    perk_defs[5] = spawnStruct(); perk_defs[5].key = "specialty_flakjacket"; perk_defs[5].name = "PhD Flopper"; perk_defs[5].check = "level._custom_perks['specialty_flakjacket']"; 
    perk_defs[6] = spawnStruct(); perk_defs[6].key = "specialty_additionalprimaryweapon"; perk_defs[6].name = "Mule Kick"; perk_defs[6].check = "level.zombiemode_using_additionalprimaryweapon_perk";
    perk_defs[7] = spawnStruct(); perk_defs[7].key = "specialty_deadshot"; perk_defs[7].name = "Deadshot"; perk_defs[7].check = "level.zombiemode_using_deadshot_perk";
    perk_defs[8] = spawnStruct(); perk_defs[8].key = "specialty_grenadepulldeath"; perk_defs[8].name = "Electric Cherry"; perk_defs[8].check = "level._custom_perks['specialty_grenadepulldeath']";
    perk_defs[9] = spawnStruct(); perk_defs[9].key = "specialty_scavenger"; perk_defs[9].name = "Tombstone"; perk_defs[9].check = "level.zombiemode_using_tombstone_perk";
    perk_defs[10] = spawnStruct(); perk_defs[10].key = "specialty_finalstand"; perk_defs[10].name = "Who's Who"; perk_defs[10].check = "level.zombiemode_using_chugabud_perk";
    perk_defs[11] = spawnStruct(); perk_defs[11].key = "specialty_nomotionsensor"; perk_defs[11].name = "Vulture Aid"; perk_defs[11].check = "level._custom_perks['specialty_nomotionsensor']";
    
    foreach(def in perk_defs)
    {
        is_available = false;
        
        
        if (def.key == "specialty_armorvest") is_available = (isDefined(level.zombiemode_using_juggernaut_perk) && level.zombiemode_using_juggernaut_perk);
        else if (def.key == "specialty_fastreload") is_available = (isDefined(level.zombiemode_using_sleightofhand_perk) && level.zombiemode_using_sleightofhand_perk);
        else if (def.key == "specialty_quickrevive") is_available = (isDefined(level.zombiemode_using_revive_perk) && level.zombiemode_using_revive_perk);
        else if (def.key == "specialty_rof") is_available = (isDefined(level.zombiemode_using_doubletap_perk) && level.zombiemode_using_doubletap_perk);
        else if (def.key == "specialty_longersprint") is_available = (isDefined(level.zombiemode_using_marathon_perk) && level.zombiemode_using_marathon_perk);
        else if (def.key == "specialty_flakjacket") is_available = (isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_flakjacket"]) && (level.script != "zm_buried"));
        else if (def.key == "specialty_additionalprimaryweapon") is_available = (isDefined(level.zombiemode_using_additionalprimaryweapon_perk) && level.zombiemode_using_additionalprimaryweapon_perk);
        else if (def.key == "specialty_deadshot") is_available = (isDefined(level.zombiemode_using_deadshot_perk) && level.zombiemode_using_deadshot_perk);
        else if (def.key == "specialty_grenadepulldeath") is_available = (isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_grenadepulldeath"]));
        else if (def.key == "specialty_scavenger") is_available = (isDefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk);
        else if (def.key == "specialty_finalstand") is_available = (isDefined(level.zombiemode_using_chugabud_perk) && level.zombiemode_using_chugabud_perk);
        else if (def.key == "specialty_nomotionsensor") is_available = (isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_nomotionsensor"]));
        
        if (is_available)
        {
            status = (isDefined(active_perks[def.key])) ? "^2[ON]" : "^1[OFF]";
            add_menu_item(menu, def.name + ": " + status, ::toggle_match_config_perk, def.key);
        }
    }
    
    add_menu_item(menu, (self.langLEN == 0) ? "Marcar Todos" : "Select All", ::select_all_match_config_perks, true);
    add_menu_item(menu, (self.langLEN == 0) ? "Desmarcar Todos" : "Deselect All", ::select_all_match_config_perks, false);
    add_menu_item(menu, (self.langLEN == 0) ? "^2CONFIRMAR" : "^2CONFIRM", ::save_match_config_perks, config_name);

    show_menu(menu);
    self thread menu_control(menu);
}

toggle_match_config_perk(perk_key)
{
    
    
    if (!isDefined(self.temp_config)) self.temp_config = spawnStruct();
    
    
    current_perks = [];
    if (isDefined(self.temp_config.start_perks) && self.temp_config.start_perks != "")
        current_list = strTok(self.temp_config.start_perks, ",");
    else
        current_list = [];
        
    found = false;
    new_string = "";
    
    foreach(p in current_list)
    {
        if (p == perk_key) found = true; 
        else new_string = (new_string == "") ? p : (new_string + "," + p);
    }
    
    if (!found) 
    {
        new_string = (new_string == "") ? perk_key : (new_string + "," + perk_key);
    }
    
    self.temp_config.start_perks = new_string;
    
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.match_config_name))
        self thread open_match_config_perks_menu(self.menu_current.match_config_name);
}

select_all_match_config_perks(select_state)
{
    if (!isDefined(self.temp_config)) self.temp_config = spawnStruct();
    
    if (select_state)
    {
        
        
        self.temp_config.start_perks = "specialty_armorvest,specialty_fastreload,specialty_quickrevive,specialty_rof,specialty_longersprint,specialty_flakjacket,specialty_additionalprimaryweapon,specialty_deadshot,specialty_grenadepulldeath,specialty_scavenger,specialty_finalstand,specialty_nomotionsensor";
    }
    else
    {
        self.temp_config.start_perks = "";
    }
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.match_config_name))
        self thread open_match_config_perks_menu(self.menu_current.match_config_name);
}

save_match_config_perks(config_name)
{
    
    self thread open_match_config_editor(config_name, true);
}
