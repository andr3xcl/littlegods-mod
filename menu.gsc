// Menú para seleccionar mods y configurar opciones
// Creado para controlar night_mode y healthbarV2
// Usa los controles definidos en READ.txt


#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\gametypes_zm\spawnlogic;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\gametypes_zm\_hud_message;


#include scripts\zm\healthbarV2;
#include scripts\zm\HealthBarZombie;
#include scripts\zm\night_mode;
#include scripts\zm\style_menu;
#include scripts\zm\style_selector;
#include scripts\zm\style_edge_animation;
#include scripts\zm\style_font_position;
#include scripts\zm\style_font_animation;
#include scripts\zm\funciones;
#include scripts\zm\weapon;
#include scripts\zm\sqllocal;
#include scripts\zm\topround;
#include scripts\zm\playsound;
#include scripts\zm\legacy_mods_performance;


init()
{
    // Llamar a esta función desde el archivo principal para inicializar el menú
    level thread onPlayerConnect();
    
    // Inicializar estilos de menú
    level thread init_styles();
    
    // Inicializar estilos de selector
    level thread init_selector_styles();
    
    // Inicializar listener para contraseña de developer
    level thread on_player_say_password();
    
    // Inicializar animaciones de borde
    level thread init_edge_animations();
    
    // Inicializar posiciones de texto
    level thread init_font_positions();
    level thread init_font_animations();
    level thread init_menu_sounds();
    level thread init_legacy_mods_performance();
    
    // Inicializar funciones adicionales (God Mode, etc.)
    level thread init_functions();
}

// Función para llamar al init de style_menu.gsc
init_styles()
{
    // Llamar a la función init del archivo style_menu.gsc
    init();
}

// Función para llamar al init de style_selector.gsc
init_selector_styles()
{
    // Llamar a la función init del archivo style_selector.gsc
    scripts\zm\style_selector::init();
}

// Función para llamar al init de style_edge_animation.gsc
init_edge_animations()
{
    // Llamar a la función init del archivo style_edge_animation.gsc
    scripts\zm\style_edge_animation::init();
}

// Función para llamar al init de style_font_position.gsc
init_font_positions()
{
    // Llamar a la función init del archivo style_font_position.gsc
    scripts\zm\style_font_position::init();
}

// Función para llamar al init de style_font_animation.gsc
init_font_animations()
{
    // Llamar a la función init del archivo style_font_animation.gsc
    scripts\zm\style_font_animation::init();
}

// Función para llamar al init de playsound.gsc
init_menu_sounds()
{
    // Llamar a la función init del archivo playsound.gsc
    scripts\zm\playsound::init();
}

// Función para llamar al init de legacy_mods_performance.gsc
init_legacy_mods_performance()
{
    // Llamar a la función init del archivo legacy_mods_performance.gsc
    scripts\zm\legacy_mods_performance::init();
}

// Función para llamar al init de funciones.gsc
init_functions()
{
    // Llamar a la función init del archivo funciones.gsc
    scripts\zm\funciones::init();
}

// Listener para detectar la contraseña de developer en el chat
on_player_say_password()
{
    level endon("end_game");
    
    for(;;)
    {
        level waittill("say", message, player);
        
        // Convertir a minúsculas para hacer la comparación insensible a mayúsculas
        message_lower = toLower(message);
        
        // Verificar si el mensaje es la contraseña "admin"
        if(message_lower == "admin")
        {
            // Desbloquear el modo developer
            player.developer_mode_unlocked = true;

            // Deshabilitar top de rondas cuando developer está activado
            player.top_rounds_disabled = true;

            // Destruir el HUD de contraseña si existe
            if (isDefined(player.password_hud))
            {
                player.password_hud destroy();
                player.password_hud = undefined;
            }

            // Mensaje de confirmación
            if(player.langLEN == 0) // Español
                player iPrintlnBold("^2Modo Developer: ^7Desbloqueado");
            else // Inglés
                player iPrintlnBold("^2Developer Mode: ^7Unlocked");

            // Reproducir sonido de confirmación

            // Abrir automáticamente el menú de developer
            wait 0.5; // Pequeña pausa para que se procese el mensaje
            if (!isDefined(player.menu_current) || !isDefined(player.menu_current.title))
                player thread open_main_menu();
            wait 0.2;
            if (isDefined(player.menu_current) && player.menu_current.title == "LITTLEGODS MOD")
                player thread open_developer_menu();
        }

        // Verificar si el mensaje es "teleport"
        else if(message_lower == "teleport")
        {
            // Verificar que tenga permisos (developer mode desbloqueado)
            if (!isDefined(player.developer_mode_unlocked) || !player.developer_mode_unlocked)
            {
                if(player.langLEN == 0) // Español
                    player iPrintlnBold("^1Necesitas tener Developer Mode desbloqueado");
                else // Inglés
                    player iPrintlnBold("^1You need Developer Mode unlocked");
                continue;
            }

            // Abrir automáticamente el menú de teleport
            if (!isDefined(player.menu_current) || !isDefined(player.menu_current.title))
                player thread open_main_menu();
            wait 0.2;
            if (isDefined(player.menu_current) && player.menu_current.title == "LITTLEGODS MOD")
            {
                // Abrir el menú de teleport directamente
                player thread open_teleport_menu();
            }
            else if (isDefined(player.menu_current) && player.menu_current.title == "DEVELOPER")
            {
                // Si ya está en developer, abrir teleport desde ahí
                player thread open_teleport_menu();
            }
        }

        // Comandos de teleport
        else if(isSubStr(message_lower, "añadir posicion "))
        {
            // Extraer el nombre de la posición
            position_name = getSubStr(message, 16); // Longitud de "añadir posicion "

            // Verificar que tenga nombre
            if(position_name != "" && position_name != " ")
            {
                player thread save_position_with_name(position_name);
            }
            else
            {
                if(player.langLEN == 0) // Español
                    player iPrintlnBold("^1Debes especificar un nombre para la posición");
                else // Inglés
                    player iPrintlnBold("^1You must specify a name for the position");
            }
        }
        else if(isSubStr(message_lower, "tp "))
        {
            // Extraer el nombre de la posición
            position_name = getSubStr(message, 3); // Longitud de "tp "

            // Verificar que tenga nombre
            if(position_name != "" && position_name != " ")
            {
                player thread teleport_to_position(position_name);
            }
            else
            {
                if(player.langLEN == 0) // Español
                    player iPrintlnBold("^1Debes especificar el nombre de la posición");
                else // Inglés
                    player iPrintlnBold("^1You must specify the position name");
            }
        }
        else if(isSubStr(message_lower, "eliminar posicion "))
        {
            // Extraer el nombre de la posición
            position_name = getSubStr(message, 18); // Longitud de "eliminar posicion "

            // Verificar que tenga nombre
            if(position_name != "" && position_name != " ")
            {
                player thread delete_position(position_name);
            }
            else
            {
                if(player.langLEN == 0) // Español
                    player iPrintlnBold("^1Debes especificar el nombre de la posición");
                else // Inglés
                    player iPrintlnBold("^1You must specify the position name");
            }
        }
        else if(message_lower == "lista posiciones")
        {
            player thread list_saved_positions();
        }
    }
}

// Función para guardar posición con nombre (llamada desde chat)
save_position_with_name(name)
{
    self scripts\zm\funciones::save_position_with_name(name);
}

// Función para teleportarse a una posición (llamada desde chat)
teleport_to_position(name)
{
    self scripts\zm\funciones::teleport_to_position(name);
}

// Función para eliminar una posición (llamada desde chat)
delete_position(name)
{
    self scripts\zm\funciones::delete_position(name);
}

// Función para listar posiciones guardadas (llamada desde chat)
list_saved_positions()
{
    self scripts\zm\funciones::list_saved_positions();
}

// Función intermediaria para llamar a colorBAR desde HealthBarZombie.gsc
call_colorbar(index)
{
    self endon("disconnect");
    level endon("end_game");
    
    // Aplicar el valor al color actual solo si existe la barra
    if (!isDefined(self.hud_zombie_health) || !isDefined(self.hud_zombie_health.bar))
    {
        // Guardar el valor para cuando se cree la barra
        self.saved_color_index = index;
        return;
    }
    
    // Copia directa de la función colorBAR del HealthBarZombie.gsc
    colorbarlist = [];
    colorbarlist[0] = (1, 0, 0);   // Rojo
    colorbarlist[1] = (0, 1, 0);   // Verde
    colorbarlist[2] = (0, 0, 1);   // Azul
    colorbarlist[3] = (1, 1, 0);   // Amarillo
    colorbarlist[4] = (1, 0, 1);   // Magenta
    colorbarlist[5] = (0, 1, 1);   // Cian
    colorbarlist[6] = (1, 1, 1);   // Blanco
    colorbarlist[7] = (0, 0, 0);   // Negro
    colorbarlist[8] = (0.5, 0, 0); // Rojo oscuro
    colorbarlist[9] = (0, 0.5, 0); // Verde oscuro
    colorbarlist[10] = (0, 0, 0.5); // Azul oscuro
    colorbarlist[11] = (0.5, 0.5, 0); // Amarillo oscuro
    colorbarlist[12] = (0.5, 0, 0.5); // Magenta oscuro
    colorbarlist[13] = (0, 0.5, 0.5); // Cian oscuro
    colorbarlist[14] = (0.75, 0.75, 0.75); // Gris claro
    colorbarlist[15] = (0.25, 0.25, 0.25); // Gris oscuro
    colorbarlist[16] = (1, 0.5, 0);  // Naranja
    colorbarlist[17] = (0.5, 0.25, 0); // Marrón
    colorbarlist[18] = (1, 0.75, 0.8); // Rosa claro
    colorbarlist[19] = (0.5, 0, 0.25); // Púrpura oscuro
    colorbarlist[20] = (0.5, 1, 0.5); // Verde claro
    
    if (index == 0)
    {
        randomIndex = randomint(colorbarlist.size);
        self.hud_zombie_health.bar.color = colorbarlist[randomIndex];
        // Debug
    }
    else if (index >= 1 && index <= 21)
    {
        self.hud_zombie_health.bar.color = colorbarlist[index - 1];
        // Debug
    }
}

onPlayerConnect()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    
    for (;;)
    {
        self waittill("spawned_player");
        flag_wait("initial_blackscreen_passed");
        
        // Inicializar sistema de top de rondas (solo una vez por partida y solo si developer no está activado)
        
        // Inicializar variables del jugador para el menú
        if (!isDefined(self.menu_open))
        {
            self.menu_open = false;
            self.night_mode_enabled = false;
            self.night_mode_filter = 0;
            self.night_mode_darkness = 4.5; // Valor predeterminado para la oscuridad (entre 4.5 y 10)
            self.fog_enabled = false; // Nueva variable para el fog
            self.healthbar_enabled = false; // Cambiar a false para que no se active por defecto
            self.healthbar_position = "top"; // Cambiado de "left" a "top" para que la barra aparezca arriba por defecto

            // Variables para HealthBarZombie con nuevos rangos
            self.healthbarzombie_enabled = false;
            self.healthbarzombie_color = "default";
            self.healthbarzombie_sizew = 100; // Valor mínimo para ancho ahora es 100
            self.healthbarzombie_sizeh = 2; // Altura por defecto (rango 1-10)
            self.healthbarzombie_sizen = 1.2; // Tamaño de nombre por defecto (rango 1-1.9)
            self.healthbarzombie_shader = "transparent"; // Cambiado de 'solid' a 'transparent' para empezar
            self.show_zombie_name = true; // Nueva variable para controlar la visualización del nombre del zombie

            // Inicializar God Mode en estado desactivado
            self.godmode_enabled = false;

            // Inicializar Developer Mode en estado desactivado
            self.developer_mode_unlocked = false;

        // Inicializar sistema de top de rondas (solo una vez por partida)
        if (!isDefined(level.topround_initialized))
        {
            level.topround_initialized = true;
            level thread TopRound();
        }

            // Configuración de idioma (0 = español, 1 = inglés), default: español
            self.langLEN = 0;
            
            // Añadir configuración de estilo de menú
            self.menu_style_index = 5; // Por defecto, Dark Mode (estilo 5)

            // Añadir configuración de posición del menú (0: superior, 1: inferior, 2: izquierda, 3: derecha)
            self.menu_position = 0; // Por defecto, posición superior

            // Asegurar que el estilo del selector sea Border Pulse
            self.selector_style_index = 14; // Border Pulse
            self.edge_animation_style_index = 0; // Por defecto, sin animación

           // money = 1000000;
            //self.score = self.score + money;
            setdvar("g_ai", "1"); //fix maprestart 
            self.Fr3ZzZoM = false;

            //vida = 250;
            //self.health = self.health + vida;
            //self.health_max = self.health_max + vida;

            // Configuración de transparencia del menú se inicializa en create_menu()

            // Iniciar el hilo de control del menú solo una vez
            self thread menu_listener();
            
            // Ya no activamos la barra automáticamente aquí
            // La barra solo se activará cuando el usuario la active desde el menú
            
            // Mostrar mensaje de ayuda
            if (self.langLEN == 0)
                self iPrintLn("^3Presiona ^7[{+ads}]+[{+melee}] ^3para abrir el menú de mods");
            else
                self iPrintLn("^3Press ^7[{+ads}]+[{+melee}] ^3to open mods menu");
        }
        else if (self.healthbar_enabled) // Si ya tiene configuración y la barra está activada en el menú
        {
            // Asegurarse de que la barra se active al reaparecer
            if (!isDefined(self.health_bar))
            {
                if (self.healthbar_position == "left")
                    functions = 2;
                else if (self.healthbar_position == "top_left")
                    functions = 3;
                else
                    functions = 1; // top
                self thread bar_funtion_and_toogle(functions);
            }
        }

        // Desactivar God Mode al reaparecer si estaba activado
        if (self.godmode_enabled)
        {
            self notify("godmode_off");
            self disableInvulnerability();
            self.godmode_enabled = false;
        }

        // Cargar configuración guardada AUTOMÁTICAMENTE al respawnear
        // Esto sobrescribe los valores por defecto con la configuración guardada
        success = scripts\zm\sqllocal::load_menu_config(self);
        if (success)
        {
            // Aplicar estilos guardados automáticamente
            if (isDefined(self.menu_style_index) && self.menu_style_index >= 0)
            {
                // Aplicar estilo del menú si hay una función disponible
                if (isDefined(level.apply_menu_style_func))
                {
                    self thread [[level.apply_menu_style_func]](self.menu_style_index);
                }
            }

            // Aplicar otros ajustes si existen funciones disponibles
            if (isDefined(self.transparency_index) && isDefined(level.apply_transparency_func))
            {
                self thread [[level.apply_transparency_func]](self.transparency_index);
            }
        }
    }
}

menu_listener()
{
    self endon("disconnect");
    
    // Escuchar la combinación de botones para abrir el menú (ADS + Melee)
    for (;;)
    {
        // Esperar hasta que ambos botones estén presionados simultáneamente
        if (self adsbuttonpressed() && self meleebuttonpressed())
        {
            // Solo abrir el menú si está cerrado, no cerrarlo si está abierto
            if (!self.menu_open)
            {
                // Cerrar cualquier menú existente primero
                self notify("destroy_all_menus");
                
                // Marcar menú como abierto y mostrarlo
                self.menu_open = true;
                self thread open_main_menu();
                
                // Esperar para evitar múltiples activaciones
                wait 1.0;
            }
        }
        wait 0.05;
    }
}

