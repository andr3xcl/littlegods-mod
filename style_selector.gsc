// Librería de estilos de selector para el sistema de menús
// Contiene diferentes estilos visuales que pueden aplicarse al selector del menú

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

// Inicialización de estilos de selector
init()
{
    // Definir los estilos de selector disponibles
    level.selector_styles = [];
    // Grupo 1: Estilos básicos
    level.selector_styles[0] = "Standard";       // Selector estándar (barra completa)
    level.selector_styles[1] = "Gradient";       // Selector con degradado
    level.selector_styles[2] = "Pulse";          // Selector con efecto pulsante
    level.selector_styles[3] = "ColorPulse";     // Selector con pulso de color
    level.selector_styles[4] = "SizePulse";      // Selector con pulso de tamaño
    level.selector_styles[5] = "BlinkPulse";     // Selector con efecto de parpadeo
    
    // Grupo 2: Estilos con flechas
    level.selector_styles[6] = "Arrow";          // Selector con flecha
    level.selector_styles[7] = "DoubleArrow";    // Selector con flechas dobles
    level.selector_styles[8] = "TripleArrows";   // Selector con tres flechas a cada lado
    level.selector_styles[9] = "DancingArrows";  // Selector con flechas bailando
    level.selector_styles[10] = "BlinkingArrows";// Selector con flechas parpadeantes
    level.selector_styles[11] = "RainbowArrows"; // Selector con flechas multicolor
    level.selector_styles[12] = "ArrowBar";      // Selector con barra y flechas
    
    // Grupo 3: Estilos con bordes
    level.selector_styles[13] = "Border";        // Selector con bordes
    level.selector_styles[14] = "BorderPulse";   // Selector con bordes pulsantes
    level.selector_styles[15] = "BorderWave";    // Selector con borde ondulado
    level.selector_styles[16] = "BorderCorners"; // Selector con bordes en las esquinas
    level.selector_styles[17] = "BorderGlow";    // Selector con bordes brillantes
    
    // Grupo 4: Otros estilos
    level.selector_styles[18] = "Dot";           // Selector con puntos
}

// Función para aplicar el estilo de selector seleccionado a un menú
apply_selector_style(menu, style_index)
{
    if (!isDefined(style_index))
        style_index = 14; // Estilo predeterminado: BorderPulse (ahora índice 14)
    
    // Guardar el estilo actual
    menu.selector_style_index = style_index;
    
    // Primero limpiar cualquier selector existente
    clear_existing_selector(menu);
    
    // Aplicar el estilo según el índice
    switch(style_index)
    {
        // Grupo 1: Estilos básicos
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
            
        // Grupo 2: Estilos con flechas
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
            
        // Grupo 3: Estilos con bordes
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
            
        // Grupo 4: Otros estilos
        case 18:
            apply_dot_selector(menu);
            break;
        default:
            apply_border_pulse_selector(menu); // Estilo predeterminado: Bordes Pulsantes
            break;
    }
    
    // Actualizar todos los elementos visuales para ajustarse al tamaño del menú
    update_selector_visuals(menu);
    
    return menu;
}

// Limpiar selector existente
clear_existing_selector(menu)
{
    // Detener cualquier efecto activo
    if (isDefined(menu.selector_effect_active))
    {
        menu.selector_effect_active = false;
        menu notify("stop_selector_effect");
    }
    
    // Destruir elementos adicionales del selector si existen
    if (isDefined(menu.selector_elements))
    {
        for (i = 0; i < menu.selector_elements.size; i++)
        {
            if (isDefined(menu.selector_elements[i]))
                menu.selector_elements[i] destroy();
        }
        menu.selector_elements = [];
    }
    
    // Asegurarse de que el selector principal existe
    if (!isDefined(menu.selection_bar))
    {
        menu.selection_bar = newClientHudElem(menu.user);
        menu.selection_bar.vertalign = "top";
        menu.selection_bar.horzalign = "left";
    }
    
    // Restaurar posición x original de la barra de selección
    menu.selection_bar.x = menu.background.x;
}

// Estilo 0: Selector estándar (barra completa)
apply_standard_selector(menu)
{
    // Configurar el selector como una barra normal (como ya estaba)
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.6;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; // Asegurar posición x correcta
    
    // Actualizar posición
    update_selector_position(menu);
}

// Estilo 1: Selector con flecha
apply_arrow_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Flecha izquierda (triángulo)
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; // Ajustado de -15 a -8 para mejor centrado
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    // Usar un triángulo simple en lugar de shader
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    // Flecha derecha (triángulo)
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; // Ajustado de +5 a +2 para mejor centrado
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    // Usar un triángulo simple en lugar de shader
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    // Iniciar efecto de animación de las flechas
    menu.selector_effect_active = true;
    menu.user thread arrow_animation_effect(menu);
}

// Efecto de animación para las flechas
arrow_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Animar posición de las flechas
        original_x_left = menu.selector_elements[0].x;
        original_x_right = menu.selector_elements[1].x;
        
        // Mover flechas hacia afuera
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        // Mover flechas hacia adentro
        for (i = 4; i >= 0; i--)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        wait 0.2;
    }
}

// Estilo 2: Selector con degradado
apply_gradient_selector(menu)
{
    // Configurar el selector con degradado
    menu.selection_bar setShader("gradient_fadein", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.8;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; // Asegurar posición x correcta
    
    // Actualizar posición
    update_selector_position(menu);
}

// Estilo 4: Selector con efecto pulsante
apply_pulse_selector(menu)
{
    // Configurar el selector como barra normal
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.6;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; // Asegurar posición x correcta
    
    // Actualizar posición
    update_selector_position(menu);
    
    // Iniciar efecto pulsante
    menu.selector_effect_active = true;
    menu.user thread pulse_animation_effect(menu);
}

// Efecto de animación pulsante
pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Aumentar alpha
        for (alpha = 0.3; alpha <= 0.8; alpha += 0.05)
        {
            menu.selection_bar.alpha = alpha;
            wait 0.05;
        }
        
        // Disminuir alpha
        for (alpha = 0.8; alpha >= 0.3; alpha -= 0.05)
        {
            menu.selection_bar.alpha = alpha;
            wait 0.05;
        }
    }
}

