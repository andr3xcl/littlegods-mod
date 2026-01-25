#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp_utility;
#include common_scripts\utility;

#include scripts\zm\menu;
#include scripts\zm\night_mode;


init()
{
    level thread onplayerSay();
}
onplayerSay()
{
    level endon("end_game");
    prefix = ".";
    for (;;)
    {
        level waittill("say", message, player);
        flag_wait("initial_blackscreen_passed");
        message = toLower(message);
        guild_name = player getGuid();
        if (!level.intermission && message[0] == prefix)
        {
            args = strtok(message, " ");
            command = getSubStr(args[0], 1);
            switch (command)
            {
            case "valuenight":
            case "vanight":
                if (isDefined(args[1]))
                {
                    if(player.nightfix == 0)
                    {
                        player iPrintln("Execute the command .night on");
                    }
                    else{
                        i = Float(args[1]);
                        if(i >= 4.5 && i <= 10)
                        {
                            player iPrintln("The darkness has been adjusted " + i );
                            player.night_mode_darkness = i;
                            player apply_night_vision_exposure( i );
                        }
                        else
                        {
                            player iPrintln("The valid configuration is from 4.5 to 10");
                        }
                    }
                }
                break;
            case "filter":
                if(isDefined(args[1]))
                {
                    if(player.nightfix > 0 && player.nightfix <= 1)
                    {
                        i = int(args[1]);
                        if(i >=0 && i <= 35)
                        {
                            player thread night_mode_toggle(i);
                        }
                        else
                        {
                            player iPrintln("Available filters from 0 to 35");
                        }
                    }
                }
                break;
            case "night":
                if(isDefined(args[1]))
                {
                    if(args[1] == "d" || args[1] == "disable")
                    {
                        player thread disable_night_mode();
                        self.nightfix = 2;
                    }
                    else if(args[1] == "on")
                    {

                        self.nightfix = 0;
                        i = 0;
                        player thread night_mode_toggle(i);
                        self iPrintln("Night mode activated");
                    }
                }
                break;
            case "fog":
                
                break;
            case "command":
                
                break;
            case "menu":
                
                player thread open_menu_allow_chat();
                break;

            }
        }
        wait 0.25;
    }
}


open_menu_allow_chat()
{
    self endon("disconnect");
    level endon("end_game");

    
    if (isDefined(self.menu_toggle_in_progress) && self.menu_toggle_in_progress)
        return;

    self.menu_toggle_in_progress = true;

    if (isDefined(self.menu_open) && self.menu_open)
    {
        self thread scripts\zm\menu::close_all_menus();
        self.open = 0;
        self.menu_open = false;
    }
    else
    {
        self notify("destroy_all_menus");
        wait 0.2;
        self.menu_open = true;
        self.open = 1;
        self thread scripts\zm\menu::open_main_menu();
    }

    wait 0.5; 
    self.menu_toggle_in_progress = false;
}
