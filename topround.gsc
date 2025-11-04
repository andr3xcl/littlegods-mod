#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp_utility;
#include common_scripts\utility;
#include scripts\zm\sqllocal;

//====================================================================================
// SISTEMA REDISEÑADO DE TOP DE RONDAS Y ESTADÍSTICAS
//====================================================================================

// Función que inicializa el sistema de estadísticas
TopRound()
{
    self endon("disconnect");

    // Solo inicializar una vez por partida
    if (isDefined(level.stats_system_initialized))
        return;

    level.stats_system_initialized = true;

    // Obtener el mapa actual
    level.current_game_map = getDvar("ui_zm_mapstartlocation");

    // Esperar a que termine el juego
    level waittill("end_game");

    // Procesar estadísticas para todos los jugadores una sola vez
    process_all_players_stats();
}

// Función que procesa las estadísticas de TODOS los jugadores
process_all_players_stats()
{
    round_reached = level.round_number;

    foreach (player in level.players)
    {
        if (isDefined(player) && isPlayer(player))
        {
            // NO procesar estadísticas si el developer mode está activado
            if (isDefined(player.developer_mode_unlocked) && player.developer_mode_unlocked)
            {
                continue; // Saltar este jugador
            }

            // Verificar si ya se procesaron las stats de este jugador
            if (!isDefined(player.stats_processed) || !player.stats_processed)
            {
                player.stats_processed = true;
                player thread process_single_player_stats(level.current_game_map, round_reached);
            }
        }
    }

    // Efectos finales (solo una vez, incluso si todos tienen developer mode)
    // Buscar el primer jugador que NO tenga developer mode activado
    foreach (player in level.players)
    {
        if (isDefined(player) && isPlayer(player) && (!isDefined(player.developer_mode_unlocked) || !player.developer_mode_unlocked))
        {
            player thread execute_map_end_effects(level.current_game_map);
            break; // Solo ejecutar una vez
        }
    }

    // Si todos tienen developer mode, ejecutar efectos con el primer jugador disponible
    if (!isDefined(level.effects_executed))
    {
        level.effects_executed = true;
        if (isDefined(level.players[0]))
        {
            level.players[0] thread execute_map_end_effects(level.current_game_map);
        }
    }
}

// Función que procesa estadísticas para un jugador individual
process_single_player_stats(current_map, round_reached)
{
    // Recopilar estadísticas de la partida
    self thread collect_game_stats();

    // Esperar a que se recopilen las estadísticas
    self waittill("stats_collected");

    // Obtener las estadísticas recopiladas
    kills = isDefined(self.game_kills) ? self.game_kills : 0;
    headshots = isDefined(self.game_headshots) ? self.game_headshots : 0;
    revives = isDefined(self.game_revives) ? self.game_revives : 0;
    downs = isDefined(self.game_downs) ? self.game_downs : 0;
    total_score = isDefined(self.score) ? self.score : 0;

    // Verificar el tipo de resultado de ronda
    round_result = scripts\zm\sqllocal::check_round_result(self, current_map, round_reached);

    // Guardar estadísticas automáticamente (solo si no es peor que el record)
    scripts\zm\sqllocal::save_player_round_data(self, current_map, round_reached, kills, headshots, revives, downs, total_score);

    // Mensaje de feedback según el tipo de resultado
    if (isDefined(self.langLEN) && self.langLEN == 0) // Español
    {
        switch (round_result)
        {
            case 3: // Primer record
                self iPrintlnBold("^3¡PRIMER RECORD!");
                self iPrintlnBold("^7Ronda: ^2" + round_reached + " ^7en " + get_map_display_name(current_map));
                break;

            case 2: // Nuevo record
                self iPrintlnBold("^3¡NUEVO RECORD PERSONAL!");
                self iPrintlnBold("^7Ronda: ^2" + round_reached + " ^7en " + get_map_display_name(current_map));
                break;

            case 1: // Igual que record
                self iPrintlnBold("^2¡RONDA IGUALADA!");
                self iPrintlnBold("^7Ronda: ^2" + round_reached + " ^7en " + get_map_display_name(current_map) + " ^7(igual que tu record)");
                break;

            case 0: // Peor que record
                self iPrintlnBold("^1Ronda no superada");
                self iPrintlnBold("^7Ronda: ^8" + round_reached + " ^7en " + get_map_display_name(current_map) + " ^7(record no actualizado)");
                break;

            default:
                self iPrintlnBold("^7Ronda: ^2" + round_reached);
            break;
        }
    }
    else // Inglés
    {
        switch (round_result)
        {
            case 3: // First record
                self iPrintlnBold("^3FIRST RECORD!");
                self iPrintlnBold("^7Round: ^2" + round_reached + " ^7in " + get_map_display_name(current_map));
                break;

            case 2: // New record
                self iPrintlnBold("^3NEW PERSONAL RECORD!");
                self iPrintlnBold("^7Round: ^2" + round_reached + " ^7in " + get_map_display_name(current_map));
                break;

            case 1: // Equal to record
                self iPrintlnBold("^2ROUND TIED!");
                self iPrintlnBold("^7Round: ^2" + round_reached + " ^7in " + get_map_display_name(current_map) + " ^7(equal to your record)");
                break;

            case 0: // Worse than record
                self iPrintlnBold("^1Round not beaten");
                self iPrintlnBold("^7Round: ^8" + round_reached + " ^7in " + get_map_display_name(current_map) + " ^7(record not updated)");
                break;

            default:
                self iPrintlnBold("^7Round: ^2" + round_reached);
                break;
        }
    }
}

