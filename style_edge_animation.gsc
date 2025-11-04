// Librería de animaciones de bordes para el sistema de menús
// Contiene diferentes animaciones que pueden aplicarse a los bordes del menú

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

// Inicialización de estilos de animación de bordes
init()
{
    // Definir los estilos de animación para bordes
    level.edge_animation_styles = [];
    level.edge_animation_styles[0] = "None";        // Sin animación
    level.edge_animation_styles[1] = "Rainbow";     // Animación de arcoíris (colores cambiantes)
    level.edge_animation_styles[2] = "Pulse";       // Animación de pulso (fade in/out)

    // Definir el estilo de animación de borde predeterminado
    if (!isDefined(level.default_edge_animation_style))
    {
        level.default_edge_animation_style = 1; // Arcoíris por defecto
    }

    // Definir el mapa de estado de animación por menú
    level.menu_edge_animation_states = [];

    // Hook para cleanup al finalizar el mapa/nivel
    level thread onplayerdisconnect();
}

// Aplicar animación de borde según el estilo seleccionado
apply_edge_animation(menu, animation_index)
{
    if (!isDefined(animation_index))
        animation_index = 0; // Por defecto: Sin animación

    // Guardar el estilo actual
    menu.edge_animation_style_index = animation_index;

    // Primero limpiar cualquier animación existente
    clear_existing_edge_animation(menu);

    // Aplicar la animación según el índice
    switch(animation_index)
    {
        case 0: // Sin animación
            // No hacer nada
            break;
        case 1: // Arcoíris
            apply_rainbow_edge_animation(menu);
            break;
        case 2: // Pulse
            apply_pulse_edge_animation(menu);
            break;
        default:
            // No hacer nada en caso de índice no válido
            break;
    }

    return menu;
}

// Limpiar animación de borde existente
clear_existing_edge_animation(menu)
{
    // Detener cualquier animación activa
    if (isDefined(menu.edge_animation_active))
    {
        menu.edge_animation_active = false;
        menu notify("stop_edge_animation");
    }
    
    // Destruir elementos de la animación del borde si existen
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


// Estilo 2: Animación Arcoíris
apply_rainbow_edge_animation(menu)
{
    // Crear elementos para la animación
    menu.edge_animation_elements = [];
    
    // Obtener la altura real del menú - calcular en base al número de elementos
    if (!isDefined(menu.height))
    {
        menu.height = menu.header_height + (menu.item_height * menu.items.size);
    }
    
    // Borde superior
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = menu.background.vertalign;
    top_border.horzalign = menu.background.horzalign;
    top_border.x = menu.background.x;
    top_border.y = menu.background.y;
    top_border.color = (1, 0, 0); // Rojo inicial
    top_border.alpha = 0.9;
    top_border setShader("white", menu.width, 2);
    
    // Borde derecho
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = menu.background.vertalign;
    right_border.horzalign = menu.background.horzalign;
    
    // Ajustar la posición X según la alineación horizontal
    if (menu.background.horzalign == "left")
    {
        right_border.x = menu.background.x + menu.width - 2;
    }
    else if (menu.background.horzalign == "right")
    {
        right_border.x = menu.background.x + menu.width - 2;
    }
    else // center
    {
        right_border.x = menu.background.x + (menu.width / 2);
    }
    
    right_border.y = menu.background.y;
    right_border.color = (1, 0.5, 0); // Naranja inicial
    right_border.alpha = 0.9;
    right_border setShader("white", 2, menu.height);
    
    // Borde inferior
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = menu.background.vertalign;
    bottom_border.horzalign = menu.background.horzalign;
    bottom_border.x = menu.background.x;
    
    // Ajustar la posición Y según la alineación vertical
    if (menu.background.vertalign == "top")
    {
        bottom_border.y = menu.background.y + menu.height - 2;
    }
    else if (menu.background.vertalign == "bottom")
    {
        bottom_border.y = menu.background.y + menu.height - 2;
    }
    else // middle
    {
        bottom_border.y = menu.background.y + (menu.height / 2);
    }
    
    bottom_border.color = (1, 1, 0); // Amarillo inicial
    bottom_border.alpha = 0.9;
    bottom_border setShader("white", menu.width, 2);
    
    // Borde izquierdo
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = menu.background.vertalign;
    left_border.horzalign = menu.background.horzalign;
    left_border.x = menu.background.x;
    left_border.y = menu.background.y;
    left_border.color = (0, 1, 0); // Verde inicial
    left_border.alpha = 0.9;
    left_border setShader("white", 2, menu.height);
    
    // Guardar referencias para actualizaciones
    menu.edge_animation_elements[0] = top_border;
    menu.edge_animation_elements[1] = right_border;
    menu.edge_animation_elements[2] = bottom_border;
    menu.edge_animation_elements[3] = left_border;
    
    // Guardar la altura actual para comparaciones futuras
    menu.last_height = menu.height;
    
    // Iniciar efecto de animación arcoíris
    menu.edge_animation_active = true;
    menu.user thread rainbow_edge_animation_effect(menu);
}

// Efecto de animación arcoíris
rainbow_edge_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_edge_animation");
    
    // Colores para la transición
    rainbow_colors = [];
    rainbow_colors[0] = (1, 0, 0);     // Rojo
    rainbow_colors[1] = (1, 0.5, 0);   // Naranja
    rainbow_colors[2] = (1, 1, 0);     // Amarillo
    rainbow_colors[3] = (0, 1, 0);     // Verde
    rainbow_colors[4] = (0, 1, 1);     // Cyan
    rainbow_colors[5] = (0, 0, 1);     // Azul
    rainbow_colors[6] = (0.5, 0, 1);   // Índigo
    rainbow_colors[7] = (1, 0, 1);     // Violeta
    
    // Establecer el desplazamiento inicial para cada borde
    border_color_index = [];
    border_color_index[0] = 0; // Desplazamiento para borde superior
    border_color_index[1] = 2; // Desplazamiento para borde derecho
    border_color_index[2] = 4; // Desplazamiento para borde inferior
    border_color_index[3] = 6; // Desplazamiento para borde izquierdo
    
    while(isDefined(menu.edge_animation_active) && menu.edge_animation_active)
    {
        // Actualizar el color de cada borde con un desplazamiento giratorio
        for (i = 0; i < 4; i++)
        {
            color_index = border_color_index[i] % rainbow_colors.size;
            menu.edge_animation_elements[i].color = rainbow_colors[color_index];
            // Avanzar al siguiente color para este borde
            border_color_index[i] = (border_color_index[i] + 1) % rainbow_colors.size;
        }
        
        // Esperar antes de la siguiente actualización
        wait 0.2;
    }
}