// Estilo 5: Selector con bordes
apply_border_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Borde superior
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = "top";
    top_border.horzalign = "left";
    top_border.x = menu.background.x;
    top_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    top_border.color = menu.active_color;
    top_border.alpha = 0.9;
    top_border setShader("white", menu.width, 1);
    
    // Borde inferior
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = "top";
    bottom_border.horzalign = "left";
    bottom_border.x = menu.background.x;
    bottom_border.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 1;
    bottom_border.color = menu.active_color;
    bottom_border.alpha = 0.9;
    bottom_border setShader("white", menu.width, 1);
    
    // Borde izquierdo
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = "top";
    left_border.horzalign = "left";
    left_border.x = menu.background.x;
    left_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    left_border.color = menu.active_color;
    left_border.alpha = 0.9;
    left_border setShader("white", 1, menu.item_height);
    
    // Borde derecho
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = "top";
    right_border.horzalign = "left";
    right_border.x = menu.background.x + menu.width - 1;
    right_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    right_border.color = menu.active_color;
    right_border.alpha = 0.9;
    right_border setShader("white", 1, menu.item_height);
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = top_border;
    menu.selector_elements[1] = bottom_border;
    menu.selector_elements[2] = left_border;
    menu.selector_elements[3] = right_border;
}

// Estilo 6: Selector con puntos
apply_dot_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Punto izquierdo
    left_dot = newClientHudElem(menu.user);
    left_dot.vertalign = "top";
    left_dot.horzalign = "left";
    left_dot.x = menu.background.x + 5;
    left_dot.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
    left_dot.color = menu.active_color;
    left_dot.alpha = 0.9;
    left_dot setShader("white", 6, 6);
    
    // Punto derecho
    right_dot = newClientHudElem(menu.user);
    right_dot.vertalign = "top";
    right_dot.horzalign = "left";
    right_dot.x = menu.background.x + menu.width - 11;
    right_dot.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
    right_dot.color = menu.active_color;
    right_dot.alpha = 0.9;
    right_dot setShader("white", 6, 6);
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = left_dot;
    menu.selector_elements[1] = right_dot;
}

// Estilo 7: Selector subrayado
apply_underline_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Línea de subrayado
    underline = newClientHudElem(menu.user);
    underline.vertalign = "top";
    underline.horzalign = "left";
    underline.x = menu.background.x + 15;
    underline.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 4;
    underline.color = menu.active_color;
    underline.alpha = 0.9;
    underline setShader("white", menu.width - 30, 2);
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = underline;
}

// Estilo 8: Selector con pulso de color
apply_color_pulse_selector(menu)
{
    // Configurar el selector como barra normal
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.7;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; // Asegurar posición x correcta
    
    // Actualizar posición
    update_selector_position(menu);
    
    // Iniciar efecto de pulso de color
    menu.selector_effect_active = true;
    menu.user thread color_pulse_animation_effect(menu);
}

// Efecto de animación de pulso de color
color_pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    // Color original
    original_color = menu.active_color;
    
    // Segundo color para alternar (complementario)
    second_color = (1 - original_color[0], 1 - original_color[1], 1 - original_color[2]);
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Transición al segundo color
        for (i = 0; i <= 10; i++)
        {
            t = i / 10; // Factor de interpolación (0-1)
            r = original_color[0] * (1 - t) + second_color[0] * t;
            g = original_color[1] * (1 - t) + second_color[1] * t;
            b = original_color[2] * (1 - t) + second_color[2] * t;
            
            menu.selection_bar.color = (r, g, b);
            wait 0.05;
        }
        
        // Transición al color original
        for (i = 10; i >= 0; i--)
        {
            t = i / 10; // Factor de interpolación (0-1)
            r = original_color[0] * (1 - t) + second_color[0] * t;
            g = original_color[1] * (1 - t) + second_color[1] * t;
            b = original_color[2] * (1 - t) + second_color[2] * t;
            
            menu.selection_bar.color = (r, g, b);
            wait 0.05;
        }
    }
}

// Estilo 9: Selector con pulso de tamaño
apply_size_pulse_selector(menu)
{
    // Configurar el selector como barra normal
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.7;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; // Asegurar posición x correcta
    
    // Actualizar posición
    update_selector_position(menu);
    
    // Iniciar efecto de pulso de tamaño
    menu.selector_effect_active = true;
    menu.user thread size_pulse_animation_effect(menu);
}

// Efecto de animación de pulso de tamaño
size_pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    // Tamaño original
    original_height = menu.item_height;
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Aumentar tamaño
        for (scale = 0; scale <= 4; scale++)
        {
            new_height = original_height + scale;
            menu.selection_bar setShader("white", menu.width, new_height);
            
            // Reposicionar para mantener centrado
            offset = (new_height - original_height) / 2;
            menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) - offset;
            
            wait 0.05;
        }
        
        // Disminuir tamaño
        for (scale = 4; scale >= 0; scale--)
        {
            new_height = original_height + scale;
            menu.selection_bar setShader("white", menu.width, new_height);
            
            // Reposicionar para mantener centrado
            offset = (new_height - original_height) / 2;
            menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) - offset;
            
            wait 0.05;
        }
        
        wait 0.2;
    }
}

// Estilo 10: Selector con bordes pulsantes
apply_border_pulse_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Borde superior
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = "top";
    top_border.horzalign = "left";
    top_border.x = menu.background.x;
    top_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    top_border.color = menu.active_color;
    top_border.alpha = 0.5; // Iniciar con opacidad media
    top_border setShader("white", menu.width, 2);
    
    // Borde inferior
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = "top";
    bottom_border.horzalign = "left";
    bottom_border.x = menu.background.x;
    bottom_border.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
    bottom_border.color = menu.active_color;
    bottom_border.alpha = 0.5; // Iniciar con opacidad media
    bottom_border setShader("white", menu.width, 2);
    
    // Borde izquierdo
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = "top";
    left_border.horzalign = "left";
    left_border.x = menu.background.x;
    left_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    left_border.color = menu.active_color;
    left_border.alpha = 0.5; // Iniciar con opacidad media
    left_border setShader("white", 2, menu.item_height);
    
    // Borde derecho
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = "top";
    right_border.horzalign = "left";
    right_border.x = menu.background.x + menu.width - 2;
    right_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    right_border.color = menu.active_color;
    right_border.alpha = 0.5; // Iniciar con opacidad media
    right_border setShader("white", 2, menu.item_height);
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = top_border;
    menu.selector_elements[1] = bottom_border;
    menu.selector_elements[2] = left_border;
    menu.selector_elements[3] = right_border;
    
    // Iniciar efecto de pulso para los bordes
    menu.selector_effect_active = true;
    menu.user thread border_pulse_animation_effect(menu);
}

