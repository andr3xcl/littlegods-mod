


#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;


init()
{
    
    level.transparency_levels = [];
    level.transparency_levels[0] = "0%";   
    level.transparency_levels[1] = "10%";
    level.transparency_levels[2] = "20%";
    level.transparency_levels[3] = "30%";
    level.transparency_levels[4] = "40%";
    level.transparency_levels[5] = "50%";
    level.transparency_levels[6] = "60%";
    level.transparency_levels[7] = "70%";  
}


apply_transparency(menu, transparency_index)
{
    if (!isDefined(transparency_index))
        transparency_index = 0; 
    
    
    menu.transparency_index = transparency_index;
    
    
    
    user_alpha_value = 1.0 - (transparency_index * 0.1);

    
    if (isDefined(menu.bg_alpha))
        background_alpha = menu.bg_alpha * user_alpha_value;
    else
        background_alpha = user_alpha_value;

    
    if (isDefined(menu.header_alpha))
        header_alpha = menu.header_alpha * user_alpha_value;
    else
        header_alpha = user_alpha_value;

    
    if (header_alpha > 1.0)
        header_alpha = 1.0;

    
    if (isDefined(menu.background))
        menu.background.alpha = background_alpha;

    
    if (isDefined(menu.header_bg))
        menu.header_bg.alpha = header_alpha;
    
    
    if (isDefined(menu.header_text))
        menu.header_text.alpha = 1.0; 
        
    
    
    
    if (isDefined(menu.footer))
        menu.footer.alpha = background_alpha;
    
    
    
    
    return menu;
}


get_transparency_percentage(transparency_index)
{
    if (!isDefined(transparency_index))
        return "0%";
        
    return level.transparency_levels[transparency_index];
}


get_transparency_name(transparency_index, lang_index)
{
    if (!isDefined(transparency_index))
        transparency_index = 0;
        
    if (!isDefined(lang_index))
        lang_index = 0;
    
    
    transparency_value = int(level.transparency_levels[transparency_index]);
    
    if (lang_index == 0) 
        return "Transparencia: " + transparency_value + "%%";
    else 
        return "Transparency: " + transparency_value + "%%";
}


update_transparency_after_style_change(menu, transparency_index)
{
    if (!isDefined(transparency_index))
        return menu;
        
    
    if (transparency_index > 0)
    {
        
        alpha_value = 1.0 - (transparency_index * 0.1);
        
        
        if (isDefined(menu.background))
            menu.background.alpha = alpha_value;
            
        if (isDefined(menu.header_bg))
            menu.header_bg.alpha = alpha_value;
            
        
            
        
        if (isDefined(menu.header_text))
            menu.header_text.alpha = 1.0;
    }
    
    return menu;
}
