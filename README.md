# LauncherGen

Create beautifully-simple .exe launchers files for almost any game that make it compatible with Steam.

## Introduction

Non-Steam games have some issues on Steam:
- The Steam overlay doesn't work consistently with all games.
- Steam often says you're playing a game for a second and then stops, even though you're still playing.
- Because of the previous issue, Steam doesn't track play time for many Non-Steam games properly.
- Changing a game's icon in Steam adds an ugly shortcut arrow to the game.
- It's hard to remember when to close or open external launchers to make them compatible with Steam.

LauncherGen was created to solve all of these issues, and give you a simple way to create a lightweight .exe 
file for any game that makes it compatible with Steam.

Out of the box, it has support for the following:
- Battle.net (Blizzard Launcher) games
- Epic Games Launcher games
- Origin games
- Bethesda Launcher games
- Games with their own launcher
- Games without any launcher

## How To Use

Start by creating a simple Launchers.json file containing the configuration for the games you wish to generate 
launchers for.

In the future, there will be a configuration GUI for this purpose. For now, the configuration is simple and can 
be done in any text editor.

I've included my own Launchers.json file in the application as Launchers.json.sample. I recommend using it as a 
template and copying any entries you want directly into your own file. You can see how easy it is to add your 
own entries to the file, as well.

Once Launchers.json is in place, you're ready to roll. Just run LauncherGen.exe and answer some basic questions,
such as:
- The location of your Launchers.json file
- The location of the folder you wish to create your new game launchers within
- The location of an icon file (or an .exe to extract the icon from) for each game
- The location of a shortcut file for many types of games

After you configure each of these options once, you should not have to do it again. The application will remember 
your selections next time and run automatically.

Each time you run the application, you're given the option to update all of your existing launchers if you wish.

Once you have built your launcher, simply add the newly-generated "[Game Name].exe" file to Steam as a Non-Steam 
game. If set up properly, you should find Steam properly tracks your gameplay, and you should be able to use the
Steam overlay within your games.

You can also add these .exe files to any other game platform or launcher you wish, as there is nothing
Steam-specific about them.

Some of the generated .exe files may depend on vendor files within the main LauncherGen directory), but you can
copy the .exe file anywhere on your system that you would like without having to copy any other dependencies 
around.

## Credits

LauncherGen was conceived and developed by Ben McClure <ben.mcclure@gmail.com> using AutoHotKey.

LauncherGen automatically downloads the following dependencies:
- [AutoHotKey](https://www.autohotkey.com/)
- [Bnetlauncher](https://github.com/dafzor/bnetlauncher)
- [IconsExt](https://www.nirsoft.net/utils/iconsext.html)

These dependencies each use different licensing from LauncherGen, and so LauncherGen doesn't include them in your initial download. They are added later, and you are free to put your own versions of the dependencies there as well.

## Contributing

You can build your own GameLauncher and Game derivative classes and place them within the LauncherLib directory. You can then reference your custom classes in your Launchers.json file.

If you wish to go further, you can download the source code and directly modify or extend the other .ahk files that make up the application.

I would greatly appreciate if you would submit a Pull Request to contribute back any useful additions you make.
