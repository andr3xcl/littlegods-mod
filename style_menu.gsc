


#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include scripts\zm\style_transparecy;


init()
{
    
    level.menu_styles = [];
    level.menu_styles[0] = "Modern Blue";       
    level.menu_styles[1] = "Classic";           
    level.menu_styles[2] = "Zombie";            
    level.menu_styles[3] = "Minimalist";        
    level.menu_styles[4] = "Neon";              
    level.menu_styles[5] = "Dark Mode";         
    level.menu_styles[6] = "Military";          
    level.menu_styles[7] = "Rainbow";           
    
    level.menu_styles[8] = "Futuristic";        
    level.menu_styles[9] = "Elegant";           
    level.menu_styles[10] = "Cyberpunk";        
    level.menu_styles[11] = "Aqua";             
    
    level.menu_styles[12] = "Retro Arcade";     
    level.menu_styles[13] = "Polar Ice";        
    level.menu_styles[14] = "Inferno";          
    level.menu_styles[15] = "Nature";           
    level.menu_styles[16] = "Halloween";        
    level.menu_styles[17] = "Christmas";        
    
    level.menu_styles[18] = "Galaxy";           
    level.menu_styles[19] = "Tropical";         
    level.menu_styles[20] = "Metal";            
    level.menu_styles[21] = "Vampire";          
    level.menu_styles[22] = "Toxic";            
    level.menu_styles[23] = "Pastel";           
    
    level.menu_styles[24] = "Desert";           
    level.menu_styles[25] = "Ocean Deep";       
    level.menu_styles[26] = "Nuke";             
    level.menu_styles[27] = "Gold Elite";       
    level.menu_styles[28] = "Frozen";           
    level.menu_styles[29] = "Retro TV";         
    
    level.menu_styles[30] = "Sunset";           
    level.menu_styles[31] = "Matrix";           
    level.menu_styles[32] = "Steampunk";        
    level.menu_styles[33] = "Blood Moon";       
    level.menu_styles[34] = "Synthwave";        
    level.menu_styles[35] = "Comic";            
    
    level.menu_styles[36] = "Pixel Art";        
    level.menu_styles[37] = "Graffiti";         
    level.menu_styles[38] = "Vaporwave";        
    level.menu_styles[39] = "Enchanted Forest";  
    level.menu_styles[40] = "Ancient Egypt";     
    level.menu_styles[41] = "Neon Retro";        
    level.menu_styles[42] = "Hologram";          
    
    level.menu_styles[43] = "Crystal Glass";     
    level.menu_styles[44] = "Velvet Noir";       
    level.menu_styles[45] = "Aurora Borealis";   
    level.menu_styles[46] = "Marble Luxe";       
    level.menu_styles[47] = "Neon City";         
    level.menu_styles[48] = "Sakura Blossom";    
    level.menu_styles[49] = "Deep Space";        
    level.menu_styles[50] = "Coral Reef";        
    level.menu_styles[51] = "Royal Purple";      
    level.menu_styles[52] = "Sunrise Gradient";  
    
    level.menu_styles[53] = "Blueprint";
    level.menu_styles[54] = "Amber Terminal";
    level.menu_styles[55] = "Monochrome";
    level.menu_styles[56] = "Parchment";
    level.menu_styles[57] = "Graphite";
    level.menu_styles[58] = "Espresso";
    level.menu_styles[59] = "Lilac";
    level.menu_styles[60] = "Mint";
    level.menu_styles[61] = "Imperial Red";
    level.menu_styles[62] = "White Gold";
    level.menu_styles[63] = "Storm";
    level.menu_styles[64] = "Cotton Candy";
    level.menu_styles[65] = "Midnight Violet";
    level.menu_styles[66] = "Sunburst";
    level.menu_styles[67] = "Titanium";
    
    level.menu_styles[68] = "Emerald City";
    level.menu_styles[69] = "Ruby Red";
    level.menu_styles[70] = "Sapphire Blue";
    level.menu_styles[71] = "Obsidian";
    level.menu_styles[72] = "Pearl";
    level.menu_styles[73] = "Carbon Fiber";
    level.menu_styles[74] = "Magma";
    level.menu_styles[75] = "Glitch";
    level.menu_styles[76] = "Biohazard";
    level.menu_styles[77] = "Radioactive";
    level.menu_styles[78] = "Void";
    level.menu_styles[79] = "Zen";
    level.menu_styles[80] = "Nordic";
    level.menu_styles[81] = "Solar Flare";
    level.menu_styles[82] = "Nebula";
}


