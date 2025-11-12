


#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;


init()
{
    
    level.selector_styles = [];
    
    level.selector_styles[0] = "Standard";       
    level.selector_styles[1] = "Gradient";       
    level.selector_styles[2] = "Pulse";          
    level.selector_styles[3] = "ColorPulse";     
    level.selector_styles[4] = "SizePulse";      
    level.selector_styles[5] = "BlinkPulse";     
    
    
    level.selector_styles[6] = "Arrow";          
    level.selector_styles[7] = "DoubleArrow";    
    level.selector_styles[8] = "TripleArrows";   
    level.selector_styles[9] = "DancingArrows";  
    level.selector_styles[10] = "BlinkingArrows";
    level.selector_styles[11] = "RainbowArrows"; 
    level.selector_styles[12] = "ArrowBar";      
    
    
    level.selector_styles[13] = "Border";        
    level.selector_styles[14] = "BorderPulse";   
    level.selector_styles[15] = "BorderWave";    
    level.selector_styles[16] = "BorderCorners"; 
    level.selector_styles[17] = "BorderGlow";    
    
    
    level.selector_styles[18] = "Dot";           
}


apply_selector_style(menu, style_index)
{
    if (!isDefined(style_index))
        style_index = 14; 
    
    
    menu.selector_style_index = style_index;
    
    
    clear_existing_selector(menu);
    
    
    switch(style_index)
    {
        
        case 0:
            apply_standard_selector(menu);
            break;
        case 1:
            apply_gradient_selector(menu);
            break;
        case 2:
            apply_pulse_selector(menu);
            break;
        case 3:
            apply_color_pulse_selector(menu);
            break;
        case 4:
            apply_size_pulse_selector(menu);
            break;
        case 5:
            apply_blink_pulse_selector(menu);
            break;
            
        
        case 6:
            apply_arrow_selector(menu);
            break;
        case 7:
            apply_double_arrow_selector(menu);
            break;
        case 8:
            apply_triple_arrows_selector(menu);
            break;
        case 9:
            apply_dancing_arrows_selector(menu);
            break;
        case 10:
            apply_blinking_arrows_selector(menu);
            break;
        case 11:
            apply_rainbow_arrows_selector(menu);
            break;
        case 12:
            apply_arrow_bar_selector(menu);
            break;
            
        
        case 13:
            apply_border_selector(menu);
            break;
        case 14:
            apply_border_pulse_selector(menu);
            break;
        case 15:
            apply_border_wave_selector(menu);
            break;
        case 16:
            apply_border_corners_selector(menu);
            break;
        case 17:
            apply_border_glow_selector(menu);
            break;
            
        
        case 18:
            apply_dot_selector(menu);
            break;
        default:
            apply_border_pulse_selector(menu); 
            break;
    }
    
    
    update_selector_visuals(menu);
    
    return menu;
}


clear_existing_selector(menu)
{
    
    if (isDefined(menu.selector_effect_active))
    {
        menu.selector_effect_active = false;
        menu notify("stop_selector_effect");
    }
    
    
    if (isDefined(menu.selector_elements))
    {
        for (i = 0; i < menu.selector_elements.size; i++)
        {
            if (isDefined(menu.selector_elements[i]))
                menu.selector_elements[i] destroy();
        }
        menu.selector_elements = [];
    }
    
    
    if (!isDefined(menu.selection_bar))
    {
        menu.selection_bar = newClientHudElem(menu.user);
        menu.selection_bar.vertalign = "top";
        menu.selection_bar.horzalign = "left";
    }
    
    
    menu.selection_bar.x = menu.background.x;
}


apply_standard_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.6;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; 
    
    
    update_selector_position(menu);
}


apply_arrow_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; 
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; 
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    
    menu.selector_effect_active = true;
    menu.user thread arrow_animation_effect(menu);
}


arrow_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        original_x_left = menu.selector_elements[0].x;
        original_x_right = menu.selector_elements[1].x;
        
        
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        
        for (i = 4; i >= 0; i--)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        wait 0.2;
    }
}


apply_gradient_selector(menu)
{
    
    menu.selection_bar setShader("gradient_fadein", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.8;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; 
    
    
    update_selector_position(menu);
}


apply_pulse_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.6;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; 
    
    
    update_selector_position(menu);
    
    
    menu.selector_effect_active = true;
    menu.user thread pulse_animation_effect(menu);
}


pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        for (alpha = 0.3; alpha <= 0.8; alpha += 0.05)
        {
            menu.selection_bar.alpha = alpha;
            wait 0.05;
        }
        
        
        for (alpha = 0.8; alpha >= 0.3; alpha -= 0.05)
        {
            menu.selection_bar.alpha = alpha;
            wait 0.05;
        }
    }
}