// Efecto de animación para bordes pulsantes
border_pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Activar cada borde secuencialmente
        
        // Borde superior
        menu.selector_elements[0].alpha = 1;
        menu.selector_elements[1].alpha = 0.3;
        menu.selector_elements[2].alpha = 0.3;
        menu.selector_elements[3].alpha = 0.3;
        wait 0.15;
        
        // Borde derecho
        menu.selector_elements[0].alpha = 0.3;
        menu.selector_elements[1].alpha = 0.3;
        menu.selector_elements[2].alpha = 0.3;
        menu.selector_elements[3].alpha = 1;
        wait 0.15;
        
        // Borde inferior
        menu.selector_elements[0].alpha = 0.3;
        menu.selector_elements[1].alpha = 1;
        menu.selector_elements[2].alpha = 0.3;
        menu.selector_elements[3].alpha = 0.3;
        wait 0.15;
        
        // Borde izquierdo
        menu.selector_elements[0].alpha = 0.3;
        menu.selector_elements[1].alpha = 0.3;
        menu.selector_elements[2].alpha = 1;
        menu.selector_elements[3].alpha = 0.3;
        wait 0.15;
        
        // Todos los bordes activados
        menu.selector_elements[0].alpha = 1;
        menu.selector_elements[1].alpha = 1;
        menu.selector_elements[2].alpha = 1;
        menu.selector_elements[3].alpha = 1;
        wait 0.3;
        
        // Todos los bordes con opacidad media
        menu.selector_elements[0].alpha = 0.7;
        menu.selector_elements[1].alpha = 0.7;
        menu.selector_elements[2].alpha = 0.7;
        menu.selector_elements[3].alpha = 0.7;
        wait 0.2;
    }
}

// Estilo 11: Selector con efecto de parpadeo
apply_blink_pulse_selector(menu)
{
    // Configurar el selector como barra normal
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.7;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x; // Asegurar posición x correcta
    
    // Actualizar posición
    update_selector_position(menu);
    
    // Iniciar efecto de parpadeo
    menu.selector_effect_active = true;
    menu.user thread blink_pulse_animation_effect(menu);
}

// Efecto de animación de parpadeo
blink_pulse_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Parpadeo rápido (3 veces)
        for (i = 0; i < 3; i++)
        {
            menu.selector_elements[0].alpha = 0.1;
            wait 0.1;
            menu.selector_elements[0].alpha = 0.7;
            wait 0.1;
        }
        
        // Pausa antes del siguiente ciclo
        wait 0.8;
    }
}

// Estilo 12: Selector con flechas dobles
apply_double_arrow_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Flecha izquierda (doble)
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; // Ajustado de -15 a -8 para mejor centrado
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    // Usar texto de doble flecha
    left_arrow.fontscale = 1.4;
    left_arrow setText(">>");
    
    // Flecha derecha (doble)
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; // Ajustado de +5 a +2 para mejor centrado
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    // Usar texto de doble flecha
    right_arrow.fontscale = 1.4;
    right_arrow setText("<<");
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    // Iniciar efecto de animación de las flechas
    menu.selector_effect_active = true;
    menu.user thread double_arrow_animation_effect(menu);
}

// Efecto de animación para las flechas dobles
double_arrow_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Animar posición de las flechas
        original_x_left = menu.selector_elements[0].x;
        original_x_right = menu.selector_elements[1].x;
        
        // Mover flechas hacia afuera
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        // Mover flechas hacia adentro
        for (i = 4; i >= 0; i--)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        wait 0.2;
    }
}

// Estilo 13: Selector con símbolos < >
apply_angle_brackets_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Símbolo izquierdo
    left_bracket = newClientHudElem(menu.user);
    left_bracket.vertalign = "top";
    left_bracket.horzalign = "left";
    left_bracket.x = menu.background.x + 5;
    left_bracket.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) + 2;
    left_bracket.color = menu.active_color;
    left_bracket.alpha = 0.9;
    left_bracket.fontscale = 1.8;
    left_bracket setText("<");
    
    // Corchete derecho
    right_bracket = newClientHudElem(menu.user);
    right_bracket.vertalign = "top";
    right_bracket.horzalign = "left";
    right_bracket.x = menu.background.x + menu.width - 10;
    right_bracket.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) + 2;
    right_bracket.color = menu.active_color;
    right_bracket.alpha = 0.9;
    right_bracket.fontscale = 1.8;
    right_bracket setText(">");
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = left_bracket;
    menu.selector_elements[1] = right_bracket;
}

// Estilo 14: Selector con flechas bailando
apply_dancing_arrows_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Flecha izquierda
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; // Ajustado de -15 a -8 para mejor centrado
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    // Usar texto en lugar de shader
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    // Flecha derecha
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; // Ajustado de +5 a +2 para mejor centrado
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    // Usar texto en lugar de shader
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    // Iniciar efecto de animación de las flechas
    menu.selector_effect_active = true;
    menu.user thread dancing_arrows_animation_effect(menu);
}

// Efecto de animación para las flechas bailando
dancing_arrows_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Animar posición de las flechas
        original_x_left = menu.selector_elements[0].x;
        original_x_right = menu.selector_elements[1].x;
        
        // Mover flechas hacia afuera
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        // Mover flechas hacia adentro
        for (i = 4; i >= 0; i--)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        wait 0.2;
    }
}

// Estilo 15: Selector con flechas parpadeantes
apply_blinking_arrows_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Flecha izquierda
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; // Ajustado de -15 a -8 para mejor centrado
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    // Usar texto en lugar de shader
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    // Flecha derecha
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; // Ajustado de +5 a +2 para mejor centrado
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    // Usar texto en lugar de shader
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    // Iniciar efecto de animación de las flechas
    menu.selector_effect_active = true;
    menu.user thread blinking_arrows_animation_effect(menu);
}

