// Sistema de animaciones de fuente/texto para el menú
// Permite animar el texto del selector con diferentes efectos visuales

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

// Inicialización del sistema de animaciones de fuente
init()
{
    // Definir las animaciones disponibles
    level.font_animations = [];
    level.font_animations[0] = "Sin Animación";      // No animation
    level.font_animations[1] = "Rebote (Bounce)";    // Bounce effect
    level.font_animations[2] = "Barrido";            // Sweep effect
    level.font_animations[3] = "Desvanecer";         // Fade effect
    level.font_animations[4] = "Escala";             // Scale effect
    level.font_animations[5] = "Giro";               // Rotate effect
    level.font_animations[6] = "Pulso";              // Pulse effect
    level.font_animations[7] = "Onda";               // Wave effect
}

// Aplicar animación al selector del menú
apply_font_animation(menu, animation_index)
{
    if (!isDefined(animation_index))
        animation_index = 0; // Sin animación por defecto

    // Guardar el índice de animación actual
    menu.font_animation_index = animation_index;

    // Detener cualquier animación previa
    if (isDefined(menu.current_animation_thread))
    {
        menu notify("stop_font_animation");
        menu.current_animation_thread = undefined;
    }

    // Aplicar la animación según el índice
    switch(animation_index)
    {
        case 0:
            // Sin animación
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

// ========================================
// ANIMACIONES INDIVIDUALES
// ========================================

// Animación de rebote (bounce)
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

        // Obtener el elemento actual y su posición original
        current_item = menu.items[menu.selected].item;
        original_y = current_item.y;

        // Verificar si ya hay una animación en progreso para este elemento
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        // Marcar que la animación está en progreso
        current_item.animation_in_progress = true;

        // Rebote hacia arriba
        current_item.y = original_y - 3;
        wait 0.1;

        // Rebote hacia abajo
        current_item.y = original_y + 1;
        wait 0.1;

        // Vuelta a posición original
        current_item.y = original_y;

        // Marcar que la animación terminó
        current_item.animation_in_progress = undefined;
    }
}

// Animación de barrido (sweep)
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

        // Obtener el elemento actual y su posición original
        current_item = menu.items[menu.selected].item;
        original_x = current_item.x;

        // Verificar si ya hay una animación en progreso para este elemento
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        // Marcar que la animación está en progreso
        current_item.animation_in_progress = true;

        // Barrido suave hacia la derecha
        current_item.x = original_x + 6;
        wait 0.08;

        current_item.x = original_x + 10;
        wait 0.08;

        // Barrido hacia la izquierda
        current_item.x = original_x - 4;
        wait 0.08;

        current_item.x = original_x - 8;
        wait 0.08;

        // Rebote suave de vuelta al centro
        current_item.x = original_x + 2;
        wait 0.06;

        // Vuelta definitiva a posición original
        current_item.x = original_x;

        // Marcar que la animación terminó
        current_item.animation_in_progress = undefined;
    }
}

// Animación de desvanecer (fade)
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

        // Obtener el elemento actual y su alpha original
        current_item = menu.items[menu.selected].item;
        original_alpha = current_item.alpha;

        // Verificar si ya hay una animación en progreso para este elemento
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        // Marcar que la animación está en progreso
        current_item.animation_in_progress = true;

        // Fade out gradual
        current_item.alpha = original_alpha * 0.8;
        wait 0.03;
        current_item.alpha = original_alpha * 0.6;
        wait 0.03;
        current_item.alpha = original_alpha * 0.4;
        wait 0.04;
        current_item.alpha = original_alpha * 0.3;
        wait 0.04;

        // Fade in gradual
        current_item.alpha = original_alpha * 0.5;
        wait 0.03;
        current_item.alpha = original_alpha * 0.7;
        wait 0.03;
        current_item.alpha = original_alpha * 0.9;
        wait 0.03;
        current_item.alpha = original_alpha;
        wait 0.03;

        // Marcar que la animación terminó
        current_item.animation_in_progress = undefined;
    }
}

