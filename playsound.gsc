// Sistema de sonidos para el menú
// Gestiona sonidos de apertura, cierre y navegación del menú

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

// Inicialización del sistema de sonidos
init()
{
    // Definir sonidos disponibles para apertura del menú
    level.menu_open_sounds = [];
    level.menu_open_sounds[0] = "Sin Sonido";                    // No sound
    level.menu_open_sounds[1] = "fly_rgunmk2_magin";             // Sonido de recarga rápida
    level.menu_open_sounds[2] = "fly_1911_slide_forward";        // Sonido de corredera adelante
    level.menu_open_sounds[3] = "fly_1911_mag_in";               // Sonido de cargador entrando
    level.menu_open_sounds[4] = "fly_assault_reload_npc_mag_in"; // Sonido de recarga assault

    // Definir sonidos disponibles para cierre del menú
    level.menu_close_sounds = [];
    level.menu_close_sounds[0] = "Sin Sonido";                   // No sound
    level.menu_close_sounds[1] = "fly_rgunmk2_magout";           // Sonido de eyección de cargador
    level.menu_close_sounds[2] = "fly_1911_slide_back";          // Sonido de corredera atrás
    level.menu_close_sounds[3] = "fly_1911_mag_out";             // Sonido de cargador saliendo
    level.menu_close_sounds[4] = "fly_assault_reload_npc_mag_out"; // Sonido de eyección assault
    level.menu_close_sounds[5] = "fly_beretta93r_slide_back";     // Sonido de corredera beretta atrás

    // Definir sonidos disponibles para navegación/scroll del menú
    level.menu_scroll_sounds = [];
    level.menu_scroll_sounds[0] = "Sin Sonido";                   // No sound
    level.menu_scroll_sounds[1] = "uin_main_nav";                 // Sonido de navegación principal
    level.menu_scroll_sounds[2] = "fly_1911_slide_back";          // Sonido de corredera de pistola
    level.menu_scroll_sounds[3] = "fly_1911_mag_in";              // Sonido de cargador entrando
    level.menu_scroll_sounds[4] = "fly_beretta93r_hammer";         // Sonido de martillo beretta

    // Definir sonidos disponibles para selección de opciones del menú
    level.menu_select_sounds = [];
    level.menu_select_sounds[0] = "Sin Sonido";                   // No sound
    level.menu_select_sounds[1] = "fly_1911_mag_out";       
    level.menu_select_sounds[2] = "fly_beretta93r_hammer";        // Sonido de entrada/confirmación
}

// Reproducir sonido de apertura del menú
play_menu_open_sound(player)
{
    if (!isDefined(player.menu_open_sound_index))
        player.menu_open_sound_index = 1; // Por defecto fly_rgunmk2_magin

    if (player.menu_open_sound_index > 0)
    {
        sound_alias = level.menu_open_sounds[player.menu_open_sound_index];
        if (isDefined(sound_alias) && sound_alias != "Sin Sonido")
        {
            player playLocalSound(sound_alias);
        }
    }
}

// Reproducir sonido de navegación/scroll del menú
play_menu_scroll_sound(player)
{
    // Evitar sonidos demasiado frecuentes (máximo uno cada 0.1 segundos)
    current_time = getTime();
    if (isDefined(player.last_scroll_sound_time) && (current_time - player.last_scroll_sound_time) < 100)
        return;

    player.last_scroll_sound_time = current_time;

    if (!isDefined(player.menu_scroll_sound_index))
        player.menu_scroll_sound_index = 1; // Por defecto uin_main_nav

    if (player.menu_scroll_sound_index > 0)
    {
        sound_alias = level.menu_scroll_sounds[player.menu_scroll_sound_index];
        if (isDefined(sound_alias) && sound_alias != "Sin Sonido")
        {
            player playLocalSound(sound_alias);
        }
    }
}

// Reproducir sonido de selección de opción del menú
play_menu_select_sound(player)
{
    if (!isDefined(player.menu_select_sound_index))
        player.menu_select_sound_index = 1; // Por defecto uin_main_enter

    if (player.menu_select_sound_index > 0)
    {
        sound_alias = level.menu_select_sounds[player.menu_select_sound_index];
        if (isDefined(sound_alias) && sound_alias != "Sin Sonido")
        {
            player playLocalSound(sound_alias);
        }
    }
}

// Reproducir sonido de cierre del menú
play_menu_close_sound(player)
{
    if (!isDefined(player.menu_close_sound_index))
        player.menu_close_sound_index = 1; // Por defecto fly_rgunmk2_magout

    if (player.menu_close_sound_index > 0)
    {
        sound_alias = level.menu_close_sounds[player.menu_close_sound_index];
        if (isDefined(sound_alias) && sound_alias != "Sin Sonido")
        {
            player playLocalSound(sound_alias);
        }
    }
}

// ========================================
// FUNCIONES AUXILIARES
// ========================================

// Obtener el nombre del sonido de apertura según el índice y el idioma
get_menu_open_sound_name(sound_index, lang_index)
{
    if (!isDefined(sound_index))
        sound_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; // Español por defecto

    sound_name = level.menu_open_sounds[sound_index];

    if (lang_index == 0) // Español
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
    else // Inglés
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

// Obtener el nombre del sonido de cierre según el índice y el idioma
get_menu_close_sound_name(sound_index, lang_index)
{
    if (!isDefined(sound_index))
        sound_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; // Español por defecto

    sound_name = level.menu_close_sounds[sound_index];

    if (lang_index == 0) // Español
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
    else // Inglés
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

// Cambiar el sonido de apertura del menú
change_menu_open_sound(player, new_sound_index)
{
    player.menu_open_sound_index = new_sound_index;
}

// Cambiar el sonido de cierre del menú
change_menu_close_sound(player, new_sound_index)
{
    player.menu_close_sound_index = new_sound_index;
}

// Obtener el nombre del sonido de navegación/scroll según el índice y el idioma
get_menu_scroll_sound_name(sound_index, lang_index)
{
    if (!isDefined(sound_index))
        sound_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; // Español por defecto

    sound_name = level.menu_scroll_sounds[sound_index];

    if (lang_index == 0) // Español
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
    else // Inglés
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

// Obtener el nombre del sonido de selección según el índice y el idioma
get_menu_select_sound_name(sound_index, lang_index)
{
    if (!isDefined(sound_index))
        sound_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; // Español por defecto

    sound_name = level.menu_select_sounds[sound_index];

    if (lang_index == 0) // Español
    {
        switch(sound_index)
        {
            case 0: return "Sin Sonido";
            case 1: return "Confirmación";
            default: return sound_name;
        }
    }
    else // Inglés
    {
        switch(sound_index)
        {
            case 0: return "No Sound";
            case 1: return "Confirmation";
            default: return sound_name;
        }
    }
}

// Cambiar el sonido de navegación/scroll del menú
change_menu_scroll_sound(player, new_sound_index)
{
    player.menu_scroll_sound_index = new_sound_index;
}

// Cambiar el sonido de selección del menú
change_menu_select_sound(player, new_sound_index)
{
    player.menu_select_sound_index = new_sound_index;
}
