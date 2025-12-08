#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;






replace_string(str, find, replace)
{
    result = "";
    for (i = 0; i < str.size; i++)
    {
        char = str[i];
        if (char == find)
            result += replace;
        else
            result += char;
    }
    return result;
}

bigint_add(a, b)
{
    
    a = "" + a;
    b = "" + b;

    res = "";
    carry = 0;
    
    i = a.size - 1;
    j = b.size - 1;

    while (i >= 0 || j >= 0 || carry > 0)
    {
        digitA = 0;
        if (i >= 0)
        {
            digitA = int(a[i]);
            i--;
        }

        digitB = 0;
        if (j >= 0)
        {
            digitB = int(b[j]);
            j--;
        }

        sum = digitA + digitB + carry;
        carry = int(sum / 10);
        res = (sum % 10) + res;
    }

    return res;
}

bigint_sub(a, b)
{
    
    a = "" + a;
    b = "" + b;

    res = "";
    borrow = 0;

    i = a.size - 1;
    j = b.size - 1;

    while (i >= 0)
    {
        digitA = int(a[i]);
        digitB = 0;
        
        if (j >= 0)
        {
            digitB = int(b[j]);
            j--;
        }

        digitA -= borrow;

        if (digitA < digitB)
        {
            digitA += 10;
            borrow = 1;
        }
        else
        {
            borrow = 0;
        }

        res = (digitA - digitB) + res;
        i--;
    }

    
    while (res.size > 1 && res[0] == "0")
    {
        res = getSubStr(res, 1);
    }

    return res;
}

bigint_compare(a, b)
{
    a = "" + a;
    b = "" + b;

    if (a.size > b.size) return 1;
    if (a.size < b.size) return -1;

    for (i = 0; i < a.size; i++)
    {
        if (int(a[i]) > int(b[i])) return 1;
        if (int(a[i]) < int(b[i])) return -1;
    }

    return 0;
}

replace_line(content, prefix, new_line)
{
    lines = strTok(content, "\n");
    result = "";

    for (i = 0; i < lines.size; i++)
    {
        line = lines[i];
        if (isSubStr(line, prefix))
        {
            result += new_line;
        }
        else
        {
            result += line;
        }

        if (i < lines.size - 1)
            result += "\n";
    }

    return result;
}

get_player_guid_by_name(player_name)
{
    
    foreach (player in level.players)
    {
        if (isDefined(player) && isDefined(player.name) &&
            toLower(player.name) == toLower(player_name))
        {
            return player getGuid();
        }
    }

    
    
    safe_name = player_name;

    
    safe_name = replace_string(safe_name, " ", "_");
    safe_name = replace_string(safe_name, "[", "");
    safe_name = replace_string(safe_name, "]", "");
    safe_name = replace_string(safe_name, "{", "");
    safe_name = replace_string(safe_name, "}", "");
    safe_name = replace_string(safe_name, "(", "");
    safe_name = replace_string(safe_name, ")", "");
    safe_name = replace_string(safe_name, "<", "");
    safe_name = replace_string(safe_name, ">", "");
    safe_name = replace_string(safe_name, "|", "");
    safe_name = replace_string(safe_name, ":", "");
    safe_name = replace_string(safe_name, "*", "");
    safe_name = replace_string(safe_name, "?", "");
    safe_name = replace_string(safe_name, "\"", "");
    safe_name = replace_string(safe_name, "'", "");

    filename = "guids/" + safe_name + ".txt";

    if (fs_testfile(filename))
    {
        file = fs_fopen(filename, "read");
        if (isDefined(file))
        {
            file_size = fs_length(file);
            guid = fs_read(file, file_size);
            fs_fclose(file);

            
            guid = replace_string(guid, "\n", "");
            guid = replace_string(guid, "\r", "");

            return guid;
        }
    }

    return undefined;
}