apply_border_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = "top";
    top_border.horzalign = "left";
    top_border.x = menu.background.x;
    top_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    top_border.color = menu.active_color;
    top_border.alpha = 0.9;
    top_border setShader("white", menu.width, 1);
    
    
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = "top";
    bottom_border.horzalign = "left";
    bottom_border.x = menu.background.x;
    bottom_border.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 1;
    bottom_border.color = menu.active_color;
    bottom_border.alpha = 0.9;
    bottom_border setShader("white", menu.width, 1);
    
    
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = "top";
    left_border.horzalign = "left";
    left_border.x = menu.background.x;
    left_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    left_border.color = menu.active_color;
    left_border.alpha = 0.9;
    left_border setShader("white", 1, menu.item_height);
    
    
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = "top";
    right_border.horzalign = "left";
    right_border.x = menu.background.x + menu.width - 1;
    right_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    right_border.color = menu.active_color;
    right_border.alpha = 0.9;
    right_border setShader("white", 1, menu.item_height);
    
    
    menu.selector_elements[0] = top_border;
    menu.selector_elements[1] = bottom_border;
    menu.selector_elements[2] = left_border;
    menu.selector_elements[3] = right_border;
}


apply_dot_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    left_dot = newClientHudElem(menu.user);
    left_dot.vertalign = "top";
    left_dot.horzalign = "left";
    left_dot.x = menu.background.x + 5;
    left_dot.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
    left_dot.color = menu.active_color;
    left_dot.alpha = 0.9;
    left_dot setShader("white", 6, 6);
    
    
    right_dot = newClientHudElem(menu.user);
    right_dot.vertalign = "top";
    right_dot.horzalign = "left";
    right_dot.x = menu.background.x + menu.width - 11;
    right_dot.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
    right_dot.color = menu.active_color;
    right_dot.alpha = 0.9;
    right_dot setShader("white", 6, 6);
    
    
    menu.selector_elements[0] = left_dot;
    menu.selector_elements[1] = right_dot;
}


apply_underline_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    underline = newClientHudElem(menu.user);
    underline.vertalign = "top";
    underline.horzalign = "left";
    underline.x = menu.background.x + 15;
    underline.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 4;
    underline.color = menu.active_color;
    underline.alpha = 0.9;
    underline setShader("white", menu.width - 30, 2);
    
    
    menu.selector_elements[0] = underline;
}


apply_color_pulse_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.7;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; 
    
    
    update_selector_position(menu);
    
    
    menu.selector_effect_active = true;
    menu.user thread color_pulse_animation_effect(menu);
}


color_pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    
    original_color = menu.active_color;
    
    
    second_color = (1 - original_color[0], 1 - original_color[1], 1 - original_color[2]);
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        for (i = 0; i <= 10; i++)
        {
            t = i / 10; 
            r = original_color[0] * (1 - t) + second_color[0] * t;
            g = original_color[1] * (1 - t) + second_color[1] * t;
            b = original_color[2] * (1 - t) + second_color[2] * t;
            
            menu.selection_bar.color = (r, g, b);
            wait 0.05;
        }
        
        
        for (i = 10; i >= 0; i--)
        {
            t = i / 10; 
            r = original_color[0] * (1 - t) + second_color[0] * t;
            g = original_color[1] * (1 - t) + second_color[1] * t;
            b = original_color[2] * (1 - t) + second_color[2] * t;
            
            menu.selection_bar.color = (r, g, b);
            wait 0.05;
        }
    }
}


apply_size_pulse_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.7;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; 
    
    
    update_selector_position(menu);
    
    
    menu.selector_effect_active = true;
    menu.user thread size_pulse_animation_effect(menu);
}


size_pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    
    original_height = menu.item_height;
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        for (scale = 0; scale <= 4; scale++)
        {
            new_height = original_height + scale;
            menu.selection_bar setShader("white", menu.width, new_height);
            
            
            offset = (new_height - original_height) / 2;
            menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) - offset;
            
            wait 0.05;
        }
        
        
        for (scale = 4; scale >= 0; scale--)
        {
            new_height = original_height + scale;
            menu.selection_bar setShader("white", menu.width, new_height);
            
            
            offset = (new_height - original_height) / 2;
            menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) - offset;
            
            wait 0.05;
        }
        
        wait 0.2;
    }
}


apply_border_pulse_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = "top";
    top_border.horzalign = "left";
    top_border.x = menu.background.x;
    top_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    top_border.color = menu.active_color;
    top_border.alpha = 0.5; 
    top_border setShader("white", menu.width, 2);
    
    
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = "top";
    bottom_border.horzalign = "left";
    bottom_border.x = menu.background.x;
    bottom_border.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
    bottom_border.color = menu.active_color;
    bottom_border.alpha = 0.5; 
    bottom_border setShader("white", menu.width, 2);
    
    
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = "top";
    left_border.horzalign = "left";
    left_border.x = menu.background.x;
    left_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    left_border.color = menu.active_color;
    left_border.alpha = 0.5; 
    left_border setShader("white", 2, menu.item_height);
    
    
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = "top";
    right_border.horzalign = "left";
    right_border.x = menu.background.x + menu.width - 2;
    right_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    right_border.color = menu.active_color;
    right_border.alpha = 0.5; 
    right_border setShader("white", 2, menu.item_height);
    
    
    menu.selector_elements[0] = top_border;
    menu.selector_elements[1] = bottom_border;
    menu.selector_elements[2] = left_border;
    menu.selector_elements[3] = right_border;
    
    
    menu.selector_effect_active = true;
    menu.user thread border_pulse_animation_effect(menu);
}


