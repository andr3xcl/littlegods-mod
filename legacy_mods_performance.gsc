// Sistema de mods de rendimiento para Little Gods Menu
// Muestra información de vida del jugador, zombies y contador
// Optimizado para evitar límite de strings usando setvalue/settext correctamente

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

// ========================================
// INICIALIZACIÓN Y CONFIGURACIÓN
// ========================================

init()
{
    // Inicializar configuraciones por defecto
    level.player_health_display = spawnStruct();
    level.zombie_health_display = spawnStruct();
    level.zombie_counter_display = spawnStruct();

    // Modo de visualización: "littlegods" o "classic"
    level.legacy_display_mode = "littlegods"; // Por defecto Littlegods

    // Configuración por defecto para vida del jugador
    level.player_health_display.enabled = false;
    level.player_health_display.x = 10;
    level.player_health_display.y = 50;
    level.player_health_display.fontscale = 1.1;
    level.player_health_display.color = (1, 1, 1); // Verde
    level.player_health_display.alpha = 1.0;
    level.player_health_display.label = "Player Health: ";
    level.player_health_display.color_gradient_enabled = false; // Toggle para degradado de colores

    // Configuración por defecto para vida del zombie
    level.zombie_health_display.enabled = false;
    level.zombie_health_display.x = 10;
    level.zombie_health_display.y = 60;
    level.zombie_health_display.fontscale = 1.1;
    level.zombie_health_display.color = (1, 1, 1); // Rojo
    level.zombie_health_display.alpha = 1.0;
    level.zombie_health_display.label = "Zombie Health: ";
    level.zombie_health_display.color_gradient_enabled = false; // Toggle para degradado de colores

    // Configuración por defecto para contador de zombies
    level.zombie_counter_display.enabled = false;
    level.zombie_counter_display.x = 10;
    level.zombie_counter_display.y = 70;
    level.zombie_counter_display.fontscale = 1.1;
    level.zombie_counter_display.color = (1, 1, 1); // Amarillo
    level.zombie_counter_display.alpha = 1.0;
    level.zombie_counter_display.label = "Zombies: ";
}

// ========================================
// FUNCIONES AUXILIARES
// ========================================

// Referencias a strings para códigos de color (necesarias para GSC)
get_health_color_code(health_percentage)
{
    // Sistema de degradado de colores basado en porcentaje de vida
    // Verde (alta vida) → Amarillo → Rojo (baja vida)
    if (health_percentage >= 75)
        return &"^2"; // Verde - vida alta
    else if (health_percentage >= 50)
        return &"^3"; // Amarillo - vida media
    else if (health_percentage >= 25)
        return &"^3"; // Amarillo - vida media-baja
    else
        return &"^1"; // Rojo - vida baja/critica
}

// Función para cambiar entre modos Littlegods y Classic
switch_legacy_display_mode(new_mode)
{
    if (new_mode != "littlegods" && new_mode != "classic")
        return;

    // Cambiar el modo
    level.legacy_display_mode = new_mode;

    // Actualizar posiciones de todos los displays existentes para todos los jugadores
    foreach(player in level.players)
    {
        if (isDefined(player.player_health_hud) && isDefined(player.player_health_value))
            update_player_health_position(player);

        if (isDefined(player.zombie_health_hud) && isDefined(player.zombie_health_value))
            update_zombie_health_position(player);

        if (isDefined(player.zombie_counter_hud) && isDefined(player.zombie_counter_value))
            update_zombie_counter_position(player);
    }
}

// Función para actualizar posición del display de vida del jugador
update_player_health_position(player)
{
    if (!isDefined(player.player_health_hud) || !isDefined(player.player_health_value))
        return;

    if (level.legacy_display_mode == "classic")
    {
        // Posición abajo izquierda para Classic (cerca del contador, 10 unidades debajo)
        // Layout: contador arriba (y=365, x=280-335), vida jugador abajo izquierda (y=375, x=200-255), vida zombie abajo derecha (y=375, x=410-465)
        player.player_health_hud.x = 200; // Izquierda, cerca del contador (80 unidades a la izquierda del contador en x=280)
        player.player_health_hud.y = 375; // 10 unidades debajo del contador (365 + 10)
        player.player_health_value.x = 255; // 55 unidades a la derecha del label
        player.player_health_value.y = 375;
    }
    else
    {
        // Posición esquina para Littlegods
        player.player_health_hud.x = level.player_health_display.x;
        player.player_health_hud.y = level.player_health_display.y;
        player.player_health_value.x = level.player_health_display.x + 60;
        player.player_health_value.y = level.player_health_display.y;
    }
}

