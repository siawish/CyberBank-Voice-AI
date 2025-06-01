#!/bin/bash

# Store your Google Gemini API Key
GEMINI_API_KEY="AIzaSyAfnzW5GyaZeHVnF3pyrUrxXOWlScOZqz8"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    whiptail --msgbox "Error: 'jq' is required but not installed. Install with: sudo apt install jq" 10 60
    exit 1
fi

# Get the current user ID from the main banking script
# This uses the environment variable set by test1.sh when launching the Banking Assistant
get_current_user_id() {
    # First check if the environment variable is set
    if [[ -n "$CURRENT_USER_ID" ]]; then
        echo "$CURRENT_USER_ID"
        return
    fi
    
    # Fallback: Look for the most recently modified user detail file
    local most_recent_file=$(ls -t [0-9]*detail 2>/dev/null | head -1)
    if [[ -n "$most_recent_file" ]]; then
        echo "${most_recent_file%detail}"
    else
        echo ""
    fi
}

# Source the voice_utils.sh script to use speak function
source ./voice_utils.sh 2>/dev/null

# Execute banking operations based on AI commands
execute_banking_command() {
    local command=$1
    local user_id=$2
    local result="Command not recognized. Please try again."
    local voice_message=""
    
    # Parse the command format: OPERATION:param1:param2...
    IFS=':' read -r operation param1 param2 <<< "$command"
    
    case "$operation" in
        "CHECK_BALANCE")
            if [[ -f "${user_id}balance" ]]; then
                local balance=$(cat "${user_id}balance")
                result="Your current balance is $balance rupees."
                voice_message="Your current balance is $balance rupees."
            else
                result="Could not retrieve balance information."
                voice_message="Sorry, I could not retrieve your balance information."
            fi
            ;;
            
        "VIEW_TRANSACTIONS")
            if [[ -f "${user_id}pashbook" ]]; then
                local count=${param1:-5}  # Default to 5 transactions if not specified
                local transactions=$(tail -n "$count" "${user_id}pashbook")
                result="Your recent transactions:\n$transactions"
                voice_message="Here are your recent transactions."
            else
                result="No transaction history found."
                voice_message="Sorry, I could not find any transaction history."
            fi
            ;;
            
        "TRANSFER")
            # Perform actual transfer operation
            local amount=$param1
            local recipient=$param2
            
            if [[ -z "$amount" || -z "$recipient" ]]; then
                result="Transfer failed: Missing amount or recipient."
                voice_message="Transfer failed. Missing amount or recipient information."
            elif ! [[ "$amount" =~ ^[0-9]+$ ]]; then
                result="Transfer failed: Amount must be a number."
                voice_message="Transfer failed. The amount must be a number."
            elif ! [[ -f "${recipient}detail" ]]; then
                result="Transfer failed: Recipient account not found."
                voice_message="Transfer failed. Recipient account not found."
            else
                local balance=$(cat "${user_id}balance")
                if (( balance < amount )); then
                    result="Transfer failed: Insufficient funds. Your balance is $balance rupees."
                    voice_message="Transfer failed. You have insufficient funds."
                else
                    # Perform the actual transfer
                    # Get current timestamp for transaction record
                    local now=$(date +"%d-%m-%Y %H:%M:%S")
                    
                    # Update sender's balance
                    local new_sender_balance=$((balance - amount))
                    echo $new_sender_balance > "${user_id}balance"
                    
                    # Update sender's passbook
                    local sender_passbook_entry="$now|Transferred to $recipient|$amount|$new_sender_balance+"
                    echo $sender_passbook_entry >> "${user_id}pashbook"
                    
                    # Update recipient's balance
                    local recipient_balance=$(cat "${recipient}balance")
                    local new_recipient_balance=$((recipient_balance + amount))
                    echo $new_recipient_balance > "${recipient}balance"
                    
                    # Update recipient's passbook
                    local recipient_passbook_entry="$now|Received from $user_id|$amount|$new_recipient_balance+"
                    echo $recipient_passbook_entry >> "${recipient}pashbook"
                    
                    # Get recipient's name for the message
                    local recipient_name=$(cat "${recipient}detail" | cut -f2 -d"|" || echo "account $recipient")
                    
                    result="Transfer successful! You have transferred $amount rupees to $recipient_name. Your new balance is $new_sender_balance rupees."
                    voice_message="Transfer successful! You have transferred $amount rupees to $recipient_name."
                fi
            fi
            ;;
            
        *)
            result="Command not recognized: $operation. Please try a valid command."
            voice_message="Sorry, I didn't understand that command."
            ;;
    esac
    
    # Voice announcement is now handled before this function is called
    # to ensure parallel execution of voice and screen display
    
    echo "$result"
}