// Estilo 3: Animación Pulse (Pulso)
apply_pulse_edge_animation(menu)
{
    // Crear elementos para la animación
    menu.edge_animation_elements = [];
    
    // Obtener la altura real del menú - calcular en base al número de elementos
    if (!isDefined(menu.height))
    {
        menu.height = menu.header_height + (menu.item_height * menu.items.size);
    }
    
    // Determinar el color según el estilo del menú (azul por defecto)
    edge_color = (0.2, 0.6, 1);
    
    // Usar colores que coincidan mejor con los estilos de menú
    if (isDefined(menu.style_index))
    {
        // Para "Luna Sangrienta" (33) y estilos rojos similares
        if (menu.style_index == 33 || menu.style_index == 14 || menu.style_index == 21)
        {
            edge_color = (1, 0.2, 0.2); // Rojo sangre para Luna Sangrienta
        }
        // Para estilos neón/synthwave (34)
        else if (menu.style_index == 34 || menu.style_index == 4)
        {
            edge_color = (1, 0.2, 0.9); // Rosa neón
        }
        // Para estilos cyan/azules (11, 8, 0, 18)
        else if (menu.style_index == 11 || menu.style_index == 8 || menu.style_index == 0 || menu.style_index == 18)
        {
            edge_color = (0.2, 0.7, 1); // Azul claro
        }
        // Para estilos verdes (3, 15, 22)
        else if (menu.style_index == 3 || menu.style_index == 15 || menu.style_index == 22)
        {
            edge_color = (0.2, 1, 0.5); // Verde vibrante
        }
    }
    
    // Crear los cuatro bordes del menú
    // Borde superior
    top_border = newClientHudElem(menu.user);
    top_border.vertalign = menu.background.vertalign;
    top_border.horzalign = menu.background.horzalign;
    top_border.x = menu.background.x;
    top_border.y = menu.background.y;
    top_border.color = edge_color;
    top_border.alpha = 0; // Inicialmente invisible
    top_border setShader("white", menu.width, 2);
    
    // Borde derecho
    right_border = newClientHudElem(menu.user);
    right_border.vertalign = menu.background.vertalign;
    right_border.horzalign = menu.background.horzalign;
    right_border.x = menu.background.x + menu.width - 2;
    right_border.y = menu.background.y;
    right_border.color = edge_color;
    right_border.alpha = 0; // Inicialmente invisible
    right_border setShader("white", 2, menu.height);
    
    // Borde inferior
    bottom_border = newClientHudElem(menu.user);
    bottom_border.vertalign = menu.background.vertalign;
    bottom_border.horzalign = menu.background.horzalign;
    bottom_border.x = menu.background.x;
    bottom_border.y = menu.background.y + menu.height - 2;
    bottom_border.color = edge_color;
    bottom_border.alpha = 0; // Inicialmente invisible
    bottom_border setShader("white", menu.width, 2);
    
    // Borde izquierdo
    left_border = newClientHudElem(menu.user);
    left_border.vertalign = menu.background.vertalign;
    left_border.horzalign = menu.background.horzalign;
    left_border.x = menu.background.x;
    left_border.y = menu.background.y;
    left_border.color = edge_color;
    left_border.alpha = 0; // Inicialmente invisible
    left_border setShader("white", 2, menu.height);
    
    // Guardar referencias para actualizaciones
    menu.edge_animation_elements[0] = top_border;
    menu.edge_animation_elements[1] = right_border;
    menu.edge_animation_elements[2] = bottom_border;
    menu.edge_animation_elements[3] = left_border;
    
    // Guardar el color para referencias futuras
    menu.edge_animation_color = edge_color;
    
    // Guardar la altura actual para comparaciones futuras
    menu.last_height = menu.height;
    
    // Iniciar efecto de animación de pulso
    menu.edge_animation_active = true;
    menu.user thread pulse_edge_animation_effect(menu);
}

