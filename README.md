# Bash Banking System with Voice Integration

## Project Overview

This project is a comprehensive banking system implemented in Bash with integrated voice announcements. The system provides a text-based user interface for banking operations while simultaneously delivering voice feedback for key actions, creating an accessible and interactive banking experience.

## Account Limits

The system enforces a maximum limit of 50,000 rupees for all banking operations:
- Maximum account balance: 50,000 rupees
- Maximum single deposit: 50,000 rupees
- Maximum single withdrawal: 50,000 rupees
- Maximum transfer amount: 50,000 rupees

## Features

- **Account Management**
  - Account creation with validation
  - Secure login system
  - Profile viewing and editing
  - Password management
  
- **Banking Operations**
  - Deposit funds
  - Withdraw funds
  - Transfer between accounts
  - Balance inquiry
  - Transaction history (Passbook)
  
- **Voice Integration**
  - Text-to-speech announcements for key actions
  - Voice queue using FCFS (First-Come-First-Served) scheduling to prevent overlapping announcements
  - Priority-based voice messages (higher priority messages played first)
  - Contextual voice prompts with personalized information
  
- **Admin Functions**
  - View all users
  - Search for specific users
  - Remove accounts
  
- **Banking Assistant**
  - AI-powered chatbot using Google Gemini API
  - Conversational assistance for banking queries
  - Banking operation execution through natural language
  - Integration with account data (balance, transactions)
  - Awareness of banking limits (50,000 rupees maximum)

## System Architecture

The system consists of several key components:

1. **Main Banking Script (`test1.sh`)**: Core banking functionality and user interface with stylish ASCII art loading screen
2. **Voice Utilities (`voice_utils.sh`)**: Text-to-speech functionality with queue management
3. **Chatbot Integration (`chat_gpt.sh`)**: AI assistant using Google Gemini API with banking business logic
4. **Launcher Script (`run_banking.sh`)**: Environment setup and dependency management

## Technical Requirements

- Bash shell environment (Linux/WSL)
- Python 3.x with pip
- Required Python packages:
  - `gtts` (Google Text-to-Speech)
- Required system packages:
  - `whiptail` (for UI elements)
  - `mpg123` (for audio playback)
  - `jq` (for JSON parsing in chatbot)

## User Interface

- **Loading Screen**: Character-by-character animated white ASCII art logo for Cyber Bank that appears on startup
  - Displays each character individually for a typewriter effect
  - Uses white bold text for better visibility
  - Centered on screen with appropriate spacing
  - Welcome voice announcement plays during logo display

- **Menu System**: Whiptail-based menus with improved spacing and readability
  - Added spacing between menu headings and options for better visual hierarchy
  - Consistent formatting across all menus (main menu, user dashboard, admin panel)

- **Voice Feedback**: Synchronized voice announcements that don't overlap
  - Voice messages play in the background while UI remains responsive
  - Queue system ensures announcements complete before starting the next one

- **Chatbot Interface**: Natural language interface for banking operations
  - Conversational interface with brief, human-like responses
  - Banking command execution through natural language requests

- **Messaging System**: Communication between users and admin
  - Users can send messages to admin
  - Admin can view and respond to user messages

## Voice Queue System

The voice announcement system uses a sophisticated FCFS (First-Come-First-Served) scheduling algorithm:

1. **Queue Directory**: Voice requests are stored as files in `/tmp/banking_voice_queue/`
2. **Priority Levels**: Each voice message has a priority level (1-10, with 1 being highest)
3. **Producer-Consumer Model**:
   - Producer: The `speak()` function adds messages to the queue
   - Consumer: The background processor plays messages in priority order
4. **File-based Synchronization**: Prevents overlapping announcements and race conditions
5. **Clean Resource Management**: Temporary files are automatically removed after processing

## Operating System Concepts Implementation

This project demonstrates several important operating system concepts:

### 1. Process Management

- **Background Processing**: Voice announcements run in the background using the `&` operator, allowing the banking interface to remain responsive.
  ```bash
  # Implementation in voice_utils.sh
  (
      # TTS processing code
      # ...
  ) &
  ```

- **Subshells**: Isolated process environments created using `(...)` syntax for voice generation, ensuring clean process separation.
  ```bash
  # Implementation in voice_utils.sh
  (
      # Create a unique temporary file for this instance
      local temp_id=$RANDOM
      # ...
  ) &
  ```

