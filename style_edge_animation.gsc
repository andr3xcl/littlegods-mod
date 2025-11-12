


#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;


init()
{
    
    level.edge_animation_styles = [];
    level.edge_animation_styles[0] = "None";        
    level.edge_animation_styles[1] = "Rainbow";     
    level.edge_animation_styles[2] = "Pulse";       

    
    if (!isDefined(level.default_edge_animation_style))
    {
        level.default_edge_animation_style = 1; 
    }

    
    level.menu_edge_animation_states = [];

    
    level thread onplayerdisconnect();
}


apply_edge_animation(menu, animation_index)
{
    if (!isDefined(animation_index))
        animation_index = 0; 

    
    menu.edge_animation_style_index = animation_index;

    
    clear_existing_edge_animation(menu);

    
    switch(animation_index)
    {
        case 0: 
            
            break;
        case 1: 
            apply_rainbow_edge_animation(menu);
            break;
        case 2: 
            apply_pulse_edge_animation(menu);
            break;
        default:
            
            break;
    }

    return menu;
}


clear_existing_edge_animation(menu)
{
    
    if (isDefined(menu.edge_animation_active))
    {
        menu.edge_animation_active = false;
        menu notify("stop_edge_animation");
    }
    
    
    if (isDefined(menu.edge_animation_elements))
    {
        for (i = 0; i < menu.edge_animation_elements.size; i++)
        {
            if (isDefined(menu.edge_animation_elements[i]))
                menu.edge_animation_elements[i] destroy();
        }
        menu.edge_animation_elements = [];
    }
}



apply_rainbow_edge_animation(menu)
{
    
    menu.edge_animation_elements = [];
    
    
    if (!isDefined(menu.height))
    {
        menu.height = menu.header_height + (menu.item_height * menu.items.size);
    }
    
    
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = menu.background.vertalign;
    top_border.horzalign = menu.background.horzalign;
    top_border.x = menu.background.x;
    top_border.y = menu.background.y;
    top_border.color = (1, 0, 0); 
    top_border.alpha = 0.9;
    top_border setShader("white", menu.width, 2);
    
    
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = menu.background.vertalign;
    right_border.horzalign = menu.background.horzalign;
    
    
    if (menu.background.horzalign == "left")
    {
        right_border.x = menu.background.x + menu.width - 2;
    }
    else if (menu.background.horzalign == "right")
    {
        right_border.x = menu.background.x + menu.width - 2;
    }
    else 
    {
        right_border.x = menu.background.x + (menu.width / 2);
    }
    
    right_border.y = menu.background.y;
    right_border.color = (1, 0.5, 0); 
    right_border.alpha = 0.9;
    right_border setShader("white", 2, menu.height);
    
    
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = menu.background.vertalign;
    bottom_border.horzalign = menu.background.horzalign;
    bottom_border.x = menu.background.x;
    
    
    if (menu.background.vertalign == "top")
    {
        bottom_border.y = menu.background.y + menu.height - 2;
    }
    else if (menu.background.vertalign == "bottom")
    {
        bottom_border.y = menu.background.y + menu.height - 2;
    }
    else 
    {
        bottom_border.y = menu.background.y + (menu.height / 2);
    }
    
    bottom_border.color = (1, 1, 0); 
    bottom_border.alpha = 0.9;
    bottom_border setShader("white", menu.width, 2);
    
    
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = menu.background.vertalign;
    left_border.horzalign = menu.background.horzalign;
    left_border.x = menu.background.x;
    left_border.y = menu.background.y;
    left_border.color = (0, 1, 0); 
    left_border.alpha = 0.9;
    left_border setShader("white", 2, menu.height);
    
    
    menu.edge_animation_elements[0] = top_border;
    menu.edge_animation_elements[1] = right_border;
    menu.edge_animation_elements[2] = bottom_border;
    menu.edge_animation_elements[3] = left_border;
    
    
    menu.last_height = menu.height;
    
    
    menu.edge_animation_active = true;
    menu.user thread rainbow_edge_animation_effect(menu);
}


rainbow_edge_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_edge_animation");
    
    
    rainbow_colors = [];
    rainbow_colors[0] = (1, 0, 0);     
    rainbow_colors[1] = (1, 0.5, 0);   
    rainbow_colors[2] = (1, 1, 0);     
    rainbow_colors[3] = (0, 1, 0);     
    rainbow_colors[4] = (0, 1, 1);     
    rainbow_colors[5] = (0, 0, 1);     
    rainbow_colors[6] = (0.5, 0, 1);   
    rainbow_colors[7] = (1, 0, 1);     
    
    
    border_color_index = [];
    border_color_index[0] = 0; 
    border_color_index[1] = 2; 
    border_color_index[2] = 4; 
    border_color_index[3] = 6; 
    
    while(isDefined(menu.edge_animation_active) && menu.edge_animation_active)
    {
        
        for (i = 0; i < 4; i++)
        {
            color_index = border_color_index[i] % rainbow_colors.size;
            menu.edge_animation_elements[i].color = rainbow_colors[color_index];
            
            border_color_index[i] = (border_color_index[i] + 1) % rainbow_colors.size;
        }
        
        
        wait 0.2;
    }
}