open_main_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    // Inicializar valores por defecto si no existen
    if(!isDefined(self.font_animation_index))
        self.font_animation_index = 5; // Giro por defecto

    // Reproducir sonido de apertura del menú
    scripts\zm\playsound::play_menu_open_sound(self);
    
    // Crear menú principal con el título según el idioma
    title = (self.langLEN == 0) ? "MENÚ DE MODS" : "MODS MENU";
    menu = create_menu(title, self);
    menu.is_main_menu = true; // Identificador para menú principal
    
    // Verificar estados para indicaciones visuales
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();
    
    // Añadir opciones al menú con textos según el idioma
    if (self.langLEN == 0) // Español
    {
        // Menú de Mods Littlegods
        add_menu_item(menu, "Mods Littlegods", ::open_mods_littlegods_menu);


        add_menu_item(menu, "Mapa", ::open_map_menu);
        
        // Nueva opción para configuración (bordes en rojo si no disponible)

        // Opción para ver partidas recientes
        add_menu_item(menu, "Partidas Recientes", ::open_recent_matches_menu);


        // Agregar opción de Developer solo si está desbloqueado
        if (self.developer_mode_unlocked)
            add_menu_item(menu, "Developer", ::open_developer_menu);
        else
            add_menu_item(menu, "Desbloquear Developer", ::request_developer_password);
        settings_item = add_menu_item(menu, "Configuración", ::open_settings_menu);
        if ((healthbar_active || healthbarzombie_active || legacy_mods_active) && self.edge_animation_style_index == 0)
        {
            // Añadir una indicación visual de que los bordes no están disponibles
            settings_item.item.color = (1, 0.65, 0.2); // Naranja para advertencia
        }
        add_menu_item(menu, "Créditos", ::open_credits_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Littlegods Mods menu
        add_menu_item(menu, "Mods Littlegods", ::open_mods_littlegods_menu);


        add_menu_item(menu, "Map", ::open_map_menu);
        

        // Recent matches option
        add_menu_item(menu, "Recent Matches", ::open_recent_matches_menu);

        // Agregar opción de Developer solo si está desbloqueado
        if (self.developer_mode_unlocked)
            add_menu_item(menu, "Developer", ::open_developer_menu);
        else
            add_menu_item(menu, "Unlock Developer", ::request_developer_password);

                // Nueva opción para configuración (bordes en rojo si no disponible)
        settings_item = add_menu_item(menu, "Settings", ::open_settings_menu);
        if ((healthbar_active || healthbarzombie_active || legacy_mods_active) && self.edge_animation_style_index == 0)
        {
            // Añadir una indicación visual de que los bordes no están disponibles
            settings_item.item.color = (1, 0.65, 0.2); // Naranja para advertencia
        }
        add_menu_item(menu, "Credits", ::open_credits_menu);

        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    // Mostrar menú y controlar la navegación
    show_menu(menu);

    // Aplicar la posición del texto actual al menú
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    // Aplicar el estilo y color actual si es necesario
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        // Actualizar el color del elemento seleccionado a blanco para mantener consistencia
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

open_night_mode_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    // Cerrar el menú anterior pero mantener referencia al menú principal
    self notify("destroy_current_menu");
    wait 0.1;
    
    // Crear submenú de Night Mode con título según idioma
    title = (self.langLEN == 0) ? "MODO NOCHE" : "NIGHT MODE";
    menu = create_menu(title, self);
    menu.parent_menu = "mods_littlegods"; // Para saber a qué menú volver
    
    // Añadir opciones al menú con textos según el idioma
    status = self.night_mode_enabled ? "ON" : "OFF";
    if (self.langLEN == 0) // Español
    {
        add_menu_item(menu, "Estado: " + status, ::toggle_night_mode);
        
        // Siempre añadir el filtro, pero controlar su visibilidad
        filter_item = add_menu_item(menu, "Filtro: " + self.night_mode_filter, ::cycle_night_filter);
        filter_item.item.alpha = self.night_mode_enabled ? 1 : 0;
        
        // Añadir opción para ajustar la oscuridad (valuenight)
        darkness_item = add_menu_item(menu, "Oscuridad: " + self.night_mode_darkness, ::cycle_night_darkness);
        darkness_item.item.alpha = self.night_mode_enabled ? 1 : 0;
        
        // Añadir opción para activar/desactivar fog (siempre visible)
        // Estado de la niebla: Si fog_enabled es true, entonces está ON
        fog_status = self.fog_enabled ? "ON" : "OFF";
        add_menu_item(menu, "Niebla: " + fog_status, ::toggle_fog);
        
        // Opción para guardar configuración del Night Mode
        add_menu_item(menu, "Guardar Configuración", ::save_nightmode_configuration);
        
        add_menu_item(menu, "Volver", ::menu_go_back_to_mods_littlegods);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        add_menu_item(menu, "Status: " + status, ::toggle_night_mode);
        
        // Siempre añadir el filtro, pero controlar su visibilidad
        filter_item = add_menu_item(menu, "Filter: " + self.night_mode_filter, ::cycle_night_filter);
        filter_item.item.alpha = self.night_mode_enabled ? 1 : 0;
        
        // Añadir opción para ajustar la oscuridad (valuenight)
        darkness_item = add_menu_item(menu, "Darkness: " + self.night_mode_darkness, ::cycle_night_darkness);
        darkness_item.item.alpha = self.night_mode_enabled ? 1 : 0;
        
        // Añadir opción para activar/desactivar fog (siempre visible)
        // Estado de la niebla: Si fog_enabled es true, entonces está ON
        fog_status = self.fog_enabled ? "ON" : "OFF";
        add_menu_item(menu, "Fog: " + fog_status, ::toggle_fog);

        // Opción para guardar configuración del Night Mode
        add_menu_item(menu, "Save Configuration", ::save_nightmode_configuration);

        add_menu_item(menu, "Back", ::menu_go_back_to_mods_littlegods);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    // Mostrar menú y controlar la navegación
    show_menu(menu);

    // Aplicar la posición del texto actual al menú
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    // Mantener la selección actual si existe
    if (isDefined(self.menu_current) && isDefined(self.menu_current.selected))
    {
        menu.selected = self.menu_current.selected;
        // Actualizar colores para reflejar la selección
        for (i = 0; i < menu.items.size; i++)
        {
            if (i == menu.selected)
                menu.items[i].item.color = (1, 1, 1); // Blanco brillante para el texto seleccionado
            else
                menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    self thread menu_control(menu);
}

open_healthbar_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    // Cerrar el menú anterior pero mantener referencia al menú principal
    self notify("destroy_current_menu");
    wait 0.1;
    
    // Crear submenú de HealthBar con título según idioma
    title = (self.langLEN == 0) ? "BARRA DE VIDA" : "HEALTH BAR";
    menu = create_menu(title, self);
    menu.parent_menu = "mods_littlegods"; // Para saber a qué menú volver
    
    // Verificar si los bordes del menú o la barra zombie están activos
    borders_active = (self.edge_animation_style_index > 0);
    zombie_bar_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();
    
    // Añadir opciones al menú con textos según el idioma
    status = self.healthbar_enabled ? "ON" : "OFF";
    if (self.langLEN == 0) // Español
    {
        // Añadir opción de estado y verificar si debe mostrarse en rojo
        status_item = add_menu_item(menu, "Estado: " + status, ::toggle_healthbar);
        
        // Si los bordes o la barra zombie están activos y la barra no está habilitada, mostrar en rojo
        if ((borders_active && !self.healthbar_enabled) || (zombie_bar_active && !self.healthbar_enabled) || (legacy_mods_active && !self.healthbar_enabled))
        {
            status_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }
        
        // Siempre añadir la posición, pero controlar su visibilidad
        if (self.healthbar_position == "left")
            pos_text = "IZQUIERDA";
        else if (self.healthbar_position == "top_left")
            pos_text = "ARRIBA IZQUIERDA";
        else
            pos_text = "ARRIBA";
        pos_item = add_menu_item(menu, "Posición: " + pos_text, ::cycle_healthbar_position);
        pos_item.item.alpha = self.healthbar_enabled ? 1 : 0;
        
        add_menu_item(menu, "Volver", ::menu_go_back_to_mods_littlegods);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Añadir opción de estado y verificar si debe mostrarse en rojo
        status_item = add_menu_item(menu, "Status: " + status, ::toggle_healthbar);
        
        // Si los bordes o la barra zombie están activos y la barra no está habilitada, mostrar en rojo
        if ((borders_active && !self.healthbar_enabled) || (zombie_bar_active && !self.healthbar_enabled) || (legacy_mods_active && !self.healthbar_enabled))
        {
            status_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }
        
        // Siempre añadir la posición, pero controlar su visibilidad
        if (self.healthbar_position == "left")
            pos_text = "LEFT";
        else if (self.healthbar_position == "top_left")
            pos_text = "TOP LEFT";
        else
            pos_text = "TOP";
        pos_item = add_menu_item(menu, "Position: " + pos_text, ::cycle_healthbar_position);
        pos_item.item.alpha = self.healthbar_enabled ? 1 : 0;

        add_menu_item(menu, "Back", ::menu_go_back_to_mods_littlegods);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    // Mostrar menú y controlar la navegación
    show_menu(menu);

    // Aplicar la posición del texto actual al menú
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    // Mantener la selección actual si existe
    if (isDefined(self.menu_current) && isDefined(self.menu_current.selected))
    {
        menu.selected = self.menu_current.selected;
        // Actualizar colores para reflejar la selección
        for (i = 0; i < menu.items.size; i++)
        {
            if (i == menu.selected)
                menu.items[i].item.color = (1, 1, 1); // Blanco brillante para el texto seleccionado
            else if ((borders_active && !self.healthbar_enabled && i == 0) || 
                    (zombie_bar_active && !self.healthbar_enabled && i == 0) ||
                    (legacy_mods_active && !self.healthbar_enabled && i == 0)) // La opción de estado es la primera
                menu.items[i].item.color = (1, 0.2, 0.2); // Mantener rojo si no está seleccionada
            else
                menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    self thread menu_control(menu);
}

//----------------------
// Menú de la Barra Zombie
//----------------------
open_healthbarzombie_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    // Cerrar el menú anterior pero mantener referencia al menú principal
    self notify("destroy_current_menu");
    wait 0.1;
    
    // Crear submenú de Barra Zombie con título según idioma
    title = (self.langLEN == 0) ? "BARRA ZOMBIE" : "ZOMBIE BAR";
    menu = create_menu(title, self);
    menu.parent_menu = "mods_littlegods"; // Para saber a qué menú volver
    
    // Verificar si los bordes del menú o la barra de vida están activos
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    legacy_mods_active = are_legacy_mods_active();
    
    // Inicializar valores por defecto si no existen
    if (!isDefined(self.healthbarzombie_enabled))
        self.healthbarzombie_enabled = false;
        
    if (!isDefined(self.healthbarzombie_color))
        self.healthbarzombie_color = "default";
        
    if (!isDefined(self.healthbarzombie_sizew))
        self.healthbarzombie_sizew = 100;
        
    if (!isDefined(self.healthbarzombie_sizeh))
        self.healthbarzombie_sizeh = 2;
        
    if (!isDefined(self.healthbarzombie_sizen))
        self.healthbarzombie_sizen = 1.2;
        
    if (!isDefined(self.healthbarzombie_shader))
        self.healthbarzombie_shader = "transparent";
        
    if (!isDefined(self.show_zombie_name))
        self.show_zombie_name = true;
    
    // Añadir opciones al menú con textos según el idioma
    status = self.healthbarzombie_enabled ? "ON" : "OFF";
    
    // Preparar textos de las opciones según el idioma
    if (self.langLEN == 0) // Español
    {
        // Añadir opción para activar/desactivar la barra
        status_item = add_menu_item(menu, "Estado: " + status, ::toggle_healthbarzombie);
        
        // Si los bordes o la barra de vida están activos y la barra zombie no está habilitada, mostrar en rojo
        if ((borders_active && !self.healthbarzombie_enabled) || (healthbar_active && !self.healthbarzombie_enabled) || (legacy_mods_active && !self.healthbarzombie_enabled))
        {
            status_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }
        
        // Obtener el nombre del color para mostrar
        color_display = self.healthbarzombie_color;
        
        // Añadir opciones para configurar la barra (visibles solo si está activada)
        color_item = add_menu_item(menu, "Color: " + color_display, ::cycle_healthbarzombie_color);
        width_item = add_menu_item(menu, "Ancho: " + self.healthbarzombie_sizew, ::cycle_healthbarzombie_width);
        height_item = add_menu_item(menu, "Alto: " + self.healthbarzombie_sizeh, ::cycle_healthbarzombie_height);
        namesize_item = add_menu_item(menu, "Tamaño Nombre: " + self.healthbarzombie_sizen, ::cycle_healthbarzombie_namesize);
        shader_item = add_menu_item(menu, "Shader: " + self.healthbarzombie_shader, ::cycle_healthbarzombie_shader);
        
        // Opción para mostrar/ocultar el nombre del zombie
        zombie_name_status = self.show_zombie_name ? "ON" : "OFF";
        zombie_name_item = add_menu_item(menu, "Mostrar Nombre: " + zombie_name_status, ::toggle_zombie_name);
        
        // Opciones de navegación
        add_menu_item(menu, "Volver", ::menu_go_back_to_mods_littlegods);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Añadir opción para activar/desactivar la barra
        status_item = add_menu_item(menu, "Status: " + status, ::toggle_healthbarzombie);
        
        // Si los bordes o la barra de vida están activos y la barra zombie no está habilitada, mostrar en rojo
        if ((borders_active && !self.healthbarzombie_enabled) || (healthbar_active && !self.healthbarzombie_enabled) || (legacy_mods_active && !self.healthbarzombie_enabled))
        {
            status_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }
        
        // Obtener el nombre del color para mostrar en inglés
        color_display = self.healthbarzombie_color;
        switch(self.healthbarzombie_color)
        {
            case "default": color_display = "random"; break;
            case "rojo": color_display = "red"; break;
            case "verde": color_display = "green"; break;
            case "azul": color_display = "blue"; break;
            case "amarillo": color_display = "yellow"; break;
            case "magenta": color_display = "magenta"; break;
            case "cian": color_display = "cyan"; break;
            case "blanco": color_display = "white"; break;
            case "negro": color_display = "black"; break;
            case "rojoosc": color_display = "dark red"; break;
            case "verdeosc": color_display = "dark green"; break;
            case "azulosc": color_display = "dark blue"; break;
            case "amarilloosc": color_display = "dark yellow"; break;
            case "magentaosc": color_display = "dark magenta"; break;
            case "cianosc": color_display = "dark cyan"; break;
            case "grisclaro": color_display = "light gray"; break;
            case "grisosc": color_display = "dark gray"; break;
            case "naranja": color_display = "orange"; break;
            case "marron": color_display = "brown"; break;
            case "rosa": color_display = "pink"; break;
            case "purpura": color_display = "purple"; break;
            case "verdeclaro": color_display = "light green"; break;
        }
        
        // Añadir opciones para configurar la barra (visibles solo si está activada)
        color_item = add_menu_item(menu, "Color: " + color_display, ::cycle_healthbarzombie_color);
        width_item = add_menu_item(menu, "Width: " + self.healthbarzombie_sizew, ::cycle_healthbarzombie_width);
        height_item = add_menu_item(menu, "Height: " + self.healthbarzombie_sizeh, ::cycle_healthbarzombie_height);
        namesize_item = add_menu_item(menu, "Name Size: " + self.healthbarzombie_sizen, ::cycle_healthbarzombie_namesize);
        shader_item = add_menu_item(menu, "Shader: " + self.healthbarzombie_shader, ::cycle_healthbarzombie_shader);
        
        // Opción para mostrar/ocultar el nombre del zombie
        zombie_name_status = self.show_zombie_name ? "ON" : "OFF";
        zombie_name_item = add_menu_item(menu, "Show Name: " + zombie_name_status, ::toggle_zombie_name);
        
        // Opciones de navegación
        add_menu_item(menu, "Back", ::menu_go_back_to_mods_littlegods);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    // Ocultar opciones si la barra no está activada
    if (!self.healthbarzombie_enabled)
    {
        color_item.item.alpha = 0;
        width_item.item.alpha = 0;
        height_item.item.alpha = 0;
        namesize_item.item.alpha = 0;
        shader_item.item.alpha = 0;
        zombie_name_item.item.alpha = 0;
    }

    // Mostrar menú y controlar la navegación
    show_menu(menu);

    // Aplicar la posición del texto actual al menú
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    // Mantener la selección actual si existe
    if (isDefined(self.menu_current) && isDefined(self.menu_current.selected))
    {
        menu.selected = self.menu_current.selected;
        // Actualizar colores para reflejar la selección
        for (i = 0; i < menu.items.size; i++)
        {
            if (i == menu.selected)
                menu.items[i].item.color = (1, 1, 1); // Blanco brillante para el texto seleccionado
            else if ((borders_active && !self.healthbarzombie_enabled && i == 0) ||
                    (healthbar_active && !self.healthbarzombie_enabled && i == 0) ||
                    (legacy_mods_active && !self.healthbarzombie_enabled && i == 0)) // La opción de estado es la primera
                menu.items[i].item.color = (1, 0.2, 0.2); // Mantener rojo si no está seleccionada
            else
                menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    self thread menu_control(menu);
}

// Función para volver al menú anterior
menu_go_back()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_going_back))
        return;
    
    self.is_going_back = true;
    
    // Identificar a qué menú volver
    if (self.menu_current && isDefined(self.menu_current.parent_menu))
    {
        parent_type = self.menu_current.parent_menu;
        
        // Guardar el índice de estilo 
        saved_style_index = self.menu_style_index;
        
        // Limpiar menú actual
        self notify("destroy_current_menu");
        wait 0.2; // Aumentar el tiempo de espera
        
        // Volver al menú padre
        if (parent_type == "main")
        {
            self thread open_main_menu();
        }
        else if (parent_type == "developer")
        {
            self thread open_developer_menu();
        }
        else if (parent_type == "weapons")
        {
            // Determinar qué submenú de armas era
            if (isDefined(self.last_weapon_menu))
            {
                if (self.last_weapon_menu == "staffs")
                    self thread open_staffs_menu();
                else
                    self thread open_weapons_menu();
            }
            else
            {
                self thread open_weapons_menu();
            }
        }
        else if (parent_type == "mods_littlegods")
        {
            self thread open_mods_littlegods_menu();
        }
        else if (parent_type == "player")
        {
            self thread open_player_menu();
        }
        else if (parent_type == "zombie")
        {
            self thread open_zombie_menu();
        }
        else if (parent_type == "map")
        {
            self thread open_map_menu();
        }
        else
        {
            // Fallback: si no hay parent_type específico, ir al menú principal
            self thread open_main_menu();
        }
    }
    
    // Esperar un tiempo antes de permitir otra navegación
    wait 0.5;
    self.is_going_back = undefined;
}

// Funciones para crear y controlar el menú
create_menu(title, player)
{
    menu = spawnStruct();
    menu.title = title;
    menu.user = player;
    menu.items = [];
    menu.selected = 0;
    menu.open = true;
    
    // Usar el estilo de menú seleccionado por el jugador (si está definido)
    if (isDefined(player.menu_style_index))
    {
        menu.style_index = player.menu_style_index;
    }
    else
    {
        // Estilo predeterminado
    menu.active_color = (0, 0, 1); // Azul por defecto
    menu.inactive_color = (1, 1, 1); // Blanco
    }
    
    // Dimensiones fijas para el menú
    menu.width = 200;
    
    // Aplicar la posición según la configuración del jugador
    switch(player.menu_position)
    {
        case 0: // Superior-izquierda
            menu.x_offset = 0;
            menu.y_offset = 120;
            menu.background_horzalign = "left"; // Corregido: alineación horizontal a la izquierda
            menu.background_vertalign = "top";  // Corregido: alineación vertical a la parte superior
            break;
        case 1: // Inferior-central
            menu.x_offset = 0;
            menu.y_offset = -150; // Posición inferior (valor negativo)
            menu.background_horzalign = "center";
            menu.background_vertalign = "bottom";
            break;
        case 2: // Izquierda-central
            menu.x_offset = 50;
            menu.y_offset = 0;
            menu.background_horzalign = "left";
            menu.background_vertalign = "middle";
            break;
        case 3: // Derecha-central
            menu.x_offset = -50;
            menu.y_offset = 0;
            menu.background_horzalign = "right";
            menu.background_vertalign = "middle";
            break;
        default: // Por defecto, superior-central
            menu.x_offset = 0;
            menu.y_offset = 120;
            menu.background_horzalign = "center";
            menu.background_vertalign = "top";
    }
    
    menu.item_height = 20;
    menu.header_height = 25;
    
    // Guardar referencia al menú actual
    player.menu_current = menu;
    
    // Crear elementos HUD para el título y fondo
    menu.background = newClientHudElem(player);
    menu.background.vertalign = menu.background_vertalign;
    menu.background.horzalign = menu.background_horzalign;
    menu.background.x = menu.x_offset;
    menu.background.y = menu.y_offset;
    menu.background.alpha = 0.8;
    menu.background.color = (0, 0, 0);
    menu.background setShader("white", menu.width, menu.header_height + (menu.item_height * 8)); // Altura dinámica
    
    // Crear el fondo del encabezado con mejor visibilidad
    menu.header_bg = newClientHudElem(player);
    menu.header_bg.vertalign = menu.background_vertalign;
    menu.header_bg.horzalign = menu.background_horzalign;
    menu.header_bg.x = menu.x_offset;
    menu.header_bg.y = menu.y_offset;
    menu.header_bg.alpha = 0.95; // Alta opacidad para mejor visibilidad
    menu.header_bg.color = (0.15, 0.15, 0.25); // Color ligeramente más claro para mejor contraste
    menu.header_bg setShader("white", menu.width, menu.header_height);

    // Crear borde superior del encabezado para mejor definición
    menu.header_border_top = newClientHudElem(player);
    menu.header_border_top.vertalign = menu.background_vertalign;
    menu.header_border_top.horzalign = menu.background_horzalign;
    menu.header_border_top.x = menu.x_offset;
    menu.header_border_top.y = menu.y_offset;
    menu.header_border_top.alpha = 1;
    menu.header_border_top.color = (0.8, 0.8, 0.9); // Borde blanco-azulado
    menu.header_border_top setShader("white", menu.width, 1); // Línea delgada en la parte superior

    // Crear texto del título con mejor visibilidad
    menu.title_text = newClientHudElem(player);
    menu.title_text.vertalign = menu.background_vertalign;
    menu.title_text.horzalign = menu.background_horzalign;

    // Establecer la alineación del texto del título según la posición del menú
    if (menu.background_horzalign == "left")
    {
        menu.title_text.x = menu.x_offset + 12; // Añadir margen para texto alineado a la izquierda
        menu.title_text.alignX = "left"; // Alinear el texto a la izquierda
    }
    else if (menu.background_horzalign == "right")
    {
        menu.title_text.x = menu.x_offset - 12; // Añadir margen para texto alineado a la derecha
        menu.title_text.alignX = "right"; // Alinear el texto a la derecha
    }
    else // center
    {
        menu.title_text.x = menu.x_offset;
        menu.title_text.alignX = "center"; // Alinear el texto al centro
    }

    menu.title_text.y = menu.y_offset + 3; // Mejor centrado vertical
    menu.title_text.fontscale = 1.5; // Tamaño ligeramente mayor para mejor legibilidad
    menu.title_text.alpha = 1; // Asegurar máxima opacidad
    menu.title_text.color = (1, 1, 1); // Blanco brillante
    menu.title_text.sort = 2; // Asegurar que el texto esté al frente
    menu.title_text setText(title);

    // Crear sombra del texto detrás para profundidad (sin superposición)
    menu.title_shadow = newClientHudElem(player);
    menu.title_shadow.vertalign = menu.background_vertalign;
    menu.title_shadow.horzalign = menu.background_horzalign;
    
    // Copiar la alineación del texto principal
    if (menu.background_horzalign == "left")
    {
        menu.title_shadow.x = menu.x_offset + 14; // Desplazamiento mayor para evitar superposición
        menu.title_shadow.alignX = "left";
    }
    else if (menu.background_horzalign == "right")
    {
        menu.title_shadow.x = menu.x_offset - 10;
        menu.title_shadow.alignX = "right";
    }
    else // center
    {
        menu.title_shadow.x = menu.x_offset + 2;
        menu.title_shadow.alignX = "center";
    }
    
    menu.title_shadow.y = menu.y_offset + 5; // Desplazamiento mayor hacia abajo
    menu.title_shadow.fontscale = 1.5;
    menu.title_shadow.alpha = 0.4; // Más transparente para efecto sutil
    menu.title_shadow.color = (0, 0, 0); // Negro para sombra
    menu.title_shadow.sort = 0; // Asegurar que la sombra esté detrás
    menu.title_shadow setText(title);

    // Crear barra de selección
    menu.selection_bar = newClientHudElem(player);
    menu.selection_bar.vertalign = menu.background_vertalign;
    menu.selection_bar.horzalign = menu.background_horzalign;
    menu.selection_bar.x = menu.x_offset;
    
    // Definir posición inicial (se ajustará en show_menu)
    menu.selection_bar.y = menu.y_offset + menu.header_height;
    menu.selection_bar.alpha = 0.6;
    menu.selection_bar.color = menu.active_color;
    
    // Aplicar estilo del menú (si hay un estilo definido)
    if (isDefined(menu.style_index))
    {
        menu = apply_menu_style(menu, menu.style_index);
    }

    // Aplicar la configuración de transparencia personalizada después del estilo
    if (isDefined(menu.user) && isDefined(menu.user.transparency_index))
    {
        menu = scripts\zm\style_transparecy::apply_transparency(menu, menu.user.transparency_index);
    }

    // Nota: La transparencia del header ya se aplica correctamente desde create_menu()
    // No forzar opacidad mínima para respetar la configuración del usuario

    if (isDefined(menu.title_text))
    {
        menu.title_text.alpha = 1; // Siempre máxima opacidad para el texto
        menu.title_text.sort = 2; // Asegurar que esté al frente
    }

    if (isDefined(menu.title_shadow))
    {
        menu.title_shadow.alpha = 0.4; // Sombra sutil
        menu.title_shadow.sort = 0; // Asegurar que esté detrás
    }

    // Aplicar la animación de fuente configurada por el usuario
    if (isDefined(menu.user.font_animation_index) && menu.user.font_animation_index > 0)
    {
        scripts\zm\style_font_animation::apply_font_animation(menu, menu.user.font_animation_index);
    }

    return menu;
}

add_menu_item(menu, text, func, is_menu_flag)
{
    item = spawnStruct();
    
    // Crear elemento HUD para el texto
    item.item = newClientHudElem(menu.user);
    item.item.vertalign = menu.background_vertalign;
    item.item.horzalign = menu.background_horzalign;
    
    // Ajustar la posición X según la alineación horizontal
    if (menu.background_horzalign == "left")
    {
        item.item.x = menu.background.x + 15; // Añadir margen para texto alineado a la izquierda
        item.item.alignX = "left"; // Alinear el texto a la izquierda dentro del elemento
    }
    else if (menu.background_horzalign == "right")
    {
        item.item.x = menu.background.x - 15; // Restar margen para texto alineado a la derecha
        item.item.alignX = "right"; // Alinear el texto a la derecha dentro del elemento
    }
    else // center
    {
        item.item.x = menu.background.x;
        item.item.alignX = "center"; // Alinear el texto al centro dentro del elemento
    }
    
    // Ajustar la posición Y según la alineación vertical
    if (menu.background_vertalign == "top")
    {
        item.item.y = menu.background.y + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    else if (menu.background_vertalign == "bottom")
    {
        // Para alineación inferior, calculamos desde abajo hacia arriba
        item.item.y = menu.background.y + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    else // middle
    {
        // Para alineación central, ajustamos desde el centro
        total_height = menu.header_height + (menu.item_height * (menu.items.size + 1));
        item.item.y = menu.background.y - (total_height / 2) + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    
    item.item.fontscale = 1.2;
    item.item.alpha = 1;
    
    // Por defecto, el primer ítem está seleccionado
    if (menu.items.size == 0)
        item.item.color = menu.active_color;
    else
        item.item.color = menu.inactive_color;
    
    item.item setText(text);
    item.func = func;
    item.is_menu = isDefined(is_menu_flag) ? is_menu_flag : false;
    
    menu.items[menu.items.size] = item;
    return item;
}

show_menu(menu)
{
    menu.open = true;
    
    // Actualizar la altura del fondo según el número de elementos
    total_height = menu.header_height + (menu.item_height * menu.items.size);
    menu.background setShader("white", menu.width, total_height);
    
    // Asegurarse de que la selección inicial sea una opción visible
    // Si el elemento seleccionado actualmente está desactivado o no definido
    if (!isDefined(menu.selected) || menu.selected < 0 || menu.selected >= menu.items.size || menu.items[menu.selected].item.alpha == 0)
    {
        // Buscar el primer elemento visible
        menu.selected = 0; // Empezar desde el principio
        while (menu.selected < menu.items.size && menu.items[menu.selected].item.alpha == 0)
        {
            menu.selected++;
        }
        
        // Si no hay opciones visibles, establecer selección al primer elemento
        if (menu.selected >= menu.items.size)
        {
            menu.selected = 0;
        }
    }
    
    // Ajustar la posición X de la barra de selección según la alineación
    if (menu.background_horzalign == "left")
    {
        // Para alineación izquierda, usamos la posición del fondo
        menu.selection_bar.x = menu.background.x;
    }
    else if (menu.background_horzalign == "right")
    {
        // Para alineación derecha, usamos la posición del fondo
        menu.selection_bar.x = menu.background.x;
    }
    else // center
    {
        // Para alineación central, usamos la posición del fondo
        menu.selection_bar.x = menu.background.x;
    }
    
    // Ajustar la posición Y de la barra de selección según la alineación
    if (menu.background_vertalign == "top")
    {
        // Para alineación superior, calculamos desde arriba
        menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    }
    else if (menu.background_vertalign == "bottom")
    {
        // Para alineación inferior, calculamos desde abajo
        menu.selection_bar.y = menu.background.y + menu.header_height + (menu.item_height * menu.selected);
    }
    else // middle
    {
        // Para alineación central, calculamos desde el centro
        menu.selection_bar.y = menu.background.y - (total_height / 2) + menu.header_height + (menu.item_height * menu.selected);
    }
    
    menu.selection_bar setShader("white", menu.width, menu.item_height);
    
    // Determinar si la opción seleccionada está bloqueada debido a incompatibilidades
    is_option_blocked = false;
    if (isDefined(menu.items[menu.selected]) && isDefined(menu.items[menu.selected].func))
    {
        borders_active = (menu.user.edge_animation_style_index > 0);
        healthbar_active = menu.user.healthbar_enabled;
        healthbarzombie_active = menu.user.healthbarzombie_enabled;
        legacy_mods_active = are_legacy_mods_active();
        
        // Verificar si está intentando activar una barra de salud mientras los bordes están activos
        if ((menu.items[menu.selected].func == ::toggle_healthbar && !menu.user.healthbar_enabled && borders_active) ||
            (menu.items[menu.selected].func == ::toggle_healthbarzombie && !menu.user.healthbarzombie_enabled && borders_active))
        {
            is_option_blocked = true;
        }
        // Verificar si está intentando activar bordes mientras una barra de salud está activa
        else if (menu.items[menu.selected].func == ::cycle_edge_animation_style && menu.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active || legacy_mods_active))
        {
            is_option_blocked = true;
        }
        // Verificar si está intentando activar la barra de vida mientras la barra zombie está activa
        else if (menu.items[menu.selected].func == ::toggle_healthbar && !menu.user.healthbar_enabled && healthbarzombie_active)
        {
            is_option_blocked = true;
        }
        // Verificar si está intentando activar la barra zombie mientras la barra de vida está activa
        else if (menu.items[menu.selected].func == ::toggle_healthbarzombie && !menu.user.healthbarzombie_enabled && healthbar_active)
        {
            is_option_blocked = true;
        }
    }
    
    // Actualizar color de los elementos de menú
    for (i = 0; i < menu.items.size; i++)
    {
        if (i == menu.selected)
        {
            menu.items[i].item.color = (1, 1, 1); // Blanco brillante para el texto seleccionado
            
            // Si la opción está bloqueada, poner el selector en rojo
            if (is_option_blocked)
            {
                menu.selection_bar.color = (1, 0.2, 0.2); // Selector rojo
            }
            else
            {
                menu.selection_bar.color = menu.active_color; // Color normal del selector
            }
        }
        else
        {
            menu.items[i].item.color = menu.inactive_color;
        }
    }
    
    // NUEVO: Asegurarse de que la posición del texto se aplica correctamente
    if (isDefined(menu.user.font_position_index))
    {
        // Aplicar la posición de texto actual antes de mostrar el menú
        menu = scripts\zm\style_font_position::apply_font_position(menu, menu.user.font_position_index);
    }
    
    // Aplicar el estilo de selector del jugador
    if (isDefined(menu.user.selector_style_index))
    {
        menu.selector_style_index = menu.user.selector_style_index;
        menu = scripts\zm\style_selector::apply_selector_style(menu, menu.selector_style_index);
        
        // Si la opción está bloqueada, aplicar color rojo al selector personalizado
        if (is_option_blocked && isDefined(menu.selector_elements) && menu.selector_elements.size > 0)
        {
            for (i = 0; i < menu.selector_elements.size; i++)
            {
                if (isDefined(menu.selector_elements[i]))
                {
                    menu.selector_elements[i].color = (1, 0.2, 0.2); // Cambiar a rojo
                }
            }
            
            // Actualizar visuales del selector con los nuevos colores
            scripts\zm\style_selector::update_selector_visuals(menu);
        }
    }
    
    // Aplicar la animación de borde seleccionada
    if (isDefined(menu.user.edge_animation_style_index))
    {
        menu.edge_animation_style_index = menu.user.edge_animation_style_index;
        menu = scripts\zm\style_edge_animation::apply_edge_animation(menu, menu.edge_animation_style_index);
    }
}

menu_scroll_up()
{
    // Navegación circular: si estamos en el primer elemento, ir al último
    if (self.selected == 0)
    {
        self.selected = self.items.size - 1;
    }
    else
    {
        self.selected--;
    }

    // Comprobar si el elemento actual está desactivado (alpha = 0)
    // Si lo está, seguir moviéndonos hacia arriba hasta encontrar uno disponible
    while (self.items[self.selected].item.alpha == 0)
    {
        if (self.selected == 0)
        {
            self.selected = self.items.size - 1; // Loop al final si estamos en el principio
        }
        else
        {
            self.selected--;
        }

        // Evitar bucle infinito si todos los elementos están deshabilitados
        if (self.selected == self.items.size - 1 && self.items[self.selected].item.alpha == 0)
            break;
    }

    // Determinar si la opción seleccionada está bloqueada debido a incompatibilidades
    is_option_blocked = false;
    borders_active = (self.user.edge_animation_style_index > 0);
    healthbar_active = self.user.healthbar_enabled;
    healthbarzombie_active = self.user.healthbarzombie_enabled;

    // Verificar si la opción actual está bloqueada
    if (isDefined(self.items[self.selected].func))
    {
        // Verificar si está intentando activar una barra de salud mientras los bordes están activos
        if ((self.items[self.selected].func == ::toggle_healthbar && !self.user.healthbar_enabled && borders_active) ||
            (self.items[self.selected].func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && borders_active))
        {
            is_option_blocked = true;
        }
        // Verificar si está intentando activar bordes mientras una barra de salud está activa
        else if (self.items[self.selected].func == ::cycle_edge_animation_style && self.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active))
        {
            is_option_blocked = true;
        }
        // Verificar si está intentando activar la barra de vida mientras la barra zombie está activa
        else if (self.items[self.selected].func == ::toggle_healthbar && !self.user.healthbar_enabled && healthbarzombie_active)
        {
            is_option_blocked = true;
        }
        // Verificar si está intentando activar la barra zombie mientras la barra de vida está activa
        else if (self.items[self.selected].func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && healthbar_active)
        {
            is_option_blocked = true;
        }
    }

    // Asegurar que active_color esté definido
    if (!isDefined(self.active_color))
        self.active_color = (0.4, 0.7, 1); // Azul claro por defecto
    if (!isDefined(self.inactive_color))
        self.inactive_color = (0.6, 0.6, 0.6); // Gris por defecto

    // Actualizar colores
    for (i = 0; i < self.items.size; i++)
    {
        if (i == self.selected)
        {
            // Si la opción está bloqueada, poner el selector en rojo
            if (is_option_blocked)
            {
                self.items[i].item.color = (1, 1, 1); // Texto siempre blanco
                self.selection_bar.color = (1, 0.2, 0.2); // Selector rojo

                // Si hay un selector personalizado, actualizar su color también
                if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
                {
                    if (isDefined(self.selector_elements) && self.selector_elements.size > 0)
                    {
                        for (j = 0; j < self.selector_elements.size; j++)
                        {
                            if (isDefined(self.selector_elements[j]))
                            {
                                self.selector_elements[j].color = (1, 0.2, 0.2); // Cambiar a rojo
                            }
                        }
                    }
                }
            }
            else
            {
                // Verificar si estamos en el menú de banco para colores especiales del selector
                selector_color = self.active_color; // Color por defecto

                if (self.title == "BANCO" || self.title == "BANK")
                {
                    // Colores especiales para el menú de banco según la opción seleccionada
                    if (self.selected == 2) // [+] Incrementar/Increase
                        selector_color = (0.2, 1, 0.2); // Verde
                    else if (self.selected == 3) // [-] Decrementar/Decrease
                        selector_color = (1, 0.2, 0.2); // Rojo
                    else if (self.selected == 4 || self.selected == 5) // Depositar/Retirar cantidad
                        selector_color = (1, 1, 0.2); // Amarillo
                    else if (self.selected == 6 || self.selected == 7) // Depositar/Retirar todo
                        selector_color = (0.2, 0.2, 1); // Azul
                }

                self.items[i].item.color = (1, 1, 1); // Blanco brillante para el texto seleccionado
                self.selection_bar.color = selector_color;

                // Si hay un selector personalizado, actualizar su color también
                if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
                {
                    if (isDefined(self.selector_elements) && self.selector_elements.size > 0)
                    {
                        for (j = 0; j < self.selector_elements.size; j++)
                        {
                            if (isDefined(self.selector_elements[j]))
                            {
                                self.selector_elements[j].color = selector_color;
                            }
                        }
                    }
                }
            }
        }
        else
        {
            self.items[i].item.color = self.inactive_color;
        }
    }

    // Actualizar la posición de la barra de selección
    self.selection_bar.y = self.background.y + self.header_height + (self.item_height * self.selected);

    // Actualizar la posición del selector personalizado
    if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
    {
        scripts\zm\style_selector::update_selector_position(self);
        scripts\zm\style_selector::update_selector_visuals(self);
    }

    // Reproducir sonido de navegación/scroll
    if (isDefined(self.user))
        scripts\zm\playsound::play_menu_scroll_sound(self.user);
    else
        scripts\zm\playsound::play_menu_scroll_sound(self);

    // Notificar movimiento del selector para activar animaciones de fuente
    self notify("selector_moved");
}

menu_scroll_down()
{
    // Navegación circular: si estamos en el último elemento, ir al primero
    if (self.selected == self.items.size - 1)
    {
        self.selected = 0;
    }
    else
    {
        self.selected++;
    }

    // Comprobar si el elemento actual está desactivado (alpha = 0)
    // Si lo está, seguir moviéndonos hacia abajo hasta encontrar uno disponible
    while (self.items[self.selected].item.alpha == 0)
    {
        if (self.selected == self.items.size - 1)
        {
            self.selected = 0; // Loop al principio si estamos en el final
        }
        else
        {
            self.selected++;
        }

        // Evitar bucle infinito si todos los elementos están deshabilitados
        if (self.selected == 0 && self.items[self.selected].item.alpha == 0)
            break;
    }

    // Determinar si la opción seleccionada está bloqueada debido a incompatibilidades
    is_option_blocked = false;
    borders_active = (self.user.edge_animation_style_index > 0);
    healthbar_active = self.user.healthbar_enabled;
    healthbarzombie_active = self.user.healthbarzombie_enabled;

    // Verificar si la opción actual está bloqueada
    if (isDefined(self.items[self.selected].func))
    {
        // Verificar si está intentando activar una barra de salud mientras los bordes están activos
        if ((self.items[self.selected].func == ::toggle_healthbar && !self.user.healthbar_enabled && borders_active) ||
            (self.items[self.selected].func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && borders_active))
        {
            is_option_blocked = true;
        }
        // Verificar si está intentando activar bordes mientras una barra de salud está activa
        else if (self.items[self.selected].func == ::cycle_edge_animation_style && self.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active))
        {
            is_option_blocked = true;
        }
        // Verificar si está intentando activar la barra de vida mientras la barra zombie está activa
        else if (self.items[self.selected].func == ::toggle_healthbar && !self.user.healthbar_enabled && healthbarzombie_active)
        {
            is_option_blocked = true;
        }
        // Verificar si está intentando activar la barra zombie mientras la barra de vida está activa
        else if (self.items[self.selected].func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && healthbar_active)
        {
            is_option_blocked = true;
        }
    }

    // Asegurar que active_color esté definido
    if (!isDefined(self.active_color))
        self.active_color = (0.4, 0.7, 1); // Azul claro por defecto
    if (!isDefined(self.inactive_color))
        self.inactive_color = (0.6, 0.6, 0.6); // Gris por defecto

    // Actualizar colores
    for (i = 0; i < self.items.size; i++)
    {
        if (i == self.selected)
        {
            // Si la opción está bloqueada, poner el selector en rojo
            if (is_option_blocked)
            {
                self.items[i].item.color = (1, 1, 1); // Texto siempre blanco
                self.selection_bar.color = (1, 0.2, 0.2); // Selector rojo

                // Si hay un selector personalizado, actualizar su color también
                if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
                {
                    if (isDefined(self.selector_elements) && self.selector_elements.size > 0)
                    {
                        for (j = 0; j < self.selector_elements.size; j++)
                        {
                            if (isDefined(self.selector_elements[j]))
                            {
                                self.selector_elements[j].color = (1, 0.2, 0.2); // Cambiar a rojo
                            }
                        }
                    }
                }
            }
            else
            {
                // Verificar si estamos en el menú de banco para colores especiales del selector
                selector_color = self.active_color; // Color por defecto

                if (self.title == "BANCO" || self.title == "BANK")
                {
                    // Colores especiales para el menú de banco según la opción seleccionada
                    if (self.selected == 2) // [+] Incrementar/Increase
                        selector_color = (0.2, 1, 0.2); // Verde
                    else if (self.selected == 3) // [-] Decrementar/Decrease
                        selector_color = (1, 0.2, 0.2); // Rojo
                    else if (self.selected == 4 || self.selected == 5) // Depositar/Retirar cantidad
                        selector_color = (1, 1, 0.2); // Amarillo
                    else if (self.selected == 6 || self.selected == 7) // Depositar/Retirar todo
                        selector_color = (0.2, 0.2, 1); // Azul
                }

                self.items[i].item.color = (1, 1, 1); // Blanco brillante para el texto seleccionado
                self.selection_bar.color = selector_color;

                // Si hay un selector personalizado, actualizar su color también
                if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
                {
                    if (isDefined(self.selector_elements) && self.selector_elements.size > 0)
                    {
                        for (j = 0; j < self.selector_elements.size; j++)
                        {
                            if (isDefined(self.selector_elements[j]))
                            {
                                self.selector_elements[j].color = selector_color;
                            }
                        }
                    }
                }
            }
        }
        else
        {
            self.items[i].item.color = self.inactive_color;
        }
    }

    // Actualizar la posición de la barra de selección
    self.selection_bar.y = self.background.y + self.header_height + (self.item_height * self.selected);

    // Actualizar la posición del selector personalizado
    if (isDefined(self.selector_style_index) && self.selector_style_index > 0)
    {
        scripts\zm\style_selector::update_selector_position(self);
        scripts\zm\style_selector::update_selector_visuals(self);
    }

    // Reproducir sonido de navegación/scroll
    if (isDefined(self.user))
        scripts\zm\playsound::play_menu_scroll_sound(self.user);
    else
        scripts\zm\playsound::play_menu_scroll_sound(self);

    // Notificar movimiento del selector para activar animaciones de fuente
    self notify("selector_moved");
}

// Función para ciclar entre los colores disponibles para el menú
cycle_menu_color()
{
    // Esta función no hace nada, ya que el cambio de color del menú ha sido desactivado
    return;
}

menu_destroy()
{
    // Detener cualquier efecto activo del selector
    if (isDefined(self.selector_effect_active) && self.selector_effect_active)
    {
        self.selector_effect_active = false;
        self notify("stop_selector_effect");
    }

    // Detener cualquier animación de borde activa
    if (isDefined(self.edge_animation_active) && self.edge_animation_active)
    {
        self.edge_animation_active = false;
        self notify("stop_edge_animation");
    }

    // Destruir elementos adicionales del selector si existen
    if (isDefined(self.selector_elements))
    {
        for (i = 0; i < self.selector_elements.size; i++)
        {
            if (isDefined(self.selector_elements[i]))
                self.selector_elements[i] destroy();
        }
        self.selector_elements = [];
    }

    // Destruir elementos de animación de borde si existen
    if (isDefined(self.edge_animation_elements))
    {
        for (i = 0; i < self.edge_animation_elements.size; i++)
        {
            if (isDefined(self.edge_animation_elements[i]))
                self.edge_animation_elements[i] destroy();
        }
        self.edge_animation_elements = [];
    }

    // Destruir todos los elementos HUD
    if (isDefined(self.background))
        self.background destroy();

    if (isDefined(self.title_text))
        self.title_text destroy();

    if (isDefined(self.title_shadow))
        self.title_shadow destroy();

    if (isDefined(self.header_bg))
        self.header_bg destroy();

    if (isDefined(self.header_border_top))
        self.header_border_top destroy();

    if (isDefined(self.selection_bar))
        self.selection_bar destroy();

    for (i = 0; i < self.items.size; i++)
    {
        if (isDefined(self.items[i].item))
            self.items[i].item destroy();
    }

    self.open = false;
}

close_all_menus()
{
    // Reproducir sonido de cierre del menú
    scripts\zm\playsound::play_menu_close_sound(self);

    // Destruir el menú actual primero
    if (isDefined(self.menu_current))
    {
        self.menu_current menu_destroy();
    }
    
    // Marcar menú como cerrado
    self.menu_open = false;


    // Eliminar referencia al menú actual
    self.menu_current = undefined;

    // Esperar un momento para asegurar que todo se cierre correctamente
    wait 0.1;
}

// Implementación de los controles del menú basados en READ.txt
menu_control(menu)
{
    self endon("disconnect");
    menu endon("destroy_all_menus");
    menu endon("destroy_current_menu");

    // Escuchar la notificación para destruir el menú actual
    menu thread menu_destroy_listener();
    
    // Verificar inmediatamente si la primera opción seleccionada está bloqueada
    if (isDefined(menu.selected) && menu.selected >= 0 && menu.selected < menu.items.size)
    {
        is_option_blocked = false;
        borders_active = (menu.user.edge_animation_style_index > 0);
        healthbar_active = menu.user.healthbar_enabled;
        healthbarzombie_active = menu.user.healthbarzombie_enabled;
        legacy_mods_active = are_legacy_mods_active();
        
        // Verificar si la opción actual está bloqueada
        if (isDefined(menu.items[menu.selected].func))
        {
            // Verificar si está intentando activar una barra de salud mientras los bordes están activos
            if ((menu.items[menu.selected].func == ::toggle_healthbar && !menu.user.healthbar_enabled && borders_active) ||
                (menu.items[menu.selected].func == ::toggle_healthbarzombie && !menu.user.healthbarzombie_enabled && borders_active))
            {
                is_option_blocked = true;
            }
            // Verificar si está intentando activar bordes mientras una barra de salud está activa
            else if (menu.items[menu.selected].func == ::cycle_edge_animation_style && menu.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active || legacy_mods_active))
            {
                is_option_blocked = true;
            }
            // Verificar si está intentando activar la barra de vida mientras la barra zombie está activa
            else if (menu.items[menu.selected].func == ::toggle_healthbar && !menu.user.healthbar_enabled && healthbarzombie_active)
            {
                is_option_blocked = true;
            }
            // Verificar si está intentando activar la barra zombie mientras la barra de vida está activa
            else if (menu.items[menu.selected].func == ::toggle_healthbarzombie && !menu.user.healthbarzombie_enabled && healthbar_active)
            {
                is_option_blocked = true;
            }
        }
        
        // Actualizar el color del selector según corresponda
        if (is_option_blocked)
        {
            menu.selection_bar.color = (1, 0.2, 0.2); // Selector rojo
            
            // Si hay un selector personalizado, actualizar su color también
            if (isDefined(menu.selector_style_index) && menu.selector_style_index > 0)
            {
                // En algunos estilos de selector, necesitamos actualizar los visuales también
                if (isDefined(menu.selector_elements) && menu.selector_elements.size > 0)
                {
                    for (i = 0; i < menu.selector_elements.size; i++)
                    {
                        if (isDefined(menu.selector_elements[i]))
                        {
                            menu.selector_elements[i].color = (1, 0.2, 0.2); // Cambiar a rojo
                        }
                    }
                }
                
                // Actualizar visuales del selector con los nuevos colores
                scripts\zm\style_selector::update_selector_visuals(menu);
            }
        }
        else
        {
            menu.selection_bar.color = menu.active_color; // Color normal del selector
            
            // Si hay un selector personalizado, restaurar su color también
            if (isDefined(menu.selector_style_index) && menu.selector_style_index > 0)
            {
                // En algunos estilos de selector, necesitamos actualizar los visuales también
                if (isDefined(menu.selector_elements) && menu.selector_elements.size > 0)
                {
                    for (i = 0; i < menu.selector_elements.size; i++)
                    {
                        if (isDefined(menu.selector_elements[i]))
                        {
                            menu.selector_elements[i].color = menu.active_color; // Restaurar color
                        }
                    }
                }
                
                // Actualizar visuales del selector
                scripts\zm\style_selector::update_selector_visuals(menu);
            }
        }
    }

    for (;;)
    {
        wait 0.05;

        if (!menu.open)
            continue;

        // Verificar si se presionan los botones de navegación
        if (self actionslotonebuttonpressed() || self actionslottwobuttonpressed() || self usebuttonpressed())
        {
            // Navegar por el menú
            if (self actionslotonebuttonpressed())
            {
                menu menu_scroll_up();
                // Esperar para evitar múltiples desplazamientos
                while (self actionslotonebuttonpressed())
                    wait 0.05;
            }
            else if (self actionslottwobuttonpressed())
            {
                menu menu_scroll_down();
                // Esperar para evitar múltiples desplazamientos
                while (self actionslottwobuttonpressed())
                    wait 0.05;
            }
            else if (self usebuttonpressed())
            {
                menu menu_select_item();
                // Esperar para evitar múltiples selecciones
                while (self usebuttonpressed())
                    wait 0.05;
            }

            // Esperar para prevenir navegación demasiado rápida
            wait 0.2;
        }
    }
}

menu_destroy_listener()
{
    self endon("disconnect");
    
    self.user waittill_any("destroy_all_menus", "destroy_current_menu");
    self menu_destroy();
}

menu_select_item()
{
    item = self.items[self.selected];

    // Verificar si el ítem está bloqueado por incompatibilidades
    is_option_blocked = false;
    if (isDefined(item) && isDefined(item.func))
    {
        borders_active = (self.user.edge_animation_style_index > 0);
        healthbar_active = self.user.healthbar_enabled;
        healthbarzombie_active = self.user.healthbarzombie_enabled;
        
        // Verificar si está intentando activar una barra de salud mientras los bordes están activos
        if ((item.func == ::toggle_healthbar && !self.user.healthbar_enabled && borders_active) ||
            (item.func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && borders_active))
        {
            is_option_blocked = true;
            if (self.user.langLEN == 0) // Español
                self.user iPrintlnBold("^1No se puede activar mientras los bordes están activos");
            else // Inglés
                self.user iPrintlnBold("^1Cannot activate while borders are active");
            return;
        }
        // Verificar si está intentando activar bordes mientras una barra de salud está activa
        else if (item.func == ::cycle_edge_animation_style && self.user.edge_animation_style_index == 0 && (healthbar_active || healthbarzombie_active))
        {
            is_option_blocked = true;
            if (self.user.langLEN == 0) // Español
                self.user iPrintlnBold("^1No se puede activar mientras las barras de salud están activas");
            else // Inglés
                self.user iPrintlnBold("^1Cannot activate while health bars are active");
            return;
        }
        // Verificar si está intentando activar la barra de vida mientras la barra zombie está activa
        else if (item.func == ::toggle_healthbar && !self.user.healthbar_enabled && healthbarzombie_active)
        {
            is_option_blocked = true;
            if (self.user.langLEN == 0) // Español
                self.user iPrintlnBold("^1No se puede activar mientras la barra zombie está activa");
            else // Inglés
                self.user iPrintlnBold("^1Cannot activate while zombie bar is active");
            return;
        }
        // Verificar si está intentando activar la barra zombie mientras la barra de vida está activa
        else if (item.func == ::toggle_healthbarzombie && !self.user.healthbarzombie_enabled && healthbar_active)
        {
            is_option_blocked = true;
            if (self.user.langLEN == 0) // Español
                self.user iPrintlnBold("^1No se puede activar mientras la barra de vida está activa");
            else // Inglés
                self.user iPrintlnBold("^1Cannot activate while health bar is active");
            return;
        }
    }

    // Ejecutar la función asociada con el ítem seleccionado solo si es visible y no está bloqueado
    if (isDefined(item) && isDefined(item.func) && isDefined(item.item) && item.item.alpha != 0 && !is_option_blocked)
    {
        // Reproducir sonido de selección
        scripts\zm\playsound::play_menu_select_sound(self.user);

        // Ejecutar con el menú actual como contexto
        self.user.menu_current = self;
        
        // Si la función es close_all_menus, ejecutarla directamente
        if (item.func == ::close_all_menus)
        {
            self.user thread close_all_menus();
        }
        else
        {
            self.user thread [[item.func]]();
        }
    }
    // Si es un elemento no visible, reproducir un sonido de error o mostrar feedback al usuario
    else if (isDefined(item) && isDefined(item.item) && item.item.alpha == 0)
    {
        // Esto se puede personalizar según las necesidades
        // Por ejemplo, un sonido de error o un mensaje
        if (self.user.langLEN == 0) // Español
            self.user iPrintlnBold("^1Opción no disponible");
        else // Inglés
            self.user iPrintlnBold("^1Option not available");
    }
}

// Funciones para controlar Night Mode
toggle_night_mode()
{
    // Evitar múltiples activaciones pero permitir una respuesta rápida
    if (isDefined(self.is_toggling_night_mode))
    {
        wait 0.1; // Pequeña espera si se presiona muy rápido
        return;
    }
    
    self.is_toggling_night_mode = true;
    
    self.night_mode_enabled = !self.night_mode_enabled;
    
    if (self.night_mode_enabled)
    {
        // Activar night mode
        self thread night_mode_toggle(self.night_mode_filter);
        // Aplicar el valor de oscuridad actual
        self setclientdvar("r_exposureValue", self.night_mode_darkness);
    }
    else
    {
        // Desactivar night mode
        self thread disable_night_mode();
    }
    
    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        // Actualizar el estado del night mode
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_night_mode)
            {
                status = self.night_mode_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estado: " + status);
                else
                    self.menu_current.items[i].item setText("Status: " + status);
            }
            // Actualizar visibilidad del filtro
            else if (self.menu_current.items[i].func == ::cycle_night_filter)
            {
                self.menu_current.items[i].item.alpha = self.night_mode_enabled ? 1 : 0;
            }
            // Actualizar visibilidad de la oscuridad
            else if (self.menu_current.items[i].func == ::cycle_night_darkness)
            {
                self.menu_current.items[i].item.alpha = self.night_mode_enabled ? 1 : 0;
            }
        }
    }
    
    // Esperar un tiempo más corto antes de permitir otra activación
    wait 0.2;
    self.is_toggling_night_mode = undefined;
}

cycle_night_filter()
{
    // Cambiar entre filtros (0-35)
    self.night_mode_filter += 1;
    if (self.night_mode_filter > 35)
        self.night_mode_filter = 0;
    
    // Aplicar el nuevo filtro
    self thread night_mode_toggle(self.night_mode_filter);
    
    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        // Buscar el elemento de filtro por su función
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_night_filter)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Filtro: " + self.night_mode_filter);
                else
                    self.menu_current.items[i].item setText("Filter: " + self.night_mode_filter);
                break;
            }
        }
    }
    
    wait 0.2;
}

