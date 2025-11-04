#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm_hud_util;
#include maps\mp\zombies_zm;
#include maps\mp\zombies_zm_utility;
#include maps\mp\zombies_zm_weapons;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies_zm_stats;
#include maps\mp\gametypes_zm_hud_message;
#include maps\mp\zombies_zm_powerups;
#include maps\mp\zombies_zm_perks;
#include maps\mp\zombies_zm_audio;
#include maps\mp\zombies_zm_score;
#include maps\mp\gametypes_globallogic_spawn;
#include maps\mp\gametypes_spectating;
#include maps\mp_tacticalinsertion;
#include maps\mp_challenges;
#include maps\mp\gametypes_globallogic;
#include maps\mp\gametypes_globallogic_ui;
#include maps\mp\_utility;
#include maps\mp\gametypes_persistence;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\gametypes_zm\spawnlogic;
#include maps\mp\gametypes_zm\_hostmigration;

// Inicialización del módulo
init()
{
    level thread onPlayerConnect();
}

// Función que se ejecuta cuando un jugador se conecta
onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

// Función que se ejecuta cuando un jugador aparece en el juego
onPlayerSpawned()
{
    self endon("disconnect");
    
    for(;;)
    {
        self waittill("spawned_player");
        
        // Inicializar variables de God Mode
        if(!isDefined(self.godmode_enabled))
        {
            self.godmode_enabled = false;
        }
    }
}

// Función para activar el God Mode
toggle_godmode()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_godmode))
    {
        wait 0.1;
        return;
    }
    
    self.is_toggling_godmode = true;
    
    // Cambiar el estado del God Mode
    self.godmode_enabled = !self.godmode_enabled;
    
    if(self.godmode_enabled)
    {
        // Activar God Mode
        self enableInvulnerability();
        
        // Notificar al jugador según el idioma
        if(self.langLEN == 0)
            self iPrintLnBold("^2God Mode ACTIVADO");
        else
            self iPrintLnBold("^2God Mode ENABLED");
            
        // Indicador de God Mode removido por petición del usuario
        // self thread show_godmode_indicator();
    }
    else
    {
        // Desactivar God Mode
        self disableInvulnerability();
        
        // Notificar al jugador según el idiomam
        if(self.langLEN == 0)
            self iPrintLnBold("^1God Mode DESACTIVADO");
        else
            self iPrintLnBold("^1God Mode DISABLED");
            
        // Quitar el indicador de God Mode
        self notify("godmode_off");
    }
    
    // Actualizar el texto del menú actual
    if(isDefined(self.menu_current))
    {
        for(i = 0; i < self.menu_current.items.size; i++)
        {
            if(self.menu_current.items[i].func == ::toggle_godmode)
            {
                status = self.godmode_enabled ? "ON" : "OFF";
                
                if(self.langLEN == 0)
                    self.menu_current.items[i].item setText("God Mode: " + status);
                else
                    self.menu_current.items[i].item setText("God Mode: " + status);
                    
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_godmode = undefined;
}

// Función para mostrar un indicador de God Mode activo
show_godmode_indicator()
{
    self endon("disconnect");
    self endon("godmode_off");
    
    // Crear un indicador en pantalla para mostrar que el God Mode está activo
    indicator = newClientHudElem(self);
    indicator.alignX = "center";
    indicator.alignY = "bottom";
    indicator.horzAlign = "center";
    indicator.vertAlign = "bottom";
    indicator.x = 0;
    indicator.y = -50;
    indicator.fontScale = 1.2;
    indicator.color = (1, 0.8, 0);
    indicator.alpha = 0.8;
    indicator.hidewheninmenu = 1;
    
    // Establecer el texto del indicador según el idioma
    if(self.langLEN == 0)
        indicator setText("^3GOD MODE ACTIVO");
    else
        indicator setText("^3GOD MODE ACTIVE");
    
    // Pulso de transparencia para el indicador
    while(true)
    {
        // Hacer un efecto de pulso con la transparencia
        for(i = 8; i > 3; i--)
        {
            indicator.alpha = i * 0.1;
            wait 0.1;
        }
        
        for(i = 3; i < 8; i++)
        {
            indicator.alpha = i * 0.1;
            wait 0.1;
        }
        
        wait 0.5;
    }
}

// Función para avanzar a la siguiente ronda (solo incrementa contador)
advance_round()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_changing_round))
    {
        wait 0.1;
        return;
    }
    
    self.is_changing_round = true;
    
    // Verificar si el jugador tiene permisos para cambiar rondas
    if(!self.godmode_enabled)
    {
        // Notificar al jugador según el idioma
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^1Error: Necesitas God Mode para cambiar rondas");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Error: You need God Mode to change rounds");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_changing_round = undefined;
        return;
    }
    
    // Inicializar la ronda objetivo si no existe
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;
        
    // Incrementar la ronda objetivo
    self.target_round++;
    
    // Notificar al jugador según el idioma
    if(self.langLEN == 0)
        self iPrintLnBold("^5Ronda objetivo: ^3" + self.target_round + " ^7(Presiona Aplicar)");
    else
        self iPrintLnBold("^5Target round: ^3" + self.target_round + " ^7(Press Apply)");
    
    // Actualizar el texto del menú actual si existe
    self update_round_menu_text();
    
    wait 0.2;
    self.is_changing_round = undefined;
}

// Función para retroceder a la ronda anterior (solo decrementa contador)
go_back_round()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_changing_round))
    {
        wait 0.1;
        return;
    }
    
    self.is_changing_round = true;
    
    // Verificar si el jugador tiene permisos para cambiar rondas
    if(!self.godmode_enabled)
    {
        // Notificar al jugador según el idioma
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^1Error: Necesitas God Mode para cambiar rondas");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Error: You need God Mode to change rounds");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_changing_round = undefined;
        return;
    }
    
    // Inicializar la ronda objetivo si no existe
    if(!isDefined(self.target_round))
        self.target_round = level.round_number;
    
    // No permitir retroceder por debajo de la ronda 1
    if(self.target_round <= 1)
    {
        // Notificar al jugador según el idioma
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^3Ya estás en la ronda mínima");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^3You're already at the minimum round");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_changing_round = undefined;
        return;
    }
    
    // Decrementar la ronda objetivo
    self.target_round--;
    
    // Notificar al jugador según el idioma
    if(self.langLEN == 0)
        self iPrintLnBold("^5Ronda objetivo: ^3" + self.target_round + " ^7(Presiona Aplicar)");
    else
        self iPrintLnBold("^5Target round: ^3" + self.target_round + " ^7(Press Apply)");
    
    // Actualizar el texto del menú actual si existe
    self update_round_menu_text();
    
    wait 0.2;
    self.is_changing_round = undefined;
}

// Función para actualizar el texto del menú con la ronda objetivo
update_round_menu_text()
{
    if(isDefined(self.menu_current))
    {
        for(i = 0; i < self.menu_current.items.size; i++)
        {
            if(self.menu_current.items[i].func == ::apply_round_change)
            {
                // Actualizar el texto del botón Aplicar
                if(self.langLEN == 0)
                    self.menu_current.items[i].item setText("Aplicar Ronda: " + self.target_round);
                else
                    self.menu_current.items[i].item setText("Apply Round: " + self.target_round);
                    
                break;
            }
        }
    }
}

// Nueva función para aplicar el cambio de ronda
apply_round_change()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_applying_round))
    {
        wait 0.1;
        return;
    }
    
    self.is_applying_round = true;
    
    // Verificar si el jugador tiene permisos para cambiar rondas
    if(!self.godmode_enabled)
    {
        // Notificar al jugador según el idioma
        if(self.langLEN == 0)
        {
            self iPrintlnBold("^1Error: Necesitas God Mode para cambiar rondas");
            self playsound("menu_error");
        }
        else
        {
            self iPrintlnBold("^1Error: You need God Mode to change rounds");
            self playsound("menu_error");
        }
        
        wait 0.2;
        self.is_applying_round = undefined;
        return;
    }
    
    // Verificar si hay una ronda objetivo definida
    if(!isDefined(self.target_round))
    {
        self.target_round = level.round_number;
        
        // Actualizar el texto del menú actual si existe
        self update_round_menu_text();
        
        wait 0.2;
        self.is_applying_round = undefined;
        return;
    }
    
    // Verificar si la ronda objetivo es diferente de la actual
    if(self.target_round == level.round_number)
    {
        // Notificar al jugador según el idioma
        if(self.langLEN == 0)
            self iPrintLnBold("^3Ya estás en la ronda " + self.target_round);
        else
            self iPrintLnBold("^3You're already in round " + self.target_round);
            
        wait 0.2;
        self.is_applying_round = undefined;
        return;
    }
    
    // Notificar al jugador que se está aplicando el cambio
    if(self.langLEN == 0)
        self iPrintLnBold("^5Cambiando a ronda ^3" + self.target_round + "^5...");
    else
        self iPrintLnBold("^5Changing to round ^3" + self.target_round + "^5...");
        
    // Usar el método probado de cambio de ronda
    self thread zombiekill();
    level.round_number = self.target_round - 1; // Se resta 1 porque el sistema agregará 1 automáticamente
    
    // Notificar al jugador según el idioma
    if(self.langLEN == 0)
        self iPrintLnBold("^2¡Ronda cambiada a: ^5" + self.target_round + "^2!");
    else
        self iPrintLnBold("^2Round changed to: ^5" + self.target_round + "^2!");
    
    // Reproducir sonido de cambio de ronda
    self playsound("zmb_round_change");
    
    // Mostrar el número de ronda en la pantalla con un efecto especial
    self thread show_round_change_message(self.target_round);
    
    wait 0.5;
    self.is_applying_round = undefined;
}

