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


init()
{
    level endon("end_game");
    level thread on_player_connect();
    level thread command_bar();
    // No realizamos ninguna activación automática aquí
}
on_player_connect()
{
    self endon( "end_game" );

    for (;;)
    {
        level waittill( "connected", player );
        // No activamos la barra automáticamente
        // Solo se activará desde el menú o comandos explícitos
    }
}
command_bar()
{
    level endon("end_game");
    prefix = "#";
    for (;;)
    {
        level waittill("say", message, player);
        message = toLower(message);
        if (!level.intermission && message[0] == prefix)
        {
            args = strtok(message, " ");
            command = getSubStr(args[0], 1);
            switch (command)
            {
                case "bar":
                if (isDefined(args[1]))
                    {
                    if (args[1] == "top")
                    {
                        functions = 1;
                        player.healthbar_enabled = true; // Actualizar el estado en el menú
                        player.healthbar_position = "top";
                        player thread bar_funtion_and_toogle(functions);
                    }
                    else if (args[1] == "left")
                    {
                        functions = 2;
                        player.healthbar_enabled = true; // Actualizar el estado en el menú
                        player.healthbar_position = "left";
                        player thread bar_funtion_and_toogle(functions);
                    }
                    else if (args[1] == "top_left" || args[1] == "topleft")
                    {
                        functions = 3;
                        player.healthbar_enabled = true; // Actualizar el estado en el menú
                        player.healthbar_position = "top_left";
                        player thread bar_funtion_and_toogle(functions);
                    }
                        else if (args[1] == "off")
                        {
                            functions = 100;
                            player.healthbar_enabled = false; // Actualizar el estado en el menú
                            player thread bar_funtion_and_toogle(functions);
                        }
                    }
                break;
            }
        }
    }
}

bar_funtion_and_toogle(functions)
{
    flag_wait("initial_blackscreen_passed");
    
    // Destruir todos los elementos existentes independientemente de la función
    if(isDefined(self.health_bar))
        self.health_bar render_destroy_elem();

    if(isDefined(self.health_info_text))
        self.health_info_text render_destroy_elem();

    if(isDefined(self.player_info_text))
        self.player_info_text destroy();

    if(isDefined(self.health_current_label))
        self.health_current_label destroy();

    if(isDefined(self.health_max_label))
        self.health_max_label destroy();

    if(isDefined(self.zombies_label))
        self.zombies_label destroy();
        
    // No crear nuevos elementos si la función es para desactivar (100)
    if(functions == 100)
        return;
    
    // Crear los elementos optimizados (solo 3 en total en lugar de 6)
    self.health_bar = self createprimaryprogressbar();
    self.health_info_text = self createFontString("Objective", 1);
    self.player_info_text = self createfontstring("Objective", 1);

    // Crear elementos para label/setvalue
    self.health_current_label = self createfontstring("Objective", 1);
    self.health_max_label = self createfontstring("Objective", 1);
    self.zombies_label = self createfontstring("Objective", 1);
    
    if(functions == 1) // top
    {
        // Configurar el texto de información del jugador (un poco más abajo)
        self.player_info_text setpoint("CENTER", 0, 0, -220);

        // Configurar la barra de progreso
        self.health_bar.width = 100;
        self.health_bar.height = 2;
        self.health_bar setpoint("CENTER", 0, "CENTER", -210);

        // Configurar los labels con setvalue (debajo de la barra, en línea)
        self.health_current_label setpoint("CENTER", 0, 0, -204);
        self.health_current_label.label = &"^7HP: ";
        self.health_current_label setvalue(self.health);
        self.health_current_label.x = self.health_bar.x - 35; // Alinear con borde izquierdo de la barra

        self.health_max_label setpoint("CENTER", 0, 0, -204);
        self.health_max_label.label = &" / ";
        self.health_max_label setvalue(self.maxhealth);
        self.health_max_label.x = self.health_current_label.x + 25; // Después del HP

        self.zombies_label setpoint("CENTER", 0, 0, -204);
        self.zombies_label.label = &"^1 - Zombies: ";
        self.zombies_label setvalue(0); // Inicializar con 0, se actualizará después
        self.zombies_label.x = self.health_max_label.x + 30; // Después del HP máximo

        // Iniciar hilos de actualización
        self thread update_zombies();
        self thread bar_health_funtion();
    }
    else if(functions == 2) // left
    {
        // Configurar el texto de información del jugador (arriba a la izquierda)
        self.player_info_text setpoint("LEFT", "LEFT", 0, 82);

        // Configurar la barra de progreso
        self.health_bar.width = 100;
        self.health_bar.height = 2;
        self.health_bar setpoint("LEFT", "LEFT", 0, 90);

        // Configurar los labels con setvalue (en línea como las otras barras)
        self.health_current_label setpoint("LEFT", "LEFT", 0, 100);
        self.health_current_label.label = &"^7HP: ";
        self.health_current_label setvalue(self.health);

        self.health_max_label setpoint("LEFT", "LEFT", 35, 100);
        self.health_max_label.label = &" / ";
        self.health_max_label setvalue(self.maxhealth);

        self.zombies_label setpoint("LEFT", "LEFT", 65, 100);
        self.zombies_label.label = &"^1 - Zombies: ";
        self.zombies_label setvalue(0); // Inicializar con 0, se actualizará después

        // Iniciar hilos de actualización
        self thread bar_health_funtion();
        self thread update_zombies();
    }
    else if(functions == 3) // top left (mismo diseño que left pero arriba)
    {
        // Configurar el texto de información del jugador (arriba a la izquierda)
        self.player_info_text setPoint("TOPLEFT", "TOPLEFT", 10, 22);

        // Configurar la barra de progreso
        self.health_bar.width = 100;
        self.health_bar.height = 2;
        self.health_bar setPoint("TOPLEFT", "TOPLEFT", 10, 35);

        // Configurar los labels con setvalue (debajo de la barra, en línea)
        self.health_current_label setPoint("TOPLEFT", "TOPLEFT", 10, 40);
        self.health_current_label.label = &"^7HP: ";
        self.health_current_label setvalue(self.health);

        self.health_max_label setPoint("TOPLEFT", "TOPLEFT", 45, 40);
        self.health_max_label.label = &" / ";
        self.health_max_label setvalue(self.maxhealth);
        self.health_max_label.x = self.health_current_label.x + 25; // Después del HP

        self.zombies_label setPoint("TOPLEFT", "TOPLEFT", 65, 40);
        self.zombies_label.label = &"^1 - Zombies: ";
        self.zombies_label.x = self.health_max_label.x + 30; // Después del HP máximo
        self.zombies_label setvalue(0); // Inicializar con 0, se actualizará después

        // Iniciar hilos de actualización
        self thread bar_health_funtion();
        self thread update_zombies();
    }
}