border_pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        
        
        menu.selector_elements[0].alpha = 1;
        menu.selector_elements[1].alpha = 0.3;
        menu.selector_elements[2].alpha = 0.3;
        menu.selector_elements[3].alpha = 0.3;
        wait 0.15;
        
        
        menu.selector_elements[0].alpha = 0.3;
        menu.selector_elements[1].alpha = 0.3;
        menu.selector_elements[2].alpha = 0.3;
        menu.selector_elements[3].alpha = 1;
        wait 0.15;
        
        
        menu.selector_elements[0].alpha = 0.3;
        menu.selector_elements[1].alpha = 1;
        menu.selector_elements[2].alpha = 0.3;
        menu.selector_elements[3].alpha = 0.3;
        wait 0.15;
        
        
        menu.selector_elements[0].alpha = 0.3;
        menu.selector_elements[1].alpha = 0.3;
        menu.selector_elements[2].alpha = 1;
        menu.selector_elements[3].alpha = 0.3;
        wait 0.15;
        
        
        menu.selector_elements[0].alpha = 1;
        menu.selector_elements[1].alpha = 1;
        menu.selector_elements[2].alpha = 1;
        menu.selector_elements[3].alpha = 1;
        wait 0.3;
        
        
        menu.selector_elements[0].alpha = 0.7;
        menu.selector_elements[1].alpha = 0.7;
        menu.selector_elements[2].alpha = 0.7;
        menu.selector_elements[3].alpha = 0.7;
        wait 0.2;
    }
}


apply_blink_pulse_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.7;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; 
    
    
    update_selector_position(menu);
    
    
    menu.selector_effect_active = true;
    menu.user thread blink_pulse_animation_effect(menu);
}


blink_pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        for (i = 0; i < 3; i++)
        {
            menu.selector_elements[0].alpha = 0.1;
            wait 0.1;
            menu.selector_elements[0].alpha = 0.7;
            wait 0.1;
        }
        
        
        wait 0.8;
    }
}


apply_double_arrow_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; 
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    
    left_arrow.fontscale = 1.4;
    left_arrow setText(">>");
    
    
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; 
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    
    right_arrow.fontscale = 1.4;
    right_arrow setText("<<");
    
    
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    
    menu.selector_effect_active = true;
    menu.user thread double_arrow_animation_effect(menu);
}


double_arrow_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        original_x_left = menu.selector_elements[0].x;
        original_x_right = menu.selector_elements[1].x;
        
        
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        
        for (i = 4; i >= 0; i--)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        wait 0.2;
    }
}


apply_angle_brackets_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    left_bracket = newClientHudElem(menu.user);
    left_bracket.vertalign = "top";
    left_bracket.horzalign = "left";
    left_bracket.x = menu.background.x + 5;
    left_bracket.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) + 2;
    left_bracket.color = menu.active_color;
    left_bracket.alpha = 0.9;
    left_bracket.fontscale = 1.8;
    left_bracket setText("<");
    
    
    right_bracket = newClientHudElem(menu.user);
    right_bracket.vertalign = "top";
    right_bracket.horzalign = "left";
    right_bracket.x = menu.background.x + menu.width - 10;
    right_bracket.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) + 2;
    right_bracket.color = menu.active_color;
    right_bracket.alpha = 0.9;
    right_bracket.fontscale = 1.8;
    right_bracket setText(">");
    
    
    menu.selector_elements[0] = left_bracket;
    menu.selector_elements[1] = right_bracket;
}


apply_dancing_arrows_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; 
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; 
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    
    menu.selector_effect_active = true;
    menu.user thread dancing_arrows_animation_effect(menu);
}


dancing_arrows_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        original_x_left = menu.selector_elements[0].x;
        original_x_right = menu.selector_elements[1].x;
        
        
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        
        for (i = 4; i >= 0; i--)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        wait 0.2;
    }
}


apply_blinking_arrows_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; 
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; 
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    
    menu.selector_effect_active = true;
    menu.user thread blinking_arrows_animation_effect(menu);
}


blinking_arrows_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        original_x_left = menu.selector_elements[0].x;
        original_x_right = menu.selector_elements[1].x;
        
        
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        
        for (i = 4; i >= 0; i--)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        wait 0.2;
    }
}