// Función para actualizar posición del display de vida del zombie
update_zombie_health_position(player)
{
    if (!isDefined(player.zombie_health_hud) || !isDefined(player.zombie_health_value))
        return;

    if (level.legacy_display_mode == "classic")
    {
        // Posición abajo derecha para Classic (cerca del contador, 10 unidades debajo)
        // Layout: contador arriba (y=365, x=280-335), vida jugador abajo izquierda (y=375, x=200-255), vida zombie abajo derecha (y=375, x=410-465)
        player.zombie_health_hud.x = 365; // Derecha, cerca del contador (75 unidades a la derecha del contador en x=335)
        player.zombie_health_hud.y = 375; // 10 unidades debajo del contador (365 + 10)
        player.zombie_health_value.x = 435; // 55 unidades a la derecha del label
        player.zombie_health_value.y = 375;
    }
    else
    {
        // Posición esquina para Littlegods
        player.zombie_health_hud.x = level.zombie_health_display.x;
        player.zombie_health_hud.y = level.zombie_health_display.y;
        player.zombie_health_value.x = level.zombie_health_display.x + 60;
        player.zombie_health_value.y = level.zombie_health_display.y;
    }
}

// Función para actualizar posición del display de contador de zombies
update_zombie_counter_position(player)
{
    if (!isDefined(player.zombie_counter_hud) || !isDefined(player.zombie_counter_value))
        return;

    if (level.legacy_display_mode == "classic")
    {
        // Posición arriba centrada para Classic
        // Layout: contador arriba, vida jugador abajo izquierda, vida zombie abajo derecha
        player.zombie_counter_hud.x = 295; // Centrado, ligeramente a la izquierda para el texto
        player.zombie_counter_hud.y = 365; // Arriba
        player.zombie_counter_value.x = 334; // 55 unidades a la derecha del label
        player.zombie_counter_value.y = 365;
    }
    else
    {
        // Posición esquina para Littlegods
        player.zombie_counter_hud.x = level.zombie_counter_display.x;
        player.zombie_counter_hud.y = level.zombie_counter_display.y;
        player.zombie_counter_value.x = level.zombie_counter_display.x + 60;
        player.zombie_counter_value.y = level.zombie_counter_display.y;
    }
}

// ========================================
// FUNCIONES PRINCIPALES
// ========================================

// Activar/desactivar display de vida del jugador
toggle_player_health_display(player)
{
    level.player_health_display.enabled = !level.player_health_display.enabled;

    if (level.player_health_display.enabled)
    {
        create_player_health_display(player);
        player thread update_player_health_display();
    }
    else
    {
        destroy_player_health_display(player);
    }
}

// Activar/desactivar display de vida del zombie
toggle_zombie_health_display(player)
{
    level.zombie_health_display.enabled = !level.zombie_health_display.enabled;

    if (level.zombie_health_display.enabled)
    {
        create_zombie_health_display(player);
        player thread update_zombie_health_display();
    }
    else
    {
        destroy_zombie_health_display(player);
    }
}

// Activar/desactivar contador de zombies
toggle_zombie_counter_display(player)
{
    level.zombie_counter_display.enabled = !level.zombie_counter_display.enabled;

    if (level.zombie_counter_display.enabled)
    {
        create_zombie_counter_display(player);
        player thread update_zombie_counter_display();
    }
    else
    {
        destroy_zombie_counter_display(player);
    }
}

// ========================================
// CREACIÓN DE DISPLAYS
// ========================================