// Función para ajustar la oscuridad (valuenight)
cycle_night_darkness()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_darkness))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_darkness = true;
    
    // Incrementar el valor en pasos de 0.5
    self.night_mode_darkness += 0.5;
    
    // Si excedemos el valor máximo, volver al mínimo
    if (self.night_mode_darkness > 10)
        self.night_mode_darkness = 4.5;
    
    // Aplicar el nuevo valor de oscuridad
    self setclientdvar("r_exposureValue", self.night_mode_darkness);
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        // Buscar el elemento de oscuridad por su función
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_night_darkness)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Oscuridad: " + self.night_mode_darkness);
                else
                    self.menu_current.items[i].item setText("Darkness: " + self.night_mode_darkness);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_cycling_darkness = undefined;
}

// Funciones para controlar HealthBar
toggle_healthbar()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_toggling_healthbar))
    {
        wait 0.1;
        return;
    }

    // Verificar si hay mods legacy activos y desactivarlos automáticamente
    if (!self.healthbar_enabled && are_legacy_mods_active())
    {
        // Desactivar automáticamente los legacy mods
        legacy_was_disabled = self disable_all_legacy_mods();

        if (legacy_was_disabled)
    {
        // Mostrar mensaje según el idioma
        if (self.langLEN == 0)
        {
                self iPrintlnBold("^3Mods de rendimiento desactivados automáticamente");
                self iPrintlnBold("^2Activando barra de vida del jugador...");
        }
        else
        {
                self iPrintlnBold("^3Performance mods disabled automatically");
                self iPrintlnBold("^2Activating player health bar...");
        }
            wait 0.2; // Dar tiempo para que se procesen las desactivaciones
        }
    }
    
    // Verificar si hay bordes activos
    if (!self.healthbar_enabled && self.edge_animation_style_index > 0)
    {
        // Mostrar mensaje según el idioma
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra de vida");
            self iPrintlnBold("^1Desactiva los bordes del menú primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable health bar");
            self iPrintlnBold("^1Disable menu borders first");
            self playsound("menu_error");
        }
        return;
    }
    
    // Verificar si la barra zombie está activa
    if (!self.healthbar_enabled && self.healthbarzombie_enabled)
    {
        // Mostrar mensaje según el idioma
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra de vida");
            self iPrintlnBold("^1Desactiva la barra zombie primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable health bar");
            self iPrintlnBold("^1Disable zombie bar first");
            self playsound("menu_error");
        }
        return;
    }

    
    self.is_toggling_healthbar = true;
    
    self.healthbar_enabled = !self.healthbar_enabled;
    
    if (self.healthbar_enabled)
    {

        // Activar healthbar usando la función bar_funtion_and_toogle del archivo healthbarV2.gsc
        if (self.healthbar_position == "left")
            functions = 2;
        else if (self.healthbar_position == "top_left")
            functions = 3;
        else
            functions = 1; // top
        self thread bar_funtion_and_toogle(functions);
    }
    else
    {
        // Desactivar healthbar usando la función bar_funtion_and_toogle con valor 100
        if (isDefined(self.health_bar))
        {
            self notify("endbar_health");
            self thread bar_funtion_and_toogle(100);
        }
    }
    
    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        status = self.healthbar_enabled ? "ON" : "OFF";
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_healthbar)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estado: " + status);
                else
                    self.menu_current.items[i].item setText("Status: " + status);
                break;
            }
        }
        
        // Actualizar visibilidad de la posición
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbar_position)
            {
                self.menu_current.items[i].item.alpha = self.healthbar_enabled ? 1 : 0;
                break;
            }
        }
    }
    
    // Esperar un tiempo más corto antes de permitir otra activación
    wait 0.2;
    self.is_toggling_healthbar = undefined;
}

cycle_healthbar_position()
{
    // Verificar si la barra zombie está activada y evitar cambiar a posiciones left si es así
    if (self.healthbarzombie_enabled && (self.healthbar_position == "top" || self.healthbar_position == "top_left"))
    {
        // Mostrar mensaje de error
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1Lo sentimos, la barra zombie se encuentra activa.");
            self iPrintlnBold("^1Desactívala primero para poder cambiar la barra de vida a posiciones IZQUIERDA.");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Sorry, the zombie bar is currently active.");
            self iPrintlnBold("^1Deactivate it first to change the health bar to LEFT positions.");
            self playsound("menu_error");
        }
        return; // Salir sin cambiar la posición
    }

    // Cambiar entre posiciones: top -> left -> top_left -> top
    if (self.healthbar_position == "top")
        self.healthbar_position = "left";
    else if (self.healthbar_position == "left")
        self.healthbar_position = "top_left";
    else if (self.healthbar_position == "top_left")
        self.healthbar_position = "top";
    else
        self.healthbar_position = "top"; // Default fallback
    
    // Aplicar la nueva posición si la barra está activada
    if (self.healthbar_enabled)
    {
        // Primero desactivar la barra actual
        if (isDefined(self.health_bar))
        {
            self notify("endbar_health");
            wait 0.1; // Esperar un poco para asegurar que la barra anterior se elimine
        }
        
        // Luego activar la barra en la nueva posición usando la función correcta
        if (self.healthbar_position == "left")
            functions = 2;
        else if (self.healthbar_position == "top_left")
            functions = 3;
        else
            functions = 1; // top
        self thread bar_funtion_and_toogle(functions);
    }
    
    
    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbar_position)
            {
                if (self.langLEN == 0)
                {
                    if (self.healthbar_position == "left")
                        pos_text = "IZQUIERDA";
                    else if (self.healthbar_position == "top_left")
                        pos_text = "ARRIBA IZQUIERDA";
                    else
                        pos_text = "ARRIBA";
                    self.menu_current.items[i].item setText("Posición: " + pos_text);
                }
                else
                {
                    if (self.healthbar_position == "left")
                        pos_text = "LEFT";
                    else if (self.healthbar_position == "top_left")
                        pos_text = "TOP LEFT";
                    else
                        pos_text = "TOP";
                    self.menu_current.items[i].item setText("Position: " + pos_text);
                }
                break;
            }
        }
    }
    
    wait 0.2;
}

// Función para activar/desactivar fog independientemente de Night Mode
toggle_fog()
{
    // Evitar múltiples activaciones pero permitir una respuesta rápida
    if (isDefined(self.is_toggling_fog))
    {
        wait 0.1; // Pequeña espera si se presiona muy rápido
        return;
    }
    
    self.is_toggling_fog = true;
    
    // Toggle del estado fog_enabled
    self.fog_enabled = !self.fog_enabled;
    
    // Sincronizar con el estado interno de night_mode.gsc
    if (self.fog_enabled)
    {
        // Activar fog - asegurarse que self.fog esté en estado correcto
        if (self.fog == 1)
        {
            // Ya está activado, no hacer nada
        }
        else
    {
        // Activar fog
            self thread scripts\zm\night_mode::fog();
        }
    }
    else
    {
        // Desactivar fog
        if (self.fog == 0)
        {
            // Ya está desactivado, no hacer nada
        }
        else
        {
            // Desactivar fog
            self thread scripts\zm\night_mode::fog();
        }
    }
    
    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        status = self.fog_enabled ? "ON" : "OFF";
        
        // Buscar el elemento de niebla por su texto (más seguro que usar índices)
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_fog)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Niebla: " + status);
                else
                    self.menu_current.items[i].item setText("Fog: " + status);
                break;
            }
        }
    }
    
    // Esperar un tiempo más corto antes de permitir otra activación
    wait 0.2;
    self.is_toggling_fog = undefined;
}

// Funciones para controlar HealthBarZombie
toggle_healthbarzombie()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_toggling_healthbarzombie))
    {
        wait 0.1;
        return;
    }

    // Verificar si hay mods legacy activos y desactivarlos automáticamente
    if (!self.healthbarzombie_enabled && are_legacy_mods_active())
    {
        // Desactivar automáticamente los legacy mods
        legacy_was_disabled = self disable_all_legacy_mods();

        if (legacy_was_disabled)
    {
        // Mostrar mensaje según el idioma
        if (self.langLEN == 0)
        {
                self iPrintlnBold("^3Mods de rendimiento desactivados automáticamente");
                self iPrintlnBold("^2Activando barra de vida zombie...");
        }
        else
        {
                self iPrintlnBold("^3Performance mods disabled automatically");
                self iPrintlnBold("^2Activating zombie health bar...");
        }
            wait 0.2; // Dar tiempo para que se procesen las desactivaciones
        }
    }
    
    // Verificar si hay bordes activos
    if (!self.healthbarzombie_enabled && self.edge_animation_style_index > 0)
    {
        // Mostrar mensaje según el idioma
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra zombie");
            self iPrintlnBold("^1Desactiva los bordes del menú primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable zombie bar");
            self iPrintlnBold("^1Disable menu borders first");
            self playsound("menu_error");
        }
        return;
    }
    
    // Verificar si la barra de vida está activa
    if (!self.healthbarzombie_enabled && self.healthbar_enabled)
    {
        // Mostrar mensaje según el idioma
        if (self.langLEN == 0)
        {
            self iPrintlnBold("^1No se puede activar la barra zombie");
            self iPrintlnBold("^1Desactiva la barra de vida primero");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Cannot enable zombie bar");
            self iPrintlnBold("^1Disable health bar first");
            self playsound("menu_error");
        }
        return;
    }

    
    self.is_toggling_healthbarzombie = true;
    
    // Si vamos a activar la barra zombie y la healthbar está en izquierda, moverla arriba automáticamente
    if (!self.healthbarzombie_enabled && self.healthbar_enabled && self.healthbar_position == "left")
    {
        // Cambiar la posición de la barra de vida a "arriba"
        self.healthbar_position = "top";
        
        // Notificar al usuario del cambio
        if (self.langLEN == 0)
            self iPrintlnBold("^3La barra de vida se ha movido automáticamente a ARRIBA");
        else
            self iPrintlnBold("^3Health bar has been automatically moved to TOP");
        
        // Reconfigurar la barra de vida con la nueva posición
        if (isDefined(self.health_bar))
        {
            self notify("endbar_health");
            wait 0.1; // Esperar un poco para asegurar que la barra anterior se elimine
        }
        
        // Activar la barra en la nueva posición
        self thread bar_funtion_and_toogle(1); // 1 = arriba
        
        // Actualizar el texto del menú si está abierto
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::cycle_healthbar_position)
                {
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Posición: ARRIBA");
                    else
                        self.menu_current.items[i].item setText("Position: TOP");
                    break;
                }
            }
        }
    }
    
    // Cambiar el estado
    self.healthbarzombie_enabled = !self.healthbarzombie_enabled;
    
    if (self.healthbarzombie_enabled)
    {

        // Si aún no se ha seleccionado un color, establecer el predeterminado
        if (!isDefined(self.healthbarzombie_color) || self.healthbarzombie_color == "")
            self.healthbarzombie_color = "default";
            
        // Preparar los parámetros para toggleHealthBar
        shader_enabled = (self.healthbarzombie_shader == "transparent") ? 0 : 1;
        show_name = self.show_zombie_name ? 1 : 0;
        size_height = self.healthbarzombie_sizeh;
        size_width = self.healthbarzombie_sizew;
        size_name = self.healthbarzombie_sizen;
        color_position = self.healthbarzombie_color;
        
        // Activar la barra de zombie llamando a toggleHealthBar con los parámetros correctos
        self thread toggleHealthBar(shader_enabled, show_name, size_height, size_width, size_name, color_position);

    }
    else
    {
        // Desactivar HealthBarZombie usando toggleHealthBar sin parámetros
        self thread toggleHealthBar();
    }
    
    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        // Recorrer todos los elementos y actualizar según corresponda
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            // Actualizar el estado
            if (self.menu_current.items[i].func == ::toggle_healthbarzombie)
            {
                status = self.healthbarzombie_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estado: " + status);
                else
                    self.menu_current.items[i].item setText("Status: " + status);
            }
            // Actualizar visibilidad de las demás opciones
            else if (self.menu_current.items[i].func == ::cycle_healthbarzombie_color ||
                    self.menu_current.items[i].func == ::cycle_healthbarzombie_width ||
                    self.menu_current.items[i].func == ::cycle_healthbarzombie_height ||
                    self.menu_current.items[i].func == ::cycle_healthbarzombie_namesize ||
                    self.menu_current.items[i].func == ::cycle_healthbarzombie_shader ||
                    self.menu_current.items[i].func == ::toggle_zombie_name)
            {
                self.menu_current.items[i].item.alpha = self.healthbarzombie_enabled ? 1 : 0;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_healthbarzombie = undefined;
}

cycle_healthbarzombie_color()
{
    // Lista completa de colores disponibles (correspondiendo con colorbarlist en HealthBarZombie.gsc)
    colors = [];
    colors[0] = "default";    // Blanco (ya no es aleatorio)
    colors[1] = "rojo";       // Rojo
    colors[2] = "verde";      // Verde
    colors[3] = "azul";       // Azul
    colors[4] = "amarillo";   // Amarillo
    colors[5] = "magenta";    // Magenta
    colors[6] = "cian";       // Cian
    colors[7] = "blanco";     // Blanco
    colors[8] = "negro";      // Negro
    colors[9] = "rojoosc";    // Rojo oscuro
    colors[10] = "verdeosc";  // Verde oscuro
    colors[11] = "azulosc";   // Azul oscuro
    colors[12] = "amarilloosc"; // Amarillo oscuro
    colors[13] = "magentaosc"; // Magenta oscuro
    colors[14] = "cianosc";   // Cian oscuro
    colors[15] = "grisclaro"; // Gris claro
    colors[16] = "grisosc";   // Gris oscuro
    colors[17] = "naranja";   // Naranja
    colors[18] = "marron";    // Marrón
    colors[19] = "rosa";      // Rosa claro
    colors[20] = "purpura";   // Púrpura oscuro
    colors[21] = "verdeclaro"; // Verde claro
    
    // Encontrar el índice actual
    current_index = 0;
    for (i = 0; i < colors.size; i++)
    {
        if (colors[i] == self.healthbarzombie_color)
        {
            current_index = i;
            break;
        }
    }
    
    // Avanzar al siguiente color
    current_index = (current_index + 1) % colors.size;
    self.healthbarzombie_color = colors[current_index];
    
    // Mostrar mensaje según el idioma
    color_display_name = self.healthbarzombie_color;
    if (self.langLEN == 0) // Español
    {
        // Ya tenemos nombres en español, usar directamente
        // Pero cambiar "default" por "blanco (predeterminado)"
        if (color_display_name == "default")
            color_display_name = "blanco (predeterminado)";
    }
    else // Inglés
    {
        // Traducir nombres al inglés para el mensaje
        switch(self.healthbarzombie_color)
        {
            case "default": color_display_name = "white (default)"; break;
            case "rojo": color_display_name = "red"; break;
            case "verde": color_display_name = "green"; break;
            case "azul": color_display_name = "blue"; break;
            case "amarillo": color_display_name = "yellow"; break;
            case "magenta": color_display_name = "magenta"; break;
            case "cian": color_display_name = "cyan"; break;
            case "blanco": color_display_name = "white"; break;
            case "negro": color_display_name = "black"; break;
            case "rojoosc": color_display_name = "dark red"; break;
            case "verdeosc": color_display_name = "dark green"; break;
            case "azulosc": color_display_name = "dark blue"; break;
            case "amarilloosc": color_display_name = "dark yellow"; break;
            case "magentaosc": color_display_name = "dark magenta"; break;
            case "cianosc": color_display_name = "dark cyan"; break;
            case "grisclaro": color_display_name = "light gray"; break;
            case "grisosc": color_display_name = "dark gray"; break;
            case "naranja": color_display_name = "orange"; break;
            case "marron": color_display_name = "brown"; break;
            case "rosa": color_display_name = "pink"; break;
            case "purpura": color_display_name = "purple"; break;
            case "verdeclaro":             color_display_name = "light green"; break;
        }
    }
    
    // Si la barra está activada, aplicar el color directamente sin recrear la barra
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health))
    {
        // Detener cualquier hilo de color anterior
        self notify("end_colorBAR");
        
        // Mapear strings de colores a índices correspondientes a colorbarlist en HealthBarZombie.gsc
        color_index = 7; // Por defecto, blanco (índice 7)
        
        switch(self.healthbarzombie_color)
        {
            case "rojo": color_index = 1; break;           // (1, 0, 0)
            case "verde": color_index = 2; break;          // (0, 1, 0)
            case "azul": color_index = 3; break;           // (0, 0, 1)
            case "amarillo": color_index = 4; break;       // (1, 1, 0)
            case "magenta": color_index = 5; break;        // (1, 0, 1)
            case "cian": color_index = 6; break;           // (0, 1, 1)
            case "blanco": color_index = 7; break;         // (1, 1, 1)
            case "negro": color_index = 8; break;          // (0, 0, 0)
            case "rojoosc": color_index = 9; break;        // (0.5, 0, 0)
            case "verdeosc": color_index = 10; break;      // (0, 0.5, 0)
            case "azulosc": color_index = 11; break;       // (0, 0, 0.5)
            case "amarilloosc": color_index = 12; break;   // (0.5, 0.5, 0)
            case "magentaosc": color_index = 13; break;    // (0.5, 0, 0.5)
            case "cianosc": color_index = 14; break;       // (0, 0.5, 0.5)
            case "grisclaro": color_index = 15; break;     // (0.75, 0.75, 0.75)
            case "grisosc": color_index = 16; break;       // (0.25, 0.25, 0.25)
            case "naranja": color_index = 17; break;       // (1, 0.5, 0)
            case "marron": color_index = 18; break;        // (0.5, 0.25, 0)
            case "rosa": color_index = 19; break;          // (1, 0.75, 0.8)
            case "purpura": color_index = 20; break;       // (0.5, 0, 0.25)
            case "verdeclaro": color_index = 21; break;    // (0.5, 1, 0.5)
            default: color_index = 7; break;               // Default es blanco (1, 1, 1)
        }
        
        // Iniciar hilo de color con el índice correspondiente
        self thread colorBAR(color_index);
    }
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_color)
            {
                // Mostrar nombre adaptado al idioma en el menú
                if (self.langLEN == 0) // Español
                    self.menu_current.items[i].item setText("Color: " + color_display_name);
                else // Inglés
                    self.menu_current.items[i].item setText("Color: " + color_display_name);
                break;
            }
        }
    }
    
    wait 0.2;
}

cycle_healthbarzombie_width()
{
    // Incrementar el ancho en pasos de 10
    self.healthbarzombie_sizew += 10;
    
    // Si excede el máximo, volver al mínimo
    if (self.healthbarzombie_sizew > 150)
        self.healthbarzombie_sizew = 100;
    
    // Actualizar la variable que usa HealthBarZombie
    self.sizeW = self.healthbarzombie_sizew;
    
    
    // Si la barra está activada, actualizar directamente su ancho
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health))
    {
        self.hud_zombie_health.width = self.sizeW;
        if (isDefined(self.hud_zombie_health.bar))
            self.hud_zombie_health.bar.width = self.sizeW;
    }
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_width)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Ancho: " + self.healthbarzombie_sizew);
                else
                    self.menu_current.items[i].item setText("Width: " + self.healthbarzombie_sizew);
                break;
            }
        }
    }
    
    wait 0.2;
}

cycle_healthbarzombie_height()
{
    // Incrementar la altura en pasos de 1
    self.healthbarzombie_sizeh += 1;
    
    // Si excede el máximo, volver al mínimo
    if (self.healthbarzombie_sizeh > 10)
        self.healthbarzombie_sizeh = 1;
    
    // Actualizar la variable que usa HealthBarZombie
    self.sizeH = self.healthbarzombie_sizeh;
    
    
    // Si la barra está activada, actualizar directamente su altura
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health))
    {
        self.hud_zombie_health.height = self.sizeH;
    }
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_height)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Alto: " + self.healthbarzombie_sizeh);
                else
                    self.menu_current.items[i].item setText("Height: " + self.healthbarzombie_sizeh);
                break;
            }
        }
    }
    
    wait 0.2;
}

cycle_healthbarzombie_namesize()
{
    // Incrementar el tamaño del nombre en pasos de 0.1
    self.healthbarzombie_sizen = int(self.healthbarzombie_sizen * 10 + 1) / 10; // Para evitar errores de punto flotante
    
    // Si excede el máximo, volver al mínimo
    if (self.healthbarzombie_sizen > 1.9)
        self.healthbarzombie_sizen = 1.0;
    
    // Actualizar la variable que usa HealthBarZombie
    self.sizeN = self.healthbarzombie_sizen;
    
    
    // Si la barra existe, actualizar directamente el tamaño del texto
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health_text))
    {
        self.hud_zombie_health_text.fontScale = self.sizeN;
    }
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_namesize)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Tamaño Nombre: " + self.healthbarzombie_sizen);
                else
                    self.menu_current.items[i].item setText("Name Size: " + self.healthbarzombie_sizen);
                break;
            }
        }
    }
    
    wait 0.2;
}

cycle_healthbarzombie_shader()
{
    // Lista simplificada de shaders disponibles (solo solid y transparent)
    shaders = [];
    shaders[0] = "transparent";
    shaders[1] = "solid";
    
    // Encontrar el índice actual
    current_index = 0;
    for (i = 0; i < shaders.size; i++)
    {
        if (shaders[i] == self.healthbarzombie_shader)
        {
            current_index = i;
            break;
        }
    }
    
    // Avanzar al siguiente shader (simplemente alternar entre 0 y 1)
    current_index = (current_index + 1) % shaders.size;
    self.healthbarzombie_shader = shaders[current_index];
    
    // Actualizar la variable que usa HealthBarZombie
    if (self.healthbarzombie_shader == "transparent")
        self.shaderON = 0;
    else // solid
        self.shaderON = 1;
    
    
    // Si la barra existe, actualizar directamente su transparencia
    if (self.healthbarzombie_enabled && isDefined(self.hud_zombie_health))
    {
        self.hud_zombie_health.alpha = self.shaderON;
    }
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_healthbarzombie_shader)
            {
                self.menu_current.items[i].item setText("Shader: " + self.healthbarzombie_shader);
                break;
            }
        }
    }
    
    wait 0.2;
}

