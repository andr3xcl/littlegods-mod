#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;


get_current_zone()
{
    zone = self get_current_zone_name();
    if (!isDefined(zone))
    {
        zone = "";
    }
    return zone;
}

get_current_zone_name()
{
    if (isDefined(self.current_zone))
    {
        return self.current_zone;
    }
    
    zone = self maps\mp\zombies\_zm_zonemgr::get_player_zone();
    return zone;
}

get_zone_display_name(zone)
{
    if (!isDefined(zone))
    {
        return "";
    }

    name = zone;

    if (level.script == "zm_transit" || level.script == "zm_transit_dr")
    {
        if (zone == "zone_pri")
        {
            name = "Bus Depot";
        }
        else if (zone == "zone_pri2")
        {
            name = "Bus Depot Hallway";
        }
        else if (zone == "zone_station_ext")
        {
            name = "Outside Bus Depot";
        }
        else if (zone == "zone_trans_2b")
        {
            name = "Fog After Bus Depot";
        }
        else if (zone == "zone_trans_2")
        {
            name = "Tunnel Entrance";
        }
        else if (zone == "zone_amb_tunnel")
        {
            name = "Tunnel";
        }
        else if (zone == "zone_trans_3")
        {
            name = "Tunnel Exit";
        }
        else if (zone == "zone_roadside_west")
        {
            name = "Outside Diner";
        }
        else if (zone == "zone_gas")
        {
            name = "Gas Station";
        }
        else if (zone == "zone_roadside_east")
        {
            name = "Outside Garage";
        }
        else if (zone == "zone_trans_diner")
        {
            name = "Fog Outside Diner";
        }
        else if (zone == "zone_trans_diner2")
        {
            name = "Fog Outside Garage";
        }
        else if (zone == "zone_gar")
        {
            name = "Garage";
        }
        else if (zone == "zone_din")
        {
            name = "Diner";
        }
        else if (zone == "zone_diner_roof")
        {
            name = "Diner Roof";
        }
        else if (zone == "zone_trans_4")
        {
            name = "Fog After Diner";
        }
        else if (zone == "zone_amb_forest")
        {
            name = "Forest";
        }
        else if (zone == "zone_trans_10")
        {
            name = "Outside Church";
        }
        else if (zone == "zone_town_church")
        {
            name = "Outside Church To Town";
        }
        else if (zone == "zone_trans_5")
        {
            name = "Fog Before Farm";
        }
        else if (zone == "zone_far")
        {
            name = "Outside Farm";
        }
        else if (zone == "zone_far_ext")
        {
            name = "Farm";
        }
        else if (zone == "zone_brn")
        {
            name = "Barn";
        }
        else if (zone == "zone_farm_house")
        {
            name = "Farmhouse";
        }
        else if (zone == "zone_trans_6")
        {
            name = "Fog After Farm";
        }
        else if (zone == "zone_amb_cornfield")
        {
            name = "Cornfield";
        }
        else if (zone == "zone_cornfield_prototype")
        {
            name = "Prototype";
        }
        else if (zone == "zone_trans_7")
        {
            name = "Upper Fog Before Power Station";
        }
        else if (zone == "zone_trans_pow_ext1")
        {
            name = "Fog Before Power Station";
        }
        else if (zone == "zone_pow")
        {
            name = "Outside Power Station";
        }
        else if (zone == "zone_prr")
        {
            name = "Power Station";
        }
        else if (zone == "zone_pcr")
        {
            name = "Power Station Control Room";
        }
        else if (zone == "zone_pow_warehouse")
        {
            name = "Warehouse";
        }
        else if (zone == "zone_trans_8")
        {
            name = "Fog After Power Station";
        }
        else if (zone == "zone_amb_power2town")
        {
            name = "Cabin";
        }
        else if (zone == "zone_trans_9")
        {
            name = "Fog Before Town";
        }
        else if (zone == "zone_town_north")
        {
            name = "North Town";
        }
        else if (zone == "zone_tow")
        {
            name = "Center Town";
        }
        else if (zone == "zone_town_east")
        {
            name = "East Town";
        }
        else if (zone == "zone_town_west")
        {
            name = "West Town";
        }
        else if (zone == "zone_town_south")
        {
            name = "South Town";
        }
        else if (zone == "zone_bar")
        {
            name = "Bar";
        }
        else if (zone == "zone_town_barber")
        {
            name = "Bookstore";
        }
        else if (zone == "zone_ban")
        {
            name = "Bank";
        }
        else if (zone == "zone_ban_vault")
        {
            name = "Bank Vault";
        }
        else if (zone == "zone_tbu")
        {
            name = "Below Bank";
        }
        else if (zone == "zone_trans_11")
        {
            name = "Fog After Town";
        }
        else if (zone == "zone_amb_bridge")
        {
            name = "Bridge";
        }
        else if (zone == "zone_trans_1")
        {
            name = "Fog Before Bus Depot";
        }
    }
    else if (level.script == "zm_prison")
    {
        if (zone == "zone_start")
        {
            name = "D-Block";
        }
        else if (zone == "zone_library")
        {
            name = "Library";
        }
        else if (zone == "zone_cellblock_west")
        {
            name = "Cell Block 2nd Floor";
        }
        else if (zone == "zone_cellblock_west_gondola")
        {
            name = "Cell Block 3rd Floor";
        }
        else if (zone == "zone_cellblock_west_gondola_dock")
        {
            name = "Upper Gondola Platform";
        }
        else if (zone == "zone_cellblock_west_barber")
        {
            name = "Michigan Avenue";
        }
        else if (zone == "zone_cellblock_east")
        {
            name = "Times Square";
        }
        else if (zone == "zone_cafeteria")
        {
            name = "Cafeteria";
        }
        else if (zone == "zone_infirmary")
        {
            name = "Infirmary";
        }
        else if (zone == "zone_roof")
        {
            name = "Roof";
        }
        else if (zone == "zone_warden_office")
        {
            name = "Warden's Office";
        }
        else if (zone == "zone_citadel")
        {
            name = "Citadel";
        }
        else if (zone == "zone_dock")
        {
            name = "Docks";
        }
        else if (zone == "zone_golden_gate_bridge")
        {
            name = "Golden Gate Bridge";
        }
    }
    else if (level.script == "zm_buried")
    {
        if (zone == "zone_start")
        {
            name = "Processing";
        }
        else if (zone == "zone_tunnels_center")
        {
            name = "Center Tunnels";
        }
        else if (zone == "zone_general_store")
        {
            name = "General Store";
        }
        else if (zone == "zone_bank")
        {
            name = "Bank";
        }
        else if (zone == "zone_gun_store")
        {
            name = "Gunsmith";
        }
        else if (zone == "zone_underground_bar")
        {
            name = "Saloon";
        }
        else if (zone == "zone_toy_store")
        {
            name = "Toy Store";
        }
        else if (zone == "zone_candy_store")
        {
            name = "Candy Store";
        }
        else if (zone == "zone_underground_courthouse")
        {
            name = "Courthouse";
        }
        else if (zone == "zone_church_main")
        {
            name = "Church";
        }
        else if (zone == "zone_mansion")
        {
            name = "Mansion";
        }
        else if (zone == "zone_maze")
        {
            name = "Maze";
        }
    }
    else if (level.script == "zm_tomb")
    {
        if (zone == "zone_start")
        {
            name = "Lower Laboratory";
        }
        else if (zone == "zone_start_a")
        {
            name = "Upper Laboratory";
        }
        else if (zone == "zone_start_b")
        {
            name = "Generator 1";
        }
        else if (zone == "zone_bunker_3a")
        {
            name = "Generator 3";
        }
        else if (zone == "zone_bunker_4a")
        {
            name = "Generator 2";
        }
        else if (zone == "zone_village_0")
        {
            name = "Generator 4";
        }
        else if (zone == "zone_village_1")
        {
            name = "Generator 5";
        }
        else if (zone == "zone_village_3a")
        {
            name = "Generator 6";
        }
        else if (zone == "zone_nml_2")
        {
            name = "No Man's Land";
        }
        else if (zone == "zone_chamber_4")
        {
            name = "Crazy Place Center";
        }
        else if (zone == "zone_robot_head")
        {
            name = "Robot's Head";
        }
    }
    else if (level.script == "zm_nuked")
    {
        if (zone == "culdesac_yellow_zone")
        {
            name = "Yellow House";
        }
        else if (zone == "culdesac_green_zone")
        {
            name = "Green House";
        }
        else if (zone == "truck_zone")
        {
            name = "Truck";
        }
    }
    else if (level.script == "zm_highrise")
    {
        if (zone == "zone_green_start")
        {
            name = "Green Highrise";
        }
        else if (zone == "zone_orange_level1")
        {
            name = "Orange Highrise";
        }
        else if (zone == "zone_blue_level5")
        {
            name = "Blue Highrise";
        }
    }

    return name;
}