// Función para matar a todos los zombies (usando el método de player.gsc)
zombiekill()
{
    self endon("end_game");
    zombs = getaiarray("axis");
    // Removed level.zombie_total = 0; to prevent zombie spawning issues

    if(isDefined(zombs))
    {
        for(i = 0; i < zombs.size; i++)
        {
            zombs[i] dodamage(zombs[i].health * 5000, (0, 0, 0), self);
            wait 0.05;
        }

        if(isDefined(self.dopnuke))
            self dopnuke();
    }
}
dopnuke()
{
    self endon( "end_game" );

    foreach ( player in level.players )
    {
        level thread nuke_powerup( self, player.team );
        player powerup_vo( "nuke" );
        zombies = getaiarray( level.zombie_team );
        player.zombie_nuked = arraysort( zombies, self.origin );
        player notify( "nuke_triggered" );
    }
}
// Función para mostrar un mensaje de cambio de ronda
show_round_change_message(round_number)
{
    // Crear un elemento HUD para mostrar el cambio de ronda
    round_text = newClientHudElem(self);
    round_text.alignX = "center";
    round_text.alignY = "middle";
    round_text.horzAlign = "center";
    round_text.vertAlign = "middle";
    round_text.x = 0;
    round_text.y = -50;
    round_text.fontScale = 3.0;
    round_text.color = (1, 0.7, 0);
    round_text.alpha = 0;
    round_text.sort = 1001;
    round_text setText("^3RONDA " + round_number);
    
    // Animación de entrada
    round_text fadeOverTime(0.5);
    round_text.alpha = 1;
    wait 1.5;
    
    // Animación de salida
    round_text fadeOverTime(0.5);
    round_text.alpha = 0;
    wait 0.5;
    
    // Destruir el elemento HUD
    round_text destroy();
} 
// Función para activar/desactivar Perk Unlimited
toggle_perk_unlimite(menu)
{
    self endon("disconnect");
    
    // Evitar múltiples activaciones
    if (isDefined(self.is_toggling_perk_unlimite))
    {
        wait 0.1;
        return;
    }
    
    self.is_toggling_perk_unlimite = true;
    
    // Invertir el estado de activación
    if (!isDefined(self.perk_unlimite_active))
        self.perk_unlimite_active = false;
    
    self.perk_unlimite_active = !self.perk_unlimite_active;
    
    // Reproducir sonido de confirmación
    self playLocalSound("uin_alert_closewindow");
    
    // Aplicar el cambio según el estado
    if (self.perk_unlimite_active)
    {
        // Lógica para activar los Perks ilimitados
        level.is_unlimited_perks = true;
        level.perk_purchase_limit = 9;
        
        // Mensaje de confirmación
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^2Perk Unlimited: ^7Activado");
        else // Inglés
            self iPrintlnBold("^2Perk Unlimited: ^7Enabled");
    }
    else
    {
        // Lógica para desactivar los Perks ilimitados
        level.is_unlimited_perks = false;
        level.perk_purchase_limit = 4;
        
        // Mensaje de confirmación
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^1Perk Unlimited: ^7Desactivado");
        else // Inglés
            self iPrintlnBold("^1Perk Unlimited: ^7Disabled");
    }
    
    // Actualizar el texto del menú en tiempo real
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (isDefined(self.menu_current.items[i].func) && self.menu_current.items[i].func == scripts\zm\funciones::toggle_perk_unlimite)
            {
                status = self.perk_unlimite_active ? "ON" : "OFF";
                self.menu_current.items[i].item setText("Perk Unlimited: " + status);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_perk_unlimite = undefined;
}
ThirdPerson()
{
    self endon("disconnect");
    
    // Evitar múltiples activaciones
    if (isDefined(self.is_toggling_thirdperson))
    {
        wait 0.1;
        return;
    }
    
    self.is_toggling_thirdperson = true;
    
    // Asegurarse de que TPP está definido (false = primera persona, true = tercera persona)
    if (!isDefined(self.TPP))
        self.TPP = false;
    
    // Cambiar el estado
    self.TPP = !self.TPP;
    
    // Reproducir sonido de confirmación
    self playLocalSound("uin_alert_closewindow");
    
    // Aplicar el cambio según el estado actual
    if (self.TPP)
    {
        // Activar tercera persona
        self setclientthirdperson(1);
        
        // Mensaje de confirmación
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^2Tercera Persona: ^7Activado");
        else // Inglés
            self iPrintlnBold("^2Third Person: ^7Enabled");
    }
    else
    {
        // Desactivar tercera persona (volver a primera persona)
        self setclientthirdperson(0);
        
        // Mensaje de confirmación
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^1Tercera Persona: ^7Desactivado");
        else // Inglés
            self iPrintlnBold("^1Third Person: ^7Disabled");
    }
    
    // Actualizar el texto del menú en tiempo real
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (isDefined(self.menu_current.items[i].func) && self.menu_current.items[i].func == scripts\zm\funciones::ThirdPerson)
            {
                status = self.TPP ? "ON" : "OFF";
                if (self.langLEN == 0) // Español
                    self.menu_current.items[i].item setText("Tercera Persona: " + status);
                else // Inglés
                    self.menu_current.items[i].item setText("Third Person: " + status);
                break;
            }
        }
    }
    
    wait 0.2;
    self.is_toggling_thirdperson = undefined;
}

// Función para dar 10k de puntos al jugador
give_10k_points()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_giving_points))
    {
        wait 0.1;
        return;
    }

    self.is_giving_points = true;

    // Dar 10,000 puntos al jugador
    self maps\mp\zombies\_zm_score::add_to_player_score(10000);

    // Reproducir sonido de confirmación
    self playLocalSound("uin_alert_popup");

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2+10,000 ^7Puntos");
    else // Inglés
        self iPrintlnBold("^2+10,000 ^7Points");

    wait 0.5;
    self.is_giving_points = undefined;
}


// Función para activar/desactivar velocidad x2
toggle_speed()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_toggling_speed))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_speed = true;

    // Inicializar si no existe
    if (!isDefined(self.speed_boost_enabled))
        self.speed_boost_enabled = false;

    self.speed_boost_enabled = !self.speed_boost_enabled;

    if (self.speed_boost_enabled)
    {
        // Activar velocidad x2
        self setMoveSpeedScale(2.0);

        // Mensaje de confirmación
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^2Velocidad x2: ^7Activado");
        else // Inglés
            self iPrintlnBold("^2Speed x2: ^7Enabled");
    }
    else
    {
        // Desactivar velocidad x2
        self setMoveSpeedScale(1.0);

        // Mensaje de confirmación
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^1Velocidad x2: ^7Desactivado");
        else // Inglés
            self iPrintlnBold("^1Speed x2: ^7Disabled");
    }

    // Actualizar el texto del menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (isDefined(self.menu_current.items[i].func) && self.menu_current.items[i].func == ::toggle_speed)
            {
                status = self.speed_boost_enabled ? "ON" : "OFF";
                self.menu_current.items[i].item setText("Velocidad x2: " + status);
                break;
            }
        }
    }

    wait 0.2;
    self.is_toggling_speed = undefined;
}

// Función para inicializar el sistema de posiciones guardadas
init_teleport_system()
{
    if (!isDefined(self.saved_positions))
    {
        self.saved_positions = [];
        self.position_count = 0;
    }
}