apply_menu_style(menu, style_index)
{
    if (!isDefined(style_index))
        style_index = 0; 

    
    stop_rainbow_effect(menu);
    stop_aurora_effect(menu);

    
    menu.style_index = style_index;

    
    switch(style_index)
    {
        case 0:
            apply_modern_blue_style(menu);
            break;
        case 1:
            apply_classic_style(menu);
            break;
        case 2:
            apply_zombie_style(menu);
            break;
        case 3:
            apply_minimalist_style(menu);
            break;
        case 4:
            apply_neon_style(menu);
            break;
        case 5:
            apply_dark_mode_style(menu);
            break;
        case 6:
            apply_military_style(menu);
            break;
        case 7:
            apply_rainbow_style(menu);
            break;
        
        case 8:
            apply_futuristic_style(menu);
            break;
        case 9:
            apply_elegant_style(menu);
            break;
        case 10:
            apply_cyberpunk_style(menu);
            break;
        case 11:
            apply_aqua_style(menu);
            break;
        
        case 12:
            apply_retro_arcade_style(menu);
            break;
        case 13:
            apply_polar_ice_style(menu);
            break;
        case 14:
            apply_inferno_style(menu);
            break;
        case 15:
            apply_nature_style(menu);
            break;
        case 16:
            apply_halloween_style(menu);
            break;
        case 17:
            apply_christmas_style(menu);
            break;
        
        case 18:
            apply_galaxy_style(menu);
            break;
        case 19:
            apply_tropical_style(menu);
            break;
        case 20:
            apply_metal_style(menu);
            break;
        case 21:
            apply_vampire_style(menu);
            break;
        case 22:
            apply_toxic_style(menu);
            break;
        case 23:
            apply_pastel_style(menu);
            break;
        
        case 24:
            apply_desert_style(menu);
            break;
        case 25:
            apply_ocean_deep_style(menu);
            break;
        case 26:
            apply_nuke_style(menu);
            break;
        case 27:
            apply_gold_elite_style(menu);
            break;
        case 28:
            apply_frozen_style(menu);
            break;
        case 29:
            apply_retro_tv_style(menu);
            break;
        
        case 30:
            apply_sunset_style(menu);
            break;
        case 31:
            apply_matrix_style(menu);
            break;
        case 32:
            apply_steampunk_style(menu);
            break;
        case 33:
            apply_blood_moon_style(menu);
            break;
        case 34:
            apply_synthwave_style(menu);
            break;
        case 35:
            apply_comic_style(menu);
            break;
        
        case 36:
            apply_pixel_art_style(menu);
            break;
        case 37:
            apply_graffiti_style(menu);
            break;
        case 38:
            apply_vaporwave_style(menu);
            break;
        case 39:
            apply_enchanted_forest_style(menu);
            break;
        case 40:
            apply_ancient_egypt_style(menu);
            break;
        case 41:
            apply_neon_retro_style(menu);
            break;
        case 42:
            apply_hologram_style(menu);
            break;
        
        case 43:
            apply_crystal_glass_style(menu);
            break;
        case 44:
            apply_velvet_noir_style(menu);
            break;
        case 45:
            apply_aurora_borealis_style(menu);
            break;
        case 46:
            apply_marble_luxe_style(menu);
            break;
        case 47:
            apply_neon_city_style(menu);
            break;
        case 48:
            apply_sakura_blossom_style(menu);
            break;
        case 49:
            apply_deep_space_style(menu);
            break;
        case 50:
            apply_coral_reef_style(menu);
            break;
        case 51:
            apply_royal_purple_style(menu);
            break;
        case 52:
            apply_sunrise_gradient_style(menu);
            break;
            
        case 53: apply_blueprint_style(menu); break;
        case 54: apply_amber_terminal_style(menu); break;
        case 55: apply_monochrome_style(menu); break;
        case 56: apply_parchment_style(menu); break;
        case 57: apply_graphite_style(menu); break;
        case 58: apply_espresso_style(menu); break;
        case 59: apply_lilac_style(menu); break;
        case 60: apply_mint_style(menu); break;
        case 61: apply_imperial_red_style(menu); break;
        case 62: apply_white_gold_style(menu); break;
        case 63: apply_storm_style(menu); break;
        case 64: apply_cotton_candy_style(menu); break;
        case 65: apply_midnight_violet_style(menu); break;
        case 66: apply_sunburst_style(menu); break;
        case 67: apply_titanium_style(menu); break;

        case 68: apply_emerald_city_style(menu); break;
        case 69: apply_ruby_red_style(menu); break;
        case 70: apply_sapphire_blue_style(menu); break;
        case 71: apply_obsidian_style(menu); break;
        case 72: apply_pearl_style(menu); break;
        case 73: apply_carbon_fiber_style(menu); break;
        case 74: apply_magma_style(menu); break;
        case 75: apply_glitch_style(menu); break;
        case 76: apply_biohazard_style(menu); break;
        case 77: apply_radioactive_style(menu); break;
        case 78: apply_void_style(menu); break;
        case 79: apply_zen_style(menu); break;
        case 80: apply_nordic_style(menu); break;
        case 81: apply_solar_flare_style(menu); break;
        case 82: apply_nebula_style(menu); break;

        default:
            apply_modern_blue_style(menu); 
    }


    
    if (isDefined(menu.user) && isDefined(menu.user.transparency_index) && menu.user.transparency_index > 0)
    {
        menu = scripts\zm\style_transparecy::apply_transparency(menu, menu.user.transparency_index);
    }

    
    menu = apply_custom_dimensions(menu);

    return menu;
}


get_style_name(style_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
        
    if (lang_index == 0) 
    {
        switch(style_index)
        {
            case 0: return "Azul Moderno";
            case 1: return "Clásico";
            case 2: return "Zombie";
            case 3: return "Minimalista";
            case 4: return "Neón";
            case 5: return "Modo Oscuro";
            case 6: return "Militar";
            case 7: return "Arcoíris";
            
            case 8: return "Futurista";
            case 9: return "Elegante";
            case 10: return "Cyberpunk";
            case 11: return "Aqua";
            
            case 12: return "Arcade Retro";
            case 13: return "Hielo Polar";
            case 14: return "Infierno";
            case 15: return "Naturaleza";
            case 16: return "Halloween";
            case 17: return "Navidad";
            
            case 18: return "Galaxia";
            case 19: return "Tropical";
            case 20: return "Metal";
            case 21: return "Vampiro";
            case 22: return "Tóxico";
            case 23: return "Pastel";
            
            case 24: return "Desierto";
            case 25: return "Océano Profundo";
            case 26: return "Nuclear";
            case 27: return "Oro Elite";
            case 28: return "Congelado";
            case 29: return "TV Retro";
            
            case 30: return "Atardecer";
            case 31: return "Matrix";
            case 32: return "Steampunk";
            case 33: return "Luna Sangrienta";
            case 34: return "Synthwave";
            case 35: return "Cómic";
            
            case 36: return "Pixel Art";
            case 37: return "Grafiti";
            case 38: return "Vaporwave";
            case 39: return "Bosque Encantado";
            case 40: return "Egipto Antiguo";
            case 41: return "Neón Retro";
            case 42: return "Holograma";
            
            case 43: return "Cristal Vidrio";
            case 44: return "Terciopelo Negro";
            case 45: return "Aurora Boreal";
            case 46: return "Mármol Lujo";
            case 47: return "Neón Ciudad";
            case 48: return "Flor Sakura";
            case 49: return "Espacio Profundo";
            case 50: return "Arrecife Coral";
            case 51: return "Púrpura Real";
            case 52: return "Gradiente Amanecer";
            
            case 53: return "Plano Azul";
            case 54: return "Terminal Ámbar";
            case 55: return "Monocromo";
            case 56: return "Pergamino";
            case 57: return "Grafito";
            case 58: return "Expreso";
            case 59: return "Lila";
            case 60: return "Menta";
            case 61: return "Rojo Imperial";
            case 62: return "Oro Blanco";
            case 63: return "Tormenta";
            case 64: return "Algodón de Azúcar";
            case 65: return "Violeta Medianoche";
            case 66: return "Rayo de Sol";
            case 67: return "Titanio";
            
            case 68: return "Ciudad Esmeralda";
            case 69: return "Rojo Rubí";
            case 70: return "Azul Zafiro";
            case 71: return "Obsidiana";
            case 72: return "Perla";
            case 73: return "Fibra de Carbono";
            case 74: return "Magma";
            case 75: return "Glitch";
            case 76: return "Biohazard";
            case 77: return "Radiactivo";
            case 78: return "Vacío";
            case 79: return "Zen";
            case 80: return "Nórdico";
            case 81: return "Llamarada Solar";
            case 82: return "Nebulosa";
            
            default: return "Desconocido";
        }
    }
    else 
    {
        switch(style_index)
        {
            case 0: return "Modern Blue";
            case 1: return "Classic";
            case 2: return "Zombie";
            case 3: return "Minimalist";
            case 4: return "Neon";
            case 5: return "Dark Mode";
            case 6: return "Military";
            case 7: return "Rainbow";
            
            case 8: return "Futuristic";
            case 9: return "Elegant";
            case 10: return "Cyberpunk";
            case 11: return "Aqua";
            
            case 12: return "Retro Arcade";
            case 13: return "Polar Ice";
            case 14: return "Inferno";
            case 15: return "Nature";
            case 16: return "Halloween";
            case 17: return "Christmas";
            
            case 18: return "Galaxy";
            case 19: return "Tropical";
            case 20: return "Metal";
            case 21: return "Vampire";
            case 22: return "Toxic";
            case 23: return "Pastel";
            
            case 24: return "Desert";
            case 25: return "Ocean Deep";
            case 26: return "Nuke";
            case 27: return "Gold Elite";
            case 28: return "Frozen";
            case 29: return "Retro TV";
            
            case 30: return "Sunset";
            case 31: return "Matrix";
            case 32: return "Steampunk";
            case 33: return "Blood Moon";
            case 34: return "Synthwave";
            case 35: return "Comic";
            
            case 36: return "Pixel Art";
            case 37: return "Graffiti";
            case 38: return "Vaporwave";
            case 39: return "Enchanted Forest";
            case 40: return "Ancient Egypt";
            case 41: return "Neon Retro";
            case 42: return "Hologram";
            
            case 43: return "Crystal Glass";
            case 44: return "Velvet Noir";
            case 45: return "Aurora Borealis";
            case 46: return "Marble Luxe";
            case 47: return "Neon City";
            case 48: return "Sakura Blossom";
            case 49: return "Deep Space";
            case 50: return "Coral Reef";
            case 51: return "Royal Purple";
            case 52: return "Sunrise Gradient";
            
            case 53: return "Blueprint";
            case 54: return "Amber Terminal";
            case 55: return "Monochrome";
            case 56: return "Parchment";
            case 57: return "Graphite";
            case 58: return "Espresso";
            case 59: return "Lilac";
            case 60: return "Mint";
            case 61: return "Imperial Red";
            case 62: return "White Gold";
            case 63: return "Storm";
            case 64: return "Cotton Candy";
            case 65: return "Midnight Violet";
            case 66: return "Sunburst";
            case 67: return "Titanium";
            
            case 68: return "Emerald City";
            case 69: return "Ruby Red";
            case 70: return "Sapphire Blue";
            case 71: return "Obsidian";
            case 72: return "Pearl";
            case 73: return "Carbon Fiber";
            case 74: return "Magma";
            case 75: return "Glitch";
            case 76: return "Biohazard";
            case 77: return "Radioactive";
            case 78: return "Void";
            case 79: return "Zen";
            case 80: return "Nordic";
            case 81: return "Solar Flare";
            case 82: return "Nebula";
            
            default: return "Unknown";
        }
    }
}