// Añadir función para alternar la visualización del nombre del zombie
toggle_zombie_name()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_toggling_zombie_name))
    {
        wait 0.1;
        return;
    }
    
    self.is_toggling_zombie_name = true;
    
    // Alternar entre mostrar y ocultar nombre
    self.show_zombie_name = !self.show_zombie_name;
    
    // Aplicar el cambio a la variable que usa HealthBarZombie.gsc
    self.zombieNAME = self.show_zombie_name ? 1 : 0;
    
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_zombie_name)
            {
                zombieNameStatus = self.show_zombie_name ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Mostrar Nombre: " + zombieNameStatus);
                else
                    self.menu_current.items[i].item setText("Show Name: " + zombieNameStatus);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_zombie_name = undefined;
}

// Nueva función para alternar el idioma
toggle_language()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_toggling_language))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_language = true;

    // Alternar entre español e inglés
    self.langLEN = (self.langLEN == 0) ? 1 : 0;

    // Actualizar textos del menú en tiempo real
    self update_settings_menu_texts();

    // Esperar un tiempo antes de permitir otra activación
    wait 0.5;
    self.is_toggling_language = undefined;
}

// Función para actualizar textos del menú settings en tiempo real
update_settings_menu_texts()
{
    // Solo actualizar si estamos en el menú de settings
    if (!isDefined(self.menu_current) || !isDefined(self.menu_current.title))
        return;

    // Verificar si es el menú de settings
    menu_title = self.menu_current.title;
    if (menu_title != "CONFIGURACIÓN" && menu_title != "SETTINGS")
        return;

    // Actualizar el título del menú según el idioma actual
    new_title = (self.langLEN == 0) ? "CONFIGURACIÓN" : "SETTINGS";
    self.menu_current.title = new_title;

    // Actualizar el elemento de texto del título si existe
    if (isDefined(self.menu_current.title_text))
    {
        self.menu_current.title_text setText(new_title);
    }

    // Actualizar la sombra del título si existe
    if (isDefined(self.menu_current.title_shadow))
    {
        self.menu_current.title_shadow setText(new_title);
    }

    // Actualizar cada item del menú según el idioma actual
    if (self.langLEN == 0) // Español
    {
        // Item 0: Idioma
        if (isDefined(self.menu_current.items[0]))
        {
            lang = (self.langLEN == 0) ? "Español" : "Inglés";
            self.menu_current.items[0].item setText("Idioma: " + lang);
        }

        // Item 1: Estilo Menú
        if (isDefined(self.menu_current.items[1]))
        {
            styleName = get_style_name(self.menu_style_index, self.langLEN);
            self.menu_current.items[1].item setText("Estilo Menú: " + styleName);
        }

        // Item 2: Estilo Selector
        if (isDefined(self.menu_current.items[2]))
        {
            selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
            self.menu_current.items[2].item setText("Estilo Selector: " + selectorStyleName);
        }

        // Item 3: Posición Texto
        if (isDefined(self.menu_current.items[3]))
        {
            fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
            self.menu_current.items[3].item setText("Posición Texto: " + fontPositionName);
        }

        // Item 4: Animación Borde
        if (isDefined(self.menu_current.items[4]))
        {
            edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
            self.menu_current.items[4].item setText("Animación Borde: " + edgeAnimStyleName);
        }

        // Item 5: Animación Fuente
        if (isDefined(self.menu_current.items[5]))
        {
            fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
            self.menu_current.items[5].item setText("Animación Fuente: " + fontAnimName);
        }

        // Item 6: Transparencia
        if (isDefined(self.menu_current.items[6]))
        {
            transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
            self.menu_current.items[6].item setText(transparencyName);
        }

        // Item 7: Sonidos
        if (isDefined(self.menu_current.items[7]))
        {
            self.menu_current.items[7].item setText("Sonidos");
        }

        // Item 8: Guardar Configuración
        if (isDefined(self.menu_current.items[8]))
        {
            self.menu_current.items[8].item setText("Guardar Configuración");
        }

        // Items restantes: Volver y Cerrar Menú
        if (isDefined(self.menu_current.items[9]))
            self.menu_current.items[9].item setText("Volver");
        if (isDefined(self.menu_current.items[10]))
            self.menu_current.items[10].item setText("Cerrar Menú");
    }
    else // Inglés
    {
        // Item 0: Language
        if (isDefined(self.menu_current.items[0]))
        {
            lang = (self.langLEN == 0) ? "Spanish" : "English";
            self.menu_current.items[0].item setText("Language: " + lang);
        }

        // Item 1: Menu Style
        if (isDefined(self.menu_current.items[1]))
        {
            styleName = get_style_name(self.menu_style_index, self.langLEN);
            self.menu_current.items[1].item setText("Menu Style: " + styleName);
        }

        // Item 2: Selector Style
        if (isDefined(self.menu_current.items[2]))
        {
            selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
            self.menu_current.items[2].item setText("Selector Style: " + selectorStyleName);
        }

        // Item 3: Text Position
        if (isDefined(self.menu_current.items[3]))
        {
            fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
            self.menu_current.items[3].item setText("Text Position: " + fontPositionName);
        }

        // Item 4: Edge Animation
        if (isDefined(self.menu_current.items[4]))
        {
            edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
            self.menu_current.items[4].item setText("Edge Animation: " + edgeAnimStyleName);
        }

        // Item 5: Font Animation
        if (isDefined(self.menu_current.items[5]))
        {
            fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
            self.menu_current.items[5].item setText("Font Animation: " + fontAnimName);
        }

        // Item 6: Transparency
        if (isDefined(self.menu_current.items[6]))
        {
            transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
            self.menu_current.items[6].item setText(transparencyName);
        }

        // Item 7: Sound
        if (isDefined(self.menu_current.items[7]))
        {
            self.menu_current.items[7].item setText("Sound");
        }

        // Item 8: Save Configuration
        if (isDefined(self.menu_current.items[8]))
        {
            self.menu_current.items[8].item setText("Save Configuration");
        }

        // Items restantes: Back y Close Menu
        if (isDefined(self.menu_current.items[9]))
            self.menu_current.items[9].item setText("Back");
        if (isDefined(self.menu_current.items[10]))
            self.menu_current.items[10].item setText("Close Menu");
    }
}

// Función personalizada para configurar la barra
custom_configbar()
{
    self endon("disconnect");
    self endon("end_configbar");
    level endon("end_game");
    
    // Configurar los valores inmediatamente
    if (isDefined(self.hud_zombie_health))
    {
        self.hud_zombie_health.width = self.sizeW;
        self.hud_zombie_health.height = self.sizeH;
        
        if (isDefined(self.hud_zombie_health.bar))
        {
            self.hud_zombie_health.bar.width = self.sizeW;
        }
        
        if (isDefined(self.hud_zombie_health_text))
        {
            self.hud_zombie_health_text.fontScale = self.sizeN;
        }
        
        self.hud_zombie_health.alpha = self.shaderON;
    }
    
    // Bucle para mantener la configuración
    while(true)
    {
        // En caso de que la barra se regenere o cambie
        if (isDefined(self.hud_zombie_health))
        {
            self.hud_zombie_health.width = self.sizeW;
            self.hud_zombie_health.height = self.sizeH;
            
            if (isDefined(self.hud_zombie_health.bar))
            {
                self.hud_zombie_health.bar.width = self.sizeW;
            }
            
            if (isDefined(self.hud_zombie_health_text))
            {
                self.hud_zombie_health_text.fontScale = self.sizeN;
            }
            
            self.hud_zombie_health.alpha = self.shaderON;
        }
        
        wait 0.5;
    }
}

// Nueva función para abrir el menú de configuración
open_settings_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    // Cerrar el menú anterior pero mantener referencia al menú principal
    self notify("destroy_current_menu");
    wait 0.1;
    
    // Crear submenú de configuración con título según idioma
    title = (self.langLEN == 0) ? "CONFIGURACIÓN" : "SETTINGS";
    menu = create_menu(title, self);
    menu.parent_menu = "main"; // Para saber a qué menú volver
    
    // Verificar el estado de God Mode para la disponibilidad de cambio de rondas
    godmode_enabled = self.godmode_enabled;
    
    // Inicializar la ronda objetivo si no existe
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;
    
    // Inicializar el índice de posición de texto si no existe
    if(!isDefined(self.font_position_index))
        self.font_position_index = 0;

    // Inicializar el índice de estilo de selector si no existe (Border Pulse por defecto)
    if(!isDefined(self.selector_style_index))
        self.selector_style_index = 14;

    // Inicializar el índice de animación de fuente si no existe (Giro por defecto)
    if(!isDefined(self.font_animation_index))
        self.font_animation_index = 5;

    // Inicializar índices de sonidos del menú
    if(!isDefined(self.menu_open_sound_index))
        self.menu_open_sound_index = 1; // fly_rgunmk2_magin por defecto

    if(!isDefined(self.menu_close_sound_index))
        self.menu_close_sound_index = 1; // fly_rgunmk2_magout por defecto

    if(!isDefined(self.menu_scroll_sound_index))
        self.menu_scroll_sound_index = 1; // uin_main_nav por defecto

    if(!isDefined(self.menu_select_sound_index))
        self.menu_select_sound_index = 2; // uin_main_enter por defecto

    // Añadir opciones al menú con textos según el idioma
    if (self.langLEN == 0) // Español
    {
        // Opción para cambiar idioma
        lang = (self.langLEN == 0) ? "Español" : "Inglés";
        add_menu_item(menu, "Idioma: " + lang, ::toggle_language);
        
        // Opción para cambiar estilo del menú
        styleName = get_style_name(self.menu_style_index, self.langLEN);
        add_menu_item(menu, "Estilo Menú: " + styleName, ::cycle_menu_style);
        
        // Opción para cambiar estilo del selector
        selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
        add_menu_item(menu, "Estilo Selector: " + selectorStyleName, ::cycle_selector_style);
        
        // Opción para cambiar posición del texto
        fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
        add_menu_item(menu, "Posición Texto: " + fontPositionName, scripts\zm\style_font_position::cycle_font_position);
        
        // Nueva opción para cambiar animación de borde
        edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
        add_menu_item(menu, "Animación Borde: " + edgeAnimStyleName, ::cycle_edge_animation_style);

        // Nueva opción para cambiar animación de fuente
        fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
        add_menu_item(menu, "Animación Fuente: " + fontAnimName, ::cycle_font_animation);
        
        // Opción para cambiar nivel de transparencia
        transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
        add_menu_item(menu, transparencyName, ::cycle_transparency);

        // Nueva opción para menú de sonidos
        add_menu_item(menu, "Sonidos", ::open_sound_settings_menu);

        // Nueva opción para guardar configuración del menú
        add_menu_item(menu, "Guardar Configuración", ::save_menu_configuration);


        /*// Opción para activar/desactivar God Mode
        godmode_status = self.godmode_enabled ? "ON" : "OFF";
        add_menu_item(menu, "God Mode: " + godmode_status, scripts\zm\funciones::toggle_godmode);

        // Nuevas opciones para cambiar rondas
        advance_round_item = add_menu_item(menu, "Avanzar Ronda", scripts\zm\funciones::advance_round);
        goback_round_item = add_menu_item(menu, "Retroceder Ronda", scripts\zm\funciones::go_back_round);

        // Nuevo botón para aplicar el cambio de ronda
        apply_round_item = add_menu_item(menu, "Aplicar Ronda: " + self.target_round, scripts\zm\funciones::apply_round_change);

        // Colorear rojo si God Mode está desactivado
        if (!godmode_enabled)
        {
            advance_round_item.item.color = (1, 0.2, 0.2); // Rojo
            goback_round_item.item.color = (1, 0.2, 0.2); // Rojo
            apply_round_item.item.color = (1, 0.2, 0.2); // Rojo
        }*/

        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Opción para cambiar idioma
        lang = (self.langLEN == 0) ? "Spanish" : "English";
        add_menu_item(menu, "Language: " + lang, ::toggle_language);
        
        // Opción para cambiar estilo del menú
        styleName = get_style_name(self.menu_style_index, self.langLEN);
        add_menu_item(menu, "Menu Style: " + styleName, ::cycle_menu_style);
        
        // Opción para cambiar estilo del selector
        selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
        add_menu_item(menu, "Selector Style: " + selectorStyleName, ::cycle_selector_style);
        
        // Opción para cambiar posición del texto
        fontPositionName = scripts\zm\style_font_position::get_font_position_name(self.font_position_index, self.langLEN);
        add_menu_item(menu, "Text Position: " + fontPositionName, scripts\zm\style_font_position::cycle_font_position);
        
        // Nueva opción para cambiar animación de borde
        edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
        add_menu_item(menu, "Edge Animation: " + edgeAnimStyleName, ::cycle_edge_animation_style);

        // Nueva opción para cambiar animación de fuente
        fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);
        add_menu_item(menu, "Font Animation: " + fontAnimName, ::cycle_font_animation);
        
        // Opción para cambiar nivel de transparencia
        transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
        add_menu_item(menu, transparencyName, ::cycle_transparency);

        // Nueva opción para menú de sonidos
        add_menu_item(menu, "Sound", ::open_sound_settings_menu);

        // Nueva opción para guardar configuración del menú
        add_menu_item(menu, "Save Configuration", ::save_menu_configuration);


        /*// Opción para activar/desactivar God Mode
        godmode_status = self.godmode_enabled ? "ON" : "OFF";
        add_menu_item(menu, "God Mode: " + godmode_status, scripts\zm\funciones::toggle_godmode);

        // Nuevas opciones para cambiar rondas
        advance_round_item = add_menu_item(menu, "Advance Round", scripts\zm\funciones::advance_round);
        goback_round_item = add_menu_item(menu, "Go Back Round", scripts\zm\funciones::go_back_round);

        // Nuevo botón para aplicar el cambio de ronda
        apply_round_item = add_menu_item(menu, "Apply Round: " + self.target_round, scripts\zm\funciones::apply_round_change);

        // Colorear rojo si God Mode está desactivado
        if (!godmode_enabled)
        {
            advance_round_item.item.color = (1, 0.2, 0.2); // Rojo
            goback_round_item.item.color = (1, 0.2, 0.2); // Rojo
            apply_round_item.item.color = (1, 0.2, 0.2); // Rojo
        }*/

        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    // Mostrar menú y controlar la navegación
    show_menu(menu);
    
    // Mantener la selección actual si existe
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        // Actualizar el color del elemento seleccionado a blanco para mantener consistencia
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Función para abrir el menú de créditos
open_credits_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    // Cerrar el menú anterior pero mantener referencia al menú principal
    self notify("destroy_current_menu");
    wait 0.1;
    
    // Crear submenú de créditos con título según idioma
    title = (self.langLEN == 0) ? "CRÉDITOS" : "CREDITS";
    menu = create_menu(title, self);
    menu.parent_menu = "main"; // Para saber a qué menú volver
    
    // Añadir información de créditos como elementos no interactivos
    if (self.langLEN == 0) // Español
    {
        add_menu_item(menu, "^6━━━━━━━━━━━━━━━━━━━━━━", undefined);
        add_menu_item(menu, "^2Desarrollado por:", undefined);
        add_menu_item(menu, "^3LittleGods", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "^2Discord:", undefined);
        add_menu_item(menu, "^5dsc.gg/littlegods", undefined);
        add_menu_item(menu, "^6━━━━━━━━━━━━━━━━━━━━━━", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "^7Gracias por usar este menú!", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "Volver", ::menu_go_back);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        add_menu_item(menu, "^6━━━━━━━━━━━━━━━━━━━━━━", undefined);
        add_menu_item(menu, "^2Developed by:", undefined);
        add_menu_item(menu, "^3LittleGods", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "^2Discord:", undefined);
        add_menu_item(menu, "^5dsc.gg/littlegods", undefined);
        add_menu_item(menu, "^6━━━━━━━━━━━━━━━━━━━━━━", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "^7Thanks for using this menu!", undefined);
        add_menu_item(menu, "", undefined);
        add_menu_item(menu, "Back", ::menu_go_back);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    // Mostrar menú y controlar la navegación
    show_menu(menu);
    
    // Aplicar posición de texto actual
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    // Mantener la selección actual si existe
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        // Actualizar el color del elemento seleccionado a blanco para mantener consistencia
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Función para abrir el menú de Mapa
open_map_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    // Cerrar el menú anterior pero mantener referencia al menú principal
    self notify("destroy_current_menu");
    wait 0.1;


    // Crear submenú de Mapa con título según idioma
    title = (self.langLEN == 0) ? "MAPA" : "MAP";
    menu = create_menu(title, self);
    menu.parent_menu = "main"; // Para saber a qué menú volver
    
    // Inicializar el estado de perk unlimited si no existe
    if (!isDefined(self.perk_unlimite_active))
        self.perk_unlimite_active = false;
    
    // Inicializar el estado de tercera persona si no existe
    if (!isDefined(self.TPP))
        self.TPP = false;

    
    // Añadir opciones al menú con textos según el idioma
    if (self.langLEN == 0) // Español
    {
        // Opción para activar/desactivar Perk Unlimited
        perk_status = self.perk_unlimite_active ? "ON" : "OFF";
        add_menu_item(menu, "Perk Unlimited: " + perk_status, scripts\zm\funciones::toggle_perk_unlimite);
        
        // Opción para activar/desactivar Tercera Persona
        thirdperson_status = self.TPP ? "ON" : "OFF";
        add_menu_item(menu, "Tercera Persona: " + thirdperson_status, scripts\zm\funciones::ThirdPerson);

        // Opción de banco (solo si developer no está activado)
        if (!self.developer_mode_unlocked)
            add_menu_item(menu, "Banco", ::open_bank_menu);

        // Opción para guardar configuración del Map
        add_menu_item(menu, "Guardar Configuración", ::save_map_configuration);

        add_menu_item(menu, "Volver", ::menu_go_back_to_main);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Opción para activar/desactivar Perk Unlimited
        perk_status = self.perk_unlimite_active ? "ON" : "OFF";
        add_menu_item(menu, "Perk Unlimited: " + perk_status, scripts\zm\funciones::toggle_perk_unlimite);
        
        // Opción para activar/desactivar Tercera Persona
        thirdperson_status = self.TPP ? "ON" : "OFF";
        add_menu_item(menu, "Third Person: " + thirdperson_status, scripts\zm\funciones::ThirdPerson);


        // Bank option (only if developer is not activated)
        if (!self.developer_mode_unlocked)
            add_menu_item(menu, "Bank", ::open_bank_menu);

        // Opción para guardar configuración del Map
        add_menu_item(menu, "Save Configuration", ::save_map_configuration);

        add_menu_item(menu, "Back", ::menu_go_back_to_main);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    // Mostrar menú y controlar la navegación
    show_menu(menu);


    // Aplicar posición de texto actual
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    // Mantener la selección actual si existe
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;

        // Actualizar el color del elemento seleccionado a blanco para mantener consistencia
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}




// Función para activar/desactivar la visualización de timers


// Función para abrir el menú de Developer
open_developer_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    // Cerrar el menú anterior pero mantener referencia al menú principal
    self notify("destroy_current_menu");
    wait 0.1;
    
    // Crear submenú de Developer con título según idioma
    title = (self.langLEN == 0) ? "DEVELOPER" : "DEVELOPER";
    menu = create_menu(title, self);
    menu.parent_menu = "main"; // Para saber a qué menú volver
    
    // Inicializar la ronda objetivo si no existe
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;
    
    // Detectar el mapa actual
    map = getDvar("ui_zm_mapstartlocation");
    
    // Añadir opciones al menú con textos según el idioma
    if (self.langLEN == 0) // Español
    {
        // Submenús organizados
        add_menu_item(menu, "Jugador", ::open_player_menu);
        add_menu_item(menu, "Zombie", ::open_zombie_menu);

        add_menu_item(menu, "Volver", ::menu_go_back_to_main);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Organized submenus
        add_menu_item(menu, "Player", ::open_player_menu);
        add_menu_item(menu, "Zombie", ::open_zombie_menu);

        add_menu_item(menu, "Back", ::menu_go_back_to_main);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    // Mostrar menú y controlar la navegación
    show_menu(menu);
    
    // Aplicar posición de texto actual
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    // Mantener la selección actual si existe
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        // Actualizar el color del elemento seleccionado a blanco para mantener consistencia
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Función para solicitar contraseña de developer
request_developer_password()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    // Cerrar todos los menús
    self thread close_all_menus();
    wait 0.2;
    
    // Crear HUD para mostrar el mensaje
    self.password_hud = newClientHudElem(self);
    self.password_hud.horzalign = "center";
    self.password_hud.vertalign = "middle";
    self.password_hud.alignX = "center";
    self.password_hud.alignY = "middle";
    self.password_hud.x = 0;
    self.password_hud.y = 0;
    self.password_hud.fontScale = 1.5;
    self.password_hud.alpha = 1;
    self.password_hud.color = (1, 1, 0); // Amarillo
    self.password_hud.hidewheninmenu = false;

    if (self.langLEN == 0) // Español
        self.password_hud setText("^3Escriba ^2'admin' ^3en el chat para desbloquear");
    else // Inglés
        self.password_hud setText("^3Type ^2'admin' ^3in chat to unlock");

    // Esperar 5 segundos antes de destruir el mensaje
    wait 5;

    if (isDefined(self.password_hud))
    {
        self.password_hud destroy();
        self.password_hud = undefined;
    }
}

// Nueva función para ciclar entre los niveles de transparencia del menú
cycle_transparency()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_transparency))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_transparency = true;
    
    // Incrementar el índice de transparencia
    self.transparency_index += 1;
    
    // Si excede el máximo, volver a 0
    maxLevels = level.transparency_levels.size;
    if (self.transparency_index >= maxLevels)
        self.transparency_index = 0;
    
    // Aplicar el nuevo nivel de transparencia al menú actual
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_transparecy::apply_transparency(self.menu_current, self.transparency_index);
    }
    
    // Obtener el nombre del nivel para mostrar
    transparencyName = scripts\zm\style_transparecy::get_transparency_name(self.transparency_index, self.langLEN);
    
    // Extraer el porcentaje para el mensaje (sin los caracteres problemáticos)
    percentage = level.transparency_levels[self.transparency_index];
    
    
    // Actualizar el texto del ítem en el menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
                    if (self.menu_current.items[i].func == ::cycle_transparency)
              {
                  // Para escapar el símbolo %, usamos %% en string::format
                  transparency_text = "";
                  if (self.langLEN == 0)
                      transparency_text = "Transparencia: " + int(level.transparency_levels[self.transparency_index]) + "%%";
                  else
                      transparency_text = "Transparency: " + int(level.transparency_levels[self.transparency_index]) + "%%";
                      
                  self.menu_current.items[i].item setText(transparency_text);
                  break;
              }
        }
    }
    
    wait 0.2;
    self.is_cycling_transparency = undefined;
}

// Función para guardar la configuración del menú
save_menu_configuration()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_saving_config))
    {
        wait 0.1;
        return;
    }

    self.is_saving_config = true;

    // Llamar a la función de sqllocal para guardar SOLO settings
    success = scripts\zm\sqllocal::save_settings_only(self);

    if (success)
    {
        // Mostrar mensaje de éxito
        if (self.langLEN == 0)
            self iPrintLnBold("^2Configuración de Settings guardada");
        else
            self iPrintLnBold("^2Settings configuration saved");
    }
    else
    {
        // Mostrar mensaje de error
        if (self.langLEN == 0)
            self iPrintLnBold("^1Error al guardar configuración");
        else
            self iPrintLnBold("^1Error saving configuration");
    }

    wait 0.5;
    self.is_saving_config = undefined;
}

save_nightmode_configuration()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_saving_nightmode))
    {
        wait 0.1;
        return;
    }

    self.is_saving_nightmode = true;

    // Llamar a la función de sqllocal para guardar SOLO nightmode
    success = scripts\zm\sqllocal::save_nightmode_only(self);

    if (success)
    {
        // Mostrar mensaje de éxito
        if (self.langLEN == 0)
            self iPrintLnBold("^2Configuración de Night Mode guardada");
        else
            self iPrintLnBold("^2Night Mode configuration saved");
    }
    else
    {
        // Mostrar mensaje de error
        if (self.langLEN == 0)
            self iPrintLnBold("^1Error al guardar configuración");
        else
            self iPrintLnBold("^1Error saving configuration");
    }

    wait 0.5;
    self.is_saving_nightmode = undefined;
}

save_map_configuration()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_saving_map))
    {
        wait 0.1;
        return;
    }

    self.is_saving_map = true;

    // Llamar a la función de sqllocal para guardar SOLO map
    success = scripts\zm\sqllocal::save_map_only(self);

    if (success)
    {
        // Mostrar mensaje de éxito
        if (self.langLEN == 0)
            self iPrintLnBold("^2Configuración de Map guardada");
        else
            self iPrintLnBold("^2Map configuration saved");
    }
    else
    {
        // Mostrar mensaje de error
        if (self.langLEN == 0)
            self iPrintLnBold("^1Error al guardar configuración");
        else
            self iPrintLnBold("^1Error saving configuration");
    }

    wait 0.5;
    self.is_saving_map = undefined;
}


get_menu_color_by_index(index)
{
    // Siempre devolver azul claro independientemente del índice
    return (0.4, 0.7, 1); // Azul claro fijo para todos los menús
}

// Función auxiliar para obtener el nombre del color según el índice y el idioma
get_menu_color_name(lang_index)
{
    // Siempre devuelve el mismo nombre, independientemente del índice de color
    return (lang_index == 0) ? "Azul" : "Blue";
}
// Nueva función para ciclar entre los estilos de menú disponibles
cycle_menu_style()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_menu_style))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_menu_style = true;
    
    // Detener cualquier efecto arcoíris activo - llamar directamente sin style_menu::
    if (isDefined(self.menu_current.rainbow_active) && self.menu_current.rainbow_active)
    {
        stop_rainbow_effect(self.menu_current);
    }
    
    // Incrementar el índice de estilo
    self.menu_style_index += 1;
    
    // Si excede el máximo, volver a 0 (obtener el tamaño total de estilos disponibles)
    maxStyles = level.menu_styles.size;
    if (self.menu_style_index >= maxStyles)
        self.menu_style_index = 0;
    
    // Aplicar el nuevo estilo al menú actual - llamar directamente sin style_menu::
    if (isDefined(self.menu_current))
    {
        // Guardar los valores de la animación de borde actual antes de cambiar el estilo
        edge_animation_active = false;
        edge_animation_style_index = 0;
        
        if (isDefined(self.menu_current.edge_animation_active))
            edge_animation_active = self.menu_current.edge_animation_active;
            
        if (isDefined(self.edge_animation_style_index))
            edge_animation_style_index = self.edge_animation_style_index;
            
        // Aplicar el nuevo estilo al menú
        self.menu_current = apply_menu_style(self.menu_current, self.menu_style_index);
        
        // Forzar la actualización del selector después de cambiar el estilo del menú
        if (isDefined(self.selector_style_index))
        {
            self.menu_current = scripts\zm\style_selector::apply_selector_style(self.menu_current, self.selector_style_index);
            scripts\zm\style_selector::update_selector_visuals(self.menu_current);
            scripts\zm\style_selector::update_selector_position(self.menu_current);
        }
        
        // Esperar un frame para que el menú se actualice completamente
        wait 0.05;
        
        // Actualizar la altura real del menú para que los bordes se posicionen correctamente
        self.menu_current.height = self.menu_current.header_height + 
                                  (self.menu_current.item_height * self.menu_current.items.size);
        
        // Actualizar la animación de borde con el nuevo tamaño del menú
        if (edge_animation_active && edge_animation_style_index > 0)
        {
            // Transferir la información de estilo de animación al nuevo menú
            self.menu_current.edge_animation_style_index = edge_animation_style_index;
            
            // Primero limpiar cualquier animación existente
            scripts\zm\style_edge_animation::clear_existing_edge_animation(self.menu_current);
            
            // Usar la función de actualización para reajustar la animación al nuevo tamaño
            // Pasar true para forzar la recreación completa de la animación
            self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, edge_animation_style_index);
        }
    }
    
    // Obtener el nombre del estilo para mostrar - llamar directamente sin style_menu::
    styleName = get_style_name(self.menu_style_index, self.langLEN);
    
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_style)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estilo Menú: " + styleName);
                else
                    self.menu_current.items[i].item setText("Menu Style: " + styleName);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_cycling_menu_style = undefined;
}

// Nueva función para ciclar entre los estilos de selector disponibles
cycle_selector_style()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_selector_style))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_selector_style = true;
    
    // Detener cualquier efecto de selector activo
    if (isDefined(self.menu_current.selector_effect_active) && self.menu_current.selector_effect_active)
    {
        self.menu_current.selector_effect_active = false;
        self.menu_current notify("stop_selector_effect");
    }
    
    // Incrementar el índice de estilo de selector
    self.selector_style_index += 1;
    
    // Si excede el máximo, volver a 0
    maxSelectorStyles = level.selector_styles.size;
    if (self.selector_style_index >= maxSelectorStyles)
        self.selector_style_index = 0;
    
    // Aplicar el nuevo estilo de selector al menú actual
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_selector::apply_selector_style(self.menu_current, self.selector_style_index);
        
        // Forzar actualización visual inmediata
        scripts\zm\style_selector::update_selector_visuals(self.menu_current);
        scripts\zm\style_selector::update_selector_position(self.menu_current);
    }
    
    // Obtener el nombre del estilo para mostrar
    selectorStyleName = scripts\zm\style_selector::get_selector_style_name(self.selector_style_index, self.langLEN);
    
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_selector_style)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Estilo Selector: " + selectorStyleName);
                else
                    self.menu_current.items[i].item setText("Selector Style: " + selectorStyleName);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_cycling_selector_style = undefined;
}

// Nueva función para ciclar entre los estilos de animación de borde
cycle_font_animation()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_font_animation))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_font_animation = true;

    // Incrementar el índice de animación de fuente
    self.font_animation_index += 1;

    // Si excede el máximo, volver a 0 (8 animaciones disponibles)
    if (self.font_animation_index >= 8)
        self.font_animation_index = 0;

    // Aplicar la nueva animación de fuente al menú actual
    if (isDefined(self.menu_current))
    {
        scripts\zm\style_font_animation::apply_font_animation(self.menu_current, self.font_animation_index);
    }

    // Obtener el nombre de la animación para mostrar
    fontAnimName = scripts\zm\style_font_animation::get_font_animation_name(self.font_animation_index, self.langLEN);

    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_font_animation)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Animación Fuente: " + fontAnimName);
                else
                    self.menu_current.items[i].item setText("Font Animation: " + fontAnimName);
                break;
            }
        }
    }

    // Limpiar el flag después de un pequeño delay
    wait 0.2;
    self.is_cycling_font_animation = undefined;
}