apply_triple_arrows_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    spacing = 10; 
    
    
    pos_y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    
    
    left_arrow1 = newClientHudElem(menu.user);
    left_arrow1.vertalign = "top";
    left_arrow1.horzalign = "left";
    left_arrow1.x = menu.background.x - 28 - (spacing * 2); 
    left_arrow1.y = pos_y;
    left_arrow1.color = menu.active_color;
    left_arrow1.alpha = 1;
    left_arrow1.fontscale = 1.5;
    left_arrow1 setText(">");
    
    
    left_arrow2 = newClientHudElem(menu.user);
    left_arrow2.vertalign = "top";
    left_arrow2.horzalign = "left";
    left_arrow2.x = menu.background.x - 28 - spacing; 
    left_arrow2.y = pos_y;
    left_arrow2.color = menu.active_color;
    left_arrow2.alpha = 1;
    left_arrow2.fontscale = 1.5;
    left_arrow2 setText(">");
    
    
    left_arrow3 = newClientHudElem(menu.user);
    left_arrow3.vertalign = "top";
    left_arrow3.horzalign = "left";
    left_arrow3.x = menu.background.x - 28; 
    left_arrow3.y = pos_y;
    left_arrow3.color = menu.active_color;
    left_arrow3.alpha = 1;
    left_arrow3.fontscale = 1.5;
    left_arrow3 setText(">");
    
    
    right_arrow1 = newClientHudElem(menu.user);
    right_arrow1.vertalign = "top";
    right_arrow1.horzalign = "left";
    right_arrow1.x = menu.background.x + menu.width + 8; 
    right_arrow1.y = pos_y;
    right_arrow1.color = menu.active_color;
    right_arrow1.alpha = 1;
    right_arrow1.fontscale = 1.5;
    right_arrow1 setText("<");
    
    
    right_arrow2 = newClientHudElem(menu.user);
    right_arrow2.vertalign = "top";
    right_arrow2.horzalign = "left";
    right_arrow2.x = menu.background.x + menu.width + 8 + spacing; 
    right_arrow2.y = pos_y;
    right_arrow2.color = menu.active_color;
    right_arrow2.alpha = 1;
    right_arrow2.fontscale = 1.5;
    right_arrow2 setText("<");
    
    
    right_arrow3 = newClientHudElem(menu.user);
    right_arrow3.vertalign = "top";
    right_arrow3.horzalign = "left";
    right_arrow3.x = menu.background.x + menu.width + 8 + (spacing * 2); 
    right_arrow3.y = pos_y;
    right_arrow3.color = menu.active_color;
    right_arrow3.alpha = 1;
    right_arrow3.fontscale = 1.5;
    right_arrow3 setText("<");
    
    
    menu.selector_elements[0] = left_arrow1;
    menu.selector_elements[1] = left_arrow2;
    menu.selector_elements[2] = left_arrow3;
    menu.selector_elements[3] = right_arrow1;
    menu.selector_elements[4] = right_arrow2;
    menu.selector_elements[5] = right_arrow3;
    
    
    menu.selector_effect_active = true;
    menu.user thread triple_arrows_animation_effect(menu);
}


triple_arrows_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        
        
        menu.selector_elements[0].alpha = 1;
        menu.selector_elements[5].alpha = 1;
        menu.selector_elements[1].alpha = 0.4;
        menu.selector_elements[4].alpha = 0.4;
        menu.selector_elements[2].alpha = 0.4;
        menu.selector_elements[3].alpha = 0.4;
        wait 0.2;
        
        
        menu.selector_elements[0].alpha = 0.4;
        menu.selector_elements[5].alpha = 0.4;
        menu.selector_elements[1].alpha = 1;
        menu.selector_elements[4].alpha = 1;
        menu.selector_elements[2].alpha = 0.4;
        menu.selector_elements[3].alpha = 0.4;
        wait 0.2;
        
        
        menu.selector_elements[0].alpha = 0.4;
        menu.selector_elements[5].alpha = 0.4;
        menu.selector_elements[1].alpha = 0.4;
        menu.selector_elements[4].alpha = 0.4;
        menu.selector_elements[2].alpha = 1;
        menu.selector_elements[3].alpha = 1;
        wait 0.2;
        
        
        menu.selector_elements[0].alpha = 1;
        menu.selector_elements[5].alpha = 1;
        menu.selector_elements[1].alpha = 1;
        menu.selector_elements[4].alpha = 1;
        menu.selector_elements[2].alpha = 1;
        menu.selector_elements[3].alpha = 1;
        wait 0.4;
    }
}


apply_rainbow_arrows_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; 
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = (1, 0, 0); 
    left_arrow.alpha = 0.9;
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; 
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = (1, 0, 0); 
    right_arrow.alpha = 0.9;
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    
    menu.selector_effect_active = true;
    menu.user thread rainbow_arrows_animation_effect(menu);
}


rainbow_arrows_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    
    rainbow_colors = [];
    rainbow_colors[0] = (1, 0, 0);     
    rainbow_colors[1] = (1, 0.5, 0);   
    rainbow_colors[2] = (1, 1, 0);     
    rainbow_colors[3] = (0, 1, 0);     
    rainbow_colors[4] = (0, 0, 1);     
    rainbow_colors[5] = (0.5, 0, 1);   
    rainbow_colors[6] = (1, 0, 1);     
    
    color_index = 0;
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        menu.selector_elements[0].color = rainbow_colors[color_index];
        menu.selector_elements[1].color = rainbow_colors[color_index];
        
        
        color_index = (color_index + 1) % rainbow_colors.size;
        
        wait 0.3;
    }
}