// Efecto de animación para las flechas parpadeantes
blinking_arrows_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Animar posición de las flechas
        original_x_left = menu.selector_elements[0].x;
        original_x_right = menu.selector_elements[1].x;
        
        // Mover flechas hacia afuera
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        // Mover flechas hacia adentro
        for (i = 4; i >= 0; i--)
        {
            menu.selector_elements[0].x = original_x_left - i;
            menu.selector_elements[1].x = original_x_right + i;
            wait 0.04;
        }
        
        wait 0.2;
    }
}

// Estilo 16: Selector con triple flechas
apply_triple_arrows_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Posiciones y tamaños para las flechas
    spacing = 10; // Espaciado entre flechas
    
    // Posición central para las flechas izquierdas y derechas
    pos_y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    
    // Primera flecha izquierda (exterior)
    left_arrow1 = newClientHudElem(menu.user);
    left_arrow1.vertalign = "top";
    left_arrow1.horzalign = "left";
    left_arrow1.x = menu.background.x - 28 - (spacing * 2); // Ajustado de -35 a -28 para mejor centrado
    left_arrow1.y = pos_y;
    left_arrow1.color = menu.active_color;
    left_arrow1.alpha = 1;
    left_arrow1.fontscale = 1.5;
    left_arrow1 setText(">");
    
    // Segunda flecha izquierda (media)
    left_arrow2 = newClientHudElem(menu.user);
    left_arrow2.vertalign = "top";
    left_arrow2.horzalign = "left";
    left_arrow2.x = menu.background.x - 28 - spacing; // Ajustado de -35 a -28 para mejor centrado
    left_arrow2.y = pos_y;
    left_arrow2.color = menu.active_color;
    left_arrow2.alpha = 1;
    left_arrow2.fontscale = 1.5;
    left_arrow2 setText(">");
    
    // Tercera flecha izquierda (interior)
    left_arrow3 = newClientHudElem(menu.user);
    left_arrow3.vertalign = "top";
    left_arrow3.horzalign = "left";
    left_arrow3.x = menu.background.x - 28; // Ajustado de -35 a -28 para mejor centrado
    left_arrow3.y = pos_y;
    left_arrow3.color = menu.active_color;
    left_arrow3.alpha = 1;
    left_arrow3.fontscale = 1.5;
    left_arrow3 setText(">");
    
    // Primera flecha derecha (interior)
    right_arrow1 = newClientHudElem(menu.user);
    right_arrow1.vertalign = "top";
    right_arrow1.horzalign = "left";
    right_arrow1.x = menu.background.x + menu.width + 8; // Ajustado de +15 a +8 para mejor centrado
    right_arrow1.y = pos_y;
    right_arrow1.color = menu.active_color;
    right_arrow1.alpha = 1;
    right_arrow1.fontscale = 1.5;
    right_arrow1 setText("<");
    
    // Segunda flecha derecha (media)
    right_arrow2 = newClientHudElem(menu.user);
    right_arrow2.vertalign = "top";
    right_arrow2.horzalign = "left";
    right_arrow2.x = menu.background.x + menu.width + 8 + spacing; // Ajustado de +15 a +8 para mejor centrado
    right_arrow2.y = pos_y;
    right_arrow2.color = menu.active_color;
    right_arrow2.alpha = 1;
    right_arrow2.fontscale = 1.5;
    right_arrow2 setText("<");
    
    // Tercera flecha derecha (exterior)
    right_arrow3 = newClientHudElem(menu.user);
    right_arrow3.vertalign = "top";
    right_arrow3.horzalign = "left";
    right_arrow3.x = menu.background.x + menu.width + 8 + (spacing * 2); // Ajustado de +15 a +8 para mejor centrado
    right_arrow3.y = pos_y;
    right_arrow3.color = menu.active_color;
    right_arrow3.alpha = 1;
    right_arrow3.fontscale = 1.5;
    right_arrow3 setText("<");
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = left_arrow1;
    menu.selector_elements[1] = left_arrow2;
    menu.selector_elements[2] = left_arrow3;
    menu.selector_elements[3] = right_arrow1;
    menu.selector_elements[4] = right_arrow2;
    menu.selector_elements[5] = right_arrow3;
    
    // Iniciar efecto de animación secuencial para las flechas
    menu.selector_effect_active = true;
    menu.user thread triple_arrows_animation_effect(menu);
}

// Efecto de animación para las flechas triples
triple_arrows_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Secuencia de parpadeo de flechas exteriores a interiores
        
        // Exterior solamente
        menu.selector_elements[0].alpha = 1;
        menu.selector_elements[5].alpha = 1;
        menu.selector_elements[1].alpha = 0.4;
        menu.selector_elements[4].alpha = 0.4;
        menu.selector_elements[2].alpha = 0.4;
        menu.selector_elements[3].alpha = 0.4;
        wait 0.2;
        
        // Medio solamente
        menu.selector_elements[0].alpha = 0.4;
        menu.selector_elements[5].alpha = 0.4;
        menu.selector_elements[1].alpha = 1;
        menu.selector_elements[4].alpha = 1;
        menu.selector_elements[2].alpha = 0.4;
        menu.selector_elements[3].alpha = 0.4;
        wait 0.2;
        
        // Interior solamente
        menu.selector_elements[0].alpha = 0.4;
        menu.selector_elements[5].alpha = 0.4;
        menu.selector_elements[1].alpha = 0.4;
        menu.selector_elements[4].alpha = 0.4;
        menu.selector_elements[2].alpha = 1;
        menu.selector_elements[3].alpha = 1;
        wait 0.2;
        
        // Todas las flechas visibles
        menu.selector_elements[0].alpha = 1;
        menu.selector_elements[5].alpha = 1;
        menu.selector_elements[1].alpha = 1;
        menu.selector_elements[4].alpha = 1;
        menu.selector_elements[2].alpha = 1;
        menu.selector_elements[3].alpha = 1;
        wait 0.4;
    }
}

// Estilo 17: Selector con flechas multicolor (arcoíris)
apply_rainbow_arrows_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.3;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Flecha izquierda
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x - 8; // Ajustado de -15 a -8 para mejor centrado
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = (1, 0, 0); // Rojo inicial
    left_arrow.alpha = 0.9;
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    // Flecha derecha
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width + 2; // Ajustado de +5 a +2 para mejor centrado
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = (1, 0, 0); // Rojo inicial
    right_arrow.alpha = 0.9;
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    // Iniciar efecto de cambio de color arcoíris
    menu.selector_effect_active = true;
    menu.user thread rainbow_arrows_animation_effect(menu);
}