save_recent_match(player, map_name, round_number, kills, headshots, revives, downs, score, most_used_weapon, all_weapons_data, all_perks_data)
{

    if ((isDefined(player.developer_mode_unlocked) && player.developer_mode_unlocked) ||
        (isDefined(player.partida_alterada_sv_cheats) && player.partida_alterada_sv_cheats) ||
        (isDefined(level.partida_alterada_global) && level.partida_alterada_global))
    {

        return;
    }
    
    map_name = get_corrected_map_name(map_name);


    if (!isDefined(player) || !isPlayer(player))
    {
        return;
    }


    if (isDefined(player.sessionstate) && player.sessionstate == "spectator")
    {
        return;
    }


    player_guid = player getGuid();


    directory = "scriptdata/recent/" + player_guid + "/" + map_name + "/";


    next_match_number = get_next_recent_match_number(player_guid, map_name);


    filename = directory + map_name + "_recent_" + next_match_number + ".txt";


    update_match_index(player_guid, map_name, next_match_number);

    file = fs_fopen(filename, "write");

    if (!isDefined(file))
    {
        self iPrintlnBold("^1Error: No se pudo crear archivo de partida reciente");
        return;
    }


    player_name = player.name;
    if (!isDefined(player_name) || player_name == "")
        player_name = "Unknown Player";


    
    if (!isDefined(most_used_weapon) || most_used_weapon == "")
        most_used_weapon = "None";


    fs_write(file, "================================\n");
    fs_write(file, "PARTIDA RECIENTE #" + next_match_number + "\n");
    fs_write(file, "================================\n");
    fs_write(file, "Jugador: " + player_name + "\n");
    fs_write(file, "GUID: " + player_guid + "\n");
    fs_write(file, "Mapa: " + map_name + "\n");
    fs_write(file, "Ronda Alcanzada: " + round_number + "\n");

    time = int(getTime() / 1000);
    hours = int(time / 3600);
    minutes = int((time % 3600) / 60);
    seconds = time % 60;
    
    time_str = "";
    if (hours < 10) time_str += "0";
    time_str += hours + ":";
    if (minutes < 10) time_str += "0";
    time_str += minutes + ":";
    if (seconds < 10) time_str += "0";
    time_str += seconds;

    fs_write(file, "Duracion: " + time_str + "\n");
    fs_write(file, "\n");
    fs_write(file, "ESTADISTICAS DE LA PARTIDA:\n");
    fs_write(file, "Kills: " + kills + "\n");
    fs_write(file, "Headshots: " + headshots + "\n");
    fs_write(file, "Revives: " + revives + "\n");
    fs_write(file, "Downs: " + downs + "\n");
    fs_write(file, "Score Total: " + score + "\n");
    fs_write(file, "Arma Mas Usada: " + most_used_weapon + "\n");

    
    if (isDefined(all_weapons_data) && all_weapons_data.size > 0)
    {
        fs_write(file, "\nARMAS USADAS EN LA PARTIDA:\n");

        
        weapons_sorted = [];
        foreach (weapon_name, kill_count in all_weapons_data)
        {
            weapons_sorted[weapons_sorted.size] = weapon_name + ":" + kill_count;
        }

        for (i = 0; i < weapons_sorted.size - 1; i++)
        {
            for (j = i + 1; j < weapons_sorted.size; j++)
            {
                weapon_i = strTok(weapons_sorted[i], ":");
                weapon_j = strTok(weapons_sorted[j], ":");

                kills_i = int(weapon_i[1]);
                kills_j = int(weapon_j[1]);

                if (kills_j > kills_i)
                {
                    temp = weapons_sorted[i];
                    weapons_sorted[i] = weapons_sorted[j];
                    weapons_sorted[j] = temp;
                }
            }
        }

        
        for (i = 0; i < weapons_sorted.size && i < 10; i++) 
        {
            weapon_data = strTok(weapons_sorted[i], ":");
            weapon_name = weapon_data[0];
            kill_count = weapon_data[1];
            
            display_line = weapon_name + ": " + kill_count + " kills";
            
            fs_write(file, display_line + "\n");
        }
    }

    
    if (isDefined(all_perks_data) && all_perks_data.size > 0)
    {
        fs_write(file, "\nPERKS USADOS EN LA PARTIDA:\n");

        
        foreach (perk_name, obtained_count in all_perks_data)
        {
            perk_display_name = get_perk_display_name(perk_name);
            fs_write(file, perk_display_name + ": " + obtained_count + " uso" + (obtained_count > 1 ? "s" : "") + "\n");
        }
    }

    if (isDefined(player.bank_transaction_history) && player.bank_transaction_history.size > 0)
    {
        fs_write(file, "\nTRANSACCIONES BANCARIAS:\n");
        fs_write(file, "--------------------------------\n");
        foreach (transaction in player.bank_transaction_history)
        {
            fs_write(file, transaction + "\n");
        }
        fs_write(file, "--------------------------------\n");
    }

    fs_write(file, "================================\n");

    fs_fclose(file);


    if (isDefined(player) && isPlayer(player))
    {
        player iPrintlnBold("^2Partida reciente guardada (#" + next_match_number + ")");
    }
}


save_player_round_data(player, map_name, round_number, kills, headshots, revives, downs, score)
{
    map_name = get_corrected_map_name(map_name);
    
    most_used_weapon = get_most_used_weapon(player);
    all_weapons_data = get_all_weapons_used(player);
    all_perks_data = get_all_perks_used(player);


    save_recent_match(player, map_name, round_number, kills, headshots, revives, downs, score, most_used_weapon, all_weapons_data, all_perks_data);
}


get_most_used_weapon(player)
{
    if (!isDefined(player.weapon_kills) || player.weapon_kills.size == 0)
        return "None";
    
    most_used = "None";
    max_kills = 0;
    
    
    foreach (weapon_name, kill_count in player.weapon_kills)
    {
        if (kill_count > max_kills)
        {
            max_kills = kill_count;
            most_used = weapon_name;
        }
    }
    
    
    if (most_used != "None")
    {
        most_used = format_weapon_name(most_used);
    }
    
    return most_used + " (" + max_kills + " kills)";
}


get_all_weapons_used(player)
{
    if (!isDefined(player.weapon_kills) || player.weapon_kills.size == 0)
        return undefined;

    
    weapons_used = [];
    foreach (weapon_name, kill_count in player.weapon_kills)
    {
        if (kill_count > 0)
        {
            weapons_used[weapon_name] = kill_count;
        }
    }

    return weapons_used;
}


format_weapon_name(weapon_name)
{
    
    
    return weapon_name;
}