apply_pulse_edge_animation(menu)
{
    
    menu.edge_animation_elements = [];
    
    
    if (!isDefined(menu.height))
    {
        menu.height = menu.header_height + (menu.item_height * menu.items.size);
    }
    
    
    edge_color = (0.2, 0.6, 1);
    
    
    if (isDefined(menu.style_index))
    {
        
        if (menu.style_index == 33 || menu.style_index == 14 || menu.style_index == 21)
        {
            edge_color = (1, 0.2, 0.2); 
        }
        
        else if (menu.style_index == 34 || menu.style_index == 4)
        {
            edge_color = (1, 0.2, 0.9); 
        }
        
        else if (menu.style_index == 11 || menu.style_index == 8 || menu.style_index == 0 || menu.style_index == 18)
        {
            edge_color = (0.2, 0.7, 1); 
        }
        
        else if (menu.style_index == 3 || menu.style_index == 15 || menu.style_index == 22)
        {
            edge_color = (0.2, 1, 0.5); 
        }
    }
    
    
    
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = menu.background.vertalign;
    top_border.horzalign = menu.background.horzalign;
    top_border.x = menu.background.x;
    top_border.y = menu.background.y;
    top_border.color = edge_color;
    top_border.alpha = 0; 
    top_border setShader("white", menu.width, 2);
    
    
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = menu.background.vertalign;
    right_border.horzalign = menu.background.horzalign;
    right_border.x = menu.background.x + menu.width - 2;
    right_border.y = menu.background.y;
    right_border.color = edge_color;
    right_border.alpha = 0; 
    right_border setShader("white", 2, menu.height);
    
    
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = menu.background.vertalign;
    bottom_border.horzalign = menu.background.horzalign;
    bottom_border.x = menu.background.x;
    bottom_border.y = menu.background.y + menu.height - 2;
    bottom_border.color = edge_color;
    bottom_border.alpha = 0; 
    bottom_border setShader("white", menu.width, 2);
    
    
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = menu.background.vertalign;
    left_border.horzalign = menu.background.horzalign;
    left_border.x = menu.background.x;
    left_border.y = menu.background.y;
    left_border.color = edge_color;
    left_border.alpha = 0; 
    left_border setShader("white", 2, menu.height);
    
    
    menu.edge_animation_elements[0] = top_border;
    menu.edge_animation_elements[1] = right_border;
    menu.edge_animation_elements[2] = bottom_border;
    menu.edge_animation_elements[3] = left_border;
    
    
    menu.edge_animation_color = edge_color;
    
    
    menu.last_height = menu.height;
    
    
    menu.edge_animation_active = true;
    menu.user thread pulse_edge_animation_effect(menu);
}


pulse_edge_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_edge_animation");
    
    
    if (!isDefined(menu.edge_animation_elements) || menu.edge_animation_elements.size < 4)
        return;
    
    
    min_alpha = 0.1;
    max_alpha = 0.9;
    pulse_speed = 0.05; 
    
    
    fade_in = true; 
    current_alpha = min_alpha;
    
    while(isDefined(menu.edge_animation_active) && menu.edge_animation_active)
    {
        
        menu.height = menu.header_height + (menu.item_height * menu.items.size);
        
        
        menu.edge_animation_elements[1] setShader("white", 2, menu.height);  
        menu.edge_animation_elements[2].y = menu.background.y + menu.height - 2; 
        menu.edge_animation_elements[3] setShader("white", 2, menu.height);  
        
        
        if (fade_in)
        {
            current_alpha += pulse_speed;
            if (current_alpha >= max_alpha)
            {
                current_alpha = max_alpha;
                fade_in = false; 
            }
        }
        else
        {
            current_alpha -= pulse_speed;
            if (current_alpha <= min_alpha)
            {
                current_alpha = min_alpha;
                fade_in = true; 
            }
        }
        
        
        for (i = 0; i < 4; i++)
        {
            menu.edge_animation_elements[i].alpha = current_alpha;
        }
        
        wait 0.05; 
    }
}



onplayerdisconnect()
{
    level endon("end_game");
    
    level waittill("player_disconnect");
    
    
    players = getPlayers();
    for (i = 0; i < players.size; i++)
    {
        player = players[i];
        if (isDefined(player.menu_stack))
        {
            for (j = 0; j < player.menu_stack.size; j++)
            {
                menu = player.menu_stack[j];
                if (isDefined(menu))
                {
                    clear_existing_edge_animation(menu);
                }
            }
        }
    }
    
    
    level thread onplayerdisconnect();
}