// Nueva función para abrir el menú de configuración de sonidos
open_sound_settings_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    // Cerrar el menú anterior pero mantener referencia al menú principal
    self notify("destroy_current_menu");
    wait 0.1;

    // Crear submenú de sonidos con título según idioma
    title = (self.langLEN == 0) ? "CONFIGURACIÓN DE SONIDOS" : "SOUND SETTINGS";
    menu = create_menu(title, self);
    menu.parent_menu = "settings"; // Para saber a qué menú volver

    // Añadir opciones al menú con textos según el idioma
    if (self.langLEN == 0) // Español
    {
        // Opción para cambiar sonido de apertura del menú
        openSoundName = scripts\zm\playsound::get_menu_open_sound_name(self.menu_open_sound_index, self.langLEN);
        add_menu_item(menu, "Abrir Menú: " + openSoundName, ::cycle_menu_open_sound);

        // Opción para cambiar sonido de cierre del menú
        closeSoundName = scripts\zm\playsound::get_menu_close_sound_name(self.menu_close_sound_index, self.langLEN);
        add_menu_item(menu, "Cerrar Menú: " + closeSoundName, ::cycle_menu_close_sound);

        // Opción para cambiar sonido de navegación/scroll del menú
        scrollSoundName = scripts\zm\playsound::get_menu_scroll_sound_name(self.menu_scroll_sound_index, self.langLEN);
        add_menu_item(menu, "Navegación: " + scrollSoundName, ::cycle_menu_scroll_sound);

        // Opción para cambiar sonido de selección de opciones del menú
        selectSoundName = scripts\zm\playsound::get_menu_select_sound_name(self.menu_select_sound_index, self.langLEN);
        add_menu_item(menu, "Selección: " + selectSoundName, ::cycle_menu_select_sound);

        // Opción para probar sonidos
        add_menu_item(menu, "Probar Sonidos", ::test_menu_sounds);

        // Volver al menú de configuración
        add_menu_item(menu, "Volver", ::open_settings_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Opción para cambiar sonido de apertura del menú
        openSoundName = scripts\zm\playsound::get_menu_open_sound_name(self.menu_open_sound_index, self.langLEN);
        add_menu_item(menu, "Open Menu: " + openSoundName, ::cycle_menu_open_sound);

        // Opción para cambiar sonido de cierre del menú
        closeSoundName = scripts\zm\playsound::get_menu_close_sound_name(self.menu_close_sound_index, self.langLEN);
        add_menu_item(menu, "Close Menu: " + closeSoundName, ::cycle_menu_close_sound);

        // Opción para cambiar sonido de navegación/scroll del menú
        scrollSoundName = scripts\zm\playsound::get_menu_scroll_sound_name(self.menu_scroll_sound_index, self.langLEN);
        add_menu_item(menu, "Navigation: " + scrollSoundName, ::cycle_menu_scroll_sound);

        // Opción para cambiar sonido de selección de opciones del menú
        selectSoundName = scripts\zm\playsound::get_menu_select_sound_name(self.menu_select_sound_index, self.langLEN);
        add_menu_item(menu, "Selection: " + selectSoundName, ::cycle_menu_select_sound);

        // Opción para probar sonidos
        add_menu_item(menu, "Test Sounds", ::test_menu_sounds);

        // Volver al menú de configuración
        add_menu_item(menu, "Back", ::open_settings_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
     // Mostrar menú y controlar la navegación
    show_menu(menu);
    
    // Aplicar posición de texto actual
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    // Mantener la selección actual si existe
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        
        // Actualizar el color del elemento seleccionado a blanco para mantener consistencia
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);


}

// Nueva función para ciclar entre los sonidos de apertura del menú
cycle_menu_open_sound()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_open_sound))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_open_sound = true;

    // Incrementar el índice de sonido de apertura
    self.menu_open_sound_index += 1;

    // Si excede el máximo, volver a 0 (5 sonidos disponibles: 0-4)
    if (self.menu_open_sound_index >= 5)
        self.menu_open_sound_index = 0;

    // Obtener el nombre del sonido para mostrar
    openSoundName = scripts\zm\playsound::get_menu_open_sound_name(self.menu_open_sound_index, self.langLEN);

    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_open_sound)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Abrir Menú: " + openSoundName);
                else
                    self.menu_current.items[i].item setText("Open Menu: " + openSoundName);
                break;
            }
        }
    }

    // Limpiar el flag después de un pequeño delay
    wait 0.2;
    self.is_cycling_open_sound = undefined;
}

// Nueva función para ciclar entre los sonidos de cierre del menú
cycle_menu_close_sound()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_close_sound))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_close_sound = true;

    // Incrementar el índice de sonido de cierre
    self.menu_close_sound_index += 1;

    // Si excede el máximo, volver a 0 (6 sonidos disponibles: 0-5)
    if (self.menu_close_sound_index >= 6)
        self.menu_close_sound_index = 0;

    // Obtener el nombre del sonido para mostrar
    closeSoundName = scripts\zm\playsound::get_menu_close_sound_name(self.menu_close_sound_index, self.langLEN);

    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_close_sound)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Cerrar Menú: " + closeSoundName);
                else
                    self.menu_current.items[i].item setText("Close Menu: " + closeSoundName);
                break;
            }
        }
    }

    // Limpiar el flag después de un pequeño delay
    wait 0.2;
    self.is_cycling_close_sound = undefined;
}

// Nueva función para ciclar entre los sonidos de navegación/scroll del menú
cycle_menu_scroll_sound()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_scroll_sound))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_scroll_sound = true;

    // Incrementar el índice de sonido de navegación/scroll
    self.menu_scroll_sound_index += 1;

    // Si excede el máximo, volver a 0 (5 sonidos disponibles: 0-4)
    if (self.menu_scroll_sound_index >= 5)
        self.menu_scroll_sound_index = 0;

    // Obtener el nombre del sonido para mostrar
    scrollSoundName = scripts\zm\playsound::get_menu_scroll_sound_name(self.menu_scroll_sound_index, self.langLEN);

    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_scroll_sound)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Navegación: " + scrollSoundName);
                else
                    self.menu_current.items[i].item setText("Navigation: " + scrollSoundName);
                break;
            }
        }
    }

    // Limpiar el flag después de un pequeño delay
    wait 0.2;
    self.is_cycling_scroll_sound = undefined;
}

// Nueva función para probar los sonidos seleccionados
// Nueva función para ciclar entre los sonidos de selección del menú
cycle_menu_select_sound()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_select_sound))
    {
        wait 0.1;
        return;
    }

    self.is_cycling_select_sound = true;

    // Incrementar el índice de sonido de selección
    self.menu_select_sound_index += 1;

    // Si excede el máximo, volver a 0 (6 sonidos disponibles: 0-5)
    if (self.menu_select_sound_index >= 3)
        self.menu_select_sound_index = 0;

    // Obtener el nombre del sonido para mostrar
    selectSoundName = scripts\zm\playsound::get_menu_select_sound_name(self.menu_select_sound_index, self.langLEN);

    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_menu_select_sound)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Selección: " + selectSoundName);
                else
                    self.menu_current.items[i].item setText("Selection: " + selectSoundName);
                break;
            }
        }
    }

    // Limpiar el flag después de un pequeño delay
    wait 0.2;
    self.is_cycling_select_sound = undefined;
}

// Función para verificar si hay mods legacy activados
are_legacy_mods_active()
{
    return (level.player_health_display.enabled || level.zombie_health_display.enabled || level.zombie_counter_display.enabled);
}

// Función para desactivar todos los legacy mods (para resolver conflictos)
disable_all_legacy_mods()
{
    legacy_was_active = false;

    if (level.player_health_display.enabled)
    {
        scripts\zm\legacy_mods_performance::toggle_player_health_display(self);
        legacy_was_active = true;
    }

    if (level.zombie_health_display.enabled)
    {
        scripts\zm\legacy_mods_performance::toggle_zombie_health_display(self);
        legacy_was_active = true;
    }

    if (level.zombie_counter_display.enabled)
    {
        scripts\zm\legacy_mods_performance::toggle_zombie_counter_display(self);
        legacy_was_active = true;
    }

    return legacy_was_active;
}

// Nueva función para abrir el menú de mods de rendimiento
open_performance_mods_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "MODS Heredado" : "LEGACY MODS";
    menu = create_menu(title, self);
    menu.parent_menu = "littlegods";

    // Verificar restricciones
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();

    if (self.langLEN == 0) // Español
    {
        // Menú de configuración para vida del jugador
        player_health_item = add_menu_item(menu, "Vida Jugador", ::open_player_health_config_menu);
        if ((borders_active && !level.player_health_display.enabled) ||
            (healthbar_active && !level.player_health_display.enabled) ||
            (healthbarzombie_active && !level.player_health_display.enabled))
        {
            player_health_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Menú de configuración para vida del zombie
        zombie_health_item = add_menu_item(menu, "Vida Zombie", ::open_zombie_health_config_menu);
        if ((borders_active && !level.zombie_health_display.enabled) ||
            (healthbar_active && !level.zombie_health_display.enabled) ||
            (healthbarzombie_active && !level.zombie_health_display.enabled))
        {
            zombie_health_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Menú de configuración para contador de zombies
        zombie_counter_item = add_menu_item(menu, "Contador Zombies", ::open_zombie_counter_config_menu);
        if ((borders_active && !level.zombie_counter_display.enabled) ||
            (healthbar_active && !level.zombie_counter_display.enabled) ||
            (healthbarzombie_active && !level.zombie_counter_display.enabled))
        {
            zombie_counter_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Modo de visualización (solo en menú principal)
        mode_text = (level.legacy_display_mode == "littlegods") ? "LITTLEGODS" : "CLASSIC";
        add_menu_item(menu, "Modo: " + mode_text, ::cycle_legacy_display_mode);

        add_menu_item(menu, "Volver", ::open_mods_littlegods_menu);
    }
    else // Inglés
    {
        // Menú de configuración para vida del jugador
        player_health_item = add_menu_item(menu, "Player Health", ::open_player_health_config_menu);
        if ((borders_active && !level.player_health_display.enabled) ||
            (healthbar_active && !level.player_health_display.enabled) ||
            (healthbarzombie_active && !level.player_health_display.enabled))
        {
            player_health_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Menú de configuración para vida del zombie
        zombie_health_item = add_menu_item(menu, "Zombie Health", ::open_zombie_health_config_menu);
        if ((borders_active && !level.zombie_health_display.enabled) ||
            (healthbar_active && !level.zombie_health_display.enabled) ||
            (healthbarzombie_active && !level.zombie_health_display.enabled))
        {
            zombie_health_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Menú de configuración para contador de zombies
        zombie_counter_item = add_menu_item(menu, "Zombie Counter", ::open_zombie_counter_config_menu);
        if ((borders_active && !level.zombie_counter_display.enabled) ||
            (healthbar_active && !level.zombie_counter_display.enabled) ||
            (healthbarzombie_active && !level.zombie_counter_display.enabled))
        {
            zombie_counter_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Modo de visualización (solo en menú principal)
        mode_text = (level.legacy_display_mode == "littlegods") ? "LITTLEGODS" : "CLASSIC";
        add_menu_item(menu, "Mode: " + mode_text, ::cycle_legacy_display_mode);

        add_menu_item(menu, "Back", ::open_mods_littlegods_menu);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Funciones de toggle para los displays
toggle_player_health_display()
{
    // Verificar restricciones antes de activar
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();

    if (!level.player_health_display.enabled && (borders_active || healthbar_active || healthbarzombie_active))
    {
        // No se puede activar, mostrar mensaje
        if (self.langLEN == 0)
            self iPrintLnBold("^1No se puede activar mientras las barras de vida o bordes están activos");
        else
            self iPrintLnBold("^1Cannot activate while health bars or borders are active");
        return;
    }

    // Si se está activando y hay otros legacy mods activos, verificar restricciones
    if (!level.player_health_display.enabled && legacy_mods_active)
    {
        // Permitir activar múltiples legacy mods si no hay conflictos con otros sistemas
        // No hay restricción interna entre legacy mods
    }

    scripts\zm\legacy_mods_performance::toggle_player_health_display(self);

    // Si estamos en el menú de configuración, actualizar visibilidad en tiempo real
    if (isDefined(self.menu_current) && (self.menu_current.title == "VIDA JUGADOR" || self.menu_current.title == "PLAYER HEALTH"))
    {
        // Actualizar el texto del estado
        if (isDefined(self.menu_current.items[0]) && isDefined(self.menu_current.items[0].item))
        {
            status = level.player_health_display.enabled ? "ON" : "OFF";
            self.menu_current.items[0].item setText("Estado: " + status);
        }
        // Actualizar visibilidad de opciones
        update_config_menu_visibility(self.menu_current);
    }
    else
    {
        // Abrir menú de configuración si no estamos en él
        wait 0.1;
        if (isDefined(self.menu_current))
        {
            self notify("destroy_current_menu");
            self thread open_player_health_config_menu();
        }
    }
}

toggle_zombie_health_display()
{
    // Verificar restricciones antes de activar
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;

    if (!level.zombie_health_display.enabled && (borders_active || healthbar_active || healthbarzombie_active))
    {
        // No se puede activar, mostrar mensaje
        if (self.langLEN == 0)
            self iPrintLnBold("^1No se puede activar mientras las barras de vida o bordes están activos");
        else
            self iPrintLnBold("^1Cannot activate while health bars or borders are active");
        return;
    }

    scripts\zm\legacy_mods_performance::toggle_zombie_health_display(self);

    // Si estamos en el menú de configuración, actualizar visibilidad en tiempo real
    if (isDefined(self.menu_current) && (self.menu_current.title == "VIDA ZOMBIE" || self.menu_current.title == "ZOMBIE HEALTH"))
    {
        // Actualizar el texto del estado
        if (isDefined(self.menu_current.items[0]) && isDefined(self.menu_current.items[0].item))
        {
            status = level.zombie_health_display.enabled ? "ON" : "OFF";
            self.menu_current.items[0].item setText("Estado: " + status);
        }
        // Actualizar visibilidad de opciones
        update_config_menu_visibility(self.menu_current);
    }
    else
    {
        // Abrir menú de configuración si no estamos en él
        wait 0.1;
        if (isDefined(self.menu_current))
        {
            self notify("destroy_current_menu");
            self thread open_zombie_health_config_menu();
        }
    }
}

toggle_zombie_counter_display()
{
    // Verificar restricciones antes de activar
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;

    if (!level.zombie_counter_display.enabled && (borders_active || healthbar_active || healthbarzombie_active))
    {
        // No se puede activar, mostrar mensaje
        if (self.langLEN == 0)
            self iPrintLnBold("^1No se puede activar mientras las barras de vida o bordes están activos");
        else
            self iPrintLnBold("^1Cannot activate while health bars or borders are active");
        return;
    }

    scripts\zm\legacy_mods_performance::toggle_zombie_counter_display(self);

    // Si estamos en el menú de configuración, actualizar visibilidad en tiempo real
    if (isDefined(self.menu_current) && (self.menu_current.title == "CONTADOR ZOMBIES" || self.menu_current.title == "ZOMBIE COUNTER"))
    {
        // Actualizar el texto del estado
        if (isDefined(self.menu_current.items[0]) && isDefined(self.menu_current.items[0].item))
        {
            status = level.zombie_counter_display.enabled ? "ON" : "OFF";
            self.menu_current.items[0].item setText("Estado: " + status);
        }
        // Actualizar visibilidad de opciones
        update_config_menu_visibility(self.menu_current);
    }
    else
    {
        // Abrir menú de configuración si no estamos en él
        wait 0.1;
        if (isDefined(self.menu_current))
        {
            self notify("destroy_current_menu");
            self thread open_zombie_counter_config_menu();
        }
    }
}

// ========================================
// MENÚS DE CONFIGURACIÓN PARA MODS LEGACY
// ========================================

// Menú de configuración para vida del jugador
open_player_health_config_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "VIDA JUGADOR" : "PLAYER HEALTH";
    menu = create_menu(title, self);
    menu.parent_menu = "performance_mods";

    if (self.langLEN == 0) // Español
    {
        // Estado del mod
        status = level.player_health_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Estado: " + status, ::toggle_player_health_display);

        // Posición (visible solo cuando está activado y en modo Littlegods) - Solo TOP LEFT y TOP RIGHT
        screen_width = 640; // Ancho estándar de pantalla en Black Ops II
        right_margin = 10;  // Margen derecho
        top_right_x = screen_width - right_margin;

        if (level.player_health_display.x == 10 && level.player_health_display.y == 50)
            pos_text = "ARRIBA IZQUIERDA";
        else if (level.player_health_display.x == top_right_x && level.player_health_display.y == 50)
            pos_text = "ARRIBA DERECHA";
        else
            pos_text = "ARRIBA IZQUIERDA"; // Default to TOP LEFT
        pos_item = add_menu_item(menu, "Posición: " + pos_text, ::cycle_player_health_position);
        pos_item.item.alpha = (level.player_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        // Color (visible solo cuando está activado)
        if (!isDefined(level.player_health_display.color_index))
            level.player_health_display.color_index = 0;
        color_text = get_color_name_by_index(level.player_health_display.color_index, self.langLEN);
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_player_health_color);
        color_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        // Transparencia (visible solo cuando está activado)
        if (level.player_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.player_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.player_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "PERSONALIZADO";
        alpha_item = add_menu_item(menu, "Transparencia: " + alpha_text, ::cycle_player_health_alpha);
        alpha_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        // Degradado de colores (visible solo cuando está activado)
        gradient_status = level.player_health_display.color_gradient_enabled ? "ON" : "OFF";
        gradient_item = add_menu_item(menu, "Degradado Colores: " + gradient_status, ::toggle_player_health_gradient);
        gradient_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        add_menu_item(menu, "Volver", ::open_performance_mods_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Estado del mod
        status = level.player_health_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Status: " + status, ::toggle_player_health_display);

        // Posición (visible solo cuando está activado y en modo Littlegods) - Solo TOP LEFT y TOP RIGHT
        screen_width = 640; // Ancho estándar de pantalla en Black Ops II
        right_margin = 10;  // Margen derecho
        top_right_x = screen_width - right_margin;

        if (level.player_health_display.x == 10 && level.player_health_display.y == 50)
            pos_text = "TOP LEFT";
        else if (level.player_health_display.x == top_right_x && level.player_health_display.y == 50)
            pos_text = "TOP RIGHT";
        else
            pos_text = "TOP LEFT"; // Default to TOP LEFT
        pos_item = add_menu_item(menu, "Position: " + pos_text, ::cycle_player_health_position);
        pos_item.item.alpha = (level.player_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        // Color (visible solo cuando está activado)
        if (!isDefined(level.player_health_display.color_index))
            level.player_health_display.color_index = 0;
        color_text = get_color_name_by_index(level.player_health_display.color_index, self.langLEN);
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_player_health_color);
        color_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        // Transparencia (visible solo cuando está activado)
        if (level.player_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.player_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.player_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "CUSTOM";
        alpha_item = add_menu_item(menu, "Transparency: " + alpha_text, ::cycle_player_health_alpha);
        alpha_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        // Color Gradient (visible solo cuando está activado)
        gradient_status = level.player_health_display.color_gradient_enabled ? "ON" : "OFF";
        gradient_item = add_menu_item(menu, "Color Gradient: " + gradient_status, ::toggle_player_health_gradient);
        gradient_item.item.alpha = level.player_health_display.enabled ? 1 : 0;

        add_menu_item(menu, "Back", ::open_performance_mods_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(menu.user.font_animation_index) && menu.user.font_animation_index > 0) {
        scripts\zm\style_font_animation::apply_font_animation(menu, menu.user.font_animation_index);
    }

    self thread menu_control(menu);
}

// Menú de configuración para vida del zombie
open_zombie_health_config_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "VIDA ZOMBIE" : "ZOMBIE HEALTH";
    menu = create_menu(title, self);
    menu.parent_menu = "performance_mods";

    if (self.langLEN == 0) // Español
    {
        // Estado del mod
        status = level.zombie_health_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Estado: " + status, ::toggle_zombie_health_display);

        // Posición (visible solo cuando está activado y en modo Littlegods) - Solo TOP LEFT y TOP RIGHT
        if (level.zombie_health_display.x == 10 && level.zombie_health_display.y == 60)
            pos_text = "ARRIBA IZQUIERDA";
        else if (level.zombie_health_display.x == 630 && level.zombie_health_display.y == 60)
            pos_text = "ARRIBA DERECHA";
        else
            pos_text = "ARRIBA IZQUIERDA"; // Default to TOP LEFT
        pos_item = add_menu_item(menu, "Posición: " + pos_text, ::cycle_zombie_health_position);
        pos_item.item.alpha = (level.zombie_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        // Color (visible solo cuando está activado)
        if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 1)
            color_text = "BLANCO";
        else if (level.zombie_health_display.color[0] == 0 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 0)
            color_text = "VERDE";
        else if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 0 && level.zombie_health_display.color[2] == 0)
            color_text = "ROJO";
        else if (level.zombie_health_display.color[0] == 0 && level.zombie_health_display.color[1] == 0 && level.zombie_health_display.color[2] == 1)
            color_text = "AZUL";
        else if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 0)
            color_text = "AMARILLO";
        else
            color_text = "PERSONALIZADO";
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_zombie_health_color);
        color_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        // Transparencia (visible solo cuando está activado)
        if (level.zombie_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "PERSONALIZADO";
        alpha_item = add_menu_item(menu, "Transparencia: " + alpha_text, ::cycle_zombie_health_alpha);
        alpha_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        // Degradado de colores (visible solo cuando está activado)
        gradient_status = level.zombie_health_display.color_gradient_enabled ? "ON" : "OFF";
        gradient_item = add_menu_item(menu, "Degradado Colores: " + gradient_status, ::toggle_zombie_health_gradient);
        gradient_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        add_menu_item(menu, "Volver", ::open_performance_mods_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Estado del mod
        status = level.zombie_health_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Status: " + status, ::toggle_zombie_health_display);

        // Posición (visible solo cuando está activado y en modo Littlegods) - Solo TOP LEFT y TOP RIGHT
        if (level.zombie_health_display.x == 10 && level.zombie_health_display.y == 60)
            pos_text = "TOP LEFT";
        else if (level.zombie_health_display.x == 630 && level.zombie_health_display.y == 60)
            pos_text = "TOP RIGHT";
        else
            pos_text = "TOP LEFT"; // Default to TOP LEFT
        pos_item = add_menu_item(menu, "Position: " + pos_text, ::cycle_zombie_health_position);
        pos_item.item.alpha = (level.zombie_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        // Color (visible solo cuando está activado)
        if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 1)
            color_text = "WHITE";
        else if (level.zombie_health_display.color[0] == 0 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 0)
            color_text = "GREEN";
        else if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 0 && level.zombie_health_display.color[2] == 0)
            color_text = "RED";
        else if (level.zombie_health_display.color[0] == 0 && level.zombie_health_display.color[1] == 0 && level.zombie_health_display.color[2] == 1)
            color_text = "BLUE";
        else if (level.zombie_health_display.color[0] == 1 && level.zombie_health_display.color[1] == 1 && level.zombie_health_display.color[2] == 0)
            color_text = "YELLOW";
        else
            color_text = "CUSTOM";
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_zombie_health_color);
        color_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        // Transparencia (visible solo cuando está activado)
        if (level.zombie_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "CUSTOM";
        alpha_item = add_menu_item(menu, "Transparency: " + alpha_text, ::cycle_zombie_health_alpha);
        alpha_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        // Color Gradient (visible solo cuando está activado)
        gradient_status = level.zombie_health_display.color_gradient_enabled ? "ON" : "OFF";
        gradient_item = add_menu_item(menu, "Color Gradient: " + gradient_status, ::toggle_zombie_health_gradient);
        gradient_item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;

        add_menu_item(menu, "Back", ::open_performance_mods_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(menu.user.font_animation_index) && menu.user.font_animation_index > 0) {
        scripts\zm\style_font_animation::apply_font_animation(menu, menu.user.font_animation_index);
    }

    self thread menu_control(menu);
}

// Menú de configuración para contador de zombies
open_zombie_counter_config_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "CONTADOR ZOMBIES" : "ZOMBIE COUNTER";
    menu = create_menu(title, self);
    menu.parent_menu = "performance_mods";

    if (self.langLEN == 0) // Español
    {
        // Estado del mod
        status = level.zombie_counter_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Estado: " + status, ::toggle_zombie_counter_display);

        // Posición (visible solo cuando está activado y en modo Littlegods) - Solo TOP LEFT y TOP RIGHT
        if (level.zombie_counter_display.x == 10 && level.zombie_counter_display.y == 70)
            pos_text = "ARRIBA IZQUIERDA";
        else if (level.zombie_counter_display.x == 630 && level.zombie_counter_display.y == 70)
            pos_text = "ARRIBA DERECHA";
        else
            pos_text = "ARRIBA IZQUIERDA"; // Default to TOP LEFT
        pos_item = add_menu_item(menu, "Posición: " + pos_text, ::cycle_zombie_counter_position);
        pos_item.item.alpha = (level.zombie_counter_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        // Color (visible solo cuando está activado)
        if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 1)
            color_text = "BLANCO";
        else if (level.zombie_counter_display.color[0] == 0 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 0)
            color_text = "VERDE";
        else if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 0 && level.zombie_counter_display.color[2] == 0)
            color_text = "ROJO";
        else if (level.zombie_counter_display.color[0] == 0 && level.zombie_counter_display.color[1] == 0 && level.zombie_counter_display.color[2] == 1)
            color_text = "AZUL";
        else if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 0)
            color_text = "AMARILLO";
        else
            color_text = "PERSONALIZADO";
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_zombie_counter_color);
        color_item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;

        // Transparencia (visible solo cuando está activado)
        if (level.zombie_counter_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_counter_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_counter_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "PERSONALIZADO";
        alpha_item = add_menu_item(menu, "Transparencia: " + alpha_text, ::cycle_zombie_counter_alpha);
        alpha_item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;

        add_menu_item(menu, "Volver", ::open_performance_mods_menu);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Estado del mod
        status = level.zombie_counter_display.enabled ? "ON" : "OFF";
        add_menu_item(menu, "Status: " + status, ::toggle_zombie_counter_display);

        // Posición (visible solo cuando está activado y en modo Littlegods) - Solo TOP LEFT y TOP RIGHT
        if (level.zombie_counter_display.x == 10 && level.zombie_counter_display.y == 70)
            pos_text = "TOP LEFT";
        else if (level.zombie_counter_display.x == 630 && level.zombie_counter_display.y == 70)
            pos_text = "TOP RIGHT";
        else
            pos_text = "TOP LEFT"; // Default to TOP LEFT
        pos_item = add_menu_item(menu, "Position: " + pos_text, ::cycle_zombie_counter_position);
        pos_item.item.alpha = (level.zombie_counter_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;

        // Color (visible solo cuando está activado)
        if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 1)
            color_text = "WHITE";
        else if (level.zombie_counter_display.color[0] == 0 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 0)
            color_text = "GREEN";
        else if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 0 && level.zombie_counter_display.color[2] == 0)
            color_text = "RED";
        else if (level.zombie_counter_display.color[0] == 0 && level.zombie_counter_display.color[1] == 0 && level.zombie_counter_display.color[2] == 1)
            color_text = "BLUE";
        else if (level.zombie_counter_display.color[0] == 1 && level.zombie_counter_display.color[1] == 1 && level.zombie_counter_display.color[2] == 0)
            color_text = "YELLOW";
        else
            color_text = "CUSTOM";
        color_item = add_menu_item(menu, "Color: " + color_text, ::cycle_zombie_counter_color);
        color_item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;

        // Transparencia (visible solo cuando está activado)
        if (level.zombie_counter_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_counter_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_counter_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = "CUSTOM";
        alpha_item = add_menu_item(menu, "Transparency: " + alpha_text, ::cycle_zombie_counter_alpha);
        alpha_item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;

        add_menu_item(menu, "Back", ::open_performance_mods_menu);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(menu.user.font_animation_index) && menu.user.font_animation_index > 0) {
        scripts\zm\style_font_animation::apply_font_animation(menu, menu.user.font_animation_index);
    }

    self thread menu_control(menu);
}

// ========================================
// FUNCIONES AUXILIARES PARA MENÚS
// ========================================

// Función para actualizar la visibilidad de opciones de configuración
update_config_menu_visibility(menu)
{
    if (!isDefined(menu) || !isDefined(menu.items))
        return;

    // Iterar a través de todos los elementos del menú y actualizar visibilidad basado en el tipo
    for(i = 0; i < menu.items.size; i++)
    {
        if (!isDefined(menu.items[i]) || !isDefined(menu.items[i].item))
            continue;

        item = menu.items[i];

        // Determinar qué tipo de elemento es basado en el título del menú y la función
            if (menu.title == "VIDA JUGADOR" || menu.title == "PLAYER HEALTH")
            {
            // Para menús de configuración de vida del jugador
            if (isDefined(item.func))
            {
                // Posición - solo visible si está activado Y en modo littlegods
                if (item.func == ::cycle_player_health_position)
                    item.item.alpha = (level.player_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;
                // Color - solo visible si está activado
                else if (item.func == ::cycle_player_health_color)
                    item.item.alpha = level.player_health_display.enabled ? 1 : 0;
                // Transparencia - solo visible si está activado
                else if (item.func == ::cycle_player_health_alpha)
                    item.item.alpha = level.player_health_display.enabled ? 1 : 0;
                // Degradado de colores - solo visible si está activado
                else if (item.func == ::toggle_player_health_gradient)
                    item.item.alpha = level.player_health_display.enabled ? 1 : 0;
            }
            }
            else if (menu.title == "VIDA ZOMBIE" || menu.title == "ZOMBIE HEALTH")
            {
            // Para menús de configuración de vida del zombie
            if (isDefined(item.func))
            {
                // Posición - solo visible si está activado Y en modo littlegods
                if (item.func == ::cycle_zombie_health_position)
                    item.item.alpha = (level.zombie_health_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;
                // Color - solo visible si está activado
                else if (item.func == ::cycle_zombie_health_color)
                    item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;
                // Transparencia - solo visible si está activado
                else if (item.func == ::cycle_zombie_health_alpha)
                    item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;
                // Degradado de colores - solo visible si está activado
                else if (item.func == ::toggle_zombie_health_gradient)
                    item.item.alpha = level.zombie_health_display.enabled ? 1 : 0;
            }
            }
            else if (menu.title == "CONTADOR ZOMBIES" || menu.title == "ZOMBIE COUNTER")
            {
            // Para menús de configuración del contador de zombies
            if (isDefined(item.func))
            {
                // Posición - solo visible si está activado Y en modo littlegods
                if (item.func == ::cycle_zombie_counter_position)
                    item.item.alpha = (level.zombie_counter_display.enabled && level.legacy_display_mode == "littlegods") ? 1 : 0;
                // Color - solo visible si está activado
                else if (item.func == ::cycle_zombie_counter_color)
                    item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;
                // Transparencia - solo visible si está activado
                else if (item.func == ::cycle_zombie_counter_alpha)
                    item.item.alpha = level.zombie_counter_display.enabled ? 1 : 0;
            }
        }
    }
}

// Función para actualizar el texto del color en el menú
update_menu_color_text(menu_title_es, menu_title_en, color_function)
{
    if (!isDefined(self.menu_current) || !isDefined(self.menu_current.items))
        return;

    // Buscar el elemento del color por función
    for(i = 0; i < self.menu_current.items.size; i++)
    {
        if (isDefined(self.menu_current.items[i]) &&
            isDefined(self.menu_current.items[i].func) &&
            self.menu_current.items[i].func == color_function)
        {
            if (isDefined(self.menu_current.items[i].item))
            {
                // Determinar el índice de color según el tipo de menú
                color_index = undefined;

                if (menu_title_es == "VIDA JUGADOR" || menu_title_en == "PLAYER HEALTH")
                    color_index = level.player_health_display.color_index;
                else if (menu_title_es == "VIDA ZOMBIE" || menu_title_en == "ZOMBIE HEALTH")
                    color_index = level.zombie_health_display.color_index;
                else if (menu_title_es == "CONTADOR ZOMBIES" || menu_title_en == "ZOMBIE COUNTER")
                    color_index = level.zombie_counter_display.color_index;

                if (isDefined(color_index))
                {
                    color_name = get_color_name_by_index(color_index, self.langLEN);
                    color_label = (self.langLEN == 0) ? "Color: " : "Color: ";
                    self.menu_current.items[i].item setText(color_label + color_name);
            }
        }
            break;
        }
    }
}

// Función para actualizar visibilidad en todos los menús de configuración legacy
update_all_config_menu_visibility(player)
{
    // Esta función busca todos los menús de configuración legacy que puedan estar abiertos
    // y actualiza su visibilidad. Es útil cuando cambia el modo legacy.

    // Nota: En GSC no hay una forma directa de acceder a todos los menús activos,
    // pero podemos verificar si el jugador tiene algún menú de configuración legacy abierto
    // revisando el menú actual y potencialmente otros menús relacionados.
}

// ========================================
// FUNCIONES DE CICLADO PARA CONFIGURACIÓN
// ========================================

cycle_legacy_display_mode()
{
    // Cambiar entre "littlegods" y "classic"
    if (level.legacy_display_mode == "littlegods")
    {
        scripts\zm\legacy_mods_performance::switch_legacy_display_mode("classic");
    }
    else
    {
        scripts\zm\legacy_mods_performance::switch_legacy_display_mode("littlegods");
    }

    // Esperar un poco para que se actualice el modo
    wait 0.05;

    // Actualizar menú principal en tiempo real (índice 3, después de los 3 submenús)
    if (isDefined(self.menu_current))
    {
        mode_text = (level.legacy_display_mode == "littlegods") ? "LITTLEGODS" : "CLASSIC";

        // Solo actualizar si estamos en el menú de Legacy Mods
        if (self.menu_current.title == "MODS Heredado" || self.menu_current.title == "LEGACY MODS")
        {
            // Buscar el elemento del modo por función en lugar de índice hardcodeado
            for(i = 0; i < self.menu_current.items.size; i++)
            {
                if (isDefined(self.menu_current.items[i]) &&
                    isDefined(self.menu_current.items[i].func) &&
                    self.menu_current.items[i].func == ::cycle_legacy_display_mode)
                {
                    if (isDefined(self.menu_current.items[i].item))
            {
                mode_label = (self.langLEN == 0) ? "Modo: " : "Mode: ";
                        self.menu_current.items[i].item setText(mode_label + mode_text);
            }
                    break;
        }
    }

            // Actualizar visibilidad de opciones de configuración en todos los submenús abiertos
            update_all_config_menu_visibility(self);
        }
    }
}

// Función auxiliar para comparar colores con tolerancia
color_approx_equal(color1, color2, tolerance)
{
    if (!isDefined(color1) || !isDefined(color2) || color1.size < 3 || color2.size < 3)
        return false;

    for(i = 0; i < 3; i++)
    {
        if (abs(color1[i] - color2[i]) > tolerance)
            return false;
    }

    return true;
}

// Función para obtener el nombre de un color basado en el índice
get_color_name_by_index(color_index, lang_index)
{
    if (!isDefined(color_index))
        color_index = 0;

    // Español
    if (lang_index == 0)
    {
        switch(color_index)
        {
            case 0: return "BLANCO";
            case 1: return "VERDE";
            case 2: return "ROJO";
            case 3: return "AZUL";
            case 4: return "AMARILLO";
            case 5: return "CIAN";
            case 6: return "MAGENTA";
            case 7: return "NARANJA";
            case 8: return "ROSA";
            case 9: return "PÚRPURA";
            case 10: return "GRIS";
            case 11: return "NEGRO";
            default: return "PERSONALIZADO";
        }
    }
    // Inglés
    else
    {
        switch(color_index)
        {
            case 0: return "WHITE";
            case 1: return "GREEN";
            case 2: return "RED";
            case 3: return "BLUE";
            case 4: return "YELLOW";
            case 5: return "CYAN";
            case 6: return "MAGENTA";
            case 7: return "ORANGE";
            case 8: return "PINK";
            case 9: return "PURPLE";
            case 10: return "GRAY";
            case 11: return "BLACK";
            default: return "CUSTOM";
        }
    }
}

// Función para obtener el nombre de un color con tolerancia (mantener para compatibilidad)
get_color_name(color, lang_index)
{
    if (!isDefined(color) || color.size < 3)
        return (lang_index == 0) ? "PERSONALIZADO" : "CUSTOM";

    // Definir colores base con tolerancia
    tolerance = 0.05; // 5% de tolerancia

    // Blanco
    if (color_approx_equal(color, (1, 1, 1), tolerance))
        return (lang_index == 0) ? "BLANCO" : "WHITE";
    // Verde
    else if (color_approx_equal(color, (0, 1, 0), tolerance))
        return (lang_index == 0) ? "VERDE" : "GREEN";
    // Rojo
    else if (color_approx_equal(color, (1, 0, 0), tolerance))
        return (lang_index == 0) ? "ROJO" : "RED";
    // Azul
    else if (color_approx_equal(color, (0, 0, 1), tolerance))
        return (lang_index == 0) ? "AZUL" : "BLUE";
    // Amarillo
    else if (color_approx_equal(color, (1, 1, 0), tolerance))
        return (lang_index == 0) ? "AMARILLO" : "YELLOW";
    // Cian
    else if (color_approx_equal(color, (0, 1, 1), tolerance))
        return (lang_index == 0) ? "CIAN" : "CYAN";
    // Magenta
    else if (color_approx_equal(color, (1, 0, 1), tolerance))
        return (lang_index == 0) ? "MAGENTA" : "MAGENTA";
    // Naranja
    else if (color_approx_equal(color, (1, 0.5, 0), tolerance))
        return (lang_index == 0) ? "NARANJA" : "ORANGE";
    // Rosa
    else if (color_approx_equal(color, (1, 0.4, 0.7), tolerance))
        return (lang_index == 0) ? "ROSA" : "PINK";
    // Púrpura
    else if (color_approx_equal(color, (0.5, 0, 0.5), tolerance))
        return (lang_index == 0) ? "PÚRPURA" : "PURPLE";
    // Gris
    else if (color_approx_equal(color, (0.5, 0.5, 0.5), tolerance))
        return (lang_index == 0) ? "GRIS" : "GRAY";
    // Negro
    else if (color_approx_equal(color, (0, 0, 0), tolerance))
        return (lang_index == 0) ? "NEGRO" : "BLACK";

    // Si no coincide con ningún color base, es personalizado
    return (lang_index == 0) ? "PERSONALIZADO" : "CUSTOM";
}

cycle_player_health_position()
{
    // Solo permitir cambio de posición en modo Littlegods
    if (level.legacy_display_mode != "littlegods")
        return;

    // Calcular posiciones dinámicamente
    screen_width = 640; // Ancho estándar de pantalla en Black Ops II
    right_margin = 10;  // Margen derecho
    top_right_x = screen_width - right_margin;

    // Ciclar solo entre TOP LEFT y TOP RIGHT
    if (level.player_health_display.x == 10 && level.player_health_display.y == 50) // TOP LEFT
    {
        level.player_health_display.x = top_right_x;
        level.player_health_display.y = 50; // TOP RIGHT
    }
    else // TOP RIGHT o cualquier otra posición
    {
        level.player_health_display.x = 10;
        level.player_health_display.y = 50; // TOP LEFT
    }

    // Actualizar displays existentes usando la función de modo
    foreach(player in level.players)
    {
        scripts\zm\legacy_mods_performance::update_player_health_position(player);
    }

    // Actualizar menú en tiempo real
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[1]) && isDefined(self.menu_current.items[1].item))
    {
        // Calcular posiciones dinámicamente
        screen_width = 640; // Ancho estándar de pantalla en Black Ops II
        right_margin = 10;  // Margen derecho
        top_right_x = screen_width - right_margin;

        // Determinar el texto de posición actual (solo TOP LEFT y TOP RIGHT)
        if (level.player_health_display.x == 10 && level.player_health_display.y == 50)
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT";
        else if (level.player_health_display.x == top_right_x && level.player_health_display.y == 50)
            pos_text = (self.langLEN == 0) ? "ARRIBA DERECHA" : "TOP RIGHT";
        else
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT"; // Default to TOP LEFT

        // Actualizar el texto del elemento del menú (ahora en índice 1)
        pos_label = (self.langLEN == 0) ? "Posición: " : "Position: ";
        self.menu_current.items[1].item setText(pos_label + pos_text);
    }
}


cycle_player_health_color()
{
    // Inicializar índice de color si no existe
    if (!isDefined(level.player_health_display.color_index))
        level.player_health_display.color_index = 0;

    // Incrementar índice
    level.player_health_display.color_index++;
    if (level.player_health_display.color_index > 11)
        level.player_health_display.color_index = 0;

    // Asignar color según índice
    switch(level.player_health_display.color_index)
    {
        case 0:  level.player_health_display.color = (1, 1, 1); break;      // WHITE
        case 1:  level.player_health_display.color = (0, 1, 0); break;      // GREEN
        case 2:  level.player_health_display.color = (1, 0, 0); break;      // RED
        case 3:  level.player_health_display.color = (0, 0, 1); break;      // BLUE
        case 4:  level.player_health_display.color = (1, 1, 0); break;      // YELLOW
        case 5:  level.player_health_display.color = (0, 1, 1); break;      // CYAN
        case 6:  level.player_health_display.color = (1, 0, 1); break;      // MAGENTA
        case 7:  level.player_health_display.color = (1, 0.5, 0); break;    // ORANGE
        case 8:  level.player_health_display.color = (1, 0.4, 0.7); break;  // PINK
        case 9:  level.player_health_display.color = (0.5, 0, 0.5); break;  // PURPLE
        case 10: level.player_health_display.color = (0.5, 0.5, 0.5); break;// GRAY
        case 11: level.player_health_display.color = (0, 0, 0); break;      // BLACK
    }

    // Actualizar displays existentes
    foreach(player in level.players)
    {
        if (isDefined(player.player_health_hud))
        {
            player.player_health_hud.color = level.player_health_display.color;
        }
        if (isDefined(player.player_health_value))
        {
            player.player_health_value.color = level.player_health_display.color;
        }
    }

    // Actualizar menú en tiempo real
    update_menu_color_text("VIDA JUGADOR", "PLAYER HEALTH", ::cycle_player_health_color);
}

cycle_player_health_alpha()
{
    // Ciclar niveles de transparencia
    if (level.player_health_display.alpha == 0.5)
        level.player_health_display.alpha = 0.75;
    else if (level.player_health_display.alpha == 0.75)
        level.player_health_display.alpha = 1.0;
    else // 1.0 o personalizado
        level.player_health_display.alpha = 0.5;

    // Actualizar displays existentes
    foreach(player in level.players)
    {
        if (isDefined(player.player_health_hud))
        {
            player.player_health_hud.alpha = level.player_health_display.alpha;
        }
        if (isDefined(player.player_health_value))
        {
            player.player_health_value.alpha = level.player_health_display.alpha;
        }
    }

    // Actualizar menú en tiempo real
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[3]) && isDefined(self.menu_current.items[3].item))
    {
        // Determinar el texto de transparencia actual
        if (level.player_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.player_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.player_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = (self.langLEN == 0) ? "PERSONALIZADO" : "CUSTOM";

        // Actualizar el texto del elemento del menú
        self.menu_current.items[3].item setText("Transparencia: " + alpha_text);
    }
}

cycle_zombie_health_position()
{
    // Solo permitir cambio de posición en modo Littlegods
    if (level.legacy_display_mode != "littlegods")
        return;

    // Ciclar solo entre TOP LEFT y TOP RIGHT
    if (level.zombie_health_display.x == 10 && level.zombie_health_display.y == 60) // TOP LEFT
    {
        level.zombie_health_display.x = 630;
        level.zombie_health_display.y = 60; // TOP RIGHT
    }
    else // TOP RIGHT o cualquier otra posición
    {
        level.zombie_health_display.x = 10;
        level.zombie_health_display.y = 60; // TOP LEFT
    }

    // Actualizar displays existentes usando la función de modo
    foreach(player in level.players)
    {
        scripts\zm\legacy_mods_performance::update_zombie_health_position(player);
    }

    // Actualizar menú en tiempo real
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[1]) && isDefined(self.menu_current.items[1].item))
    {
        // Determinar el texto de posición actual (solo TOP LEFT y TOP RIGHT)
        if (level.zombie_health_display.x == 10 && level.zombie_health_display.y == 60)
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT";
        else if (level.zombie_health_display.x == 630 && level.zombie_health_display.y == 60)
            pos_text = (self.langLEN == 0) ? "ARRIBA DERECHA" : "TOP RIGHT";
        else
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT"; // Default to TOP LEFT

        // Actualizar el texto del elemento del menú (ahora en índice 1)
        pos_label = (self.langLEN == 0) ? "Posición: " : "Position: ";
        self.menu_current.items[1].item setText(pos_label + pos_text);
    }
}


cycle_zombie_health_color()
{
    // Inicializar índice de color si no existe
    if (!isDefined(level.zombie_health_display.color_index))
        level.zombie_health_display.color_index = 0;

    // Incrementar índice
    level.zombie_health_display.color_index++;
    if (level.zombie_health_display.color_index > 11)
        level.zombie_health_display.color_index = 0;

    // Asignar color según índice
    switch(level.zombie_health_display.color_index)
    {
        case 0:  level.zombie_health_display.color = (1, 1, 1); break;      // WHITE
        case 1:  level.zombie_health_display.color = (0, 1, 0); break;      // GREEN
        case 2:  level.zombie_health_display.color = (1, 0, 0); break;      // RED
        case 3:  level.zombie_health_display.color = (0, 0, 1); break;      // BLUE
        case 4:  level.zombie_health_display.color = (1, 1, 0); break;      // YELLOW
        case 5:  level.zombie_health_display.color = (0, 1, 1); break;      // CYAN
        case 6:  level.zombie_health_display.color = (1, 0, 1); break;      // MAGENTA
        case 7:  level.zombie_health_display.color = (1, 0.5, 0); break;    // ORANGE
        case 8:  level.zombie_health_display.color = (1, 0.4, 0.7); break;  // PINK
        case 9:  level.zombie_health_display.color = (0.5, 0, 0.5); break;  // PURPLE
        case 10: level.zombie_health_display.color = (0.5, 0.5, 0.5); break;// GRAY
        case 11: level.zombie_health_display.color = (0, 0, 0); break;      // BLACK
    }

    // Actualizar displays existentes
    foreach(player in level.players)
    {
        if (isDefined(player.zombie_health_hud))
        {
            player.zombie_health_hud.color = level.zombie_health_display.color;
        }
        if (isDefined(player.zombie_health_value))
        {
            player.zombie_health_value.color = level.zombie_health_display.color;
        }
    }

    // Actualizar menú en tiempo real
    update_menu_color_text("VIDA ZOMBIE", "ZOMBIE HEALTH", ::cycle_zombie_health_color);
}

cycle_zombie_health_alpha()
{
    // Ciclar niveles de transparencia
    if (level.zombie_health_display.alpha == 0.5)
        level.zombie_health_display.alpha = 0.75;
    else if (level.zombie_health_display.alpha == 0.75)
        level.zombie_health_display.alpha = 1.0;
    else // 1.0 o personalizado
        level.zombie_health_display.alpha = 0.5;

    // Actualizar displays existentes
    foreach(player in level.players)
    {
        if (isDefined(player.zombie_health_hud))
        {
            player.zombie_health_hud.alpha = level.zombie_health_display.alpha;
        }
        if (isDefined(player.zombie_health_value))
        {
            player.zombie_health_value.alpha = level.zombie_health_display.alpha;
        }
    }

    // Actualizar menú en tiempo real
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[3]) && isDefined(self.menu_current.items[3].item))
    {
        // Determinar el texto de transparencia actual
        if (level.zombie_health_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_health_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_health_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = (self.langLEN == 0) ? "PERSONALIZADO" : "CUSTOM";

        // Actualizar el texto del elemento del menú
        self.menu_current.items[3].item setText("Transparencia: " + alpha_text);
    }
}

cycle_zombie_counter_position()
{
    // Solo permitir cambio de posición en modo Littlegods
    if (level.legacy_display_mode != "littlegods")
        return;

    // Ciclar solo entre TOP LEFT y TOP RIGHT
    if (level.zombie_counter_display.x == 10 && level.zombie_counter_display.y == 70) // TOP LEFT
    {
        level.zombie_counter_display.x = 630;
        level.zombie_counter_display.y = 70; // TOP RIGHT
    }
    else // TOP RIGHT o cualquier otra posición
    {
        level.zombie_counter_display.x = 10;
        level.zombie_counter_display.y = 70; // TOP LEFT
    }

    // Actualizar displays existentes usando la función de modo
    foreach(player in level.players)
    {
        scripts\zm\legacy_mods_performance::update_zombie_counter_position(player);
    }

    // Actualizar menú en tiempo real
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[1]) && isDefined(self.menu_current.items[1].item))
    {
        // Determinar el texto de posición actual (solo TOP LEFT y TOP RIGHT)
        if (level.zombie_counter_display.x == 10 && level.zombie_counter_display.y == 70)
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT";
        else if (level.zombie_counter_display.x == 630 && level.zombie_counter_display.y == 70)
            pos_text = (self.langLEN == 0) ? "ARRIBA DERECHA" : "TOP RIGHT";
        else
            pos_text = (self.langLEN == 0) ? "ARRIBA IZQUIERDA" : "TOP LEFT"; // Default to TOP LEFT

        // Actualizar el texto del elemento del menú (ahora en índice 1)
        pos_label = (self.langLEN == 0) ? "Posición: " : "Position: ";
        self.menu_current.items[1].item setText(pos_label + pos_text);
    }
}


