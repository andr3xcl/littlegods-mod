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


get_player_stat(player, stat_name)
{
    if (!isDefined(player))
        return 0;
    
    stat_value = player maps\mp\gametypes_zm\_globallogic_score::getpersstat(stat_name);
    
    if (!isDefined(stat_value))
        return 0;
    
    return stat_value;
}


save_recent_match(player, map_name, round_number, kills, headshots, revives, downs, score, most_used_weapon, all_weapons_data)
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

    
    if (!isDefined(level.match_start_time))
        level.match_start_time = getTime();
        
    elapsed_time = getTime() - level.match_start_time;
    time = int(elapsed_time / 1000);
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
    
    
    spr = 0;
    if (round_number > 0)
    {
        spr = time / round_number;
    }
    fs_write(file, "S.P.R: " + formatFloat(spr, 2) + "s\n");
    
    fs_write(file, "\n");
    
    
    
    
    
    
    fs_write(file, "[GENERAL]\n");
    fs_write(file, "Time Played: " + get_player_stat(player, "time_played_total") + "\n");
    fs_write(file, "Kills: " + get_player_stat(player, "kills") + "\n");
    fs_write(file, "Deaths: " + get_player_stat(player, "deaths") + "\n");
    fs_write(file, "Downs: " + get_player_stat(player, "downs") + "\n");
    fs_write(file, "Revives: " + get_player_stat(player, "revives") + "\n");
    fs_write(file, "Suicides: " + get_player_stat(player, "suicides") + "\n");
    fs_write(file, "Score Total: " + get_player_stat(player, "score") + "\n");
    fs_write(file, "Weighted Rounds: " + get_player_stat(player, "weighted_rounds_played") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[COMBAT]\n");
    fs_write(file, "Headshots: " + get_player_stat(player, "headshots") + "\n");
    fs_write(file, "Total Gibs: " + get_player_stat(player, "gibs") + "\n");
    fs_write(file, "Head Gibs: " + get_player_stat(player, "head_gibs") + "\n");
    fs_write(file, "Right Arm Gibs: " + get_player_stat(player, "right_arm_gibs") + "\n");
    fs_write(file, "Left Arm Gibs: " + get_player_stat(player, "left_arm_gibs") + "\n");
    fs_write(file, "Right Leg Gibs: " + get_player_stat(player, "right_leg_gibs") + "\n");
    fs_write(file, "Left Leg Gibs: " + get_player_stat(player, "left_leg_gibs") + "\n");
    fs_write(file, "Melee Kills: " + get_player_stat(player, "melee_kills") + "\n");
    fs_write(file, "Grenade Kills: " + get_player_stat(player, "grenade_kills") + "\n");
    fs_write(file, "Total Shots: " + get_player_stat(player, "total_shots") + "\n");
    fs_write(file, "Hits: " + get_player_stat(player, "hits") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[SURVIVAL & ECONOMY]\n");
    fs_write(file, "Distance Traveled: " + get_player_stat(player, "distance_traveled") + "\n");
    fs_write(file, "Doors Purchased: " + get_player_stat(player, "doors_purchased") + "\n");
    fs_write(file, "Boards Rebuilt: " + get_player_stat(player, "boards") + "\n");
    fs_write(file, "Wins: " + get_player_stat(player, "wins") + "\n");
    fs_write(file, "Losses: " + get_player_stat(player, "losses") + "\n");
    fs_write(file, "Failed Revives: " + get_player_stat(player, "failed_revives") + "\n");
    fs_write(file, "Sacrifices: " + get_player_stat(player, "sacrifices") + "\n");
    fs_write(file, "Failed Sacrifices: " + get_player_stat(player, "failed_sacrifices") + "\n");
    fs_write(file, "Drops: " + get_player_stat(player, "drops") + "\n");
    fs_write(file, "Wall Buy Weapons: " + get_player_stat(player, "wallbuy_weapons_purchased") + "\n");
    fs_write(file, "Ammo Purchased: " + get_player_stat(player, "ammo_purchased") + "\n");
    fs_write(file, "Upgraded Ammo: " + get_player_stat(player, "upgraded_ammo_purchased") + "\n");
    fs_write(file, "Power Turned On: " + get_player_stat(player, "power_turnedon") + "\n");
    fs_write(file, "Power Turned Off: " + get_player_stat(player, "power_turnedoff") + "\n");
    fs_write(file, "Buildables Picked Up: " + get_player_stat(player, "planted_buildables_pickedup") + "\n");
    fs_write(file, "Buildables Built: " + get_player_stat(player, "buildables_built") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[MAGIC BOX & PAP]\n");
    fs_write(file, "Box Used: " + get_player_stat(player, "use_magicbox") + "\n");
    fs_write(file, "Box Weapons Taken: " + get_player_stat(player, "grabbed_from_magicbox") + "\n");
    fs_write(file, "PAP Used: " + get_player_stat(player, "use_pap") + "\n");
    fs_write(file, "PAP Weapons Taken: " + get_player_stat(player, "pap_weapon_grabbed") + "\n");
    fs_write(file, "PAP Weapons Left: " + get_player_stat(player, "pap_weapon_not_grabbed") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[POWERUPS]\n");
    fs_write(file, "Nukes: " + get_player_stat(player, "nuke_pickedup") + "\n");
    fs_write(file, "Insta-Kills: " + get_player_stat(player, "insta_kill_pickedup") + "\n");
    fs_write(file, "Max Ammo: " + get_player_stat(player, "full_ammo_pickedup") + "\n");
    fs_write(file, "Double Points: " + get_player_stat(player, "double_points_pickedup") + "\n");
    fs_write(file, "Meat Stink: " + get_player_stat(player, "meat_stink_pickedup") + "\n");
    fs_write(file, "Carpenters: " + get_player_stat(player, "carpenter_pickedup") + "\n");
    fs_write(file, "Fire Sales: " + get_player_stat(player, "fire_sale_pickedup") + "\n");
    fs_write(file, "Zombie Blood: " + get_player_stat(player, "zombie_blood_pickedup") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[PERKS DRANK COUNTERS]\n");
    fs_write(file, "Total Perks: " + get_player_stat(player, "perks_drank") + "\n");
    fs_write(file, "Juggernog: " + get_player_stat(player, "specialty_armorvest_drank") + "\n");
    fs_write(file, "Quick Revive: " + get_player_stat(player, "specialty_quickrevive_drank") + "\n");
    fs_write(file, "Double Tap: " + get_player_stat(player, "specialty_rof_drank") + "\n");
    fs_write(file, "Speed Cola: " + get_player_stat(player, "specialty_fastreload_drank") + "\n");
    fs_write(file, "PhD Flopper: " + get_player_stat(player, "specialty_flakjacket_drank") + "\n");
    fs_write(file, "Mule Kick: " + get_player_stat(player, "specialty_additionalprimaryweapon_drank") + "\n");
    fs_write(file, "Stamin-Up: " + get_player_stat(player, "specialty_longersprint_drank") + "\n");
    fs_write(file, "Deadshot: " + get_player_stat(player, "specialty_deadshot_drank") + "\n");
    fs_write(file, "Tombstone/Who's Who: " + get_player_stat(player, "specialty_finalstand_drank") + "\n");
    fs_write(file, "Electric Cherry: " + get_player_stat(player, "specialty_grenadepulldeath_drank") + "\n");
    fs_write(file, "Vulture Aid: " + get_player_stat(player, "specialty_nomotionsensor_drank") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[EQUIPMENT]\n");
    fs_write(file, "Claymores Planted: " + get_player_stat(player, "claymores_planted") + "\n");
    fs_write(file, "Claymores Picked Up: " + get_player_stat(player, "claymores_pickedup") + "\n");
    fs_write(file, "Ballistic Knives Picked Up: " + get_player_stat(player, "ballistic_knives_pickedup") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[MAP SPECIFIC]\n");
    fs_write(file, "Hell Hounds Killed: " + get_player_stat(player, "zdogs_killed") + "\n");
    fs_write(file, "Hell Hound Rounds Won: " + get_player_stat(player, "zdog_rounds_finished") + "\n");
    fs_write(file, "Hell Hound Rounds Lost: " + get_player_stat(player, "zdog_rounds_lost") + "\n");
    fs_write(file, "Killed by Hell Hound: " + get_player_stat(player, "killed_by_zdog") + "\n");
    fs_write(file, "Screecher Minigames Won: " + get_player_stat(player, "screecher_minigames_won") + "\n");
    fs_write(file, "Screecher Minigames Lost: " + get_player_stat(player, "screecher_minigames_lost") + "\n");
    fs_write(file, "Screechers Killed: " + get_player_stat(player, "screechers_killed") + "\n");
    fs_write(file, "Screecher Teleporters: " + get_player_stat(player, "screecher_teleporters_used") + "\n");
    fs_write(file, "Avogadros Defeated: " + get_player_stat(player, "avogadro_defeated") + "\n");
    fs_write(file, "Killed by Avogadro: " + get_player_stat(player, "killed_by_avogadro") + "\n");
    fs_write(file, "Contaminations Received: " + get_player_stat(player, "contaminations_received") + "\n");
    fs_write(file, "Contaminations Given: " + get_player_stat(player, "contaminations_given") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[PERSISTENT UPGRADES]\n");
    fs_write(file, "Boarding Repair: " + get_player_stat(player, "pers_boarding") + "\n");
    fs_write(file, "Revive No Perk: " + get_player_stat(player, "pers_revivenoperk") + "\n");
    fs_write(file, "Multikill Headshots: " + get_player_stat(player, "pers_multikill_headshots") + "\n");
    fs_write(file, "Cash Back Bought: " + get_player_stat(player, "pers_cash_back_bought") + "\n");
    fs_write(file, "Cash Back Prone: " + get_player_stat(player, "pers_cash_back_prone") + "\n");
    fs_write(file, "Insta Kill: " + get_player_stat(player, "pers_insta_kill") + "\n");
    fs_write(file, "Juggernog Persistent: " + get_player_stat(player, "pers_jugg") + "\n");
    fs_write(file, "Juggernog Downgrades: " + get_player_stat(player, "pers_jugg_downgrade_count") + "\n");
    fs_write(file, "Carpenter Persistent: " + get_player_stat(player, "pers_carpenter") + "\n");
    fs_write(file, "Nube 5 Times: " + get_player_stat(player, "pers_nube_5_times") + "\n");
    fs_write(file, "PhD Flopper Counter: " + get_player_stat(player, "pers_flopper_counter") + "\n");
    fs_write(file, "Perk Lose Counter: " + get_player_stat(player, "pers_perk_lose_counter") + "\n");
    fs_write(file, "Pistol Points Counter: " + get_player_stat(player, "pers_pistol_points_counter") + "\n");
    fs_write(file, "Double Points Counter: " + get_player_stat(player, "pers_double_points_counter") + "\n");
    fs_write(file, "Sniper Counter: " + get_player_stat(player, "pers_sniper_counter") + "\n");
    fs_write(file, "Marathon Counter: " + get_player_stat(player, "pers_marathon_counter") + "\n");
    fs_write(file, "Box Weapon Counter: " + get_player_stat(player, "pers_box_weapon_counter") + "\n");
    fs_write(file, "Kiting Counter: " + get_player_stat(player, "pers_zombie_kiting_counter") + "\n");
    fs_write(file, "Max Ammo Counter: " + get_player_stat(player, "pers_max_ammo_counter") + "\n");
    fs_write(file, "Melee Bonus Counter: " + get_player_stat(player, "pers_melee_bonus_counter") + "\n");
    fs_write(file, "Nube Counter: " + get_player_stat(player, "pers_nube_counter") + "\n");
    fs_write(file, "Last Man Standing Counter: " + get_player_stat(player, "pers_last_man_standing_counter") + "\n");
    fs_write(file, "Reload Speed Counter: " + get_player_stat(player, "pers_reload_speed_counter") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[MOB OF THE DEAD STATS]\n");
    fs_write(file, "Brutus Killed: " + get_player_stat(player, "prison_brutus_killed") + "\n");
    fs_write(file, "Tomahawk Acquired: " + get_player_stat(player, "prison_tomahawk_acquired") + "\n");
    fs_write(file, "Fan Trap Used: " + get_player_stat(player, "prison_fan_trap_used") + "\n");
    fs_write(file, "Acid Trap Used: " + get_player_stat(player, "prison_acid_trap_used") + "\n");
    fs_write(file, "Sniper Tower Used: " + get_player_stat(player, "prison_sniper_tower_used") + "\n");
    fs_write(file, "Easter Egg Good Ending: " + get_player_stat(player, "prison_ee_good_ending") + "\n");
    fs_write(file, "Easter Egg Bad Ending: " + get_player_stat(player, "prison_ee_bad_ending") + "\n");
    fs_write(file, "Spoon Acquired: " + get_player_stat(player, "prison_ee_spoon_acquired") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[BURIED STATS]\n");
    fs_write(file, "LSAT Purchased: " + get_player_stat(player, "buried_lsat_purchased") + "\n");
    fs_write(file, "Fountain Transporter Used: " + get_player_stat(player, "buried_fountain_transporter_used") + "\n");
    fs_write(file, "Ghosts Killed: " + get_player_stat(player, "buried_ghost_killed") + "\n");
    fs_write(file, "Ghost Drained Player: " + get_player_stat(player, "buried_ghost_drained_player") + "\n");
    fs_write(file, "Ghost Perk Acquired: " + get_player_stat(player, "buried_ghost_perk_acquired") + "\n");
    fs_write(file, "Sloth Booze Given: " + get_player_stat(player, "buried_sloth_booze_given") + "\n");
    fs_write(file, "Sloth Booze Break Barricade: " + get_player_stat(player, "buried_sloth_booze_break_barricade") + "\n");
    fs_write(file, "Sloth Candy Given: " + get_player_stat(player, "buried_sloth_candy_given") + "\n");
    fs_write(file, "Sloth Candy Protect: " + get_player_stat(player, "buried_sloth_candy_protect") + "\n");
    fs_write(file, "Sloth Candy Build Buildable: " + get_player_stat(player, "buried_sloth_candy_build_buildable") + "\n");
    fs_write(file, "Sloth Candy Wallbuy: " + get_player_stat(player, "buried_sloth_candy_wallbuy") + "\n");
    fs_write(file, "Sloth Candy Fetch Buildable: " + get_player_stat(player, "buried_sloth_candy_fetch_buildable") + "\n");
    fs_write(file, "Sloth Candy Box Lock: " + get_player_stat(player, "buried_sloth_candy_box_lock") + "\n");
    fs_write(file, "Sloth Candy Box Move: " + get_player_stat(player, "buried_sloth_candy_box_move") + "\n");
    fs_write(file, "Sloth Candy Box Spin: " + get_player_stat(player, "buried_sloth_candy_box_spin") + "\n");
    fs_write(file, "Sloth Candy Powerup Cycle: " + get_player_stat(player, "buried_sloth_candy_powerup_cycle") + "\n");
    fs_write(file, "Sloth Candy Dance: " + get_player_stat(player, "buried_sloth_candy_dance") + "\n");
    fs_write(file, "Sloth Candy Crawler: " + get_player_stat(player, "buried_sloth_candy_crawler") + "\n");
    fs_write(file, "Wallbuy Placed: " + get_player_stat(player, "buried_wallbuy_placed") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[ORIGINS STATS]\n");
    fs_write(file, "Mechz Killed: " + get_player_stat(player, "tomb_mechz_killed") + "\n");
    fs_write(file, "Robot Stomped: " + get_player_stat(player, "tomb_giant_robot_stomped") + "\n");
    fs_write(file, "Robot Accessed: " + get_player_stat(player, "tomb_giant_robot_accessed") + "\n");
    fs_write(file, "Generators Captured: " + get_player_stat(player, "tomb_generator_captured") + "\n");
    fs_write(file, "Generators Defended: " + get_player_stat(player, "tomb_generator_defended") + "\n");
    fs_write(file, "Generators Lost: " + get_player_stat(player, "tomb_generator_lost") + "\n");
    fs_write(file, "Digs: " + get_player_stat(player, "tomb_dig") + "\n");
    fs_write(file, "Golden Shovel: " + get_player_stat(player, "tomb_golden_shovel") + "\n");
    fs_write(file, "Golden Helmet: " + get_player_stat(player, "tomb_golden_hard_hat") + "\n");
    fs_write(file, "Perk Slots Extended: " + get_player_stat(player, "tomb_perk_extension") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[CHEAT FLAGS DETECTED]\n");
    fs_write(file, "Too Many Weapons: " + get_player_stat(player, "cheat_too_many_weapons") + "\n");
    fs_write(file, "Out of Playable: " + get_player_stat(player, "cheat_out_of_playable") + "\n");
    fs_write(file, "Too Friendly: " + get_player_stat(player, "cheat_too_friendly") + "\n");
    fs_write(file, "Total Cheat Flags: " + get_player_stat(player, "cheat_total") + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[WEAPON USE]\n");
    fs_write(file, "Most Used: " + most_used_weapon + "\n");
    fs_write(file, "\n");
    
    
    fs_write(file, "[OTHER]\n");
    fs_write(file, "ZTeam: " + get_player_stat(player, "score") + "\n");
    fs_write(file, "\n");

    
    if (isDefined(player.weapon_kills_data) && player.weapon_kills_data.size > 0)
    {
        fs_write(file, "\nARMAS USADAS EN LA PARTIDA:\n");

        
        weapons_sorted = [];
        weapon_names = getArrayKeys(player.weapon_kills_data);
        
        foreach (weapon_name in weapon_names)
        {
            kills = player.weapon_kills_data[weapon_name].kills;
            weapons_sorted[weapons_sorted.size] = weapon_name + "|" + kills;
        }

        
        for (i = 0; i < weapons_sorted.size - 1; i++)
        {
            for (j = i + 1; j < weapons_sorted.size; j++)
            {
                weapon_i = strTok(weapons_sorted[i], "|");
                weapon_j = strTok(weapons_sorted[j], "|");

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

        
        for (i = 0; i < weapons_sorted.size && i < 20; i++)
        {
            weapon_tokens = strTok(weapons_sorted[i], "|");
            weapon_name = weapon_tokens[0];
            weapon_data = player.weapon_kills_data[weapon_name];
            
            
            line = weapon_name + "|" + weapon_data.kills + "|" + weapon_data.headshots + "|";
            
            
            for (k = 0; k < weapon_data.kill_times.size; k++)
            {
                kill_time = weapon_data.kill_times[k];
                line += kill_time.time + "," + kill_time.isHeadshot + "," + kill_time.round;
                
                if (k < weapon_data.kill_times.size - 1)
                    line += ";";
            }
            
            fs_write(file, line + "\n");
        }
    }
    
    else if (isDefined(all_weapons_data) && all_weapons_data.size > 0)
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

    
    round_number = int(round_number);

    if (isDefined(level.last_round_start_time))
    {
        
        level.round_durations[round_number] = getTime() - level.last_round_start_time;
    }

    if (isDefined(level.round_durations) && level.round_durations.size > 0)
    {
        fs_write(file, "\n[ROUND DURATIONS]\n");
        fs_write(file, "--------------------------------\n");
        for (i = 1; i <= round_number; i++)
        {
            
            duration_val = 0;
            if (isDefined(level.round_durations[i]))
                duration_val = level.round_durations[i];
                
            r_duration = int(duration_val / 1000);
            r_hours = int(r_duration / 3600);
            r_minutes = int((r_duration % 3600) / 60);
            r_seconds = r_duration % 60;
            
            r_dur_str = "";
            if (r_hours < 10) r_dur_str += "0";
            r_dur_str += r_hours + ":";
            if (r_minutes < 10) r_dur_str += "0";
            r_dur_str += r_minutes + ":";
            if (r_seconds < 10) r_dur_str += "0";
            r_dur_str += r_seconds;
            
            
            if (i == round_number)
                fs_write(file, "Ronda " + i + ": " + r_dur_str + " (DEAD)\n");
            else
                fs_write(file, "Ronda " + i + ": " + r_dur_str + "\n");
        }
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

    save_recent_match(player, map_name, round_number, kills, headshots, revives, downs, score, most_used_weapon, all_weapons_data);
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


get_map_display_name(map_code)
{
    
    is_bonus = false;
    actual_map_code = map_code;
    
    if (isSubStr(map_code, " bonus"))
    {
        is_bonus = true;
        
        actual_map_code = getSubStr(map_code, 0, map_code.size - 6);
    }
    
    display_name = "";
    
    switch (actual_map_code)
    {
        
        case "tomb": display_name = "Origins"; break;
        case "transit": display_name = "Transit"; break;
        case "tranzit": display_name = "Transit"; break;
        case "busdepot": display_name = "Bus Depot"; break;
        case "processing": display_name = "Buried"; break;
        case "prison": display_name = "Mob of the Dead"; break;
        case "nuked": display_name = "Nuketown"; break;
        case "highrise": display_name = "Die Rise"; break;
        
        
        case "tunnel": display_name = "Tunnel"; break;
        case "diner": display_name = "Diner"; break;
        case "power": display_name = "Power Station"; break;
        case "cornfield": display_name = "Cornfield"; break;
        case "house": display_name = "Farm House"; break;
        case "town": display_name = "Town"; break;
        case "farm": display_name = "Farm"; break;
        
        
        case "nuketown": display_name = "Nuketown"; break;
        
        
        case "building1top": display_name = "Rooftop"; break;
        case "redroom": display_name = "Red Room"; break;
        
        
        case "showers": display_name = "Showers"; break;
        case "docks": display_name = "Docks"; break;
        case "cellblock": display_name = "Cell Block"; break;
        case "rooftop": display_name = "Rooftop"; break;
        
        
        case "maze": display_name = "Maze"; break;
        
        
        case "trenches": display_name = "Trenches"; break;
        case "crazyplace": display_name = "Crazy Place"; break;
        case "excavation": display_name = "Excavation Site"; break;
        
        default: display_name = actual_map_code; break;
    }
    
    
    if (is_bonus)
    {
        display_name += " Bonus";
    }
    
    return display_name;
}

get_corrected_map_name(map_name)
{
    
    custom_map = getDvar("customMap");
    
    if (isDefined(custom_map) && custom_map != "" && custom_map != "vanilla")
    {
        
        bonus_maps = strTok("diner power cornfield tunnel house town farm busdepot nuketown docks showers cellblock rooftop building1top maze trenches crazyplace", " ");
        
        foreach (bonus_map in bonus_maps)
        {
            if (custom_map == bonus_map)
            {
                return custom_map + " bonus";
            }
        }
        
        return custom_map;
    }
    
    
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









save_menu_config(player, override_filename, save_settings_only)
{
    if (isDefined(save_settings_only) && save_settings_only)
        return save_menu_config_selective(player, true, false, false, override_filename);
        
    return save_menu_config_selective(player, true, true, true, override_filename);
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


save_menu_config_selective(player, save_settings, save_nightmode, save_map, override_filename)
{
    
    player_guid = player getGuid();

    
    filename = isDefined(override_filename) ? override_filename : "scriptdata/menu/" + player_guid + ".txt";

    
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
                        else if (key == "show_coords") existing_map.show_coords = value;
                        else if (key == "dev_password") existing_settings.dev_password = value;
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
        dev_password = isDefined(player.dev_password) ? player.dev_password : "admin";
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
        dev_password = isDefined(existing_settings.dev_password) ? existing_settings.dev_password : "admin";
    }

    fs_write(file, "language=" + lang_value + "\n");
    
    lang_def_val = (isDefined(player.language_defined) && player.language_defined) ? "1" : "0";
    fs_write(file, "language_defined=" + lang_def_val + "\n");
    
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
    fs_write(file, "dev_password=" + dev_password + "\n");

    
    
    
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
        show_coords = isDefined(player.show_coords) ? player.show_coords : false;
    }
    else
    {
        
        perk_unlimited = isDefined(existing_map.perk_unlimited) ? string_to_bool(existing_map.perk_unlimited) : false;
        third_person = isDefined(existing_map.third_person) ? string_to_bool(existing_map.third_person) : false;
        show_coords = isDefined(existing_map.show_coords) ? string_to_bool(existing_map.show_coords) : false;
    }

    fs_write(file, "perk_unlimited=" + (perk_unlimited ? "1" : "0") + "\n");
    fs_write(file, "third_person=" + (third_person ? "1" : "0") + "\n");
    fs_write(file, "show_coords=" + (show_coords ? "1" : "0") + "\n");

    fs_write(file, "\n");
    fs_write(file, "================================\n");

    fs_fclose(file);

    
    if (isDefined(player) && isPlayer(player))
    {
        player iPrintlnBold("^2Configuración guardada exitosamente");
    }

    return true;
}


load_menu_config(player, override_filename)
{
    
    player_guid = player getGuid();

    filename = isDefined(override_filename) ? override_filename : "scriptdata/menu/" + player_guid + ".txt";

    
    
    player.night_mode_enabled = false;
    player.fog_enabled = false;
    player.night_mode_filter = 0;
    player.night_mode_darkness = 0;
    
    
    player.perk_unlimite_active = false;
    player.TPP = false;
    player.show_coords = false;

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
                    case "language_defined":
                        player.language_defined = string_to_bool(value);
                        break;
                    case "dev_password":
                        player.dev_password = trim_string(value);
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

                    case "show_coords":
                        player.show_coords = string_to_bool(value);
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
    else
    {
        player thread scripts\zm\night_mode::reset_all_night_mode_dvars();
    }
    
    if (isDefined(player.fog_enabled) && player.fog_enabled)
    {
        wait 0.2;
        player thread scripts\zm\night_mode::toggle_fog_saved();
    }

    
    if (isDefined(player.perk_unlimite_active) && player.perk_unlimite_active)
    {
        level.is_unlimited_perks = true;
        level.perk_purchase_limit = 9;
    }
    else
    {
        level.is_unlimited_perks = false;
        level.perk_purchase_limit = 4;
    }

    if (isDefined(player.TPP) && player.TPP)
    {
        player setclientthirdperson(1);
    }
    else
    {
        player setclientthirdperson(0);
    }

    if (isDefined(player.show_coords) && player.show_coords)
    {
        player thread scripts\zm\funciones::apply_show_coords_saved();
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
    
    if (!isDefined(level.match_start_time))
    {
        level.match_start_time = getTime();
    }
    
    
    if (!isDefined(player.weapon_kills_data))
    {
        player.weapon_kills_data = [];
    }
    
    
    if (!isDefined(player.weapon_kills))
    {
        player.weapon_kills = [];
    }
    
    player thread track_weapon_kills_callback();
    player thread init_round_pacing();
}

init_round_pacing()
{
    if (isDefined(level.round_pacing_initialized))
        return;
    
    level.round_pacing_initialized = true;
    level.round_durations = [];
    level.last_round_start_time = getTime();
    level.pacing_current_round = level.round_number;
    
    while (true)
    {
        
        if (level.round_number > level.pacing_current_round)
        {
            current_time = getTime();
            duration = current_time - level.last_round_start_time;
            
            
            level.round_durations[level.pacing_current_round] = duration;
            
            
            level.pacing_current_round = level.round_number;
            level.last_round_start_time = current_time;
        }
        
        wait 1;
    }
}


track_weapon_kills_callback()
{
    self endon("disconnect");
    level endon("end_game");

    wait 1;

    
    self.weapon_tracking_last_kills = 0;
    self.weapon_tracking_last_headshots = 0;
    
    if (isDefined(self.pers["kills"]))
        self.weapon_tracking_last_kills = self.pers["kills"];
    if (isDefined(self.pers["headshots"]))
        self.weapon_tracking_last_headshots = self.pers["headshots"];

    while (true)
    {
        wait 0.05;

        
        current_kills = get_player_stat(self, "kills");
        current_headshots = get_player_stat(self, "headshots");

        
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
                
                if (!isDefined(self.weapon_kills_data[current_weapon]))
                {
                    self.weapon_kills_data[current_weapon] = spawnStruct();
                    self.weapon_kills_data[current_weapon].kills = 0;
                    self.weapon_kills_data[current_weapon].headshots = 0;
                    self.weapon_kills_data[current_weapon].kill_times = [];
                }

                
                kills_diff = current_kills - self.weapon_tracking_last_kills;
                headshots_diff = current_headshots - self.weapon_tracking_last_headshots;

                
                self.weapon_kills_data[current_weapon].kills += kills_diff;
                self.weapon_kills_data[current_weapon].headshots += headshots_diff;

                
                if (!isDefined(self.weapon_kills[current_weapon]))
                    self.weapon_kills[current_weapon] = 0;
                self.weapon_kills[current_weapon] += kills_diff;

                
                current_round = level.round_number;
                
                
                if (!isDefined(level.match_start_time))
                    level.match_start_time = getTime();
                    
                elapsed_time = getTime() - level.match_start_time;
                game_time = int(elapsed_time / 1000);
                hours = int(game_time / 3600);
                minutes = int((game_time % 3600) / 60);
                seconds = game_time % 60;
                
                time_str = "";
                if (hours < 10) time_str += "0";
                time_str += hours + ":";
                if (minutes < 10) time_str += "0";
                time_str += minutes + ":";
                if (seconds < 10) time_str += "0";
                time_str += seconds;

                
                for (i = 0; i < kills_diff && self.weapon_kills_data[current_weapon].kill_times.size < 1000; i++)
                {
                    kill_entry = spawnStruct();
                    kill_entry.time = time_str;
                    kill_entry.round = current_round;
                    
                    
                    if (i < headshots_diff)
                        kill_entry.isHeadshot = 1;
                    else
                        kill_entry.isHeadshot = 0;
                    
                    self.weapon_kills_data[current_weapon].kill_times[self.weapon_kills_data[current_weapon].kill_times.size] = kill_entry;
                }
            }

            
            self.weapon_tracking_last_kills = current_kills;
            self.weapon_tracking_last_headshots = current_headshots;
        }
    }
}




formatFloat(val, precision)
{
    str = "" + val;
    toks = strTok(str, ".");
    if (toks.size == 1)
        return str + ".00";
    
    dec = toks[1];
    if (dec.size > precision)
        dec = getSubStr(dec, 0, precision);
    else if (dec.size < precision)
    {
        for (i = dec.size; i < precision; i++)
            dec += "0";
    }
    
    return toks[0] + "." + dec;
}







save_teleport_point(player, point_name, origin, angles, category)
{
    player_guid = player getGuid();
    
    
    map_name = get_corrected_map_name(getDvar("mapname"));
    
    
    filename = "scriptdata/teleport/" + player_guid + "/" + map_name + "_teleport.txt";
    
    
    line_data = point_name + "|";
    line_data += origin[0] + "," + origin[1] + "," + origin[2] + "|";
    line_data += angles[0] + "," + angles[1] + "," + angles[2] + "|";
    line_data += (isDefined(category) ? category : "") + "\n";
    
    
    file = fs_fopen(filename, "append");
    if (!isDefined(file))
    {
        return false;
    }
    
    fs_write(file, line_data);
    fs_fclose(file);
    
    return true;
}


load_teleport_points(player)
{
    player_guid = player getGuid();
    
    
    map_name = get_corrected_map_name(getDvar("mapname"));
    
    
    filename = "scriptdata/teleport/" + player_guid + "/" + map_name + "_teleport.txt";
    
    
    player.teleport_points = [];
    player.teleport_names = [];
    player.teleport_categories_map = []; 
    player.teleport_count = 0;
    
    
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
    count = 0;
    
    foreach (line in lines)
    {
        if (isSubStr(line, "|"))
        {
            parts = strTok(line, "|");
            if (parts.size >= 3)
            {
                
                point_name = parts[0];
                
                origin_str = strTok(parts[1], ",");
                if (origin_str.size >= 3)
                {
                    origin = (float(origin_str[0]), float(origin_str[1]), float(origin_str[2]));
                }
                else continue;
                
                angles_str = strTok(parts[2], ",");
                if (angles_str.size >= 3)
                {
                    angles = (float(angles_str[0]), float(angles_str[1]), float(angles_str[2]));
                }
                else continue;
                
                category = "";
                if (parts.size >= 4)
                {
                    category = parts[3];
                }
                
                
                point_data = spawnStruct();
                point_data.origin = origin;
                point_data.angles = angles;
                point_data.category = category;
                
                
                player.teleport_points[count] = point_data;
                player.teleport_names[count] = point_name;
                count++;
            }
        }
    }
    
    player.teleport_count = count;
    return count;
}


delete_teleport_point_persistent(player, point_name)
{
    player_guid = player getGuid();
    
    
    map_name = get_corrected_map_name(getDvar("mapname"));
    
    
    filename = "scriptdata/teleport/" + player_guid + "/" + map_name + "_teleport.txt";
    
    
    if (!fs_testfile(filename))
    {
        return false;
    }
    
    
    file_read = fs_fopen(filename, "read");
    if (!isDefined(file_read))
    {
        return false;
    }
    
    file_size = fs_length(file_read);
    content = fs_read(file_read, file_size);
    fs_fclose(file_read);
    
    
    lines = strTok(content, "\n");
    new_content = "";
    found = false;
    
    foreach (line in lines)
    {
        if (isSubStr(line, "|"))
        {
            parts = strTok(line, "|");
            if (parts.size >= 3 && parts[0] == point_name)
            {
                
                found = true;
                continue;
            }
        }
        
        
        if (line != "")
        {
            new_content += line + "\n";
        }
    }
    
    if (!found)
    {
        return false; 
    }
    
    
    file_write = fs_fopen(filename, "write");
    if (!isDefined(file_write))
    {
        return false;
    }
    
    fs_write(file_write, new_content);
    fs_fclose(file_write);
    
    return true;
}


delete_all_teleport_points_persistent(player)
{
    player_guid = player getGuid();
    
    
    map_name = get_corrected_map_name(getDvar("mapname"));
    
    
    filename = "scriptdata/teleport/" + player_guid + "/" + map_name + "_teleport.txt";
    
    
    if (!fs_testfile(filename))
    {
        return false;
    }
    
    
    file = fs_fopen(filename, "write");
    if (!isDefined(file))
    {
        return false;
    }
    
    fs_write(file, "");
    fs_fclose(file);
    
    return true;
}





save_teleport_category(player, category_name)
{
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    filename = "scriptdata/teleport/" + player_guid + "/" + map_name + "_categories.txt";
    
    
    if (fs_testfile(filename))
    {
        file_read = fs_fopen(filename, "read");
        if (isDefined(file_read))
        {
            file_size = fs_length(file_read);
            content = fs_read(file_read, file_size);
            fs_fclose(file_read);
            
            categories = strTok(content, "\n");
            foreach (cat in categories)
            {
                if (cat == category_name) return false;
            }
        }
    }
    
    file = fs_fopen(filename, "append");
    if (!isDefined(file)) return false;
    
    fs_write(file, category_name + "\n");
    fs_fclose(file);
    return true;
}

load_teleport_categories(player)
{
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    filename = "scriptdata/teleport/" + player_guid + "/" + map_name + "_categories.txt";
    
    player.teleport_categories = [];
    
    if (!fs_testfile(filename)) return [];
    
    file = fs_fopen(filename, "read");
    if (!isDefined(file)) return [];
    
    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);
    
    player.teleport_categories = strTok(content, "\n");
    return player.teleport_categories;
}

delete_teleport_category_persistent(player, category_name)
{
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    filename = "scriptdata/teleport/" + player_guid + "/" + map_name + "_categories.txt";
    
    if (!fs_testfile(filename)) return false;
    
    file_read = fs_fopen(filename, "read");
    file_size = fs_length(file_read);
    content = fs_read(file_read, file_size);
    fs_fclose(file_read);
    
    lines = strTok(content, "\n");
    new_content = "";
    found = false;
    
    foreach (line in lines)
    {
        if (line == category_name)
        {
            found = true;
            continue;
        }
        new_content += line + "\n";
    }
    
    if (!found) return false;
    
    file_write = fs_fopen(filename, "write");
    fs_write(file_write, new_content);
    fs_fclose(file_write);
    
    
    update_all_points_remove_category(player, category_name);
    
    return true;
}

update_point_category_persistent(player, point_name, category_name)
{
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    filename = "scriptdata/teleport/" + player_guid + "/" + map_name + "_teleport.txt";
    
    if (!fs_testfile(filename)) return false;
    
    file_read = fs_fopen(filename, "read");
    file_size = fs_length(file_read);
    content = fs_read(file_read, file_size);
    fs_fclose(file_read);
    
    lines = strTok(content, "\n");
    new_content = "";
    found = false;
    
    foreach (line in lines)
    {
        if (isSubStr(line, "|"))
        {
            parts = strTok(line, "|");
            if (parts.size >= 3 && parts[0] == point_name)
            {
                
                category = (isDefined(category_name) ? category_name : "");
                new_line = parts[0] + "|" + parts[1] + "|" + parts[2] + "|" + category + "\n";
                new_content += new_line;
                found = true;
                continue;
            }
        }
        new_content += line + "\n";
    }
    
    if (!found) return false;
    
    file_write = fs_fopen(filename, "write");
    fs_write(file_write, new_content);
    fs_fclose(file_write);
    return true;
}

update_all_points_remove_category(player, category_name)
{
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    filename = "scriptdata/teleport/" + player_guid + "/" + map_name + "_teleport.txt";
    
    if (!fs_testfile(filename)) return;
    
    file_read = fs_fopen(filename, "read");
    file_size = fs_length(file_read);
    content = fs_read(file_read, file_size);
    fs_fclose(file_read);
    
    lines = strTok(content, "\n");
    new_content = "";
    modified = false;
    
    foreach (line in lines)
    {
        if (isSubStr(line, "|"))
        {
            parts = strTok(line, "|");
            if (parts.size >= 4 && parts[3] == category_name)
            {
                new_line = parts[0] + "|" + parts[1] + "|" + parts[2] + "|\n";
                new_content += new_line;
                modified = true;
                continue;
            }
        }
        new_content += line + "\n";
    }
    
    if (modified)
    {
        file_write = fs_fopen(filename, "write");
        fs_write(file_write, new_content);
        fs_fclose(file_write);
    }
}





load_custom_dev_categories(player)
{
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    filename = "scriptdata/dev_menu/" + player_guid + "/" + map_name + "_dev_categories.txt";
    
    categories = [];
    
    if (!fs_testfile(filename))
        return categories;
        
    file = fs_fopen(filename, "read");
    if (!isDefined(file))
        return categories;
        
    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);
    
    categories = strTok(content, "\n");
    return categories;
}

save_custom_dev_category(player, category_name)
{
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    filename = "scriptdata/dev_menu/" + player_guid + "/" + map_name + "_dev_categories.txt";
    
    existing = load_custom_dev_categories(player);
    foreach (cat in existing)
    {
        if (cat == category_name)
            return false;
    }
    
    file = fs_fopen(filename, "append");
    if (!isDefined(file))
        return false;
    
    fs_write(file, category_name + "\n");
    fs_fclose(file);
    return true;
}

delete_custom_dev_category_persistent(player, category_name)
{
    player_guid = player getGuid();
    filename = "scriptdata/dev_menu/" + player_guid + ".txt";
    
    if (!fs_testfile(filename))
        return false;
        
    file_read = fs_fopen(filename, "read");
    file_size = fs_length(file_read);
    content = fs_read(file_read, file_size);
    fs_fclose(file_read);
    
    lines = strTok(content, "\n");
    new_content = "";
    found = false;
    
    foreach (line in lines)
    {
        if (isSubStr(line, "CAT|" + category_name))
        {
            found = true;
            continue;
        }
        
        if (isSubStr(line, "ITEM|" + category_name + "|"))
        {
            found = true;
            continue;
        }
        
        if (line != "")
            new_content += line + "\n";
    }
    
    if (!found)
        return false;
        
    file_write = fs_fopen(filename, "write");
    if (isDefined(file_write))
    {
        fs_write(file_write, new_content);
        fs_fclose(file_write);
        return true;
    }
    
    return false;
}

load_custom_dev_items(player, category_name)
{
    player_guid = player getGuid();
    filename = "scriptdata/dev_menu/" + player_guid + ".txt";
    
    items = [];
    
    if (!fs_testfile(filename))
        return items;
        
    file = fs_fopen(filename, "read");
    if (!isDefined(file))
        return items;
        
    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);
    
    lines = strTok(content, "\n");
    foreach (line in lines)
    {
        if (isSubStr(line, "ITEM|" + category_name + "|"))
        {
            parts = strTok(line, "|");
            if (parts.size >= 3)
            {
                items[items.size] = parts[2];
            }
        }
    }
    
    return items;
}

save_custom_dev_item(player, category_name, function_key)
{
    player_guid = player getGuid();
    filename = "scriptdata/dev_menu/" + player_guid + ".txt";
    
    
    existing = load_custom_dev_items(player, category_name);
    foreach (item in existing)
    {
        if (item == function_key)
            return false;
    }
    
    file = fs_fopen(filename, "append");
    if (!isDefined(file))
        return false;
        
    fs_write(file, "ITEM|" + category_name + "|" + function_key + "\n");
    fs_fclose(file);
    return true;
}

remove_custom_dev_item_persistent(player, category_name, function_key)
{
    player_guid = player getGuid();
    filename = "scriptdata/dev_menu/" + player_guid + ".txt";
    
    if (!fs_testfile(filename))
        return false;
        
    file_read = fs_fopen(filename, "read");
    file_size = fs_length(file_read);
    content = fs_read(file_read, file_size);
    fs_fclose(file_read);
    
    lines = strTok(content, "\n");
    new_content = "";
    found = false;
    
    target_line = "ITEM|" + category_name + "|" + function_key;
    
    foreach (line in lines)
    {
        if (line == target_line)
        {
            found = true;
            continue;
        }
        
        if (line != "")
            new_content += line + "\n";
    }
    
    if (!found)
        return false;
        
    file_write = fs_fopen(filename, "write");
    if (isDefined(file_write))
    {
        fs_write(file_write, new_content);
        fs_fclose(file_write);
        return true;
    }
    
    return false;
}

save_menu_profile(player, profile_name)
{
    player_guid = player getGuid();
    filename = "scriptdata/profiles/" + player_guid + "/" + profile_name + ".txt";
    
    success = save_menu_config_selective(player, true, true, true, filename);
    if (success)
    {
        add_profile_to_manifest(player, profile_name);
    }
    return success;
}

save_menu_profile_selective(player, profile_name, save_settings, save_nightmode, save_map)
{
    player_guid = player getGuid();
    filename = "scriptdata/profiles/" + player_guid + "/" + profile_name + ".txt";
    
    success = save_menu_config_selective(player, save_settings, save_nightmode, save_map, filename);
    if (success)
    {
        add_profile_to_manifest(player, profile_name);
    }
    return success;
}

load_menu_profile(player, profile_name)
{
    player_guid = player getGuid();
    filename = "scriptdata/profiles/" + player_guid + "/" + profile_name + ".txt";
    return load_menu_config(player, filename);
}

get_player_profiles(player)
{
    player_guid = player getGuid();
    dir = "scriptdata/profiles/" + player_guid;
    manifest = dir + "/manifest.txt";
    
    if (!fs_testfile(manifest))
        return [];
    
    file = fs_fopen(manifest, "read");
    if (!isDefined(file))
        return [];
    
    size = fs_length(file);
    if (size == 0)
    {
        fs_fclose(file);
        return [];
    }
    
    content = fs_read(file, size);
    fs_fclose(file);
    
    return strTok(content, "\n");
}

add_profile_to_manifest(player, profile_name)
{
    player_guid = player getGuid();
    dir = "scriptdata/profiles/" + player_guid;
    manifest = dir + "/manifest.txt";
    
    profiles = get_player_profiles(player);
    foreach (p in profiles)
    {
        if (p == profile_name)
            return true;
    }
    
    file = fs_fopen(manifest, "append");
    if (!isDefined(file))
        return false;
        
    fs_write(file, profile_name + "\n");
    fs_fclose(file);
    return true;
}

delete_menu_profile(player, profile_name)
{
    player_guid = player getGuid();
    dir = "scriptdata/profiles/" + player_guid;
    manifest = dir + "/manifest.txt";
    
    profiles = get_player_profiles(player);
    new_content = "";
    found = false;
    
    foreach (p in profiles)
    {
        if (p == profile_name)
        {
            found = true;
            continue;
        }
        
        if (p != "")
            new_content += p + "\n";
    }
    
    if (!found)
        return false;
        
    file = fs_fopen(manifest, "write");
    if (isDefined(file))
    {
        fs_write(file, new_content);
        fs_fclose(file);
        return true;
    }
    return false;
}





save_match_config(player, config_name, source_obj)
{
    if (!isDefined(source_obj))
        source_obj = player;
        
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    dir = "scriptdata/config_gods/" + player_guid;
    filename = dir + "/" + map_name + "_" + config_name + ".txt";
    
    file = fs_fopen(filename, "write");
    if (!isDefined(file))
        return false;
        
    
    health = isDefined(source_obj.maxhealth) ? source_obj.maxhealth : 100;
    score = isDefined(source_obj.score) ? source_obj.score : 500;
    box_cost = isDefined(source_obj.box_cost) ? source_obj.box_cost : 950;
    
    fs_write(file, "max_health=" + health + "\n");
    fs_write(file, "starting_score=" + score + "\n");
    fs_write(file, "box_cost=" + box_cost + "\n");
    
    current_map = getDvar("ui_zm_mapstartlocation");
    fs_write(file, "map=" + current_map + "\n");
    
    
    if (isDefined(source_obj.start_weapon))
    {
        fs_write(file, "start_weapon=" + source_obj.start_weapon + "\n");
        upgraded_val = (isDefined(source_obj.start_weapon_upgraded) && source_obj.start_weapon_upgraded) ? "1" : "0";
        fs_write(file, "start_weapon_upgraded=" + upgraded_val + "\n");
        if (isDefined(source_obj.start_weapon_camo))
            fs_write(file, "start_weapon_camo=" + source_obj.start_weapon_camo + "\n");
    }
    
    if (isDefined(source_obj.start_perks))
        fs_write(file, "start_perks=" + source_obj.start_perks + "\n");
    
    fs_fclose(file);
    add_match_config_to_manifest(player, config_name);
    return true;
}

save_match_config_from_temp(player, config_name)
{
    if (!isDefined(player.temp_config)) return false;
    return save_match_config(player, config_name, player.temp_config);
}


load_match_config(player, config_name, apply_now)
{
    if (!isDefined(apply_now))
        apply_now = true;
        
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    filename = "scriptdata/config_gods/" + player_guid + "/" + map_name + "_" + config_name + ".txt";
    
    if (!fs_testfile(filename))
        return false;
        
    file = fs_fopen(filename, "read");
    if (!isDefined(file))
        return false;
        
    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);
    
    lines = strTok(content, "\n");
    
    
    if (!apply_now)
    {
        if (!isDefined(player.temp_config))
            player.temp_config = spawnStruct();
        
        target = player.temp_config;
        
        if (!isDefined(target.maxhealth)) target.maxhealth = player.maxhealth;
        if (!isDefined(target.score)) target.score = player.score;
        if (!isDefined(target.box_cost)) target.box_cost = player.box_cost;
    }
    else
    {
        target = player;
        if (!isDefined(player.perk_costs))
            player.perk_costs = [];
    }

    foreach (line in lines)
    {
        if (isSubStr(line, "="))
        {
            parts = strTok(line, "=");
            if (parts.size >= 2)
            {
                key = parts[0];
                val_str = parts[1];
                
                if (key == "start_weapon") 
                {
                    target.start_weapon = trim_string(val_str);
                }
                else if (key == "start_weapon_upgraded") 
                {
                    target.start_weapon_upgraded = (val_str == "1");
                }
                else
                {
                    val = int(val_str);
                    if (key == "max_health") target.maxhealth = val;
                    else if (key == "starting_score") target.score = val;
                    else if (key == "box_cost") target.box_cost = val;
                    else if (key == "start_weapon_camo") target.start_weapon_camo = val;
                }
                
                
                if (key == "start_perks")
                {
                    target.start_perks = trim_string(val_str);
                }
            }
        }
    }
    
    
    if (apply_now)
    {
        
        player.current_match_config_name = config_name;
        
        
        player thread apply_match_config_settings();
    }
    
    return true;
}

apply_match_config_settings()
{
    self endon("disconnect");
    
    
    if (isDefined(self.maxhealth))
    {
        self setMaxHealth(self.maxhealth);
        self.health = self.maxhealth;
    }
    
    if (isDefined(self.score))
    {
        
    }
    
    
    if (isDefined(self.box_cost))
    {
        level.zombie_treasure_chest_cost = self.box_cost;
        if (isDefined(level.chests))
        {
            foreach (chest in level.chests)
            {
                if (isDefined(chest))
                    chest.zombie_cost = self.box_cost;
            }
        }
    }
    
    
    if (isDefined(self.start_weapon))
    {
        self takeAllWeapons();
        
        weapon_to_give = self.start_weapon;
        
        
        if (weapon_to_give == "random")
        {
             
             
             if (isDefined(level.weaponList) && level.weaponList.size > 0)
             {
                 rand_idx = randomInt(level.weaponList.size);
                 
                 
                 
                 
                 
                 weapon_to_give = level.weaponList[rand_idx];
                 if (!isDefined(weapon_to_give)) weapon_to_give = level.weaponList[0]; 
             }
             else
             {
                 weapon_to_give = "m1911_zm"; 
             }
        }
        
        self giveWeapon(weapon_to_give);
        
        if (isDefined(self.start_weapon_upgraded) && self.start_weapon_upgraded)
        {
             self thread scripts\zm\weapon::Upgrade_arma(weapon_to_give);
        }
        
        self switchToWeapon(weapon_to_give);
        
        
        if (isDefined(self.start_weapon_camo))
        {
             
             
             
             
             wait 0.1;
             self thread scripts\zm\weapon::apply_weapon_camo(self.start_weapon_camo);
        }
        
        self giveMaxAmmo(weapon_to_give);
    }
    
    
    if (isDefined(self.start_perks) && self.start_perks != "")
    {
        
        
        self thread apply_start_perks_sequence();
    }
}

apply_match_config_from_temp(player)
{
    
    t = player.temp_config;
    if (!isDefined(t)) return;
    
    if (isDefined(t.maxhealth)) player.maxhealth = t.maxhealth;
    if (isDefined(t.score)) player.score = t.score;
    if (isDefined(t.box_cost)) player.box_cost = t.box_cost;
    if (isDefined(t.start_weapon)) player.start_weapon = t.start_weapon;
    if (isDefined(t.start_weapon_upgraded)) player.start_weapon_upgraded = t.start_weapon_upgraded;
    if (isDefined(t.start_weapon_camo)) player.start_weapon_camo = t.start_weapon_camo;
    if (isDefined(t.start_perks)) player.start_perks = t.start_perks;
    
    
    
    
    if (isDefined(t.config_name_ref)) player.current_match_config_name = t.config_name_ref;
    
    player thread apply_match_config_settings();
}

clear_all_perks()
{
    
    perks = [];
    perks[0] = "specialty_armorvest";
    perks[1] = "specialty_fastreload";
    perks[2] = "specialty_quickrevive";
    perks[3] = "specialty_rof";
    perks[4] = "specialty_longersprint";
    perks[5] = "specialty_flakjacket";
    perks[6] = "specialty_additionalprimaryweapon";
    perks[7] = "specialty_deadshot";
    perks[8] = "specialty_grenadepulldeath";
    perks[9] = "specialty_scavenger";
    perks[10] = "specialty_finalstand";
    perks[11] = "specialty_nomotionsensor";
    
    foreach(p in perks)
    {
        if (self hasPerk(p))
            self unsetPerk(p);
    }
}

apply_start_perks_sequence()
{
    self endon("disconnect");
    
    wait 2;
    
    
    self clear_all_perks();
    wait 0.1;

    perks = strTok(self.start_perks, ",");
    foreach(perk in perks)
    {
        if (isDefined(perk) && !self hasPerk(perk))
        {
            
            self maps\mp\zombies\_zm_perks::give_perk(perk, false);
            wait 0.05; 
        }
    }
}

get_player_match_configs(player)
{
    player_guid = player getGuid();
    dir = "scriptdata/config_gods/" + player_guid;
    manifest = dir + "/manifest.txt";
    
    if (!fs_testfile(manifest))
        return [];
        
    file = fs_fopen(manifest, "read");
    file_size = fs_length(file);
    content = fs_read(file, file_size);
    fs_fclose(file);
    
    current_map = getDvar("ui_zm_mapstartlocation");
    all_configs = strTok(content, "\n");
    filtered_configs = [];
    
    foreach (config_name in all_configs)
    {
        if (config_name == "")
            continue;
            
        config_file = dir + "/" + config_name + ".txt";
        if (fs_testfile(config_file))
        {
            cfg_file = fs_fopen(config_file, "read");
            cfg_size = fs_length(cfg_file);
            cfg_content = fs_read(cfg_file, cfg_size);
            fs_fclose(cfg_file);
            
            config_map = "";
            lines = strTok(cfg_content, "\n");
            foreach (line in lines)
            {
                if (isSubStr(line, "map="))
                {
                    config_map = getSubStr(line, 4);
                    break;
                }
            }
            
            if (config_map == "" || config_map == current_map)
            {
                filtered_configs[filtered_configs.size] = config_name;
            }
        }
    }
    
    return filtered_configs;
}

add_match_config_to_manifest(player, config_name)
{
    player_guid = player getGuid();
    dir = "scriptdata/config_gods/" + player_guid;
    manifest = dir + "/manifest.txt";
    
    configs = get_player_match_configs(player);
    foreach (cfg in configs)
    {
        if (cfg == config_name)
            return;
    }
    
    file = fs_fopen(manifest, "append");
    if (isDefined(file))
    {
        fs_write(file, config_name + "\n");
        fs_fclose(file);
    }
}

delete_match_config(player, config_name)
{
    player_guid = player getGuid();
    map_name = get_corrected_map_name(getDvar("mapname"));
    dir = "scriptdata/config_gods/" + player_guid;
    filename = dir + "/" + map_name + "_" + config_name + ".txt";
    manifest = dir + "/manifest.txt";
    
    
    
    
    configs = get_player_match_configs(player);
    new_content = "";
    found = false;
    
    foreach (cfg in configs)
    {
        if (cfg == config_name)
        {
            found = true;
            continue;
        }
        if (cfg != "")
            new_content += cfg + "\n";
    }
    
    if (!found)
        return false;
        
    file = fs_fopen(manifest, "write");
    if (isDefined(file))
    {
        fs_write(file, new_content);
        fs_fclose(file);
        return true;
    }
    return false;
}

trim_string(str)
{
    if (!isDefined(str)) return "";
    
    
    while (str.size > 0 && (str[0] == " " || str[0] == "\r" || str[0] == "\n"))
        str = getSubStr(str, 1);
        
    while (str.size > 0 && (str[str.size - 1] == " " || str[str.size - 1] == "\r" || str[str.size - 1] == "\n"))
        str = getSubStr(str, 0, str.size - 1);
        
    return str;
}
