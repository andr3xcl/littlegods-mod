// Librería de estilos de menú para el sistema de menús
// Contiene diferentes estilos visuales que pueden aplicarse al menú

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include scripts\zm\style_transparecy;

// Inicialización de estilos de menú
init()
{
    // Definir los estilos disponibles - añadir nuevos estilos aquí
    level.menu_styles = [];
    level.menu_styles[0] = "Modern Blue";       // Estilo moderno azul (predeterminado)
    level.menu_styles[1] = "Classic";           // Estilo clásico
    level.menu_styles[2] = "Zombie";            // Estilo zombie con verde/rojo
    level.menu_styles[3] = "Minimalist";        // Estilo minimalista
    level.menu_styles[4] = "Neon";              // Estilo neón con brillos
    level.menu_styles[5] = "Dark Mode";         // Estilo oscuro
    level.menu_styles[6] = "Military";          // Estilo militar
    level.menu_styles[7] = "Rainbow";           // Estilo arcoíris
    // Estilos modernos
    level.menu_styles[8] = "Futuristic";        // Estilo futurista con azules
    level.menu_styles[9] = "Elegant";           // Estilo elegante dorado y negro
    level.menu_styles[10] = "Cyberpunk";        // Estilo cyberpunk con colores vibrantes
    level.menu_styles[11] = "Aqua";             // Estilo acuático fresco
    // NUEVOS ESTILOS AÑADIDOS
    level.menu_styles[12] = "Retro Arcade";     // Estilo retro de arcades de los 80s
    level.menu_styles[13] = "Polar Ice";        // Estilo hielo polar con tonos blancos y azules
    level.menu_styles[14] = "Inferno";          // Estilo fuego infernal con rojos y naranjas
    level.menu_styles[15] = "Nature";           // Estilo naturaleza con verdes y marrones
    level.menu_styles[16] = "Halloween";        // Estilo Halloween con naranja y negro
    level.menu_styles[17] = "Christmas";        // Estilo Navidad con rojo y verde
    // SEGUNDA TANDA DE ESTILOS NUEVOS
    level.menu_styles[18] = "Galaxy";           // Estilo galaxia con tonos púrpuras y azules
    level.menu_styles[19] = "Tropical";         // Estilo tropical con tonos vivos
    level.menu_styles[20] = "Metal";            // Estilo metálico con grises y reflejos
    level.menu_styles[21] = "Vampire";          // Estilo vampiro con rojo oscuro y negro
    level.menu_styles[22] = "Toxic";            // Estilo tóxico con verdes fluorescentes
    level.menu_styles[23] = "Pastel";           // Estilo pastel con colores suaves
    // TERCERA TANDA DE ESTILOS NUEVOS
    level.menu_styles[24] = "Desert";           // Estilo desierto con tonos arena y marrón
    level.menu_styles[25] = "Ocean Deep";       // Estilo océano profundo con azules oscuros
    level.menu_styles[26] = "Nuke";             // Estilo nuclear con amarillo y negro
    level.menu_styles[27] = "Gold Elite";       // Estilo dorado premium
    level.menu_styles[28] = "Frozen";           // Estilo congelado con azules pálidos
    level.menu_styles[29] = "Retro TV";         // Estilo TV retro con líneas y estática
    // CUARTA TANDA DE ESTILOS NUEVOS
    level.menu_styles[30] = "Sunset";           // Estilo atardecer con naranjas y rojos
    level.menu_styles[31] = "Matrix";           // Estilo matrix con verde código sobre negro
    level.menu_styles[32] = "Steampunk";        // Estilo steampunk con bronces y marrones
    level.menu_styles[33] = "Blood Moon";       // Estilo luna de sangre, rojo sangre y negro
    level.menu_styles[34] = "Synthwave";        // Estilo synthwave con rosa y azul neón
    level.menu_styles[35] = "Comic";            // Estilo cómic con colores vivos y bordes negros
    // QUINTA TANDA DE ESTILOS NUEVOS
    level.menu_styles[36] = "Pixel Art";        // Estilo pixel art inspirado en 8-bit
    level.menu_styles[37] = "Graffiti";         // Estilo urbano con colores de aerosol
    level.menu_styles[38] = "Vaporwave";        // Estética retro de los 90s con pastel y neón
    level.menu_styles[39] = "Enchanted Forest";  // Estilo bosque encantado con verdes y púrpuras
    level.menu_styles[40] = "Ancient Egypt";     // Estilo egipcio con dorados y azules
    level.menu_styles[41] = "Neon Retro";        // Estilo 80s con colores neón intensos
    level.menu_styles[42] = "Hologram";          // Estilo holográfico futurista con efectos translúcidos
}

// Función para aplicar el estilo seleccionado a un menú
apply_menu_style(menu, style_index)
{
    if (!isDefined(style_index))
        style_index = 0; // Estilo predeterminado
    
    // Guardar el estilo actual
    menu.style_index = style_index;
    
    // Aplicar el estilo según el índice
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
        // Estilos modernos
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
        // NUEVOS ESTILOS AÑADIDOS
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
        // SEGUNDA TANDA DE ESTILOS NUEVOS
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
        // TERCERA TANDA DE ESTILOS NUEVOS
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
        // CUARTA TANDA DE ESTILOS NUEVOS
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
        // QUINTA TANDA DE ESTILOS NUEVOS
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
        default:
            apply_modern_blue_style(menu); // Estilo predeterminado
    }

    // Reaplicar la transparencia configurada por el usuario después del cambio de estilo
    if (isDefined(menu.transparency_index) && menu.transparency_index > 0)
    {
        menu = apply_transparency(menu, menu.transparency_index);
    }

    return menu;
}