get_edge_animation_style_name(style_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;

    if (lang_index == 0) 
    {
        switch(style_index)
        {
            case 0: return "Ninguna";
            case 1: return "Arcoíris";
            case 2: return "Pulso";
            default: return "Ninguna";
        }
    }
    else 
    {
        switch(style_index)
        {
            case 0: return "None";
            case 1: return "Rainbow";
            case 2: return "Pulse";
            default: return "None";
        }
    }
}


update_edge_animation_size(menu)
{
    
    if (isDefined(menu.edge_animation_active))
    {
        menu.edge_animation_active = false;
        menu notify("stop_edge_animation");
    }
    
    
    wait 0.05;
    
    
    menu.height = menu.header_height + (menu.item_height * menu.items.size);
    
    
    height_changed = true;
    if (isDefined(menu.last_height))
    {
        if (menu.height == menu.last_height)
        {
            height_changed = false;
        }
    }
    
    
    if (height_changed || !isDefined(menu.edge_animation_elements) || menu.edge_animation_elements.size == 0)
    {
        
        apply_edge_animation(menu, menu.edge_animation_style_index);
        return;
    }
    
    
    if (isDefined(menu.edge_animation_elements) && menu.edge_animation_elements.size > 0)
    {
        
        switch(menu.edge_animation_style_index)
        {
            case 1: 
                
                if (isDefined(menu.edge_animation_elements[0]))
                {
                    menu.edge_animation_elements[0].x = menu.background.x;
                    menu.edge_animation_elements[0].y = menu.background.y;
                    menu.edge_animation_elements[0] setShader("white", menu.width, 2);
                }

                
                if (isDefined(menu.edge_animation_elements[1]))
                {
                    
                    if (menu.background.horzalign == "left")
                    {
                        menu.edge_animation_elements[1].x = menu.background.x + menu.width - 2;
                    }
                    else if (menu.background.horzalign == "right")
                    {
                        menu.edge_animation_elements[1].x = menu.background.x + menu.width - 2;
                    }
                    else 
                    {
                        menu.edge_animation_elements[1].x = menu.background.x + (menu.width / 2);
                    }
                    menu.edge_animation_elements[1].y = menu.background.y;
                    menu.edge_animation_elements[1] setShader("white", 2, menu.height);
                }

                
                if (isDefined(menu.edge_animation_elements[2]))
                {
                    menu.edge_animation_elements[2].x = menu.background.x;
                    menu.edge_animation_elements[2].y = menu.background.y + menu.height - 2;
                    menu.edge_animation_elements[2] setShader("white", menu.width, 2);
                }

                
                if (isDefined(menu.edge_animation_elements[3]))
                {
                    menu.edge_animation_elements[3].x = menu.background.x;
                    menu.edge_animation_elements[3].y = menu.background.y;
                    menu.edge_animation_elements[3] setShader("white", 2, menu.height);
                }
                break;

            case 2: 
                
                if (isDefined(menu.edge_animation_elements[0]))
                {
                    menu.edge_animation_elements[0].x = menu.background.x;
                    menu.edge_animation_elements[0].y = menu.background.y;
                    menu.edge_animation_elements[0] setShader("white", menu.width, 2);
                }

                
                if (isDefined(menu.edge_animation_elements[1]))
                {
                    menu.edge_animation_elements[1].x = menu.background.x + menu.width - 2;
                    menu.edge_animation_elements[1].y = menu.background.y;
                    menu.edge_animation_elements[1] setShader("white", 2, menu.height);
                }

                
                if (isDefined(menu.edge_animation_elements[2]))
                {
                    menu.edge_animation_elements[2].x = menu.background.x;
                    menu.edge_animation_elements[2].y = menu.background.y + menu.height - 2;
                    menu.edge_animation_elements[2] setShader("white", menu.width, 2);
                }

                
                if (isDefined(menu.edge_animation_elements[3]))
                {
                    menu.edge_animation_elements[3].x = menu.background.x;
                    menu.edge_animation_elements[3].y = menu.background.y;
                    menu.edge_animation_elements[3] setShader("white", 2, menu.height);
                }
                break;
        }
    }

    
    menu.last_height = menu.height;

    
    if (isDefined(menu.edge_animation_style_index) && menu.edge_animation_style_index > 0)
    {
        menu.edge_animation_active = true;
        if (menu.edge_animation_style_index == 1) 
        {
            menu.user thread rainbow_edge_animation_effect(menu);
        }
        else if (menu.edge_animation_style_index == 2) 

        
        {
            menu.user thread pulse_edge_animation_effect(menu);
        }
    }
}