apply_modern_blue_style(menu)
{

    menu.header_color = (0.1, 0.45, 0.85);
    menu.active_color = (0.1, 0.45, 0.85);
    menu.inactive_color = (1, 1, 1);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0, 0, 0);


    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.75; 
    menu.header_alpha = 0.98; 

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_classic_style(menu)
{

    menu.header_color = (1, 1, 0);
    menu.active_color = (1, 1, 0);
    menu.inactive_color = (0.9, 0.9, 0.9);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.2, 0.2, 0.2);


    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_zombie_style(menu)
{

    menu.header_color = (0.7, 0.1, 0.1);
    menu.active_color = (0.7, 0.1, 0.1);
    menu.inactive_color = (0.8, 0.8, 0.6);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.1, 0.1, 0.1);


    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_minimalist_style(menu)
{

    menu.header_color = (0.9, 0.9, 0.9);
    menu.active_color = (0.9, 0.9, 0.9);
    menu.inactive_color = (0.7, 0.7, 0.7);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.15, 0.15, 0.15);


    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.6;
    menu.header_alpha = 0.7;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_neon_style(menu)
{
    
    menu.header_color = (1, 0.2, 0.8);      
    menu.active_color = (1, 0.2, 0.8);      
    menu.inactive_color = (0.7, 0.9, 1);    
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.05, 0.05, 0.1);      
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.8;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_dark_mode_style(menu)
{
    
    menu.header_color = (0.15, 0.15, 0.15); 
    menu.active_color = (0.15, 0.15, 0.15);      
    menu.inactive_color = (0.6, 0.6, 0.6);  
    menu.title_color = (1, 1, 1);       
    menu.bg_color = (0.05, 0.05, 0.05);     

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22; 

    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 0.98; 

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_military_style(menu)
{
    
    menu.header_color = (0.6, 0.6, 0.2);   
    menu.active_color = (0.6, 0.6, 0.2);    
    menu.inactive_color = (0.8, 0.8, 0.7);  
    menu.title_color = (1, 1, 1);     
    menu.bg_color = (0.15, 0.15, 0.1);      
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_rainbow_style(menu)
{
    
    

    
    menu.header_color = (1, 0.5, 0);          
    menu.active_color = (1, 0.5, 0);        
    menu.inactive_color = (1, 1, 1);        
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.1, 0, 0.2);          

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22; 

    
    menu.bg_alpha = 0.8; 
    menu.header_alpha = 0.98; 

    
    menu.has_border = false;

    
    update_menu_visuals(menu);

    
    if (!isDefined(menu.rainbow_active))
    {
        menu.rainbow_active = true;
        menu.user thread rainbow_effect(menu);
    }
}


rainbow_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_rainbow");

    hue = 0;

    while(isDefined(menu.rainbow_active) && menu.rainbow_active)
    {
        
        hue += 0.01;
        if (hue > 1) hue = 0;

        
        header_color = hsv_to_rgb(hue, 0.8, 0.8);
        
        selection_color = hsv_to_rgb((hue + 0.2) % 1, 0.9, 0.9);

        
        menu.header_color = header_color;
        menu.active_color = selection_color;

        
        if (isDefined(menu.header_bg))
        {
            menu.header_bg.color = header_color;
            menu.header_bg.alpha = 0.98; 
        }

        if (isDefined(menu.header_border_top))
        {
            menu.header_border_top.color = selection_color; 
        }

        if (isDefined(menu.selection_bar))
            menu.selection_bar.color = selection_color;

        
        if (isDefined(menu.title_text))
        {
            hide_title = scripts\zm\style_shaders_menu::should_hide_title_for_logo_shader(menu.user);
            menu.title_text.alpha = hide_title ? 0 : 1;
        }

        wait 0.05; 
    }
}


hsv_to_rgb(h, s, v)
{
    
    
    
    if (s == 0)
        return (v, v, v); 
    
    h = h * 6; 
    i = int(h);
    f = h - i;
    
    p = v * (1 - s);
    q = v * (1 - (s * f));
    t = v * (1 - (s * (1 - f)));
    
    switch(i % 6)
    {
        case 0: return (v, t, p);
        case 1: return (q, v, p);
        case 2: return (p, v, t);
        case 3: return (p, q, v);
        case 4: return (t, p, v);
        case 5: return (v, p, q);
        default: return (v, t, p);
    }
}


