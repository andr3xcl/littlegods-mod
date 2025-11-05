#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

//====================================================================================
// SISTEMA DE GUARDADO DE ESTADÍSTICAS POR JUGADOR Y MAPA
//====================================================================================

// Función para guardar una partida reciente
save_recent_match(player, map_name, round_number, kills, headshots, revives, downs, score)
{
    // Obtener GUID del jugador
    player_guid = player getGuid();

    // Crear directorio del jugador si no existe
    directory = "scriptdata/recent/" + player_guid + "/";

    // Obtener el número de la siguiente partida reciente
    next_match_number = get_next_recent_match_number(player_guid, map_name);

    // Crear nombre del archivo: mapa_recent_X.txt
    filename = directory + map_name + "_recent_" + next_match_number + ".txt";

    // Actualizar el archivo de índice
    update_match_index(player_guid, map_name, next_match_number);

    file = fs_fopen(filename, "write");

    if (!isDefined(file))
    {
        self iPrintlnBold("^1Error: No se pudo crear archivo de partida reciente");
        return;
    }

    // Obtener datos del jugador
    player_name = player.name;
    if (!isDefined(player_name) || player_name == "")
        player_name = "Unknown Player";

    current_time = getTime();

    // Escribir datos de la partida reciente
    fs_write(file, "================================\n");
    fs_write(file, "PARTIDA RECIENTE #" + next_match_number + "\n");
    fs_write(file, "================================\n");
    fs_write(file, "Jugador: " + player_name + "\n");
    fs_write(file, "GUID: " + player_guid + "\n");
    fs_write(file, "Mapa: " + map_name + "\n");
    fs_write(file, "Ronda Alcanzada: " + round_number + "\n");
    fs_write(file, "\n");
    fs_write(file, "ESTADISTICAS DE LA PARTIDA:\n");
    fs_write(file, "Kills: " + kills + "\n");
    fs_write(file, "Headshots: " + headshots + "\n");
    fs_write(file, "Revives: " + revives + "\n");
    fs_write(file, "Downs: " + downs + "\n");
    fs_write(file, "Score Total: " + score + "\n");
    fs_write(file, "\n");
    fs_write(file, "Fecha/Hora: " + current_time + "\n");
    fs_write(file, "================================\n");

    fs_fclose(file);

    // Mensaje de confirmación
    if (isDefined(player) && isPlayer(player))
    {
        player iPrintlnBold("^2Partida reciente guardada (#" + next_match_number + ")");
    }
}

// Función para guardar estadísticas del jugador al morir (para compatibilidad)
save_player_round_data(player, map_name, round_number, kills, headshots, revives, downs, score)
{
    // Usar la nueva función de partidas recientes
    save_recent_match(player, map_name, round_number, kills, headshots, revives, downs, score);
}