// Animación de escala (scale)
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

        // Obtener el elemento actual y su escala original
        current_item = menu.items[menu.selected].item;
        original_scale = current_item.fontscale;

        // Verificar si ya hay una animación en progreso para este elemento
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        // Marcar que la animación está en progreso
        current_item.animation_in_progress = true;

        // Escalar hacia arriba
        current_item.fontscale = original_scale * 1.2;
        wait 0.08;

        // Escalar hacia abajo
        current_item.fontscale = original_scale * 0.9;
        wait 0.08;

        // Vuelta al tamaño original
        current_item.fontscale = original_scale;

        // Marcar que la animación terminó
        current_item.animation_in_progress = undefined;
    }
}

// Animación de giro (rotate) - usando movimiento lateral como simulación de giro
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

        // Obtener el elemento actual y su posición original
        current_item = menu.items[menu.selected].item;
        original_x = current_item.x;

        // Verificar si ya hay una animación en progreso para este elemento
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        // Marcar que la animación está en progreso
        current_item.animation_in_progress = true;

        // Movimiento rápido hacia la derecha
        current_item.x = original_x + 15;
        wait 0.05;

        // Movimiento rápido hacia la izquierda
        current_item.x = original_x - 15;
        wait 0.05;

        // Movimiento rápido al centro
        current_item.x = original_x + 5;
        wait 0.05;

        // Vuelta a posición original
        current_item.x = original_x;

        // Marcar que la animación terminó
        current_item.animation_in_progress = undefined;
    }
}

// Animación de pulso (pulse)
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

        // Obtener el elemento actual y su alpha original
        current_item = menu.items[menu.selected].item;
        original_alpha = current_item.alpha;

        // Verificar si ya hay una animación en progreso para este elemento
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        // Marcar que la animación está en progreso
        current_item.animation_in_progress = true;

        // Primer pulso intenso
        current_item.alpha = original_alpha * 0.5;
        wait 0.05;
        current_item.alpha = original_alpha * 0.8;
        wait 0.03;

        // Segundo pulso más suave
        current_item.alpha = original_alpha * 0.6;
        wait 0.04;
        current_item.alpha = original_alpha * 0.9;
        wait 0.03;

        // Tercer pulso sutil
        current_item.alpha = original_alpha * 0.7;
        wait 0.03;
        current_item.alpha = original_alpha;
        wait 0.03;

        // Marcar que la animación terminó
        current_item.animation_in_progress = undefined;
    }
}

// Animación de onda (wave)
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

        // Obtener el elemento actual y su posición original
        current_item = menu.items[menu.selected].item;
        original_y = current_item.y;

        // Verificar si ya hay una animación en progreso para este elemento
        if (isDefined(current_item.animation_in_progress) && current_item.animation_in_progress)
            continue;

        // Marcar que la animación está en progreso
        current_item.animation_in_progress = true;

        // Onda hacia arriba
        current_item.y = original_y - 2;
        wait 0.08;

        // Onda hacia abajo
        current_item.y = original_y + 2;
        wait 0.08;

        // Pequeña onda hacia arriba
        current_item.y = original_y - 1;
        wait 0.06;

        // Vuelta a posición original
        current_item.y = original_y;

        // Marcar que la animación terminó
        current_item.animation_in_progress = undefined;
    }
}

// ========================================
// FUNCIONES AUXILIARES
// ========================================

// Obtener el nombre de la animación según el índice y el idioma
get_font_animation_name(animation_index, lang_index)
{
    if (!isDefined(animation_index))
        animation_index = 0;

    if (!isDefined(lang_index))
        lang_index = 0; // Español por defecto

    animation_name = level.font_animations[animation_index];

    if (lang_index == 0) // Español
    {
        return animation_name;
    }
    else // Inglés
    {
        // Traducir algunos nombres al inglés
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

// Cambiar la animación de fuente (llamada desde el menú)
change_font_animation(menu, new_animation_index)
{
    menu.font_animation_index = new_animation_index;
    menu apply_font_animation(menu, new_animation_index);
}
