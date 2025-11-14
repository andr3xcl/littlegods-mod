
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;


init()
{
    
    level.menu_open_sounds = [];
    level.menu_open_sounds[0] = "Sin Sonido";                    
    level.menu_open_sounds[1] = "fly_rgunmk2_magin";             
    level.menu_open_sounds[2] = "fly_1911_slide_forward";        
    level.menu_open_sounds[3] = "fly_1911_mag_in";               
    level.menu_open_sounds[4] = "fly_assault_reload_npc_mag_in"; 

    
    level.menu_close_sounds = [];
    level.menu_close_sounds[0] = "Sin Sonido";                   
    level.menu_close_sounds[1] = "fly_rgunmk2_magout";           
    level.menu_close_sounds[2] = "fly_1911_slide_back";          
    level.menu_close_sounds[3] = "fly_1911_mag_out";             
    level.menu_close_sounds[4] = "fly_assault_reload_npc_mag_out"; 
    level.menu_close_sounds[5] = "fly_beretta93r_slide_back";     

    
    level.menu_scroll_sounds = [];
    level.menu_scroll_sounds[0] = "Sin Sonido";                   
    level.menu_scroll_sounds[1] = "uin_main_nav";                 
    level.menu_scroll_sounds[2] = "fly_1911_slide_back";          
    level.menu_scroll_sounds[3] = "fly_1911_mag_in";              
    level.menu_scroll_sounds[4] = "fly_beretta93r_hammer";         

    
    level.menu_select_sounds = [];
    level.menu_select_sounds[0] = "Sin Sonido";                   
    level.menu_select_sounds[1] = "fly_1911_mag_out";       
    level.menu_select_sounds[2] = "fly_beretta93r_hammer";        
}


play_menu_open_sound(player)
{
    if (!isDefined(player.menu_open_sound_index))
        player.menu_open_sound_index = 1; 

    if (player.menu_open_sound_index > 0)
    {
        sound_alias = level.menu_open_sounds[player.menu_open_sound_index];
        if (isDefined(sound_alias) && sound_alias != "Sin Sonido")
        {
            player playLocalSound(sound_alias);
        }
    }
}


play_menu_scroll_sound(player)
{
    
    current_time = getTime();
    if (isDefined(player.last_scroll_sound_time) && (current_time - player.last_scroll_sound_time) < 100)
        return;

    player.last_scroll_sound_time = current_time;

    if (!isDefined(player.menu_scroll_sound_index))
        player.menu_scroll_sound_index = 1; 

    if (player.menu_scroll_sound_index > 0)
    {
        sound_alias = level.menu_scroll_sounds[player.menu_scroll_sound_index];
        if (isDefined(sound_alias) && sound_alias != "Sin Sonido")
        {
            player playLocalSound(sound_alias);
        }
    }
}


play_menu_select_sound(player)
{
    if (!isDefined(player.menu_select_sound_index))
        player.menu_select_sound_index = 1; 

    if (player.menu_select_sound_index > 0)
    {
        sound_alias = level.menu_select_sounds[player.menu_select_sound_index];
        if (isDefined(sound_alias) && sound_alias != "Sin Sonido")
        {
            player playLocalSound(sound_alias);
        }
    }
}


play_menu_close_sound(player)
{
    if (!isDefined(player.menu_close_sound_index))
        player.menu_close_sound_index = 1; 

    if (player.menu_close_sound_index > 0)
    {
        sound_alias = level.menu_close_sounds[player.menu_close_sound_index];
        if (isDefined(sound_alias) && sound_alias != "Sin Sonido")
        {
            player playLocalSound(sound_alias);
        }
    }
}






get_menu_open_sound_name(sound_index, lang_index)
{
    if (!isDefined(sound_index))
        sound_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; 

    sound_name = level.menu_open_sounds[sound_index];

    if (lang_index == 0) 
    {
        switch(sound_index)
        {
            case 0: return "Sin Sonido";
            case 1: return "Recarga Rápida";
            case 2: return "Corredera Adelante";
            case 3: return "Cargador Entrando";
            case 4: return "Recarga Assault";
            default: return sound_name;
        }
    }
    else 
    {
        switch(sound_index)
        {
            case 0: return "No Sound";
            case 1: return "Quick Reload";
            case 2: return "Slide Forward";
            case 3: return "Mag In";
            case 4: return "Assault Reload";
            default: return sound_name;
        }
    }
}


get_menu_close_sound_name(sound_index, lang_index)
{
    if (!isDefined(sound_index))
        sound_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; 

    sound_name = level.menu_close_sounds[sound_index];

    if (lang_index == 0) 
    {
        switch(sound_index)
        {
            case 0: return "Sin Sonido";
            case 1: return "Eyección Cargador";
            case 2: return "Corredera Atrás";
            case 3: return "Cargador Saliendo";
            case 4: return "Eyección Assault";
            case 5: return "Corredera Beretta Atrás";
            default: return sound_name;
        }
    }
    else 
    {
        switch(sound_index)
        {
            case 0: return "No Sound";
            case 1: return "Magazine Eject";
            case 2: return "Slide Back";
            case 3: return "Mag Out";
            case 4: return "Assault Eject";
            case 5: return "Beretta Slide Back";
            default: return sound_name;
        }
    }
}


change_menu_open_sound(player, new_sound_index)
{
    player.menu_open_sound_index = new_sound_index;
}


change_menu_close_sound(player, new_sound_index)
{
    player.menu_close_sound_index = new_sound_index;
}


get_menu_scroll_sound_name(sound_index, lang_index)
{
    if (!isDefined(sound_index))
        sound_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; 

    sound_name = level.menu_scroll_sounds[sound_index];

    if (lang_index == 0) 
    {
        switch(sound_index)
        {
            case 0: return "Sin Sonido";
            case 1: return "Navegación";
            case 2: return "Corredera Pistola";
            case 3: return "Cargador Entrando";
            case 4: return "Martillo Beretta";
            default: return sound_name;
        }
    }
    else 
    {
        switch(sound_index)
        {
            case 0: return "No Sound";
            case 1: return "Navigation";
            case 2: return "Pistol Slide";
            case 3: return "Mag In";
            case 4: return "Beretta Hammer";
            default: return sound_name;
        }
    }
}


get_menu_select_sound_name(sound_index, lang_index)
{
    if (!isDefined(sound_index))
        sound_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; 

    sound_name = level.menu_select_sounds[sound_index];

    if (lang_index == 0) 
    {
        switch(sound_index)
        {
            case 0: return "Sin Sonido";
            case 1: return "Confirmación";
            default: return sound_name;
        }
    }
    else 
    {
        switch(sound_index)
        {
            case 0: return "No Sound";
            case 1: return "Confirmation";
            default: return sound_name;
        }
    }
}


change_menu_scroll_sound(player, new_sound_index)
{
    player.menu_scroll_sound_index = new_sound_index;
}


change_menu_select_sound(player, new_sound_index)
{
    player.menu_select_sound_index = new_sound_index;
}