get_next_recent_match_number(player_guid, map_name)
{
    
    index_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + map_name + "_index.txt";

    if (!fs_testfile(index_filename))
    {
        
        return 1;
    }

    
    file = fs_fopen(index_filename, "read");
    if (!isDefined(file))
    {
        return 1; 
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    
    last_number = int(content);

    
    return last_number + 1;
}


update_match_index(player_guid, map_name, match_number)
{
    index_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + map_name + "_index.txt";

    file = fs_fopen(index_filename, "write");
    if (!isDefined(file))
    {
        
        
        return;
    }

    
    fs_write(file, "" + match_number);
    fs_fclose(file);
}


show_recent_matches(player, map_name)
{
    
    if ((isDefined(player.developer_mode_unlocked) && player.developer_mode_unlocked) ||
        (isDefined(player.partida_alterada_sv_cheats) && player.partida_alterada_sv_cheats) ||
        (isDefined(level.partida_alterada_global) && level.partida_alterada_global))
    {
        if (isDefined(player.langLEN) && player.langLEN == 0)
            player iPrintlnBold("^1Las estadísticas están deshabilitadas en Developer Mode o con sv_cheats activado");
        else
            player iPrintlnBold("^1Statistics are disabled in Developer Mode or when sv_cheats is enabled");
        return;
    }

    map_name = get_corrected_map_name(map_name);

    player_guid = player getGuid();

    
    index_filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + map_name + "_index.txt";

    if (!fs_testfile(index_filename))
    {
        
        if (isDefined(player.langLEN) && player.langLEN == 0)
            player iPrintlnBold("^3No hay partidas recientes en " + get_map_display_name(map_name));
        else
            player iPrintlnBold("^3No recent matches in " + get_map_display_name(map_name));
        return;
    }

    
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

    
    files = [];
    for (i = last_match_number; i > 0 && files.size < 5; i--)
    {
        filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + map_name + "_recent_" + i + ".txt";
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

    
    if (isDefined(player.langLEN) && player.langLEN == 0)
        player iPrintlnBold("^6=== PARTIDAS RECIENTES: " + get_map_display_name(map_name) + " (" + files.size + ") ===");
    else
        player iPrintlnBold("^6=== RECENT MATCHES: " + get_map_display_name(map_name) + " (" + files.size + ") ===");

    
    display_count = min(files.size, 5);

    for (i = 0; i < display_count; i++)
    {
        filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + files[i];

        if (!fs_testfile(filename))
            continue;

        file = fs_fopen(filename, "read");
        if (!isDefined(file))
            continue;

        file_size = fs_length(file);
        content = fs_read(file, file_size);
        fs_fclose(file);

        
        lines = strTok(content, "\n");
        round_info = "";
        score_info = "";
        time_info = "";
        duration_info = "";

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
            else if (isSubStr(line, "Duracion:"))
            {
                duration_info = getSubStr(line, 10);
            }
        }

        wait 0.2; 

        
        parts = strTok(files[i], "_");
        match_num = int(getSubStr(parts[2], 0, parts[2].size - 4));

        if (isDefined(player.langLEN) && player.langLEN == 0)
        {
            display_str = "^7#" + match_num + " ^2Ronda: ^7" + round_info;
            if (duration_info != "")
                display_str += " ^5Tiempo: ^7" + duration_info;
            display_str += " ^3Score: ^7" + score_info;
            player iPrintln(display_str);
        }
        else
        {
            display_str = "^7#" + match_num + " ^2Round: ^7" + round_info;
            if (duration_info != "")
                display_str += " ^5Time: ^7" + duration_info;
            display_str += " ^3Score: ^7" + score_info;
            player iPrintln(display_str);
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


get_map_display_name(map_code)
{
    switch (map_code)
    {
        case "tomb": return "Origins";
        case "transit": return "Transit";
        case "tranzit": return "Transit";
        case "busdepot": return "Bus Depot";
        case "processing": return "Buried";
        case "prison": return "Mob of the Dead";
        case "nuked": return "Nuketown";
        case "highrise": return "Die Rise";
        default: return map_code;
    }
}

get_corrected_map_name(map_name)
{
    if (map_name == "transit")
    {
        var = getdvar("ui_gametype");
        if (var == "zclassic")
            return "tranzit";
        else
            return "busdepot";
    }
    return map_name;
}


load_player_round_data(player_guid, map_name)
{
    map_name = get_corrected_map_name(map_name);
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
    
    
    player_data = [];
    player_data["exists"] = true;
    player_data["guid"] = player_guid;
    player_data["map"] = map_name;

    return player_data;
}



check_round_result(player, map_name, current_round)
{
    
    if ((isDefined(player.developer_mode_unlocked) && player.developer_mode_unlocked) ||
        (isDefined(player.partida_alterada_sv_cheats) && player.partida_alterada_sv_cheats) ||
        (isDefined(level.partida_alterada_global) && level.partida_alterada_global))
    {
        return -1;
    }

    map_name = get_corrected_map_name(map_name);
    
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

    
    if (!fs_testfile(filename))
        return 3; 

    
    file = fs_fopen(filename, "read");
    if (!isDefined(file))
        return 3; 

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);
    
    
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

    
    if (current_round > saved_round)
        return 2; 
    else if (current_round == saved_round)
        return 1; 
    else
        return 0; 
}


check_personal_record(player, map_name, current_round)
{
    result = check_round_result(player, map_name, current_round);
    return (result == 2 || result == 3); 
}


list_all_stats_files()
{
    
    if ((isDefined(self.developer_mode_unlocked) && self.developer_mode_unlocked) ||
        (isDefined(self.partida_alterada_sv_cheats) && self.partida_alterada_sv_cheats) ||
        (isDefined(level.partida_alterada_global) && level.partida_alterada_global))
    {
        if (isDefined(self.langLEN) && self.langLEN == 0)
            self iPrintlnBold("^1Las estadísticas están deshabilitadas en Developer Mode o con sv_cheats activado");
        else
            self iPrintlnBold("^1Statistics are disabled in Developer Mode or when sv_cheats is enabled");
        return;
    }

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


show_player_stats(player_guid, map_name)
{
    
    if ((isDefined(self.developer_mode_unlocked) && self.developer_mode_unlocked) ||
        (isDefined(self.partida_alterada_sv_cheats) && self.partida_alterada_sv_cheats) ||
        (isDefined(level.partida_alterada_global) && level.partida_alterada_global))
    {
        if (isDefined(self.langLEN) && self.langLEN == 0)
            self iPrintlnBold("^1Las estadísticas están deshabilitadas en Developer Mode o con sv_cheats activado");
        else
            self iPrintlnBold("^1Statistics are disabled in Developer Mode or when sv_cheats is enabled");
        return;
    }

    map_name = get_corrected_map_name(map_name);

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


show_recent_match_details(player, map_name, match_number)
{
    map_name = get_corrected_map_name(map_name);
    player_guid = player getGuid();
    filename = "scriptdata/recent/" + player_guid + "/" + map_name + "/" + map_name + "_recent_" + match_number + ".txt";

    if (!fs_testfile(filename))
    {
        if (isDefined(player.langLEN) && player.langLEN == 0)
            player iPrintlnBold("^3Partida reciente #" + match_number + " no encontrada");
        else
            player iPrintlnBold("^3Recent match #" + match_number + " not found");
        return;
    }

    file = fs_fopen(filename, "read");

    if (!isDefined(file))
    {
        if (isDefined(player.langLEN) && player.langLEN == 0)
            player iPrintlnBold("^1Error al leer partida reciente");
        else
            player iPrintlnBold("^1Error reading recent match");
        return;
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    
    if (isDefined(player.langLEN) && player.langLEN == 0)
        player iPrintlnBold("^6=== DETALLES PARTIDA RECIENTE #" + match_number + " ===");
    else
        player iPrintlnBold("^6=== RECENT MATCH DETAILS #" + match_number + " ===");

    
    lines = strTok(content, "\n");

    foreach (line in lines)
    {
        if (line != "")
        {
            wait 0.1; 
            player iPrintln("^7" + line);
        }
    }
}





get_bank_balance(player)
{
    player_id = player getGuid();

    return get_bank_balance_with_id(player_id);
}



log_bank_transaction(player, type, amount, detail)
{
    if (!isDefined(player.bank_transaction_history))
    {
        player.bank_transaction_history = [];
    }

    
    
    time = int(getTime() / 1000);
    
    
    hours = int(time / 3600);
    minutes = int((time % 3600) / 60);
    seconds = time % 60;
    
    time_str = "";
    if (hours < 10) time_str += "0";
    time_str += hours + ":";
    if (minutes < 10) time_str += "0";
    time_str += minutes + ":";
    if (seconds < 10) time_str += "0";
    time_str += seconds;

    log_entry = "[" + time_str + "] " + type + ": " + amount + " - " + detail;
    
    player.bank_transaction_history[player.bank_transaction_history.size] = log_entry;
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


    new_balance = bigint_add(current_balance, amount);


    player.score -= amount;


    file = fs_fopen(filename, "write");
    
    if (!isDefined(file))
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1Error al acceder al banco");
        else
            player iPrintlnBold("^1Error accessing bank");
        
        player.score += amount;
        return;
    }
    
    current_time = getTime();

    
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

    log_bank_transaction(player, "DEPOSIT", amount, "Balance: " + new_balance);
}

get_bank_balance_with_id(player_id)
{
    filename = "bank/" + player_id + ".txt"; 

    if (!fs_testfile(filename))
    {
        return "0"; 
    }

    file = fs_fopen(filename, "read");

    if (!isDefined(file))
    {
        return "0"; 
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
            balance_str = getSubStr(line, 9); 
            
            
            return balance_str; 
        }
    }

    return "0"; 
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

    
    score_limit = 1000000;
    if (player.score >= score_limit)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1Ya has llegado al límite de puntos (1,000,000)");
        else
            player iPrintlnBold("^1Max points reached (1,000,000)");
        return;
    }

    if (player.score + amount > score_limit)
    {
        amount = score_limit - player.score;
        if (player.langLEN == 0)
            player iPrintlnBold("^3Ajustando retiro para llegar al límite de puntos");
        else
            player iPrintlnBold("^3Adjusting withdrawal to reach point limit");
    }

    
    player_id = player getGuid();

    
    
    current_balance = get_bank_balance_with_id(player_id);

    
    
    if (bigint_compare(current_balance, amount) == -1)
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No tienes suficientes puntos en el banco");
        else
            player iPrintlnBold("^1Not enough points in bank");
        return;
    }

    filename = "bank/" + player_id + ".txt";

    
    new_balance = bigint_sub(current_balance, amount);

    
    player.score += amount;

    
    file = fs_fopen(filename, "write");

    if (!isDefined(file))
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1Error al acceder al banco");
        else
            player iPrintlnBold("^1Error accessing bank");
        
        player.score -= amount;
        return;
    }
    
    
    current_time = getTime();

    
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

    log_bank_transaction(player, "WITHDRAW", amount, "Balance: " + new_balance);
}

bank_withdraw_all(player)
{
    
    
    player_id = player getGuid();

    current_balance = get_bank_balance_with_id(player_id);

    if (current_balance == "0")
    {
        if (player.langLEN == 0)
            player iPrintlnBold("^1No tienes puntos en el banco");
        else
            player iPrintlnBold("^1No points in bank");
        return;
    }

    amount_to_withdraw = 0;
    limit = 1000000;

    
    if (bigint_compare(current_balance, limit) == 1)
    {
        amount_to_withdraw = limit;
    }
    else
    {
        amount_to_withdraw = int(current_balance);
    }

    bank_withdraw(player, amount_to_withdraw);
}


bank_pay_player(payer, receiver_name, amount)
{
    if (!isDefined(amount) || amount <= 0)
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1Cantidad inválida");
        else
            payer iPrintlnBold("^1Invalid amount");
        return;
    }

    if (payer.score < amount)
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1No tienes suficientes puntos");
        else
            payer iPrintlnBold("^1Not enough points");
        return;
    }

    
    receiver = undefined;
    foreach (player in level.players)
    {
        if (isDefined(player) && isDefined(player.name) &&
            toLower(player.name) == toLower(receiver_name))
        {
            receiver = player;
            break;
        }
    }

    if (!isDefined(receiver))
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1Jugador '" + receiver_name + "' no encontrado");
        else
            payer iPrintlnBold("^1Player '" + receiver_name + "' not found");
        return;
    }

    if (receiver == payer)
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1No puedes pagarte a ti mismo");
        else
            payer iPrintlnBold("^1You can't pay yourself");
        return;
    }

    
    payer.score -= amount;
    receiver.score += amount;

    
    if (payer.langLEN == 0)
    {
        payer iPrintlnBold("^2Pagaste ^7" + amount + "^2 puntos a ^7" + receiver.name);
        receiver iPrintlnBold("^3Recibiste ^7" + amount + "^3 puntos de ^7" + payer.name);
    }
    else
    {
        payer iPrintlnBold("^2Paid ^7" + amount + "^2 points to ^7" + receiver.name);
        receiver iPrintlnBold("^3Received ^7" + amount + "^3 points from ^7" + payer.name);
    }

    log_bank_transaction(payer, "TRANSFER_SENT", amount, "To: " + receiver.name);
    log_bank_transaction(receiver, "TRANSFER_RECEIVED", amount, "From: " + payer.name);
}