update_menu_visuals(menu)
{
    
    if (!isDefined(menu.background))
    {
        menu.background = newClientHudElem(menu.user);
        menu.background.vertalign = "top";
        menu.background.horzalign = "left";
        menu.background.x = 0; 
        menu.background.y = 120; 
    }

    if (!isDefined(menu.header_bg))
    {
        menu.header_bg = newClientHudElem(menu.user);
        menu.header_bg.vertalign = "top";
        menu.header_bg.horzalign = "left";
        menu.header_bg.x = menu.background.x;
        menu.header_bg.y = menu.background.y;
    }

    if (!isDefined(menu.header_border_top))
    {
        menu.header_border_top = newClientHudElem(menu.user);
        menu.header_border_top.vertalign = "top";
        menu.header_border_top.horzalign = "left";
        menu.header_border_top.x = menu.background.x;
        menu.header_border_top.y = menu.background.y;
    }

    if (!isDefined(menu.title_text))
    {
        menu.title_text = newClientHudElem(menu.user);
        menu.title_text.vertalign = "top";
        menu.title_text.horzalign = "left";
        menu.title_text.x = menu.background.x + 12; 
        menu.title_text.y = menu.background.y + 3;
        menu.title_text.fontscale = 1.5;
        menu.title_text setTextUnlimited(menu.title);
    }

    if (!isDefined(menu.title_shadow))
    {
        menu.title_shadow = newClientHudElem(menu.user);
        menu.title_shadow.vertalign = "top";
        menu.title_shadow.horzalign = "left";
        menu.title_shadow.x = menu.background.x + 14;
        menu.title_shadow.y = menu.background.y + 5;
        menu.title_shadow.fontscale = 1.5;
        menu.title_shadow setTextUnlimited(menu.title);
    }

    if (!isDefined(menu.selection_bar))
    {
        menu.selection_bar = newClientHudElem(menu.user);
        menu.selection_bar.vertalign = "top";
        menu.selection_bar.horzalign = "left";
        menu.selection_bar.x = menu.background.x;
        menu.selection_bar.y = menu.background.y + menu.header_height;
        menu.selection_bar.alpha = 0.6;
    }

    
    if (isDefined(menu.border_top))
    {
        menu.border_top.alpha = 0;
        menu.border_bottom.alpha = 0;
        menu.border_left.alpha = 0;
        menu.border_right.alpha = 0;
    }

    
    original_x = menu.background.x;
    original_y = menu.background.y;

    
    menu.background.alpha = menu.bg_alpha;
    menu.background.color = menu.bg_color;
    
    total_height = menu.header_height + (menu.item_height * menu.items.size);
    menu.background setShader("white", menu.width, total_height);

    
    menu.header_bg.x = original_x;
    menu.header_bg.y = original_y;
    menu.header_bg.alpha = menu.header_alpha;
    menu.header_bg.color = menu.header_color;
    menu.header_bg setShader("white", menu.width, menu.header_height);

    
    if (isDefined(menu.header_bg))
    {
        menu.header_bg.color = menu.header_color;
        menu.header_bg.alpha = menu.header_alpha;
    }

    
    if (isDefined(menu.has_border) && menu.has_border)
    {
        menu.header_border_top.x = original_x;
        menu.header_border_top.y = original_y;
        menu.header_border_top.alpha = 1;
        menu.header_border_top.color = menu.active_color; 
        menu.header_border_top setShader("white", menu.width, 1);
    }
    else
    {
        
        menu.header_border_top.alpha = 0;
    }

    
    
    if (!isDefined(menu.font_position_index) || menu.font_position_index == 0)
    {
        menu.title_text.x = original_x + 12; 
        menu.title_text.alignX = "left";
    }
    menu.title_text.y = original_y + 3;
    menu.title_text.color = menu.title_color;

    
    hide_title = scripts\zm\style_shaders_menu::should_hide_title_for_logo_shader(menu.user);
    menu.title_text.alpha = hide_title ? 0 : 1;
    menu.title_text.sort = 2;

    if (!isDefined(menu.font_position_index) || menu.font_position_index == 0)
    {
        menu.title_shadow.x = original_x + 14;
        menu.title_shadow.alignX = "left";
    }
    menu.title_shadow.y = original_y + 5;
    menu.title_shadow.color = (0, 0, 0);
    menu.title_shadow.alpha = hide_title ? 0 : 0.4;
    menu.title_shadow.sort = 0; 

    
    menu.selection_bar.x = original_x;
    if (isDefined(menu.selected))
    {
        menu.selection_bar.y = original_y + menu.header_height + (menu.item_height * menu.selected);
    }
    menu.selection_bar.color = menu.header_color;
    menu.selection_bar setShader("white", menu.width, menu.item_height);

    
    if (isDefined(menu.selection_bar))
    {
        menu.selection_bar.color = menu.header_color;
    }

    
    for (i = 0; i < menu.items.size; i++)
    {
        if (isDefined(menu.items[i].item))
        {
            
            if (!isDefined(menu.font_position_index) || menu.font_position_index == 0)
            {
                
                if (menu.items[i].item.horzalign == "center")
                {
                    
                    menu.items[i].item.x = original_x + (menu.width / 2);
                    menu.items[i].item.alignX = "center";
                }
                else
                {
                    
                    menu.items[i].item.x = original_x + 15; 
                    menu.items[i].item.alignX = "left";
                }
            }

            menu.items[i].item.y = original_y + menu.header_height + (menu.item_height * i) + (menu.item_height / 2) - 6;
            menu.items[i].item.color = (i == menu.selected) ? (1, 1, 1) : menu.inactive_color; 
        }
    }

    
    if (isDefined(menu.font_position_index) && menu.font_position_index > 0)
    {
        menu = scripts\zm\style_font_position::update_menu_visuals_with_position(menu);
    }

    
    return menu;
}


stop_rainbow_effect(menu)
{
    if (isDefined(menu.rainbow_active) && menu.rainbow_active)
    {
        menu.rainbow_active = false;
        menu notify("stop_rainbow");
    }
}


