
# Code Counter

### Recursive source code line counter.

##### Code Counter v.1.1


## Purpose

Count lines of code and comments in source files in C, BASIC, and general web files.

Code Counter will search for files of the specified type in the **directory from which it's called**, and then search recursively in any sub-directories.

Original aim: initiate Code Counter in a project's top-level directory and provide file statistics on the complete project.


## OS Support

+ Linux

    + x32
    + x64 (with 32-bit library support available)

+ Windows


## Usage

        codecounter [option]

*options:*

        -c    process C source files: .c, .cpp, .h

        -b    process BASIC source files: .bas, .bi, .vb

        -w    process general web files: .html, .htm, .css, .php, .inc, .tpl, .js, .sql


## Output

For large projects, pipe Code Counter's file-by-file output to a file for later usage, grepping etc:

        codecounter -c > cc_out.txt


## Build

Install [FreeBASIC](http://www.freebasic.net/forum/viewforum.php?f=1) compiler (fbc).

Ensure GCC is available: `whereis gcc`


### Linux

        make

or full process:

        make && make install


### Windows / Compile Manually

        fbc codecounter.bas -gen gcc -O max


## Other

On both Linux and Windows, it's more convenient for Code Counter to be available from any directory location via the PATH system variable (rather than copying the executable file to the directory where needed).


### Linux

        make install

Or move the *codecounter* executable to a location such as */usr/local/bin* (location must be present in $PATH).

### Windows

[Windows key + Break] > Advanced tab > Environmental Variables button > click Path line > Edit button > Variable value - append at the end of existing line info: *C:\directory\path\to\codecounter.exe\;*


## Credits

Thanks to Richard D. Clark (rdc) for his elegant directory recursion function.


## License

Code Counter is released under the [GPL v.3](https://www.gnu.org/licenses/gpl-3.0.html).
