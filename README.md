# Desktopfile

D library for working with *.desktop* files. Desktop entries in Freedesktop world are akin to shortcuts from Windows world (.lnk files).
The most of desktop environments on Linux and BSD flavors follows [Desktop Entry Specification](http://standards.freedesktop.org/desktop-entry-spec/latest/) today.
The goal of **desktopfile** library is to provide implementation of this specification in D programming language.
Please feel free to propose enchancements or report any related bugs to *Issues* page.

## Platform support

The library is crossplatform for the most part, though there's little sense to use it on systems that don't follow freedesktop specifications.
**desktopfile** is developed and tested on FreeBSD and Debian GNU/Linux.

## Generating documentation

Ddoc:

    dub build --build=docs
    
Ddox:

    dub build --build=ddox

## Running tests

    dub test
    
## Examples

### Desktop util

Utility that can parse and execute .desktop files.
This will start vlc with the first parameter set to ~/Music:

    dub run desktopfile:desktoputil -- exec /usr/share/applications/vlc.desktop ~/Music
    
Starting the command line application should start it in terminal emulator:

    dub run desktopfile:desktoputil -- exec /usr/share/applications/python2.7.desktop
    
Parse and write .desktop file to new location:

    dub run desktopfile:desktoputil -- write /usr/share/applications/vlc.desktop ~/Desktop/vlc.desktop

### Desktop test

Parses all .desktop files in system's applications paths (usually /usr/local/share/applicatons and /usr/share/applications).
Writes errors (if any) to stderr.
Use this example to check if the desktopfile library can parse all .desktop files on your system.

    dub run desktopfile:desktoptest --build=release



