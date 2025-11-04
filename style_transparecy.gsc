// Librería de ajuste de transparencia para el sistema de menús
// Permite controlar el nivel de transparencia del menú en tiempo real

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

// Inicialización de niveles de transparencia
init()
{
    // Definir los niveles de transparencia disponibles (0 = sólido, 70 = máxima transparencia)
    level.transparency_levels = [];
    level.transparency_levels[0] = "0%";   // Sólido
    level.transparency_levels[1] = "10%";
    level.transparency_levels[2] = "20%";
    level.transparency_levels[3] = "30%";
    level.transparency_levels[4] = "40%";
    level.transparency_levels[5] = "50%";
    level.transparency_levels[6] = "60%";
    level.transparency_levels[7] = "70%";  // Máxima transparencia
}

// Función para aplicar el nivel de transparencia seleccionado a un menú
apply_transparency(menu, transparency_index)
{
    if (!isDefined(transparency_index))
        transparency_index = 0; // Por defecto, sólido (sin transparencia)
    
    // Guardar el nivel de transparencia actual
    menu.transparency_index = transparency_index;
    
    // Calcular el valor de alpha basado en el índice (0 = alpha 1.0, 7 = alpha 0.3)
    // El rango de alpha es de 1.0 (sólido) a 0.3 (muy transparente)
    user_alpha_value = 1.0 - (transparency_index * 0.1);

    // Si el menú ya tiene un bg_alpha definido (del estilo), multiplicar por la transparencia del usuario
    if (isDefined(menu.bg_alpha))
        background_alpha = menu.bg_alpha * user_alpha_value;
    else
        background_alpha = user_alpha_value;

    // Para el header, mantener una opacidad ligeramente mayor si tiene header_alpha definido
    if (isDefined(menu.header_alpha))
        header_alpha = menu.header_alpha * user_alpha_value;
    else
        header_alpha = user_alpha_value;

    // Limitar el header alpha para que no exceda 1.0
    if (header_alpha > 1.0)
        header_alpha = 1.0;

    // Aplicar la transparencia al fondo del menú
    if (isDefined(menu.background))
        menu.background.alpha = background_alpha;

    // Aplicar la transparencia al header
    if (isDefined(menu.header_bg))
        menu.header_bg.alpha = header_alpha;
    
    // Aplicar a otros elementos del menú que deban ser afectados
    if (isDefined(menu.header_text))
        menu.header_text.alpha = 1.0; // El texto del header siempre visible
        
    // NO modificar la opacidad del selector - debe mantenerse siempre visible
    
    // Aplicar al footer si existe
    if (isDefined(menu.footer))
        menu.footer.alpha = background_alpha;
    
    // No modificar la opacidad del texto de los items para mantener legibilidad
    // El selector mantiene su opacidad original (no se ve afectado por la transparencia)
    
    return menu;
}

// Función para obtener el valor de transparencia actual como porcentaje
get_transparency_percentage(transparency_index)
{
    if (!isDefined(transparency_index))
        return "0%";
        
    return level.transparency_levels[transparency_index];
}

// Obtener el nombre del nivel de transparencia según el índice
get_transparency_name(transparency_index, lang_index)
{
    if (!isDefined(transparency_index))
        transparency_index = 0;
        
    if (!isDefined(lang_index))
        lang_index = 0;
    
    // Extraer solo el número, sin el símbolo %
    transparency_value = int(level.transparency_levels[transparency_index]);
    
    if (lang_index == 0) // Español
        return "Transparencia: " + transparency_value + "%%";
    else // Inglés
        return "Transparency: " + transparency_value + "%%";
}

// Nueva función para actualizar la transparencia después de un cambio de estilo
update_transparency_after_style_change(menu, transparency_index)
{
    if (!isDefined(transparency_index))
        return menu;
        
    // Asegurarse de que la transparencia se aplique con prioridad sobre los valores del estilo
    if (transparency_index > 0)
    {
        // Calcular el valor de alpha
        alpha_value = 1.0 - (transparency_index * 0.1);
        
        // Forzar la aplicación de la transparencia al fondo y al header
        if (isDefined(menu.background))
            menu.background.alpha = alpha_value;
            
        if (isDefined(menu.header_bg))
            menu.header_bg.alpha = alpha_value;
            
        // NO modificar la opacidad del selector
            
        // Asegurarse de que el texto del título permanezca visible
        if (isDefined(menu.header_text))
            menu.header_text.alpha = 1.0;
    }
    
    return menu;
}