# Banking Assistant Function with User Data Integration
ask_gemini() {
    # Get current user ID
    local user_id=$(get_current_user_id)
    local user_data=""
    
    # Extract user data if we have a valid user ID
    if [[ -n "$user_id" && -f "${user_id}detail" && -f "${user_id}balance" ]]; then
        local name=$(cat "${user_id}detail" | cut -f2 -d"|" || echo "Unknown")
        local balance=$(cat "${user_id}balance" || echo "Unknown")
        
        # Get recent transactions (last 5)
        local transactions=""
        if [[ -f "${user_id}pashbook" ]]; then
            transactions=$(tail -n 5 "${user_id}pashbook" || echo "No recent transactions")
        else
            transactions="No transaction history available"
        fi
        
        # Format user data for the prompt
        user_data="
USER DATA:
- Name: $name
- Account ID: $user_id
- Current Balance: $balance rupees
- Recent Transactions:
$transactions
"
    else
        user_data="No user data available. You may need to log in first."
    fi
    
    dialog_content="Welcome to Banking Assistant! Ask your banking-related questions or request banking operations below:\n"

    # Enhanced system prompt with user data and banking capabilities
    app_training="You are a Banking System Assistant for a Bash Banking App. 

$user_data

CAPABILITIES:
You can help with the following banking operations:
1. Check balance - respond with command: CHECK_BALANCE
2. View recent transactions - respond with command: VIEW_TRANSACTIONS:number_of_transactions
3. Transfer money - respond with command: TRANSFER:amount:recipient_id

ACCOUNT LIMITS:
The account has a 50,000 rupees limit for all operations, including:
- Maximum balance: 50,000 rupees
- Maximum transfer amount: 50,000 rupees
- Maximum deposit amount: 50,000 rupees
- Maximum withdrawal amount: 50,000 rupees
Always inform users about this limit when relevant to their query.

When the user requests one of these operations, respond with EXACTLY the command format shown above.
For example, if they ask 'What's my balance?', respond with 'CHECK_BALANCE'.
If they ask to transfer money, verify they have sufficient funds first and check that the amount doesn't exceed the 50,000 rupees limit.

For other banking features, provide information about:
- Account management (opening accounts, password changes)
- Profile editing (name, gender, DOB, email updates)
- General banking advice and information

STYLE INSTRUCTIONS:
1. Keep responses brief and concise - use 1-3 short sentences when possible
2. Use casual, conversational language like a human bank teller would
3. Avoid lengthy explanations unless specifically requested
4. Use simple words and avoid technical jargon
5. Be direct and to the point - don't be overly formal
6. Respond in a friendly, helpful tone
7. For instructions, use bullet points instead of paragraphs
8. Use contractions (don't, can't, you'll) to sound more natural"

    while true; do
        USER_INPUT=$(whiptail --inputbox "$dialog_content" 15 80 --title "Banking Assistant" 3>&1 1>&2 2>&3)

        if [ $? -ne 0 ] || [ -z "$USER_INPUT" ]; then
            whiptail --msgbox "👋 Exiting Banking Assistant." 10 60
            break
        fi

        # Merge training + question
        full_prompt="$app_training\n\nUser Question: $USER_INPUT"

        json_payload=$(jq -n --arg txt "$full_prompt" '{
            contents: [{ parts: [{ text: $txt }] }]
        }')

        response=$(curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$GEMINI_API_KEY" \
            -H "Content-Type: application/json" \
            -X POST \
            -d "$json_payload")

        parsed_response=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')

        if [[ "$parsed_response" == "null" || -z "$parsed_response" ]]; then
            dialog_content+="You: $USER_INPUT\n\n❌ Error: Empty response from Gemini. Please try again.\n"
        else
            # Check if the response contains a banking command
            if [[ "$parsed_response" =~ ^(CHECK_BALANCE|VIEW_TRANSACTIONS|TRANSFER) ]]; then
                # Start voice announcement in background before showing the result
                # Parse the command to get the operation and parameters
                IFS=':' read -r operation param1 param2 <<< "$parsed_response"
                
                # Prepare voice message based on operation
                local voice_message=""
                case "$operation" in
                    "CHECK_BALANCE")
                        if [[ -f "${user_id}balance" ]]; then
                            local balance=$(cat "${user_id}balance")
                            voice_message="Your current balance is $balance rupees."
                        else
                            voice_message="Sorry, I could not retrieve your balance information."
                        fi
                        ;;
                    "VIEW_TRANSACTIONS")
                        voice_message="Here are your recent transactions."
                        ;;
                    "TRANSFER")
                        local amount=$param1
                        local recipient=$param2
                        local balance=$(cat "${user_id}balance" 2>/dev/null || echo "0")
                        
                        if [[ -z "$amount" || -z "$recipient" ]]; then
                            voice_message="Transfer failed. Missing information."
                        elif ! [[ -f "${recipient}detail" ]]; then
                            voice_message="Transfer failed. Recipient not found."
                        elif (( balance < amount )); then
                            voice_message="Transfer failed. Insufficient funds."
                        else
                            # Get recipient's name for the message
                            local recipient_name=$(cat "${recipient}detail" | cut -f2 -d"|" || echo "account $recipient")
                            voice_message="Processing transfer of $amount rupees to $recipient_name."
                        fi
                        ;;
                esac
                
                # Start voice announcement in background
                if type speak >/dev/null 2>&1 && [[ -n "$voice_message" ]]; then
                    speak "$voice_message" &
                fi
                
                # Execute the banking command and update dialog
                command_result=$(execute_banking_command "$parsed_response" "$user_id")
                dialog_content+="You: $USER_INPUT\n\n💬 Banking Assistant: $command_result\n"
            else
                # For regular responses, just update the dialog
                dialog_content+="You: $USER_INPUT\n\n💬 Banking Assistant: $parsed_response\n"
                
                # Optionally speak the response for non-command queries too
                if type speak >/dev/null 2>&1; then
                    # Extract a shorter version of the response for voice (first sentence or two)
                    local short_response=$(echo "$parsed_response" | sed 's/\. /\n/g' | head -n 2 | tr '\n' ' ')
                    speak "$short_response" &
                fi
            fi
        fi

        # Count the number of lines in the dialog content to ensure we're always showing the latest messages
        line_count=$(echo -e "$dialog_content" | wc -l)
        
        # If we have more than 15 lines, we need to scroll to show the latest messages
        # The --fb option forces the display to start at the bottom of the text
        if [ $line_count -gt 15 ]; then
            whiptail --scrolltext --fb --title "Banking Assistant" --msgbox "$dialog_content" 20 80
        else
            whiptail --scrolltext --title "Banking Assistant" --msgbox "$dialog_content" 20 80
        fi
    done
}

# Start the Enhanced Banking Assistant
ask_gemini