bank_pay_to_guid(payer, target_guid, amount)
{
    if (!isDefined(amount) || amount <= 0)
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1Cantidad inválida");
        else
            payer iPrintlnBold("^1Invalid amount");
        return;
    }

    if (payer.score < amount)
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1No tienes suficientes puntos");
        else
            payer iPrintlnBold("^1Not enough points");
        return;
    }

    
    payer_guid_str = "" + payer getGuid();
    target_guid_str = "" + target_guid;
    if (target_guid_str == payer_guid_str)
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1No puedes depositar a tu propio banco");
        else
            payer iPrintlnBold("^1You can't deposit to your own bank");
        return;
    }

    
    filename = "bank/" + target_guid + ".txt";
    if (!fs_testfile(filename))
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1El banco del jugador no existe");
        else
            payer iPrintlnBold("^1Player's bank doesn't exist");
        return;
    }

    
    existing_file = fs_fopen(filename, "read");
    if (!isDefined(existing_file))
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1Error al acceder al banco del jugador");
        else
            payer iPrintlnBold("^1Error accessing player's bank");
        return;
    }

    file_size = fs_length(existing_file);
    content = fs_read(existing_file, file_size);
    fs_fclose(existing_file);

    
    player_name = "Jugador " + target_guid; 
    lines = strTok(content, "\n");
    for (i = 0; i < lines.size; i++)
    {
        line = lines[i];
        if (isSubStr(line, "Jugador: "))
        {
            player_name = getSubStr(line, 9); 
            break;
        }
    }

    
    current_balance = get_bank_balance_with_id(target_guid);
    new_balance = bigint_add(current_balance, amount);

    
    updated_content = replace_line(content, "Balance:", "Balance: " + new_balance);

    
    file = fs_fopen(filename, "write");
    if (isDefined(file))
    {
        fs_write(file, updated_content);
        fs_fclose(file);
    }
    else
    {
        if (payer.langLEN == 0)
            payer iPrintlnBold("^1Error al guardar en el banco del jugador");
        else
            payer iPrintlnBold("^1Error saving to player's bank");
        return;
    }

    
    payer.score -= amount;

    
    if (payer.langLEN == 0)
        payer iPrintlnBold("^2Depositaste ^7" + amount + "^2 puntos al banco de ^7" + player_name);
    else
        payer iPrintlnBold("^2Deposited ^7" + amount + "^2 points to ^7" + player_name + "'s bank");

    log_bank_transaction(payer, "TRANSFER_SENT_GUID", amount, "To GUID: " + target_guid);
}