// Efecto de animación de pulso
pulse_edge_animation_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_edge_animation");
    
    // Asegurarse de que los elementos existen
    if (!isDefined(menu.edge_animation_elements) || menu.edge_animation_elements.size < 4)
        return;
    
    // Configuración del pulso
    min_alpha = 0.1;
    max_alpha = 0.9;
    pulse_speed = 0.05; // Velocidad del pulso
    
    // Estado del pulso
    fade_in = true; // True = desvanecer, False = aparecer
    current_alpha = min_alpha;
    
    while(isDefined(menu.edge_animation_active) && menu.edge_animation_active)
    {
        // Actualizar la altura en cada iteración
        menu.height = menu.header_height + (menu.item_height * menu.items.size);
        
        // Asegurarse de que los bordes cubren todo el menú
        menu.edge_animation_elements[1] setShader("white", 2, menu.height);  // Borde derecho
        menu.edge_animation_elements[2].y = menu.background.y + menu.height - 2; // Borde inferior
        menu.edge_animation_elements[3] setShader("white", 2, menu.height);  // Borde izquierdo
        
        // Efecto de pulso
        if (fade_in)
        {
            current_alpha += pulse_speed;
            if (current_alpha >= max_alpha)
            {
                current_alpha = max_alpha;
                fade_in = false; // Cambiar dirección
            }
        }
        else
        {
            current_alpha -= pulse_speed;
            if (current_alpha <= min_alpha)
            {
                current_alpha = min_alpha;
                fade_in = true; // Cambiar dirección
            }
        }
        
        // Aplicar la opacidad actual a todos los bordes
        for (i = 0; i < 4; i++)
        {
            menu.edge_animation_elements[i].alpha = current_alpha;
        }
        
        wait 0.05; // Velocidad de la animación
    }
}


// Función para manejar la desconexión de jugadores
onplayerdisconnect()
{
    level endon("end_game");
    
    level waittill("player_disconnect");
    
    // Limpiar recursos y animaciones cuando un jugador se desconecta
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
    
    // Seguir monitoreando futuras desconexiones
    level thread onplayerdisconnect();
}

