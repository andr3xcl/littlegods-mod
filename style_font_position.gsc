


#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;


init()
{
    
    level.font_positions = [];
    level.font_positions[0] = "Left";       
    level.font_positions[1] = "Center";     
    level.font_positions[2] = "Right";      
    
    
    level thread on_player_connect();
}


on_player_connect()
{
    for(;;)
    {
        level waittill("connected", player);
        player.font_position_index = 0; 
    }
}


get_font_position_name(position_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
        
    if (lang_index == 0) 
    {
        switch(position_index)
        {
            case 0: return "Izquierda";
            case 1: return "Centro";
            case 2: return "Derecha";
            default: return "Desconocido";
        }
    }
    else 
    {
        switch(position_index)
        {
            case 0: return "Left";
            case 1: return "Center";
            case 2: return "Right";
            default: return "Unknown";
        }
    }
}


apply_font_position(menu, position_index)
{
    if (!isDefined(position_index))
        position_index = 0; 
    
    
    menu.font_position_index = position_index;
    menu.owner.font_position_index = position_index;
    
    
    menu = update_menu_visuals_with_position(menu);
    
    return menu;
}


update_menu_visuals_with_position(menu)
{
    
    if (!isDefined(menu.items) || menu.items.size < 1)
        return menu;
    
    
    if (!isDefined(menu.background))
        return menu;
    
    
    original_x = menu.background.x;
    original_y = menu.background.y;
    original_width = menu.width;
    position_index = menu.font_position_index;
    
    
    for (i = 0; i < menu.items.size; i++)
    {
        if (isDefined(menu.items[i].item))
        {
            switch(position_index)
            {
                case 0: 
                    menu.items[i].item.x = original_x + 15; 
                    menu.items[i].item.alignX = "left";
                    break;
                    
                case 1: 
                    menu.items[i].item.x = original_x + (original_width / 2);
                    menu.items[i].item.alignX = "center";
                    break;
                    
                case 2: 
                    menu.items[i].item.x = original_x + original_width - 15; 
                    menu.items[i].item.alignX = "right";
                    break;
                    
                default: 
                    menu.items[i].item.x = original_x + 15;
                    menu.items[i].item.alignX = "left";
                    break;
            }
            
            
            if (i == menu.selected)
                menu.items[i].item.color = menu.active_color;
            else
                menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    
    if (isDefined(menu.title_text))
    {
        switch(position_index)
        {
            case 0: 
                menu.title_text.x = original_x + 10;
                menu.title_text.alignX = "left";
                break;
                
            case 1: 
                menu.title_text.x = original_x + (original_width / 2);
                menu.title_text.alignX = "center";
                break;
                
            case 2: 
                menu.title_text.x = original_x + original_width - 10;
                menu.title_text.alignX = "right";
                break;
                
            default: 
                menu.title_text.x = original_x + 10;
                menu.title_text.alignX = "left";
                break;
        }
        
        
        menu.title_text.color = menu.title_color;
    }
    
    
    if (isDefined(menu.title_shadow))
    {
        switch(position_index)
        {
            case 0: 
                menu.title_shadow.x = original_x + 12; 
                menu.title_shadow.alignX = "left";
                break;
                
            case 1: 
                menu.title_shadow.x = original_x + (original_width / 2) + 2; 
                menu.title_shadow.alignX = "center";
                break;
                
            case 2: 
                menu.title_shadow.x = original_x + original_width - 8; 
                menu.title_shadow.alignX = "right";
                break;
                
            default: 
                menu.title_shadow.x = original_x + 12;
                menu.title_shadow.alignX = "left";
                break;
        }
    }
    
    
    if (isDefined(menu.selection_bar) && isDefined(menu.selected))
    {
        menu.selection_bar.y = original_y + menu.header_height + (menu.item_height * menu.selected);
        menu.selection_bar.color = menu.active_color;
    }
    
    return menu;
}


cycle_font_position(menu)
{
    self endon("disconnect");

    
    if (isDefined(self.is_cycling_font_position))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_font_position = true;

    
    current_index = self.font_position_index;
    next_index = (current_index + 1) % 3; 

    
    self.font_position_index = next_index;

    
    self playLocalSound("ui_mouse_click");

    
    position_name = get_font_position_name(next_index, self.langLEN);

    
    if (isDefined(self.menu_current))
    {
        
        self.menu_current = apply_font_position(self.menu_current, next_index);
        
        
        if (isDefined(self.menu_current.items))
        {
            
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (isDefined(self.menu_current.items[i]) && isDefined(self.menu_current.items[i].func))
                {
                    
                    if (self.menu_current.items[i].func == ::cycle_font_position)
                    {
                        if (self.langLEN == 0) 
                            self.menu_current.items[i].item setText("Posición Texto: " + position_name);
                        else 
                            self.menu_current.items[i].item setText("Text Position: " + position_name);
                        break;
                    }
                }
            }
        }
    }

    
    level thread update_all_active_menus_font_position(self, next_index);

    
    wait 0.2;
    self.is_cycling_font_position = undefined;

    return;
}


update_all_active_menus_font_position(player, font_position_index)
{
    
    

    
    if (isDefined(player.menu_current))
    {
        player.menu_current = apply_font_position(player.menu_current, font_position_index);
    }

    

    
    if (isDefined(player) && isDefined(player.menu_current) && isDefined(player.menu_current.sub_menu))
    {
        player.menu_current.sub_menu = apply_font_position(player.menu_current.sub_menu, font_position_index);
    }
} 