- **Process IDs**: Using $RANDOM to create unique identifiers for temporary files, preventing conflicts when multiple voice processes run simultaneously.
  ```bash
  # Implementation in voice_utils.sh
  local temp_id=$RANDOM
  local temp_script="/tmp/tts_temp_${temp_id}.py"
  local temp_audio="/tmp/banking_voice_${temp_id}.mp3"
  ```

### 2. File System Operations

- **File I/O**: Reading and writing to files for storing account details, balances, and transaction records.
  ```bash
  # Implementation in test1.sh
  echo $balance > $1"balance"  # Writing to a file
  balance=`cat $1"balance"`    # Reading from a file
  ```

- **File Permissions**: Setting executable permissions for scripts to ensure they can be run directly.
  ```bash
  # Implementation in run_banking.sh
  chmod +x test1.sh
  chmod +x voice_utils.sh
  chmod +x chat_gpt.sh
  ```

- **Temporary Files**: Creating and managing temporary files for voice generation, with proper cleanup.
  ```bash
  # Implementation in voice_utils.sh
  local temp_script="/tmp/tts_temp_${temp_id}.py"
  # ...
  # Clean up temporary files
  rm -f "$temp_script" "$temp_audio"
  ```

### 3. Interprocess Communication

- **Redirection**: Using `>`, `>>`, `2>&1` for redirecting standard output and errors.
  ```bash
  # Implementation in test1.sh
  option=$(whiptail --title "Banking Solution" --menu "Choose Your Option" 15 60 4 \ 
           "1" "Open Account" \ "2" "User Login" \ "3" "Admin Login" \ 
           "4" "Credit" \ "5" "Banking Assistant" --ok-button "Select" --cancel-button "Exit" 3>&1 1>&2 2>&3)
  ```

- **Pipes**: Connecting command outputs to inputs for data processing.
  ```bash
  # Implementation in test1.sh
  name=`cat $id"detail" | cut -f2 -d"|"`
  ```

### 4. Memory Management

- **Environment Variables**: Using shell variables to store and manipulate data throughout the application.
  ```bash
  # Implementation in test1.sh
  balance=0
  echo $balance > $1"balance"
  ```

- **Variable Scope**: Using local variables in functions to prevent namespace pollution.
  ```bash
  # Implementation in voice_utils.sh
  speak() {
      local message="$1"
      # ...
  }
  ```

### 5. Concurrency

- **Asynchronous Execution**: Running voice announcements concurrently with the UI, allowing users to interact with the system while voice plays.
  ```bash
  # Implementation in voice_utils.sh
  speak() {
      # ...
      (
          # TTS processing code
      ) &  # Run in background
  }
  ```

- **Non-blocking I/O**: Ensuring the UI remains responsive while voice plays by using background processes.
  ```bash
  # Implementation in test1.sh
  # After successful login
  if command -v announce_login >/dev/null 2>&1; then
      announce_login "$name"  # This runs in background
  fi
  # UI continues immediately without waiting
  ```

### 6. Resource Management

- **Cleanup Operations**: Removing temporary files after use to prevent resource leaks.
  ```bash
  # Implementation in voice_utils.sh
  # Clean up temporary files
  rm -f "$temp_script" "$temp_audio"
  ```

- **Resource Allocation**: Creating and releasing system resources properly.
  ```bash
  # Implementation in test1.sh
  # When removing an account
  rm -f $userId"detail"
  rm -f $userId"balance"
  rm -f $userId"pashbook"
  ```

### 7. Virtualization

- **Virtual Environments**: Using Python virtual environments for dependency isolation.
  ```bash
  # Implementation in run_banking.sh
  # Activate virtual environment if it exists
  if [ -d ~/myenv ]; then
      source ~/myenv/bin/activate
      pip install gtts
  fi
  ```

- **WSL (Windows Subsystem for Linux)**: Running Linux applications on Windows, allowing for cross-platform compatibility.
  ```bash
  # The entire project runs on WSL, as indicated by file paths:
  # \\wsl.localhost\kali-linux\home\kali_linux\banking\
  ```

### 8. System Calls

- **Command Execution**: Using system commands like `mpg123` for audio playback.
  ```bash
  # Implementation in voice_utils.sh
  # Play the MP3 file (using mpg123)
  mpg123 -q "$temp_audio" > /dev/null 2>&1
  ```

- **Process Creation**: Spawning Python processes for text-to-speech conversion.
  ```bash
  # Implementation in voice_utils.sh
  if [ -d ~/myenv ]; then
      ~/myenv/bin/python3 "$temp_script"
  else
      # Fall back to system Python
      python3 "$temp_script"
  fi
  ```