// Función para guardar posición con nombre personalizado
save_position_with_name(name)
{
    self endon("disconnect");

    // Inicializar sistema si no existe
    self init_teleport_system();

    // Validar nombre
    if (!isDefined(name) || name == "" || name == " ")
    {
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^1Debes especificar un nombre para la posición");
        else // Inglés
            self iPrintlnBold("^1You must specify a name for the position");

        self playLocalSound("menu_error");
        return;
    }

    // Verificar si ya existe una posición con ese nombre
    for (i = 0; i < self.position_count; i++)
    {
        if (isDefined(self.saved_positions[i]) && self.saved_positions[i].name == name)
        {
            if (self.langLEN == 0) // Español
                self iPrintlnBold("^1Ya existe una posición con el nombre: ^5" + name);
            else // Inglés
                self iPrintlnBold("^1A position with name ^5" + name + " ^1already exists");

            self playLocalSound("menu_error");
            return;
        }
    }

    // Crear estructura de posición
    position_data = spawnStruct();
    position_data.name = name;
    position_data.origin = self.origin;
    position_data.angles = self getPlayerAngles();

    // Agregar a la lista
    self.saved_positions[self.position_count] = position_data;
    self.position_count++;

    // Reproducir sonido de confirmación
    self playLocalSound("uin_alert_popup");

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2Posición ^5" + name + " ^2guardada");
    else // Inglés
        self iPrintlnBold("^2Position ^5" + name + " ^2saved");

    wait 0.1;
}

// Función para teleportarse a una posición por nombre
teleport_to_position(name)
{
    self endon("disconnect");

    // Inicializar sistema si no existe
    self init_teleport_system();

    // Buscar la posición por nombre
    found = false;
    for (i = 0; i < self.position_count; i++)
    {
        if (isDefined(self.saved_positions[i]) && self.saved_positions[i].name == name)
        {
            // Teleportarse a la posición
            self setOrigin(self.saved_positions[i].origin);
            self setPlayerAngles(self.saved_positions[i].angles);

            // Reproducir sonido de confirmación
            self playLocalSound("uin_positive_feedback");

            // Mensaje de confirmación
            if (self.langLEN == 0) // Español
                self iPrintlnBold("^2Teleportado a ^5" + name);
            else // Inglés
                self iPrintlnBold("^2Teleported to ^5" + name);

            found = true;
            wait 0.1;
            break;
        }
    }

    if (!found)
    {
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^1No se encontró la posición: ^5" + name);
        else // Inglés
            self iPrintlnBold("^1Position not found: ^5" + name);

        self playLocalSound("menu_error");
    }
}

// Función para eliminar una posición por nombre
delete_position(name)
{
    self endon("disconnect");

    // Inicializar sistema si no existe
    self init_teleport_system();

    // Buscar y eliminar la posición
    found = false;
    for (i = 0; i < self.position_count; i++)
    {
        if (isDefined(self.saved_positions[i]) && self.saved_positions[i].name == name)
        {
            // Eliminar la posición moviendo las demás hacia adelante
            for (j = i; j < self.position_count - 1; j++)
            {
                self.saved_positions[j] = self.saved_positions[j + 1];
            }
            self.saved_positions[self.position_count - 1] = undefined;
            self.position_count--;

            // Reproducir sonido de confirmación
            self playLocalSound("uin_alert_popup");

            // Mensaje de confirmación
            if (self.langLEN == 0) // Español
                self iPrintlnBold("^1Posición ^5" + name + " ^1eliminada");
            else // Inglés
                self iPrintlnBold("^1Position ^5" + name + " ^1deleted");

            found = true;
            wait 0.1;
            break;
        }
    }

    if (!found)
    {
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^1No se encontró la posición: ^5" + name);
        else // Inglés
            self iPrintlnBold("^1Position not found: ^5" + name);

        self playLocalSound("menu_error");
    }
}

// Función para listar todas las posiciones guardadas
list_saved_positions()
{
    self endon("disconnect");

    // Inicializar sistema si no existe
    self init_teleport_system();

    if (self.position_count == 0)
    {
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^1No hay posiciones guardadas");
        else // Inglés
            self iPrintlnBold("^1No saved positions");

        return;
    }

    if (self.langLEN == 0) // Español
        self iPrintlnBold("^5=== POSICIONES GUARDADAS ===");
    else // Inglés
        self iPrintlnBold("^5=== SAVED POSITIONS ===");

    wait 0.05;

    for (i = 0; i < self.position_count; i++)
    {
        if (isDefined(self.saved_positions[i]))
        {
            if (self.langLEN == 0) // Español
                self iPrintln("^3" + (i + 1) + ". ^5" + self.saved_positions[i].name);
            else // Inglés
                self iPrintln("^3" + (i + 1) + ". ^5" + self.saved_positions[i].name);

            wait 0.05;
        }
    }

    if (self.langLEN == 0) // Español
        self iPrintln("^7Escribe '^2tp [nombre]^7' para teleportarte");
    else // Inglés
        self iPrintln("^7Type '^2tp [name]^7' to teleport");

    wait 0.05;
}

// Funciones de compatibilidad (para mantener funcionalidad anterior)
save_position()
{
    // Por defecto guardar con nombre genérico
    timestamp = getTime();
    default_name = "Posicion_" + timestamp;
    self save_position_with_name(default_name);
}

teleport_to_saved()
{
    // Por defecto teleportar a la primera posición si existe
    self init_teleport_system();

    if (self.position_count > 0 && isDefined(self.saved_positions[0]))
    {
        self setOrigin(self.saved_positions[0].origin);
        self setPlayerAngles(self.saved_positions[0].angles);

        self playLocalSound("uin_positive_feedback");

        if (self.langLEN == 0) // Español
            self iPrintlnBold("^2Teleportado a ^5" + self.saved_positions[0].name);
        else // Inglés
            self iPrintlnBold("^2Teleported to ^5" + self.saved_positions[0].name);
    }
    else
    {
        if (self.langLEN == 0) // Español
            self iPrintlnBold("^1No hay posiciones guardadas");
        else // Inglés
            self iPrintlnBold("^1No saved positions");

        self playLocalSound("menu_error");
    }
}

// ===== SISTEMA DE POWERUPS =====

// Función para spawnear Max Ammo
spawn_max_ammo()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    // Calcular posición enfrente del jugador
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    // Spawnear powerup de Max Ammo enfrente del jugador
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("full_ammo", spawn_pos);

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2Powerup ^5Max Ammo ^2spawneado");
    else // Inglés
        self iPrintlnBold("^2Powerup ^5Max Ammo ^2spawned");

    // Reproducir sonido
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}

// Función para spawnear Insta Kill
spawn_insta_kill()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    // Calcular posición enfrente del jugador
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    // Spawnear powerup de Insta Kill enfrente del jugador
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("insta_kill", spawn_pos);

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2Powerup ^5Insta Kill ^2spawneado");
    else // Inglés
        self iPrintlnBold("^2Powerup ^5Insta Kill ^2spawned");

    // Reproducir sonido
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}

// Función para spawnear Carpenter (Catapum)
spawn_carpenter()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    // Calcular posición enfrente del jugador
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    // Intentar diferentes nombres para carpenter (algunos mapas lo llaman diferente)
    powerup_names = [];
    powerup_names[0] = "carpenter";
    powerup_names[1] = "free_perk";
    powerup_names[2] = "bonus_points";
    spawned = false;

    for (i = 0; i < powerup_names.size; i++)
    {
        powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop(powerup_names[i], spawn_pos);
        if (isDefined(powerup))
        {
            spawned = true;
            break;
        }
        wait 0.05;
    }

    // Si ninguno funcionó, intentar con el método alternativo
    if (!spawned)
    {
        // Método alternativo: usar el sistema de powerups directamente
        level thread maps\mp\zombies\_zm_powerups::powerup_drop(spawn_pos);
    }

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2Powerup ^5Carpenter ^2spawneado");
    else // Inglés
        self iPrintlnBold("^2Powerup ^5Carpenter ^2spawned");

    // Reproducir sonido
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}

// Función para spawnear Double Points (x2)
spawn_double_points()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    // Calcular posición enfrente del jugador
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    // Spawnear powerup de Double Points enfrente del jugador
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("double_points", spawn_pos);

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2Powerup ^5Double Points ^2spawneado");
    else // Inglés
        self iPrintlnBold("^2Powerup ^5Double Points ^2spawned");

    // Reproducir sonido
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}