// Obtener el nombre del estilo según el índice y el idioma
get_style_name(style_index, lang_index)
{
    if (!isDefined(lang_index))
        lang_index = 0;
        
    if (lang_index == 0) // Español
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
            // Estilos modernos en español
            case 8: return "Futurista";
            case 9: return "Elegante";
            case 10: return "Cyberpunk";
            case 11: return "Aqua";
            // NUEVOS ESTILOS EN ESPAÑOL
            case 12: return "Arcade Retro";
            case 13: return "Hielo Polar";
            case 14: return "Infierno";
            case 15: return "Naturaleza";
            case 16: return "Halloween";
            case 17: return "Navidad";
            // SEGUNDA TANDA DE ESTILOS EN ESPAÑOL
            case 18: return "Galaxia";
            case 19: return "Tropical";
            case 20: return "Metal";
            case 21: return "Vampiro";
            case 22: return "Tóxico";
            case 23: return "Pastel";
            // TERCERA TANDA DE ESTILOS EN ESPAÑOL
            case 24: return "Desierto";
            case 25: return "Océano Profundo";
            case 26: return "Nuclear";
            case 27: return "Oro Elite";
            case 28: return "Congelado";
            case 29: return "TV Retro";
            // CUARTA TANDA DE ESTILOS EN ESPAÑOL
            case 30: return "Atardecer";
            case 31: return "Matrix";
            case 32: return "Steampunk";
            case 33: return "Luna Sangrienta";
            case 34: return "Synthwave";
            case 35: return "Cómic";
            // QUINTA TANDA DE ESTILOS EN ESPAÑOL
            case 36: return "Pixel Art";
            case 37: return "Grafiti";
            case 38: return "Vaporwave";
            case 39: return "Bosque Encantado";
            case 40: return "Egipto Antiguo";
            case 41: return "Neón Retro";
            case 42: return "Holograma";
            default: return "Desconocido";
        }
    }
    else // Inglés
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
            // Estilos modernos en inglés
            case 8: return "Futuristic";
            case 9: return "Elegant";
            case 10: return "Cyberpunk";
            case 11: return "Aqua";
            // NUEVOS ESTILOS EN INGLÉS
            case 12: return "Retro Arcade";
            case 13: return "Polar Ice";
            case 14: return "Inferno";
            case 15: return "Nature";
            case 16: return "Halloween";
            case 17: return "Christmas";
            // SEGUNDA TANDA DE ESTILOS EN INGLÉS
            case 18: return "Galaxy";
            case 19: return "Tropical";
            case 20: return "Metal";
            case 21: return "Vampire";
            case 22: return "Toxic";
            case 23: return "Pastel";
            // TERCERA TANDA DE ESTILOS EN INGLÉS
            case 24: return "Desert";
            case 25: return "Ocean Deep";
            case 26: return "Nuke";
            case 27: return "Gold Elite";
            case 28: return "Frozen";
            case 29: return "Retro TV";
            // CUARTA TANDA DE ESTILOS EN INGLÉS
            case 30: return "Sunset";
            case 31: return "Matrix";
            case 32: return "Steampunk";
            case 33: return "Blood Moon";
            case 34: return "Synthwave";
            case 35: return "Comic";
            // QUINTA TANDA DE ESTILOS EN INGLÉS
            case 36: return "Pixel Art";
            case 37: return "Graffiti";
            case 38: return "Vaporwave";
            case 39: return "Enchanted Forest";
            case 40: return "Ancient Egypt";
            case 41: return "Neon Retro";
            case 42: return "Hologram";
            default: return "Unknown";
        }
    }
}