// Función para obtener el siguiente número de partida reciente
get_next_recent_match_number(player_guid, map_name)
{
    // Leer el archivo de índice para este mapa
    index_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "_index.txt";

    if (!fs_testfile(index_filename))
    {
        // Si no existe el archivo de índice, es la primera partida
        return 1;
    }

    // Leer el último número usado
    file = fs_fopen(index_filename, "read");
    if (!isDefined(file))
    {
        return 1; // Si no puede leer, asumir primera partida
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    // El contenido debería ser solo el número
    last_number = int(content);

    // Retornar el siguiente número
    return last_number + 1;
}

// Función para actualizar el archivo de índice
update_match_index(player_guid, map_name, match_number)
{
    index_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "_index.txt";

    file = fs_fopen(index_filename, "write");
    if (!isDefined(file))
    {
        // Si no puede crear el archivo de índice, no hay problema
        // La próxima vez asumirá que es la primera partida
        return;
    }

    // Escribir el número actual
    fs_write(file, "" + match_number);
    fs_fclose(file);
}

// Función para mostrar las partidas recientes de un jugador
show_recent_matches(player, map_name)
{
    player_guid = player getGuid();

    // Leer el archivo de índice para saber cuántas partidas hay
    index_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "_index.txt";

    if (!fs_testfile(index_filename))
    {
        // No hay partidas para este mapa
        if (isDefined(player.langLEN) && player.langLEN == 0)
            player iPrintlnBold("^3No hay partidas recientes en " + get_map_display_name(map_name));
        else
            player iPrintlnBold("^3No recent matches in " + get_map_display_name(map_name));
        return;
    }

    // Leer el último número
    file = fs_fopen(index_filename, "read");
    if (!isDefined(file))
    {
        if (isDefined(player.langLEN) && player.langLEN == 0)
            player iPrintlnBold("^3No hay partidas recientes en " + get_map_display_name(map_name));
        else
            player iPrintlnBold("^3No recent matches in " + get_map_display_name(map_name));
        return;
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    last_match_number = int(content);

    // Crear lista de archivos existentes (del último hacia atrás, máximo 5)
    files = [];
    for (i = last_match_number; i > 0 && files.size < 5; i--)
    {
        filename = "scriptdata/recent/" + player_guid + "/" + map_name + "_recent_" + i + ".txt";
        if (fs_testfile(filename))
        {
            files[files.size] = map_name + "_recent_" + i + ".txt";
        }
    }

    if (!isDefined(files) || files.size == 0)
    {
        if (isDefined(player.langLEN) && player.langLEN == 0)
            player iPrintlnBold("^3No hay partidas recientes en " + get_map_display_name(map_name));
        else
            player iPrintlnBold("^3No recent matches in " + get_map_display_name(map_name));
        return;
    }

    // Mostrar header
    if (isDefined(player.langLEN) && player.langLEN == 0)
        player iPrintlnBold("^6=== PARTIDAS RECIENTES: " + get_map_display_name(map_name) + " (" + files.size + ") ===");
    else
        player iPrintlnBold("^6=== RECENT MATCHES: " + get_map_display_name(map_name) + " (" + files.size + ") ===");

    // Mostrar cada partida (máximo 5 para no spam)
    display_count = min(files.size, 5);

    for (i = 0; i < display_count; i++)
    {
        filename = "scriptdata/recent/" + player_guid + "/" + files[i];

        if (!fs_testfile(filename))
            continue;

        file = fs_fopen(filename, "read");
        if (!isDefined(file))
            continue;

        file_size = fs_length(file);
        content = fs_read(file, file_size);
        fs_fclose(file);

        // Extraer información básica
        lines = strTok(content, "\n");
        round_info = "";
        score_info = "";
        time_info = "";

        foreach (line in lines)
        {
            if (isSubStr(line, "Ronda Alcanzada:"))
            {
                round_info = getSubStr(line, 16);
            }
            else if (isSubStr(line, "Score Total:"))
            {
                score_info = getSubStr(line, 12);
            }
            else if (isSubStr(line, "Fecha/Hora:"))
            {
                time_info = getSubStr(line, 11);
            }
        }

        wait 0.2; // Evitar spam

        // Extraer el número del nombre del archivo
        parts = strTok(files[i], "_");
        match_num = int(getSubStr(parts[2], 0, parts[2].size - 4));

        if (isDefined(player.langLEN) && player.langLEN == 0)
        {
            player iPrintln("^7#" + match_num + " ^2Ronda: ^7" + round_info + " ^3Score: ^7" + score_info);
        }
        else
        {
            player iPrintln("^7#" + match_num + " ^2Round: ^7" + round_info + " ^3Score: ^7" + score_info);
        }
    }

    if (files.size > 5)
    {
        if (isDefined(player.langLEN) && player.langLEN == 0)
            player iPrintln("^8... y " + (files.size - 5) + " más");
        else
            player iPrintln("^8... and " + (files.size - 5) + " more");
    }
}

// Función auxiliar para obtener nombre del mapa
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

// Función para cargar datos de un jugador (simplificada)
load_player_round_data(player_guid, map_name)
{
    filename = map_name + "_" + player_guid + ".txt";

    if (!fs_testfile(filename))
    {
        return undefined;
    }

    file = fs_fopen(filename, "read");

    if (!isDefined(file))
    {
        return undefined;
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);
    
    // Crear datos básicos del jugador (solo verificamos si existe el archivo)
    player_data = [];
    player_data["exists"] = true;
    player_data["guid"] = player_guid;
    player_data["map"] = map_name;

    return player_data;
}

// Función para verificar el tipo de resultado de ronda
// Retorna: 0 = peor que record, 1 = igual que record, 2 = nuevo record, 3 = primer record
check_round_result(player, map_name, current_round)
{
    // Usar la misma lógica de GUID que save_player_round_data
    player_guid = player getGuid();

    if (!isDefined(player_guid) || player_guid == "" || player_guid == "0")
    {
        if (isDefined(player.name) && player.name != "")
        {
            player_guid = "name_" + player.name;
        }
        else
        {
            player_guid = "unknown_" + randomInt(999999);
        }
    }

    filename = map_name + "_" + player_guid + ".txt";

    // Si no existe el archivo, es el primer record
    if (!fs_testfile(filename))
        return 3; // Primer record

    // Leer el archivo existente para obtener la ronda guardada
    file = fs_fopen(filename, "read");
    if (!isDefined(file))
        return 3; // Si no puede leer, asumir que es primer record

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);
    
    // Buscar la línea con "Ronda Alcanzada:"
    lines = strTok(content, "\n");
    saved_round = 0;

    foreach (line in lines)
    {
        if (isSubStr(line, "Ronda Alcanzada:"))
        {
            saved_round_str = getSubStr(line, 17);
            saved_round = int(saved_round_str);
            break;
        }
    }

    // Determinar el tipo de resultado
    if (current_round > saved_round)
        return 2; // Nuevo record
    else if (current_round == saved_round)
        return 1; // Igual que record
    else
        return 0; // Peor que record
}

// Función para verificar si el jugador superó su record personal (simplificada) - mantiene compatibilidad
check_personal_record(player, map_name, current_round)
{
    result = check_round_result(player, map_name, current_round);
    return (result == 2 || result == 3); // Nuevo record o primer record
}

// Función para listar todos los archivos de estadísticas
list_all_stats_files()
{
    files = fs_listfiles("*.txt");

    if (!isDefined(files) || files.size == 0)
    {
        self iPrintlnBold("^3No hay archivos de estadísticas guardados");
        return;
    }

    self iPrintlnBold("^6=== ARCHIVOS DE ESTADÍSTICAS (" + files.size + ") ===");

    for (i = 0; i < files.size; i++)
    {
        wait 0.2;
        self iPrintln("^7" + (i + 1) + ". " + files[i]);
    }
}

// Función para mostrar estadísticas de un jugador específico (simplificada)
show_player_stats(player_guid, map_name)
{
    filename = map_name + "_" + player_guid + ".txt";

    if (!fs_testfile(filename))
    {
        self iPrintlnBold("^3No hay estadísticas para este jugador en " + map_name);
        return;
    }
    
    file = fs_fopen(filename, "read");
    
    if (!isDefined(file))
    {
        self iPrintlnBold("^1Error al leer archivo de estadísticas");
        return;
    }
    
    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);
    
    self iPrintlnBold("^6=== ESTADÍSTICAS DEL JUGADOR ===");
    self iPrintlnBold("^7Archivo: ^2" + filename);
    self iPrintlnBold("^7Jugador: ^2" + player_guid);
    self iPrintlnBold("^7Mapa: ^2" + map_name);
    self iPrintlnBold("^3Archivo existe y contiene datos");
}

