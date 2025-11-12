


#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;


init()
{
    
    level.font_animations = [];
    level.font_animations[0] = "Sin Animación";      
    level.font_animations[1] = "Rebote (Bounce)";    
    level.font_animations[2] = "Barrido";            
    level.font_animations[3] = "Desvanecer";         
    level.font_animations[4] = "Escala";             
    level.font_animations[5] = "Giro";               
    level.font_animations[6] = "Pulso";              
    level.font_animations[7] = "Onda";               
}


apply_font_animation(menu, animation_index)
{
    if (!isDefined(animation_index))
        animation_index = 0; 

    
    menu.font_animation_index = animation_index;

    
    if (isDefined(menu.current_animation_thread))
    {
        menu notify("stop_font_animation");
        menu.current_animation_thread = undefined;
    }

    
    switch(animation_index)
    {
        case 0:
            
            break;
        case 1:
            menu thread apply_bounce_animation(menu);
            break;
        case 2:
            menu thread apply_sweep_animation(menu);
            break;
        case 3:
            menu thread apply_fade_animation(menu);
            break;
        case 4:
            menu thread apply_scale_animation(menu);
            break;
        case 5:
            menu thread apply_rotate_animation(menu);
            break;
        case 6:
            menu thread apply_pulse_animation(menu);
            break;
        case 7:
            menu thread apply_wave_animation(menu);
            break;
    }
}






apply_bounce_animation(menu)
{
    menu endon("stop_font_animation");
    menu endon("menu_closed");

    menu.current_animation_thread = true;

    while(true)
    {
        menu waittill("selector_moved");

        if (!isDefined(menu.items) || !isDefined(menu.items[menu.selected]) || !isDefined(menu.items[menu.selected].item))
            continue;

        
        current_item = menu.items[menu.selected].item;
        original_y = current_item.y;

        
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        
        current_item.animation_in_progress = true;

        
        current_item.y = original_y - 3;
        wait 0.1;

        
        current_item.y = original_y + 1;
        wait 0.1;

        
        current_item.y = original_y;

        
        current_item.animation_in_progress = undefined;
    }
}


apply_sweep_animation(menu)
{
    menu endon("stop_font_animation");
    menu endon("menu_closed");

    menu.current_animation_thread = true;

    while(true)
    {
        menu waittill("selector_moved");

        if (!isDefined(menu.items) || !isDefined(menu.items[menu.selected]) || !isDefined(menu.items[menu.selected].item))
            continue;

        
        current_item = menu.items[menu.selected].item;
        original_x = current_item.x;

        
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        
        current_item.animation_in_progress = true;

        
        current_item.x = original_x + 6;
        wait 0.08;

        current_item.x = original_x + 10;
        wait 0.08;

        
        current_item.x = original_x - 4;
        wait 0.08;

        current_item.x = original_x - 8;
        wait 0.08;

        
        current_item.x = original_x + 2;
        wait 0.06;

        
        current_item.x = original_x;

        
        current_item.animation_in_progress = undefined;
    }
}


apply_fade_animation(menu)
{
    menu endon("stop_font_animation");
    menu endon("menu_closed");

    menu.current_animation_thread = true;

    while(true)
    {
        menu waittill("selector_moved");

        if (!isDefined(menu.items) || !isDefined(menu.items[menu.selected]) || !isDefined(menu.items[menu.selected].item))
            continue;

        
        current_item = menu.items[menu.selected].item;
        original_alpha = current_item.alpha;

        
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        
        current_item.animation_in_progress = true;

        
        current_item.alpha = original_alpha * 0.8;
        wait 0.03;
        current_item.alpha = original_alpha * 0.6;
        wait 0.03;
        current_item.alpha = original_alpha * 0.4;
        wait 0.04;
        current_item.alpha = original_alpha * 0.3;
        wait 0.04;

        
        current_item.alpha = original_alpha * 0.5;
        wait 0.03;
        current_item.alpha = original_alpha * 0.7;
        wait 0.03;
        current_item.alpha = original_alpha * 0.9;
        wait 0.03;
        current_item.alpha = original_alpha;
        wait 0.03;

        
        current_item.animation_in_progress = undefined;
    }
}