// Efecto de animación para las flechas arcoíris
rainbow_arrows_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    // Colores arcoíris
    rainbow_colors = [];
    rainbow_colors[0] = (1, 0, 0);     // Rojo
    rainbow_colors[1] = (1, 0.5, 0);   // Naranja
    rainbow_colors[2] = (1, 1, 0);     // Amarillo
    rainbow_colors[3] = (0, 1, 0);     // Verde
    rainbow_colors[4] = (0, 0, 1);     // Azul
    rainbow_colors[5] = (0.5, 0, 1);   // Índigo
    rainbow_colors[6] = (1, 0, 1);     // Violeta
    
    color_index = 0;
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Cambiar color de ambas flechas
        menu.selector_elements[0].color = rainbow_colors[color_index];
        menu.selector_elements[1].color = rainbow_colors[color_index];
        
        // Incrementar índice de color
        color_index = (color_index + 1) % rainbow_colors.size;
        
        wait 0.3;
    }
}

// Estilo 18: Selector con barra y flechas
apply_arrow_bar_selector(menu)
{
    // Configurar el selector como barra normal pero más corta
    menu.selection_bar setShader("white", menu.width - 20, menu.item_height);
    menu.selection_bar.alpha = 0.5;
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar.x = menu.background.x + 10; // Centrar la barra acortada
    
    // Actualizar posición
    update_selector_position(menu);
    
    // Crear elementos adicionales del selector
    menu.selector_elements = [];
    
    // Flecha izquierda
    left_arrow = newClientHudElem(menu.user);
    left_arrow.vertalign = "top";
    left_arrow.horzalign = "left";
    left_arrow.x = menu.background.x;
    left_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    left_arrow.color = menu.active_color;
    left_arrow.alpha = 0.9;
    left_arrow.fontscale = 1.4;
    left_arrow setText(">");
    
    // Flecha derecha
    right_arrow = newClientHudElem(menu.user);
    right_arrow.vertalign = "top";
    right_arrow.horzalign = "left";
    right_arrow.x = menu.background.x + menu.width - 10;
    right_arrow.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
    right_arrow.color = menu.active_color;
    right_arrow.alpha = 0.9;
    right_arrow.fontscale = 1.4;
    right_arrow setText("<");
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = left_arrow;
    menu.selector_elements[1] = right_arrow;
    
    // Iniciar efecto pulsante para la barra y las flechas
    menu.selector_effect_active = true;
    menu.user thread arrow_bar_animation_effect(menu);
}

// Efecto de animación para la barra con flechas
arrow_bar_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Aumentar alpha de flechas, reducir de barra
        for (i = 0; i < 5; i++)
        {
            menu.selector_elements[0].alpha = 0.5 + (i * 0.1);
            menu.selector_elements[1].alpha = 0.5 + (i * 0.1);
            menu.selection_bar.alpha = 0.5 - (i * 0.05);
            wait 0.05;
        }
        
        // Reducir alpha de flechas, aumentar de barra
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

// Estilo 15: Selector con borde ondulado
apply_border_wave_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector: múltiples segmentos para el efecto de onda
    menu.selector_elements = [];
    
    // Cantidad de segmentos para el borde superior e inferior
    segments = 10;
    segment_width = menu.width / segments;
    
    // Crear segmentos del borde superior
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
    
    // Crear segmentos del borde inferior
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
    
    // Bordes laterales
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
    
    // Iniciar efecto de onda para los bordes
    menu.selector_effect_active = true;
    menu.user thread border_wave_animation_effect(menu, segments);
}

// Efecto de animación para el borde ondulado
border_wave_animation_effect(menu, segments)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    wave_offset = 0;
    max_displacement = 3; // Máxima desplazamiento vertical de la onda
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Actualizar posición de cada segmento superior según la onda
        for (i = 0; i < segments; i++)
        {
            // Calcular posición en la onda para este segmento
            wave_pos = (i + wave_offset) % segments;
            displacement = sin(wave_pos * (360/segments) * (3.14159/180)) * max_displacement;
            
            // Aplicar desplazamiento al segmento superior
            menu.selector_elements[i].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + displacement;
            
            // Aplicar desplazamiento al segmento inferior
            menu.selector_elements[segments + i].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2 - displacement;
        }
        
        // Incrementar offset para mover la onda
        wave_offset = (wave_offset + 1) % segments;
        
        wait 0.05;
    }
}