// Función para recopilar estadísticas de la partida
collect_game_stats()
{
    self.game_kills = 0;
    self.game_headshots = 0;
    self.game_revives = 0;
    self.game_downs = 0;

    // Contar kills
    if (isDefined(self.pers["kills"]))
        self.game_kills = self.pers["kills"];

    // Contar headshots (si está disponible)
    if (isDefined(self.pers["headshots"]))
        self.game_headshots = self.pers["headshots"];

    // Contar revives
    if (isDefined(self.pers["revives"]))
        self.game_revives = self.pers["revives"];

    // Contar downs
    if (isDefined(self.pers["downs"]))
        self.game_downs = self.pers["downs"];

    wait 0.5;
    self notify("stats_collected");
}

// Función para obtener el nombre display del mapa
get_map_display_name(map_code)
{
    switch (map_code)
    {
        case "tomb": return "Origins";
        case "transit": return "Transit";
        case "processing": return "Buried";
        case "prison": return "Mob of the Dead";
        case "nuked": return "Nuketown";
        case "highrise": return "Die Rise";
        default: return map_code;
    }
}

// Función para ejecutar efectos finales según el mapa
execute_map_end_effects(map_code)
{
    trace = (0, 0, 3000);

    switch (map_code)
    {
        case "tomb": // Origins - Efectos especiales
            earthquake(0.9, 15, (0, 0, 0), 100000);
            foreach (player in level.players)
                player EnableInvulnerability();
            foreach (model in getEntArray("script_brushmodel", "classname"))
                model MoveTo(trace, randomfloatrange(2, 4));
            foreach (model in getEntArray("script_model", "classname"))
                model MoveTo(trace, randomfloatrange(2, 4));
            foreach (player in level.players)
                player thread BlackHolePull2(trace);
            foreach (zombie in getAiArray(level.zombie_team))
                zombie forceteleport(trace, self.angles + vectorScale((0, 1, 0), 180));
            wait 3;
            playfx(loadfx("explosions/fx_default_explosion"), trace);
            playfx(loadFx("misc/fx_zombie_mini_nuke_hotness"), trace);
            foreach (model in getEntArray("script_brushmodel", "classname"))
                    model Delete();
            foreach (model in getEntArray("script_model", "classname"))
                    model Delete();
            wait 0.1;
            foreach (player in level.players)
            {
                player DisableInvulnerability();
                RadiusDamage(trace, 500, 99999, 99999, player);
            }
            break;

        case "transit": // Transit - Efectos estándar
            earthquake(0.6, 10, (0, 0, 0), 50000);
            foreach (player in level.players)
                player EnableInvulnerability();
            wait 2;
            foreach (player in level.players)
                player DisableInvulnerability();
            break;

        case "processing": // Buried - Efectos estándar
            earthquake(0.7, 12, (0, 0, 0), 75000);
            foreach (player in level.players)
                player EnableInvulnerability();
            wait 2;
            foreach (player in level.players)
                player DisableInvulnerability();
            break;

        case "prison": // Mob of the Dead - Sin efectos especiales
            earthquake(0.5, 8, (0, 0, 0), 25000);
            wait 1;
            break;

        default: // Efectos estándar para otros mapas
            earthquake(0.4, 6, (0, 0, 0), 20000);
            wait 1;
            break;
    }

    level notify("end_game");
}

// Función auxiliar para BlackHolePull2 (si existe)
BlackHolePull2(trace)
{
    // Implementación básica si la función no existe
    self setOrigin(trace);
}