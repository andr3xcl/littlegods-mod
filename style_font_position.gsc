// Librería para gestionar las posiciones de texto en el sistema de menús
// Permite cambiar entre diferentes posiciones de texto: izquierda, centro y derecha

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

// Inicialización de posiciones de texto
init()
{
    // Definir las posiciones disponibles
    level.font_positions = [];
    level.font_positions[0] = "Left";       // Alineación a la izquierda (predeterminado)
    level.font_positions[1] = "Center";     // Alineación al centro
    level.font_positions[2] = "Right";      // Alineación a la derecha
    
    // Inicializar variables para cada jugador cuando se conecta
    level thread on_player_connect();
}

// Gestionar la inicialización para cada jugador
on_player_connect()
{
    for(;;)
    {
        level waittill("connected", player);
        player.font_position_index = 0; // Posición predeterminada: izquierda
    }
}

// Obtener el nombre de la posición según el índice y el idioma
get_font_position_name(position_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
        
    if (lang_index == 0) // Español
    {
        switch(position_index)
        {
            case 0: return "Izquierda";
            case 1: return "Centro";
            case 2: return "Derecha";
            default: return "Desconocido";
        }
    }
    else // Inglés
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

// Función para aplicar la posición del texto a un menú específico
apply_font_position(menu, position_index)
{
    if (!isDefined(position_index))
        position_index = 0; // Posición predeterminada: izquierda
    
    // Guardar la posición actual
    menu.font_position_index = position_index;
    menu.owner.font_position_index = position_index;
    
    // Actualizar los elementos visuales con la nueva posición
    menu = update_menu_visuals_with_position(menu);
    
    return menu;
}

// Función para actualizar los elementos visuales del menú según la posición
update_menu_visuals_with_position(menu)
{
    // Si no hay elementos, no hay nada que hacer
    if (!isDefined(menu.items) || menu.items.size < 1)
        return menu;
    
    // Si no hay elementos visuales creados todavía, no hay nada que hacer
    if (!isDefined(menu.background))
        return menu;
    
    // Obtener las coordenadas originales y dimensiones del menú
    original_x = menu.background.x;
    original_y = menu.background.y;
    original_width = menu.width;
    position_index = menu.font_position_index;
    
    // Actualizar la posición de los elementos según la posición seleccionada
    for (i = 0; i < menu.items.size; i++)
    {
        if (isDefined(menu.items[i].item))
        {
            switch(position_index)
            {
                case 0: // Izquierda
                    menu.items[i].item.x = original_x + 15; // Margen izquierdo
                    menu.items[i].item.alignX = "left";
                    break;
                    
                case 1: // Centro
                    menu.items[i].item.x = original_x + (original_width / 2);
                    menu.items[i].item.alignX = "center";
                    break;
                    
                case 2: // Derecha
                    menu.items[i].item.x = original_x + original_width - 15; // Margen derecho
                    menu.items[i].item.alignX = "right";
                    break;
                    
                default: // Por defecto, izquierda
                    menu.items[i].item.x = original_x + 15;
                    menu.items[i].item.alignX = "left";
                    break;
            }
            
            // Asegurarnos de que el color se mantiene correcto
            if (i == menu.selected)
                menu.items[i].item.color = menu.active_color;
            else
                menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    // También actualizar el texto del título si existe
    if (isDefined(menu.title_text))
    {
        switch(position_index)
        {
            case 0: // Izquierda
                menu.title_text.x = original_x + 10;
                menu.title_text.alignX = "left";
                break;
                
            case 1: // Centro
                menu.title_text.x = original_x + (original_width / 2);
                menu.title_text.alignX = "center";
                break;
                
            case 2: // Derecha
                menu.title_text.x = original_x + original_width - 10;
                menu.title_text.alignX = "right";
                break;
                
            default: // Por defecto, izquierda
                menu.title_text.x = original_x + 10;
                menu.title_text.alignX = "left";
                break;
        }
        
        // Asegurar que el color del título es correcto
        menu.title_text.color = menu.title_color;
    }
    
    // NUEVO: También actualizar la sombra del título si existe
    if (isDefined(menu.title_shadow))
    {
        switch(position_index)
        {
            case 0: // Izquierda
                menu.title_shadow.x = original_x + 12; // Desplazamiento para sombra
                menu.title_shadow.alignX = "left";
                break;
                
            case 1: // Centro
                menu.title_shadow.x = original_x + (original_width / 2) + 2; // Desplazamiento para sombra
                menu.title_shadow.alignX = "center";
                break;
                
            case 2: // Derecha
                menu.title_shadow.x = original_x + original_width - 8; // Desplazamiento para sombra
                menu.title_shadow.alignX = "right";
                break;
                
            default: // Por defecto, izquierda
                menu.title_shadow.x = original_x + 12;
                menu.title_shadow.alignX = "left";
                break;
        }
    }
    
    // Asegurarnos de que la barra de selección esté actualizada
    if (isDefined(menu.selection_bar) && isDefined(menu.selected))
    {
        menu.selection_bar.y = original_y + menu.header_height + (menu.item_height * menu.selected);
        menu.selection_bar.color = menu.active_color;
    }
    
    return menu;
}

// Función para cambiar la posición del texto (para ser usada como callback en el menú)
cycle_font_position(menu)
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_font_position))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_font_position = true;

    // Obtener el índice actual y avanzar al siguiente
    current_index = self.font_position_index;
    next_index = (current_index + 1) % 3; // 3 posiciones disponibles

    // Actualizar el índice de posición del texto
    self.font_position_index = next_index;

    // Reproducir sonido de cambio
    self playLocalSound("ui_mouse_click");

    // Obtener el nombre de la posición para actualizar el menú
    position_name = get_font_position_name(next_index, self.langLEN);

    // Aplicar la nueva posición a TODOS los menús activos inmediatamente
    if (isDefined(self.menu_current))
    {
        // Aplicar al menú principal si está activo
        self.menu_current = apply_font_position(self.menu_current, next_index);
        
        // Actualizar el texto del elemento del menú seleccionado
        if (isDefined(self.menu_current.items))
        {
            // Buscar la opción de posición de texto en el menú por su función
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (isDefined(self.menu_current.items[i]) && isDefined(self.menu_current.items[i].func))
                {
                    // Verificar si esta es la función de cambio de posición de texto
                    if (self.menu_current.items[i].func == ::cycle_font_position)
                    {
                        if (self.langLEN == 0) // Español
                            self.menu_current.items[i].item setText("Posición Texto: " + position_name);
                        else // Inglés
                            self.menu_current.items[i].item setText("Text Position: " + position_name);
                        break;
                    }
                }
            }
        }
    }

    // Actualizar también cualquier submenú que pueda estar abierto
    level thread update_all_active_menus_font_position(self, next_index);

    // Permitir que se vuelva a activar después de un breve tiempo
    wait 0.2;
    self.is_cycling_font_position = undefined;

    return;
}

// Función para actualizar la posición del texto en todos los menús activos
update_all_active_menus_font_position(player, font_position_index)
{
    // No esperar, aplicar inmediatamente
    // Esto asegura que el cambio se vea en tiempo real

    // Aplicar al propio jugador que hizo el cambio
    if (isDefined(player.menu_current))
    {
        player.menu_current = apply_font_position(player.menu_current, font_position_index);
    }

    // Si hay algún submenú activo, actualizarlo también
    if (isDefined(player) && isDefined(player.menu_current) && isDefined(player.menu_current.sub_menu))
    {
        player.menu_current.sub_menu = apply_font_position(player.menu_current.sub_menu, font_position_index);
    }
} 