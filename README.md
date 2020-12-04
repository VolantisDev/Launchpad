# Launchpad

Create beautifully-simple .exe files to launch any game seamlessly though Steam and other platforms.

## Introduction

Many game platforms (such as Steam) allow you to add games from other platforms to your list and launch 
them with added benefits (such as the Steam overlay). This rocks when it works, but it doesn't
always work quite as well as it should.

Launchpad attempts to bridge the gap and bring your games into whatever platform you want to run them. 
While this is a lofty feat, Launchpad can handle many advanced and custom scenarios. But for most 
scenarios, you can utilize Launchpad's online Launcher DB to pre-configure everything for you nearly
effortlessly.

## Why Use Launchpad

Let's take Steam as an example, because that was the original use case for Launchpad's creation.

Adding Non-Steam games to Steam often works well, but it is a bit quirky, and sometimes features are broken
or it might not work at all. Some common issues include:
- Some games that open via URL or the Windows Store can't be added to Steam.
- Some games cause Steam to say you're playing only for a moment and then stop even though you're still in-game. 
  In these cases, playtime cannot be tracked and your friends don't know you're playing a game.
- Some games launch in ways where the Steam overlay doesn't hook into their process
- Some games that use external launchers continue to say you're playing the game after you exit--sometimes for 
  days if you don't notice.
- Changing a game's icon in Steam adds a shortcut arrow that obscures the icon and makes it obvious it doesn't 
  belong

Launchpad was created to solve all of these issues, and give you a simple way to create a lightweight .exe 
file for any game. You can add them to Steam, or any other launcher. Or you can simply run them directly to
help you control how you launch your games.

## Features

Some of the many features Launchpad offers to help you run your games include:
- Generate .exe files that can be added to any game platform
- Automate the tedious steps required to open and close third party game launchers at the right times
- Launch any game that can be run via shortcut, command, or URI through Steam and other platforms!
- A simple installation process for new users
- A themeable GUI that lets you manage your launchers and access all settings and features
- Themeable progress windows that can optionally show you what Launchpad is doing when launching a game

Launchpad inherently knows how to launch games in several of the main game launcher platforms out there,
including:
- Blizzard (Battle.net)
- Epic Games Launcher
- Origin
- Bethesda Launcher
- Microsoft Store

More launchers are being added all the time, but there's no need to wait! Those launchers are all just presets
for Launchpad, but you can define your own settings and run pretty much any game through pretty much any launcher.
You can also launch games directly that don't use any launcher.

## How To Use

If you're a new user, head over to the Releases page and get the "Launchpad.exe" file from the latest release.
You can ignore all the other files (Launchpad will download them as required).

Simply run Launchpad.exe right from your download folder to get started. You will be able to choose the folder
to install Launchpad to and create a desktop shortcut if desired.

Once it's installed, simply run Launchpad from the installation folder or shortcut, and it will walk you through
the initial settings.

From there, you can use the Launcher Manager to create and manage your Launcher File, and then you can build
your launchers with the click of a button.

There are many advanced settings available by clicking on the Settings button. Help text is being added/expanded
but most of the options should be self-explanatory.

## Updating Launchpad

When there's a new version of Launchpad available, you only have to update Launchpad.exe. All of the other files
Launchpad uses will be updated auotmatically next time you run Launchpad.

To update Launchpad.exe, you have two options:
1. Download the latest Launchpad.exe file from the Releases page and replace your existing file.
1. Run LaunchpadUpdater.exe from the installation directory, which automates that process.

Launchpad currently does not notify you when a new release is available, so make sure to check periodically.
Update notifications are coming soon!

## Using Launchpad with Steam

Launchpad was built specifically with Steam in mind!

Generate your launchers through the Launchpad app, then simply add the new "[Game Name].exe" file that
Launchpad generated as a Non-Steam Game.

It'll show up in your Steam Library with the name and icon you've selected, and if everything worked right, 
launching it should work flawlessly, track your gameplay properly, and give you full Steam overlay support.

## Note on Portability

Your Launcher File and all other Launchpad configuration files are portable, but the launchers that Launchpad
generates will often only work on the system they were generated on, or an equivalent system where everything
is located at the same paths.

If you reinstall your OS or move your games, you'll probably need to open Launchpad and rebuild your launchers 
before using them.

## Credits

Launchpad was conceived and developed by Ben McClure of Volantis Development (ben@volantisdev.com) using the 
powerful scripting language AutoHotKey.

Launchpad automatically downloads a few dependencies for use during its operation. The dependencies it installs are:
- [AutoHotKey](https://www.autohotkey.com/)
- [Bnetlauncher](https://github.com/dafzor/bnetlauncher)
- [IconsExt](https://www.nirsoft.net/utils/iconsext.html)

These dependencies each use different licensing from Launchpad, and they have their own release cycles, so Launchpad doesn't include them in your initial download.  Don't worry, Launchpad downloads them for you and you won't even notice them.

## Contribute to the Game Launcher DB!
- Public API endpoint: https://benmcclure.com/game-launcher-db/
- GitHub page: https://github.com/bmcclure/game-launcher-db

## Contributing

You can build your own GameLauncher and Game derivative classes and place them within the LauncherLib directory. You can then reference your custom classes in your Launchers.json file.

If you wish to go further, you can download the source code and directly modify or extend the other .ahk files that make up the application.

I would greatly appreciate if you would submit a Pull Request to contribute back any useful additions you make.

## Attribution

Icons made by <a href="https://www.flaticon.com/free-icon/rec_1783406" title="iconixar">iconixar</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>