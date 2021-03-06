/+dub.sdl:
name "test"
dependency "desktopfile" path="../"
dependency "standardpaths" version="~>0.8.0"
+/

import std.stdio;
import std.algorithm;
import std.array;
import std.file;
import std.path;
import std.process;
import std.getopt;

import desktopfile.paths;
import desktopfile.file;
import isfreedesktop;

void main(string[] args)
{
    string[] desktopDirs;

    bool verbose;

    getopt(args, "verbose", "Print name of each examined desktop file to standard output", &verbose);

    if (args.length > 1) {
        desktopDirs = args[1..$];
    } else {
        static if (isFreedesktop) {
            import standardpaths;

            string[] dataPaths = standardPaths(StandardPath.data);

            desktopDirs = applicationsPaths() ~ dataPaths.map!(s => buildPath(s, "desktop-directories")).array ~ dataPaths.map!(s => buildPath(s, "templates")).array ~ standardPaths(StandardPath.startup) ~ writablePath(StandardPath.desktop);
        }

        version(Windows) {
            try {
                auto root = environment.get("SYSTEMDRIVE", "C:");
                auto kdeDir = root ~ `\ProgramData\KDE\share`;
                if (kdeDir.isDir) {
                    desktopDirs = [buildPath(kdeDir, `applications`), buildPath(kdeDir, `desktop-directories`), buildPath(kdeDir, `templates`), buildPath(kdeDir, `autostart`)];
                }
            } catch(Exception e) {

            }
        }
    }

    if (!desktopDirs.length) {
        stderr.writeln("No desktop directories given nor could be detected");
        stderr.writefln("Usage: %s [DIRECTORY]...", args[0]);
        return;
    }

    writefln("Using directories: %-(%s, %)", desktopDirs);

    foreach(dir; desktopDirs.filter!(s => s.exists && s.isDir())) {
        foreach(entry; dir.dirEntries(SpanMode.depth).filter!(a => a.isFile() && (a.extension == ".desktop" || a.extension == ".directory"))) {
            if (verbose) {
                writeln(entry);
            }
            try {
                auto df = new DesktopFile(entry);
                if (!df.execValue().empty) {
                    auto execArgs = df.expandExecValue();
                }
            }
            catch(IniLikeReadException e) {
                stderr.writefln("Error reading %s: at %s: %s", entry, e.lineNumber, e.msg);
            }
            catch(DesktopExecException e) {
                stderr.writefln("Error while expanding Exec value of %s: %s", entry, e.msg);
            }
            catch(Exception e) {
                stderr.writefln("Error reading %s: %s", entry, e.msg);
            }
        }
    }
}