create_player_health_display(player)
{
    if (!isDefined(player.player_health_hud))
    {
        // Crear elementos HUD usando setvalue para evitar límite de strings
        player.player_health_hud = newClientHudElem(player);
        player.player_health_hud.x = level.player_health_display.x;
        player.player_health_hud.y = level.player_health_display.y;
        player.player_health_hud.fontscale = level.player_health_display.fontscale;
        player.player_health_hud.color = level.player_health_display.color;
        player.player_health_hud.alpha = level.player_health_display.alpha;
        player.player_health_hud setText(level.player_health_display.label);

        // Crear elemento para el valor separado
        player.player_health_value = newClientHudElem(player);
        player.player_health_value.x = level.player_health_display.x + 60; // Posición después del label
        player.player_health_value.y = level.player_health_display.y;
        player.player_health_value.fontscale = level.player_health_display.fontscale;
        player.player_health_value.color = level.player_health_display.color;
        player.player_health_value.alpha = level.player_health_display.alpha;
        player.player_health_value.label = &"^2"; // Label por defecto
        player.player_health_value.current_label = &"^2"; // Tracking del label actual

        // Establecer posiciones según el modo
        update_player_health_position(player);
    }
}

create_zombie_health_display(player)
{
    if (!isDefined(player.zombie_health_hud))
    {
        player.zombie_health_hud = newClientHudElem(player);
        player.zombie_health_hud.x = level.zombie_health_display.x;
        player.zombie_health_hud.y = level.zombie_health_display.y;
        player.zombie_health_hud.fontscale = level.zombie_health_display.fontscale;
        player.zombie_health_hud.color = level.zombie_health_display.color;
        player.zombie_health_hud.alpha = level.zombie_health_display.alpha;
        player.zombie_health_hud setText(level.zombie_health_display.label);

        player.zombie_health_value = newClientHudElem(player);
        player.zombie_health_value.x = level.zombie_health_display.x + 60;
        player.zombie_health_value.y = level.zombie_health_display.y;
        player.zombie_health_value.fontscale = level.zombie_health_display.fontscale;
        player.zombie_health_value.color = level.zombie_health_display.color;
        player.zombie_health_value.alpha = level.zombie_health_display.alpha;
        player.zombie_health_value.label = &"^5"; // Label por defecto
        player.zombie_health_value.current_label = &"^5"; // Tracking del label actual

        // Establecer posiciones según el modo
        update_zombie_health_position(player);
    }
}

create_zombie_counter_display(player)
{
    if (!isDefined(player.zombie_counter_hud))
    {
        player.zombie_counter_hud = newClientHudElem(player);
        player.zombie_counter_hud.x = level.zombie_counter_display.x;
        player.zombie_counter_hud.y = level.zombie_counter_display.y;
        player.zombie_counter_hud.fontscale = level.zombie_counter_display.fontscale;
        player.zombie_counter_hud.color = level.zombie_counter_display.color;
        player.zombie_counter_hud.alpha = level.zombie_counter_display.alpha;
        player.zombie_counter_hud setText(level.zombie_counter_display.label);

        player.zombie_counter_value = newClientHudElem(player);
        player.zombie_counter_value.x = level.zombie_counter_display.x + 60;
        player.zombie_counter_value.y = level.zombie_counter_display.y;
        player.zombie_counter_value.fontscale = level.zombie_counter_display.fontscale;
        player.zombie_counter_value.color = level.zombie_counter_display.color;
        player.zombie_counter_value.alpha = level.zombie_counter_display.alpha;
        player.zombie_counter_value.label = &"^1";

        // Establecer posiciones según el modo
        update_zombie_counter_position(player);
    }
}

// ========================================
// DESTRUCCIÓN DE DISPLAYS
// ========================================

destroy_player_health_display(player)
{
    if (isDefined(player.player_health_hud))
    {
        player.player_health_hud destroy();
        player.player_health_hud = undefined;
    }
    if (isDefined(player.player_health_value))
    {
        player.player_health_value destroy();
        player.player_health_value = undefined;
    }
}

destroy_zombie_health_display(player)
{
    if (isDefined(player.zombie_health_hud))
    {
        player.zombie_health_hud destroy();
        player.zombie_health_hud = undefined;
    }
    if (isDefined(player.zombie_health_value))
    {
        player.zombie_health_value destroy();
        player.zombie_health_value = undefined;
    }
}

destroy_zombie_counter_display(player)
{
    if (isDefined(player.zombie_counter_hud))
    {
        player.zombie_counter_hud destroy();
        player.zombie_counter_hud = undefined;
    }
    if (isDefined(player.zombie_counter_value))
    {
        player.zombie_counter_value destroy();
        player.zombie_counter_value = undefined;
    }
}

// ========================================
// ACTUALIZACIÓN DE VALORES
// ========================================

