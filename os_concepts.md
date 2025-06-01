# Operating System Concepts in Bash Banking System

This document outlines the key operating system concepts implemented in our Bash banking system.

## 1. Process Management

- **Background Processing**: Voice announcements run in the background to keep the UI responsive
- **Subshells**: Isolated process environments with `(...)` syntax for voice generation
- **Process IDs**: Unique identifiers for temporary files to prevent conflicts
- **FCFS Scheduling**: First-Come-First-Served algorithm for voice queue management
- **Process Synchronization**: Voice processor ensures sequential processing

## 2. File System Operations

- **File I/O**: Reading/writing for account details, balances, transactions
- **File Permissions**: Setting executable permissions for scripts
- **Temporary Files**: Creating/managing temporary files for voice with proper cleanup
- **Directory Management**: Creating and using directories for voice queue
- **File Locking**: Implicit locking through queue system for voice files

## 3. Interprocess Communication

- **Redirection**: Using `>`, `>>`, `2>&1` for redirecting stdout and stderr
- **Pipes**: Connecting command outputs to inputs for data processing
- **Signals**: Managing user interrupts and program flow
- **File-based IPC**: Voice queue files for communication between processes

## 4. Memory Management

- **Environment Variables**: Shell variables to store and manipulate data
- **Variable Scope**: Local variables in functions to prevent namespace pollution
- **Resource Allocation**: Proper allocation and deallocation of memory
- **Garbage Collection**: Cleanup of temporary files and resources

## 5. Concurrency

- **Asynchronous Execution**: Running voice in parallel with UI
- **Non-blocking I/O**: Ensuring UI remains responsive during voice playback
- **Race Condition Prevention**: Queue system prevents voice announcement overlap
- **Critical Sections**: Protected regions of code that must not execute concurrently

## 6. Resource Management

- **Cleanup Operations**: Removing temporary files to prevent resource leaks
- **Resource Allocation/Deallocation**: Creating and releasing system resources
- **Priority Management**: Voice announcements with priority levels (1-10)
- **Producer-Consumer Model**: Voice queue implementation

## 7. Virtualization

- **Virtual Environments**: Python virtual environments for dependency isolation
- **WSL (Windows Subsystem for Linux)**: Running Linux applications on Windows
- **Process Isolation**: Subshells for isolated execution environments

## 8. System Calls

- **Command Execution**: Using system commands like `mpg123` for audio playback
- **Process Creation**: Spawning Python processes for text-to-speech
- **File Operations**: Opening, reading, writing, and deleting files
- **I/O Operations**: Terminal I/O for user interaction

## 9. User Interface

- **Terminal I/O**: Using whiptail for text-based interfaces
- **Signal Handling**: Managing user interrupts and program flow
- **Character-by-Character Output**: Controlled display of ASCII art loading screen
- **Menu Navigation**: Hierarchical menu system with keyboard input

## 10. Security Concepts

- **Authentication**: Password-based login system
- **Data Protection**: Storing sensitive information in separate files
- **Input Validation**: Checking user inputs for validity before processing
- **Access Control**: Role-based access (user vs. admin)

## 11. Additional Concepts

- **Multiprocessing**: Running voice announcements in parallel with main program
- **Process Coordination**: Voice queue ensures processes work together properly
- **State Management**: Maintaining system state through file-based storage
- **Event-Driven Programming**: System responds to user actions and events