// Función para spawnear Fire Sale
spawn_fire_sale()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    // Calcular posición enfrente del jugador
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    // Spawnear powerup de Fire Sale enfrente del jugador
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("fire_sale", spawn_pos);

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2Powerup ^5Fire Sale ^2spawneado");
    else // Inglés
        self iPrintlnBold("^2Powerup ^5Fire Sale ^2spawned");

    // Reproducir sonido
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}

// Función para spawnear Nuke
spawn_nuke()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    // Calcular posición enfrente del jugador
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    // Spawnear powerup de Nuke enfrente del jugador
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("nuke", spawn_pos);

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2Powerup ^5Nuke ^2spawneado");
    else // Inglés
        self iPrintlnBold("^2Powerup ^5Nuke ^2spawned");

    // Reproducir sonido
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}

// Función para spawnear Zombie Blood
spawn_zombie_blood()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    // Calcular posición enfrente del jugador
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    // Spawnear powerup de Zombie Blood enfrente del jugador
    powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("zombie_blood", spawn_pos);

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2Powerup ^5Zombie Blood ^2spawneado");
    else // Inglés
        self iPrintlnBold("^2Powerup ^5Zombie Blood ^2spawned");

    // Reproducir sonido
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}


// Función para spawnear TODOS los powerups
spawn_all_powerups()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_spawning_all_powerups))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_all_powerups = true;

    // Calcular dirección forward del jugador
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    right = AnglesToRight(player_angles);

    // Lista de todos los powerups disponibles
    powerup_types = [];
    powerup_types[0] = "full_ammo";
    powerup_types[1] = "insta_kill";
    powerup_types[2] = "carpenter";
    powerup_types[3] = "double_points";
    powerup_types[4] = "fire_sale";
    powerup_types[5] = "nuke";
    powerup_types[6] = "zombie_blood";

    // Posición base enfrente del jugador
    base_pos = self.origin + forward * 150 + (0, 0, 10);

    for (i = 0; i < powerup_types.size; i++)
    {
        // Crear formación circular alrededor de la posición base
        angle = (i / powerup_types.size) * 360;
        radius = 80;

        offset_x = cos(angle) * radius;
        offset_y = sin(angle) * radius;

        // Ajustar altura especial para Nuke (índice 5)
        height_offset = i * 15;
        if (powerup_types[i] == "nuke")
        {
            height_offset = i * 15 - 20; // Bajar el Nuke 20 unidades
        }

        spawn_pos = base_pos + (offset_x, offset_y, height_offset);

        // Spawnear el powerup
        powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop(powerup_types[i], spawn_pos);

        wait 0.1; // Pequeña pausa entre spawns
    }

    // Mensaje de confirmación
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2TODOS los Powerups spawneados enfrente!");
    else // Inglés
        self iPrintlnBold("^2ALL Powerups spawned in front!");

    // Reproducir sonido especial
    self playLocalSound("zmb_round_change");

    wait 1.0;
    self.is_spawning_all_powerups = undefined;
}

// Función para spawnear un powerup RANDOM
spawn_random_powerup()
{
    self endon("disconnect");

    // Evitar múltiples activaciones
    if (isDefined(self.is_spawning_powerup))
    {
        wait 0.1;
        return;
    }

    self.is_spawning_powerup = true;

    // Calcular posición enfrente del jugador
    player_angles = self getPlayerAngles();
    forward = AnglesToForward(player_angles);
    spawn_pos = self.origin + forward * 100 + (0, 0, 10);

    // Lista de powerups disponibles para random
    powerup_types = [];
    powerup_types[0] = "full_ammo";
    powerup_types[1] = "insta_kill";
    powerup_types[2] = "carpenter";
    powerup_types[3] = "double_points";
    powerup_types[4] = "fire_sale";
    powerup_types[5] = "nuke";
    powerup_types[6] = "zombie_blood";

    // Seleccionar uno aleatorio
    random_index = randomInt(powerup_types.size);
    selected_powerup = powerup_types[random_index];

    // Si es carpenter, intentar nombres alternativos
    if (selected_powerup == "carpenter")
    {
        carpenter_names = [];
        carpenter_names[0] = "carpenter";
        carpenter_names[1] = "free_perk";
        carpenter_names[2] = "bonus_points";
        for (i = 0; i < carpenter_names.size; i++)
        {
            powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop(carpenter_names[i], spawn_pos);
            if (isDefined(powerup))
                break;
            wait 0.05;
        }
    }
    else
    {
        // Spawnear el powerup seleccionado enfrente del jugador
        powerup = level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop(selected_powerup, spawn_pos);
    }

    // Nombres para mostrar en el mensaje
    powerup_names = [];
    powerup_names["full_ammo"] = "Max Ammo";
    powerup_names["insta_kill"] = "Insta Kill";
    powerup_names["carpenter"] = "Carpenter";
    powerup_names["double_points"] = "Double Points";
    powerup_names["fire_sale"] = "Fire Sale";
    powerup_names["nuke"] = "Nuke";
    powerup_names["zombie_blood"] = "Zombie Blood";

    // Mensaje de confirmación
    powerup_name = powerup_names[selected_powerup];
    if (self.langLEN == 0) // Español
        self iPrintlnBold("^2Powerup Random: ^5" + powerup_name + " ^2spawneado enfrente!");
    else // Inglés
        self iPrintlnBold("^2Random Powerup: ^5" + powerup_name + " ^2spawned in front!");

    // Reproducir sonido
    self playLocalSound("uin_positive_feedback");

    wait 0.5;
    self.is_spawning_powerup = undefined;
}

//====================================================================================
// FUNCIONES PARA CONTROL DE ZOMBIES
//====================================================================================

// Función para congelar/descongelar todos los zombies
toggle_zombie_freeze()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_freeze))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_freeze = true;

    // Cambiar el estado del freeze
    if(!isDefined(self.zombies_frozen))
        self.zombies_frozen = false;

    self.zombies_frozen = !self.zombies_frozen;

    zombies = getAIArray("axis");

    if(self.zombies_frozen)
    {
        // Congelar todos los zombies - solo frenar movimiento
        foreach(zombie in zombies)
        {
            if(isDefined(zombie) && isAlive(zombie))
            {
                zombie setVelocity((0, 0, 0)); // Frenar vector de movimiento
                zombie.ignoreall = true; // Hacer que ignoren al jugador
            }
        }

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^3ZOMBIES CONGELADOS");
        else
            self iPrintLnBold("^3ZOMBIES FROZEN");

        // Actualizar el texto del menú actual
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::toggle_zombie_freeze)
                {
                    status = self.zombies_frozen ? "ON" : "OFF";
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                    else
                        self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                }
            }
        }
    }
    else
    {
        // Descongelar todos los zombies
        foreach(zombie in zombies)
        {
            if(isDefined(zombie) && isAlive(zombie))
            {
                zombie.ignoreall = false; // Volver a perseguir al jugador
            }
        }

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^1ZOMBIES DESCONGELADOS");
        else
            self iPrintLnBold("^1ZOMBIES UNFROZEN");

        // Actualizar el texto del menú actual
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::toggle_zombie_freeze)
                {
                    status = self.zombies_frozen ? "ON" : "OFF";
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                    else
                        self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                }
            }
        }
    }


    self.is_toggling_freeze = undefined;
}

// Función para matar todos los zombies
kill_all_zombies()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_kill))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_kill = true;

    zombies = getAIArray("axis");
    killed_count = 0;

    foreach(zombie in zombies)
    {
        if(isDefined(zombie) && isAlive(zombie))
        {
            zombie doDamage(zombie.health + 999, zombie.origin);
            killed_count++;
        }
    }

    // Notificar al jugador
    if(self.langLEN == 0)
        self iPrintLnBold("^2ELIMINADOS: ^5" + killed_count + " ^2ZOMBIES");
    else
        self iPrintLnBold("^2KILLED: ^5" + killed_count + " ^2ZOMBIES");

    self.is_toggling_kill = undefined;
}

//====================================================================================
// FUNCIONES PARA ARMAS Y MUNICIÓN
//====================================================================================

