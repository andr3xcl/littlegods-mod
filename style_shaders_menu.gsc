




#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;





init()
{
    
    precacheShader("gradient_center");
    precacheShader("gradient_top");
    precacheShader("gradient_bottom");
    precacheShader("gradient_fadein");
    precacheShader("overlay_low_health");
    precacheShader("postfx");
    precacheShader("checkerboard");
    precacheShader("logo");
    
    
    
    
    level.background_shaders = [];
    level.background_shaders[0] = "gradient_center";
    level.background_shaders[1] = "gradient_top";
    level.background_shaders[2] = "gradient_bottom";
    level.background_shaders[3] = "gradient_fadein";
    level.background_shaders[4] = "overlay_low_health";
    level.background_shaders[5] = "postfx";
    
    
    level.header_shaders = [];
    level.header_shaders[0] = "checkerboard";
    level.header_shaders[1] = "logo";
    level.header_shaders[2] = "postfx";
    
    
    level.selector_shaders = [];
    level.selector_shaders[0] = "postfx";
    
    level thread on_player_connect();
}

on_player_connect()
{
    for(;;)
    {
        level waittill("connected", player);
        
        
        if (!isDefined(player.background_shader_index))
            player.background_shader_index = 1; 
            
        if (!isDefined(player.header_shader_index))
            player.header_shader_index = -1; 
            
        if (!isDefined(player.selection_shader_index))
            player.selection_shader_index = -1; 
    }
}





get_background_shader_by_index(shader_index)
{
    if (!isDefined(shader_index) || shader_index < 0 || shader_index >= level.background_shaders.size)
        return "white";
    
    return level.background_shaders[shader_index];
}

get_header_shader_by_index(shader_index)
{
    if (!isDefined(shader_index) || shader_index < 0 || shader_index >= level.header_shaders.size)
        return "white";
    
    return level.header_shaders[shader_index];
}

get_selector_shader_by_index(shader_index)
{
    if (!isDefined(shader_index) || shader_index < 0 || shader_index >= level.selector_shaders.size)
        return "white";
    
    return level.selector_shaders[shader_index];
}

get_background_shader_name(shader_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
    
    if (!isDefined(shader_index) || shader_index < 0 || shader_index >= level.background_shaders.size)
        return (lang_index == 0) ? "Shader Desconocido" : "Unknown Shader";
    
    if (lang_index == 0) 
    {
        switch(shader_index)
        {
            case 0: return "Gradiente Central";
            case 1: return "Gradiente Superior";
            case 2: return "Gradiente Inferior";
            case 3: return "Gradiente Fade In";
            case 4: return "Overlay Baja Vida";
            case 5: return "Post-efecto";
            default: return "Shader " + shader_index;
        }
    }
    else 
    {
        switch(shader_index)
        {
            case 0: return "Center Gradient";
            case 1: return "Top Gradient";
            case 2: return "Bottom Gradient";
            case 3: return "Fade In Gradient";
            case 4: return "Low Health Overlay";
            case 5: return "Post-effect";
            default: return "Shader " + shader_index;
        }
    }
}

get_header_shader_name(shader_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
    
    if (!isDefined(shader_index) || shader_index < 0 || shader_index >= level.header_shaders.size)
        return (lang_index == 0) ? "Shader Desconocido" : "Unknown Shader";
    
    if (lang_index == 0) 
    {
        switch(shader_index)
        {
            case 0: return "Tablero Ajedrez";
            case 1: return "Logo Principal";
            case 2: return "Post-efecto";
            default: return "Shader " + shader_index;
        }
    }
    else 
    {
        switch(shader_index)
        {
            case 0: return "Checkerboard";
            case 1: return "Main Logo";
            case 2: return "Post-effect";
            default: return "Shader " + shader_index;
        }
    }
}

get_selector_shader_name(shader_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
    
    if (!isDefined(shader_index) || shader_index < 0 || shader_index >= level.selector_shaders.size)
        return (lang_index == 0) ? "Shader Desconocido" : "Unknown Shader";
    
    if (lang_index == 0) 
    {
        switch(shader_index)
        {
            case 0: return "Post-efecto";
            default: return "Shader " + shader_index;
        }
    }
    else 
    {
        switch(shader_index)
        {
            case 0: return "Post-effect";
            default: return "Shader " + shader_index;
        }
    }
}





get_background_shader_display_name(shader_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
        
    if (!isDefined(shader_index) || shader_index == -1)
    {
        return (lang_index == 0) ? "Ninguno" : "None";
    }
    
    return get_background_shader_name(shader_index, lang_index);
}

get_header_shader_display_name(shader_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
        
    if (!isDefined(shader_index) || shader_index == -1)
    {
        return (lang_index == 0) ? "Ninguno" : "None";
    }
    
    return get_header_shader_name(shader_index, lang_index);
}

get_selector_shader_display_name(shader_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
        
    if (!isDefined(shader_index) || shader_index == -1)
    {
        return (lang_index == 0) ? "Ninguno" : "None";
    }
    
    return get_selector_shader_name(shader_index, lang_index);
}