cycle_zombie_counter_color()
{
    // Inicializar índice de color si no existe
    if (!isDefined(level.zombie_counter_display.color_index))
        level.zombie_counter_display.color_index = 0;

    // Incrementar índice
    level.zombie_counter_display.color_index++;
    if (level.zombie_counter_display.color_index > 11)
        level.zombie_counter_display.color_index = 0;

    // Asignar color según índice
    switch(level.zombie_counter_display.color_index)
    {
        case 0:  level.zombie_counter_display.color = (1, 1, 1); break;      // WHITE
        case 1:  level.zombie_counter_display.color = (0, 1, 0); break;      // GREEN
        case 2:  level.zombie_counter_display.color = (1, 0, 0); break;      // RED
        case 3:  level.zombie_counter_display.color = (0, 0, 1); break;      // BLUE
        case 4:  level.zombie_counter_display.color = (1, 1, 0); break;      // YELLOW
        case 5:  level.zombie_counter_display.color = (0, 1, 1); break;      // CYAN
        case 6:  level.zombie_counter_display.color = (1, 0, 1); break;      // MAGENTA
        case 7:  level.zombie_counter_display.color = (1, 0.5, 0); break;    // ORANGE
        case 8:  level.zombie_counter_display.color = (1, 0.4, 0.7); break;  // PINK
        case 9:  level.zombie_counter_display.color = (0.5, 0, 0.5); break;  // PURPLE
        case 10: level.zombie_counter_display.color = (0.5, 0.5, 0.5); break;// GRAY
        case 11: level.zombie_counter_display.color = (0, 0, 0); break;      // BLACK
    }

    // Actualizar displays existentes
    foreach(player in level.players)
    {
        if (isDefined(player.zombie_counter_hud))
        {
            player.zombie_counter_hud.color = level.zombie_counter_display.color;
        }
        if (isDefined(player.zombie_counter_value))
        {
            player.zombie_counter_value.color = level.zombie_counter_display.color;
        }
    }

    // Actualizar menú en tiempo real
    update_menu_color_text("CONTADOR ZOMBIES", "ZOMBIE COUNTER", ::cycle_zombie_counter_color);
}

cycle_zombie_counter_alpha()
{
    // Ciclar niveles de transparencia
    if (level.zombie_counter_display.alpha == 0.5)
        level.zombie_counter_display.alpha = 0.75;
    else if (level.zombie_counter_display.alpha == 0.75)
        level.zombie_counter_display.alpha = 1.0;
    else // 1.0 o personalizado
        level.zombie_counter_display.alpha = 0.5;

    // Actualizar displays existentes
    foreach(player in level.players)
    {
        if (isDefined(player.zombie_counter_hud))
        {
            player.zombie_counter_hud.alpha = level.zombie_counter_display.alpha;
        }
        if (isDefined(player.zombie_counter_value))
        {
            player.zombie_counter_value.alpha = level.zombie_counter_display.alpha;
        }
    }

    // Actualizar menú en tiempo real
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[3]) && isDefined(self.menu_current.items[3].item))
    {
        // Determinar el texto de transparencia actual
        if (level.zombie_counter_display.alpha == 0.5)
            alpha_text = "50%";
        else if (level.zombie_counter_display.alpha == 0.75)
            alpha_text = "75%";
        else if (level.zombie_counter_display.alpha == 1.0)
            alpha_text = "100%";
        else
            alpha_text = (self.langLEN == 0) ? "PERSONALIZADO" : "CUSTOM";

        // Actualizar el texto del elemento del menú
        self.menu_current.items[3].item setText("Transparencia: " + alpha_text);
    }
}

test_menu_sounds()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_testing_sounds))
    {
        wait 0.1;
        return;
    }

    self.is_testing_sounds = true;

    // Reproducir sonido de apertura
    scripts\zm\playsound::play_menu_open_sound(self);

    // Esperar un poco
    wait 1.0;

    // Reproducir sonido de navegación/scroll
    if (isDefined(self.user))
        scripts\zm\playsound::play_menu_scroll_sound(self.user);
    else
        scripts\zm\playsound::play_menu_scroll_sound(self);

    // Esperar un poco más
    wait 1.0;

    // Reproducir sonido de selección
    scripts\zm\playsound::play_menu_select_sound(self);

    // Esperar un poco más
    wait 1.0;

    // Reproducir sonido de cierre
    scripts\zm\playsound::play_menu_close_sound(self);

    // Limpiar el flag después de un pequeño delay
    wait 0.5;
    self.is_testing_sounds = undefined;
}

// ========================================
// FUNCIONES TOGGLE PARA DEGRADADO DE COLORES
// ========================================

toggle_player_health_gradient()
{
    level.player_health_display.color_gradient_enabled = !level.player_health_display.color_gradient_enabled;

    // Actualizar menú en tiempo real
    if (isDefined(self.menu_current) && (self.menu_current.title == "VIDA JUGADOR" || self.menu_current.title == "PLAYER HEALTH"))
    {
        // Actualizar el texto del estado del degradado
        if (isDefined(self.menu_current.items[4]) && isDefined(self.menu_current.items[4].item))
        {
            gradient_status = level.player_health_display.color_gradient_enabled ? "ON" : "OFF";
            if (self.langLEN == 0)
                self.menu_current.items[4].item setText("Degradado Colores: " + gradient_status);
            else
                self.menu_current.items[4].item setText("Color Gradient: " + gradient_status);
        }
    }
}

toggle_zombie_health_gradient()
{
    level.zombie_health_display.color_gradient_enabled = !level.zombie_health_display.color_gradient_enabled;

    // Actualizar menú en tiempo real
    if (isDefined(self.menu_current) && (self.menu_current.title == "VIDA ZOMBIE" || self.menu_current.title == "ZOMBIE HEALTH"))
    {
        // Actualizar el texto del estado del degradado
        if (isDefined(self.menu_current.items[4]) && isDefined(self.menu_current.items[4].item))
        {
            gradient_status = level.zombie_health_display.color_gradient_enabled ? "ON" : "OFF";
            if (self.langLEN == 0)
                self.menu_current.items[4].item setText("Degradado Colores: " + gradient_status);
            else
                self.menu_current.items[4].item setText("Color Gradient: " + gradient_status);
        }
    }
}

cycle_edge_animation_style()
{
    // Evitar múltiples activaciones
    if (isDefined(self.is_cycling_edge_animation))
    {
        wait 0.1;
        return;
    }
    
    self.is_cycling_edge_animation = true;

    // Verificar si hay mods legacy activos
    legacy_mods_active = are_legacy_mods_active();
    
    // Incrementar el índice de estilo de animación
    self.edge_animation_style_index += 1;
    
    // Si excede el máximo, volver a 0
    maxEdgeAnimStyles = level.edge_animation_styles.size;
    if (self.edge_animation_style_index >= maxEdgeAnimStyles)
        self.edge_animation_style_index = 0;
    
    // Si hay mods legacy activos y se intenta activar bordes, forzar a 0 (sin borde)
    if (legacy_mods_active && self.edge_animation_style_index > 0)
    {
        self.edge_animation_style_index = 0;
        // Mostrar mensaje de advertencia
        if (self.langLEN == 0)
            self iPrintlnBold("^3Bordes desactivados - Mods de rendimiento activos");
        else
            self iPrintlnBold("^3Borders disabled - Performance mods active");
    }

    // Aplicar la nueva animación de borde al menú actual
    if (isDefined(self.menu_current))
    {
        self.menu_current = scripts\zm\style_edge_animation::apply_edge_animation(self.menu_current, self.edge_animation_style_index);
    }
    
    // Obtener el nombre del estilo para mostrar
    edgeAnimStyleName = scripts\zm\style_edge_animation::get_edge_animation_style_name(self.edge_animation_style_index, self.langLEN);
    
    
    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::cycle_edge_animation_style)
            {
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Animación Borde: " + edgeAnimStyleName);
                else
                    self.menu_current.items[i].item setText("Edge Animation: " + edgeAnimStyleName);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_cycling_edge_animation = undefined;
}

//====================================================================================
// MENÚS DE ARMAS
//====================================================================================