bar_health_funtion()
{
    level endon("end_game");
    self endon("endbar_health");
    self endon("disconnect");
    
    // Obtener información del mapa
    map = getDvar("ui_zm_mapstartlocation");
    map_name = "";
    
    switch (map)
    {
        case "tomb": map_name = "ORIGINS"; break;
        case "transit": map_name = "TRANSIT"; break;
        case "town": map_name = "TOWN"; break;
        case "farm": map_name = "FARM"; break;
        case "processing": map_name = "BURIED"; break;
        case "prison": map_name = "PRISON"; break;
        case "nuked": map_name = "NUKETOWN"; break;
        case "rooftop": map_name = "HIGHRISE"; break;
    }
    
    // Configura las propiedades de ocultación
    self.health_bar.hidewheninmenu = 1;
    self.health_info_text.hidewheninmenu = 1;
    self.player_info_text.hidewheninmenu = 1;
    self.health_current_label.hidewheninmenu = 1;
    self.health_max_label.hidewheninmenu = 1;
    self.zombies_label.hidewheninmenu = 1;

    // Asegurar que el fondo de la barra sea transparente para no interferir con el menú
    if(isDefined(self.health_bar.barframe))
        self.health_bar.barframe.alpha = 0;

    self.health_bar.hidewheninscope = 1;
    self.health_info_text.hidewheninscope = 1;
    self.player_info_text.hidewheninscope = 1;
    self.health_current_label.hidewheninscope = 1;
    self.health_max_label.hidewheninscope = 1;
    self.zombies_label.hidewheninscope = 1;
    
    // Configura el texto de información del jugador (nombre + mapa)
    player_info = self.name + " | " + map_name;
    self.player_info_text setText(player_info);
    
    zombie_count = 0; // Inicializar contador de zombies
    
    while (true)
    {
        // Actualizar contador de zombies (para no crear un hilo separado)
        if(isDefined(get_round_enemy_array()))
            zombie_count = get_round_enemy_array().size + level.zombie_total;
        
        if (isdefined(self.e_afterlife_corpse))
        {
            // Ocultar elementos en modo afterlife
            self.health_bar.bar.alpha = 0;
            // Mantener el barframe transparente para evitar interferencia con menú
            self.health_bar.barframe.alpha = 0;
            self.health_current_label.alpha = 0;
            self.health_max_label.alpha = 0;
            self.zombies_label.alpha = 0;
            self.player_info_text.alpha = 0;

            wait 0.05;
            continue;
        }

        // Mostrar elementos
        self.health_bar.alpha = 0;
        self.health_bar.bar.alpha = 1;
        // Mantener el barframe transparente para evitar interferencia con menú
        self.health_bar.barframe.alpha = 0;
        self.health_current_label.alpha = 1;
        self.health_max_label.alpha = 1;
        self.zombies_label.alpha = 1;
        self.player_info_text.alpha = 1;

        // Actualizar barra con porcentaje de salud
        health_percent = self.health / self.maxhealth;
        self.health_bar updatebar(health_percent);

        // Actualizar valores usando setvalue
        self.health_current_label setvalue(self.health);
        self.health_max_label setvalue(self.maxhealth);
        self.zombies_label setvalue(zombie_count);

        // Actualizar color según nivel de salud
        current_color = (0, 1, 0.5); // Verde por defecto

        if(self.health <= self.maxhealth && self.health >= 71)
            current_color = (0, 1, 0.5); // Verde
        else if(self.health <= 70 && self.health >= 50)
            current_color = (1, 1, 0); // Amarillo
        else if(self.health <= 49 && self.health >= 25)
            current_color = (1, 0.5, 0); // Naranja
        else if(self.health <= 24 && self.health >= 0)
            current_color = (0.5, 0, 0); // Rojo

        // Aplicar colores a elementos
        self.health_current_label.color = current_color;
        self.health_max_label.color = current_color;
        self.health_bar.bar.color = current_color;
        
        wait 0.5;
    }
}

update_zombies()
{
    // Esta función ya no se necesita ya que el conteo de zombies se maneja en bar_health_funtion
    // Pero la dejamos vacía por compatibilidad con código existente
    level endon("end_game");
    self endon("endbar_health");
    self endon("disconnect");
}

render_destroy_elem()
{
    foreach (child in self.children)
        child render_destroy_elem();

    self destroyelem();
}