update_player_health_display()
{
    self endon("disconnect");
    self endon("player_health_display_disabled");

    while(level.player_health_display.enabled)
    {
        if (isDefined(self.player_health_value) && isPlayer(self))
        {
            current_health = self.health;
            max_health = self.maxhealth;

            // Determinar el label correcto
            if (level.player_health_display.color_gradient_enabled && max_health > 0)
            {
                // Calcular porcentaje de vida
                health_percentage = (current_health / max_health) * 100;
                new_label = get_health_color_code(health_percentage);
            }
            else
            {
                // Usar color por defecto (verde)
                new_label = get_health_color_code(100); // Verde para vida completa
            }

            // Si el label cambió, recrear el elemento HUD para asegurar que el color se aplique
            if (!isDefined(self.player_health_value.current_label) || self.player_health_value.current_label != new_label)
            {
                // Destruir el elemento anterior
                if (isDefined(self.player_health_value))
                {
                    self.player_health_value destroy();
                }

                // Crear nuevo elemento con el label correcto
                self.player_health_value = newClientHudElem(self);
                self.player_health_value.fontscale = level.player_health_display.fontscale;
                self.player_health_value.color = level.player_health_display.color;
                self.player_health_value.alpha = level.player_health_display.alpha;
                self.player_health_value.label = new_label;
                self.player_health_value.current_label = new_label;

                // Posicionar según el modo actual usando la función de actualización
                // Esto asegura que tanto el label como el value estén correctamente posicionados
                update_player_health_position(self);
            }

            // Usar setvalue para evitar creación de strings únicos
            self.player_health_value setValue(current_health);
        }

        wait 0.1; // Actualizar 10 veces por segundo
    }
}

update_zombie_health_display()
{
    self endon("disconnect");
    self endon("zombie_health_display_disabled");

    while(level.zombie_health_display.enabled)
    {
        if (isDefined(self.zombie_health_value))
        {
            // Encontrar el zombie más cercano al jugador
            closest_zombie = get_closest_zombie_to_player(self);

            if (isDefined(closest_zombie) && isAlive(closest_zombie))
            {
                zombie_health = closest_zombie.health;
                max_zombie_health = closest_zombie.maxhealth; // Usar el valor real del zombie

                // Determinar el label correcto
                if (level.zombie_health_display.color_gradient_enabled && max_zombie_health > 0)
                {
                    // Calcular porcentaje de vida del zombie
                    health_percentage = (zombie_health / max_zombie_health) * 100;
                    new_label = get_health_color_code(health_percentage);
                }
                else
                {
                    // Usar color por defecto (amarillo/cyan) - mantener ^5 para zombies
                    new_label = &"^5";
                }

                // Si el label cambió, recrear el elemento HUD para asegurar que el color se aplique
                if (!isDefined(self.zombie_health_value.current_label) || self.zombie_health_value.current_label != new_label)
                {
                    // Destruir el elemento anterior
                    if (isDefined(self.zombie_health_value))
                    {
                        self.zombie_health_value destroy();
                    }

                    // Crear nuevo elemento con el label correcto
                    self.zombie_health_value = newClientHudElem(self);
                    self.zombie_health_value.fontscale = level.zombie_health_display.fontscale;
                    self.zombie_health_value.color = level.zombie_health_display.color;
                    self.zombie_health_value.alpha = level.zombie_health_display.alpha;
                    self.zombie_health_value.label = new_label;
                    self.zombie_health_value.current_label = new_label;

                    // Posicionar según el modo actual usando la función de actualización
                    // Esto asegura que tanto el label como el value estén correctamente posicionados
                    update_zombie_health_position(self);
                }

                self.zombie_health_value setValue(zombie_health);
            }
            else
            {
                // Mostrar 0 si no hay zombies cerca
                if (level.zombie_health_display.color_gradient_enabled)
                {
                    new_label = get_health_color_code(0); // Rojo para indicar no hay zombies
                }
                else
                {
                    new_label = &"^5"; // Color por defecto
                }

                // Si el label cambió, recrear el elemento HUD para asegurar que el color se aplique
                if (!isDefined(self.zombie_health_value.current_label) || self.zombie_health_value.current_label != new_label)
                {
                    // Destruir el elemento anterior
                    if (isDefined(self.zombie_health_value))
                    {
                        self.zombie_health_value destroy();
                    }

                    // Crear nuevo elemento con el label correcto
                    self.zombie_health_value = newClientHudElem(self);
                    self.zombie_health_value.fontscale = level.zombie_health_display.fontscale;
                    self.zombie_health_value.color = level.zombie_health_display.color;
                    self.zombie_health_value.alpha = level.zombie_health_display.alpha;
                    self.zombie_health_value.label = new_label;
                    self.zombie_health_value.current_label = new_label;

                    // Posicionar según el modo actual
                    if (level.legacy_display_mode == "classic")
                    {
                        self.zombie_health_value.x = 100; // Abajo derecha
                        self.zombie_health_value.y = 340;
                    }
                    else
                    {
                        self.zombie_health_value.x = level.zombie_health_display.x + 60;
                        self.zombie_health_value.y = level.zombie_health_display.y;
                    }
                }

                self.zombie_health_value setValue(0);
            }
        }

        wait 0.1;
    }
}