// Estilo 16: Selector con bordes en las esquinas
apply_border_corners_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector: 4 esquinas
    menu.selector_elements = [];
    
    // Tamaño de las esquinas (en píxeles)
    corner_size = 10;
    
    // Esquina superior izquierda - horizontal
    corner_top_left_h = newClientHudElem(menu.user);
    corner_top_left_h.vertalign = "top";
    corner_top_left_h.horzalign = "left";
    corner_top_left_h.x = menu.background.x;
    corner_top_left_h.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    corner_top_left_h.color = menu.active_color;
    corner_top_left_h.alpha = 0.9;
    corner_top_left_h setShader("white", corner_size, 2);
    
    // Esquina superior izquierda - vertical
    corner_top_left_v = newClientHudElem(menu.user);
    corner_top_left_v.vertalign = "top";
    corner_top_left_v.horzalign = "left";
    corner_top_left_v.x = menu.background.x;
    corner_top_left_v.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    corner_top_left_v.color = menu.active_color;
    corner_top_left_v.alpha = 0.9;
    corner_top_left_v setShader("white", 2, corner_size);
    
    // Esquina superior derecha - horizontal
    corner_top_right_h = newClientHudElem(menu.user);
    corner_top_right_h.vertalign = "top";
    corner_top_right_h.horzalign = "left";
    corner_top_right_h.x = menu.background.x + menu.width - corner_size;
    corner_top_right_h.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    corner_top_right_h.color = menu.active_color;
    corner_top_right_h.alpha = 0.9;
    corner_top_right_h setShader("white", corner_size, 2);
    
    // Esquina superior derecha - vertical
    corner_top_right_v = newClientHudElem(menu.user);
    corner_top_right_v.vertalign = "top";
    corner_top_right_v.horzalign = "left";
    corner_top_right_v.x = menu.background.x + menu.width - 2;
    corner_top_right_v.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    corner_top_right_v.color = menu.active_color;
    corner_top_right_v.alpha = 0.9;
    corner_top_right_v setShader("white", 2, corner_size);
    
    // Esquina inferior izquierda - horizontal
    corner_bottom_left_h = newClientHudElem(menu.user);
    corner_bottom_left_h.vertalign = "top";
    corner_bottom_left_h.horzalign = "left";
    corner_bottom_left_h.x = menu.background.x;
    corner_bottom_left_h.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
    corner_bottom_left_h.color = menu.active_color;
    corner_bottom_left_h.alpha = 0.9;
    corner_bottom_left_h setShader("white", corner_size, 2);
    
    // Esquina inferior izquierda - vertical
    corner_bottom_left_v = newClientHudElem(menu.user);
    corner_bottom_left_v.vertalign = "top";
    corner_bottom_left_v.horzalign = "left";
    corner_bottom_left_v.x = menu.background.x;
    corner_bottom_left_v.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
    corner_bottom_left_v.color = menu.active_color;
    corner_bottom_left_v.alpha = 0.9;
    corner_bottom_left_v setShader("white", 2, corner_size);
    
    // Esquina inferior derecha - horizontal
    corner_bottom_right_h = newClientHudElem(menu.user);
    corner_bottom_right_h.vertalign = "top";
    corner_bottom_right_h.horzalign = "left";
    corner_bottom_right_h.x = menu.background.x + menu.width - corner_size;
    corner_bottom_right_h.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
    corner_bottom_right_h.color = menu.active_color;
    corner_bottom_right_h.alpha = 0.9;
    corner_bottom_right_h setShader("white", corner_size, 2);
    
    // Esquina inferior derecha - vertical
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
    
    // Iniciar efecto de animación para las esquinas
    menu.selector_effect_active = true;
    menu.user thread border_corners_animation_effect(menu);
}

// Efecto de animación para las esquinas
border_corners_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Rotar efectos a través de las esquinas
        corner_set = 0;
        
        // 4 iteraciones para animar cada esquina secuencialmente
        for (corner_set = 0; corner_set < 4; corner_set++)
        {
            // Inicialmente todos con baja opacidad
            for (i = 0; i < 8; i++)
                menu.selector_elements[i].alpha = 0.3;
            
            // Activar esquina actual (2 elementos por esquina)
            menu.selector_elements[corner_set * 2].alpha = 1;
            menu.selector_elements[corner_set * 2 + 1].alpha = 1;
            
            // Parpadeo rápido
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
        
        // Al final, iluminar todas las esquinas
        for (i = 0; i < 8; i++)
            menu.selector_elements[i].alpha = 1;
            
        wait 0.5;
    }
}

// Estilo 17: Selector con bordes brillantes
apply_border_glow_selector(menu)
{
    // Mostrar barra de selección translúcida como fondo
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    menu.selection_bar.alpha = 0.1;
    menu.selection_bar.color = menu.active_color;
    
    // Crear elementos del selector
    menu.selector_elements = [];
    
    // Borde superior
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = "top";
    top_border.horzalign = "left";
    top_border.x = menu.background.x;
    top_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    top_border.color = menu.active_color;
    top_border.alpha = 0.9;
    top_border setShader("white", menu.width, 2);
    
    // Borde inferior
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = "top";
    bottom_border.horzalign = "left";
    bottom_border.x = menu.background.x;
    bottom_border.y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
    bottom_border.color = menu.active_color;
    bottom_border.alpha = 0.9;
    bottom_border setShader("white", menu.width, 2);
    
    // Borde izquierdo
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = "top";
    left_border.horzalign = "left";
    left_border.x = menu.background.x;
    left_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    left_border.color = menu.active_color;
    left_border.alpha = 0.9;
    left_border setShader("white", 2, menu.item_height);
    
    // Borde derecho
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = "top";
    right_border.horzalign = "left";
    right_border.x = menu.background.x + menu.width - 2;
    right_border.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    right_border.color = menu.active_color;
    right_border.alpha = 0.9;
    right_border setShader("white", 2, menu.item_height);
    
    // Guardar referencias para actualizaciones
    menu.selector_elements[0] = top_border;
    menu.selector_elements[1] = bottom_border;
    menu.selector_elements[2] = left_border;
    menu.selector_elements[3] = right_border;
    
    // Iniciar efecto de brillo para los bordes
    menu.selector_effect_active = true;
    menu.user thread border_glow_animation_effect(menu);
}