### 9. User Interface

- **Terminal I/O**: Using whiptail for creating text-based user interfaces.
  ```bash
  # Implementation in test1.sh
  whiptail --title "Banking Solution" --menu "Choose Your Option" 15 60 4 \
           "1" "Open Account" \ "2" "User Login" \ "3" "Admin Login" \
           "4" "Credit" \ "5" "Banking Assistant" --ok-button "Select" --cancel-button "Exit" 3>&1 1>&2 2>&3
  ```

- **Signal Handling**: Managing user interrupts and program flow.
  ```bash
  # Implementation in test1.sh
  exitstatus=$?
  if [ $exitstatus -eq 0 ]
  then
      # Process user selection
  fi
  ```

### 10. Security Concepts

- **Authentication**: Implementing password-based login system.
  ```bash
  # Implementation in test1.sh
  if [ "$password" = "$userPassword" ]
  then
      # Grant access
  else
      whiptail --title "Something Went Wrong" --msgbox "Invalid Password" 8 50
  fi
  ```

- **Data Protection**: Storing sensitive information in separate files.
  ```bash
  # Implementation in test1.sh
  # Separate files for different data
  touch $1"detail"    # Personal information
  touch $1"balance"   # Balance information
  touch $1"pashbook"  # Transaction history
  ```

### 11. Multiprocessing

- **Parallel Execution**: Running voice announcements in parallel with the main program.
  ```bash
  # Implementation in voice_utils.sh
  speak() {
      # ...
      (
          # TTS processing code
      ) &  # Run in background
  }
  ```

- **Process Independence**: Ensuring voice processes continue even if parent processes complete.
  ```bash
  # Implementation in voice_utils.sh
  # By using subshells with &, voice processes continue independently
  (
      # TTS processing code
  ) &
  ```

## State Management

The system maintains state through file-based storage:
- Account details stored in `<id>detail` files
- Account balances stored in `<id>balance` files
- Transaction history stored in `<id>pashbook` files

## Voice Integration Details

Voice announcements are implemented using:
- Google Text-to-Speech (gTTS) for converting text to speech
- mpg123 for audio playback
- Asynchronous processing to ensure non-blocking operation

Voice announcements occur at key interaction points:
- Welcome message on main menu display
- Account creation confirmation
- Successful login greeting
- Balance inquiry
- Deposit, withdrawal, and transfer confirmations
- Password change confirmation
- Profile updates
- Logout message

## Setup and Run

1. Ensure you have all requirements installed:
   - Bash shell environment (Linux/WSL)
   - Python 3.x with pip
   - Required Python packages: `gtts` (Google Text-to-Speech)
   - Required system packages: `whiptail`, `mpg123`, `jq`

2. Run the setup script to handle dependencies automatically:
   ```bash
   bash run_banking.sh
   ```
   This will:
   - Create and activate a Python virtual environment (if not exists)
   - Install required Python packages
   - Make scripts executable
   - Launch the banking system

3. Or run the main script directly if dependencies are already installed:
   ```bash
   bash test1.sh
   ```

## Usage Guide

### Basic Operations

1. **Opening an Account**:
   - Select "Open Account" from the main menu
   - Follow the prompts to enter personal details
   - Your account ID will be generated automatically

2. **Logging In**:
   - Select "User Login" from the main menu
   - Enter your account ID and password
   - Navigate through the user dashboard for various operations

3. **Using the Banking Assistant**:
   - Log in to your account
   - Select "Banking Assistant" from the user dashboard
   - Type natural language queries like "What's my balance?" or "Transfer 500 rupees to account 1002"

## AI Banking Assistant Details

The Banking Assistant integrates Google's Gemini AI API with your personal banking data:

- **Contextual Information**: Provides the AI with your name, account ID, balance, and recent transactions
- **Banking Operations**: Executes CHECK_BALANCE, VIEW_TRANSACTIONS, and TRANSFER commands through natural language
- **Conversation Style**: Uses brief, conversational language with a friendly tone
- **Security**: Banking commands are validated server-side before execution
- **Account Limits**: AI is aware of and enforces the 50,000 rupees account limits

## Future Enhancements

- Multi-language support
- Voice input capabilities
- Enhanced security features
- Database integration for persistent storage
- Web interface
- Mobile app integration

## Conclusion

This Bash Banking System demonstrates the practical application of numerous operating system concepts in a real-world application. By integrating voice capabilities with traditional text-based interfaces, it showcases how different OS features can be combined to create an accessible and user-friendly banking experience.