apply_arrow_bar_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width - 20, menu.item_height);
    menu.selection_bar.alpha = 0.5;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x + 10; 
    
    
    update_selector_position(menu);
    
    
    menu.selector_elements = [];
    
    
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x;
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width - 10;
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    
    menu.selector_effect_active = true;
    menu.user thread arrow_bar_animation_effect(menu);
}


arrow_bar_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].alpha = 0.5 + (i * 0.1);
            menu.selector_elements[1].alpha = 0.5 + (i * 0.1);
            menu.selection_bar.alpha = 0.5 - (i * 0.05);
            wait 0.05;
        }
        
        
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].alpha = 0.9 - (i * 0.1);
            menu.selector_elements[1].alpha = 0.9 - (i * 0.1);
            menu.selection_bar.alpha = 0.3 + (i * 0.05);
            wait 0.05;
        }
        
        wait 0.1;
    }
}


apply_border_wave_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    segments = 10;
    segment_width = menu.width / segments;
    
    
    for (i = 0; i < segments; i++)
    {
        segment = newClientHudElem(menu.user);
        segment.vertalign = "top";
        segment.horzalign = "left";
        segment.x = menu.background.x + (i * segment_width);
        segment.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
        segment.color = menu.active_color;
        segment.alpha = 0.9;
        segment setShader("white", segment_width, 2);
        
        menu.selector_elements[i] = segment;
    }
    
    
    for (i = 0; i < segments; i++)
    {
        segment = newClientHudElem(menu.user);
        segment.vertalign = "top";
        segment.horzalign = "left";
        segment.x = menu.background.x + (i * segment_width);
        segment.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
        segment.color = menu.active_color;
        segment.alpha = 0.9;
        segment setShader("white", segment_width, 2);
        
        menu.selector_elements[segments + i] = segment;
    }
    
    
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = "top";
    left_border.horzalign = "left";
    left_border.x = menu.background.x;
    left_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    left_border.color = menu.active_color;
    left_border.alpha = 0.9;
    left_border setShader("white", 2, menu.item_height);
    
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = "top";
    right_border.horzalign = "left";
    right_border.x = menu.background.x + menu.width - 2;
    right_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    right_border.color = menu.active_color;
    right_border.alpha = 0.9;
    right_border setShader("white", 2, menu.item_height);
    
    menu.selector_elements[segments * 2] = left_border;
    menu.selector_elements[segments * 2 + 1] = right_border;
    
    
    menu.selector_effect_active = true;
    menu.user thread border_wave_animation_effect(menu, segments);
}


border_wave_animation_effect(menu, segments)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    wave_offset = 0;
    max_displacement = 3; 
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        for (i = 0; i < segments; i++)
        {
            
            wave_pos = (i + wave_offset) % segments;
            displacement = sin(wave_pos * (360/segments) * (3.14159/180)) * max_displacement;
            
            
            menu.selector_elements[i].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + displacement;
            
            
            menu.selector_elements[segments + i].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2 - displacement;
        }
        
        
        wave_offset = (wave_offset + 1) % segments;
        
        wait 0.05;
    }
}