apply_futuristic_style(menu)
{
    
    menu.header_color = (0.0, 0.45, 0.85);      
    menu.active_color = (0.0, 0.45, 0.85);      
    menu.inactive_color = (0.8, 0.95, 1.0);  
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.0, 0.05, 0.1);     
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_elegant_style(menu)
{
    
    menu.header_color = (0.85, 0.7, 0.2);   
    menu.active_color = (0.85, 0.7, 0.2);   
    menu.inactive_color = (1.0, 0.95, 0.8);  
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.08, 0.07, 0.02);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_cyberpunk_style(menu)
{
    
    menu.header_color = (1.0, 0.0, 0.5);    
    menu.active_color = (1.0, 0.0, 0.5);      
    menu.inactive_color = (1.0, 0.8, 0.9); 
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.1, 0.0, 0.05);         
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_aqua_style(menu)
{
    
    menu.header_color = (0.0, 0.6, 0.6);      
    menu.active_color = (0.0, 0.6, 0.6);      
    menu.inactive_color = (0.8, 1.0, 1.0);      
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.0, 0.06, 0.06);      
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.8;
    menu.header_alpha = 0.95;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_retro_arcade_style(menu)
{
    
    menu.header_color = (0.7, 0.0, 1.0);      
    menu.active_color = (0.7, 0.0, 1.0);      
    menu.inactive_color = (0.9, 0.8, 1.0);  
    menu.title_color = (1, 1, 1);          
    menu.bg_color = (0.07, 0.0, 0.1);            
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_polar_ice_style(menu)
{
    
    menu.header_color = (0.6, 0.8, 1.0);      
    menu.active_color = (0.6, 0.8, 1.0);    
    menu.inactive_color = (0.9, 0.98, 1.0);   
    menu.title_color = (1, 1, 1);     
    menu.bg_color = (0.06, 0.08, 0.1);      
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.8;
    menu.header_alpha = 0.9;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_inferno_style(menu)
{
    
    menu.header_color = (0.9, 0.1, 0.0);      
    menu.active_color = (0.9, 0.1, 0.0);        
    menu.inactive_color = (1.0, 0.9, 0.8);    
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.09, 0.01, 0.0);            
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_nature_style(menu)
{
    
    menu.header_color = (0.1, 0.6, 0.2);    
    menu.active_color = (0.1, 0.6, 0.2);    
    menu.inactive_color = (0.8, 1.0, 0.85);  
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.01, 0.06, 0.02);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.95;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_halloween_style(menu)
{
    
    menu.header_color = (1.0, 0.4, 0.0);      
    menu.active_color = (1.0, 0.4, 0.0);      
    menu.inactive_color = (1.0, 0.85, 0.7);  
    menu.title_color = (1, 1, 1);         
    menu.bg_color = (0.1, 0.04, 0.0);       
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_christmas_style(menu)
{
    
    menu.header_color = (0.8, 0.0, 0.0);    
    menu.active_color = (0.8, 0.0, 0.0);    
    menu.inactive_color = (1.0, 0.9, 0.9);        
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.08, 0.0, 0.0);      
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_galaxy_style(menu)
{
    
    menu.header_color = (0.4, 0.0, 0.6);    
    menu.active_color = (0.4, 0.0, 0.6);      
    menu.inactive_color = (0.9, 0.8, 1.0);    
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.04, 0.0, 0.06);     
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 0.95;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_tropical_style(menu)
{
    
    menu.header_color = (0.0, 0.7, 0.8);      
    menu.active_color = (0.0, 0.7, 0.8);        
    menu.inactive_color = (0.8, 1.0, 1.0);      
    menu.title_color = (1, 1, 1);         
    menu.bg_color = (0.0, 0.07, 0.08);          
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.8;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_metal_style(menu)
{
    
    menu.header_color = (0.5, 0.55, 0.6);    
    menu.active_color = (0.5, 0.55, 0.6);    
    menu.inactive_color = (0.9, 0.9, 0.95);  
    menu.title_color = (1, 1, 1);    
    menu.bg_color = (0.05, 0.055, 0.06);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_vampire_style(menu)
{
    
    menu.header_color = (0.6, 0.0, 0.0);        
    menu.active_color = (0.6, 0.0, 0.0);        
    menu.inactive_color = (1.0, 0.8, 0.8);  
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.06, 0.0, 0.0);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_toxic_style(menu)
{
    
    menu.header_color = (0.4, 0.9, 0.0);      
    menu.active_color = (0.4, 0.9, 0.0);        
    menu.inactive_color = (0.9, 1.0, 0.8);    
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.04, 0.09, 0.0);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_pastel_style(menu)
{
    
    menu.header_color = (1.0, 0.7, 0.8);    
    menu.active_color = (1.0, 0.7, 0.8);    
    menu.inactive_color = (1.0, 0.9, 0.95);  
    menu.title_color = (1, 1, 1);     
    menu.bg_color = (0.1, 0.07, 0.08);           
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_desert_style(menu)
{
    
    menu.header_color = (0.8, 0.5, 0.2);    
    menu.active_color = (0.8, 0.5, 0.2);    
    menu.inactive_color = (1.0, 0.95, 0.8); 
    menu.title_color = (1, 1, 1);    
    menu.bg_color = (0.08, 0.05, 0.02);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.95;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_ocean_deep_style(menu)
{
    
    menu.header_color = (0.0, 0.1, 0.3);    
    menu.active_color = (0.0, 0.1, 0.3);      
    menu.inactive_color = (0.8, 0.9, 1.0);  
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.0, 0.01, 0.03);       
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_nuke_style(menu)
{
    
    menu.header_color = (1.0, 0.9, 0.0);      
    menu.active_color = (1.0, 0.9, 0.0);      
    menu.inactive_color = (1.0, 1.0, 0.8);  
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.1, 0.09, 0.0);     
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_gold_elite_style(menu)
{
    
    menu.header_color = (0.8, 0.7, 0.2);    
    menu.active_color = (0.8, 0.7, 0.2);     
    menu.inactive_color = (1.0, 0.95, 0.8); 
    menu.title_color = (1, 1, 1);     
    menu.bg_color = (0.08, 0.07, 0.02);       
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_frozen_style(menu)
{
    
    menu.header_color = (0.6, 0.8, 1.0);      
    menu.active_color = (0.6, 0.8, 1.0);      
    menu.inactive_color = (0.9, 0.98, 1.0);   
    menu.title_color = (1, 1, 1);     
    menu.bg_color = (0.06, 0.08, 0.1);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_retro_tv_style(menu)
{
    
    menu.header_color = (0.3, 0.3, 0.3);    
    menu.active_color = (0.3, 0.3, 0.3);    
    menu.inactive_color = (0.8, 0.8, 0.8);  
    menu.title_color = (1, 1, 1);      
    menu.bg_color = (0.03, 0.03, 0.03);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_sunset_style(menu)
{
    
    menu.header_color = (0.6, 0.3, 0.5);      
    menu.active_color = (0.6, 0.3, 0.5);      
    menu.inactive_color = (1.0, 0.9, 0.95);  
    menu.title_color = (1, 1, 1);       
    menu.bg_color = (0.06, 0.03, 0.05);       
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_matrix_style(menu)
{
    
    menu.header_color = (0.0, 0.8, 0.0);        
    menu.active_color = (0.0, 0.8, 0.0);        
    menu.inactive_color = (0.8, 1.0, 0.8);  
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.0, 0.08, 0.0);              
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.8;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_steampunk_style(menu)
{
    
    menu.header_color = (0.6, 0.4, 0.2);    
    menu.active_color = (0.6, 0.4, 0.2);    
    menu.inactive_color = (0.95, 0.9, 0.8);  
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.06, 0.04, 0.02);       
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.8;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_blood_moon_style(menu)
{
    
    menu.header_color = (0.6, 0.0, 0.0);      
    menu.active_color = (0.6, 0.0, 0.0);        
    menu.inactive_color = (1.0, 0.8, 0.8);    
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.06, 0.0, 0.0);            
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_synthwave_style(menu)
{
    
    menu.header_color = (1.0, 0.0, 0.8);    
    menu.active_color = (1.0, 0.0, 0.8);      
    menu.inactive_color = (1.0, 0.8, 0.95); 
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.1, 0.0, 0.08);         
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_comic_style(menu)
{
    
    menu.header_color = (1.0, 0.2, 0.2);    
    menu.active_color = (1.0, 0.2, 0.2);    
    menu.inactive_color = (1.0, 0.9, 0.9);  
    menu.title_color = (1, 1, 1);    
    menu.bg_color = (0.1, 0.02, 0.02);           
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_pixel_art_style(menu)
{
    
    menu.header_color = (0.2, 0.2, 0.8);    
    menu.active_color = (0.2, 0.2, 0.8);      
    menu.inactive_color = (0.9, 0.9, 1.0);  
    menu.title_color = (1, 1, 1);           
    menu.bg_color = (0.02, 0.02, 0.08);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 1.0;     
    menu.header_alpha = 1.0;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_graffiti_style(menu)
{
    
    menu.header_color = (1.0, 0.0, 0.4);    
    menu.active_color = (1.0, 0.0, 0.4);      
    menu.inactive_color = (1.0, 0.8, 0.9);  
    menu.title_color = (1, 1, 1);         
    menu.bg_color = (0.1, 0.0, 0.04);     
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_vaporwave_style(menu)
{
    
    menu.header_color = (1.0, 0.4, 0.8);    
    menu.active_color = (1.0, 0.4, 0.8);      
    menu.inactive_color = (1.0, 0.9, 1.0);  
    menu.title_color = (1, 1, 1);        
    menu.bg_color = (0.1, 0.04, 0.08);          
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.8;
    menu.header_alpha = 0.9;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_enchanted_forest_style(menu)
{
    
    menu.header_color = (0.1, 0.4, 0.2);    
    menu.active_color = (0.1, 0.4, 0.2);    
    menu.inactive_color = (0.8, 1.0, 0.85);  
    menu.title_color = (1, 1, 1);      
    menu.bg_color = (0.01, 0.04, 0.02);       
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_ancient_egypt_style(menu)
{
    
    menu.header_color = (0.8, 0.6, 0.1);    
    menu.active_color = (0.8, 0.6, 0.1);    
    menu.inactive_color = (1.0, 0.95, 0.8);  
    menu.title_color = (1, 1, 1);      
    menu.bg_color = (0.08, 0.06, 0.01);        
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_crystal_glass_style(menu)
{
    
    menu.header_color = (0.7, 0.8, 0.9);      
    menu.active_color = (0.7, 0.8, 0.9);      
    menu.inactive_color = (0.95, 0.98, 1.0);    
    menu.title_color = (1, 1, 1);      
    menu.bg_color = (0.07, 0.08, 0.09);         

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.7;
    menu.header_alpha = 0.85;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_velvet_noir_style(menu)
{
    
    menu.header_color = (0.4, 0.0, 0.1);    
    menu.active_color = (0.4, 0.0, 0.1);     
    menu.inactive_color = (1.0, 0.9, 0.9);   
    menu.title_color = (1, 1, 1);      
    menu.bg_color = (0.04, 0.0, 0.01);      

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_aurora_borealis_style(menu)
{
    
    menu.header_color = (0.0, 0.8, 0.6);     
    menu.active_color = (0.0, 0.8, 0.6);       
    menu.inactive_color = (0.8, 1.0, 0.95);     
    menu.title_color = (1, 1, 1);        
    menu.bg_color = (0.0, 0.08, 0.06);        

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.95;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);

    
    if (!isDefined(menu.aurora_active))
    {
        menu.aurora_active = true;
        menu.user thread aurora_effect(menu);
    }
}


aurora_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_aurora");

    hue = 0;

    while(isDefined(menu.aurora_active) && menu.aurora_active)
    {
        
        hue += 0.005;
        if (hue > 1) hue = 0;

        
        header_color = hsv_to_rgb(hue, 0.7, 0.9);
        selection_color = hsv_to_rgb((hue + 0.3) % 1, 0.8, 0.95);

        
        menu.header_color = header_color;
        menu.active_color = selection_color;

        
        if (isDefined(menu.header_bg))
        {
            menu.header_bg.color = header_color;
            menu.header_bg.alpha = 0.95;
        }

        if (isDefined(menu.selection_bar))
            menu.selection_bar.color = selection_color;

        wait 0.08; 
    }
}


apply_marble_luxe_style(menu)
{
    
    menu.header_color = (0.9, 0.8, 0.2);   
    menu.active_color = (0.9, 0.8, 0.2);     
    menu.inactive_color = (1.0, 0.95, 0.8); 
    menu.title_color = (1, 1, 1);     
    menu.bg_color = (0.09, 0.08, 0.02);      

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 0.95;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_neon_city_style(menu)
{
    
    menu.header_color = (0.6, 0.0, 0.8);     
    menu.active_color = (0.6, 0.0, 0.8);       
    menu.inactive_color = (0.9, 0.8, 1.0);     
    menu.title_color = (1, 1, 1);          
    menu.bg_color = (0.06, 0.0, 0.08);       

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_sakura_blossom_style(menu)
{
    
    menu.header_color = (1.0, 0.6, 0.8);    
    menu.active_color = (1.0, 0.6, 0.8);     
    menu.inactive_color = (1.0, 0.9, 0.95); 
    menu.title_color = (1, 1, 1);      
    menu.bg_color = (0.1, 0.06, 0.08);      

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_deep_space_style(menu)
{
    
    menu.header_color = (0.0, 0.0, 0.4);     
    menu.active_color = (0.0, 0.0, 0.4);       
    menu.inactive_color = (0.8, 0.8, 1.0);   
    menu.title_color = (1, 1, 1);          
    menu.bg_color = (0.0, 0.0, 0.04);      

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_coral_reef_style(menu)
{
    
    menu.header_color = (1.0, 0.4, 0.4);     
    menu.active_color = (1.0, 0.4, 0.4);     
    menu.inactive_color = (1.0, 0.9, 0.9);   
    menu.title_color = (1, 1, 1);      
    menu.bg_color = (0.1, 0.04, 0.04);         

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_royal_purple_style(menu)
{
    
    menu.header_color = (0.4, 0.0, 0.6);     
    menu.active_color = (0.4, 0.0, 0.6);     
    menu.inactive_color = (0.9, 0.8, 1.0);   
    menu.title_color = (1, 1, 1);     
    menu.bg_color = (0.04, 0.0, 0.06);         

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


apply_sunrise_gradient_style(menu)
{
    
    menu.header_color = (1.0, 0.5, 0.0);     
    menu.active_color = (1.0, 0.5, 0.0);       
    menu.inactive_color = (1.0, 0.9, 0.8);  
    menu.title_color = (1, 1, 1);     
    menu.bg_color = (0.1, 0.05, 0.0);       

    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;

    
    menu.has_border = false;

    
    update_menu_visuals(menu);
}


stop_aurora_effect(menu)
{
    if (isDefined(menu.aurora_active) && menu.aurora_active)
    {
        menu.aurora_active = false;
        menu notify("stop_aurora");
    }
}


apply_neon_retro_style(menu)
{
    
    menu.header_color = (0.0, 0.0, 0.0);          
    menu.active_color = (0.0, 0.0, 0.0);      
    menu.inactive_color = (0.8, 0.8, 0.8);  
    menu.title_color = (1, 1, 1);       
    menu.bg_color = (0.1, 0.1, 0.1);     
    
    
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    
    menu.has_border = false;
    
    
    update_menu_visuals(menu);
}


apply_hologram_style(menu)
{

    menu.header_color = (0.0, 0.8, 1.0);
    menu.active_color = (0.0, 0.8, 1.0);
    menu.inactive_color = (0.8, 0.95, 1.0);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.0, 0.08, 0.1);


    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;


    menu.bg_alpha = 0.6;
    menu.header_alpha = 0.8;


    menu.has_border = false;


    update_menu_visuals(menu);
}




apply_custom_dimensions(menu)
{
    if (!isDefined(menu.user))
        return menu;

    
    if (!isDefined(menu.user.custom_menu_width))
        menu.user.custom_menu_width = 175;

    if (!isDefined(menu.user.custom_menu_margin_x))
        menu.user.custom_menu_margin_x = 0;

    if (!isDefined(menu.user.custom_menu_margin_y))
        menu.user.custom_menu_margin_y = 40;

    if (!isDefined(menu.user.custom_menu_item_height))
        menu.user.custom_menu_item_height = 18;

    if (!isDefined(menu.user.custom_menu_header_height))
        menu.user.custom_menu_header_height = 24;

    
    menu.width = menu.user.custom_menu_width;
    menu.margin_x = menu.user.custom_menu_margin_x;
    menu.margin_y = menu.user.custom_menu_margin_y;
    menu.item_height = menu.user.custom_menu_item_height;
    menu.header_height = menu.user.custom_menu_header_height;

    
    update_menu_visuals(menu);

    
    if (isDefined(menu.background))
    {
        total_height = menu.header_height + (menu.item_height * menu.items.size);
        menu.background setShader("white", menu.width, total_height);
        menu.background.x = menu.margin_x;
        menu.background.y = menu.margin_y;
    }

    if (isDefined(menu.header_bg))
    {
        menu.header_bg setShader("white", menu.width, menu.header_height);
        menu.header_bg.x = menu.margin_x;
        menu.header_bg.y = menu.margin_y;
    }

    
    if (isDefined(menu.selection_bar))
    {
        menu.selection_bar.x = menu.margin_x;
        menu.selection_bar.y = menu.margin_y + menu.header_height + (menu.item_height * menu.selected);
        menu.selection_bar setShader("white", menu.width, menu.item_height);
    }

    
    for (i = 0; i < menu.items.size; i++)
    {
        if (isDefined(menu.items[i].item))
        {
            menu.items[i].item.y = menu.margin_y + menu.header_height + (menu.item_height * i) + (menu.item_height / 2) - 6;

            
            if (isDefined(menu.font_position_index))
            {
                switch(menu.font_position_index)
                {
                    case 0: 
                        menu.items[i].item.x = menu.margin_x + 15;
                        menu.items[i].item.alignX = "left";
                        break;
                    case 1: 
                        menu.items[i].item.x = menu.margin_x + (menu.width / 2);
                        menu.items[i].item.alignX = "center";
                        break;
                    case 2: 
                        menu.items[i].item.x = menu.margin_x + menu.width - 15;
                        menu.items[i].item.alignX = "right";
                        break;
                    default: 
                        menu.items[i].item.x = menu.margin_x + 15;
                        menu.items[i].item.alignX = "left";
                        break;
                }
            }
            else
            {
                
                if (menu.items[i].item.horzalign == "center")
                {
                    menu.items[i].item.x = menu.margin_x + (menu.width / 2);
                }
                else
                {
                    menu.items[i].item.x = menu.margin_x + 15;
                }
            }
        }
    }

    
    if (isDefined(menu.title_text))
    {
        menu.title_text.y = menu.margin_y + 3;
        
        if (isDefined(menu.font_position_index))
        {
            switch(menu.font_position_index)
            {
                case 0: 
                    menu.title_text.x = menu.margin_x + 10;
                    menu.title_text.alignX = "left";
                    break;
                case 1: 
                    menu.title_text.x = menu.margin_x + (menu.width / 2);
                    menu.title_text.alignX = "center";
                    break;
                case 2: 
                    menu.title_text.x = menu.margin_x + menu.width - 10;
                    menu.title_text.alignX = "right";
                    break;
                default:
                    menu.title_text.x = menu.margin_x + 10;
                    menu.title_text.alignX = "left";
                    break;
            }
        }
        else
        {
            menu.title_text.x = menu.margin_x + 12;
        }
    }

    if (isDefined(menu.title_shadow))
    {
        menu.title_shadow.y = menu.margin_y + 5;
        
        if (isDefined(menu.font_position_index))
        {
            switch(menu.font_position_index)
            {
                case 0: 
                    menu.title_shadow.x = menu.margin_x + 12;
                    menu.title_shadow.alignX = "left";
                    break;
                case 1: 
                    menu.title_shadow.x = menu.margin_x + (menu.width / 2) + 2;
                    menu.title_shadow.alignX = "center";
                    break;
                case 2: 
                    menu.title_shadow.x = menu.margin_x + menu.width - 8;
                    menu.title_shadow.alignX = "right";
                    break;
                default:
                    menu.title_shadow.x = menu.margin_x + 12;
                    menu.title_shadow.alignX = "left";
                    break;
            }
        }
        else
        {
            menu.title_shadow.x = menu.margin_x + 14;
        }
    }

    return menu;
}

set_custom_menu_width(player, width)
{
    if (!isDefined(width) || width < 150 || width > 350)
        width = 175;

    player.custom_menu_width = width;
}

set_custom_menu_margin_x(player, margin_x)
{
    if (!isDefined(margin_x) || margin_x < 0 || margin_x > 600)
        margin_x = 0;

    player.custom_menu_margin_x = margin_x;
}

set_custom_menu_margin_y(player, margin_y)
{
    if (!isDefined(margin_y) || margin_y < 0 || margin_y > 200)
        margin_y = 40;

    player.custom_menu_margin_y = margin_y;
}

set_custom_menu_item_height(player, item_height)
{
    if (!isDefined(item_height) || item_height < 12 || item_height > 28)
        item_height = 18;

    player.custom_menu_item_height = item_height;
}

set_custom_menu_header_height(player, header_height)
{
    if (!isDefined(header_height) || header_height < 15 || header_height > 50)
        header_height = 24;

    player.custom_menu_header_height = header_height;
}

reset_custom_dimensions(player)
{
    player.custom_menu_width = 175;
    player.custom_menu_margin_x = 0;
    player.custom_menu_margin_y = 40;
    player.custom_menu_item_height = 18;
    player.custom_menu_header_height = 24;
}

apply_blueprint_style(menu)
{
    menu.header_color = (0.0, 0.2, 0.6);
    menu.active_color = (0.0, 0.2, 0.6);
    menu.inactive_color = (0.9, 0.9, 1.0);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.0, 0.1, 0.4);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_amber_terminal_style(menu)
{
    menu.header_color = (1.0, 0.7, 0.0);
    menu.active_color = (1.0, 0.7, 0.0);
    menu.inactive_color = (0.8, 0.6, 0.0);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.0, 0.0, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_monochrome_style(menu)
{
    menu.header_color = (0.1, 0.1, 0.1);
    menu.active_color = (0.1, 0.1, 0.1);
    menu.inactive_color = (0.5, 0.5, 0.5);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.0, 0.0, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 1;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_parchment_style(menu)
{
    menu.header_color = (0.4, 0.3, 0.2);
    menu.active_color = (0.4, 0.3, 0.2);
    menu.inactive_color = (0.3, 0.2, 0.1);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.9, 0.85, 0.7);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_graphite_style(menu)
{
    menu.header_color = (0.6, 0.6, 0.6);
    menu.active_color = (0.6, 0.6, 0.6);
    menu.inactive_color = (0.4, 0.4, 0.4);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.1, 0.1, 0.1);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_espresso_style(menu)
{
    menu.header_color = (0.8, 0.7, 0.6);
    menu.active_color = (0.8, 0.7, 0.6);
    menu.inactive_color = (0.6, 0.5, 0.4);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.1, 0.05, 0.02);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_lilac_style(menu)
{
    menu.header_color = (0.6, 0.4, 0.8);
    menu.active_color = (0.6, 0.4, 0.8);
    menu.inactive_color = (0.3, 0.2, 0.4);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.9, 0.8, 1.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_mint_style(menu)
{
    menu.header_color = (0.4, 0.8, 0.6);
    menu.active_color = (0.4, 0.8, 0.6);
    menu.inactive_color = (0.2, 0.4, 0.3);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.8, 1.0, 0.9);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_imperial_red_style(menu)
{
    menu.header_color = (1.0, 0.8, 0.0);
    menu.active_color = (1.0, 0.8, 0.0);
    menu.inactive_color = (1.0, 0.9, 0.8);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.2, 0.0, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_white_gold_style(menu)
{
    menu.header_color = (0.9, 0.8, 0.2);
    menu.active_color = (0.9, 0.8, 0.2);
    menu.inactive_color = (0.6, 0.5, 0.1);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (1.0, 1.0, 1.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_storm_style(menu)
{
    menu.header_color = (1.0, 0.9, 0.0);
    menu.active_color = (1.0, 0.9, 0.0);
    menu.inactive_color = (0.7, 0.8, 0.9);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.1, 0.15, 0.2);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_cotton_candy_style(menu)
{
    menu.header_color = (0.6, 0.8, 1.0);
    menu.active_color = (0.6, 0.8, 1.0);
    menu.inactive_color = (1.0, 0.9, 0.95);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.2, 0.1, 0.15);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_midnight_violet_style(menu)
{
    menu.header_color = (0.6, 0.4, 0.8);
    menu.active_color = (0.6, 0.4, 0.8);
    menu.inactive_color = (0.4, 0.3, 0.5);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.05, 0.0, 0.1);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_sunburst_style(menu)
{
    menu.header_color = (1.0, 0.8, 0.0);
    menu.active_color = (1.0, 0.8, 0.0);
    menu.inactive_color = (1.0, 0.9, 0.8);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.2, 0.1, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_titanium_style(menu)
{
    menu.header_color = (0.3, 0.3, 0.35);
    menu.active_color = (0.3, 0.3, 0.35);
    menu.inactive_color = (0.4, 0.4, 0.45);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.8, 0.8, 0.85);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_emerald_city_style(menu)
{
    menu.header_color = (0.0, 0.6, 0.3);
    menu.active_color = (0.0, 0.6, 0.3);
    menu.inactive_color = (0.6, 1.0, 0.6);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.0, 0.1, 0.05);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_ruby_red_style(menu)
{
    menu.header_color = (0.8, 0.0, 0.1);
    menu.active_color = (0.8, 0.0, 0.1);
    menu.inactive_color = (1.0, 0.6, 0.6);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.1, 0.0, 0.02);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_sapphire_blue_style(menu)
{
    menu.header_color = (0.0, 0.2, 0.8);
    menu.active_color = (0.0, 0.2, 0.8);
    menu.inactive_color = (0.6, 0.7, 1.0);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.0, 0.02, 0.1);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_obsidian_style(menu)
{
    menu.header_color = (0.3, 0.3, 0.3);
    menu.active_color = (0.3, 0.3, 0.3);
    menu.inactive_color = (0.2, 0.2, 0.2);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.0, 0.0, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.98;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_pearl_style(menu)
{
    menu.header_color = (0.4, 0.4, 0.45);
    menu.active_color = (0.4, 0.4, 0.45);
    menu.inactive_color = (0.7, 0.7, 0.7);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (1.0, 1.0, 1.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_carbon_fiber_style(menu)
{
    menu.header_color = (0.0, 0.0, 0.0);
    menu.active_color = (0.0, 0.0, 0.0);
    menu.inactive_color = (0.4, 0.4, 0.4);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.08, 0.08, 0.08);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 1;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_magma_style(menu)
{
    menu.header_color = (1.0, 0.3, 0.0);
    menu.active_color = (1.0, 0.3, 0.0);
    menu.inactive_color = (0.5, 0.5, 0.5);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.1, 0.05, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_glitch_style(menu)
{
    menu.header_color = (0.0, 1.0, 0.0);
    menu.active_color = (0.0, 1.0, 0.0);
    menu.inactive_color = (1.0, 0.0, 1.0);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.05, 0.05, 0.05);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_biohazard_style(menu)
{
    menu.header_color = (0.0, 0.0, 0.0);
    menu.active_color = (0.0, 0.0, 0.0);
    menu.inactive_color = (0.4, 0.4, 0.0);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.1, 0.1, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_radioactive_style(menu)
{
    menu.header_color = (0.2, 1.0, 0.2);
    menu.active_color = (0.2, 1.0, 0.2);
    menu.inactive_color = (0.1, 0.5, 0.1);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.0, 0.1, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_void_style(menu)
{
    menu.header_color = (0.3, 0.0, 0.5);
    menu.active_color = (0.3, 0.0, 0.5);
    menu.inactive_color = (0.2, 0.2, 0.2);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.0, 0.0, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 1;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_zen_style(menu)
{
    menu.header_color = (0.3, 0.5, 0.3);
    menu.active_color = (0.3, 0.5, 0.3);
    menu.inactive_color = (0.5, 0.45, 0.4);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.95, 0.92, 0.85);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_nordic_style(menu)
{
    menu.header_color = (0.6, 0.8, 0.9);
    menu.active_color = (0.6, 0.8, 0.9);
    menu.inactive_color = (0.7, 0.75, 0.8);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.2, 0.25, 0.3);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_solar_flare_style(menu)
{
    menu.header_color = (1.0, 1.0, 0.0);
    menu.active_color = (1.0, 1.0, 0.0);
    menu.inactive_color = (1.0, 0.8, 0.6);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.3, 0.1, 0.0);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
}

apply_nebula_style(menu)
{
    menu.header_color = (0.2, 0.0, 0.4);
    menu.active_color = (0.0, 0.8, 1.0);
    menu.inactive_color = (1.0, 0.4, 0.8);
    menu.title_color = (1, 1, 1);
    menu.bg_color = (0.1, 0.0, 0.2);

    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;

    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    menu.has_border = false;

    update_menu_visuals(menu);
} 