save_menu_config(player)
{
    return save_menu_config_selective(player, true, true, true);
}


save_settings_only(player)
{
    return save_menu_config_selective(player, true, false, false);
}


save_nightmode_only(player)
{
    return save_menu_config_selective(player, false, true, false);
}


save_map_only(player)
{
    return save_menu_config_selective(player, false, false, true);
}


save_menu_config_selective(player, save_settings, save_nightmode, save_map)
{
    
    player_guid = player getGuid();

    
    filename = "scriptdata/menu/" + player_guid + ".txt";

    
    existing_settings = spawnStruct();
    existing_nightmode = spawnStruct();
    existing_map = spawnStruct();
    
    if (fs_testfile(filename))
    {
        
        file_read = fs_fopen(filename, "read");
        if (isDefined(file_read))
        {
            file_size = fs_length(file_read);
            content = fs_read(file_read, file_size);
            fs_fclose(file_read);

            
            lines = strTok(content, "\n");
            foreach (line in lines)
            {
                if (isSubStr(line, "="))
                {
                    parts = strTok(line, "=");
                    if (parts.size >= 2)
                    {
                        key = parts[0];
                        value = parts[1];

                        
                        if (key == "language") existing_settings.language = value;
                        else if (key == "menu_style") existing_settings.menu_style = value;
                        else if (key == "sector_style") existing_settings.sector_style = value;
                        else if (key == "selector_style_index") existing_settings.selector_style_index = value;
                        else if (key == "font_position_index") existing_settings.font_position_index = value;
                        else if (key == "font_animation") existing_settings.font_animation = value;
                        else if (key == "transparency_index") existing_settings.transparency_index = value;
                        else if (key == "menu_select_button_index") existing_settings.menu_select_button_index = value;
                        else if (key == "menu_down_button_index") existing_settings.menu_down_button_index = value;
                        else if (key == "menu_up_button_index") existing_settings.menu_up_button_index = value;
                        else if (key == "menu_cancel_button_index") existing_settings.menu_cancel_button_index = value;
                        else if (key == "menu_open_sound_index") existing_settings.menu_open_sound_index = value;
                        else if (key == "menu_close_sound_index") existing_settings.menu_close_sound_index = value;
                        else if (key == "menu_scroll_sound_index") existing_settings.menu_scroll_sound_index = value;
                        else if (key == "menu_select_sound_index") existing_settings.menu_select_sound_index = value;
                        else if (key == "custom_menu_width") existing_settings.custom_menu_width = value;
                        else if (key == "custom_menu_margin_x") existing_settings.custom_menu_margin_x = value;
                        else if (key == "custom_menu_margin_y") existing_settings.custom_menu_margin_y = value;
                        else if (key == "custom_menu_item_height") existing_settings.custom_menu_item_height = value;
                        else if (key == "custom_menu_header_height") existing_settings.custom_menu_header_height = value;
                        else if (key == "background_shader_index") existing_settings.background_shader_index = value;
                        else if (key == "header_shader_index") existing_settings.header_shader_index = value;
                        else if (key == "selection_shader_index") existing_settings.selection_shader_index = value;
                        else if (key == "menu_glow_enabled") existing_settings.menu_glow_enabled = value;
                        
                        else if (key == "night_mode_enabled") existing_nightmode.night_mode_enabled = value;
                        else if (key == "night_mode_filter") existing_nightmode.night_mode_filter = value;
                        else if (key == "night_mode_darkness") existing_nightmode.night_mode_darkness = value;
                        else if (key == "fog_enabled") existing_nightmode.fog_enabled = value;
                        
                        else if (key == "perk_unlimited") existing_map.perk_unlimited = value;
                        else if (key == "third_person") existing_map.third_person = value;
                    }
                }
            }
        }
    }

    
    file = fs_fopen(filename, "write");

    if (!isDefined(file))
    {
        player iPrintlnBold("^1Error: No se pudo crear archivo de configuración");
        return false;
    }

    
    player_name = player.name;
    if (!isDefined(player_name) || player_name == "")
        player_name = "Unknown Player";

    
    current_time = getTime();

    
    fs_write(file, "================================\n");
    fs_write(file, "CONFIGURACION DEL MENU\n");
    fs_write(file, "================================\n");
    fs_write(file, "Jugador: " + player_name + "\n");
    fs_write(file, "GUID: " + player_guid + "\n");
    fs_write(file, "Fecha/Hora: " + current_time + "\n");
    fs_write(file, "\n");
    fs_write(file, "CONFIGURACION GUARDADA:\n");

    
    if (save_settings)
    {
        lang_value = isDefined(player.langLEN) ? player.langLEN : 0;
        menu_style = isDefined(player.menu_style_index) ? player.menu_style_index : 0;
        sector_style = isDefined(player.sector_style_index) ? player.sector_style_index : 0;
        selector_style = isDefined(player.selector_style_index) ? player.selector_style_index : 14;
        font_position = isDefined(player.font_position_index) ? player.font_position_index : 0;
        font_animation = isDefined(player.font_animation_index) ? player.font_animation_index : 0;
        transparency_index = isDefined(player.transparency_index) ? player.transparency_index : 0;
        menu_select_button_index = isDefined(player.menu_select_button_index) ? player.menu_select_button_index : 0;
        menu_down_button_index = isDefined(player.menu_down_button_index) ? player.menu_down_button_index : 0;
        menu_up_button_index = isDefined(player.menu_up_button_index) ? player.menu_up_button_index : 0;
        menu_cancel_button_index = isDefined(player.menu_cancel_button_index) ? player.menu_cancel_button_index : 1;
        menu_open_sound_index = isDefined(player.menu_open_sound_index) ? player.menu_open_sound_index : 1;
        menu_close_sound_index = isDefined(player.menu_close_sound_index) ? player.menu_close_sound_index : 1;
        menu_scroll_sound_index = isDefined(player.menu_scroll_sound_index) ? player.menu_scroll_sound_index : 1;
        menu_select_sound_index = isDefined(player.menu_select_sound_index) ? player.menu_select_sound_index : 1;
        custom_menu_width = isDefined(player.custom_menu_width) ? player.custom_menu_width : 175;
        custom_menu_margin_x = isDefined(player.custom_menu_margin_x) ? player.custom_menu_margin_x : 0;
        custom_menu_margin_y = isDefined(player.custom_menu_margin_y) ? player.custom_menu_margin_y : 40;
        custom_menu_item_height = isDefined(player.custom_menu_item_height) ? player.custom_menu_item_height : 18;
        custom_menu_header_height = isDefined(player.custom_menu_header_height) ? player.custom_menu_header_height : 24;
        background_shader_index = isDefined(player.background_shader_index) ? player.background_shader_index : -1;
        header_shader_index = isDefined(player.header_shader_index) ? player.header_shader_index : -1;
        header_shader_index = isDefined(player.header_shader_index) ? player.header_shader_index : -1;
        selection_shader_index = isDefined(player.selection_shader_index) ? player.selection_shader_index : -1;
        menu_glow_enabled = isDefined(player.menu_glow_enabled) ? player.menu_glow_enabled : false;
    }
    else
    {
        
        lang_value = isDefined(existing_settings.language) ? int(existing_settings.language) : 0;
        menu_style = isDefined(existing_settings.menu_style) ? int(existing_settings.menu_style) : 0;
        sector_style = isDefined(existing_settings.sector_style) ? int(existing_settings.sector_style) : 0;
        selector_style = isDefined(existing_settings.selector_style_index) ? int(existing_settings.selector_style_index) : 14;
        font_position = isDefined(existing_settings.font_position_index) ? int(existing_settings.font_position_index) : 0;
        font_animation = isDefined(existing_settings.font_animation) ? int(existing_settings.font_animation) : 0;
        transparency_index = isDefined(existing_settings.transparency_index) ? int(existing_settings.transparency_index) : 0;
        menu_select_button_index = isDefined(existing_settings.menu_select_button_index) ? int(existing_settings.menu_select_button_index) : 0;
        menu_down_button_index = isDefined(existing_settings.menu_down_button_index) ? int(existing_settings.menu_down_button_index) : 0;
        menu_up_button_index = isDefined(existing_settings.menu_up_button_index) ? int(existing_settings.menu_up_button_index) : 0;
        menu_cancel_button_index = isDefined(existing_settings.menu_cancel_button_index) ? int(existing_settings.menu_cancel_button_index) : 1;
        menu_open_sound_index = isDefined(existing_settings.menu_open_sound_index) ? int(existing_settings.menu_open_sound_index) : 1;
        menu_close_sound_index = isDefined(existing_settings.menu_close_sound_index) ? int(existing_settings.menu_close_sound_index) : 1;
        menu_scroll_sound_index = isDefined(existing_settings.menu_scroll_sound_index) ? int(existing_settings.menu_scroll_sound_index) : 1;
        menu_select_sound_index = isDefined(existing_settings.menu_select_sound_index) ? int(existing_settings.menu_select_sound_index) : 1;
        custom_menu_width = isDefined(existing_settings.custom_menu_width) ? int(existing_settings.custom_menu_width) : 175;
        custom_menu_margin_x = isDefined(existing_settings.custom_menu_margin_x) ? int(existing_settings.custom_menu_margin_x) : 0;
        custom_menu_margin_y = isDefined(existing_settings.custom_menu_margin_y) ? int(existing_settings.custom_menu_margin_y) : 40;
        custom_menu_item_height = isDefined(existing_settings.custom_menu_item_height) ? int(existing_settings.custom_menu_item_height) : 18;
        custom_menu_header_height = isDefined(existing_settings.custom_menu_header_height) ? int(existing_settings.custom_menu_header_height) : 24;
        background_shader_index = isDefined(existing_settings.background_shader_index) ? int(existing_settings.background_shader_index) : -1;
        header_shader_index = isDefined(existing_settings.header_shader_index) ? int(existing_settings.header_shader_index) : -1;
        header_shader_index = isDefined(existing_settings.header_shader_index) ? int(existing_settings.header_shader_index) : -1;
        selection_shader_index = isDefined(existing_settings.selection_shader_index) ? int(existing_settings.selection_shader_index) : -1;
        menu_glow_enabled = isDefined(existing_settings.menu_glow_enabled) ? string_to_bool(existing_settings.menu_glow_enabled) : false;
    }

    fs_write(file, "language=" + lang_value + "\n");
    fs_write(file, "menu_style=" + menu_style + "\n");
    fs_write(file, "sector_style=" + sector_style + "\n");
    fs_write(file, "selector_style_index=" + selector_style + "\n");
    fs_write(file, "font_position_index=" + font_position + "\n");
    fs_write(file, "font_animation=" + font_animation + "\n");
    fs_write(file, "transparency_index=" + transparency_index + "\n");
    fs_write(file, "menu_select_button_index=" + menu_select_button_index + "\n");
    fs_write(file, "menu_down_button_index=" + menu_down_button_index + "\n");
    fs_write(file, "menu_up_button_index=" + menu_up_button_index + "\n");
    fs_write(file, "menu_cancel_button_index=" + menu_cancel_button_index + "\n");
    fs_write(file, "menu_open_sound_index=" + menu_open_sound_index + "\n");
    fs_write(file, "menu_close_sound_index=" + menu_close_sound_index + "\n");
    fs_write(file, "menu_scroll_sound_index=" + menu_scroll_sound_index + "\n");
    fs_write(file, "menu_select_sound_index=" + menu_select_sound_index + "\n");
    fs_write(file, "custom_menu_width=" + custom_menu_width + "\n");
    fs_write(file, "custom_menu_margin_x=" + custom_menu_margin_x + "\n");
    fs_write(file, "custom_menu_margin_y=" + custom_menu_margin_y + "\n");
    fs_write(file, "custom_menu_item_height=" + custom_menu_item_height + "\n");
    fs_write(file, "custom_menu_header_height=" + custom_menu_header_height + "\n");
    fs_write(file, "background_shader_index=" + background_shader_index + "\n");
    fs_write(file, "header_shader_index=" + header_shader_index + "\n");
    fs_write(file, "selection_shader_index=" + selection_shader_index + "\n");
    fs_write(file, "menu_glow_enabled=" + (menu_glow_enabled ? "1" : "0") + "\n");

    
    
    
    fs_write(file, "\n");
    fs_write(file, "NIGHTMODE\n");
    fs_write(file, "\n");

    
    if (save_nightmode)
    {
        night_mode_enabled = isDefined(player.night_mode_enabled) ? player.night_mode_enabled : false;
        night_mode_filter = isDefined(player.night_mode_filter) ? player.night_mode_filter : 0;
        night_mode_darkness = isDefined(player.night_mode_darkness) ? player.night_mode_darkness : 0;
        fog_enabled = isDefined(player.fog_enabled) ? player.fog_enabled : false;
    }
    else
    {
        
        night_mode_enabled = isDefined(existing_nightmode.night_mode_enabled) ? string_to_bool(existing_nightmode.night_mode_enabled) : false;
        night_mode_filter = isDefined(existing_nightmode.night_mode_filter) ? int(existing_nightmode.night_mode_filter) : 0;
        night_mode_darkness = isDefined(existing_nightmode.night_mode_darkness) ? int(existing_nightmode.night_mode_darkness) : 0;
        fog_enabled = isDefined(existing_nightmode.fog_enabled) ? string_to_bool(existing_nightmode.fog_enabled) : false;
    }

    fs_write(file, "night_mode_enabled=" + (night_mode_enabled ? "1" : "0") + "\n");
    fs_write(file, "night_mode_filter=" + night_mode_filter + "\n");
    fs_write(file, "night_mode_darkness=" + night_mode_darkness + "\n");
    fs_write(file, "fog_enabled=" + (fog_enabled ? "1" : "0") + "\n");

    
    
    
    fs_write(file, "\n");
    fs_write(file, "PERKS\n");
    fs_write(file, "\n");

    
    
    if (isDefined(save_map) && save_map)
    {
        perk_unlimited = isDefined(player.perk_unlimite_active) ? player.perk_unlimite_active : false;
        third_person = isDefined(player.TPP) ? player.TPP : false;
    }
    else
    {
        
        perk_unlimited = isDefined(existing_map.perk_unlimited) ? string_to_bool(existing_map.perk_unlimited) : false;
        third_person = isDefined(existing_map.third_person) ? string_to_bool(existing_map.third_person) : false;
    }

    fs_write(file, "perk_unlimited=" + (perk_unlimited ? "1" : "0") + "\n");
    fs_write(file, "third_person=" + (third_person ? "1" : "0") + "\n");

    fs_write(file, "\n");
    fs_write(file, "================================\n");

    fs_fclose(file);

    
    if (isDefined(player) && isPlayer(player))
    {
        player iPrintlnBold("^2Configuración guardada exitosamente");
    }

    return true;
}