apply_border_corners_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    corner_size = 10;
    
    
    corner_top_left_h = newClientHudElem(menu.user);
    corner_top_left_h.vertalign = "top";
    corner_top_left_h.horzalign = "left";
    corner_top_left_h.x = menu.background.x;
    corner_top_left_h.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    corner_top_left_h.color = menu.active_color;
    corner_top_left_h.alpha = 0.9;
    corner_top_left_h setShader("white", corner_size, 2);
    
    
    corner_top_left_v = newClientHudElem(menu.user);
    corner_top_left_v.vertalign = "top";
    corner_top_left_v.horzalign = "left";
    corner_top_left_v.x = menu.background.x;
    corner_top_left_v.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    corner_top_left_v.color = menu.active_color;
    corner_top_left_v.alpha = 0.9;
    corner_top_left_v setShader("white", 2, corner_size);
    
    
    corner_top_right_h = newClientHudElem(menu.user);
    corner_top_right_h.vertalign = "top";
    corner_top_right_h.horzalign = "left";
    corner_top_right_h.x = menu.background.x + menu.width - corner_size;
    corner_top_right_h.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    corner_top_right_h.color = menu.active_color;
    corner_top_right_h.alpha = 0.9;
    corner_top_right_h setShader("white", corner_size, 2);
    
    
    corner_top_right_v = newClientHudElem(menu.user);
    corner_top_right_v.vertalign = "top";
    corner_top_right_v.horzalign = "left";
    corner_top_right_v.x = menu.background.x + menu.width - 2;
    corner_top_right_v.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    corner_top_right_v.color = menu.active_color;
    corner_top_right_v.alpha = 0.9;
    corner_top_right_v setShader("white", 2, corner_size);
    
    
    corner_bottom_left_h = newClientHudElem(menu.user);
    corner_bottom_left_h.vertalign = "top";
    corner_bottom_left_h.horzalign = "left";
    corner_bottom_left_h.x = menu.background.x;
    corner_bottom_left_h.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
    corner_bottom_left_h.color = menu.active_color;
    corner_bottom_left_h.alpha = 0.9;
    corner_bottom_left_h setShader("white", corner_size, 2);
    
    
    corner_bottom_left_v = newClientHudElem(menu.user);
    corner_bottom_left_v.vertalign = "top";
    corner_bottom_left_v.horzalign = "left";
    corner_bottom_left_v.x = menu.background.x;
    corner_bottom_left_v.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
    corner_bottom_left_v.color = menu.active_color;
    corner_bottom_left_v.alpha = 0.9;
    corner_bottom_left_v setShader("white", 2, corner_size);
    
    
    corner_bottom_right_h = newClientHudElem(menu.user);
    corner_bottom_right_h.vertalign = "top";
    corner_bottom_right_h.horzalign = "left";
    corner_bottom_right_h.x = menu.background.x + menu.width - corner_size;
    corner_bottom_right_h.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
    corner_bottom_right_h.color = menu.active_color;
    corner_bottom_right_h.alpha = 0.9;
    corner_bottom_right_h setShader("white", corner_size, 2);
    
    
    corner_bottom_right_v = newClientHudElem(menu.user);
    corner_bottom_right_v.vertalign = "top";
    corner_bottom_right_v.horzalign = "left";
    corner_bottom_right_v.x = menu.background.x + menu.width - 2;
    corner_bottom_right_v.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
    corner_bottom_right_v.color = menu.active_color;
    corner_bottom_right_v.alpha = 0.9;
    corner_bottom_right_v setShader("white", 2, corner_size);
    
    menu.selector_elements[0] = corner_top_left_h;
    menu.selector_elements[1] = corner_top_left_v;
    menu.selector_elements[2] = corner_top_right_h;
    menu.selector_elements[3] = corner_top_right_v;
    menu.selector_elements[4] = corner_bottom_left_h;
    menu.selector_elements[5] = corner_bottom_left_v;
    menu.selector_elements[6] = corner_bottom_right_h;
    menu.selector_elements[7] = corner_bottom_right_v;
    
    
    menu.selector_effect_active = true;
    menu.user thread border_corners_animation_effect(menu);
}


border_corners_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        corner_set = 0;
        
        
        for (corner_set = 0; corner_set < 4; corner_set++)
        {
            
            for (i = 0; i < 8; i++)
                menu.selector_elements[i].alpha = 0.3;
            
            
            menu.selector_elements[corner_set * 2].alpha = 1;
            menu.selector_elements[corner_set * 2 + 1].alpha = 1;
            
            
            for (i = 0; i < 3; i++)
            {
                menu.selector_elements[corner_set * 2].alpha = 0.3;
                menu.selector_elements[corner_set * 2 + 1].alpha = 0.3;
                wait 0.1;
                menu.selector_elements[corner_set * 2].alpha = 1;
                menu.selector_elements[corner_set * 2 + 1].alpha = 1;
                wait 0.1;
            }
            
            wait 0.2;
        }
        
        
        for (i = 0; i < 8; i++)
            menu.selector_elements[i].alpha = 1;
            
        wait 0.5;
    }
}


apply_border_glow_selector(menu)
{
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    
    menu.selector_elements = [];
    
    
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = "top";
    top_border.horzalign = "left";
    top_border.x = menu.background.x;
    top_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    top_border.color = menu.active_color;
    top_border.alpha = 0.9;
    top_border setShader("white", menu.width, 2);
    
    
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = "top";
    bottom_border.horzalign = "left";
    bottom_border.x = menu.background.x;
    bottom_border.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
    bottom_border.color = menu.active_color;
    bottom_border.alpha = 0.9;
    bottom_border setShader("white", menu.width, 2);
    
    
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = "top";
    left_border.horzalign = "left";
    left_border.x = menu.background.x;
    left_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    left_border.color = menu.active_color;
    left_border.alpha = 0.9;
    left_border setShader("white", 2, menu.item_height);
    
    
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = "top";
    right_border.horzalign = "left";
    right_border.x = menu.background.x + menu.width - 2;
    right_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    right_border.color = menu.active_color;
    right_border.alpha = 0.9;
    right_border setShader("white", 2, menu.item_height);
    
    
    menu.selector_elements[0] = top_border;
    menu.selector_elements[1] = bottom_border;
    menu.selector_elements[2] = left_border;
    menu.selector_elements[3] = right_border;
    
    
    menu.selector_effect_active = true;
    menu.user thread border_glow_animation_effect(menu);
}


