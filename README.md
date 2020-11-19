# Launchpad

Create beautifully-simple .exe files to launch any game seamlessly though Steam and other platforms.

## Latest News

I have completely rewritten Launchpad in the current codebase. This version is highly experimental and likely will not work for you yet.

Once fully released, the new version contains many enhancements, such as:

- A Launchpad GUI. You can now configure Launchpad and access all of its functionality from a single window.
- An online API for getting the latest game and launcher data, as well as build dependencies (https://benmcclure.com/game-launcher-db/). You may contribute your own data to the API now: https://github.com/bmcclure/game-launcher-db
- Open your Launchers.json file in your associated .json editor with a single click, and reload its contents without having to quit Launchpad.
- Open your launchers folder or your game assets folder easily from within the app
- Separate the game assets dir (icons, shortcut files, etc) from the launcher files if desired (or continue mixing the assets in)
- Optionally copy the game assets into the launcher directory if you've chosen to store them separately
- Keep all launcher .exes in a single directory if desired (or continue using one directory per game)
- Update Launchpad's dependency files anytime via a click of a button


Things that won't yet be in this release, but I am working on for a future release:
- A Launcher Manager GUI which allows you to visually build your Launchers.json file.
- A button to automatically remove all generated files when you want to start from scratch.

## Contribute to the Game Launcher DB!
- Public API endpoint: https://benmcclure.com/game-launcher-db/
- GitHub page: https://github.com/bmcclure/game-launcher-db

## Introduction

Non-Steam games have some issues on Steam:
- Some types of games that open via URL or the Windows Store can't be added to Steam at all.
- The Steam overlay doesn't work consistently with all games.
- Steam often says you're playing a game for a second and then stops, even though you're still playing.
- Because of the previous issue, Steam doesn't track play time for many Non-Steam games properly.
- Changing a game's icon in Steam adds an ugly shortcut arrow to the game.
- It's hard to remember when to close or open external launchers to make them compatible with Steam.

Launchpad was created to solve all of these issues, and give you a simple way to create a lightweight .exe 
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

Once Launchers.json is in place, you're ready to roll. Just run Launchpad.exe and answer some basic questions,
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

Some of the generated .exe files may depend on vendor files within the main Launchpad directory), but you can
copy the .exe file anywhere on your system that you would like without having to copy any other dependencies 
around.

## Credits

Launchpad was conceived and developed by Ben McClure <ben.mcclure@gmail.com> using AutoHotKey.

Launchpad automatically downloads the following dependencies:
- [AutoHotKey](https://www.autohotkey.com/)
- [Bnetlauncher](https://github.com/dafzor/bnetlauncher)
- [IconsExt](https://www.nirsoft.net/utils/iconsext.html)

These dependencies each use different licensing from Launchpad, and so Launchpad doesn't include them in your initial download. They are added later, and you are free to put your own versions of the dependencies there as well.

## Contributing

You can build your own GameLauncher and Game derivative classes and place them within the LauncherLib directory. You can then reference your custom classes in your Launchers.json file.

If you wish to go further, you can download the source code and directly modify or extend the other .ahk files that make up the application.

I would greatly appreciate if you would submit a Pull Request to contribute back any useful additions you make.

## Attribution

Icons made by <a href="https://www.flaticon.com/free-icon/rec_1783406" title="iconixar">iconixar</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>