apply_menu_shaders(menu)
{
    if (!isDefined(menu) || !isDefined(menu.user))
        return menu;
        
    
    bg_shader = -1;
    header_shader = -1;
    selection_shader = -1;
    
    if (isDefined(menu.user.background_shader_index))
        bg_shader = menu.user.background_shader_index;
        
    if (isDefined(menu.user.header_shader_index))
        header_shader = menu.user.header_shader_index;
        
    if (isDefined(menu.user.selection_shader_index))
        selection_shader = menu.user.selection_shader_index;
    
    
    if (isDefined(menu.background))
    {
        shader_name = (bg_shader >= 0) ? get_background_shader_by_index(bg_shader) : "white";
        menu.background setShader(shader_name, menu.width, menu.header_height + (menu.item_height * menu.items.size));
    }

    
    if (isDefined(menu.header_bg))
    {
        shader_name = (header_shader >= 0) ? get_header_shader_by_index(header_shader) : "white";
        menu.header_bg setShader(shader_name, menu.width, menu.header_height);

        
        if (header_shader == 1 && isDefined(menu.title_text)) 
        {
            menu.title_text.alpha = 0;
            if (isDefined(menu.title_shadow))
                menu.title_shadow.alpha = 0;
        }
        else if (isDefined(menu.title_text)) 
        {
            menu.title_text.alpha = 1;
            if (isDefined(menu.title_shadow))
                menu.title_shadow.alpha = 0.4;
        }
    }

    
    if (isDefined(menu.selection_bar))
    {
        shader_name = (selection_shader >= 0) ? get_selector_shader_by_index(selection_shader) : "white";
        menu.selection_bar setShader(shader_name, menu.width, menu.item_height);
    }
    
    return menu;
}





cycle_background_shader(player)
{
    
    if (isDefined(player.edge_animation_style_index) && player.edge_animation_style_index > 0)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No se puede activar shaders mientras la animación de borde está activa");
        else
            player iPrintlnBold("^1Cannot activate shaders while edge animation is active");
        return;
    }

    
    if (has_conflicting_visual_systems_active(player))
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No se puede activar shaders mientras hay barras de vida o mods legacy activos");
        else
            player iPrintlnBold("^1Cannot activate shaders while health bars or legacy mods are active");
        return;
    }

    if (!isDefined(player.background_shader_index))
        player.background_shader_index = -1;

    player.background_shader_index++;

    
    max_shaders = level.background_shaders.size;
    if (player.background_shader_index >= max_shaders)
        player.background_shader_index = -1;
}

cycle_header_shader(player)
{
    
    if (isDefined(player.edge_animation_style_index) && player.edge_animation_style_index > 0)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No se puede activar shaders mientras la animación de borde está activa");
        else
            player iPrintlnBold("^1Cannot activate shaders while edge animation is active");
        return;
    }

    
    if (has_conflicting_visual_systems_active(player))
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No se puede activar shaders mientras hay barras de vida o mods legacy activos");
        else
            player iPrintlnBold("^1Cannot activate shaders while health bars or legacy mods are active");
        return;
    }

    if (!isDefined(player.header_shader_index))
        player.header_shader_index = -1;

    player.header_shader_index++;

    
    max_shaders = level.header_shaders.size;
    if (player.header_shader_index >= max_shaders)
        player.header_shader_index = -1;
}

cycle_selection_shader(player)
{
    
    if (isDefined(player.edge_animation_style_index) && player.edge_animation_style_index > 0)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No se puede activar shaders mientras la animación de borde está activa");
        else
            player iPrintlnBold("^1Cannot activate shaders while edge animation is active");
        return;
    }

    
    if (has_conflicting_visual_systems_active(player))
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No se puede activar shaders mientras hay barras de vida o mods legacy activos");
        else
            player iPrintlnBold("^1Cannot activate shaders while health bars or legacy mods are active");
        return;
    }

    if (!isDefined(player.selection_shader_index))
        player.selection_shader_index = -1;

    player.selection_shader_index++;

    
    max_shaders = level.selector_shaders.size;
    if (player.selection_shader_index >= max_shaders)
        player.selection_shader_index = -1;
}





has_active_shaders(player)
{
    
    if (isDefined(player.background_shader_index) && player.background_shader_index >= 0)
        return true;
    if (isDefined(player.header_shader_index) && player.header_shader_index >= 0)
        return true;
    if (isDefined(player.selection_shader_index) && player.selection_shader_index >= 0)
        return true;

    return false;
}

has_conflicting_visual_systems_active(player)
{
    
    if (isDefined(player.healthbar_enabled) && player.healthbar_enabled)
        return true;

    
    if (isDefined(player.healthbarzombie_enabled) && player.healthbarzombie_enabled)
        return true;

    
    if (isDefined(level.player_health_display) && level.player_health_display.enabled ||
        isDefined(level.zombie_health_display) && level.zombie_health_display.enabled ||
        isDefined(level.zombie_counter_display) && level.zombie_counter_display.enabled)
        return true;

    return false;
}

should_hide_title_for_logo_shader(player)
{
    
    return (isDefined(player.header_shader_index) && player.header_shader_index == 1);
}





reset_all_shaders(player)
{
    player.background_shader_index = -1;
    player.header_shader_index = -1;
    player.selection_shader_index = -1;
}