// Función para activar/desactivar munición infinita en el arma actual
toggle_unlimited_ammo()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_ammo))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_ammo = true;

    // Cambiar el estado de unlimited ammo
    if(!isDefined(self.unlimited_ammo))
        self.unlimited_ammo = false;

    self.unlimited_ammo = !self.unlimited_ammo;

    if(self.unlimited_ammo)
    {
        // Activar unlimited ammo
        self thread unlimited_ammo_monitor();

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^2MUNICIÓN INFINITA ACTIVADA");
        else
            self iPrintLnBold("^2UNLIMITED AMMO ENABLED");

        // Actualizar el texto del menú actual
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::toggle_unlimited_ammo)
                {
                    status = self.unlimited_ammo ? "ON" : "OFF";
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Munición Infinita: " + status);
                    else
                        self.menu_current.items[i].item setText("Unlimited Ammo: " + status);
                }
            }
        }
    }
    else
    {
        // Desactivar unlimited ammo
        self notify("stop_unlimited_ammo");

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^1MUNICIÓN INFINITA DESACTIVADA");
        else
            self iPrintLnBold("^1UNLIMITED AMMO DISABLED");

        // Actualizar el texto del menú actual
        if (isDefined(self.menu_current))
        {
            for (i = 0; i < self.menu_current.items.size; i++)
            {
                if (self.menu_current.items[i].func == ::toggle_unlimited_ammo)
                {
                    status = self.unlimited_ammo ? "ON" : "OFF";
                    if (self.langLEN == 0)
                        self.menu_current.items[i].item setText("Munición Infinita: " + status);
                    else
                        self.menu_current.items[i].item setText("Unlimited Ammo: " + status);
                }
            }
        }
    }


    self.is_toggling_ammo = undefined;
}

// Thread que monitorea y rellena la munición
unlimited_ammo_monitor()
{
    self endon("disconnect");
    self endon("stop_unlimited_ammo");

    while(true)
    {
        wait 0.1;

        if(!isDefined(self) || !isAlive(self))
            continue;

        // Rellenar munición del arma actual
        current_weapon = self getCurrentWeapon();
        if(isDefined(current_weapon) && current_weapon != "none")
        {
            self setWeaponAmmoClip(current_weapon, weaponClipSize(current_weapon));
            self giveMaxAmmo(current_weapon);
        }

        // Rellenar granadas y equipamiento
        weapons = self getWeaponsList();
        foreach(weapon in weapons)
        {
            if(isDefined(weapon) && weapon != "none")
            {
                // Verificar si es granada por nombre
                is_grenade = false;
                grenade_types = [];
                grenade_types[0] = "frag_grenade_zm";
                grenade_types[1] = "sticky_grenade_zm";
                grenade_types[2] = "cymbal_monkey_zm";
                grenade_types[3] = "emp_grenade_zm";
                grenade_types[4] = "claymore_zm";

                foreach(grenade in grenade_types)
                {
                    if(weapon == grenade)
                    {
                        is_grenade = true;
                        break;
                    }
                }

                // Para granadas y equipamiento especial
                if(is_grenade)
                {
                    self giveMaxAmmo(weapon);
                }
            }
        }

        // Rellenar granadas letales
        self setWeaponAmmoClip("frag_grenade_zm", 4);
        self setWeaponAmmoClip("sticky_grenade_zm", 4);

        // Rellenar granadas tácticas
        self setWeaponAmmoClip("cymbal_monkey_zm", 4);
        self setWeaponAmmoClip("emp_grenade_zm", 4);
    }
}

//====================================================================================
// FUNCIONES AVANZADAS DE MOVIMIENTO Y VUELO
//====================================================================================

// Función para activar/desactivar modo UFO (vuelo libre)
toggle_ufo_mode()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_ufo))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_ufo = true;

    // Cambiar el estado del UFO mode
    if(!isDefined(self.ufo_enabled))
        self.ufo_enabled = false;

    self.ufo_enabled = !self.ufo_enabled;

    if(self.ufo_enabled)
    {
        // Desactivar Forge Mode si está activo (restricción)
        if(isDefined(self.forge_enabled) && self.forge_enabled)
        {
            self.forge_enabled = false;
            self notify("stop_forge_mode");

            if(self.langLEN == 0)
                self iPrintLn("^1FORGE MODE DESACTIVADO (conflicto con UFO)");
            else
                self iPrintLn("^1FORGE MODE DISABLED (conflict with UFO)");

            // Actualizar el texto del menú para Forge Mode
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_forge_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        else
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        break;
                    }
                }
            }
        }

        // Desactivar Aimbot si está activo (restricción)
        if(isDefined(self.aimbot_enabled) && self.aimbot_enabled)
        {
            self.aimbot_enabled = false;
            self notify("stop_aimbot");

            if (self.langLEN == 0)
                self iPrintLn("^1AIMBOT DESACTIVADO (conflicto con UFO)");
            else
                self iPrintLn("^1AIMBOT DISABLED (conflict with UFO)");

            // Actualizar el texto del menú para Aimbot
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_aimbot)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Aimbot: OFF");
                        else
                            self.menu_current.items[i].item setText("Aimbot: OFF");
                        break;
                    }
                }
            }
        }

        // Activar UFO mode
        self thread ufo_mode_monitor();

        // Activar godmode automáticamente cuando se activa UFO para protección completa
        if(!self.godmode_enabled)
        {
            self enableInvulnerability();
            self.ufo_godmode_activated = true; // Marcar que el godmode fue activado por UFO
        }

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^2MODO UFO ACTIVADO - Presiona [{+frag}] para volar");
        else
            self iPrintLnBold("^2UFO MODE ENABLED - Press [{+frag}] to fly");
    }
    else
    {
        // Desactivar UFO mode
        self notify("stop_ufo_mode");

        // Limpiar objeto de vuelo si existe
        if(isDefined(self.ufo_object))
        {
            self.ufo_object delete();
            self.ufo_object = undefined;
        }

        // Desvincular si está vinculado
        if(isDefined(self.fly_enabled) && self.fly_enabled)
        {
            self unlink();
            self.fly_enabled = false;
        }

        // Desactivar godmode solo si fue activado por UFO
        if(isDefined(self.ufo_godmode_activated) && self.ufo_godmode_activated && !self.godmode_enabled)
        {
            self disableInvulnerability();
            self.ufo_godmode_activated = undefined;
        }

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^1MODO UFO DESACTIVADO");
        else
            self iPrintLnBold("^1UFO MODE DISABLED");
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_ufo_mode)
            {
                status = self.ufo_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Modo UFO: " + status);
                else
                    self.menu_current.items[i].item setText("UFO Mode: " + status);
            }
        }
    }

    // Esperar más tiempo para evitar activaciones rápidas
    wait 0.5;
    self.is_toggling_ufo = undefined;
}

// Thread que maneja el modo UFO
ufo_mode_monitor()
{
    self endon("disconnect");
    self endon("stop_ufo_mode");

    // Crear objeto invisible para el vuelo
    if(!isDefined(self.ufo_object))
    {
        self.ufo_object = spawn("script_model", self.origin);
        self.ufo_object setModel("tag_origin");
    }

    self.fly_enabled = false;
    self.last_frag_press = 0; // Para controlar el tiempo entre presiones

    while(true)
    {
        // Controlar presiones rápidas de la tecla frag (G)
        if(self fragButtonPressed() && (getTime() - self.last_frag_press) > 500) // 500ms mínimo entre presiones
        {
            self.last_frag_press = getTime();

            if(!self.fly_enabled)
            {
                // Iniciar vuelo
                self playerLinkTo(self.ufo_object);
                self.fly_enabled = true;

                // Activar godmode durante el vuelo para evitar daño de paredes de muerte
                if(!self.godmode_enabled && !isDefined(self.ufo_godmode_activated))
                {
                    self enableInvulnerability();
                    self.ufo_flight_godmode = true; // Marcar que el godmode fue activado por vuelo
                }

                if(self.langLEN == 0)
                    self iPrintLn("^2VOLANDO...");
                else
                    self iPrintLn("^2FLYING...");
            }
            else
            {
                // Detener vuelo
                self unlink();
                self.fly_enabled = false;

                // Desactivar godmode de vuelo solo si no hay godmode general activado
                if(isDefined(self.ufo_flight_godmode) && self.ufo_flight_godmode && !self.godmode_enabled)
                {
                    self disableInvulnerability();
                    self.ufo_flight_godmode = undefined;
                }

                if(self.langLEN == 0)
                    self iPrintLn("^1VUELO DETENIDO");
                else
                    self iPrintLn("^1FLIGHT STOPPED");
            }
        }

        if(self.fly_enabled)
        {
            // Movimiento de vuelo suave
            fly_origin = self.ufo_object.origin + vectorScale(anglesToForward(self getPlayerAngles()), 20);
            self.ufo_object moveTo(fly_origin, 0.01);
        }

        wait 0.01;
    }
}