load_menu_config(player)
{
    
    player_guid = player getGuid();

    
    filename = "scriptdata/menu/" + player_guid + ".txt";

    
    if (!fs_testfile(filename))
    {
        
        return false;
    }

    file = fs_fopen(filename, "read");

    if (!isDefined(file))
    {
        
        return false;
    }

    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);

    
    lines = strTok(content, "\n");

    foreach (line in lines)
    {
        
        if (isSubStr(line, "="))
        {
            
            parts = strTok(line, "=");
            if (parts.size >= 2)
            {
                key = parts[0];
                value = parts[1];

                
                switch (key)
                {
                    case "language":
                        player.langLEN = int(value);
                        break;

                    case "menu_style":
                        player.menu_style_index = int(value);
                        
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

                    case "menu_select_button_index":
                        player.menu_select_button_index = int(value);
                        break;

                    case "menu_down_button_index":
                        player.menu_down_button_index = int(value);
                        break;

                    case "menu_up_button_index":
                        player.menu_up_button_index = int(value);
                        break;

                    case "menu_cancel_button_index":
                        player.menu_cancel_button_index = int(value);
                        break;

                    case "menu_open_sound_index":
                        player.menu_open_sound_index = int(value);
                        break;

                    case "menu_close_sound_index":
                        player.menu_close_sound_index = int(value);
                        break;

                    case "menu_scroll_sound_index":
                        player.menu_scroll_sound_index = int(value);
                        break;

                    case "menu_select_sound_index":
                        player.menu_select_sound_index = int(value);
                        break;

                    case "custom_menu_width":
                        player.custom_menu_width = int(value);
                        break;

                    case "custom_menu_margin_x":
                        player.custom_menu_margin_x = int(value);
                        break;

                    case "custom_menu_margin_y":
                        player.custom_menu_margin_y = int(value);
                        break;

                    case "custom_menu_item_height":
                        player.custom_menu_item_height = int(value);
                        break;

                    case "custom_menu_header_height":
                        player.custom_menu_header_height = int(value);
                        break;

                    case "background_shader_index":
                        player.background_shader_index = int(value);
                        break;

                    case "header_shader_index":
                        player.header_shader_index = int(value);
                        break;

                    case "selection_shader_index":
                        player.selection_shader_index = int(value);
                        break;

                    case "menu_glow_enabled":
                        player.menu_glow_enabled = string_to_bool(value);
                        break;





                    case "night_mode_enabled":
                        player.night_mode_enabled = string_to_bool(value);
                        break;

                    case "night_mode_filter":
                        player.night_mode_filter = int(value);
                        break;

                    case "night_mode_darkness":
                        player.night_mode_darkness = int(value);
                        break;

                    case "fog_enabled":
                        player.fog_enabled = string_to_bool(value);
                        break;

                    
                    
                    
                    case "perk_unlimited":
                        player.perk_unlimite_active = string_to_bool(value);
                        break;

                    case "third_person":
                        player.TPP = string_to_bool(value);
                        break;
                }
            }
        }
    }

    
    wait 0.5;

    
    if (isDefined(player.night_mode_enabled) && player.night_mode_enabled)
    {
        
        if (isDefined(player.night_mode_filter))
        {
            player thread scripts\zm\night_mode::night_mode_toggle(player.night_mode_filter);
        }
    }
    
    
    if (isDefined(player.fog_enabled) && player.fog_enabled)
    {
        wait 0.2;
        player thread scripts\zm\night_mode::toggle_fog_saved();
    }

    
    
    if (isDefined(player.perk_unlimite_active) && player.perk_unlimite_active)
    {
        wait 0.2;
        player thread scripts\zm\funciones::apply_perk_unlimited_saved();
    }

    
    if (isDefined(player.TPP) && player.TPP)
    {
        wait 0.2;
        player thread scripts\zm\funciones::apply_third_person_saved();
    }

    
    

    return true;
}