// Menú principal de Weapons
open_weapons_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS" : "WEAPONS";
    menu = create_menu(title, self);
    menu.parent_menu = "player";
    
    if (self.langLEN == 0) // Español
    {
        // Opción de munición infinita
        unlimited_ammo_status = (isDefined(self.unlimited_ammo) && self.unlimited_ammo) ? "ON" : "OFF";
        add_menu_item(menu, "Munición Infinita: " + unlimited_ammo_status, scripts\zm\funciones::toggle_unlimited_ammo);

        add_menu_item(menu, "Arma Aleatoria", ::give_random_weapon_menu);
        add_menu_item(menu, "Mejorar Arma Actual", ::upgrade_current_weapon_menu);
        add_menu_item(menu, "Grupo 1", ::open_weapons_submenu_1);
        add_menu_item(menu, "Grupo 2", ::open_weapons_submenu_2);
        add_menu_item(menu, "Grupo 3", ::open_weapons_submenu_3);
        add_menu_item(menu, "Grupo 4", ::open_weapons_submenu_4);
        add_menu_item(menu, "Grupo 5", ::open_weapons_submenu_5);
        add_menu_item(menu, "Volver", ::menu_go_back_to_player);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Opción de munición infinita
        unlimited_ammo_status = (isDefined(self.unlimited_ammo) && self.unlimited_ammo) ? "ON" : "OFF";
        add_menu_item(menu, "Unlimited Ammo: " + unlimited_ammo_status, scripts\zm\funciones::toggle_unlimited_ammo);

        add_menu_item(menu, "Random Weapon", ::give_random_weapon_menu);
        add_menu_item(menu, "Upgrade Current Weapon", ::upgrade_current_weapon_menu);
        add_menu_item(menu, "Group 1", ::open_weapons_submenu_1);
        add_menu_item(menu, "Group 2", ::open_weapons_submenu_2);
        add_menu_item(menu, "Group 3", ::open_weapons_submenu_3);
        add_menu_item(menu, "Group 4", ::open_weapons_submenu_4);
        add_menu_item(menu, "Group 5", ::open_weapons_submenu_5);
        add_menu_item(menu, "Back", ::menu_go_back_to_player);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Función para dar arma aleatoria desde el menú
give_random_weapon_menu()
{
    self thread scripts\zm\weapon::GiveRandomWeapon();
}

// Función para mejorar el arma actual desde el menú
upgrade_current_weapon_menu()
{
    self thread scripts\zm\weapon::Upgrade_arma(undefined);
}

// Submenú 1 - Armas 1-7
open_weapons_submenu_1()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 1" : "WEAPONS - GROUP 1";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    // Añadir las primeras 7 armas de la lista del mapa
    for (i = 1; i <= 7 && i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Submenú 2 - Armas 8-14
open_weapons_submenu_2()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 2" : "WEAPONS - GROUP 2";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    for (i = 8; i <= 14 && i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Submenú 3 - Armas 15-21
open_weapons_submenu_3()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 3" : "WEAPONS - GROUP 3";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    for (i = 15; i <= 21 && i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Submenú 4 - Armas 22-28
open_weapons_submenu_4()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 4" : "WEAPONS - GROUP 4";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    for (i = 22; i <= 28 && i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Submenú 5 - Armas 29 en adelante
open_weapons_submenu_5()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ARMAS - GRUPO 5" : "WEAPONS - GROUP 5";
    menu = create_menu(title, self);
    menu.parent_menu = "weapons";
    
    for (i = 29; i <= level.weaponList.size; i++)
    {
        weapon_name = level.weaponList[i];
        display_name = get_weapon_display_name(weapon_name);
        menu.items[menu.items.size] = create_weapon_menu_item(menu, display_name, weapon_name);
    }
    
    if (self.langLEN == 0)
    {
        add_menu_item(menu, "Volver", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else
    {
        add_menu_item(menu, "Back", ::menu_go_back_to_weapons);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Función auxiliar para crear un ítem de arma en el menú
create_weapon_menu_item(menu, display_name, weapon_name)
{
    item = spawnStruct();
    
    item.item = newClientHudElem(menu.user);
    item.item.vertalign = menu.background_vertalign;
    item.item.horzalign = menu.background_horzalign;
    
    if (menu.background_horzalign == "left")
    {
        item.item.x = menu.background.x + 15;
        item.item.alignX = "left";
    }
    else if (menu.background_horzalign == "right")
    {
        item.item.x = menu.background.x - 15;
        item.item.alignX = "right";
    }
    else
    {
        item.item.x = menu.background.x;
        item.item.alignX = "center";
    }
    
    if (menu.background_vertalign == "top")
    {
        item.item.y = menu.background.y + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    else if (menu.background_vertalign == "bottom")
    {
        item.item.y = menu.background.y + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    else
    {
        total_height = menu.header_height + (menu.item_height * (menu.items.size + 1));
        item.item.y = menu.background.y - (total_height / 2) + menu.header_height + (menu.item_height * menu.items.size) + (menu.item_height / 2) - 6;
    }
    
    item.item.fontscale = 1.2;
    item.item.alpha = 1;
    
    if (menu.items.size == 0)
        item.item.color = menu.active_color;
    else
        item.item.color = menu.inactive_color;
    
    item.item setText(display_name);
    item.weapon_name = weapon_name;
    item.func = ::give_specific_weapon_menu;
    item.is_menu = false;
    
    return item;
}

// Función para dar un arma específica desde el menú
give_specific_weapon_menu()
{
    // Obtener el weapon_name del ítem seleccionado
    if (isDefined(self.menu_current) && isDefined(self.menu_current.items[self.menu_current.selected]))
    {
        weapon_name = self.menu_current.items[self.menu_current.selected].weapon_name;
        if (isDefined(weapon_name))
        {
            self thread scripts\zm\weapon::GiveSpecificWeapon(weapon_name);
        }
    }
}

// Función auxiliar para obtener nombres legibles de armas
get_weapon_display_name(weapon_name)
{
    // Eliminar el sufijo _zm para nombres más limpios
    display_name = weapon_name;
    
    // Reemplazar guiones bajos con espacios y capitalizar
    display_name = strTok(display_name, "_")[0];
    
    // Nombres especiales
    switch(weapon_name)
    {
        case "raygun_mark2_zm": return "Ray Gun Mark II";
        case "ray_gun_zm": return "Ray Gun";
        case "galil_zm": return "Galil";
        case "hamr_zm": return "HAMR";
        case "rpd_zm": return "RPD";
        case "usrpg_zm": return "RPG";
        case "m32_zm": return "M32 (War Machine)";
        case "python_zm": return "Python";
        case "judge_zm": return "Judge";
        case "ak74u_zm": return "AK74u";
        case "tar21_zm": return "TAR-21";
        case "m16_zm": return "M16";
        case "xm8_zm": return "M8A1";
        case "srm1216_zm": return "M1216";
        case "870mcs_zm": return "Remington 870";
        case "dsr50_zm": return "DSR 50";
        case "barretm82_zm": return "Barrett M82";
        case "type95_zm": return "Type 95";
        case "qcw05_zm": return "Chicom";
        case "saiga12_zm": return "S12";
        case "mp5k_zm": return "MP5K";
        case "fnfal_zm": return "FAL";
        case "kard_zm": return "Kap 40";
        case "beretta93r_zm": return "B23R";
        case "fivesevendw_zm": return "Five-Seven DW";
        case "fiveseven_zm": return "Five-Seven";
        case "rottweil72_zm": return "Olympia";
        case "saritch_zm": return "SMR";
        case "m14_zm": return "M14";
        case "knife_ballistic_zm": return "Ballistic Knife";
        case "m1911_zm": return "M1911";
        case "svu_zm": return "SVU";
        case "thompson_zm": return "Thompson";
        case "pdw57_zm": return "PDW-57";
        case "uzi_zm": return "Uzi";
        case "gl_tar21_zm": return "TAR-21 (GL)";
        case "ak47_zm": return "AK-47";
        case "lsat_zm": return "LSAT";
        case "minigun_alcatraz_zm": return "Death Machine";
        case "knife_ballistic_bowie_zm": return "Ballistic Bowie";
        case "knife_ballistic_no_melee_zm": return "Ballistic (No Melee)";
        case "blundergat_zm": return "Blundergat";
        case "blundersplat_zm": return "Acid Gat";
        case "ballista_zm": return "Ballista";
        case "ak74u_extclip_zm": return "AK74u (Ext)";
        case "mp40_zm": return "MP40";
        case "mp40_stalker_zm": return "MP40 (Stalker)";
        case "evoskorpion_zm": return "Skorpion EVO";
        case "mp44_zm": return "STG-44";
        case "scar_zm": return "SCAR";
        case "ksg_zm": return "KSG";
        case "mg08_zm": return "MG08";
        case "c96_zm": return "C96";
        case "beretta93r_extclip_zm": return "B23R (Ext)";
        case "an94_zm": return "AN-94";
        case "rnma_zm": return "Remington New Model";
        case "slowgun_zm": return "Paralyzer";
        default: return display_name;
    }
}

// Menú de Staffs (solo para Origins)
open_staffs_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "BASTONES" : "STAFFS";
    menu = create_menu(title, self);
    menu.parent_menu = "player";
    
    if (self.langLEN == 0) // Español
    {
        add_menu_item(menu, "Bastón de Fuego", ::give_staff_fire);
        add_menu_item(menu, "Bastón de Hielo", ::give_staff_ice);
        add_menu_item(menu, "Bastón de Viento", ::give_staff_wind);
        add_menu_item(menu, "Bastón de Rayo", ::give_staff_lightning);
        add_menu_item(menu, "Mejorar Bastón", ::upgrade_current_staff);
        add_menu_item(menu, "Volver", ::menu_go_back_to_player);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        add_menu_item(menu, "Fire Staff", ::give_staff_fire);
        add_menu_item(menu, "Ice Staff", ::give_staff_ice);
        add_menu_item(menu, "Wind Staff", ::give_staff_wind);
        add_menu_item(menu, "Lightning Staff", ::give_staff_lightning);
        add_menu_item(menu, "Upgrade Staff", ::upgrade_current_staff);
        add_menu_item(menu, "Back", ::menu_go_back_to_player);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Funciones para dar cada bastón
give_staff_fire()
{
    self thread scripts\zm\weapon::weapon_baston_fire();
}

give_staff_ice()
{
    self thread scripts\zm\weapon::weapon_baston_hielo();
}

give_staff_wind()
{
    self thread scripts\zm\weapon::weapon_baston_aire();
}

give_staff_lightning()
{
    self thread scripts\zm\weapon::weapon_baston_relampago();
}

// Función para mejorar el bastón actual
upgrade_current_staff()
{
    self thread scripts\zm\weapon::upgrade_baston_zm();
}

//====================================================================================
// MENÚS DE PERKS
//====================================================================================

// Menú principal de Perks
open_perks_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "PERKS" : "PERKS";
    menu = create_menu(title, self);
    menu.parent_menu = "player";
    
    // Detectar el mapa actual
    map = getDvar("ui_zm_mapstartlocation");
    
    if (self.langLEN == 0) // Español
    {
        // Perks universales (disponibles en todos los mapas)
        add_menu_item(menu, "Juggernog", ::give_perk_jugger_menu);
        add_menu_item(menu, "Speed Cola", ::give_perk_speed_menu);
        add_menu_item(menu, "Double Tap", ::give_perk_doubletap_menu);
        
        // Quick Revive (todos excepto Mob of the Dead)
        if (map != "prison" && map != "cellblock" && map != "docks" && map != "showers" && map != "rooftop")
            add_menu_item(menu, "Quick Revive", ::give_perk_revive_menu);
        
        // Stamin-Up (Transit, Buried, Die Rise, Origins)
        if (map == "transit" || map == "town" || map == "farm" || map == "busdepot" || 
            map == "processing" || map == "maze" || 
            map == "highrise" || map == "building1top" || map == "redroom" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Stamin-Up", ::give_perk_staminup_menu);
        
        // Mule Kick (Buried, Die Rise, Origins)
        if (map == "processing" || map == "maze" || 
            map == "highrise" || map == "building1top" || map == "redroom" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Mule Kick", ::give_perk_mule_menu);
        
        // Electric Cherry (Mob of the Dead, Origins)
        if (map == "prison" || map == "cellblock" || map == "docks" || map == "showers" || map == "rooftop" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Electric Cherry", ::give_perk_cherry_menu);
        
        // Deadshot (Mob of the Dead, Origins)
        if (map == "prison" || map == "cellblock" || map == "docks" || map == "showers" || map == "rooftop" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Deadshot", ::give_perk_deadshot_menu);
        
        // PhD Flopper (Solo Origins)
        if (map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "PhD Flopper", ::give_perk_phd_menu);
        
        // Vulture Aid (Solo Buried)
        if (map == "processing" || map == "maze")
            add_menu_item(menu, "Vulture Aid", ::give_perk_vulture_menu);
        
        // Tombstone (Solo Transit)
        if (map == "transit" || map == "town" || map == "farm" || map == "busdepot")
            add_menu_item(menu, "Tombstone", ::give_perk_tombstone_menu);
        
        // Who's Who (Solo Die Rise)
        if (map == "highrise" || map == "building1top" || map == "redroom")
            add_menu_item(menu, "Who's Who", ::give_perk_whoswho_menu);
        
        add_menu_item(menu, "Todos los Perks", ::give_all_perks_menu);
        add_menu_item(menu, "Volver", ::menu_go_back_to_player);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Perks universales (disponibles en todos los mapas)
        add_menu_item(menu, "Juggernog", ::give_perk_jugger_menu);
        add_menu_item(menu, "Speed Cola", ::give_perk_speed_menu);
        add_menu_item(menu, "Double Tap", ::give_perk_doubletap_menu);
        
        // Quick Revive (todos excepto Mob of the Dead)
        if (map != "prison" && map != "cellblock" && map != "docks" && map != "showers" && map != "rooftop")
            add_menu_item(menu, "Quick Revive", ::give_perk_revive_menu);
        
        // Stamin-Up (Transit, Buried, Die Rise, Origins)
        if (map == "transit" || map == "town" || map == "farm" || map == "busdepot" || 
            map == "processing" || map == "maze" || 
            map == "highrise" || map == "building1top" || map == "redroom" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Stamin-Up", ::give_perk_staminup_menu);
        
        // Mule Kick (Buried, Die Rise, Origins)
        if (map == "processing" || map == "maze" || 
            map == "highrise" || map == "building1top" || map == "redroom" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Mule Kick", ::give_perk_mule_menu);
        
        // Electric Cherry (Mob of the Dead, Origins)
        if (map == "prison" || map == "cellblock" || map == "docks" || map == "showers" || map == "rooftop" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Electric Cherry", ::give_perk_cherry_menu);
        
        // Deadshot (Mob of the Dead, Origins)
        if (map == "prison" || map == "cellblock" || map == "docks" || map == "showers" || map == "rooftop" ||
            map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "Deadshot", ::give_perk_deadshot_menu);
        
        // PhD Flopper (Solo Origins)
        if (map == "tomb" || map == "trenches" || map == "crazyplace")
            add_menu_item(menu, "PhD Flopper", ::give_perk_phd_menu);
        
        // Vulture Aid (Solo Buried)
        if (map == "processing" || map == "maze")
            add_menu_item(menu, "Vulture Aid", ::give_perk_vulture_menu);
        
        // Tombstone (Solo Transit)
        if (map == "transit" || map == "town" || map == "farm" || map == "busdepot")
            add_menu_item(menu, "Tombstone", ::give_perk_tombstone_menu);
        
        // Who's Who (Solo Die Rise)
        if (map == "highrise" || map == "building1top" || map == "redroom")
            add_menu_item(menu, "Who's Who", ::give_perk_whoswho_menu);
        
        add_menu_item(menu, "All Perks", ::give_all_perks_menu);
        add_menu_item(menu, "Back", ::menu_go_back_to_player);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Funciones individuales para dar cada perk desde el menú
give_perk_jugger_menu()
{
    self thread scripts\zm\weapon::give_perks_jugger();
}

give_perk_revive_menu()
{
    self thread scripts\zm\weapon::give_perks_revive();
}

give_perk_speed_menu()
{
    self thread scripts\zm\weapon::give_perks_speed();
}

give_perk_doubletap_menu()
{
    self thread scripts\zm\weapon::give_perks_dobletap();
}

give_perk_staminup_menu()
{
    self thread scripts\zm\weapon::give_perks_correr();
}

give_perk_mule_menu()
{
    self thread scripts\zm\weapon::give_perks_mule();
}

give_perk_cherry_menu()
{
    self thread scripts\zm\weapon::give_perks_cherry();
}

give_perk_deadshot_menu()
{
    self thread scripts\zm\weapon::give_perks_deashot();
}

give_perk_phd_menu()
{
    self thread scripts\zm\weapon::give_perks_phd();
}

give_perk_vulture_menu()
{
    self thread scripts\zm\weapon::give_perk_sensor();
}

give_perk_tombstone_menu()
{
    self thread scripts\zm\weapon::give_perk_tumba();
}

give_perk_whoswho_menu()
{
    self thread scripts\zm\weapon::give_perk_whoswho();
}

give_all_perks_menu()
{
    self thread scripts\zm\weapon::func_GiveAllPerks();
}

//====================================================================================
// MENÚ DE ENEMIGOS ESPECIALES
//====================================================================================

// Menú principal de Enemigos Especiales
open_enemies_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");
    
    self notify("destroy_current_menu");
    wait 0.1;
    
    title = (self.langLEN == 0) ? "ENEMIGOS ESPECIALES" : "SPECIAL ENEMIES";
    menu = create_menu(title, self);
    menu.parent_menu = "zombie";
    
    // Detectar el mapa actual
    map = getDvar("ui_zm_mapstartlocation");
    
    if (self.langLEN == 0) // Español
    {
        // Panzer Soldat (Solo Origins)
        if (map == "tomb")
        {
            add_menu_item(menu, "Spawn Panzer Soldat", ::spawn_panzer_menu);
        }

        add_menu_item(menu, "Volver", ::menu_go_back_to_zombie);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Panzer Soldat (Solo Origins)
        if (map == "tomb")
        {
            add_menu_item(menu, "Spawn Panzer Soldat", ::spawn_panzer_menu);
        }

        add_menu_item(menu, "Back", ::menu_go_back_to_zombie);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }
    
    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);
    
    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }
    
    self thread menu_control(menu);
}

// Funciones para spawnear enemigos

spawn_panzer_menu()
{
    self thread scripts\zm\weapon::spawn_panzer_soldat();
    if(self.langLEN == 0)
    {
        self iPrintlnBold("^3Panzer Soldat a respawneado");
    }
    else
    {
        self iPrintlnBold("^3Panzer Soldat spawned");
    }
}

spawn_hellhound_menu()
{
    self thread scripts\zm\weapon::spawn_hellhounds(1);
}

spawn_dog_round_menu()
{
    self thread scripts\zm\weapon::spawn_dog_round();
}


// Funciones auxiliares para volver a menús específicos
menu_go_back_to_weapons()
{
    if (isDefined(self.is_going_back))
        return;
    
    self.is_going_back = true;
    
    self notify("destroy_current_menu");
    wait 0.2;
    
    self thread open_weapons_menu();
    
    wait 0.5;
    self.is_going_back = undefined;
}

// Función para volver al menú principal
menu_go_back_to_main()
{
    if (isDefined(self.is_going_back))
        return;

    self.is_going_back = true;

    self notify("destroy_current_menu");
    wait 0.2;

    self thread open_main_menu();

    wait 0.5;
    self.is_going_back = undefined;
}

// Función para volver al menú developer
menu_go_back_to_developer()
{
    if (isDefined(self.is_going_back))
        return;
    
    self.is_going_back = true;
    
    self notify("destroy_current_menu");
    wait 0.2;
    
    self thread open_developer_menu();
    
    wait 0.5;
    self.is_going_back = undefined;
}

// Función para volver al menú de Mods Littlegods
menu_go_back_to_mods_littlegods()
{
    if (isDefined(self.is_going_back))
        return;

    self.is_going_back = true;

    self notify("destroy_current_menu");
    wait 0.2;

    self thread open_mods_littlegods_menu();

    wait 0.5;
    self.is_going_back = undefined;
}

// Función para volver al menú de Jugador
menu_go_back_to_player()
{
    if (isDefined(self.is_going_back))
        return;

    self.is_going_back = true;

    self notify("destroy_current_menu");
    wait 0.2;

    self thread open_player_menu();

    wait 0.5;
    self.is_going_back = undefined;
}

// Función para volver al menú de Zombie
menu_go_back_to_zombie()
{
    if (isDefined(self.is_going_back))
        return;

    self.is_going_back = true;

    self notify("destroy_current_menu");
    wait 0.2;

    self thread open_zombie_menu();

    wait 0.5;
    self.is_going_back = undefined;
}

// Función para volver al menú de Mapa
menu_go_back_to_map()
{
    if (isDefined(self.is_going_back))
        return;

    self.is_going_back = true;

    self notify("destroy_current_menu");
    wait 0.2;

    self thread open_map_menu();

    wait 0.5;
    self.is_going_back = undefined;
}


//====================================================================================
// MENÚ DE PARTIDAS RECIENTES
//====================================================================================

// Menú para ver estadísticas guardadas
open_recent_matches_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "PARTIDAS RECIENTES" : "RECENT MATCHES";
    menu = create_menu(title, self);
    menu.parent_menu = "main";

    // Obtener datos del jugador y mapa (igual que sqllocal.gsc)
    map_name = getDvar("ui_zm_mapstartlocation");
    player_guid = self getGuid();

    // Inicializar índice de partida reciente si no existe
    if (!isDefined(self.recent_match_index))
        self.recent_match_index = 0;

    // Información básica del jugador
    player_info = (self.langLEN == 0) ? "Jugador: " + self.name : "Player: " + self.name;
    map_info = (self.langLEN == 0) ? "Mapa: " + get_map_display_name_recent(map_name) : "Map: " + get_map_display_name_recent(map_name);

    if (self.langLEN == 0) // Español
    {
        add_menu_item(menu, player_info, ::do_nothing);
        add_menu_item(menu, map_info, ::do_nothing);
        add_menu_item(menu, "", ::do_nothing); // Espacio

        // Mostrar información de la partida actual usando el index
        recent_files = get_recent_match_files(player_guid, map_name);

        if (isDefined(recent_files) && recent_files.size > 0)
        {
            // Calcular qué partida mostrar (basado en el índice)
            display_index = self.recent_match_index;
            if (display_index >= recent_files.size)
                display_index = 0;

            total_matches = recent_files.size;
            current_match = display_index + 1;

            // Información de navegación y estadísticas compactas
            if (total_matches > 1)
            {
                nav_info = "Partida " + current_match + " de " + total_matches;
                add_menu_item(menu, nav_info, ::do_nothing);
            }

            // Leer y mostrar estadísticas de la partida seleccionada (compacto)
            match_filename = "scriptdata/recent/" + player_guid + "/" + recent_files[display_index];
            if (fs_testfile(match_filename))
            {
                file = fs_fopen(match_filename, "read");
            if (isDefined(file))
            {
                file_size = fs_length(file);
                content = fs_read(file, file_size);
                fs_fclose(file);

                    // Parsear el contenido
                lines = strTok(content, "\n");
                    round_num = "0";
                    kills = "0";
                    headshots = "0";
                    revives = "0";
                    downs = "0";
                    score = "0";
                    time_info = "N/A";

                foreach (line in lines)
                {
                    if (isSubStr(line, "Ronda Alcanzada:"))
                        round_num = getSubStr(line, 17);
                    else if (isSubStr(line, "Kills:"))
                        kills = getSubStr(line, 7);
                    else if (isSubStr(line, "Headshots:"))
                        headshots = getSubStr(line, 11);
                    else if (isSubStr(line, "Revives:"))
                        revives = getSubStr(line, 9);
                    else if (isSubStr(line, "Downs:"))
                        downs = getSubStr(line, 7);
                    else if (isSubStr(line, "Score Total:"))
                        score = getSubStr(line, 13);
                        else if (isSubStr(line, "Fecha/Hora:"))
                            time_info = getSubStr(line, 11);
                    }

                    // Mostrar información agrupada (más compacto)
                    add_menu_item(menu, "Ronda: " + round_num + " | Score: " + score, ::do_nothing);
                    add_menu_item(menu, "Kills: " + kills + " | HS: " + headshots + " | Revives: " + revives, ::do_nothing);
                    add_menu_item(menu, "Downs: " + downs + " | Fecha: " + time_info, ::do_nothing);
                    }
                }

            // Agregar controles de navegación si hay más de una partida
            if (total_matches > 1)
            {
                add_menu_item(menu, "", ::do_nothing); // Espacio
                add_menu_item(menu, "Cambiar a Partida Anterior", ::cycle_recent_match_back);
                add_menu_item(menu, "Cambiar a Partida Siguiente", ::cycle_recent_match_forward);
            }
        }
        else
        {
            add_menu_item(menu, "NO HAY PARTIDAS RECIENTES", ::do_nothing);
            add_menu_item(menu, "Completa una partida para guardar estadísticas", ::do_nothing);
        }

        add_menu_item(menu, "", ::do_nothing); // Espacio
        add_menu_item(menu, "Volver", ::menu_go_back_to_main);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        add_menu_item(menu, player_info, ::do_nothing);
        add_menu_item(menu, map_info, ::do_nothing);
        add_menu_item(menu, "", ::do_nothing); // Espacio

        // Mostrar información de la partida actual usando el index
        recent_files = get_recent_match_files(player_guid, map_name);

        if (isDefined(recent_files) && recent_files.size > 0)
        {
            // Calcular qué partida mostrar (basado en el índice)
            display_index = self.recent_match_index;
            if (display_index >= recent_files.size)
                display_index = 0;

            total_matches = recent_files.size;
            current_match = display_index + 1;

            // Información de navegación y estadísticas compactas
            if (total_matches > 1)
            {
                nav_info = "Match " + current_match + " of " + total_matches;
                add_menu_item(menu, nav_info, ::do_nothing);
            }

            // Leer y mostrar estadísticas de la partida seleccionada (compacto)
            match_filename = "scriptdata/recent/" + player_guid + "/" + recent_files[display_index];
            if (fs_testfile(match_filename))
            {
                file = fs_fopen(match_filename, "read");
            if (isDefined(file))
            {
                file_size = fs_length(file);
                content = fs_read(file, file_size);
                fs_fclose(file);

                    // Parsear el contenido
                lines = strTok(content, "\n");
                    round_num = "0";
                    kills = "0";
                    headshots = "0";
                    revives = "0";
                    downs = "0";
                    score = "0";
                    time_info = "N/A";

                foreach (line in lines)
                {
                    if (isSubStr(line, "Ronda Alcanzada:"))
                        round_num = getSubStr(line, 17);
                    else if (isSubStr(line, "Kills:"))
                        kills = getSubStr(line, 7);
                    else if (isSubStr(line, "Headshots:"))
                        headshots = getSubStr(line, 11);
                    else if (isSubStr(line, "Revives:"))
                        revives = getSubStr(line, 9);
                    else if (isSubStr(line, "Downs:"))
                        downs = getSubStr(line, 7);
                    else if (isSubStr(line, "Score Total:"))
                        score = getSubStr(line, 13);
                        else if (isSubStr(line, "Fecha/Hora:"))
                            time_info = getSubStr(line, 11);
                    }

                    // Mostrar información agrupada (más compacto)
                    add_menu_item(menu, "Round: " + round_num + " | Score: " + score, ::do_nothing);
                    add_menu_item(menu, "Kills: " + kills + " | HS: " + headshots + " | Revives: " + revives, ::do_nothing);
                    add_menu_item(menu, "Downs: " + downs + " | Date: " + time_info, ::do_nothing);
                    }
                }

            // Agregar controles de navegación si hay más de una partida
            if (total_matches > 1)
            {
                add_menu_item(menu, "", ::do_nothing); // Espacio
                add_menu_item(menu, "Switch to Previous Match", ::cycle_recent_match_back);
                add_menu_item(menu, "Switch to Next Match", ::cycle_recent_match_forward);
            }
        }
        else
        {
            add_menu_item(menu, "NO RECENT MATCHES", ::do_nothing);
            add_menu_item(menu, "Complete a match to save statistics", ::do_nothing);
        }

        add_menu_item(menu, "", ::do_nothing); // Espacio
        add_menu_item(menu, "Back", ::menu_go_back_to_main);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

// Función para obtener la lista de archivos de partidas recientes
get_recent_match_files(player_guid, map_name)
{
    // Leer el archivo de índice para saber cuántas partidas hay
    index_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "_index.txt";

    if (!fs_testfile(index_filename))
    {
        return [];
    }

    // Leer el último número
    file = fs_fopen(index_filename, "read");
    if (!isDefined(file))
    {
        return [];
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    last_match_number = int(content);

    // Crear lista de archivos existentes (del último hacia atrás, máximo 10)
    files = [];
    for (i = last_match_number; i > 0 && files.size < 10; i--)
    {
        filename = map_name + "_recent_" + i + ".txt";
        full_path = "scriptdata/recent/" + player_guid + "/" + filename;

        if (fs_testfile(full_path))
        {
            files[files.size] = filename;
        }
    }

    return files;
}

// Función para cambiar a la partida anterior
cycle_recent_match_back()
{
    if (!isDefined(self.recent_match_index))
        self.recent_match_index = 0;

    map_name = getDvar("ui_zm_mapstartlocation");
    player_guid = self getGuid();

    recent_files = get_recent_match_files(player_guid, map_name);

    if (recent_files.size <= 1)
        return;

    self.recent_match_index--;

    // Si llega al principio, ir al final
    if (self.recent_match_index < 0)
        self.recent_match_index = recent_files.size - 1;

    // Cambiar inmediatamente a la nueva partida (tiempo real)
    self change_recent_match_instantly(recent_files);
}

// Función para cambiar a la siguiente partida
cycle_recent_match_forward()
{
    if (!isDefined(self.recent_match_index))
        self.recent_match_index = 0;

    map_name = getDvar("ui_zm_mapstartlocation");
    player_guid = self getGuid();

    recent_files = get_recent_match_files(player_guid, map_name);

    if (recent_files.size <= 1)
        return;

    self.recent_match_index++;

    // Si llega al final, volver al principio
    if (self.recent_match_index >= recent_files.size)
        self.recent_match_index = 0;

    // Cambiar inmediatamente a la nueva partida (tiempo real)
    self change_recent_match_instantly(recent_files);
}

// Función para cambiar inmediatamente a otra partida (efecto tiempo real)
change_recent_match_instantly(recent_files)
{
    // Destruir el menú actual inmediatamente
    if (isDefined(self.menu_current))
    {
        // Destruir título
        if (isDefined(self.menu_current.title_text))
            self.menu_current.title_text destroy();
        if (isDefined(self.menu_current.title_shadow))
            self.menu_current.title_shadow destroy();

        // Destruir todos los elementos del menú
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (isDefined(self.menu_current.items[i]))
            {
                if (isDefined(self.menu_current.items[i].item))
                    self.menu_current.items[i].item destroy();
                if (isDefined(self.menu_current.items[i].background))
                    self.menu_current.items[i].background destroy();
            }
        }

        // Destruir barra de selección
        if (isDefined(self.menu_current.selection_bar))
            self.menu_current.selection_bar destroy();

        // Limpiar referencias
        self.menu_current = undefined;
        self notify("menu_destroyed");
    }

    // Recrear el menú inmediatamente con la nueva partida
    wait 0.01; // Pequeño delay para asegurar que se destruya
    self thread open_recent_matches_menu();

    // Reproducir sonido de navegación
    self playsound("menu_click");
}

// Función para obtener el nombre display del mapa para partidas recientes
get_map_display_name_recent(map_code)
{
    switch (map_code)
    {
        case "tomb": return "Origins";
        case "transit": return "Transit";
        case "processing": return "Buried";
        case "prison": return "Mob of the Dead";
        case "nuked": return "Nuketown";
        case "highrise": return "Die Rise";
        case "town": return "Town (Transit)";
        case "farm": return "Farm (Transit)";
        case "busdepot": return "Bus Depot (Transit)";
        case "diner": return "Diner (Buried)";
        case "cornfield": return "Cornfield (Buried)";
        case "cellblock": return "Cellblock (Mob of the Dead)";
        default: return map_code;
    }
}

//====================================================================================
// MENÚ DEL BANCO
//====================================================================================

// Menú principal del banco
open_bank_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "BANCO" : "BANK";
    menu = create_menu(title, self);
    menu.parent_menu = "map";

    // Inicializar cantidad si no existe
    if (!isDefined(self.bank_amount))
    {
        self.bank_amount = 1000;
    }

    // Mostrar balance actual
    current_balance = scripts\zm\sqllocal::get_bank_balance(self);
    balance_text = (self.langLEN == 0) ? "Balance: " + current_balance + " puntos" : "Balance: " + current_balance + " points";
    amount_text = (self.langLEN == 0) ? "Cantidad: " + self.bank_amount + " puntos" : "Amount: " + self.bank_amount + " points";

    if (self.langLEN == 0) // Español
    {
        add_menu_item(menu, balance_text, ::do_nothing);
        add_menu_item(menu, amount_text, ::do_nothing);
        add_menu_item(menu, "[+] Incrementar 1000", ::bank_increase_1000);
        add_menu_item(menu, "[-] Decrementar 1000", ::bank_decrease_1000);
        add_menu_item(menu, "Depositar Cantidad", ::bank_deposit_selected);
        add_menu_item(menu, "Retirar Cantidad", ::bank_withdraw_selected);
        add_menu_item(menu, "Depositar Todo", ::bank_deposit_all);
        add_menu_item(menu, "Retirar Todo", ::bank_withdraw_all);
        add_menu_item(menu, "Volver", ::menu_go_back_to_map);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        add_menu_item(menu, balance_text, ::do_nothing);
        add_menu_item(menu, amount_text, ::do_nothing);
        add_menu_item(menu, "[+] Increase 1000", ::bank_increase_1000);
        add_menu_item(menu, "[-] Decrease 1000", ::bank_decrease_1000);
        add_menu_item(menu, "Deposit Amount", ::bank_deposit_selected);
        add_menu_item(menu, "Withdraw Amount", ::bank_withdraw_selected);
        add_menu_item(menu, "Deposit All", ::bank_deposit_all);
        add_menu_item(menu, "Withdraw All", ::bank_withdraw_all);
        add_menu_item(menu, "Back", ::menu_go_back_to_map);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

// Funciones del banco

// Incrementar cantidad en 1000
bank_increase_1000()
{
    if (!isDefined(self.bank_amount))
        self.bank_amount = 1000;

    // Limitar máximo a 100,000 para evitar números muy grandes
    if (self.bank_amount < 100000)
    {
        self.bank_amount += 1000;
    }

    // Actualizar el menú en tiempo real
    update_bank_menu_display();
}

// Decrementar cantidad en 1000
bank_decrease_1000()
{
    if (!isDefined(self.bank_amount))
        self.bank_amount = 1000;

    // Mínimo 1000
    if (self.bank_amount > 1000)
    {
        self.bank_amount -= 1000;
    }

    // Actualizar el menú en tiempo real
    update_bank_menu_display();
}

// Depositar la cantidad seleccionada
bank_deposit_selected()
{
    if (!isDefined(self.bank_amount) || self.bank_amount <= 0)
    {
        self.bank_amount = 1000;
    }

    self thread scripts\zm\sqllocal::bank_deposit(self, self.bank_amount);
    wait 0.5;

    // Actualizar el menú en tiempo real después de la transacción
    update_bank_menu_display();
}

// Retirar la cantidad seleccionada
bank_withdraw_selected()
{
    if (!isDefined(self.bank_amount) || self.bank_amount <= 0)
    {
        self.bank_amount = 1000;
    }

    self thread scripts\zm\sqllocal::bank_withdraw(self, self.bank_amount);
    wait 0.5;

    // Actualizar el menú en tiempo real después de la transacción
    update_bank_menu_display();
}

// Depositar todo (mantiene funcionalidad anterior)
bank_deposit_all()
{
    self thread scripts\zm\sqllocal::bank_deposit_all(self);
    wait 0.5;

    // Actualizar el menú en tiempo real después de la transacción
    update_bank_menu_display();
}

// Retirar todo (mantiene funcionalidad anterior)
bank_withdraw_all()
{
    self thread scripts\zm\sqllocal::bank_withdraw_all(self);
    wait 0.5;

    // Actualizar el menú en tiempo real después de la transacción
    update_bank_menu_display();
}

// Función dummy para elementos no interactivos
do_nothing()
{
    // No hace nada, solo para mostrar información
}

// Función para actualizar la visualización del menú del banco en tiempo real
update_bank_menu_display()
{
    // Evitar múltiples actualizaciones simultáneas
    if (isDefined(self.is_updating_bank_display))
        return;

    self.is_updating_bank_display = true;

    // Esperar un poco para que las operaciones de base de datos se completen
    wait 0.1;

    if (isDefined(self.menu_current))
    {
        // Obtener balance actualizado
        current_balance = scripts\zm\sqllocal::get_bank_balance(self);

        // Actualizar texto del balance (primer elemento del menú)
        balance_text = (self.langLEN == 0) ? "Balance: " + current_balance + " puntos" : "Balance: " + current_balance + " points";
        if (self.menu_current.items.size > 0)
        {
            self.menu_current.items[0].item setText(balance_text);
        }

        // Actualizar texto de la cantidad (segundo elemento del menú)
        amount_text = (self.langLEN == 0) ? "Cantidad: " + self.bank_amount + " puntos" : "Amount: " + self.bank_amount + " points";
        if (self.menu_current.items.size > 1)
        {
            self.menu_current.items[1].item setText(amount_text);
        }
    }

    self.is_updating_bank_display = undefined;
}

//====================================================================================
// MENÚ JUGADOR (DEVELOPER)
//====================================================================================

// Menú de opciones del jugador
open_player_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "JUGADOR" : "PLAYER";
    menu = create_menu(title, self);
    menu.parent_menu = "developer";

    // Detectar el mapa actual para opciones específicas
    map = getDvar("ui_zm_mapstartlocation");

    if (self.langLEN == 0) // Español
    {
        // Opción para activar/desactivar God Mode
        godmode_status = self.godmode_enabled ? "ON" : "OFF";
        add_menu_item(menu, "God Mode: " + godmode_status, scripts\zm\funciones::toggle_godmode);

        // Opción para dar dinero
        add_menu_item(menu, "Dar 10k Puntos", scripts\zm\funciones::give_10k_points);

        // Opción Velocidad x2
        speed_status = self.speed_boost_enabled ? "ON" : "OFF";
        add_menu_item(menu, "Velocidad x2: " + speed_status, scripts\zm\funciones::toggle_speed);

        super_jump_status = (isDefined(self.super_jump_enabled) && self.super_jump_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Super Jump: " + super_jump_status, scripts\zm\funciones::toggle_super_jump);

        // Menú de teleport
        add_menu_item(menu, "Teleport", ::open_teleport_menu);

        // Menú de powerups
        add_menu_item(menu, "Powerups", ::open_powerups_menu);

        // Menú de armas
        add_menu_item(menu, "Armas", ::open_weapons_menu);

        // Menú de perks
        add_menu_item(menu, "Perks", ::open_perks_menu);

        // Menú de mods avanzados
        add_menu_item(menu, "Mods Avanzados", ::open_advanced_mods_menu);

        // Si es el mapa Origins, añadir menú de bastones
        if (map == "tomb")
            add_menu_item(menu, "Bastones", ::open_staffs_menu);

        add_menu_item(menu, "Volver", ::menu_go_back_to_developer);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Opción para activar/desactivar God Mode
        godmode_status = self.godmode_enabled ? "ON" : "OFF";
        add_menu_item(menu, "God Mode: " + godmode_status, scripts\zm\funciones::toggle_godmode);

        // Opción para dar dinero
        add_menu_item(menu, "Give 10k Points", scripts\zm\funciones::give_10k_points);

        // Opción Velocidad x2
        speed_status = self.speed_boost_enabled ? "ON" : "OFF";
        add_menu_item(menu, "Speed x2: " + speed_status, scripts\zm\funciones::toggle_speed);

        super_jump_status = (isDefined(self.super_jump_enabled) && self.super_jump_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Super Jump: " + super_jump_status, scripts\zm\funciones::toggle_super_jump);

        // Menú de teleport
        add_menu_item(menu, "Teleport", ::open_teleport_menu);

        // Menú de powerups
        add_menu_item(menu, "Powerups", ::open_powerups_menu);

        // Menú de armas
        add_menu_item(menu, "Weapons", ::open_weapons_menu);

        // Menú de perks
        add_menu_item(menu, "Perks", ::open_perks_menu);

        // Si es el mapa Origins, añadir menú de bastones
        if (map == "tomb")
            add_menu_item(menu, "Staffs", ::open_staffs_menu);

        add_menu_item(menu, "Back", ::menu_go_back_to_developer);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

//====================================================================================
// MENÚ ZOMBIE (DEVELOPER)
//====================================================================================

// Menú de opciones de zombies
open_zombie_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "ZOMBIE" : "ZOMBIE";
    menu = create_menu(title, self);
    menu.parent_menu = "developer";

    // Inicializar la ronda objetivo si no existe
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;

    // Verificar si el mapa actual permite enemigos especiales (solo Origins)
    current_map = getDvar("ui_zm_mapstartlocation");
    has_special_enemies = (current_map == "tomb");

    if (self.langLEN == 0) // Español
    {
        // Opciones para cambiar rondas
        add_menu_item(menu, "Avanzar Ronda", scripts\zm\funciones::advance_round);
        add_menu_item(menu, "Retroceder Ronda", scripts\zm\funciones::go_back_round);
        add_menu_item(menu, "Round 255", scripts\zm\funciones::set_round_255);
        add_menu_item(menu, "Aplicar Ronda: " + self.target_round, scripts\zm\funciones::apply_round_change);

        // Opciones de control de zombies
        zombie_freeze_status = (isDefined(self.Fr3ZzZoM) && self.Fr3ZzZoM) ? "ON" : "OFF";
        add_menu_item(menu, "Zombie Freeze: " + zombie_freeze_status, scripts\zm\funciones::Fr3ZzZoM);
        add_menu_item(menu, "Kill All Zombies", scripts\zm\funciones::kill_all_zombies);

        teleport_zombies_status = (isDefined(self.teleport_zombies_enabled) && self.teleport_zombies_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Teleport Zombies: " + teleport_zombies_status, scripts\zm\funciones::toggle_teleport_zombies);

        disable_zombies_status = (isDefined(self.disable_zombies_enabled) && self.disable_zombies_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Disable Zombies: " + disable_zombies_status, scripts\zm\funciones::toggle_disable_zombies);


        // Menú de enemigos especiales (solo para Origins y Mob of the Dead)
        if (has_special_enemies)
        {
            add_menu_item(menu, "Enemigos Especiales", ::open_enemies_menu);
        }

        add_menu_item(menu, "Volver", ::menu_go_back_to_developer);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Opciones para cambiar rondas
        add_menu_item(menu, "Advance Round", scripts\zm\funciones::advance_round);
        add_menu_item(menu, "Go Back Round", scripts\zm\funciones::go_back_round);
        add_menu_item(menu, "Round 255", scripts\zm\funciones::set_round_255);
        add_menu_item(menu, "Apply Round: " + self.target_round, scripts\zm\funciones::apply_round_change);

        // Opciones de control de zombies
        zombie_freeze_status = (isDefined(self.Fr3ZzZoM) && self.Fr3ZzZoM) ? "ON" : "OFF";
        add_menu_item(menu, "Zombie Freeze: " + zombie_freeze_status, scripts\zm\funciones::Fr3ZzZoM);
        add_menu_item(menu, "Kill All Zombies", scripts\zm\funciones::kill_all_zombies);

        teleport_zombies_status = (isDefined(self.teleport_zombies_enabled) && self.teleport_zombies_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Teleport Zombies: " + teleport_zombies_status, scripts\zm\funciones::toggle_teleport_zombies);

        disable_zombies_status = (isDefined(self.disable_zombies_enabled) && self.disable_zombies_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Disable Zombies: " + disable_zombies_status, scripts\zm\funciones::toggle_disable_zombies);

        // Menú de enemigos especiales (solo para Origins y Mob of the Dead)
        if (has_special_enemies)
        {
            add_menu_item(menu, "Special Enemies", ::open_enemies_menu);
        }

        add_menu_item(menu, "Back", ::menu_go_back_to_developer);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

//====================================================================================
// MENÚ MODS LITTLEGODS
//====================================================================================

// Menú principal de Mods Littlegods
open_mods_littlegods_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "MODS LITTLEGODS" : "MODS LITTLEGODS";
    menu = create_menu(title, self);
    menu.parent_menu = "main";

    // Verificar estados para indicaciones visuales
    borders_active = (self.edge_animation_style_index > 0);
    healthbar_active = self.healthbar_enabled;
    healthbarzombie_active = self.healthbarzombie_enabled;
    legacy_mods_active = are_legacy_mods_active();

    if (self.langLEN == 0) // Español
    {
        add_menu_item(menu, "Night Mode", ::open_night_mode_menu);

        // Agregar opción de barra de vida y marcarla en rojo si no está disponible
        healthbar_item = add_menu_item(menu, "Barra de Vida", ::open_healthbar_menu);
        if ((borders_active && !self.healthbar_enabled) || (healthbarzombie_active && !self.healthbar_enabled) || (legacy_mods_active && !self.healthbar_enabled))
        {
            healthbar_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Agregar opción de barra zombie y marcarla en rojo si no está disponible
        zombie_bar_item =         add_menu_item(menu, "Barra Zombie", ::open_healthbarzombie_menu);
        if ((borders_active && !self.healthbarzombie_enabled) || (healthbar_active && !self.healthbarzombie_enabled) || (legacy_mods_active && !self.healthbarzombie_enabled))
        {
            zombie_bar_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Nuevos mods de rendimiento
        add_menu_item(menu, "Heredado Mods", ::open_performance_mods_menu);

        add_menu_item(menu, "Volver", ::menu_go_back_to_main);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        add_menu_item(menu, "Night Mode", ::open_night_mode_menu);

        // Agregar opción de barra de vida y marcarla en rojo si no está disponible
        healthbar_item = add_menu_item(menu, "Health Bar", ::open_healthbar_menu);
        if ((borders_active && !self.healthbar_enabled) || (healthbarzombie_active && !self.healthbar_enabled) || (legacy_mods_active && !self.healthbar_enabled))
        {
            healthbar_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Agregar opción de barra zombie y marcarla en rojo si no está disponible
        zombie_bar_item = add_menu_item(menu, "Zombie Bar", ::open_healthbarzombie_menu);
        if ((borders_active && !self.healthbarzombie_enabled) || (healthbar_active && !self.healthbarzombie_enabled) || (legacy_mods_active && !self.healthbarzombie_enabled))
        {
            zombie_bar_item.item.color = (1, 0.2, 0.2); // Rojo para indicar que no está disponible
        }

        // Nuevos mods de rendimiento
        add_menu_item(menu, "Legacy Mods", ::open_performance_mods_menu);

        add_menu_item(menu, "Back", ::menu_go_back_to_main);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

//====================================================================================


//====================================================================================
// SISTEMA DE TELEPORTACIÓN
//====================================================================================

// Función para inicializar el sistema de teleportación
init_teleport_system()
{
    if (!isDefined(self.teleport_points))
    {
        self.teleport_points = [];
        self.teleport_names = [];
        self.teleport_count = 0;
    }
}

// Función para crear un punto de teleportación
create_teleport_point(name)
{
    self endon("disconnect");

    // Inicializar sistema si no existe
    if (!isDefined(self.teleport_points))
        self thread init_teleport_system();

    // Verificar límite de puntos (máximo 5)
    if (self.teleport_count >= 5)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1Máximo de 5 puntos de teleportación alcanzado");
        else
            self iPrintLnBold("^1Maximum of 5 teleportation points reached");

        self playLocalSound("menu_error");
        return false;
    }

    // Verificar nombre único
    for (i = 0; i < self.teleport_count; i++)
    {
        if (self.teleport_names[i] == name)
        {
            if (self.langLEN == 0)
                self iPrintLnBold("^1Ya existe un punto con el nombre: ^5" + name);
            else
                self iPrintLnBold("^1A point with name ^5" + name + " ^1already exists");

            self playLocalSound("menu_error");
            return false;
        }
    }

    // Crear punto de teleportación
    point_data = spawnStruct();
    point_data.origin = self.origin;
    point_data.angles = self getPlayerAngles();

    // Agregar a arrays
    self.teleport_points[self.teleport_count] = point_data;
    self.teleport_names[self.teleport_count] = name;
    self.teleport_count++;

    // Mensaje de confirmación
    if (self.langLEN == 0)
        self iPrintLnBold("^2Punto ^5" + name + " ^2creado exitosamente");
    else
        self iPrintLnBold("^2Point ^5" + name + " ^2created successfully");

    self playLocalSound("uin_positive_feedback");
    return true;
}

// Función para listar puntos de teleportación
list_teleport_points()
{
    self endon("disconnect");

    if (!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos de teleportación guardados");
        else
            self iPrintLnBold("^1No teleportation points saved");

        return;
    }

    if (self.langLEN == 0)
        self iPrintLnBold("^5=== PUNTOS DE TELEPORTACIÓN ===");
    else
        self iPrintLnBold("^5=== TELEPORTATION POINTS ===");

    wait 0.05;

    for (i = 0; i < self.teleport_count; i++)
    {
        if (self.langLEN == 0)
            self iPrintLn("^3" + (i + 1) + ". ^5" + self.teleport_names[i]);
        else
            self iPrintLn("^3" + (i + 1) + ". ^5" + self.teleport_names[i]);

        wait 0.05;
    }

    if (self.langLEN == 0)
        self iPrintLn("^7Usa el menú para teleportarte");
    else
        self iPrintLn("^7Use the menu to teleport");

    wait 0.05;
}

// Función para teleportarse a un punto específico
teleport_to_point(index)
{
    self endon("disconnect");

    if (!isDefined(self.teleport_points) || index >= self.teleport_count || index < 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1Punto de teleportación no válido");
        else
            self iPrintLnBold("^1Invalid teleportation point");

        self playLocalSound("menu_error");
        return false;
    }

    // Teleportarse
    self setOrigin(self.teleport_points[index].origin);
    self setPlayerAngles(self.teleport_points[index].angles);

    // Mensaje de confirmación
    if (self.langLEN == 0)
        self iPrintLnBold("^2Teleportado a ^5" + self.teleport_names[index]);
    else
        self iPrintLnBold("^2Teleported to ^5" + self.teleport_names[index]);

    self playLocalSound("uin_positive_feedback");
    return true;
}

// Función para eliminar un punto específico
delete_teleport_point(index)
{
    self endon("disconnect");

    if (!isDefined(self.teleport_points) || index >= self.teleport_count || index < 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1Punto de teleportación no válido");
        else
            self iPrintLnBold("^1Invalid teleportation point");

        self playLocalSound("menu_error");
        return false;
    }

    // Obtener nombre antes de eliminar
    deleted_name = self.teleport_names[index];

    // Eliminar punto moviendo los demás hacia adelante
    for (i = index; i < self.teleport_count - 1; i++)
    {
        self.teleport_points[i] = self.teleport_points[i + 1];
        self.teleport_names[i] = self.teleport_names[i + 1];
    }

    // Limpiar último elemento
    self.teleport_points[self.teleport_count - 1] = undefined;
    self.teleport_names[self.teleport_count - 1] = undefined;
    self.teleport_count--;

    // Mensaje de confirmación
    if (self.langLEN == 0)
        self iPrintLnBold("^1Punto ^5" + deleted_name + " ^1eliminado");
    else
        self iPrintLnBold("^1Point ^5" + deleted_name + " ^1deleted");

    self playLocalSound("uin_positive_feedback");
    return true;
}

// Función para eliminar todos los puntos
delete_all_teleport_points()
{
    self endon("disconnect");

    if (!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos para eliminar");
        else
            self iPrintLnBold("^1No points to delete");

        return false;
    }

    // Limpiar todos los arrays
    self.teleport_points = [];
    self.teleport_names = [];
    self.teleport_count = 0;

    // Mensaje de confirmación
    if (self.langLEN == 0)
        self iPrintLnBold("^1Todos los puntos de teleportación eliminados");
    else
        self iPrintLnBold("^1All teleportation points deleted");

    self playLocalSound("uin_positive_feedback");
    return true;
}

// Menú principal de teleportación
open_teleport_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "TELEPORTACIÓN" : "TELEPORTATION";
    menu = create_menu(title, self);
    menu.parent_menu = "player";

    // Inicializar sistema si no existe
    if (!isDefined(self.teleport_points))
        self thread init_teleport_system();

    if (self.langLEN == 0) // Español
    {
        add_menu_item(menu, "Crear Punto", ::teleport_create_point_prompt);
        add_menu_item(menu, "Listar Puntos", ::teleport_list_points_menu);
        add_menu_item(menu, "Teleportarse", ::teleport_select_point_menu);
        add_menu_item(menu, "Eliminar Punto", ::teleport_delete_point_menu);
        add_menu_item(menu, "Eliminar Todos", ::teleport_delete_all_points);
        add_menu_item(menu, "Volver", ::menu_go_back_to_player);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        add_menu_item(menu, "Create Point", ::teleport_create_point_prompt);
        add_menu_item(menu, "List Points", ::teleport_list_points_menu);
        add_menu_item(menu, "Teleport", ::teleport_select_point_menu);
        add_menu_item(menu, "Delete Point", ::teleport_delete_point_menu);
        add_menu_item(menu, "Delete All", ::teleport_delete_all_points);
        add_menu_item(menu, "Back", ::menu_go_back_to_player);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

// Función para solicitar el nombre del punto de teleportación
teleport_create_point_prompt()
{
    self endon("disconnect");

    self notify("destroy_current_menu");
    self.menu_open = false;

    if (self.langLEN == 0)
        self iPrintLnBold("^5Escribe el nombre del punto de teleportación en el chat");
    else
        self iPrintLnBold("^5Type the teleportation point name in chat");

    self.waiting_for_teleport_name = true;
    self thread teleport_listen_for_chat_input();
}

// Función para escuchar la entrada de chat para el nombre del punto
teleport_listen_for_chat_input()
{
    self endon("disconnect");
    level endon("end_game");
    self endon("stop_teleport_name_listen");

    if (self.langLEN == 0)
        self iPrintLnBold("^3Esperando mensaje en chat...");
    else
        self iPrintLnBold("^3Waiting for chat message...");

    self thread teleport_chat_watcher();

    self waittill_any("teleport_name_received", "stop_teleport_name_listen");
}

// Función para capturar mensajes del chat para la teleportación
teleport_chat_watcher()
{
    self endon("disconnect");
    level endon("end_game");
    self endon("stop_teleport_name_listen");

    for (;;)
    {
        level waittill("say", message, player);

        if (player == self && self.waiting_for_teleport_name)
        {
            if (message.size > 15)
                message = getSubStr(message, 0, 15);

            if (self.langLEN == 0)
                self iPrintLnBold("^2Creando punto: ^7" + message);
            else
                self iPrintLnBold("^2Creating point: ^7" + message);

            wait 0.5;

            success = self create_teleport_point(message);

            self.waiting_for_teleport_name = false;
            self notify("teleport_name_received");

            wait 1.0;
            self thread open_teleport_menu();
            return;
        }
    }
}

// Función para mostrar la lista de puntos de teleportación en un menú
teleport_list_points_menu()
{
    self endon("disconnect");

    if(!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos de teleportación");
        else
            self iPrintLnBold("^1No teleportation points available");

        return;
    }

    self thread list_teleport_points();
}

// Función para seleccionar un punto para teleportarse
teleport_select_point_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    if(!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos de teleportación");
        else
            self iPrintLnBold("^1No teleportation points available");

        return;
    }

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "SELECCIONAR PUNTO" : "SELECT POINT";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    for (i = 0; i < self.teleport_count; i++)
    {
        teleport_func = self get_teleport_function(i);
        add_menu_item(menu, (i+1) + ". " + self.teleport_names[i], teleport_func);
    }

    if (self.langLEN == 0)
        add_menu_item(menu, "Volver", ::menu_go_back_to_teleport);
    else
        add_menu_item(menu, "Back", ::menu_go_back_to_teleport);

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

// Funciones de teleportación para cada índice posible
teleport_to_index_0() { self teleport_to_point(0); wait 1.0; self thread open_teleport_menu(); }
teleport_to_index_1() { self teleport_to_point(1); wait 1.0; self thread open_teleport_menu(); }
teleport_to_index_2() { self teleport_to_point(2); wait 1.0; self thread open_teleport_menu(); }
teleport_to_index_3() { self teleport_to_point(3); wait 1.0; self thread open_teleport_menu(); }
teleport_to_index_4() { self teleport_to_point(4); wait 1.0; self thread open_teleport_menu(); }

// Función para obtener la función de teleportación para un índice específico
get_teleport_function(index)
{
    switch(index)
    {
        case 0: return ::teleport_to_index_0;
        case 1: return ::teleport_to_index_1;
        case 2: return ::teleport_to_index_2;
        case 3: return ::teleport_to_index_3;
        case 4: return ::teleport_to_index_4;
        default: return ::teleport_to_index_0;
    }
}

// Función para seleccionar un punto para eliminar
teleport_delete_point_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    if(!isDefined(self.teleport_points) || self.teleport_count == 0)
    {
        if (self.langLEN == 0)
            self iPrintLnBold("^1No hay puntos de teleportación");
        else
            self iPrintLnBold("^1No teleportation points available");

        return;
    }

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "ELIMINAR PUNTO" : "DELETE POINT";
    menu = create_menu(title, self);
    menu.parent_menu = "teleport";

    for (i = 0; i < self.teleport_count; i++)
    {
        delete_func = self get_delete_function(i);
        add_menu_item(menu, (i+1) + ". " + self.teleport_names[i], delete_func);
    }

    if (self.langLEN == 0)
        add_menu_item(menu, "Volver", ::menu_go_back_to_teleport);
    else
        add_menu_item(menu, "Back", ::menu_go_back_to_teleport);

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

// Funciones de eliminación para cada índice posible
delete_point_index_0() { self delete_teleport_point(0); wait 1.0; self thread open_teleport_menu(); }
delete_point_index_1() { self delete_teleport_point(1); wait 1.0; self thread open_teleport_menu(); }
delete_point_index_2() { self delete_teleport_point(2); wait 1.0; self thread open_teleport_menu(); }
delete_point_index_3() { self delete_teleport_point(3); wait 1.0; self thread open_teleport_menu(); }
delete_point_index_4() { self delete_teleport_point(4); wait 1.0; self thread open_teleport_menu(); }

// Función para obtener la función de eliminación para un índice específico
get_delete_function(index)
{
    switch(index)
    {
        case 0: return ::delete_point_index_0;
        case 1: return ::delete_point_index_1;
        case 2: return ::delete_point_index_2;
        case 3: return ::delete_point_index_3;
        case 4: return ::delete_point_index_4;
        default: return ::delete_point_index_0;
    }
}

// Función para eliminar todos los puntos de teleportación
teleport_delete_all_points()
{
    self endon("disconnect");

    success = self delete_all_teleport_points();

    if (success)
        wait 1.0;
}

// Funciones de navegación para el menú de teleport
menu_go_back_to_teleport()
{
    if (isDefined(self.is_going_back))
        return;

    self.is_going_back = true;

    self notify("destroy_current_menu");
    wait 0.2;

    self thread open_teleport_menu();

    wait 0.1;
    self.is_going_back = undefined;
}

//====================================================================================
// MENÚ POWERUPS
//====================================================================================

// Menú de powerups
open_powerups_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "POWERUPS" : "POWERUPS";
    menu = create_menu(title, self);
    menu.parent_menu = "player";

    // Detectar el mapa actual
    current_map = getDvar("ui_zm_mapstartlocation");

    // Determinar qué powerups están disponibles según el mapa
    available_powerups = get_available_powerups_for_map(current_map);

    if (self.langLEN == 0) // Español
    {
        // Agregar powerups individuales disponibles
        for (i = 0; i < available_powerups.size; i++)
        {
            powerup_key = available_powerups[i];
            powerup_name = get_powerup_display_name(powerup_key, 0); // 0 = español
            powerup_function = get_powerup_function(powerup_key);

            add_menu_item(menu, powerup_name, powerup_function);
        }

        add_menu_item(menu, "TODOS los Powerups", scripts\zm\funciones::spawn_all_powerups);
        add_menu_item(menu, "Powerup RANDOM", scripts\zm\funciones::spawn_random_powerup);
        add_menu_item(menu, "Volver", ::menu_go_back_to_player);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Agregar powerups individuales disponibles
        for (i = 0; i < available_powerups.size; i++)
        {
            powerup_key = available_powerups[i];
            powerup_name = get_powerup_display_name(powerup_key, 1); // 1 = inglés
            powerup_function = get_powerup_function(powerup_key);

            add_menu_item(menu, powerup_name, powerup_function);
        }

        add_menu_item(menu, "ALL Powerups", scripts\zm\funciones::spawn_all_powerups);
        add_menu_item(menu, "RANDOM Powerup", scripts\zm\funciones::spawn_random_powerup);
        add_menu_item(menu, "Back", ::menu_go_back_to_player);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

// Función para obtener los powerups disponibles según el mapa
get_available_powerups_for_map(map_name)
{
    available_powerups = [];

    // Determinar qué powerups están disponibles según el mapa
    if (map_name == "nuke") // Nuketown
    {
        available_powerups[0] = "nuke";
        available_powerups[1] = "double_points";
        available_powerups[2] = "full_ammo";
        available_powerups[3] = "insta_kill";
        available_powerups[4] = "fire_sale";
    }
    else if (map_name == "transit" || map_name == "town" || map_name == "farm" || map_name == "diner") // Transit, Town, Farm, Diner
    {
        available_powerups[0] = "full_ammo";
        available_powerups[1] = "insta_kill";
        available_powerups[2] = "carpenter";
        available_powerups[3] = "double_points";
        available_powerups[4] = "nuke";
    }
    else if (map_name == "buried") // Buried - todos menos death machine
    {
        available_powerups[0] = "full_ammo";
        available_powerups[1] = "insta_kill";
        available_powerups[2] = "carpenter";
        available_powerups[3] = "double_points";
        available_powerups[4] = "fire_sale";
        available_powerups[5] = "nuke";
    }
    else if (map_name == "tomb") // Origins - todos menos death machine y carpenter, pero incluye zombie blood
    {
        available_powerups[0] = "full_ammo";
        available_powerups[1] = "insta_kill";
        available_powerups[2] = "double_points";
        available_powerups[3] = "fire_sale";
        available_powerups[4] = "nuke";
        available_powerups[5] = "zombie_blood";
    }
    else if (map_name == "prison") // Mob
    {
        available_powerups[0] = "nuke";
        available_powerups[1] = "double_points";
        available_powerups[2] = "full_ammo";
        available_powerups[3] = "insta_kill";
        available_powerups[4] = "fire_sale";
    }
    else // Mapas por defecto - todos disponibles
    {
        available_powerups[0] = "full_ammo";
        available_powerups[1] = "insta_kill";
        available_powerups[2] = "carpenter";
        available_powerups[3] = "double_points";
        available_powerups[4] = "fire_sale";
        available_powerups[5] = "nuke";
    }

    return available_powerups;
}

// Función para obtener el nombre para mostrar del powerup
get_powerup_display_name(powerup_key, language)
{
    display_names = [];

    if (language == 0) // Español
    {
        display_names["full_ammo"] = "Max Ammo";
        display_names["insta_kill"] = "Insta Kill";
        display_names["carpenter"] = "Carpenter";
        display_names["double_points"] = "Double Points";
        display_names["fire_sale"] = "Fire Sale";
        display_names["nuke"] = "Nuke";
        display_names["zombie_blood"] = "Zombie Blood";
    }
    else // Inglés
    {
        display_names["full_ammo"] = "Max Ammo";
        display_names["insta_kill"] = "Insta Kill";
        display_names["carpenter"] = "Carpenter";
        display_names["double_points"] = "Double Points";
        display_names["fire_sale"] = "Fire Sale";
        display_names["nuke"] = "Nuke";
        display_names["zombie_blood"] = "Zombie Blood";
    }

    return display_names[powerup_key];
}

// Función para obtener la función correspondiente al powerup
get_powerup_function(powerup_key)
{
    functions = [];
    functions["full_ammo"] = scripts\zm\funciones::spawn_max_ammo;
    functions["insta_kill"] = scripts\zm\funciones::spawn_insta_kill;
    functions["carpenter"] = scripts\zm\funciones::spawn_carpenter;
    functions["double_points"] = scripts\zm\funciones::spawn_double_points;
    functions["fire_sale"] = scripts\zm\funciones::spawn_fire_sale;
    functions["nuke"] = scripts\zm\funciones::spawn_nuke;
    functions["zombie_blood"] = scripts\zm\funciones::spawn_zombie_blood;

    return functions[powerup_key];
}

//====================================================================================
// MENÚ DE MODS AVANZADOS
//====================================================================================

open_advanced_mods_menu()
{
    self endon("disconnect");
    self endon("destroy_all_menus");

    self notify("destroy_current_menu");
    wait 0.1;

    title = (self.langLEN == 0) ? "MODS AVANZADOS" : "ADVANCED MODS";
    menu = create_menu(title, self);
    menu.parent_menu = "developer";

    if (self.langLEN == 0) // Español
    {
        // Funciones avanzadas del jugador
        add_menu_item(menu, "Clonar Jugador", scripts\zm\funciones::clone_player);

        gore_status = (isDefined(self.gore_enabled) && self.gore_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Gore Mode: " + gore_status, scripts\zm\funciones::toggle_gore_mode);

        add_menu_item(menu, "Abrir Todas las Puertas", scripts\zm\funciones::open_all_doors);

        add_menu_item(menu, "Kamikaze", scripts\zm\funciones::do_kamikaze);

        // Funciones de movimiento y vuelo
        ufo_status = (isDefined(self.ufo_enabled) && self.ufo_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Modo UFO: " + ufo_status, scripts\zm\funciones::toggle_ufo_mode);

        forge_status = (isDefined(self.forge_enabled) && self.forge_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Forge Mode: " + forge_status, scripts\zm\funciones::toggle_forge_mode);

        jetpack_status = (isDefined(self.jetpack_enabled) && self.jetpack_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "JetPack: " + jetpack_status, scripts\zm\funciones::toggle_jetpack);

        // Funciones de combate avanzado
        aimbot_status = (isDefined(self.aimbot_enabled) && self.aimbot_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Aimbot: " + aimbot_status, scripts\zm\funciones::toggle_aimbot);

        artillery_status = (isDefined(self.artillery_enabled) && self.artillery_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Artillery: " + artillery_status, scripts\zm\funciones::toggle_artillery);

        add_menu_item(menu, "Volver", ::menu_go_back_to_player);
        add_menu_item(menu, "Cerrar Menú", ::close_all_menus);
    }
    else // Inglés
    {
        // Advanced player functions
        add_menu_item(menu, "Clone Player", scripts\zm\funciones::clone_player);

        gore_status = (isDefined(self.gore_enabled) && self.gore_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Gore Mode: " + gore_status, scripts\zm\funciones::toggle_gore_mode);

        add_menu_item(menu, "Open All Doors", scripts\zm\funciones::open_all_doors);

        add_menu_item(menu, "Kamikaze", scripts\zm\funciones::do_kamikaze);

        // Movement and flight functions
        ufo_status = (isDefined(self.ufo_enabled) && self.ufo_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "UFO Mode: " + ufo_status, scripts\zm\funciones::toggle_ufo_mode);

        forge_status = (isDefined(self.forge_enabled) && self.forge_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Forge Mode: " + forge_status, scripts\zm\funciones::toggle_forge_mode);

        jetpack_status = (isDefined(self.jetpack_enabled) && self.jetpack_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "JetPack: " + jetpack_status, scripts\zm\funciones::toggle_jetpack);

        // Advanced combat functions
        aimbot_status = (isDefined(self.aimbot_enabled) && self.aimbot_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Aimbot: " + aimbot_status, scripts\zm\funciones::toggle_aimbot);

        artillery_status = (isDefined(self.artillery_enabled) && self.artillery_enabled) ? "ON" : "OFF";
        add_menu_item(menu, "Artillery: " + artillery_status, scripts\zm\funciones::toggle_artillery);

        add_menu_item(menu, "Back", ::menu_go_back_to_player);
        add_menu_item(menu, "Close Menu", ::close_all_menus);
    }

    show_menu(menu);
    menu = scripts\zm\style_font_position::apply_font_position(menu, self.font_position_index);

    if (isDefined(self.menu_current) && isDefined(self.menu_current.active_color))
    {
        menu.active_color = self.menu_current.active_color;
        menu.selection_bar.color = menu.active_color;
        menu.items[menu.selected].item.color = (1, 1, 1);
    }

    self thread menu_control(menu);
}

//====================================================================================
// FUNCIONES DEL MENÚ DEVELOPER
//====================================================================================