toggle_forge_mode()
{
    if (isDefined(self.is_toggling_forge))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_forge = true;

    if (!isDefined(self.forge_enabled))
        self.forge_enabled = false;

    self.forge_enabled = !self.forge_enabled;

    if (self.forge_enabled)
    {
        // Desactivar UFO Mode si está activo (restricción)
        if(isDefined(self.ufo_enabled) && self.ufo_enabled)
        {
            self.ufo_enabled = false;
            self notify("stop_ufo_mode");

            // Limpiar objeto de vuelo si existe
            if(isDefined(self.ufo_object))
            {
                self.ufo_object delete();
                self.ufo_object = undefined;
            }

            // Desvincular si está vinculado
            if(isDefined(self.fly_enabled) && self.fly_enabled)
            {
                self unlink();
                self.fly_enabled = false;
            }

            // Desactivar godmode solo si fue activado por UFO
            if(isDefined(self.ufo_godmode_activated) && self.ufo_godmode_activated && !self.godmode_enabled)
            {
                self disableInvulnerability();
                self.ufo_godmode_activated = undefined;
            }

            if (self.langLEN == 0)
                self iPrintLn("^1MODO UFO DESACTIVADO (conflicto con Forge)");
            else
                self iPrintLn("^1UFO MODE DISABLED (conflict with Forge)");

            // Actualizar el texto del menú para UFO Mode
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_ufo_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Modo UFO: OFF");
                        else
                            self.menu_current.items[i].item setText("UFO Mode: OFF");
                        break;
                    }
                }
            }
        }

        // Desactivar Aimbot si está activo (restricción)
        if(isDefined(self.aimbot_enabled) && self.aimbot_enabled)
        {
            self.aimbot_enabled = false;
            self notify("stop_aimbot");

            if (self.langLEN == 0)
                self iPrintLn("^1AIMBOT DESACTIVADO (conflicto con Forge)");
            else
                self iPrintLn("^1AIMBOT DISABLED (conflict with Forge)");

            // Actualizar el texto del menú para Aimbot
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_aimbot)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Aimbot: OFF");
                        else
                            self.menu_current.items[i].item setText("Aimbot: OFF");
                        break;
                    }
                }
            }
        }

        self thread forge_mode_monitor();

        if (self.langLEN == 0)
            self iPrintLnBold("^2FORGE MODE ACTIVADO - Apunta con el mouse para mover objetos o zombies");
        else
            self iPrintLnBold("^2FORGE MODE ENABLED - Aim with mouse to move objects or zombies");
    }
    else
    {
        self notify("stop_forge_mode");

        if (self.langLEN == 0)
            self iPrintLnBold("^1FORGE MODE DESACTIVADO");
        else
            self iPrintLnBold("^1FORGE MODE DISABLED");
    }

    // Actualizar texto en menú
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            item = self.menu_current.items[i];
            if (item.func == ::toggle_forge_mode)
            {
                status = self.forge_enabled ? "ON" : "OFF";
                item.item setText("Forge Mode: " + status);
            }
        }
    }

    self.is_toggling_forge = undefined;
}

// ============================================
// ⚙️ MONITOR FORGE MODE - mover y rotar con G
// ============================================
forge_mode_monitor()
{
    self endon("disconnect");
    self endon("stop_forge_mode");

    picked_object = undefined;
    smooth_pos = undefined;
    rot_angle = 0;

    while (true)
    {
        // --- DETECTAR OBJETO / ZOMBIE ---
        if (self adsButtonPressed())
        {
            if (!isDefined(picked_object))
            {
                start_pos = self getTagOrigin("j_head");
                end_pos = start_pos + vectorScale(anglesToForward(self getPlayerAngles()), 1000);
                trace = bulletTrace(start_pos, end_pos, true, self);

                if (isDefined(trace["entity"]) && trace["entity"] != self)
                {
                    obj = trace["entity"];

                    if (isDefined(obj) && isDefined(obj.origin))
                    {
                        picked_object = obj;
                        smooth_pos = obj.origin;

                    
                    }
                }
            }

            // --- MOVER OBJETO / ZOMBIE ---
            if (isDefined(picked_object) && isDefined(picked_object.origin))
            {
                start_pos = self getTagOrigin("j_head");
                desired_pos = start_pos + vectorScale(anglesToForward(self getPlayerAngles()), 200);
                smooth_pos = vectorLerp(smooth_pos, desired_pos, 0.25);
                picked_object.origin = smooth_pos;

                if (isDefined(level._effect["powerup_grabbed"]))
                    playFX(level._effect["powerup_grabbed"], smooth_pos);
            }
        }
        else
        {
            // --- SOLTAR OBJETO / ZOMBIE ---
            if (isDefined(picked_object))
            {
                picked_object = undefined;
                smooth_pos = undefined;

            }
        }

        // --- ROTAR OBJETO CON TECLA G ---
        if (self fragButtonPressed() && isDefined(picked_object))
        {
            rot_angle += 15;
            if (rot_angle >= 360)
                rot_angle = 0;

            current_angles = picked_object.angles;
            new_angles = (current_angles[0], current_angles[1] + 15, current_angles[2]);
            picked_object.angles = new_angles;
        }

        wait 0.02;
    }
}

// ============================================
// 🔄 Interpolación (suavizado de movimiento)
// ============================================
vectorLerp(start, end, frac)
{
    return ((start[0] + (end[0] - start[0]) * frac),
            (start[1] + (end[1] - start[1]) * frac),
            (start[2] + (end[2] - start[2]) * frac));
}

// Función para activar/desactivar JetPack
toggle_jetpack()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_jetpack))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_jetpack = true;

    // Cambiar el estado del JetPack
    if(!isDefined(self.jetpack_enabled))
        self.jetpack_enabled = false;

    self.jetpack_enabled = !self.jetpack_enabled;

    if(self.jetpack_enabled)
    {
        // Activar JetPack
        self thread jetpack_monitor();

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^2JETPACK ACTIVADO - Salta para volar");
        else
            self iPrintLnBold("^2JETPACK ENABLED - Jump to fly");
    }
    else
    {
        // Desactivar JetPack
        self notify("stop_jetpack");

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^1JETPACK DESACTIVADO");
        else
            self iPrintLnBold("^1JETPACK DISABLED");
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_jetpack)
            {
                status = self.jetpack_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("JetPack: " + status);
                else
                    self.menu_current.items[i].item setText("JetPack: " + status);
            }
        }
    }

    self.is_toggling_jetpack = undefined;
}

// Thread que maneja el JetPack
jetpack_monitor()
{
    self endon("disconnect");
    self endon("stop_jetpack");

    self.jetpack_fuel = 100; // Combustible del jetpack

    while(true)
    {
        if(self jumpButtonPressed() && self.jetpack_fuel > 0 && !self isOnGround())
        {
            // Efectos visuales del jetpack
            playFX(level._effect["lght_marker_flare"], self getTagOrigin("J_Ankle_RI"));
            playFX(level._effect["lght_marker_flare"], self getTagOrigin("J_Ankle_LE"));

            // Vibración leve
            earthquake(0.15, 0.2, self getTagOrigin("j_spine4"), 50);

            // Impulso hacia arriba
            if(self getVelocity()[2] < 300)
            {
                self setVelocity(self getVelocity() + (0, 0, 60));
            }

            self.jetpack_fuel--;

            // Mostrar combustible restante
            if(self.jetpack_fuel % 20 == 0)
            {
                if(self.langLEN == 0)
                    self iPrintLnBold("Combustible: " + self.jetpack_fuel);
                else
                    self iPrintLnBold("Fuel: " + self.jetpack_fuel);
            }
        }

        // Regenerar combustible cuando no se usa
        if(self.jetpack_fuel < 100 && !self jumpButtonPressed())
        {
            self.jetpack_fuel++;
        }

        wait 0.05;
    }
}

//====================================================================================
// FUNCIONES DE COMBATE AVANZADO
//====================================================================================