apply_scale_animation(menu)
{
    menu endon("stop_font_animation");
    menu endon("menu_closed");

    menu.current_animation_thread = true;

    while(true)
    {
        menu waittill("selector_moved");

        if (!isDefined(menu.items) || !isDefined(menu.items[menu.selected]) || !isDefined(menu.items[menu.selected].item))
            continue;

        
        current_item = menu.items[menu.selected].item;
        original_scale = current_item.fontscale;

        
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        
        current_item.animation_in_progress = true;

        
        current_item.fontscale = original_scale * 1.2;
        wait 0.08;

        
        current_item.fontscale = original_scale * 0.9;
        wait 0.08;

        
        current_item.fontscale = original_scale;

        
        current_item.animation_in_progress = undefined;
    }
}


apply_rotate_animation(menu)
{
    menu endon("stop_font_animation");
    menu endon("menu_closed");

    menu.current_animation_thread = true;

    while(true)
    {
        menu waittill("selector_moved");

        if (!isDefined(menu.items) || !isDefined(menu.items[menu.selected]) || !isDefined(menu.items[menu.selected].item))
            continue;

        
        current_item = menu.items[menu.selected].item;
        original_x = current_item.x;

        
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        
        current_item.animation_in_progress = true;

        
        current_item.x = original_x + 15;
        wait 0.05;

        
        current_item.x = original_x - 15;
        wait 0.05;

        
        current_item.x = original_x + 5;
        wait 0.05;

        
        current_item.x = original_x;

        
        current_item.animation_in_progress = undefined;
    }
}


apply_pulse_animation(menu)
{
    menu endon("stop_font_animation");
    menu endon("menu_closed");

    menu.current_animation_thread = true;

    while(true)
    {
        menu waittill("selector_moved");

        if (!isDefined(menu.items) || !isDefined(menu.items[menu.selected]) || !isDefined(menu.items[menu.selected].item))
            continue;

        
        current_item = menu.items[menu.selected].item;
        original_alpha = current_item.alpha;

        
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        
        current_item.animation_in_progress = true;

        
        current_item.alpha = original_alpha * 0.5;
        wait 0.05;
        current_item.alpha = original_alpha * 0.8;
        wait 0.03;

        
        current_item.alpha = original_alpha * 0.6;
        wait 0.04;
        current_item.alpha = original_alpha * 0.9;
        wait 0.03;

        
        current_item.alpha = original_alpha * 0.7;
        wait 0.03;
        current_item.alpha = original_alpha;
        wait 0.03;

        
        current_item.animation_in_progress = undefined;
    }
}


apply_wave_animation(menu)
{
    menu endon("stop_font_animation");
    menu endon("menu_closed");

    menu.current_animation_thread = true;

    while(true)
    {
        menu waittill("selector_moved");

        if (!isDefined(menu.items) || !isDefined(menu.items[menu.selected]) || !isDefined(menu.items[menu.selected].item))
            continue;

        
        current_item = menu.items[menu.selected].item;
        original_y = current_item.y;

        
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        
        current_item.animation_in_progress = true;

        
        current_item.y = original_y - 2;
        wait 0.08;

        
        current_item.y = original_y + 2;
        wait 0.08;

        
        current_item.y = original_y - 1;
        wait 0.06;

        
        current_item.y = original_y;

        
        current_item.animation_in_progress = undefined;
    }
}






get_font_animation_name(animation_index, lang_index)
{
    if (!isDefined(animation_index))
        animation_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; 

    animation_name = level.font_animations[animation_index];

    if (lang_index == 0) 
    {
        return animation_name;
    }
    else 
    {
        
        switch(animation_index)
        {
            case 0: return "No Animation";
            case 1: return "Bounce";
            case 2: return "Sweep";
            case 3: return "Fade";
            case 4: return "Scale";
            case 5: return "Rotate";
            case 6: return "Pulse";
            case 7: return "Wave";
            default: return animation_name;
        }
    }
}


change_font_animation(menu, new_animation_index)
{
    menu.font_animation_index = new_animation_index;
    menu apply_font_animation(menu, new_animation_index);
}