border_glow_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        
        original_color = menu.active_color;
        
        
        bright_color = (
            min(1, original_color[0] + 0.3),
            min(1, original_color[1] + 0.3),
            min(1, original_color[2] + 0.3)
        );
        
        
        for (i = 0; i <= 10; i++)
        {
            t = i / 10; 
            r = original_color[0] * (1 - t) + bright_color[0] * t;
            g = original_color[1] * (1 - t) + bright_color[1] * t;
            b = original_color[2] * (1 - t) + bright_color[2] * t;
            
            for (j = 0; j < 4; j++)
                menu.selector_elements[j].color = (r, g, b);
                
            wait 0.04;
        }
        
        
        for (i = 10; i >= 0; i--)
        {
            t = i / 10; 
            r = original_color[0] * (1 - t) + bright_color[0] * t;
            g = original_color[1] * (1 - t) + bright_color[1] * t;
            b = original_color[2] * (1 - t) + bright_color[2] * t;
            
            for (j = 0; j < 4; j++)
                menu.selector_elements[j].color = (r, g, b);
                
            wait 0.04;
        }
        
        wait 0.3;
    }
}


update_selector_visuals(menu)
{
    
    if (!isDefined(menu) || !isDefined(menu.selection_bar))
        return;
    
    
    if (isDefined(menu.selection_bar))
    {
        if (menu.selector_style_index == 12) 
        {
            
            menu.selection_bar setShader("white", menu.width - 20, menu.item_height);
            menu.selection_bar.x = menu.background.x + 10;
        }
        else
        {
            
            menu.selection_bar setShader("white", menu.width, menu.item_height);
            menu.selection_bar.x = menu.background.x;
        }

        menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    }

    
    if (isDefined(menu.selector_style_index) && isDefined(menu.selector_elements))
    {
        switch(menu.selector_style_index)
        {
            case 6: 
            case 7: 
            case 9: 
            case 10: 
            case 11: 
                
                menu.selector_elements[0].x = menu.background.x - 8; 
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;

                
                menu.selector_elements[1].x = menu.background.x + menu.width + 2; 
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                break;

            case 13: 
            case 14: 
                
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[0] setShader("white", menu.width, 1); 

                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 1;
                menu.selector_elements[1] setShader("white", menu.width, 1); 

                
                menu.selector_elements[2].x = menu.background.x;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[2] setShader("white", 1, menu.item_height);

                menu.selector_elements[3].x = menu.background.x + menu.width - 1;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3] setShader("white", 1, menu.item_height);
                break;

            case 15: 
                
                segments = 10;
                menu.selector_elements[segments * 2].x = menu.background.x;
                menu.selector_elements[segments * 2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[segments * 2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[segments * 2 + 1].x = menu.background.x + menu.width - 2;
                menu.selector_elements[segments * 2 + 1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[segments * 2 + 1] setShader("white", 2, menu.item_height);
                break;
                
            case 16: 
                corner_size = 10;
                
                
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                
                menu.selector_elements[2].x = menu.background.x + menu.width - corner_size;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                
                
                menu.selector_elements[4].x = menu.background.x;
                menu.selector_elements[4].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[5].x = menu.background.x;
                menu.selector_elements[5].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
                
                menu.selector_elements[6].x = menu.background.x + menu.width - corner_size;
                menu.selector_elements[6].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[7].x = menu.background.x + menu.width - 2;
                menu.selector_elements[7].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
                break;
                
            case 17: 
                
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[0] setShader("white", menu.width, 2);
                
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[1] setShader("white", menu.width, 2);
                
                
                menu.selector_elements[2].x = menu.background.x;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3] setShader("white", 2, menu.item_height);
                break;
                
            case 18: 
                
                menu.selector_elements[0].x = menu.background.x + 5;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;

                
                menu.selector_elements[1].x = menu.background.x + menu.width - 11;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
                break;

            case 8: 
                spacing = 10;
                pos_y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 4;

                
                menu.selector_elements[0].x = menu.background.x - 28 - (spacing * 2); 
                menu.selector_elements[1].x = menu.background.x - 28 - spacing; 
                menu.selector_elements[2].x = menu.background.x - 28; 

                menu.selector_elements[3].x = menu.background.x + menu.width + 8; 
                menu.selector_elements[4].x = menu.background.x + menu.width + 8 + spacing; 
                menu.selector_elements[5].x = menu.background.x + menu.width + 8 + (spacing * 2); 

                
                for (i = 0; i < 6; i++)
                    menu.selector_elements[i].y = pos_y;
                break;

            case 12: 
                menu.selector_elements[0].x = menu.background.x; 
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;

                
                menu.selector_elements[1].x = menu.background.x + menu.width - 10;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;

                
                menu.selection_bar setShader("white", menu.width - 20, menu.item_height);
                menu.selection_bar.x = menu.background.x + 10;
                menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                break;
        }
    }
}


update_selector_position(menu)
{
    
    if (isDefined(menu.selection_bar))
    {
        
        if (isDefined(menu.selector_style_index) && menu.selector_style_index == 12) 
        {
            
            menu.selection_bar.x = menu.background.x + 10;
        }
        else
        {
            
            menu.selection_bar.x = menu.background.x;
        }
        
        
        menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    }
    
    
    if (isDefined(menu.selector_style_index) && isDefined(menu.selector_elements))
    {
        switch(menu.selector_style_index)
        {
            case 6: 
            case 7: 
            case 9: 
            case 10: 
            case 11: 
                
                menu.selector_elements[0].x = menu.background.x - 8; 
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                
                
                menu.selector_elements[1].x = menu.background.x + menu.width + 2; 
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                break;
                
            case 13: 
            case 14: 
                
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[0] setShader("white", menu.width, 2); 
                
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[1] setShader("white", menu.width, 2); 
                
                
                menu.selector_elements[2].x = menu.background.x;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3] setShader("white", 2, menu.item_height);
                break;
                
            case 15: 
                
                segments = 10;
                menu.selector_elements[segments * 2].x = menu.background.x;
                menu.selector_elements[segments * 2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[segments * 2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[segments * 2 + 1].x = menu.background.x + menu.width - 2;
                menu.selector_elements[segments * 2 + 1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[segments * 2 + 1] setShader("white", 2, menu.item_height);
                break;
                
            case 16: 
                corner_size = 10;
                
                
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                
                menu.selector_elements[2].x = menu.background.x + menu.width - corner_size;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                
                
                menu.selector_elements[4].x = menu.background.x;
                menu.selector_elements[4].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[5].x = menu.background.x;
                menu.selector_elements[5].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
                
                menu.selector_elements[6].x = menu.background.x + menu.width - corner_size;
                menu.selector_elements[6].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[7].x = menu.background.x + menu.width - 2;
                menu.selector_elements[7].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
                break;
                
            case 17: 
                
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[0] setShader("white", menu.width, 2);
                
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[1] setShader("white", menu.width, 2);
                
                
                menu.selector_elements[2].x = menu.background.x;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3] setShader("white", 2, menu.item_height);
                break;
                
            case 18: 
                menu.selector_elements[0].x = menu.background.x + 5;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
                menu.selector_elements[1].x = menu.background.x + menu.width - 11;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
                break;
                
            case 8: 
                spacing = 10;
                pos_y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 4;
                
                
                menu.selector_elements[0].x = menu.background.x - 28 - (spacing * 2); 
                menu.selector_elements[1].x = menu.background.x - 28 - spacing; 
                menu.selector_elements[2].x = menu.background.x - 28; 
                
                menu.selector_elements[3].x = menu.background.x + menu.width + 8; 
                menu.selector_elements[4].x = menu.background.x + menu.width + 8 + spacing; 
                menu.selector_elements[5].x = menu.background.x + menu.width + 8 + (spacing * 2); 
                
                
                for (i = 0; i < 6; i++)
                    menu.selector_elements[i].y = pos_y;
                break;
                
            case 12: 
                menu.selector_elements[0].x = menu.background.x; 
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                menu.selector_elements[1].x = menu.background.x + menu.width - 10; 
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                
                
                menu.selection_bar setShader("white", menu.width - 20, menu.item_height);
                menu.selection_bar.x = menu.background.x + 10;
                menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                break;
        }
    }
}


get_selector_style_name(style_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
        
    if (lang_index == 0) 
    {
        switch(style_index)
        {
            
            case 0: return "Estándar";
            case 1: return "Degradado";
            case 2: return "Pulsante";
            case 3: return "Pulso Color";
            case 4: return "Pulso Tamaño";
            case 5: return "Parpadeo";
            
            
            case 6: return "Flechas";
            case 7: return "Flechas Dobles";
            case 8: return "Triple Flecha";
            case 9: return "Flechas Bailando";
            case 10: return "Flechas Parpadeantes";
            case 11: return "Flechas Arcoíris";
            case 12: return "Barra con Flechas";
            
            
            case 13: return "Bordes";
            case 14: return "Bordes Pulsantes";
            case 15: return "Borde Ondulado";
            case 16: return "Borde Esquinas";
            case 17: return "Borde Brillante";
            
            
            case 18: return "Puntos";
            default: return "Bordes Pulsantes";
        }
    }
    else 
    {
        switch(style_index)
        {
            
            case 0: return "Standard";
            case 1: return "Gradient";
            case 2: return "Pulse";
            case 3: return "Color Pulse";
            case 4: return "Size Pulse";
            case 5: return "Blink";
            
            
            case 6: return "Arrows";
            case 7: return "Double Arrows";
            case 8: return "Triple Arrows";
            case 9: return "Dancing Arrows";
            case 10: return "Blinking Arrows";
            case 11: return "Rainbow Arrows";
            case 12: return "Arrow Bar";
            
            
            case 13: return "Border";
            case 14: return "Border Pulse";
            case 15: return "Wave Border";
            case 16: return "Corner Border";
            case 17: return "Glow Border";
            
            
            case 18: return "Dots";
            default: return "Border Pulse";
        }
    }
} 