// Función para activar/desactivar Aimbot
toggle_aimbot()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_aimbot))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_aimbot = true;

    // Cambiar el estado del Aimbot
    if(!isDefined(self.aimbot_enabled))
        self.aimbot_enabled = false;

    self.aimbot_enabled = !self.aimbot_enabled;

    if(self.aimbot_enabled)
    {
        // Desactivar Teleport Zombies si está activo (restricción)
        if(isDefined(self.teleport_zombies_enabled) && self.teleport_zombies_enabled)
        {
            self.teleport_zombies_enabled = false;
            self notify("teleport_zombies_off");

            if (self.langLEN == 0)
                self iPrintLnBold("^1TELEPORT ZOMBIES DESACTIVADO (conflicto con Aimbot)");
            else
                self iPrintLnBold("^1TELEPORT ZOMBIES DISABLED (conflict with Aimbot)");

            // Actualizar el texto del menú para Teleport Zombies
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_teleport_zombies)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Teleport Zombies: OFF");
                        else
                            self.menu_current.items[i].item setText("Teleport Zombies: OFF");
                        break;
                    }
                }
            }
        }

        // Desactivar UFO Mode si está activo (restricción)
        if(isDefined(self.ufo_enabled) && self.ufo_enabled)
        {
            self.ufo_enabled = false;
            self notify("stop_ufo_mode");

            // Limpiar objeto de vuelo si existe
            if(isDefined(self.ufo_object))
            {
                self.ufo_object delete();
                self.ufo_object = undefined;
            }

            // Desvincular si está vinculado
            if(isDefined(self.fly_enabled) && self.fly_enabled)
            {
                self unlink();
                self.fly_enabled = false;
            }

            // Desactivar godmode solo si fue activado por UFO
            if(isDefined(self.ufo_godmode_activated) && self.ufo_godmode_activated && !self.godmode_enabled)
            {
                self disableInvulnerability();
                self.ufo_godmode_activated = undefined;
            }

            if (self.langLEN == 0)
                self iPrintLnBold("^1MODO UFO DESACTIVADO (conflicto con Aimbot)");
            else
                self iPrintLnBold("^1UFO MODE DISABLED (conflict with Aimbot)");

            // Actualizar el texto del menú para UFO Mode
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_ufo_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Modo UFO: OFF");
                        else
                            self.menu_current.items[i].item setText("UFO Mode: OFF");
                        break;
                    }
                }
            }
        }

        // Desactivar Forge Mode si está activo (restricción)
        if(isDefined(self.forge_enabled) && self.forge_enabled)
        {
            self.forge_enabled = false;
            self notify("stop_forge_mode");

            if (self.langLEN == 0)
                self iPrintLnBold("^1FORGE MODE DESACTIVADO (conflicto con Aimbot)");
            else
                self iPrintLnBold("^1FORGE MODE DISABLED (conflict with Aimbot)");

            // Actualizar el texto del menú para Forge Mode
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_forge_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        else
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        break;
                    }
                }
            }
        }

        // Activar Aimbot
        self thread aimbot_monitor();

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^2AIMBOT ACTIVADO");
        else
            self iPrintLnBold("^2AIMBOT ENABLED");
    }
    else
    {
        // Desactivar Aimbot
        self notify("stop_aimbot");

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^1AIMBOT DESACTIVADO");
        else
            self iPrintLnBold("^1AIMBOT DISABLED");
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_aimbot)
            {
                status = self.aimbot_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Aimbot: " + status);
                else
                    self.menu_current.items[i].item setText("Aimbot: " + status);
            }
        }
    }

    self.is_toggling_aimbot = undefined;
}

// Thread que maneja el Aimbot
aimbot_monitor()
{
    self endon("disconnect");
    self endon("stop_aimbot");

    while(true)
    {
        if(self adsButtonPressed())
        {
            // Buscar zombie más cercano
            zombies = getAIArray("axis");
            closest_zombie = undefined;
            closest_distance = 999999;

            foreach(zombie in zombies)
            {
                if(isDefined(zombie) && isAlive(zombie))
                {
                    distance = distance(self.origin, zombie.origin);
                    if(distance < closest_distance)
                    {
                        closest_distance = distance;
                        closest_zombie = zombie;
                    }
                }
            }

            // Apuntar automáticamente al zombie más cercano
            if(isDefined(closest_zombie))
            {
                head_pos = closest_zombie getTagOrigin("j_head");
                angles = vectorToAngles(head_pos - self getTagOrigin("j_head"));
                self setPlayerAngles(angles);

                // Disparar automáticamente si está configurado
                if(isDefined(self.aimbot_auto_fire) && self.aimbot_auto_fire)
                {
                    magicBullet(self getCurrentWeapon(), self getTagOrigin("j_head"), head_pos, self);
                }
            }
        }

        wait 0.05;
    }
}

// Función para activar/desactivar Artillery (artillería)
toggle_artillery()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_artillery))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_artillery = true;

    // Cambiar el estado del Artillery
    if(!isDefined(self.artillery_enabled))
        self.artillery_enabled = false;

    self.artillery_enabled = !self.artillery_enabled;

    if(self.artillery_enabled)
    {
        // Activar Artillery
        self thread artillery_monitor();

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^2ARTILLERIA ACTIVADA");
        else
            self iPrintLnBold("^2ARTILLERY ENABLED");
    }
    else
    {
        // Desactivar Artillery
        self notify("stop_artillery");

        // Notificar al jugador
        if(self.langLEN == 0)
            self iPrintLnBold("^1ARTILLERIA DESACTIVADA");
        else
            self iPrintLnBold("^1ARTILLERY DISABLED");
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_artillery)
            {
                status = self.artillery_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Artillery: " + status);
                else
                    self.menu_current.items[i].item setText("Artillery: " + status);
            }
        }
    }

    self.is_toggling_artillery = undefined;
}

// Thread que maneja la Artillery
artillery_monitor()
{
    self endon("disconnect");
    self endon("stop_artillery");

    while(true)
    {
        // Generar coordenadas aleatorias para el bombardeo
        x = randomIntRange(-2000, 2000);
        y = randomIntRange(-2000, 2000);
        z = randomIntRange(1100, 1200);

        target_pos = (x, y, z);

        // Crear explosión en el aire
        playFX(loadFX("explosions/fx_default_explosion"), target_pos);
        playFX(level._effect["def_explosion"], target_pos);

        // Daño por radio
        radiusDamage(target_pos, 500, 1000, 300, self);

        // Efectos de sonido
        playSoundAtPosition("evt_nuke_flash", target_pos);

        // Terremoto
        earthquake(2.5, 2, target_pos, 300);

        wait 0.01; // Muy rápido para efecto de lluvia de artillería
    }
}

//====================================================================================
// FUNCIONES DEL JUGADOR
//====================================================================================

// Función para clonar al jugador
clone_player()
{
    self iprintln("Clone ^2Spawned!");
    self ClonePlayer(9999);
}


// Función para auto revive
toggle_auto_revive()
{
    if(!isDefined(level.auto_revive_enabled) || level.auto_revive_enabled == false)
    {
        level.auto_revive_enabled = true;
        self thread auto_revive_monitor();
        self iPrintln("Auto Revive [^2ON^7]");
    }
    else
    {
        level.auto_revive_enabled = false;
        self iPrintln("Auto Revive [^1OFF^7]");
        self notify("auto_revive_off");
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_auto_revive)
            {
                status = level.auto_revive_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Auto Revive: " + status);
                else
                    self.menu_current.items[i].item setText("Auto Revive: " + status);
            }
        }
    }
}

auto_revive_monitor()
{
    self endon("disconnect");
    self endon("auto_revive_off");

    for(;;)
    {
        self thread revive_all_players();
        wait 0.05;
    }
}

revive_all_players()
{
    self endon("auto_revive_off");

    foreach(player in level.players)
    {
        if(isDefined(player.revivetrigger))
        {
            player.revivetrigger setinvisibletoall();
            player notify("revive_trigger");
            player.revivetrigger delete();
            player reviveplayer();
            player.laststand = undefined;
            player [[level.spawnplayer]]();
        }
    }
}

// Función para gore mode
toggle_gore_mode()
{
    if(!isDefined(self.gore_enabled) || self.gore_enabled == false)
    {
        self.gore_enabled = true;
        self iPrintlnBold("Gore Mode [^2ON^7]");
        self thread gore_effects();
    }
    else
    {
        self.gore_enabled = false;
        self iPrintlnBold("Gore Mode [^1OFF^7]");
        self notify("gore_off");
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_gore_mode)
            {
                status = self.gore_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Gore Mode: " + status);
                else
                    self.menu_current.items[i].item setText("Gore Mode: " + status);
            }
        }
    }
}