//====================================================================================
// SISTEMA DE BANCO GLOBAL
//====================================================================================

get_bank_balance(player)
{
    player_id = player getGuid();

    return get_bank_balance_with_id(player_id);
}

bank_deposit(player, amount)
{
    if (!isDefined(amount) || amount <= 0)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1Cantidad inválida");
        else
            player iPrintlnBold("^1Invalid amount");
        return;
    }

    if (player.score < amount)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No tienes suficientes puntos");
        else
            player iPrintlnBold("^1Not enough points");
        return;
    }

    player_id = player getGuid();

    filename = "bank/" + player_id + ".txt";


    current_balance = get_bank_balance_with_id(player_id);


    new_balance = current_balance + amount;


    player.score -= amount;


    file = fs_fopen(filename, "write");

    if (!isDefined(file))
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1Error al acceder al banco");
        else
            player iPrintlnBold("^1Error accessing bank");
        // Devolver puntos al jugador
        player.score += amount;
        return;
    }

    current_time = getTime();

    // Escribir datos del banco
    fs_write(file, "================================\n");
    fs_write(file, "CUENTA BANCARIA\n");
    fs_write(file, "================================\n");
    fs_write(file, "Jugador: " + player.name + "\n");
    fs_write(file, "ID: " + player_id + "\n");
    if (player.langLEN == 0)
        fs_write(file, "Ultima Transaccion: Deposito de " + amount + " puntos\n");
    else
        fs_write(file, "Last Transaction: Deposit of " + amount + " points\n");
    fs_write(file, "Fecha/Hora: " + current_time + "\n");
    fs_write(file, "Balance: " + new_balance + "\n");
    fs_write(file, "================================\n");

    fs_fclose(file);

    if (player.langLEN == 0)
        player iPrintlnBold("^2Depositaste ^7" + amount + "^2 puntos. Balance: ^7" + new_balance);
    else
        player iPrintlnBold("^2Deposited ^7" + amount + "^2 points. Balance: ^7" + new_balance);
}

