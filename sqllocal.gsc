#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

//====================================================================================
// SISTEMA DE GUARDADO DE ESTADÍSTICAS POR JUGADOR Y MAPA
//====================================================================================

// Función para guardar estadísticas del jugador al morir
save_player_round_data(player, map_name, round_number, kills, headshots, revives, downs, score)
{
    // Obtener GUID del jugador correctamente
    player_guid = player getGuid();

    // Verificar que el GUID sea válido
    if (!isDefined(player_guid) || player_guid == "" || player_guid == "0")
    {
        // Si no hay GUID, usar el nombre del jugador como identificador
        if (isDefined(player.name) && player.name != "")
        {
            player_guid = "name_" + player.name;
    }
    else
    {
            player_guid = "unknown_" + randomInt(999999);
        }
    }

    // Verificar el tipo de resultado de ronda
    round_result = check_round_result(player, map_name, round_number);

    // Solo guardar si es nuevo record, igual que record, o primer record
    // No guardar si es peor que el record actual
    if (round_result == 0) // 0 = peor que record
    {
        return;
    }

    // Verificar si ya se guardaron estadísticas para este jugador en esta partida
    if (isDefined(player.stats_saved_this_game) && player.stats_saved_this_game)
    {
        return; // Ya se guardaron, no duplicar
    }

    player.stats_saved_this_game = true;

    // Crear nombre del archivo por mapa: mapname_guid.txt
    filename = map_name + "_" + player_guid + ".txt";

    file = fs_fopen(filename, "write");
    
    if (!isDefined(file))
    {
        self iPrintlnBold("^1Error: No se pudo crear archivo de estadísticas");
        return;
    }
    
    // Obtener nombre del jugador
    player_name = player.name;
    if (!isDefined(player_name) || player_name == "")
        player_name = "Unknown Player";

    // Obtener fecha/hora (usando getTime() que sí existe)
    current_time = getTime();

    // Escribir datos del jugador
    fs_write(file, "================================\n");
    fs_write(file, "ESTADISTICAS DEL JUGADOR\n");
    fs_write(file, "================================\n");
    fs_write(file, "Nombre: " + player_name + "\n");
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
        player iPrintlnBold("^2Estadísticas guardadas para ronda ^7" + round_number);
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

// Función para obtener el balance del banco del jugador
get_bank_balance(player)
{
    // Obtener identificador del jugador (mismo sistema que stats)
    player_id = player getGuid();

    if (!isDefined(player_id) || player_id == "" || player_id == "0")
    {
        if (isDefined(player.name) && player.name != "")
        {
            player_id = "name_" + player.name;
        }
        else
        {
            player_id = "unknown_" + randomInt(999999);
        }
    }

    // Usar la función auxiliar para obtener el balance
    return get_bank_balance_with_id(player_id);
}

// Función para depositar puntos en el banco
bank_deposit(player, amount)
{
    if (!isDefined(amount) || amount <= 0)
    {
        player iPrintlnBold("^1Cantidad inválida");
        return;
    }

    if (player.score < amount)
    {
        player iPrintlnBold("^1No tienes suficientes puntos");
        return;
    }

    // Obtener identificador del jugador
    player_id = player getGuid();

    if (!isDefined(player_id) || player_id == "" || player_id == "0")
    {
        if (isDefined(player.name) && player.name != "")
        {
            player_id = "name_" + player.name;
        }
        else
        {
            player_id = "unknown_" + randomInt(999999);
        }
    }

    filename = "bank_" + player_id + ".txt";

    // Obtener balance actual usando el mismo player_id
    current_balance = get_bank_balance_with_id(player_id);

    // Calcular nuevo balance
    new_balance = current_balance + amount;

    // Restar puntos del jugador
    player.score -= amount;

    // Guardar en archivo
    file = fs_fopen(filename, "write");
    
    if (!isDefined(file))
    {
        player iPrintlnBold("^1Error al acceder al banco");
        // Devolver puntos al jugador
        player.score += amount;
        return;
    }
    
    // Obtener fecha/hora
    current_time = getTime();

    // Escribir datos del banco
    fs_write(file, "================================\n");
    fs_write(file, "CUENTA BANCARIA\n");
    fs_write(file, "================================\n");
    fs_write(file, "Jugador: " + player.name + "\n");
    fs_write(file, "ID: " + player_id + "\n");
    fs_write(file, "Ultima Transaccion: Deposito de " + amount + " puntos\n");
    fs_write(file, "Fecha/Hora: " + current_time + "\n");
    fs_write(file, "Balance: " + new_balance + "\n");
    fs_write(file, "================================\n");
    
    fs_fclose(file);
    
    player iPrintlnBold("^2Depositaste ^7" + amount + "^2 puntos. Balance: ^7" + new_balance);
}

// Función auxiliar para obtener balance con ID específico
get_bank_balance_with_id(player_id)
{
    filename = "bank_" + player_id + ".txt";

    if (!fs_testfile(filename))
    {
        return 0; // No tiene cuenta bancaria
    }

    file = fs_fopen(filename, "read");

    if (!isDefined(file))
    {
        return 0;
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    // Extraer el balance del archivo (buscar línea específica)
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

// Función para depositar todo el dinero
bank_deposit_all(player)
{
    amount = player.score;

    if (amount <= 0)
    {
        player iPrintlnBold("^1No tienes puntos para depositar");
        return;
    }

    bank_deposit(player, amount);
}

// Función para retirar puntos del banco
bank_withdraw(player, amount)
{
    if (!isDefined(amount) || amount <= 0)
    {
        player iPrintlnBold("^1Cantidad inválida");
        return;
    }
    
    // Obtener identificador del jugador
    player_id = player getGuid();

    if (!isDefined(player_id) || player_id == "" || player_id == "0")
    {
        if (isDefined(player.name) && player.name != "")
        {
            player_id = "name_" + player.name;
        }
        else
        {
            player_id = "unknown_" + randomInt(999999);
        }
    }

    // Obtener balance actual usando el mismo player_id
    current_balance = get_bank_balance_with_id(player_id);

    if (current_balance < amount)
    {
        player iPrintlnBold("^1No tienes suficientes puntos en el banco");
        return;
    }

    filename = "bank_" + player_id + ".txt";

    // Calcular nuevo balance
    new_balance = current_balance - amount;

    // Agregar puntos al jugador
    player.score += amount;

    // Actualizar archivo
    file = fs_fopen(filename, "write");

    if (!isDefined(file))
    {
        player iPrintlnBold("^1Error al acceder al banco");
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
    fs_write(file, "Ultima Transaccion: Retiro de " + amount + " puntos\n");
    fs_write(file, "Fecha/Hora: " + current_time + "\n");
    fs_write(file, "Balance: " + new_balance + "\n");
    fs_write(file, "================================\n");

    fs_fclose(file);

    player iPrintlnBold("^2Retiraste ^7" + amount + "^2 puntos. Balance restante: ^7" + new_balance);
}

// Función para retirar todo el dinero del banco
bank_withdraw_all(player)
{
    // Obtener identificador del jugador
    player_id = player getGuid();

    if (!isDefined(player_id) || player_id == "" || player_id == "0")
    {
        if (isDefined(player.name) && player.name != "")
        {
            player_id = "name_" + player.name;
        }
        else
        {
            player_id = "unknown_" + randomInt(999999);
        }
    }

    current_balance = get_bank_balance_with_id(player_id);

    if (current_balance <= 0)
    {
        player iPrintlnBold("^1No tienes puntos en el banco");
        return;
    }

    bank_withdraw(player, current_balance);
}