// Estilo 0: Moderno Azul (similar al de la imagen, predeterminado)
apply_modern_blue_style(menu)
{
    // Colores
    menu.header_color = (0.1, 0.45, 0.85);  // Azul más brillante para mejor visibilidad
    menu.active_color = (0.1, 0.45, 0.85);  // Azul para selección
    menu.inactive_color = (1, 1, 1);        // Blanco para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0, 0, 0);              // Negro para el fondo

    // Dimensiones - centrado en la pantalla
    menu.width = 180;
    menu.margin_x = 260;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 24; // Altura ligeramente mayor para mejor proporción

    // Opacidad
    menu.bg_alpha = 0.75; // Opacidad ligeramente mayor para mejor visibilidad
    menu.header_alpha = 0.98; // Casi opaco para máxima visibilidad

    // Desactivar bordes
    menu.has_border = false;

    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 1: Clásico (estilo retro inspirado en menús antiguos)
apply_classic_style(menu)
{
    // Colores
    menu.header_color = (0.8, 0.8, 0.8);    // Gris claro para el encabezado
    menu.active_color = (1, 1, 0);          // Amarillo para selección
    menu.inactive_color = (0.9, 0.9, 0.9);  // Blanco grisáceo para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Amarillo para el texto del título
    menu.bg_color = (0.2, 0.2, 0.2);        // Gris oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 160;
    menu.margin_x = 270;
    menu.margin_y = 180;
    menu.item_height = 16;
    menu.header_height = 20;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 2: Zombie (verde y rojo inspirado en tema zombie)
apply_zombie_style(menu)
{
    // Colores
    menu.header_color = (0.2, 0.5, 0.1);    // Verde zombie para el encabezado
    menu.active_color = (0.7, 0.1, 0.1);    // Rojo sangre para selección
    menu.inactive_color = (0.8, 0.8, 0.6);  // Beige para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.1, 0.1, 0.1);        // Casi negro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 190;
    menu.margin_x = 255;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 25;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 3: Minimalista (limpio y simple)
apply_minimalist_style(menu)
{
    // Colores
    menu.header_color = (0.05, 0.05, 0.05); // Casi negro para el encabezado
    menu.active_color = (0.9, 0.9, 0.9);    // Blanco para selección
    menu.inactive_color = (0.7, 0.7, 0.7);  // Gris para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.15, 0.15, 0.15);     // Gris oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 170;
    menu.margin_x = 265;
    menu.margin_y = 180;
    menu.item_height = 16;
    menu.header_height = 18;
    
    // Opacidad
    menu.bg_alpha = 0.6;
    menu.header_alpha = 0.7;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 4: Neón (brillante y llamativo)
apply_neon_style(menu)
{
    // Colores
    menu.header_color = (0, 0.8, 0.8);      // Cian brillante para el encabezado
    menu.active_color = (1, 0.2, 0.8);      // Rosa brillante para selección
    menu.inactive_color = (0.7, 0.9, 1);    // Azul claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.05, 0.05, 0.1);      // Azul muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 185;
    menu.margin_x = 258;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 24;
    
    // Opacidad
    menu.bg_alpha = 0.8;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 5: Modo Oscuro (oscuro con acentos claros)
apply_dark_mode_style(menu)
{
    // Colores
    menu.header_color = (0.15, 0.15, 0.15); // Gris muy oscuro pero visible para el encabezado
    menu.active_color = (0.4, 0.7, 1);      // Azul claro para selección
    menu.inactive_color = (0.6, 0.6, 0.6);  // Gris claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);       // Azul claro para el texto del título
    menu.bg_color = (0.05, 0.05, 0.05);     // Negro para el fondo

    // Dimensiones - centrado en la pantalla
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22; // Altura ligeramente mayor

    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 0.98; // Casi opaco para máxima visibilidad

    // Desactivar bordes
    menu.has_border = false;

    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 6: Militar (estilo camuflaje)
apply_military_style(menu)
{
    // Colores
    menu.header_color = (0.2, 0.3, 0.15);   // Verde oliva para el encabezado
    menu.active_color = (0.6, 0.6, 0.2);    // Amarillo oliva para selección
    menu.inactive_color = (0.8, 0.8, 0.7);  // Beige para elementos no seleccionados
    menu.title_color = (1, 1, 1);     // Amarillo oliva para el texto del título
    menu.bg_color = (0.15, 0.15, 0.1);      // Verde muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 190;
    menu.margin_x = 255;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 24;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 7: Arcoíris (colorido y vibrante)
apply_rainbow_style(menu)
{
    // Solo definimos colores base, el resto se maneja dinámicamente
    // en la función rainbow_effect que se llama periódicamente

    // Colores
    menu.header_color = (1, 0, 0);          // Rojo para empezar
    menu.active_color = (1, 0.5, 0);        // Naranja para selección
    menu.inactive_color = (1, 1, 1);        // Blanco para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco brillante para el texto del título
    menu.bg_color = (0.1, 0, 0.2);          // Púrpura muy oscuro para el fondo

    // Dimensiones - centrado en la pantalla
    menu.width = 180;
    menu.margin_x = 260;
    menu.margin_y = 180;
    menu.item_height = 19;
    menu.header_height = 25; // Altura ligeramente mayor

    // Opacidad
    menu.bg_alpha = 0.8; // Opacidad mayor para mejor visibilidad
    menu.header_alpha = 0.98; // Casi opaco para máxima visibilidad

    // Desactivar bordes
    menu.has_border = false;

    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);

    // Iniciar efecto arcoíris si no está ya activo
    if (!isDefined(menu.rainbow_active))
    {
        menu.rainbow_active = true;
        menu.user thread rainbow_effect(menu);
    }
}

// Efecto de arcoíris para cambiar colores dinámicamente
rainbow_effect(menu)
{
    menu.user endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");
    menu endon("stop_rainbow");

    hue = 0;

    while(isDefined(menu.rainbow_active) && menu.rainbow_active)
    {
        // Incrementar el tono de color (0-360 en formato normalizado 0-1)
        hue += 0.01;
        if (hue > 1) hue = 0;

        // Convertir HSV a RGB para el encabezado
        header_color = hsv_to_rgb(hue, 0.8, 0.8);
        // Convertir HSV a RGB para la selección (desplazamiento de 0.2 en el tono)
        selection_color = hsv_to_rgb((hue + 0.2) % 1, 0.9, 0.9);

        // Actualizar colores
        menu.header_color = header_color;
        menu.active_color = selection_color;

        // Actualizar elementos visuales
        if (isDefined(menu.header_bg))
        {
            menu.header_bg.color = header_color;
            menu.header_bg.alpha = 0.98; // Mantener alta opacidad
        }

        if (isDefined(menu.header_border_top))
        {
            menu.header_border_top.color = selection_color; // Borde sigue el color de selección
        }

        if (isDefined(menu.selection_bar))
            menu.selection_bar.color = selection_color;

        // Asegurar que el texto del título mantenga buena visibilidad
        if (isDefined(menu.title_text))
        {
            menu.title_text.alpha = 1; // Máxima opacidad para el texto
        }

        wait 0.05; // Actualizar el color cada 50ms
    }
}

// Convertir HSV a RGB (Hue, Saturation, Value a Red, Green, Blue)
hsv_to_rgb(h, s, v)
{
    // Algoritmo estándar de conversión de HSV a RGB
    // h: 0-1 (tono), s: 0-1 (saturación), v: 0-1 (valor)
    
    if (s == 0)
        return (v, v, v); // Escala de grises
    
    h = h * 6; // Normalizar a 0-6
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

// Función para actualizar los elementos visuales del menú
update_menu_visuals(menu)
{
    // Verificar si existen los elementos básicos, y si no, crearlos
    if (!isDefined(menu.background))
    {
        menu.background = newClientHudElem(menu.user);
        menu.background.vertalign = "top";
        menu.background.horzalign = "left";
        menu.background.x = 0; // Posición izquierda
        menu.background.y = 120; // Posición superior
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
        menu.title_text.x = menu.background.x + 12; // Añadir margen para el texto del título
        menu.title_text.y = menu.background.y + 3;
        menu.title_text.fontscale = 1.5;
        menu.title_text setText(menu.title);
    }

    if (!isDefined(menu.title_shadow))
    {
        menu.title_shadow = newClientHudElem(menu.user);
        menu.title_shadow.vertalign = "top";
        menu.title_shadow.horzalign = "left";
        menu.title_shadow.x = menu.background.x + 14;
        menu.title_shadow.y = menu.background.y + 5;
        menu.title_shadow.fontscale = 1.5;
        menu.title_shadow setText(menu.title);
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

    // Esconder bordes si existen
    if (isDefined(menu.border_top))
    {
        menu.border_top.alpha = 0;
        menu.border_bottom.alpha = 0;
        menu.border_left.alpha = 0;
        menu.border_right.alpha = 0;
    }

    // Mantener las coordenadas originales
    original_x = menu.background.x;
    original_y = menu.background.y;

    // Actualizar el fondo principal
    menu.background.alpha = menu.bg_alpha;
    menu.background.color = menu.bg_color;
    // Ajustar la altura dinámica
    total_height = menu.header_height + (menu.item_height * menu.items.size);
    menu.background setShader("white", menu.width, total_height);

    // Actualizar el encabezado manteniendo posición
    menu.header_bg.x = original_x;
    menu.header_bg.y = original_y;
    menu.header_bg.alpha = menu.header_alpha;
    menu.header_bg.color = menu.header_color;
    menu.header_bg setShader("white", menu.width, menu.header_height);

    // Actualizar borde superior del encabezado solo si está habilitado
    if (isDefined(menu.has_border) && menu.has_border)
    {
        menu.header_border_top.x = original_x;
        menu.header_border_top.y = original_y;
        menu.header_border_top.alpha = 1;
        menu.header_border_top.color = (0.8, 0.8, 0.9); // Borde blanco-azulado
        menu.header_border_top setShader("white", menu.width, 1);
    }
    else
    {
        // Ocultar borde si no está habilitado
        menu.header_border_top.alpha = 0;
    }

    // Actualizar texto del título manteniendo posición
    // Solo aplicar si no hay posición de texto personalizada
    if (!isDefined(menu.font_position_index) || menu.font_position_index == 0)
    {
        menu.title_text.x = original_x + 12; // Añadir margen a la izquierda para el texto del título
        menu.title_text.alignX = "left";
    }
    menu.title_text.y = original_y + 3;
    menu.title_text.color = menu.title_color;
    menu.title_text.alpha = 1; // Asegurar máxima opacidad
    menu.title_text.sort = 2; // Asegurar que esté al frente

    // Actualizar sombra del título (detrás del texto principal)
    if (!isDefined(menu.font_position_index) || menu.font_position_index == 0)
    {
        menu.title_shadow.x = original_x + 14;
        menu.title_shadow.alignX = "left";
    }
    menu.title_shadow.y = original_y + 5;
    menu.title_shadow.color = (0, 0, 0);
    menu.title_shadow.alpha = 0.4; // Sombra sutil
    menu.title_shadow.sort = 0; // Asegurar que esté detrás

    // Actualizar barra de selección manteniendo posición
    menu.selection_bar.x = original_x;
    if (isDefined(menu.selected))
    {
        menu.selection_bar.y = original_y + menu.header_height + (menu.item_height * menu.selected);
    }
    menu.selection_bar.color = menu.active_color;
    menu.selection_bar setShader("white", menu.width, menu.item_height);

    // Actualizar elementos del menú manteniendo posiciones
    for (i = 0; i < menu.items.size; i++)
    {
        if (isDefined(menu.items[i].item))
        {
            // No actualizar la posición horizontal si ya está configurada por el sistema de posición de texto
            if (!isDefined(menu.font_position_index) || menu.font_position_index == 0)
            {
                // Actualizar posición basada en fondo y altura de elemento
                if (menu.items[i].item.horzalign == "center")
                {
                    // Si está configurado para centrar, mantener centrado
                    menu.items[i].item.x = original_x + (menu.width / 2);
                    menu.items[i].item.alignX = "center";
                }
                else
                {
                    // Si no, alinear a la izquierda con margen
                    menu.items[i].item.x = original_x + 15; // Añadir margen para texto
                    menu.items[i].item.alignX = "left";
                }
            }

            menu.items[i].item.y = original_y + menu.header_height + (menu.item_height * i) + (menu.item_height / 2) - 6;
            menu.items[i].item.color = (i == menu.selected) ? (1, 1, 1) : menu.inactive_color; // Texto seleccionado en blanco
        }
    }

    // Si hay una posición de texto definida, aplicarla después
    if (isDefined(menu.font_position_index) && menu.font_position_index > 0)
    {
        menu = scripts\zm\style_font_position::update_menu_visuals_with_position(menu);
    }

    // Devolver la estructura de menú actualizada
    return menu;
}

// Esta función debe ser llamada para detener el efecto arcoíris cuando se cambia de estilo
stop_rainbow_effect(menu)
{
    if (isDefined(menu.rainbow_active) && menu.rainbow_active)
    {
        menu.rainbow_active = false;
        menu notify("stop_rainbow");
    }
}

// Estilo 8: Futurista (azules y detalles brillantes)
apply_futuristic_style(menu)
{
    // Colores
    menu.header_color = (0, 0.2, 0.5);      // Azul profundo para el encabezado
    menu.active_color = (0.2, 0.8, 1);      // Azul brillante para selección
    menu.inactive_color = (0.85, 0.95, 1);  // Azul muy claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.03, 0.06, 0.12);     // Azul oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 190;
    menu.margin_x = 255;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 24;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 9: Elegante (dorado y negro)
apply_elegant_style(menu)
{
    // Colores
    menu.header_color = (0.8, 0.65, 0.2);   // Dorado para el encabezado
    menu.active_color = (0.9, 0.75, 0.3);   // Dorado brillante para selección
    menu.inactive_color = (0.8, 0.8, 0.8);  // Gris claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Negro para el texto del título
    menu.bg_color = (0.1, 0.1, 0.1);        // Negro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 185;
    menu.margin_x = 258;
    menu.margin_y = 180;
    menu.item_height = 19;
    menu.header_height = 26;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 10: Cyberpunk (colores vibrantes y neón)
apply_cyberpunk_style(menu)
{
    // Colores
    menu.header_color = (0.9, 0.1, 0.6);    // Fucsia neón para el encabezado
    menu.active_color = (0, 0.9, 0.9);      // Cian neón para selección
    menu.inactive_color = (0.85, 0.85, 0.9); // Gris azulado para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.05, 0, 0.1);         // Morado oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 195;
    menu.margin_x = 253;
    menu.margin_y = 180;
    menu.item_height = 21;
    menu.header_height = 28;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 11: Aqua (tonos acuáticos frescos)
apply_aqua_style(menu)
{
    // Colores
    menu.header_color = (0, 0.5, 0.5);      // Turquesa para el encabezado
    menu.active_color = (0, 0.6, 0.8);      // Azul agua para selección
    menu.inactive_color = (0.8, 1, 1);      // Celeste muy claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.05, 0.15, 0.2);      // Azul profundo para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 180;
    menu.margin_x = 260;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 24;
    
    // Opacidad
    menu.bg_alpha = 0.8;
    menu.header_alpha = 0.95;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 12: Retro Arcade (inspirado en las arcades de los 80s)
apply_retro_arcade_style(menu)
{
    // Colores
    menu.header_color = (0.9, 0, 0.9);      // Magenta brillante para el encabezado
    menu.active_color = (0, 0.9, 0.9);      // Cian brillante para selección
    menu.inactive_color = (0.5, 0.9, 0.5);  // Verde claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);          // Amarillo brillante para el texto del título
    menu.bg_color = (0, 0, 0.3);            // Azul oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 200;
    menu.margin_x = 250;
    menu.margin_y = 180;
    menu.item_height = 22;
    menu.header_height = 30;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 13: Hielo Polar (tonos blancos y azules fríos)
apply_polar_ice_style(menu)
{
    // Colores
    menu.header_color = (0.7, 0.9, 1);      // Azul hielo claro para el encabezado
    menu.active_color = (0.2, 0.6, 0.9);    // Azul brillante para selección
    menu.inactive_color = (0.9, 0.95, 1);   // Blanco azulado para elementos no seleccionados
    menu.title_color = (1, 1, 1);     // Azul brillante para el texto del título
    menu.bg_color = (0.85, 0.9, 0.95);      // Blanco grisáceo para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 185;
    menu.margin_x = 258;
    menu.margin_y = 180;
    menu.item_height = 19;
    menu.header_height = 25;
    
    // Opacidad
    menu.bg_alpha = 0.8;
    menu.header_alpha = 0.9;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 14: Inferno (tonos rojos y naranjas de fuego)
apply_inferno_style(menu)
{
    // Colores
    menu.header_color = (0.8, 0.2, 0);      // Naranja oscuro para el encabezado
    menu.active_color = (1, 0.6, 0);        // Naranja brillante para selección
    menu.inactive_color = (1, 0.8, 0.7);    // Beige claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.3, 0, 0);            // Rojo muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 190;
    menu.margin_x = 255;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 26;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 15: Naturaleza (tonos verdes y marrones)
apply_nature_style(menu)
{
    // Colores
    menu.header_color = (0.2, 0.5, 0.1);    // Verde bosque para el encabezado
    menu.active_color = (0.5, 0.8, 0.2);    // Verde brillante para selección
    menu.inactive_color = (0.8, 0.9, 0.7);  // Verde claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.3, 0.2, 0.1);        // Marrón oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 24;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.95;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 16: Halloween (naranja y negro)
apply_halloween_style(menu)
{
    // Colores
    menu.header_color = (0.9, 0.5, 0);      // Naranja Halloween para el encabezado
    menu.active_color = (0.8, 0.4, 0);      // Naranja más oscuro para selección
    menu.inactive_color = (0.8, 0.7, 0.8);  // Lila claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);         // Naranja brillante para el texto del título
    menu.bg_color = (0.1, 0.02, 0.1);       // Morado muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 195;
    menu.margin_x = 253;
    menu.margin_y = 180;
    menu.item_height = 21;
    menu.header_height = 28;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 17: Navidad (rojo y verde tradicionales)
apply_christmas_style(menu)
{
    // Colores
    menu.header_color = (0.8, 0.1, 0.1);    // Rojo navidad para el encabezado
    menu.active_color = (0.1, 0.6, 0.1);    // Verde navidad para selección
    menu.inactive_color = (1, 1, 1);        // Blanco para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.05, 0.1, 0.05);      // Verde muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 180;
    menu.margin_x = 260;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 25;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 18: Galaxia (colores cósmicos)
apply_galaxy_style(menu)
{
    // Colores
    menu.header_color = (0.3, 0.1, 0.5);    // Púrpura oscuro para el encabezado
    menu.active_color = (0.5, 0.2, 1);      // Púrpura brillante para selección
    menu.inactive_color = (0.6, 0.7, 1);    // Azul claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.05, 0.05, 0.15);     // Azul muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 190;
    menu.margin_x = 255;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 26;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 0.95;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 19: Tropical (colores vivos y vibrantes)
apply_tropical_style(menu)
{
    // Colores
    menu.header_color = (0, 0.7, 0.7);      // Turquesa para el encabezado
    menu.active_color = (1, 0.6, 0);        // Naranja tropical para selección
    menu.inactive_color = (1, 1, 0.8);      // Amarillo claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);         // Naranja tropical para el texto del título
    menu.bg_color = (0, 0.5, 0.5);          // Turquesa más oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 185;
    menu.margin_x = 258;
    menu.margin_y = 180;
    menu.item_height = 19;
    menu.header_height = 25;
    
    // Opacidad
    menu.bg_alpha = 0.8;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 20: Metal (gris metálico con reflejos)
apply_metal_style(menu)
{
    // Colores
    menu.header_color = (0.6, 0.6, 0.6);    // Gris plateado para el encabezado
    menu.active_color = (0.8, 0.8, 0.8);    // Gris brillante para selección
    menu.inactive_color = (0.5, 0.5, 0.5);  // Gris medio para elementos no seleccionados
    menu.title_color = (1, 1, 1);    // Gris muy claro para el texto del título
    menu.bg_color = (0.2, 0.2, 0.2);        // Gris oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 175;
    menu.margin_x = 263;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 24;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 21: Vampiro (rojo sangre y negro)
apply_vampire_style(menu)
{
    // Colores
    menu.header_color = (0.4, 0, 0);        // Rojo oscuro para el encabezado
    menu.active_color = (0.7, 0, 0);        // Rojo sangre para selección
    menu.inactive_color = (0.7, 0.6, 0.6);  // Rosa pálido para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.05, 0, 0.05);        // Negro púrpura para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 180;
    menu.margin_x = 260;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 25;
    
    // Opacidad
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 22: Tóxico (verde neón y negro)
apply_toxic_style(menu)
{
    // Colores
    menu.header_color = (0.2, 0.8, 0);      // Verde tóxico para el encabezado
    menu.active_color = (0.4, 1, 0);        // Verde neón brillante para selección
    menu.inactive_color = (0.8, 1, 0.7);    // Verde claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Negro para el texto del título
    menu.bg_color = (0.1, 0.1, 0.1);        // Negro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 185;
    menu.margin_x = 258;
    menu.margin_y = 180;
    menu.item_height = 21;
    menu.header_height = 27;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 23: Pastel (colores suaves y delicados)
apply_pastel_style(menu)
{
    // Colores
    menu.header_color = (0.9, 0.8, 0.9);    // Lavanda suave para el encabezado
    menu.active_color = (0.8, 0.6, 0.8);    // Púrpura pastel para selección
    menu.inactive_color = (0.9, 0.9, 0.9);  // Gris muy claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);     // Púrpura oscuro para el texto del título
    menu.bg_color = (1, 0.95, 1);           // Blanco ligeramente púrpura para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 170;
    menu.margin_x = 265;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 24: Desierto (tonos arena y marrón)
apply_desert_style(menu)
{
    // Colores
    menu.header_color = (0.8, 0.6, 0.3);    // Marrón arena para el encabezado
    menu.active_color = (0.9, 0.7, 0.2);    // Dorado arena para selección
    menu.inactive_color = (0.95, 0.9, 0.7); // Beige arena claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);    // Dorado arena para el texto del título
    menu.bg_color = (0.7, 0.6, 0.4);        // Beige arena para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 180;
    menu.margin_x = 260;
    menu.margin_y = 180;
    menu.item_height = 19;
    menu.header_height = 24;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.95;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 25: Océano Profundo (azules oscuros)
apply_ocean_deep_style(menu)
{
    // Colores
    menu.header_color = (0.1, 0.2, 0.4);    // Azul profundo para el encabezado
    menu.active_color = (0, 0.4, 0.7);      // Azul océano para selección
    menu.inactive_color = (0.6, 0.8, 0.9);  // Azul claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.05, 0.1, 0.2);       // Azul muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 185;
    menu.margin_x = 258;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 26;
    
    // Opacidad
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 26: Nuclear (amarillo y negro)
apply_nuke_style(menu)
{
    // Colores
    menu.header_color = (0.8, 0.8, 0);      // Amarillo nuclear para el encabezado
    menu.active_color = (0.9, 0.9, 0);      // Amarillo brillante para selección
    menu.inactive_color = (0.8, 0.8, 0.6);  // Amarillo apagado para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Amarillo brillante para el texto del título
    menu.bg_color = (0.15, 0.15, 0.15);     // Negro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 195;
    menu.margin_x = 253;
    menu.margin_y = 180;
    menu.item_height = 22;
    menu.header_height = 28;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 27: Oro Elite (dorado premium)
apply_gold_elite_style(menu)
{
    // Colores
    menu.header_color = (0.9, 0.8, 0.2);    // Dorado brillante para el encabezado
    menu.active_color = (1, 0.85, 0.1);     // Dorado intenso para selección
    menu.inactive_color = (0.85, 0.7, 0.2); // Dorado más apagado para elementos no seleccionados
    menu.title_color = (1, 1, 1);     // Casi negro para el texto del título
    menu.bg_color = (0.25, 0.2, 0.1);       // Marrón oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 190;
    menu.margin_x = 255;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 25;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 28: Congelado (tonos azules pálidos)
apply_frozen_style(menu)
{
    // Colores
    menu.header_color = (0.8, 0.9, 1);      // Azul hielo para el encabezado
    menu.active_color = (0.6, 0.8, 1);      // Azul hielo más oscuro para selección
    menu.inactive_color = (0.9, 0.95, 1);   // Blanco azulado para elementos no seleccionados
    menu.title_color = (1, 1, 1);     // Azul medio para el texto del título
    menu.bg_color = (0.95, 0.98, 1);        // Blanco azulado para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 180;
    menu.margin_x = 260;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 24;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 29: TV Retro (estilo de televisor antiguo)
apply_retro_tv_style(menu)
{
    // Colores
    menu.header_color = (0.2, 0.2, 0.2);    // Gris oscuro para el encabezado
    menu.active_color = (0.1, 0.7, 0.1);    // Verde fosforescente para selección
    menu.inactive_color = (0.7, 0.7, 0.7);  // Gris claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);      // Verde neón brillante para el texto del título
    menu.bg_color = (0.1, 0.1, 0.1);        // Negro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 200;
    menu.margin_x = 250;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 25;
    
    // Opacidad
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 30: Atardecer (naranjas y rojos)
apply_sunset_style(menu)
{
    // Colores
    menu.header_color = (0.9, 0.5, 0);      // Naranja atardecer para el encabezado
    menu.active_color = (0.8, 0.4, 0);      // Naranja más oscuro para selección
    menu.inactive_color = (0.8, 0.7, 0.8);  // Lila claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);       // Naranja claro para el texto del título
    menu.bg_color = (0.1, 0.02, 0.1);       // Morado muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 195;
    menu.margin_x = 253;
    menu.margin_y = 180;
    menu.item_height = 21;
    menu.header_height = 28;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 31: Matrix (verde código sobre negro)
apply_matrix_style(menu)
{
    // Colores
    menu.header_color = (0, 0.5, 0);        // Verde código para el encabezado
    menu.active_color = (0, 0.8, 0);        // Verde brillante para selección
    menu.inactive_color = (0.5, 0.5, 0.5);  // Gris para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0, 0, 0);              // Negro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 180;
    menu.margin_x = 260;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    // Opacidad
    menu.bg_alpha = 0.8;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 32: Steampunk (bronces y marrones)
apply_steampunk_style(menu)
{
    // Colores
    menu.header_color = (0.5, 0.3, 0.1);    // Marrón oscuro para el encabezado
    menu.active_color = (0.8, 0.6, 0.2);    // Marrón brillante para selección
    menu.inactive_color = (0.7, 0.5, 0.1);  // Marrón apagado para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.2, 0.1, 0.05);       // Marrón oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 180;
    menu.margin_x = 260;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    // Opacidad
    menu.bg_alpha = 0.8;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 33: Luna de Sangre (rojo sangre y negro)
apply_blood_moon_style(menu)
{
    // Colores
    menu.header_color = (0.8, 0.2, 0);      // Naranja oscuro para el encabezado
    menu.active_color = (1, 0.6, 0);        // Naranja brillante para selección
    menu.inactive_color = (1, 0.8, 0.7);    // Beige claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.3, 0, 0);            // Rojo muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 190;
    menu.margin_x = 255;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 26;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 34: Synthwave (rosa y azul neón)
apply_synthwave_style(menu)
{
    // Colores
    menu.header_color = (0.9, 0.1, 0.6);    // Fucsia neón para el encabezado
    menu.active_color = (0, 0.9, 0.9);      // Cian neón para selección
    menu.inactive_color = (0.85, 0.85, 0.9); // Gris azulado para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.05, 0, 0.1);         // Morado oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 195;
    menu.margin_x = 253;
    menu.margin_y = 180;
    menu.item_height = 21;
    menu.header_height = 28;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 35: Cómic (colores vivos y bordes negros)
apply_comic_style(menu)
{
    // Colores
    menu.header_color = (0.9, 0.8, 0.9);    // Lavanda suave para el encabezado
    menu.active_color = (0.8, 0.6, 0.8);    // Púrpura pastel para selección
    menu.inactive_color = (0.9, 0.9, 0.9);  // Gris muy claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);    // Púrpura oscuro para el texto del título
    menu.bg_color = (1, 0.95, 1);           // Blanco ligeramente púrpura para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 170;
    menu.margin_x = 265;
    menu.margin_y = 180;
    menu.item_height = 18;
    menu.header_height = 22;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 36: Pixel Art (inspirado en gráficos 8-bit)
apply_pixel_art_style(menu)
{
    // Colores
    menu.header_color = (0.3, 0.3, 0.8);    // Azul pixel para el encabezado
    menu.active_color = (1, 0.5, 0.1);      // Naranja pixelado para selección
    menu.inactive_color = (0.7, 0.7, 0.7);  // Gris claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.1, 0.1, 0.2);        // Azul muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla con forma cuadrada para efecto pixel
    menu.width = 200;
    menu.margin_x = 250;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 24;
    
    // Opacidad
    menu.bg_alpha = 1.0;     // Sin transparencia para efecto pixel
    menu.header_alpha = 1.0;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 37: Graffiti (estilo urbano con colores de aerosol)
apply_graffiti_style(menu)
{
    // Colores
    menu.header_color = (0.2, 0.2, 0.2);    // Negro para el encabezado (como muro)
    menu.active_color = (1, 0.2, 0.5);      // Rosa aerosol para selección
    menu.inactive_color = (0.3, 0.9, 0.5);  // Verde aerosol para elementos no seleccionados
    menu.title_color = (1, 1, 1);         // Amarillo brillante para el texto del título
    menu.bg_color = (0.15, 0.15, 0.15);     // Gris oscuro para el fondo (como pared)
    
    // Dimensiones - centrado en la pantalla con aspecto irregular
    menu.width = 210;
    menu.margin_x = 245;
    menu.margin_y = 180;
    menu.item_height = 22;
    menu.header_height = 30;
    
    // Opacidad
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 38: Vaporwave (estética retro de los 90s)
apply_vaporwave_style(menu)
{
    // Colores
    menu.header_color = (0.8, 0.3, 0.8);    // Púrpura para el encabezado
    menu.active_color = (0, 0.9, 0.9);      // Cian neón para selección
    menu.inactive_color = (0.9, 0.5, 0.9);  // Rosa claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);        // Rosa neón para el texto del título
    menu.bg_color = (0.2, 0, 0.3);          // Púrpura oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 195;
    menu.margin_x = 253;
    menu.margin_y = 180;
    menu.item_height = 21;
    menu.header_height = 28;
    
    // Opacidad
    menu.bg_alpha = 0.8;
    menu.header_alpha = 0.9;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 39: Bosque Encantado (tonos mágicos con verdes y púrpuras)
apply_enchanted_forest_style(menu)
{
    // Colores
    menu.header_color = (0.2, 0.6, 0.3);    // Verde bosque para el encabezado
    menu.active_color = (0.6, 0.2, 0.8);    // Púrpura mágico para selección
    menu.inactive_color = (0.7, 0.9, 0.7);  // Verde claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);      // Púrpura brillante para el texto del título
    menu.bg_color = (0.1, 0.2, 0.15);       // Verde muy oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 185;
    menu.margin_x = 258;
    menu.margin_y = 180;
    menu.item_height = 19;
    menu.header_height = 26;
    
    // Opacidad
    menu.bg_alpha = 0.85;
    menu.header_alpha = 0.9;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 40: Egipto Antiguo (dorados y azules profundos)
apply_ancient_egypt_style(menu)
{
    // Colores
    menu.header_color = (0.9, 0.7, 0.1);    // Dorado egipcio para el encabezado
    menu.active_color = (0.1, 0.4, 0.7);    // Azul faraónico para selección
    menu.inactive_color = (0.8, 0.7, 0.5);  // Arena para elementos no seleccionados
    menu.title_color = (1, 1, 1);      // Dorado brillante para el texto del título
    menu.bg_color = (0.4, 0.3, 0.2);        // Marrón arena para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 190;
    menu.margin_x = 255;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 27;
    
    // Opacidad
    menu.bg_alpha = 0.9;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 41: Neón Retro (estilo de los 80s con colores neón intensos)
apply_neon_retro_style(menu)
{
    // Colores
    menu.header_color = (0, 0, 0);          // Negro para el encabezado
    menu.active_color = (1, 0.1, 0.6);      // Rosa intenso para selección
    menu.inactive_color = (0.1, 0.9, 0.9);  // Cian brillante para elementos no seleccionados
    menu.title_color = (1, 1, 1);       // Rosa neón para el texto del título
    menu.bg_color = (0.05, 0.05, 0.05);     // Negro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 195;
    menu.margin_x = 253;
    menu.margin_y = 180;
    menu.item_height = 22;
    menu.header_height = 29;
    
    // Opacidad
    menu.bg_alpha = 0.95;
    menu.header_alpha = 1;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
}

// Estilo 42: Holograma (estilo holográfico futurista)
apply_hologram_style(menu)
{
    // Colores
    menu.header_color = (0.1, 0.7, 0.9);    // Azul holográfico para el encabezado
    menu.active_color = (0.3, 0.8, 1);      // Azul brillante para selección
    menu.inactive_color = (0.6, 0.8, 0.9);  // Azul claro para elementos no seleccionados
    menu.title_color = (1, 1, 1);           // Blanco para el texto del título
    menu.bg_color = (0.1, 0.2, 0.3);        // Azul oscuro para el fondo
    
    // Dimensiones - centrado en la pantalla
    menu.width = 200;
    menu.margin_x = 250;
    menu.margin_y = 180;
    menu.item_height = 20;
    menu.header_height = 25;
    
    // Opacidad - semitransparente para efecto holográfico
    menu.bg_alpha = 0.6;
    menu.header_alpha = 0.8;
    
    // Desactivar bordes
    menu.has_border = false;
    
    // Actualizar elementos visuales si ya existen
    update_menu_visuals(menu);
} 