// Efecto de animación de brillo para bordes
border_glow_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_selector_effect");
    
    while(isDefined(menu.selector_effect_active) && menu.selector_effect_active)
    {
        // Color original
        original_color = menu.active_color;
        
        // Color brillante (más claro)
        bright_color = (
            min(1, original_color[0] + 0.3),
            min(1, original_color[1] + 0.3),
            min(1, original_color[2] + 0.3)
        );
        
        // Transición a color brillante
        for (i = 0; i <= 10; i++)
        {
            t = i / 10; // Factor de interpolación (0-1)
            r = original_color[0] * (1 - t) + bright_color[0] * t;
            g = original_color[1] * (1 - t) + bright_color[1] * t;
            b = original_color[2] * (1 - t) + bright_color[2] * t;
            
            for (j = 0; j < 4; j++)
                menu.selector_elements[j].color = (r, g, b);
                
            wait 0.04;
        }
        
        // Transición de regreso al color original
        for (i = 10; i >= 0; i--)
        {
            t = i / 10; // Factor de interpolación (0-1)
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

// Función nueva para actualizar todos los elementos visuales basados en el tamaño del menú
update_selector_visuals(menu)
{
    // Si el selector está oculto, salir
    if (!isDefined(menu) || !isDefined(menu.selection_bar))
        return;
    
    // Actualizar posición y tamaño de la barra de selección principal
    if (isDefined(menu.selection_bar))
    {
        if (menu.selector_style_index == 12) // ArrowBar (ahora índice 12)
        {
            // Para barra con flechas, hacer la barra más pequeña (80% del ancho)
            menu.selection_bar setShader("white", menu.width - 20, menu.item_height);
            menu.selection_bar.x = menu.background.x + 10;
        }
        else
        {
            // Para otros estilos, ajustar al ancho completo
            menu.selection_bar setShader("white", menu.width, menu.item_height);
            menu.selection_bar.x = menu.background.x;
        }

        menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    }

    // Actualizar elementos adicionales del selector si existen
    if (isDefined(menu.selector_style_index) && isDefined(menu.selector_elements))
    {
        switch(menu.selector_style_index)
        {
            case 6: // Arrow
            case 7: // DoubleArrow
            case 9: // DancingArrows
            case 10: // BlinkingArrows
            case 11: // RainbowArrows
                // Flecha izquierda, más cerca para mejor centrado
                menu.selector_elements[0].x = menu.background.x - 8; // Ajustado de -15 a -8
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;

                // Flecha derecha, más cerca para mejor centrado
                menu.selector_elements[1].x = menu.background.x + menu.width + 2; // Ajustado de +5 a +2
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                break;

            case 13: // Border (ahora índice 13)
            case 14: // BorderPulse (ahora índice 14)
                // Borde superior
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[0] setShader("white", menu.width, 1); // Ajustar ancho al menú

                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 1;
                menu.selector_elements[1] setShader("white", menu.width, 1); // Ajustar ancho al menú

                // Bordes verticales
                menu.selector_elements[2].x = menu.background.x;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[2] setShader("white", 1, menu.item_height);

                menu.selector_elements[3].x = menu.background.x + menu.width - 1;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3] setShader("white", 1, menu.item_height);
                break;

            case 15: // BorderWave (ahora índice 15)
                // Actualizar bordes laterales
                segments = 10;
                menu.selector_elements[segments * 2].x = menu.background.x;
                menu.selector_elements[segments * 2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[segments * 2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[segments * 2 + 1].x = menu.background.x + menu.width - 2;
                menu.selector_elements[segments * 2 + 1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[segments * 2 + 1] setShader("white", 2, menu.item_height);
                break;
                
            case 16: // BorderCorners (ahora índice 16)
                corner_size = 10;
                
                // Esquinas superiores
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                
                menu.selector_elements[2].x = menu.background.x + menu.width - corner_size;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                
                // Esquinas inferiores
                menu.selector_elements[4].x = menu.background.x;
                menu.selector_elements[4].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[5].x = menu.background.x;
                menu.selector_elements[5].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
                
                menu.selector_elements[6].x = menu.background.x + menu.width - corner_size;
                menu.selector_elements[6].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[7].x = menu.background.x + menu.width - 2;
                menu.selector_elements[7].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
                break;
                
            case 17: // BorderGlow (ahora índice 17)
                // Bordes horizontales
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[0] setShader("white", menu.width, 2);
                
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[1] setShader("white", menu.width, 2);
                
                // Bordes verticales
                menu.selector_elements[2].x = menu.background.x;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3] setShader("white", 2, menu.item_height);
                break;
                
            case 18: // Dot (ahora índice 18)
                // Punto izquierdo
                menu.selector_elements[0].x = menu.background.x + 5;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;

                // Punto derecho
                menu.selector_elements[1].x = menu.background.x + menu.width - 11;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
                break;

            case 8: // TripleArrows (ahora índice 8)
                spacing = 10;
                pos_y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 4;

                // Actualizar posiciones horizontales basadas en el ancho del menú
                menu.selector_elements[0].x = menu.background.x - 28 - (spacing * 2); // Ajustado de -35 a -28 para mejor centrado
                menu.selector_elements[1].x = menu.background.x - 28 - spacing; // Ajustado de -35 a -28 para mejor centrado
                menu.selector_elements[2].x = menu.background.x - 28; // Ajustado de -35 a -28 para mejor centrado

                menu.selector_elements[3].x = menu.background.x + menu.width + 8; // Ajustado de +15 a +8 para mejor centrado
                menu.selector_elements[4].x = menu.background.x + menu.width + 8 + spacing; // Ajustado de +15 a +8 para mejor centrado
                menu.selector_elements[5].x = menu.background.x + menu.width + 8 + (spacing * 2); // Ajustado de +15 a +8 para mejor centrado

                // Actualizar posiciones verticales
                for (i = 0; i < 6; i++)
                    menu.selector_elements[i].y = pos_y;
                break;

            case 12: // ArrowBar (ahora índice 12)
                menu.selector_elements[0].x = menu.background.x; // Alineado con borde izquierdo
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;

                // Flecha derecha, alineada con el borde derecho
                menu.selector_elements[1].x = menu.background.x + menu.width - 10;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;

                // Actualizar barra central
                menu.selection_bar setShader("white", menu.width - 20, menu.item_height);
                menu.selection_bar.x = menu.background.x + 10;
                menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                break;
        }
    }
}

// Actualizar posición del selector cuando cambia la selección
update_selector_position(menu)
{
    // Actualizar posición de la barra de selección principal
    if (isDefined(menu.selection_bar))
    {
        // Mantener posición x según el estilo actual
        if (isDefined(menu.selector_style_index) && menu.selector_style_index == 12) // ArrowBar (ahora índice 12)
        {
            // Para barra con flechas, centrar la barra acortada
            menu.selection_bar.x = menu.background.x + 10;
        }
        else
        {
            // Para otros estilos, asegurar que la barra está en posición correcta
            menu.selection_bar.x = menu.background.x;
        }
        
        // Actualizar posición y
        menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    }
    
    // Si hay elementos adicionales del selector, actualizar sus posiciones
    if (isDefined(menu.selector_style_index) && isDefined(menu.selector_elements))
    {
        switch(menu.selector_style_index)
        {
            case 6: // Arrow
            case 7: // DoubleArrow
            case 9: // DancingArrows
            case 10: // BlinkingArrows
            case 11: // RainbowArrows
                // Flecha izquierda, más cerca para mejor centrado
                menu.selector_elements[0].x = menu.background.x - 8; // Ajustado de -15 a -8
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                
                // Flecha derecha, más cerca para mejor centrado
                menu.selector_elements[1].x = menu.background.x + menu.width + 2; // Ajustado de +5 a +2
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                break;
                
            case 13: // Border (ahora índice 13)
            case 14: // BorderPulse (ahora índice 14)
                // Bordes horizontales
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[0] setShader("white", menu.width, 2); // Ajustar ancho al menú
                
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[1] setShader("white", menu.width, 2); // Ajustar ancho al menú
                
                // Bordes verticales
                menu.selector_elements[2].x = menu.background.x;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3] setShader("white", 2, menu.item_height);
                break;
                
            case 15: // BorderWave (ahora índice 15)
                // Actualizar bordes laterales
                segments = 10;
                menu.selector_elements[segments * 2].x = menu.background.x;
                menu.selector_elements[segments * 2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[segments * 2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[segments * 2 + 1].x = menu.background.x + menu.width - 2;
                menu.selector_elements[segments * 2 + 1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[segments * 2 + 1] setShader("white", 2, menu.item_height);
                break;
                
            case 16: // BorderCorners (ahora índice 16)
                corner_size = 10;
                
                // Esquinas superiores
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                
                menu.selector_elements[2].x = menu.background.x + menu.width - corner_size;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                
                // Esquinas inferiores
                menu.selector_elements[4].x = menu.background.x;
                menu.selector_elements[4].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[5].x = menu.background.x;
                menu.selector_elements[5].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
                
                menu.selector_elements[6].x = menu.background.x + menu.width - corner_size;
                menu.selector_elements[6].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[7].x = menu.background.x + menu.width - 2;
                menu.selector_elements[7].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - corner_size;
                break;
                
            case 17: // BorderGlow (ahora índice 17)
                // Bordes horizontales
                menu.selector_elements[0].x = menu.background.x;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[0] setShader("white", menu.width, 2);
                
                menu.selector_elements[1].x = menu.background.x;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * (menu.selected + 1)) - 2;
                menu.selector_elements[1] setShader("white", menu.width, 2);
                
                // Bordes verticales
                menu.selector_elements[2].x = menu.background.x;
                menu.selector_elements[2].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[2] setShader("white", 2, menu.item_height);
                
                menu.selector_elements[3].x = menu.background.x + menu.width - 2;
                menu.selector_elements[3].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                menu.selector_elements[3] setShader("white", 2, menu.item_height);
                break;
                
            case 18: // Dot (ahora índice 18)
                menu.selector_elements[0].x = menu.background.x + 5;
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
                menu.selector_elements[1].x = menu.background.x + menu.width - 11;
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 3;
                break;
                
            case 8: // TripleArrows (ahora índice 8)
                spacing = 10;
                pos_y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 4;
                
                // Actualizar posiciones horizontales basadas en el ancho del menú
                menu.selector_elements[0].x = menu.background.x - 28 - (spacing * 2); // Ajustado de -35 a -28 para mejor centrado
                menu.selector_elements[1].x = menu.background.x - 28 - spacing; // Ajustado de -35 a -28 para mejor centrado
                menu.selector_elements[2].x = menu.background.x - 28; // Ajustado de -35 a -28 para mejor centrado
                
                menu.selector_elements[3].x = menu.background.x + menu.width + 8; // Ajustado de +15 a +8 para mejor centrado
                menu.selector_elements[4].x = menu.background.x + menu.width + 8 + spacing; // Ajustado de +15 a +8 para mejor centrado
                menu.selector_elements[5].x = menu.background.x + menu.width + 8 + (spacing * 2); // Ajustado de +15 a +8 para mejor centrado
                
                // Actualizar posiciones verticales
                for (i = 0; i < 6; i++)
                    menu.selector_elements[i].y = pos_y;
                break;
                
            case 12: // ArrowBar (ahora índice 12)
                menu.selector_elements[0].x = menu.background.x; // Alineado con borde izquierdo
                menu.selector_elements[0].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                menu.selector_elements[1].x = menu.background.x + menu.width - 10; // Alineado con borde derecho
                menu.selector_elements[1].y = menu.background.y + menu.header_height + (menu.item_height * menu.selected) + (menu.item_height / 2) - 5;
                
                // Actualizar barra central
                menu.selection_bar setShader("white", menu.width - 20, menu.item_height);
                menu.selection_bar.x = menu.background.x + 10;
                menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
                break;
        }
    }
}

// Obtener el nombre del estilo según el índice y el idioma
get_selector_style_name(style_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
        
    if (lang_index == 0) // Español
    {
        switch(style_index)
        {
            // Grupo 1: Estilos básicos
            case 0: return "Estándar";
            case 1: return "Degradado";
            case 2: return "Pulsante";
            case 3: return "Pulso Color";
            case 4: return "Pulso Tamaño";
            case 5: return "Parpadeo";
            
            // Grupo 2: Estilos con flechas
            case 6: return "Flechas";
            case 7: return "Flechas Dobles";
            case 8: return "Triple Flecha";
            case 9: return "Flechas Bailando";
            case 10: return "Flechas Parpadeantes";
            case 11: return "Flechas Arcoíris";
            case 12: return "Barra con Flechas";
            
            // Grupo 3: Estilos con bordes
            case 13: return "Bordes";
            case 14: return "Bordes Pulsantes";
            case 15: return "Borde Ondulado";
            case 16: return "Borde Esquinas";
            case 17: return "Borde Brillante";
            
            // Grupo 4: Otros estilos
            case 18: return "Puntos";
            default: return "Bordes Pulsantes";
        }
    }
    else // Inglés
    {
        switch(style_index)
        {
            // Grupo 1: Estilos básicos
            case 0: return "Standard";
            case 1: return "Gradient";
            case 2: return "Pulse";
            case 3: return "Color Pulse";
            case 4: return "Size Pulse";
            case 5: return "Blink";
            
            // Grupo 2: Estilos con flechas
            case 6: return "Arrows";
            case 7: return "Double Arrows";
            case 8: return "Triple Arrows";
            case 9: return "Dancing Arrows";
            case 10: return "Blinking Arrows";
            case 11: return "Rainbow Arrows";
            case 12: return "Arrow Bar";
            
            // Grupo 3: Estilos con bordes
            case 13: return "Border";
            case 14: return "Border Pulse";
            case 15: return "Wave Border";
            case 16: return "Corner Border";
            case 17: return "Glow Border";
            
            // Grupo 4: Otros estilos
            case 18: return "Dots";
            default: return "Border Pulse";
        }
    }
} 