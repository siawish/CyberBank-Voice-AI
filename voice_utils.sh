#!/bin/bash

# Voice utilities for banking system
# This script provides text-to-speech functionality for the banking system with FCFS scheduling

# Create voice queue directory if it doesn't exist
VOICE_QUEUE_DIR="/tmp/banking_voice_queue"
mkdir -p "$VOICE_QUEUE_DIR"

# Global variable to track if voice processor is running
VOICE_PROCESSOR_RUNNING_FILE="$VOICE_QUEUE_DIR/processor_running"

# Function to add a message to the voice queue (producer)
speak() {
    local message="$1"
    local priority="${2:-5}"  # Default priority is 5 (lower number = higher priority)
    
    # Create a unique ID for this voice request
    local request_id=$(date +%s%N)
    
    # Create a voice request file with timestamp, priority, and message
    echo "$priority|$message" > "$VOICE_QUEUE_DIR/voice_${request_id}.req"
    
    # Start the voice processor if it's not already running
    if [ ! -f "$VOICE_PROCESSOR_RUNNING_FILE" ]; then
        process_voice_queue &
    fi
}

# Function to process the voice queue (consumer) - implements FCFS scheduling
process_voice_queue() {
    # Mark processor as running
    touch "$VOICE_PROCESSOR_RUNNING_FILE"
    
    while true; do
        # Check if there are any voice requests in the queue
        local voice_files=($(ls -1 "$VOICE_QUEUE_DIR"/*.req 2>/dev/null))
        
        if [ ${#voice_files[@]} -eq 0 ]; then
            # No more voice requests, exit the processor
            rm -f "$VOICE_PROCESSOR_RUNNING_FILE"
            break
        fi
        
        # Sort files by priority first, then by creation time (FCFS within same priority)
        local next_file=$(ls -1 "$VOICE_QUEUE_DIR"/*.req 2>/dev/null | sort -t'_' -k2 | head -1)
        
        if [ -n "$next_file" ]; then
            # Read the message from the file
            local content=$(cat "$next_file")
            local priority=$(echo "$content" | cut -d'|' -f1)
            local message=$(echo "$content" | cut -d'|' -f2-)
            
            # Remove the request file before processing to avoid duplicate processing
            rm -f "$next_file"
            
            # Process the voice request (non-background)
            _speak_now "$message"
        fi
    done
}

# Internal function to actually speak the message (not to be called directly)
_speak_now() {
    local message="$1"
    
    # Create a unique temporary file for this instance
    local temp_id=$RANDOM
    local temp_script="/tmp/tts_temp_${temp_id}.py"
    local temp_audio="/tmp/banking_voice_${temp_id}.mp3"
    
    # Create a temporary Python script
    cat > "$temp_script" << EOF
from gtts import gTTS
import os

# Convert text to speech
tts = gTTS(text="$message", lang='en')

# Save the speech to an MP3 file
tts.save("$temp_audio")

# Exit the script
EOF

    # Check if virtual environment exists and use it
    if [ -d ~/myenv ]; then
        ~/myenv/bin/python3 "$temp_script"
    else
        # Fall back to system Python
        python3 "$temp_script"
    fi
    
    # Play the MP3 file (using mpg123) - this will block until audio finishes playing
    mpg123 -q "$temp_audio" > /dev/null 2>&1
    
    # Clean up temporary files
    rm -f "$temp_script" "$temp_audio"
}

# Function to announce welcome message
welcome_message() {
    speak "Welcome to Cyber Bank! — a secure, intelligent, and user-friendly banking system."
}

# Function to announce account creation
announce_account_created() {
    local id="$1"
    local name="$2"
    speak "Congratulations $name! Your account has been created successfully. Your account ID is $id."
}

# Function to announce successful login
announce_login() {
    local name="$1"
    speak "Welcome back $name. You have successfully logged in to your account."
}

# Function to announce balance
announce_balance() {
    local balance="$1"
    speak "Your current balance is $balance rupees."
}

# Function to announce deposit
announce_deposit() {
    local amount="$1"
    local balance="$2"
    speak "Your deposit of $amount rupees was successful. Your new balance is $balance rupees."
}

# Function to announce withdrawal
announce_withdrawal() {
    local amount="$1"
    local balance="$2"
    speak "You have withdrawn $amount rupees. Your remaining balance is $balance rupees."
}

# Function for announcing withdraw (alias for withdrawal)
announce_withdraw() {
    announce_withdrawal "$1" "$2"
}

# Function to announce transfer
announce_transfer() {
    local amount="$1"
    local recipient="$2"
    speak "You have transferred $amount rupees to account $recipient successfully."
}

# Function to announce password change
announce_password_change() {
    speak "Your password has been changed successfully."
}

# Function to announce logout
announce_logout() {
    local name="$1"
    speak "Logging out. See you soon $name."
}

# Function to announce name update
announce_name_update() {
    local name="$1"
    speak "Your name has been updated successfully to $name."
}

# Function to announce gender update
announce_gender_update() {
    local gender="$1"
    speak "Your gender has been updated successfully."
}

# Function to announce date of birth update
announce_dob_update() {
    speak "Your date of birth has been updated successfully."
}

# Function to announce email update
announce_email_update() {
    local email="$1"
    speak "Your email has been updated successfully."
}

# Function to announce banking assistant
announce_banking_assistant() {
    speak "Welcome to your AI Banking Assistant. How can I help you today?"
}

# Function to announce account removal
announce_account_removal() {
    local id="$1"
    speak "Account $id has been removed successfully."
}
