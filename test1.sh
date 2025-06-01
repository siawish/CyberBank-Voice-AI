#!/bin/bash
#---------------------- Color Code / Fontstyle -------------------------------
white="\e[97m"
cyan="\e[96m"
magenta="\e[95m"
blue="\e[94m"
yellow="\e[93m"
green="\e[92m"
red="\e[91m"
grey="\e[37m"
default="\e[39m"
bold="\e[1m"
normal="\e[0m"
blink="\e[5m"
#-----------------------------------------------------------------------------

# Source the voice utilities
if [ -f "./voice_utils.sh" ]; then
    source ./voice_utils.sh
fi

# Display loading screen with Cyber Bank ASCII art
display_loading_screen() {
    clear
    
    # Play welcome message at startup
    if command -v welcome_message >/dev/null 2>&1; then
        welcome_message
    fi
    
    # Add spacing at the top
    echo -e "\n\n\n\n\n\n"
    
    # ASCII art lines
    local lines=(
        "		   █████████             █████      ████████               █████                          █████     "
        "		  ███░░░░░███           ░░███      ███░░░░███             ░░███                          ░░███      "
        "		 ███     ░░░  █████ ████ ░███████ ░░░    ░███ ████████     ░███████   ██████   ████████   ░███ █████"
        "		░███         ░░███ ░███  ░███░░███   ██████░ ░░███░░███    ░███░░███ ░░░░░███ ░░███░░███  ░███░░███ "
        "		░███          ░███ ░███  ░███ ░███  ░░░░░░███ ░███ ░░░     ░███ ░███  ███████  ░███ ░███  ░██████░  "
        "		░░███     ███ ░███ ░███  ░███ ░███ ███   ░███ ░███         ░███ ░███ ███░░███  ░███ ░███  ░███░░███ "
        "		 ░░█████████  ░░███████  ████████ ░░████████  █████        ████████ ░░████████ ████ █████ ████ █████"
        "		  ░░░░░░░░░    ░░░░░███ ░░░░░░░░   ░░░░░░░░  ░░░░░        ░░░░░░░░   ░░░░░░░░ ░░░░ ░░░░░ ░░░░ ░░░░░ "
        "		               ███ ░███                                                                             "
        "		              ░░██████                                                                              "
        "		               ░░░░░░                                                                               "
    )
    
    # Print each line character by character
    echo -e "${white}${bold}"
    for line in "${lines[@]}"; do
        for (( i=0; i<${#line}; i++ )); do
            echo -n "${line:$i:1}"
            sleep 0.001  # Very small delay for smooth appearance
        done
        echo  # New line after each line is complete
    done
    echo -e "${normal}${default}"
    
    # Small pause before showing the main menu
    sleep 1
    clear
}

# Run the loading screen at startup
display_loading_screen

# Function to speak if voice utils are available
say() {
    if command -v speak >/dev/null 2>&1; then
        speak "$1"
    fi
}
createAccount()
{
	#---------------------------- Creating An Account -------------------------
	touch $1"detail"
	touch $1"balance"
	touch $1"pashbook"
	#==================
	#Creating three file one for detail record 
	#one for balance record and 
	#one for pashbook detail 
	#==================
	#---------------------------- Entry In Balance ---------------------------
	balance=0
	echo $balance > $1"balance"
	#---------------------------- Entry In detail ----------------------------
	id=$1
	name=$2
	gender=$3
	year=$4
	month=$5
	day=$6
	email=$7
	password=$8
	#---------------------------- Entry Of User Detail -----------------------
	fulldetail="$id|$name|$gender|$year|$month|$day|$email|$password"
	echo $fulldetail >> $1"detail"
	newUser="ID:$id|$name|$gender|$year|$month|$day|$email|$password+"
	echo $newUser >> "user"
	#---------------------------- Entery Of Pashbook --------------------------
	now=$(date +"%m-%d-%Y")
	msg="$now|Created Account|0|0+" 
	echo $msg >> $1"pashbook"
}
OpenAccount ()
{
	if (whiptail  --title "Confirmation" --yesno "Are You Sure You Want To Open An Account !" --clear 10 60 )
	then
	#--------------------------------------------- Add User Name ---------------------------------------------
	while [ 1 -eq 1 ]
	do
		exp='^[a-zA-Z ]+$'
		noexp='^[0-9]+$'
		newname=$(whiptail --title "Banking Solution Open Account" --inputbox "Enter Your Name"  --nocancel --clear 10 60 3>&1 1>&2 2>&3)
		#--------------------- Name Validation -------------
		if [[ $newname =~ $exp ]] && [[ $newname == *[a-zA-Z]* ]] && [[ $newname != *[0-9]* ]]
		then
			break
		else
			#--------- 
			whiptail --title "Something Went Wrong" --msgbox "Invalid Name Format ....." 10 60
		fi
	done
	#---------------------------------------------------------------------------------------------------------
	#--------------------------------------------- Add Gender ------------------------------------------------
	newgender=$(whiptail --title "Banking Solution Open Account" --menu "Select Your Gender" --nocancel --clear 15 60 4 \ "Male" "" \ "Female" "" 3>&1 1>&2 2>&3)	
		#--------- Patch Work ---------
		if [[ $newgender == *[' ']* ]]
		then
			newgender=${newgender//[[:blank:]]/}
		fi
		#------------------------------
	#---------------------------------------------------------------------------------------------------------
	#--------------------------------------------- Add Date Of Birth -----------------------------------------
	validyear=`date +"%Y"`
	startyear=$(($validyear-100))
	while [ 1 ]
	do
		noexp='^[0-9]+$'
		newyear=$(whiptail --title "Banking Solution Open Account" --inputbox "Select Date Of Birth (Year IN YYYY)" 10 78 --nocancel --clear 3>&1 1>&2 2>&3)
		if [ $newyear -ge $startyear ] && [ $newyear -lt $validyear ] && [[ $newyear =~ $noexp ]]
		then
			break
		else
			whiptail --title "Something Went Wrong" --msgbox "Invalid Year Format / Year Must Be In Range $startyear - $validyear" 10 80
		fi
	done
	while [ 1 ]
	do
		noexp='^[0-9]+$'
		newmonth=$(whiptail --title "Banking Solution Open Account" --inputbox "Select Date Of Birth (Month IN MM)" 10 78 --nocancel --clear 3>&1 1>&2 2>&3)
		if [ $newmonth -ge 1 ] && [ $newmonth -le 12 ]	&& [[ $newmonth =~ $noexp ]]
		then
			break
		else
			whiptail --title "Something Went Wrong" --msgbox "Invalid Month Format / Year Must Be In Range 1 - 12" 10 80
		fi
	done
	while [ 1 ]
	do
		noexp='^[0-9]+$'
		newday=$(whiptail --title "Banking Solution Open Account" --inputbox "Select Date Of Birth (Year IN DD)" 10 78 --nocancel --clear 3>&1 1>&2 2>&3)
		if [ $newday -ge 1 ] && [ $newday -lt 31 ] && [[ $newday =~ $noexp ]]
		then
			break
		else
			whiptail --title "Something Went Wrong" --msgbox "Invalid Day Format / Day Must Be In Range 1 - 31" 10 80
		fi
	done
	#---------------------------------------------------------------------------------------------------------
	#--------------------------------------------- Add Email -------------------------------------------------
	while [ 1 -eq 1 ]
	do
		newemail=$(whiptail --title "Re-enter Your Email" --inputbox "Enter Your Email ID " --nocancel --clear 10 60 3>&1 1>&2 2>&3)
		exitstatus=$?

		#--------------------- Eamil Validation -------------
		if [[ $newemail == *[@]* ]] && [[ $newemail == *[a-zA-z]* ]]
		then
			break
		else
			whiptail --title "Something Went Wrong" --msgbox "Invalid Email Format ..." 10 60
		fi
	done
	#---------------------------------------------------------------------------------------------------------
	#--------------------------------------------- Add Password ----------------------------------------------
	while [ 1 -eq 1 ]
	do
		password=$(whiptail --title "Banking Solution Open Account" --passwordbox "Enter Your Password : " --nocancel --clear 10 50  3>&1 1>&2 2>&3)
		if [ ${#password} -ge 8 ]
		then
			confpassword=$(whiptail --title "Banking Solution Open Account" --passwordbox "Re-enter The Password : " --nocancel --clear 10 50  3>&1 1>&2 2>&3)
			if [ "$password" = "$confpassword" ]
			then
				break
			else
				whiptail --title "Something Went Wrong" --msgbox "Invalid Confirmation Password ..." 10 60
			fi
		else
			whiptail --title "Something Went Wrong" --msgbox "Password Length Must Be Greater Than 8 Characters ..." 10 60
		fi
	done
	#---------------------------------------------------------------------------------------------------------
	if [ -s "idGenerate" ]
	then
		if (whiptail  --title "Confirmation" --yesno "Enter Yes To Confirm...." --clear 10 60 )
		then
			id=`cat idGenerate`
			id=$(( $id+1 ))
			createAccount $id "$newname" $newgender $newyear $newmonth $newday $newemail $password
			whiptail --title "Account Created" --msgbox "$newname Your Account Created Your ID $id" 8 80
			echo $id > "idGenerate"
		fi
	else
		reset
		echo -e "${red}Status - File Not Present.. System Fault${default}"
		sleep 5
	fi
	#---------------------------------------------------------------------------------------------------------
	else
		whiptail --title "Info" --msgbox "Back To Main Menu" 10 60
	fi
}
changePassword()
{
	#-------------------- Get Records ---------------------
	id=`cat $1"detail" | cut -f1 -d'|'`
	name=`cat $1"detail" | cut -f2 -d'|'`
	gender=`cat $1"detail" | cut -f3 -d'|'`
	year=`cat $1"detail" | cut -f4 -d'|'`
	month=`cat $1"detail" | cut -f5 -d'|'`
	day=`cat $1"detail" | cut -f6 -d'|'`
	email=`cat $1"detail" | cut -f7 -d'|'`
	password=`cat $1"detail" | cut -f8 -d'|'`
	#------------------------------------------------------
	oldPassword=$(whiptail --title "Change Your Password" --passwordbox "Enter Your Old Password : " 10 50  3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus -eq 0 ]
	then
		newPassword=$(whiptail --title "Change Your Password" --passwordbox "Enter Your New Password : " 10 50  3>&1 1>&2 2>&3)
		exitstatus=$?
		if [ $exitstatus -eq 0 ]
		then
			confPassword=$(whiptail --title "Change Your Password" --passwordbox "Conf Password : " 10 50  3>&1 1>&2 2>&3)
			exitstatus=$?
			if [ $exitstatus -eq 0 ]
			then
				if [ "$oldPassword" = "$password" ] && [ "$newPassword" = "$confPassword" ]
				then
					if (whiptail --title "Confirmation" --yesno "Are You Sure You Want To Change The Password !" 8 60)
					then
						userdetail="$id|$name|$gender|$year|$month|$day|$email|$newPassword"
						echo $userdetail > $1"detail"
						whiptail --title "Confirmation" --msgbox "Your Password Changed Successfully ...." 8 50
						# Announce password change with voice
						if command -v announce_password_change >/dev/null 2>&1; then
							announce_password_change
						fi
					fi
				else
					whiptail --title "Confirmation" --msgbox "Failed To Change Your Password ...." 8 50
				fi
			else
				#---- Do Nothing ----
				whiptail --title "Info" --msgbox "Your Action Has Been Canceled ...." 8 50
			fi
		else
			#---- Do Nothing ----
			whiptail --title "Info" --msgbox "Your Action Has Been Canceled ...." 8 50
		fi
	else
		#---- Do Nothing ----
		whiptail --title "Info" --msgbox "Your Action Has Been Canceled ...." 8 50
	fi
}
display()
{
	id=`cat $1"detail" | cut -f1 -d'|'`
	name=`cat $1"detail" | cut -f2 -d'|'`
	gender=`cat $1"detail" | cut -f3 -d'|'`
	year=`cat $1"detail" | cut -f4 -d'|'`
	month=`cat $1"detail" | cut -f5 -d'|'`
	day=`cat $1"detail" | cut -f6 -d'|'`
	email=`cat $1"detail" | cut -f7 -d'|'`
	balance=`cat $1"balance"`
	echo -e "\t\t\t\t${yellow}|---------------------------------------------------------|${default}"
	echo -e "\t\t\t\t${green}  Account ID${cyan}       $id"
	echo -e "\t\t\t\t${green}  Name${cyan}             $name"
	echo -e "\t\t\t\t${green}  gender${cyan}           $gender"
	echo -e "\t\t\t\t${green}  Date Of Birth${cyan}    $day-$month-$year"
	echo -e "\t\t\t\t${green}  email${cyan}            $email"
	echo -e "\t\t\t\t${yellow}|---------------------------------------------------------|${default}"
	echo -e " "
	echo -e "\t\t\t\t${yellow}|---------------------------------------------------------|${default}"
	echo -e "\t\t\t\t${green} Current Balance${cyan}   $balance"
	echo -e "\t\t\t\t${yellow}|---------------------------------------------------------|${default}"
	echo ""
}
userInfo()
{
	userid=$1
	if [ -s $1"detail" ] && [ -s $1"balance" ]
	then
		reset
		display $1
		read -p "`echo -e ${magenta}`Press Any Key To Exit ....`echo -e ${default}`" -s tempo
	else
		echo -e "${red}File Not Found System Fault ....${default}"
	fi	
}
deposit ()
{
	userAmount=$(whiptail --title "Banking Solution Deposition Menu" --inputbox "Enter Your Amount : " 10 50 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus -eq 0 ]
	then
		exp='^[0-9]+$'
		if [[ $userAmount =~ $exp ]]
		then
			if [ $userAmount -le 50000 ] && [ $userAmount -gt 0 ]
			then
					#---- Amount Deposition ----
					if (whiptail --title "Confirmation" --yesno "Are You Sure You Want To Proceed This Transaction !" 8 60)
					then
						amount=`cat $1"balance"`
						sum=$(( $amount+$userAmount ))
						echo $sum > $1"balance"
						now=$(date +"%m-%d-%Y")
						pashbookDetail="$now|Deposited|$amount|$sum+"
						echo $pashbookDetail >> $1"pashbook"
						whiptail --title "Success" --msgbox "Your Money Successfully Deposited ...." 8 50
						# Announce deposit with voice
						if command -v announce_deposit >/dev/null 2>&1; then
							announce_deposit "$userAmount" "$sum"
						fi
					fi
			else
				whiptail --title "Something Went Wrong" --msgbox "Your Deposited Amount Must Be Less Than 50001 And Greater Than 0" 8 50
			fi
		else
			#---- For Invalid Integer Format ----
			whiptail --title "Something Went Wrong" --msgbox "Please Enter Valid Number ...." 8 50
		fi
	else
		#---- Do NOthing ----
		whiptail --title "Info" --msgbox "Your Transaction Has Been Canceled ...." 8 50
	fi 
}
withdraw ()
{
	userAmount=$(whiptail --title "Banking Solution Withdraw Menu" --inputbox "Enter Your Amount : " 10 50 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus -eq 0 ]
	then
		exp='^[0-9]+$'
		if [[ $userAmount =~ $exp ]]
		then
			if [ $userAmount -le 50000 ] && [ $userAmount -gt 0 ]
			then
				amount=`cat $1"balance"`
				if [ $amount -ge $userAmount ]
				then
					if (whiptail --title "Confirmation" --yesno "Are You Sure You Want To Proceed This Transaction !" 8 60)
					then
						sum=$(( $amount-$userAmount ))
						echo $sum > $1"balance"
						now=$(date +"%m-%d-%Y")
						pashbookDetail="$now|Withdraw|$amount|$sum+"
						echo $pashbookDetail >> $1"pashbook"
						whiptail --title "Success" --msgbox "Your Money Successfully Withdraw ...." 8 50
						# Announce withdraw with voice
						if command -v announce_withdraw >/dev/null 2>&1; then
							announce_withdraw "$userAmount" "$sum"
						fi
					fi
				else
					#---- Insufficient Amount ----
					whiptail --title "Info" --msgbox "Insufficient Amount To Be Withdraw ...." 8 50
				fi
				else
					whiptail --title "Something Went Wrong" --msgbox "Your Deposited Amount Must Be Less Than 50001 And Greater Than 0" 8 50
				fi
			else
			#---- For Invalid Integer Format ----
			whiptail --title "Something Went Wrong" --msgbox "Please Enter Valid Number ...." 8 50
		fi
	else
		#---- Do Nothing ----
		whiptail --title "Info" --msgbox "Your Transaction Has Been Canceled ...." 8 50
	fi 
}
transfer ()
{
	userAmount=$(whiptail --title "Banking Solution Withdraw Menu" --inputbox "Enter Your Amount : " 10 50 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus -eq 0 ]
	then
		exp='^[0-9]+$'
		if [[ $userAmount =~ $exp ]]
		then
			if [ $userAmount -le 50000 ] && [ $userAmount -ge 0 ]
			then
				tid=$(whiptail --title "Banking Solution Withdraw Menu" --inputbox "Enter The Transfer ID : " 10 50 3>&1 1>&2 2>&3)
				if [ $exitstatus -eq 0 ]
				then
					exp='^[0-9]+$'
					if [[ $tid =~ $exp ]]
					then
						if [ -s $tid"detail" ] && [ $tid != $1 ]
						then
							# Amount Has Been Deducted
							amount=`cat $1"balance"`
							if [ $amount -ge $userAmount ]
							then
								if (whiptail --title "Confirmation" --yesno "Are You Sure You Want To Proceed This Transaction !" 8 60)
								then
									sum=$(( $amount-$userAmount ))
									echo $sum > $1"balance"
									now=$(date +"%m-%d-%Y")
									pashbookDetail="$now|Transfered $tid|$amount|$sum+"
									echo $pashbookDetail >> $1"pashbook"
									# Amount Has Been Added
									amount=`cat $tid"balance"`
									sum=$(( $amount+$userAmount ))
									echo $sum > $tid"balance"
									now=$(date +"%m-%d-%Y")
									pashbookDetail="$now|Deposited $1|$amount|$sum+"
									echo $pashbookDetail >> $tid"pashbook"
									whiptail --title "Success" --msgbox "Your Money Successfully Transfered ...." 8 50
									# Announce transfer with voice
									if command -v announce_transfer >/dev/null 2>&1; then
										announce_transfer "$userAmount" "$tid"
									fi
								fi
							else
								#---- Insufficient Amount ----
								whiptail --title "Info" --msgbox "Insufficient Amount To Be Withdraw ...." 8 50
							fi
						else
							#---- Invalid Accoutn Id ----
							whiptail --title "Something Went Wrong" --msgbox "Account ID Invalid / Not Found ...." 8 50
						fi
					else
						#---- For Invalid Integer Format On Account ----
						whiptail --title "Something Went Wrong" --msgbox "Please Enter Valid Account ID ...." 8 50
					fi
				else
					#---- Do Nothing ----
					whiptail --title "Info" --msgbox "Your Transaction Has Been Canceled ...." 8 50
				fi 
			else
				#---- Invalid According To Bank Policy ----
				whiptail --title "Something Went Wrong" --msgbox "Your Deposited Amount Must Be Less Than 50001 And Greater Than 0" 8 50
			fi
		else
			#---- For Invalid Integer Format ----
			whiptail --title "Something Went Wrong" --msgbox "Please Enter Valid Number ...." 8 50
		fi
	else
		#---- Do Nothing ----
		whiptail --title "Info" --msgbox "Your Transaction Has Been Canceled ...." 8 50
	fi 
}
pashbook ()
{
	reset
	if [ -s $1"detail" ]
	then
		# Get current balance
		current_balance=`cat $1"balance"`
		
		# Announce current balance with voice - using direct call to speak function
		speak "Your current balance is $current_balance rupees."
		
		echo -e "\t\t\t\t${yellow}+ ${cyan}$2${yellow} Passbook Detail +${default}"
		echo -e "\n"
		echo -e "${yellow}-----------------------------------------------------------------------------------------------${default}"
		echo -e "${cyan}Date\t\t\tStatus\t\t\tBalance\t\t\tCurrent Balance"
		echo -e "${yellow}-----------------------------------------------------------------------------------------------${default}"
		IFS="+"
		for line in `cat $1"pashbook"`
		do
			IFS="|"
			array=( $line )
			echo -e "${green}${array[0]}\t\t${red}${array[1]}\t\t\t${cyan}${array[2]}\t\t${array[3]}${default}"
		done
		IFS=" "
		echo -e "\n"
		read -p "`echo -e ${magenta}`Press Any Key To Exit ....`echo -e ${default}`" -s tempo
	else
		reset
		echo "System Fault ...."
		sleep 5
	fi
}
editName()
{
	while [ 1 -eq 1 ]
	do
		exp='^[a-zA-Z ]+$'
		noexp='^[0-9]+$'
		reset
		name=`cat $1"detail" | cut -f2 -d'|'`
		username=$(whiptail --title "Re-enter Your Name" --inputbox "Your Previous Name : $name" --cancel-button "Back" 10 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		if [ $exitstatus -eq 0 ]
		then
			#--------------------- Name Validation -------------
			if [[ $username =~ $exp ]] && [[ $username == *[a-zA-Z]* ]] && [[ $username != *[0-9]* ]]
			then
				if (whiptail --title "Confirmation" --yesno "Are You Sure You Want Edit Your Name !" 8 60)
				then
					`sed -i "/$1/s/$name/$username/" $1"detail"`
					`sed -i "/ID:$1/s/$name/$username/" "user"`
					whiptail --title "Confirmation" --msgbox "Your Name Successfully Updated ..." 10 60
					# Announce name update with voice
					if command -v announce_name_update >/dev/null 2>&1; then
						announce_name_update "$username"
					fi
					break
				else
					whiptail --title "Info" --msgbox "Your Action Has Been Canceled ..." 10 60
				fi
			else
				whiptail --title "Something Went Wrong" --msgbox "Invalid Name Format ..." 10 60
			fi
		else
			break
		fi
	done
	
}
editGender()
{
	while [ 1 -eq 1 ]
	do
		reset
		gender=`cat $1"detail" | cut -f3 -d'|'`
		usergender=$(whiptail --title "Banking Solution Open Account" --menu "Your Previous Gender : $gender" --cancel-button "Back" 15 60 4 \ "Male" "" \ "Female" "" 3>&1 1>&2 2>&3)
		exitstatus=$?		
		#--------- Patch Work ---------
		if [[ $usergender == *[' ']* ]]
		then
			usergender=${usergender//[[:blank:]]/}
		fi
		#------------------------------		
		if [ $exitstatus -eq 0 ]
		then
			if (whiptail --title "Confirmation" --yesno "Are You Sure You Want Edit Your Gender !" 8 60)
			then
				`sed -i "/$1/s/$gender/$usergender/" $1"detail"`
				`sed -i "/ID:$1/s/$gender/$usergender/" "user"`
				whiptail --title "Confirmation" --msgbox "Your Gender Successfully Updated ..." 10 60
				# Announce gender update with voice
				if command -v announce_gender_update >/dev/null 2>&1; then
					announce_gender_update "$usergender"
				fi
				break
			else
				whiptail --title "Info" --msgbox "Your Action Has Been Canceled ..." 10 60
				break
			fi
		else
			break
		fi
	done
}
editDOB()
{
	getyear=`cat $1"detail" | cut -f4 -d'|'`
	getmonth=`cat $1"detail" | cut -f5 -d'|'`
	getday=`cat $1"detail" | cut -f6 -d'|'`
	validyear=`date +"%Y"`
	startyear=$(($validyear-100))
	while [ 1 ]
	do
		noexp='^[0-9]+$'
		useryear=$(whiptail --title "Banking Solution Open Account" --inputbox "Select Date Of Birth (Year IN YYYY) | Previus Year $getyear" 10 78 --nocancel --clear 3>&1 1>&2 2>&3)
		if [ $useryear -ge $startyear ] && [ $useryear -lt $validyear ] && [[ $useryear =~ $noexp ]]
		then
			break
		else
			whiptail --title "Something Went Wrong" --msgbox "Invalid Year Format / Year Must Be In Range $startyear - $validyear" 10 80
		fi
	done
	while [ 1 ]
	do
		noexp='^[0-9]+$'
		usermonth=$(whiptail --title "Banking Solution Open Account" --inputbox "Select Date Of Birth (Month IN MM) | Previous Month $getmonth" 10 78 --nocancel --clear 3>&1 1>&2 2>&3)
		if [ $usermonth -ge 1 ] && [ $usermonth -le 12 ]	&& [[ $usermonth =~ $noexp ]]
		then
			break
		else
			whiptail --title "Something Went Wrong" --msgbox "Invalid Month Format / Year Must Be In Range 1 - 12" 10 80
		fi
	done
	while [ 1 ]
	do
		noexp='^[0-9]+$'
		userday=$(whiptail --title "Banking Solution Open Account" --inputbox "Select Date Of Day (Month IN DD) | Previous Day $getday" 10 78 --nocancel --clear 3>&1 1>&2 2>&3)
		if [ $userday -ge 1 ] && [ $userday -le 31 ]	&& [[ $userday =~ $noexp ]]
		then
			break
		else
			whiptail --title "Something Went Wrong" --msgbox "Invalid Day Format / Year Must Be In Range 1 - 31" 10 80
		fi
	done
	bod="$getyear|$getmonth|$getday"
	userbod="$useryear|$usermonth|$userday"
	if (whiptail --title "Confirmation" --yesno "Are You Sure You Want Edit Your Date Of Birth !" 8 60)
	then
		`sed -i "/$1/s/$bod/$userbod/" $1"detail"`
		`sed -i "/ID:$1/s/$bod/$userbod/" "user"`
		whiptail --title "Confirmation" --msgbox "Your Date Of Birth Successfully Updated ..." 10 60
		# Announce date of birth update with voice
		if command -v announce_dob_update >/dev/null 2>&1; then
			announce_dob_update "$userbod"
		fi
	else
		whiptail --title "Info" --msgbox "Your Action Has Been Canceled ..." 10 60
	fi
}
editEmail()
{
	while [ 1 ]
	do
		email=`cat $1"detail" | cut -f7 -d'|'`
		useremail=$(whiptail --title "Re-enter Your Email" --inputbox "Your Previous Email ID : $email" --cancel-button "Back" 10 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		if [ $exitstatus -eq 0 ]
		then
			#--------------------- Eamil Validation -------------
			if [[ $useremail == *[@]* ]] && [[ $useremail == *[a-zA-z]* ]]
			then
				if (whiptail --title "Confirmation" --yesno "Are You Sure You Want Edit Your Email !" 8 60)
				then
					`sed -i "/$1/s/$email/$useremail/" $1"detail"`
					`sed -i "/ID:$1/s/$email/$useremail/" "user"`
					whiptail --title "Confirmation" --msgbox "Your Email ID Successfully Updated ..." 10 60
					# Announce email update with voice
					if command -v announce_email_update >/dev/null 2>&1; then
						announce_email_update "$useremail"
					fi
					break
				else
					whiptail --title "Info" --msgbox "Your Action Has Been Canceled ..." 10 60
				fi		
			else
				whiptail --title "Something Went Wrong" --msgbox "Invalid Email Format ..." 10 60
			fi
		else
			#---- Go Back (Do Nothing) ----
			break
		fi
	done
}
editRecord()
{
	reset
	option=$(whiptail --title "Edit Your Detail" --menu "Select An Option" 15 90 4 \ "1" "Edit Name" \ "2" "Edit Gender" \ "3" "Edit Date Of Birth" \ "4" "Edit Email" --cancel-button "Back" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus -eq 0 ]
	then
		if [ $option -eq 1 ]
		then
			editName $1
		elif [ $option -eq 2 ]
		then
			editGender $1
		elif [ $option -eq 3 ]
		then
			editDOB $1
		elif [ $option -eq 4 ]
		then
			editEmail $1
		fi
	else
		whiptail --title "Info" --msgbox "Back To User DashBoard ...." 15 60
	fi
}
getUser()
{
	reset
	nouser=`wc -l user | cut -f1 -d' '`
	echo -e "\t\t\t\t${yellow}------------------- ${Magenta}Banking Solution${yellow} -------------------${default}"
	echo -e "\t\t\t\t${yellow}\t\t${green}Total Number Of Users : ${cyan}$nouser"
	echo -e "\t\t\t\t${yellow}--------------------------------------------------------${default}"
	read -p "`echo -e ${magenta}`Press Any Key To Exit ....`echo -e ${default}`" -s tempo
}
getDetail()
{
	userId=$(whiptail --title "Banking Solution Admin Menu" --inputbox "Enter The User ID : " --cancel-button "Back" 10 50 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus -eq 0 ]
	then
		if [ -s $userId"detail" ] && [ -s $userId"balance" ]
		then
			reset
			display $userId
			read -p "`echo -e ${magenta}`Press Any Key To Exit ....`echo -e ${default}`" -s tempo
		else	
			#---- Do Nothing (Only Go Back )----
			whiptail --title "Something Went Wrong" --msgbox "Invalid Account Holder ...." 8 50
		fi
	else
		#---- Do Nothing (Only Go Back )----
		whiptail --title "Info" --msgbox "Back To Admin Dash Board...." 8 50
	fi
}
getAlluser()
{
	reset
	echo -e "\t\t\t${yellow}++++++++++++++ ${green}Bank All User ${yellow}++++++++++++++${default}"
	IFS="+"
	for i in `cat user`
	do
		IFS="|"
		alluserarray=( $i )
		echo -e "${magenta}${alluserarray[0]}${default}"
		echo -e "\t\t\t${yellow}|${cyan}Name         :\t${yellow}${alluserarray[1]}${default}"
		echo -e "\t\t\t${yellow}|${cyan}Gender       :\t${yellow}${alluserarray[2]}${default}"
		echo -e "\t\t\t${yellow}|${cyan}Date Of Bith :\t${yellow}${alluserarray[3]}-${alluserarray[4]}-${alluserarray[5]}${default}"
		echo -e "\t\t\t${yellow}|${cyan}Email ID     :\t${yellow}${alluserarray[6]}${default}"
	done
	IFS=" "
	echo -e "\n"
	read -p "`echo -e ${cyan}`Enter Any Key To Exit ....`echo -e ${default}`" -s tempo
}
removeUser()
{
	userId=$(whiptail --title "Banking Solution Admin Menu" --inputbox "Enter The User Id : " --cancel-button "Back" 10 50 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus -eq 0 ]
	then
		if [ -s $userId"detail" ] 
		then
			if (whiptail --title "Confirmation" --yesno "Are You Sure You Want To Remove This Account Holder !" 8 60)
			then
				rm -f $userId"detail"
				rm -f $userId"balance"
				rm -f $userId"pashbook"
				sed -i -e "/$userId|/d" user
				whiptail --title "Confirmation" --msgbox "Account Holder Successfully Removed ...." 8 50
				# Announce account removal with voice
				if command -v announce_account_removal >/dev/null 2>&1; then
					announce_account_removal "$userId"
				fi
			fi
		else
			whiptail --title "Something Went Wrong" --msgbox "Invalid User ID" 8 50
		fi
	else
		#---- Do Nothing ----
		whiptail --title "Info" --msgbox "Back To Admin Dash Board ..." 8 50
	fi
}
# Function for users to view their messages and admin responses
viewUserMessages()
{
	local user_id=$1
	
	# Check if messages directory exists
	if [ ! -d "messages" ]; then
		mkdir -p messages
		whiptail --title "Messages" --msgbox "You have no messages." 8 50
		return
	fi
	
	# Count user messages and responses
	local msg_count=$(ls -1 messages/msg_${user_id}_* 2>/dev/null | wc -l)
	local resp_count=$(ls -1 messages/resp_${user_id}_* 2>/dev/null | wc -l)
	local total_count=$((msg_count + resp_count))
	
	if [ "$total_count" -eq 0 ]; then
		whiptail --title "Messages" --msgbox "You have no messages." 8 50
		return
	fi
	
	# Build menu of messages and responses
	local menu_items=()
	local all_files=($(ls -1t messages/{msg,resp}_${user_id}_* 2>/dev/null))
	local counter=1
	
	for file in "${all_files[@]}"; do
		# Determine if it's a message or response
		if [[ "$file" == *msg_* ]]; then
			local type="Message to Admin"
			local time=$(grep "Time:" "$file" | sed 's/Time: //')
			local status=$(grep "Status:" "$file" | sed 's/Status: //')
			
			# Add to menu items
			menu_items+=("$counter" "$type - $time [$status]")
		else
			local type="Response from Admin"
			local time=$(grep "Time:" "$file" | sed 's/Time: //')
			
			# Add to menu items
			menu_items+=("$counter" "$type - $time")
		fi
		counter=$((counter + 1))
	done
	
	# Show menu of messages and responses
	local selected=$(whiptail --title "Your Messages ($total_count)" --menu "Select a message to view:" 20 78 10 "${menu_items[@]}" --ok-button "View" --cancel-button "Back" 3>&1 1>&2 2>&3)
	exitstatus=$?
	
	if [ $exitstatus -eq 0 ] && [ -n "$selected" ]; then
		# Get selected file
		local selected_file="${all_files[$((selected - 1))]}"
		
		# Display message/response content
		local content=$(cat "$selected_file")
		whiptail --title "Message Details" --scrolltext --msgbox "$content" 20 78
		
		# Recursive call to view more messages
		viewUserMessages "$user_id"
	fi
}

# Function for admin to view and respond to user messages
viewMessages()
{
	# Check if messages directory exists
	if [ ! -d "messages" ]; then
		mkdir -p messages
		whiptail --title "Messages" --msgbox "No messages found." 8 50
		return
	fi
	
	# Count messages
	local msg_count=$(ls -1 messages/msg_* 2>/dev/null | wc -l)
	
	if [ "$msg_count" -eq 0 ]; then
		whiptail --title "Messages" --msgbox "No messages found." 8 50
		return
	fi
	
	# Build menu of messages
	local menu_items=()
	local msg_files=($(ls -1t messages/msg_* 2>/dev/null))
	local counter=1
	
	for msg_file in "${msg_files[@]}"; do
		# Extract sender and status
		local sender=$(head -n 1 "$msg_file" | sed 's/From: //')
		local time=$(grep "Time:" "$msg_file" | sed 's/Time: //')
		local status=$(grep "Status:" "$msg_file" | sed 's/Status: //')
		
		# Add to menu items
		menu_items+=("$counter" "$sender - $time [$status]")
		counter=$((counter + 1))
	done
	
	# Show menu of messages
	local selected=$(whiptail --title "User Messages ($msg_count)" --menu "Select a message to view:" 20 78 10 "${menu_items[@]}" --ok-button "View" --cancel-button "Back" 3>&1 1>&2 2>&3)
	exitstatus=$?
	
	if [ $exitstatus -eq 0 ] && [ -n "$selected" ]; then
		# Get selected message file
		local selected_file="${msg_files[$((selected - 1))]}"
		
		# Mark as read
		sed -i 's/Status: Unread/Status: Read/' "$selected_file"
		
		# Display message content
		local message_content=$(cat "$selected_file")
		whiptail --title "Message Details" --scrolltext --msgbox "$message_content" 20 78
		
		# Ask if admin wants to respond
		if (whiptail --title "Respond" --yesno "Would you like to respond to this message?" 8 60); then
			# Extract user ID from filename
			local user_id=$(echo "$selected_file" | grep -o "msg_[0-9]*" | sed 's/msg_//')
			
			# Get admin response
			local response=$(whiptail --title "Admin Response" --inputbox "Enter your response:" 15 70 3>&1 1>&2 2>&3)
			
			if [ $? -eq 0 ] && [ -n "$response" ]; then
				# Create timestamp
				local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
				
				# Create response file
				local resp_file="messages/resp_${user_id}_$(date +%s)"
				echo "To: User ID $user_id" > "$resp_file"
				echo "Time: $timestamp" >> "$resp_file"
				echo "Response:" >> "$resp_file"
				echo "$response" >> "$resp_file"
				
				# Update original message with response
				echo "" >> "$selected_file"
				echo "Admin Response (${timestamp}):" >> "$selected_file"
				echo "$response" >> "$selected_file"
				echo "Status: Responded" >> "$selected_file"
				
				# Speak confirmation if available
				if command -v speak >/dev/null 2>&1; then
					speak "Response sent to user." &
				fi
				
				whiptail --title "Response Sent" --msgbox "Your response has been saved and attached to the original message." 8 70
				
				# Recursive call to view more messages
				viewMessages
			fi
		else
			# Recursive call to view more messages
			viewMessages
		fi
	fi
}

# Function to allow users to contact admin with messages
contactAdmin()
{
	# Create messages directory if it doesn't exist
	if [ ! -d "messages" ]; then
		mkdir -p messages
	fi
	
	# Ask for user ID
	local user_id=$(whiptail --title "Contact Admin" --inputbox "Enter your User ID:" 10 50 3>&1 1>&2 2>&3)
	exitstatus=$?
	
	if [ $exitstatus -eq 0 ] && [ -n "$user_id" ]; then
		# Verify user exists
		if [ -f "${user_id}detail" ]; then
			# Get user name
			local name=$(cat "${user_id}detail" | cut -f2 -d"|")
			
			# Check if there are any admin responses for this user
			local resp_count=$(ls -1 messages/resp_${user_id}_* 2>/dev/null | wc -l)
			
			if [ "$resp_count" -gt 0 ]; then
				# Show admin responses first
				if (whiptail --title "Admin Responses" --yesno "Hello $name, you have $resp_count response(s) from the administrator. Would you like to view them now?" 10 70); then
					# Show user messages
					viewUserMessages "$user_id"
					
					# Ask if they want to send a new message
					if ! (whiptail --title "New Message" --yesno "Would you like to send a new message to the administrator?" 8 70); then
						return
					fi
				fi
			fi
			
			# Get message from user
			local message=$(whiptail --title "Message to Admin" --inputbox "Hello $name, please enter your message for the administrator:" 15 70 3>&1 1>&2 2>&3)
			
			if [ $? -eq 0 ] && [ -n "$message" ]; then
				# Create timestamp
				local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
				
				# Save message to file
				local msg_file="messages/msg_${user_id}_$(date +%s)"
				echo "From: $name (ID: $user_id)" > "$msg_file"
				echo "Time: $timestamp" >> "$msg_file"
				echo "Message:" >> "$msg_file"
				echo "$message" >> "$msg_file"
				echo "Status: Unread" >> "$msg_file"
				
				# Speak confirmation if available
				if command -v speak >/dev/null 2>&1; then
					speak "Your message has been sent to the administrator. Thank you." &
				fi
				
				whiptail --title "Message Sent" --msgbox "Your message has been sent to the administrator. Thank you." 8 60
			else
				whiptail --title "Cancelled" --msgbox "Message sending cancelled." 8 50
			fi
		else
			whiptail --title "Error" --msgbox "User ID not found. Please enter a valid ID." 8 60
		fi
	else
		whiptail --title "Cancelled" --msgbox "Contact admin cancelled." 8 50
	fi
}

# Function to change a user's password (admin only)
changeUserPassword()
{
	# Ask for the user ID whose password needs to be changed
	userId=$(whiptail --title "Banking Solution Admin Menu" --inputbox "Enter The User ID to change password: " --cancel-button "Back" 10 50 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus -eq 0 ]
	then
		# Check if the user exists
		if [ -f "${userId}detail" ]
		then
			# Get user details
			IFS='|' read -r id name address phone email password <<< "$(cat ${userId}detail)"
			
			# Display user information for confirmation
			if (whiptail --title "Confirm User" --yesno "Change password for:\nID: $id\nName: $name\nEmail: $email" 12 60)
			then
				# Ask for the new password
				new_password=$(whiptail --title "New Password" --passwordbox "Enter new password for $name: " 10 60 3>&1 1>&2 2>&3)
				if [ $? -eq 0 ] && [ -n "$new_password" ]
				then
					# Confirm the new password
					confirm_password=$(whiptail --title "Confirm Password" --passwordbox "Confirm new password: " 10 60 3>&1 1>&2 2>&3)
					if [ $? -eq 0 ] && [ "$new_password" = "$confirm_password" ]
					then
						# Update the password in the user detail file
						new_details="$id|$name|$address|$phone|$email|$new_password"
						echo "$new_details" > "${userId}detail"
						
						# Announce password change with voice
						if command -v speak >/dev/null 2>&1; then
							speak "Password changed successfully for user $name." &
						fi
						
						whiptail --title "Success" --msgbox "Password changed successfully for $name." 8 60
					else
						whiptail --title "Error" --msgbox "Passwords do not match. Password change cancelled." 8 60
					fi
				else
					whiptail --title "Cancelled" --msgbox "Password change cancelled." 8 50
				fi
			fi
		else
			whiptail --title "Error" --msgbox "User ID $userId not found." 8 50
		fi
	else
		whiptail --title "Info" --msgbox "Back to Admin Dashboard..." 8 50
	fi
}

admin()
{
	reset
	echo -e "${yellow}+ Admin Login +${default}"
	username=$(whiptail --title "Banking Solution Admin Login" --inputbox "Enter Your Username : " --ok-button "Next" 10 50 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus -eq 0 ]
	then
		password=$(whiptail --title "Banking Solution Admin Login" --passwordbox "Enter Your Password : " --ok-button "Next" 10 50  3>&1 1>&2 2>&3)
		exitstatus=$?
		if [ $exitstatus -eq 0 ]
		then
			if [ "$username" = "root" ] && [ "$password" = "12345" ]
			then
				while [ 1 ]
				do
					option=$(whiptail --title "Welcome Admin" --menu "\nAdmin Dash Board" 16 60 7 \ "1" "Number Of User" \ "2" "All User Detail" \ "3" "Search User" \ "4" "Remove Account" \ "5" "Change User Password" \ "6" "View Messages" --ok-button "Select" --cancel-button "Logout" 3>&1 1>&2 2>&3)
					if [ $option -eq 1 ]
					then
						getUser
					elif [ $option -eq 2 ]
					then
						reset
						getAlluser
					elif [ $option -eq 3 ]
					then
						getDetail
					elif [ $option -eq 4 ]
					then
						removeUser
					elif [ $option -eq 5 ]
					then
						changeUserPassword
					elif [ $option -eq 6 ]
					then
						viewMessages
					else
						if (whiptail --title "Confirmation" --yesno "Are You Sure You Want To Exit !" 8 60)
						then
							return 1
							break
						fi
					fi 
				done
			else
				whiptail --title "Something Went Wrong" --msgbox "Invalid Admin ...." 8 50
			fi
		else
			#---- Do Nothing (Only Go Back )----
			whiptail --title "Info" --msgbox "Back To Main Menu ...." 8 50
		fi
	else
		#---- Do Nothing (Only Go Back )----
		whiptail --title "Info" --msgbox "Back To Main Menu ...." 8 50
	fi
}
temp=0
# Flag to track if we just logged out
just_logged_out=0

while [ $temp -eq 0 ]
do
	reset
	# Play welcome message when showing main menu, but not right after logout
	# Welcome message is now played during loading screen
	# No welcome message here
	
	# Reset the logout flag
	just_logged_out=0
	option=$(whiptail --title "Banking Solution" --menu "\nChoose Your Option" 16 60 5 \ "1" "Open Account" \ "2" "User Login" \ "3" "Admin Login" \ "4" "Contact Admin" \ "5" "Credit" --ok-button "Select" --cancel-button "Exit" 3>&1 1>&2 2>&3)
	if [ $option -eq 1 ]
	then
		OpenAccount
	elif [ $option -eq 2 ]
	then
		id=$(whiptail --title "Login To Our Banking Solution" --inputbox "Enter Your Login ID : " 10 50 3>&1 1>&2 2>&3)
		#-------------------------------------- Check For Exit Status --------------------------------------------------
		exitstatus=$?
		if [ $exitstatus -eq 0 ]
		then
			if [ -s $id"detail" ]
			then
				password=`cat $id"detail" | cut -f8 -d"|"`
				name=`cat $id"detail" | cut -f2 -d"|"`
				ids=`cat $id"detail" | cut -f1 -d"|"`
				userPassword=$(whiptail --title "Login To Our Banking Solution" --passwordbox "Enter Your Password : " 10 50  3>&1 1>&2 2>&3)
				exitstatus=$?
				if [ $exitstatus -eq 0 ]
				then
					if [ "$password" = "$userPassword" ]
					then
						# Announce successful login with voice
						if command -v announce_login >/dev/null 2>&1; then
							announce_login "$name"
						fi
						flag=0
						while [ $flag -eq 0 ]
						do
							option=$(whiptail --title "Welcome ${name}" --menu "\nUser Dashboard" 16 90 9 \ "1" "Deposit" \ "2" "Transfer" \ "3" "Withdraw" \ "4" "Passbook Detail" \ "5" "Get Your Detail" \ "6" "Change Password" \ "7" "Edit Record" \ "8" "Banking Assistant" \ "9" "Messages" --ok-button "Select" --cancel-button "Logout" 3>&1 1>&2 2>&3)
							exitstatus=$?
							if [ $exitstatus -eq 0 ]
							then
								if [ $option -eq 1 ]
								then
									deposit $ids
								elif [ $option -eq 2 ]
								then
									transfer $ids
								elif [ $option -eq 3 ]
								then
									withdraw $ids
								elif [ $option -eq 4 ]
								then
									pashbook $ids "$name"
								elif [ $option -eq 5 ]
								then
									userInfo $ids
								elif [ $option -eq 6 ]
								then
									changePassword $ids
								elif [ $option -eq 7 ]
								then
									editRecord $ids
									name=`cat $id"detail" | cut -f2 -d"|"`
								elif [ $option -eq 8 ]
								then
									# Announce Banking Assistant with voice
									if command -v announce_banking_assistant >/dev/null 2>&1; then
										announce_banking_assistant
									fi
									
									# Set current user ID as an environment variable for the Banking Assistant
									export CURRENT_USER_ID="$id"
									
									# Launch the Banking Assistant chatbot
									bash ./chat_gpt.sh
								elif [ $option -eq 9 ]
								then
									# View user messages and admin responses
									viewUserMessages "$ids"
								else
									#----- Do Nothing ------
									echo ""
								fi
							else
								#----- Log Out ------
								if (whiptail --title "Confirmation" --yesno "Are You Sure You Want To Logout !" 8 60)
								then
									# Announce logout with voice including username
									if command -v announce_logout >/dev/null 2>&1; then
										announce_logout "$name"
									fi
									# Set the logout flag to prevent welcome message
									just_logged_out=1
									flag=1
								fi
							fi
						done
					else
						whiptail --title "Something Went Wrong" --msgbox "Invalid Password" 8 50
					fi
				else
					#---- Do Nothing (Only Go Back )----
					whiptail --title "Info" --msgbox "Your Action Has Been Canceled ...." 8 50
				fi
			else
				whiptail --title "Something Went Wrong" --msgbox "Invalid Account Holder ...." 8 50
			fi
		else
			#---- Do Nothing (Only Go Back )----
			echo ""
		fi
	elif [ $option -eq 3 ]
	then
		admin
	elif [ $option -eq 4 ]
	then
		# Contact Admin option
		contactAdmin
	elif [ $option -eq 5 ]
	then
		whiptail --title "Banking Solution" --msgbox "Develop By \n Hafiz malik Muhammad Siawish \n Daniyal Qureshi \n " 20 50
	else
		if (whiptail --title "Confirmation" --yesno "Are You Sure You Want To Exit !" 8 60)
		then
			# Announce goodbye with voice
			if command -v speak >/dev/null 2>&1; then
				speak "Thank you for using Cyber Bank. Goodbye!" &
				sleep 1  # Small delay to allow voice to start before exiting
			fi
			exit 0
		fi
	fi
done