// Obtener el nombre del estilo de animación según el índice y el idioma
get_edge_animation_style_name(style_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;

    if (lang_index == 0) // Español
    {
        switch(style_index)
        {
            case 0: return "Ninguna";
            case 1: return "Arcoíris";
            case 2: return "Pulso";
            default: return "Ninguna";
        }
    }
    else // Inglés
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

// Función para actualizar animación cuando cambia el tamaño del menú
update_edge_animation_size(menu)
{
    // Detener la animación actual
    if (isDefined(menu.edge_animation_active))
    {
        menu.edge_animation_active = false;
        menu notify("stop_edge_animation");
    }
    
    // Esperar brevemente para asegurar que la animación anterior se detiene
    wait 0.05;
    
    // Actualizar la altura real del menú basada en el contenido actual
    menu.height = menu.header_height + (menu.item_height * menu.items.size);
    
    // Verificar si la altura cambió significativamente
    height_changed = true;
    if (isDefined(menu.last_height))
    {
        if (menu.height == menu.last_height)
        {
            height_changed = false;
        }
    }
    
    // Para animaciones simples, recrear si hay cambios significativos
    if (height_changed || !isDefined(menu.edge_animation_elements) || menu.edge_animation_elements.size == 0)
    {
        // Recrear la animación desde cero
        apply_edge_animation(menu, menu.edge_animation_style_index);
        return;
    }
    
    // Para animaciones más sencillas, ajustar los elementos existentes
    if (isDefined(menu.edge_animation_elements) && menu.edge_animation_elements.size > 0)
    {
        // Caso específico para cada estilo
        switch(menu.edge_animation_style_index)
        {
            case 1: // Rainbow
                // Actualizar borde superior (índice 0)
                if (isDefined(menu.edge_animation_elements[0]))
                {
                    menu.edge_animation_elements[0].x = menu.background.x;
                    menu.edge_animation_elements[0].y = menu.background.y;
                    menu.edge_animation_elements[0] setShader("white", menu.width, 2);
                }

                // Actualizar borde derecho (índice 1)
                if (isDefined(menu.edge_animation_elements[1]))
                {
                    // Ajustar según alineación
                    if (menu.background.horzalign == "left")
                    {
                        menu.edge_animation_elements[1].x = menu.background.x + menu.width - 2;
                    }
                    else if (menu.background.horzalign == "right")
                    {
                        menu.edge_animation_elements[1].x = menu.background.x + menu.width - 2;
                    }
                    else // center
                    {
                        menu.edge_animation_elements[1].x = menu.background.x + (menu.width / 2);
                    }
                    menu.edge_animation_elements[1].y = menu.background.y;
                    menu.edge_animation_elements[1] setShader("white", 2, menu.height);
                }

                // Actualizar borde inferior (índice 2)
                if (isDefined(menu.edge_animation_elements[2]))
                {
                    menu.edge_animation_elements[2].x = menu.background.x;
                    menu.edge_animation_elements[2].y = menu.background.y + menu.height - 2;
                    menu.edge_animation_elements[2] setShader("white", menu.width, 2);
                }

                // Actualizar borde izquierdo (índice 3)
                if (isDefined(menu.edge_animation_elements[3]))
                {
                    menu.edge_animation_elements[3].x = menu.background.x;
                    menu.edge_animation_elements[3].y = menu.background.y;
                    menu.edge_animation_elements[3] setShader("white", 2, menu.height);
                }
                break;

            case 2: // Pulse
                // Actualizar borde superior (índice 0)
                if (isDefined(menu.edge_animation_elements[0]))
                {
                    menu.edge_animation_elements[0].x = menu.background.x;
                    menu.edge_animation_elements[0].y = menu.background.y;
                    menu.edge_animation_elements[0] setShader("white", menu.width, 2);
                }

                // Actualizar borde derecho (índice 1)
                if (isDefined(menu.edge_animation_elements[1]))
                {
                    menu.edge_animation_elements[1].x = menu.background.x + menu.width - 2;
                    menu.edge_animation_elements[1].y = menu.background.y;
                    menu.edge_animation_elements[1] setShader("white", 2, menu.height);
                }

                // Actualizar borde inferior (índice 2)
                if (isDefined(menu.edge_animation_elements[2]))
                {
                    menu.edge_animation_elements[2].x = menu.background.x;
                    menu.edge_animation_elements[2].y = menu.background.y + menu.height - 2;
                    menu.edge_animation_elements[2] setShader("white", menu.width, 2);
                }

                // Actualizar borde izquierdo (índice 3)
                if (isDefined(menu.edge_animation_elements[3]))
                {
                    menu.edge_animation_elements[3].x = menu.background.x;
                    menu.edge_animation_elements[3].y = menu.background.y;
                    menu.edge_animation_elements[3] setShader("white", 2, menu.height);
                }
                break;
        }
    }

    // Guardar la altura actual para futuras comparaciones
    menu.last_height = menu.height;

    // Reactivar la animación existente
    if (isDefined(menu.edge_animation_style_index) && menu.edge_animation_style_index > 0)
    {
        menu.edge_animation_active = true;
        if (menu.edge_animation_style_index == 1) // Arcoíris
        {
            menu.user thread rainbow_edge_animation_effect(menu);
        }
        else if (menu.edge_animation_style_index == 2) // Pulse
        {
            menu.user thread pulse_edge_animation_effect(menu);
        }
    }
}