string_to_bool(str)
{
    if (str == "1" || tolower(str) == "true")
        return true;
    else
        return false;
}


has_saved_config(player)
{
    
    player_guid = player getGuid();

    filename = "scriptdata/menu/" + player_guid + ".txt";
    return fs_testfile(filename);
}


delete_menu_config(player)
{
    
    player_guid = player getGuid();

    filename = "scriptdata/menu/" + player_guid + ".txt";

    if (fs_testfile(filename))
    {
        
        
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




init_weapon_tracking(player)
{
    if (!isDefined(player.weapon_kills))
    {
        player.weapon_kills = [];
    }
    
    // Time tracking removed
    
    player thread track_weapon_kills_callback();
}


track_weapon_kills_callback()
{
    self endon("disconnect");
    level endon("end_game");

    
    wait 1;

    
    self.weapon_tracking_last_kills = 0;
    if (isDefined(self.pers["kills"]))
        self.weapon_tracking_last_kills = self.pers["kills"];

    
    while (true)
    {
        wait 0.05; 

        
        current_kills = 0;
        if (isDefined(self.pers["kills"]))
            current_kills = self.pers["kills"];

        
        if (current_kills > self.weapon_tracking_last_kills)
        {
            
            current_weapon = self getCurrentWeapon();

            
            if (!isDefined(current_weapon) || current_weapon == "none" || current_weapon == "")
            {
                
                if (isDefined(self.primaryweapon) && self.primaryweapon != "none")
                    current_weapon = self.primaryweapon;
                
                else if (isDefined(self.secondaryweapon) && self.secondaryweapon != "none")
                    current_weapon = self.secondaryweapon;
            }

            
            if (isDefined(current_weapon) && current_weapon != "none" && current_weapon != "")
            {
                
                if (!isDefined(self.weapon_kills[current_weapon]))
                {
                    self.weapon_kills[current_weapon] = 0;
                }

                
                kills_diff = current_kills - self.weapon_tracking_last_kills;
                self.weapon_kills[current_weapon] += kills_diff;
                
                // Time tracking removed

            }

            
            self.weapon_tracking_last_kills = current_kills;
        }
    }
}


get_all_perks_used(player)
{
    if (!isDefined(player.perks_used) || player.perks_used.size == 0)
        return undefined;

    
    perks_used = [];
    foreach (perk_name, obtained in player.perks_used)
    {
        if (obtained > 0)
        {
            perks_used[perk_name] = obtained;
        }
    }

    return perks_used;
}


init_perks_tracking(player)
{
    if (!isDefined(player.perks_used))
    {
        player.perks_used = [];
    }

    
    perk_names = [];
    perk_names[0] = "specialty_armorvest";
    perk_names[1] = "specialty_quickrevive";
    perk_names[2] = "specialty_fastreload";
    perk_names[3] = "specialty_rof";
    perk_names[4] = "specialty_longersprint";
    perk_names[5] = "specialty_flakjacket";
    perk_names[6] = "specialty_deadshot";
    perk_names[7] = "specialty_additionalprimaryweapon";
    perk_names[8] = "specialty_grenadepulldeath";
    perk_names[9] = "specialty_finalstand";

    foreach (perk_name in perk_names)
    {
        if (!isDefined(player.perks_used[perk_name]))
        {
            player.perks_used[perk_name] = 0;
        }
    }

    
    player thread track_perks_usage_callback();
}


get_perk_display_name(perk_name)
{
    switch (perk_name)
    {
        case "specialty_armorvest": return "Juggernog";
        case "specialty_quickrevive": return "Quick Revive";
        case "specialty_fastreload": return "Speed Cola";
        case "specialty_rof": return "Double Tap";
        case "specialty_longersprint": return "Stamin-Up";
        case "specialty_flakjacket": return "PhD Flopper";
        case "specialty_deadshot": return "Deadshot Daiquiri";
        case "specialty_additionalprimaryweapon": return "Mule Kick";
        case "specialty_grenadepulldeath": return "Electric Cherry";
        case "specialty_finalstand": return "Who's Who";
        default: return perk_name;
    }
}


track_perks_usage_callback()
{
    self endon("disconnect");
    level endon("end_game");

    
    wait 2;

    
    perk_list = [];
    perk_list[0] = "specialty_armorvest";
    perk_list[1] = "specialty_quickrevive";
    perk_list[2] = "specialty_fastreload";
    perk_list[3] = "specialty_rof";
    perk_list[4] = "specialty_longersprint";
    perk_list[5] = "specialty_flakjacket";
    perk_list[6] = "specialty_deadshot";
    perk_list[7] = "specialty_additionalprimaryweapon";
    perk_list[8] = "specialty_grenadepulldeath";
    perk_list[9] = "specialty_finalstand";

    
    while (true)
    {
        wait 1; 

        
        foreach (perk_name in perk_list)
        {
            if (self hasPerk(perk_name))
            {
                
                if (!isDefined(self.perks_used[perk_name]) || self.perks_used[perk_name] == 0)
                {
                    
                    if (!isDefined(self.perks_used[perk_name]))
                    {
                        self.perks_used[perk_name] = 0;
                    }
                    self.perks_used[perk_name] = 1;
                }
            }
        }
    }
}