get_bank_balance_with_id(player_id)
{
    filename = "bank/" + player_id + ".txt"; // directory path


    if (!fs_testfile(filename))
    {
        return 0;
    }

    file = fs_fopen(filename, "read");

    if (!isDefined(file))
    {
        return 0;
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    lines = strTok(content, "\n");
    for (i = 0; i < lines.size; i++)
    {
        line = lines[i];
        if (isSubStr(line, "Balance: "))
        {
            balance_str = getSubStr(line, 9); // "Balance: " tiene 9 caracteres
            return int(balance_str);
        }
    }

    return 0;
}

bank_deposit_all(player)
{
    amount = player.score;

    if (amount <= 0)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No tienes puntos para depositar");
        else
            player iPrintlnBold("^1No points to deposit");
        return;
    }

    bank_deposit(player, amount);
}

bank_withdraw(player, amount)
{
    if (!isDefined(amount) || amount <= 0)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1Cantidad inválida");
        else
            player iPrintlnBold("^1Invalid amount");
        return;
    }

    // Obtener identificador del jugador (GUID directo)
    player_id = player getGuid();

    // Obtener balance actual usando el mismo player_id
    current_balance = get_bank_balance_with_id(player_id);

    if (current_balance < amount)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No tienes suficientes puntos en el banco");
        else
            player iPrintlnBold("^1Not enough points in bank");
        return;
    }

    filename = "bank/" + player_id + ".txt";

    // Calcular nuevo balance
    new_balance = current_balance - amount;

    // Agregar puntos al jugador
    player.score += amount;

    // Actualizar archivo
    file = fs_fopen(filename, "write");

    if (!isDefined(file))
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1Error al acceder al banco");
        else
            player iPrintlnBold("^1Error accessing bank");
        // Quitar puntos del jugador
        player.score -= amount;
        return;
    }

    // Obtener fecha/hora
    current_time = getTime();

    // Escribir datos actualizados
    fs_write(file, "================================\n");
    fs_write(file, "CUENTA BANCARIA\n");
    fs_write(file, "================================\n");
    fs_write(file, "Jugador: " + player.name + "\n");
    fs_write(file, "ID: " + player_id + "\n");
    if (player.langLEN == 0)
        fs_write(file, "Ultima Transaccion: Retiro de " + amount + " puntos\n");
    else
        fs_write(file, "Last Transaction: Withdrawal of " + amount + " points\n");
    fs_write(file, "Fecha/Hora: " + current_time + "\n");
    fs_write(file, "Balance: " + new_balance + "\n");
    fs_write(file, "================================\n");

    fs_fclose(file);

    if (player.langLEN == 0)
        player iPrintlnBold("^2Retiraste ^7" + amount + "^2 puntos. Balance restante: ^7" + new_balance);
    else
        player iPrintlnBold("^2Withdrew ^7" + amount + "^2 points. Remaining balance: ^7" + new_balance);
}

bank_withdraw_all(player)
{
    // Obtener identificador del jugador (GUID directo)
    player_id = player getGuid();

    current_balance = get_bank_balance_with_id(player_id);

    if (current_balance <= 0)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No tienes puntos en el banco");
        else
            player iPrintlnBold("^1No points in bank");
        return;
    }

    bank_withdraw(player, current_balance);
}

//====================================================================================
// SISTEMA DE GUARDADO DE CONFIGURACIÓN DEL MENÚ
//====================================================================================

