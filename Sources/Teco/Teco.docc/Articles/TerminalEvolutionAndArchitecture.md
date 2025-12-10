# Terminal: Evolution & architecture
Explore the terminal's evolution, its architecture, and how its possible to manipulate it on macOS.

## Overview
Learning the terminal's history and its components will help you understand its core concepts and design decisions. With that foundation, you'll be better equipped to reason about its behavior and leverage the framework's features more effectively.

In this article, you'll learn a gist about them.

## History
Originally, a terminal was a physical device used to interact with a computer through a keyboard and a text-based interface, often displayed on a printer or CRT. These terminals were “dumb” endpoints: they performed no computation themselves and merely sent input to, and displayed output from, a central mainframe or minicomputer.

Because each manufacturer implemented its own features, terminals were often incompatible with one another. Standards bodies such as ANSI and ECMA attempted to unify behavior, and the VT100 family became especially influential due to its wide adoption and early alignment with these standards, effectively setting a de facto baseline for terminal behavior.

As computers became personal, terminals were replaced by software that emulates its features, preserving compatibility with existing applications. On POSIX-derived systems like macOS, terminal capabilities are described through *terminfo databases* (with older systems sometimes using *termcap*), and emulators such as xterm extended the VT100 model and shaped modern conventions.

Today, terminals are primarily tools for developers and system administrators, embedded in low-level and automation workflows despite the dominance of graphical interfaces.

## Line-oriented vs. screen-oriented apps
Terminal emulators gave rise to two main kinds of text-based apps (TUIs): line-oriented and screen-oriented. Line-oriented programs treat the terminal as a simple text stream, processing input and output one line at a time, while screen-oriented ones rely on cursor movement, display control to redraw parts of the screen, and react to individual keystrokes.

## Startup behavior
When a terminal emulator is started, it sets the environment variable `$TERM`, declaring what terminal is being emulated. Software running within its environment can adapt their features based on the information they can find on the terminfo database for that terminal.

It then executes a shell as its child process, which, by default, is `ZSH` on macOS. The shell is responsible for parsing user commands and scripts described in a scripting language, forking into other terminal software available in the system, and causing interactions via *pipelines*.

The shell resolves software by their names by looking them in the directories described in the `$PATH` environment variable and using the first result found.

## Components
### Sessions & Virtual Devices
A terminal session is a logical container that connects a running program to a virtual terminal device provided by the kernel. This device, typically a pseudo-terminal (PTY), presents itself to programs as a TTY, handling input, output, signals, and job control, while the terminal emulator takes its responsability on the other end.

This abstraction lets programs behave as if they are attached to real hardware, even though everything is mediated in software.

### Screen
Each session in a terminal emulator has a screen buffer made of a grid of cells. This grid system is made of columns and rows where the origin, `Coordinate(column: 0, row: 0)`, sits at the top-left corner of the screen. Columns increase as you move to the right, and rows increase as you move downward.

### Cursor
One cell in the screen marks the cursor's position—the spot where new text appears. When the cursor reaches the final column of a row, it automatically moves to the beginning of the next line.

### Standard streams
A process running in the terminal starts with three standard file descriptors, each representing a stream typically connected to the terminal. The C standard library (libc)—which underlies Foundation—provides wrappers around these descriptors, including static buffers that don't exist in the kernel or the terminal itself.

- **Standard input (`stdin`):**\
This stream receives byte sequences that represent input events. Libc provides a buffer that caches these bytes before your program reads them.\
\
The terminal typically operates in *cooked mode*, where it preprocesses input—handling tasks such as line editing, signals, and character translation—before passing data to your program. This differs from *raw mode*, where input is delivered with minimal processing and far closer to what the emulated hardware provides.

- **Standard output (`stdout`):**\
This stream is intended for regular program output. Libc uses a line-buffered mechanism for it, meaning the buffer is automatically flushed whenever a newline is written.

- **Standard error (`stderr`):**\
This stream is reserved for error and diagnostic messages. It's unbuffered, allowing messages to appear immediately without waiting for a flush event.

By default, all three standard streams are connected to the terminal; for the output streams, this precisely means the terminal's screen. These streams can be reassigned through *redirection*, where the invoking process—most often the shell—changes the source or destination of a stream endpoint so that it reads from or writes to another file or process instead of the terminal.

## Manipulation
The terminal and the standard streams can be manipulated via the use of ANSI escape sequences—a series of codes defined by ANSI standards—low-level system APIs, signals, and stream messaging.

Teco gives you access to the ``Terminal`` enum, the main high-level interface you'll use to manipulate the emulated terminal capabilities.