gore_effects()
{
    self endon("disconnect");
    self endon("gore_off");

    while(isDefined(self.gore_enabled) && self.gore_enabled)
    {
        foreach(player in level.players)
        {
            player endon("gore_off");
            playFx(level._effect["headshot"], player getTagOrigin("j_head"));
            playFx(level._effect["headshot"], player getTagOrigin("J_neck"));
            playFx(level._effect["headshot"], player getTagOrigin("J_Shoulder_LE"));
            playFx(level._effect["headshot"], player getTagOrigin("J_Shoulder_RI"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_Shoulder_LE"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_Shoulder_RI"));
            playFx(level._effect["headshot"], player getTagOrigin("J_Ankle_RI"));
            playFx(level._effect["headshot"], player getTagOrigin("J_Ankle_LE"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_Ankle_RI"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_Ankle_LE"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_wrist_RI"));
            playFx(level._effect["bloodspurt"], player getTagOrigin("J_wrist_LE"));
            playFx(level._effect["headshot"], player getTagOrigin("J_SpineLower"));
            wait 0.05;
        }
        wait 1.0; // Reduced frequency to prevent performance issues and zombie spawning problems
    }
}

// Función para abrir todas las puertas
open_all_doors()
{
    setdvar("zombie_unlock_all", 1);
    wait 0.5;
    self iPrintlnBold("Open all the doors ^2Success");

    triggers = strTok("zombie_doors|zombie_door|zombie_airlock_buy|zombie_debris|flag_blocker|window_shutter|zombie_trap", "|");

    for(a = 0; a < triggers.size; a++)
    {
        trigger = getEntArray(triggers[a], "targetname");
        for(b = 0; b < trigger.size; b++)
        {
            trigger[b] notify("trigger");
        }
    }
}

// Función para super jump
toggle_super_jump()
{
    if(!isDefined(self.super_jump_enabled) || self.super_jump_enabled == false)
    {
        self.super_jump_enabled = true;
        self thread super_jump_monitor();
        self iPrintlnBold("Super Jump [^2ON^7]");
    }
    else
    {
        self.super_jump_enabled = false;
        self notify("super_jump_off");
        self iPrintlnBold("Super Jump [^1OFF^7]");
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_super_jump)
            {
                status = self.super_jump_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Super Jump: " + status);
                else
                    self.menu_current.items[i].item setText("Super Jump: " + status);
                break;
            }
        }
    }
}

super_jump_monitor()
{
    self endon("disconnect");
    self endon("super_jump_off");

    for(;;)
    {
        foreach(player in level.players)
        {
            if(player getVelocity()[2] > 150 && !player isOnGround())
            {
                player setVelocity(player getVelocity() + (0, 0, 38));
            }
        }
        wait 0.001;
    }
}

// Función para kamikaze
do_kamikaze()
{
    self iPrintlnBold("Kamikaze send to your ^2position");

    kam = spawn("script_model", self.origin + (5000, 1000, 10000));
    kam setModel("defaultvehicle");
    kam.angles = vectorToAngles((kam.origin) - (self.origin)) - (180, 0, 180);
    kam moveTo(self.origin, 3.5, 2, 1.5);
    kam waittill("movedone");

    earthquake(2.5, 2, kam.origin, 300);
    playFx(level._effect["thunder"], kam.origin);
    playFx(loadFx("explosions/fx_default_explosion"), kam.origin);
    playFx(loadFx("explosions/fx_default_explosion"), kam.origin + (0, 20, 50));

    wait 0.1;
    playFx(loadFx("explosions/fx_default_explosion"), kam.origin);
    playFx(loadFx("explosions/fx_default_explosion"), kam.origin + (0, 20, 50));

    radiusDamage(kam.origin, 500, 1000, 300, self);
    kam delete();
}

//====================================================================================
// FUNCIONES DE ZOMBIES
//====================================================================================

// Función para freeze zombies (exactamente como en lecturademodificaciones.txt)
Fr3ZzZoM()
{
    self endon("disconnect");
    level endon("end_game");
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_freeze))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_freeze = true;

    if(self.Fr3ZzZoM == false)
    {
        self iPrintlnBold("Freeze Zombies [^2ON^7]");
        setdvar("g_ai", "0");
        self.Fr3ZzZoM = true;
    }
    else
    {
        self iPrintlnBold("Freeze Zombies [^1OFF^7]");
        setdvar("g_ai", "1");
        self.Fr3ZzZoM = false;
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::Fr3ZzZoM)
            {
                status = self.Fr3ZzZoM ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Zombie Freeze: " + status);
                else
                    self.menu_current.items[i].item setText("Zombie Freeze: " + status);
            }
        }
    }

    self.is_toggling_freeze = undefined;
}


// Función para teleport zombies
toggle_teleport_zombies()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_teleport))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_teleport = true;

    if(!isDefined(self.teleport_zombies_enabled) || self.teleport_zombies_enabled == false)
    {
        // Desactivar Forge Mode si está activo (restricción)
        if(isDefined(self.forge_enabled) && self.forge_enabled)
        {
            self.forge_enabled = false;
            self notify("stop_forge_mode");

            if (self.langLEN == 0)
                self iPrintLnBold("^1FORGE MODE DESACTIVADO (conflicto con Teleport Zombies)");
            else
                self iPrintLnBold("^1FORGE MODE DISABLED (conflict with Teleport Zombies)");

            // Actualizar el texto del menú para Forge Mode
            if (isDefined(self.menu_current))
            {
                for (i = 0; i < self.menu_current.items.size; i++)
                {
                    if (self.menu_current.items[i].func == ::toggle_forge_mode)
                    {
                        if (self.langLEN == 0)
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        else
                            self.menu_current.items[i].item setText("Forge Mode: OFF");
                        break;
                    }
                }
            }
        }

        // Desactivar Aimbot si está activo (restricción)
        if(isDefined(self.aimbot_enabled) && self.aimbot_enabled)
        {
            self.aimbot_enabled = false;
            self notify("stop_aimbot");

            if (self.langLEN == 0)
                self iPrintLnBold("^1AIMBOT DESACTIVADO (conflicto con Teleport Zombies)");
            else
                self iPrintLnBold("^1AIMBOT DISABLED (conflict with Teleport Zombies)");
        }

        self.teleport_zombies_enabled = true;
        self iPrintlnBold("Teleport Zombies To Crosshairs [^2ON^7]");
        self thread teleport_zombies_monitor();
    }
    else
    {
        self.teleport_zombies_enabled = false;
        self iPrintlnBold("Teleport Zombies To Crosshairs [^1OFF^7]");
        self notify("teleport_zombies_off");
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_teleport_zombies)
            {
                status = self.teleport_zombies_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Teleport Zombies: " + status);
                else
                    self.menu_current.items[i].item setText("Teleport Zombies: " + status);
            }
        }
    }

    self.is_toggling_teleport = undefined;
}

teleport_zombies_monitor()
{
    self endon("disconnect");
    self endon("teleport_zombies_off");

    for(;;)
    {
        self waittill("weapon_fired");

        zombs = getAiSpeciesArray("axis", "all");
        eye = self getEye();
        vec = anglesToForward(self getPlayerAngles());
        end = (vec[0] * 100000000, vec[1] * 100000000, vec[2] * 100000000);
        teleport_loc = bulletTrace(eye, end, 0, self)["position"];

        for(i = 0; i < zombs.size; i++)
        {
            zombs[i] forceTeleport(teleport_loc);
            if(isDefined(zombs[i].reset_attack_spot))
            {
                zombs[i] maps\mp\zombies\_zm_spawner::reset_attack_spot();
            }
        }
        wait 0.05;
    }
}

// Función para disable zombies
toggle_disable_zombies()
{
    // Evitar múltiples activaciones
    if(isDefined(self.is_toggling_disable))
    {
        wait 0.1;
        return;
    }

    self.is_toggling_disable = true;

    if(!isDefined(self.disable_zombies_enabled) || self.disable_zombies_enabled == false)
    {
        self.disable_zombies_enabled = true;
        self thread disable_zombies_monitor();
        self iPrintlnBold("Disable Zombies [^2ON^7]");
    }
    else
    {
        self.disable_zombies_enabled = false;
        self iPrintlnBold("Disable Zombies [^1OFF^7]");
        level notify("enable_zombies");
    }

    // Actualizar el texto del menú actual
    if (isDefined(self.menu_current))
    {
        for (i = 0; i < self.menu_current.items.size; i++)
        {
            if (self.menu_current.items[i].func == ::toggle_disable_zombies)
            {
                status = self.disable_zombies_enabled ? "ON" : "OFF";
                if (self.langLEN == 0)
                    self.menu_current.items[i].item setText("Disable Zombies: " + status);
                else
                    self.menu_current.items[i].item setText("Disable Zombies: " + status);
            }
        }
    }

    self.is_toggling_disable = undefined;
}

disable_zombies_monitor()
{
    level endon("enable_zombies");

    while(isDefined(self.disable_zombies_enabled) && self.disable_zombies_enabled)
    {
        zombs = getAiArray("axis");
        level.zombie_total = 0;

        if(isDefined(zombs))
        {
            for(i = 0; i < zombs.size; i++)
            {
                zombs[i] doDamage(zombs[i].health * 5000, (0, 0, 0), self);
                wait 0.05;
            }
        }

        wait 0.1;
    }
}