// Función para guardar la configuración del menú del jugador
save_menu_config(player)
{
    // Obtener GUID del jugador
    player_guid = player getGuid();

    // Crear nombre del archivo: scriptdata/menu/guid.txt
    filename = "scriptdata/menu/" + player_guid + ".txt";

    file = fs_fopen(filename, "write");

    if (!isDefined(file))
    {
        player iPrintlnBold("^1Error: No se pudo crear archivo de configuración");
        return false;
    }

    // Obtener nombre del jugador
    player_name = player.name;
    if (!isDefined(player_name) || player_name == "")
        player_name = "Unknown Player";

    // Obtener fecha/hora
    current_time = getTime();

    // Escribir cabecera del archivo
    fs_write(file, "================================\n");
    fs_write(file, "CONFIGURACION DEL MENU\n");
    fs_write(file, "================================\n");
    fs_write(file, "Jugador: " + player_name + "\n");
    fs_write(file, "GUID: " + player_guid + "\n");
    fs_write(file, "Fecha/Hora: " + current_time + "\n");
    fs_write(file, "\n");
    fs_write(file, "CONFIGURACION GUARDADA:\n");

    // Guardar configuración de idioma
    lang_value = isDefined(player.langLEN) ? player.langLEN : 0;
    fs_write(file, "language=" + lang_value + "\n");

    // Guardar estilo del menú
    menu_style = isDefined(player.menu_style_index) ? player.menu_style_index : 0;
    fs_write(file, "menu_style=" + menu_style + "\n");

    // Guardar estilo del sector
    sector_style = isDefined(player.sector_style_index) ? player.sector_style_index : 0;
    fs_write(file, "sector_style=" + sector_style + "\n");

    // Guardar estilo del selector
    selector_style = isDefined(player.selector_style_index) ? player.selector_style_index : 14;
    fs_write(file, "selector_style_index=" + selector_style + "\n");

    // Guardar posición del texto
    font_position = isDefined(player.font_position_index) ? player.font_position_index : 0;
    fs_write(file, "font_position_index=" + font_position + "\n");

    // Guardar animación de fuente
    font_animation = isDefined(player.font_animation_index) ? player.font_animation_index : 0;
    fs_write(file, "font_animation=" + font_animation + "\n");

    // Guardar transparencia
    transparency_index = isDefined(player.transparency_index) ? player.transparency_index : 0;
    fs_write(file, "transparency_index=" + transparency_index + "\n");


    fs_write(file, "\n");
    fs_write(file, "================================\n");

    fs_fclose(file);

    // Mensaje de confirmación
    if (isDefined(player) && isPlayer(player))
    {
        player iPrintlnBold("^2Configuración guardada exitosamente");
    }

    return true;
}

// Función para cargar la configuración del menú del jugador
load_menu_config(player)
{
    // Obtener GUID del jugador
    player_guid = player getGuid();

    // Crear nombre del archivo: scriptdata/menu/guid.txt
    filename = "scriptdata/menu/" + player_guid + ".txt";

    // Verificar si el archivo existe
    if (!fs_testfile(filename))
    {
        // No hay configuración guardada, usar valores por defecto
        return false;
    }

    file = fs_fopen(filename, "read");

    if (!isDefined(file))
    {
        // Error al leer archivo
        return false;
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    // Parsear el contenido del archivo línea por línea
    lines = strTok(content, "\n");

    foreach (line in lines)
    {
        // Solo procesar líneas que contienen "="
        if (isSubStr(line, "="))
        {
            // Dividir la línea en clave y valor
            parts = strTok(line, "=");
            if (parts.size >= 2)
            {
                key = parts[0];
                value = parts[1];

                // Aplicar configuración según la clave
                switch (key)
                {
                    case "language":
                        player.langLEN = int(value);
                        break;

                    case "menu_style":
                        player.menu_style_index = int(value);
                        // Aplicar el estilo del menú si está disponible
                        if (isDefined(player.apply_menu_style))
                        {
                            player thread [[player.apply_menu_style]](int(value));
                        }
                        break;

                    case "sector_style":
                        player.sector_style_index = int(value);
                        break;

                    case "selector_style_index":
                        player.selector_style_index = int(value);
                        break;

                    case "font_position_index":
                        player.font_position_index = int(value);
                        break;

                    case "font_animation":
                        player.font_animation_index = int(value);
                        break;

                    case "transparency_index":
                        player.transparency_index = int(value);
                        break;

                }
            }
        }
    }

    // Mensaje de confirmación silencioso (solo para debug)
    // player iPrintlnBold("^3Configuración cargada desde archivo");

    return true;
}

// Función auxiliar para convertir string a bool
string_to_bool(str)
{
    if (str == "1" || tolower(str) == "true")
        return true;
    else
        return false;
}

// Función para verificar si existe configuración guardada
has_saved_config(player)
{
    // Obtener GUID del jugador
    player_guid = player getGuid();

    filename = "scriptdata/menu/" + player_guid + ".txt";
    return fs_testfile(filename);
}

// Función para eliminar configuración guardada (reset a valores por defecto)
delete_menu_config(player)
{
    // Obtener GUID del jugador
    player_guid = player getGuid();

    filename = "scriptdata/menu/" + player_guid + ".txt";

    if (fs_testfile(filename))
    {
        // En GSC no hay función directa para eliminar archivos
        // Una solución es sobrescribir con contenido vacío o marcar como eliminado
        file = fs_fopen(filename, "write");
        if (isDefined(file))
        {
            fs_write(file, "DELETED\n");
            fs_fclose(file);
            player iPrintlnBold("^3Configuración eliminada");
            return true;
        }
    }

    player iPrintlnBold("^1No se pudo eliminar la configuración");
    return false;
}