update_zombie_counter_display()
{
    self endon("disconnect");
    self endon("zombie_counter_display_disabled");

    while(level.zombie_counter_display.enabled)
    {
        if (isDefined(self.zombie_counter_value))
        {
            // Contar zombies vivos
            zombie_count = get_zombie_count();
            self.zombie_counter_value setValue(zombie_count);
        }

        wait 0.5; // Actualizar 2 veces por segundo (menos frecuente)
    }
}

// ========================================
// FUNCIONES AUXILIARES
// ========================================

get_closest_zombie_to_player(player)
{
    zombies = getAIArray("axis");

    if (!isDefined(zombies) || zombies.size == 0)
        return undefined;

    closest_zombie = undefined;
    closest_distance = 999999;

    foreach (zombie in zombies)
    {
        if (isDefined(zombie) && isAlive(zombie))
        {
            distance = distance(player.origin, zombie.origin);
            if (distance < closest_distance)
            {
                closest_distance = distance;
                closest_zombie = zombie;
            }
        }
    }

    return closest_zombie;
}

get_zombie_count()
{
    zombies = getAIArray("axis");
    count = 0;

    if (isDefined(zombies))
    {
        foreach (zombie in zombies)
        {
            if (isDefined(zombie) && isAlive(zombie))
                count++;
        }
    }

    return count;
}

// ========================================
// FUNCIONES DE CONFIGURACIÓN
// ========================================

// Configurar posición del display de vida del jugador
set_player_health_position(x, y)
{
    level.player_health_display.x = x;
    level.player_health_display.y = y;

    // Actualizar posición de todos los jugadores que tienen el display activo
    foreach (player in level.players)
    {
        if (isDefined(player.player_health_hud))
        {
            player.player_health_hud.x = x;
            player.player_health_hud.y = y;
        }
        if (isDefined(player.player_health_value))
        {
            player.player_health_value.x = x + 120;
            player.player_health_value.y = y;
        }
    }
}

// Configurar tamaño del display de vida del jugador
set_player_health_fontscale(scale)
{
    level.player_health_display.fontscale = scale;

    foreach (player in level.players)
    {
        if (isDefined(player.player_health_hud))
            player.player_health_hud.fontscale = scale;
        if (isDefined(player.player_health_value))
            player.player_health_value.fontscale = scale;
    }
}

// Configurar color del display de vida del jugador
set_player_health_color(color)
{
    level.player_health_display.color = color;

    foreach (player in level.players)
    {
        if (isDefined(player.player_health_hud))
            player.player_health_hud.color = color;
        if (isDefined(player.player_health_value))
            player.player_health_value.color = color;
    }
}

// Funciones similares para zombie health y zombie counter...
// (Implementar de manera similar para mantener consistencia)

// ========================================
// FUNCIONES DE LIMPIEZA
// ========================================

cleanup_all_displays()
{
    foreach (player in level.players)
    {
        destroy_player_health_display(player);
        destroy_zombie_health_display(player);
        destroy_zombie_counter_display(player);
    }
}

// Función para limpiar displays cuando el jugador se desconecta
on_player_disconnect()
{
    self notify("player_health_display_disabled");
    self notify("zombie_health_display_disabled");
    self notify("zombie_counter_display_disabled");

    destroy_player_health_display(self);
    destroy_zombie_health_display(self);
    destroy_zombie_counter_display(self);
}
