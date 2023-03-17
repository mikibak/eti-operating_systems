#!/bin/bash

# Author           : Mikolaj Bak ( s188968@student.pg.edu.pl )
# Created On       : 22.05.2022
# Last Modified By : Mikolaj Bak ( s188968@student.pg.edu.pl )
# Last Modified On : 29.05.2022
# Version          : 1.1
#
# Description      :
# This is a process controller which can be used to save and recreate user's processes
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)


LIST_OF_PROCESSES=$(mktemp)
process_controller_save=$(mktemp)

listProcesses () {
	ps -u mikolaj | sed 's/[ ][ ]*/ /g' | cut -d ' ' -f 1,2,5- | grep -v "ps\|cinnamon\|cut\|grep\|nemo\|bash\|sed\|Web Content\|GeckoMain\|Isolated Web Co" > $LIST_OF_PROCESSES
}

while getopts hvf:q OPT; do
	case $OPT in
		h) echo "Pomoc"
			man process_controller;;
		v) echo "Wersja"
			zenity --info --title 'Version' --text 'Version 1.1';;
	esac
done

while true; do
	ans=""
	ans=$(zenity --info --title 'Process controller' \
		--text 'Choose action' \
		--extra-button "Show current processes" \
		--extra-button "Save" \
		--extra-button "Load" \
		--extra-button "Show changes" \
		--ok-label "Save and exit" \
	)
	
  	rc=$?
  	if [[ ${rc} == "1" && ${ans} == "" ]] ; then
  		#the X button
   	 	break
	elif [[ ${rc} == "0" ]] ; then
		#save and exit
		break
	fi
	
	case ${ans} in
  		"Show current processes") 
  			listProcesses
  			zenity --text-info --filename "$LIST_OF_PROCESSES" --title "Current processes" ;;
  		"Save") 
  			listProcesses
  			cat $LIST_OF_PROCESSES > process_controller_save ;;
  		"Show changes") 
  			current_processes=$(mktemp)
  			comparison=$(mktemp)
  			listProcesses
  			cat $LIST_OF_PROCESSES > $current_processes
  			
  			echo "New processes: " > $comparison
  			awk 'FNR == NR { oldfile[$0]=1; }; 
  				FNR != NR { if(oldfile[$0]==0) print; }' process_controller_save $current_processes >> $comparison
  			echo "Closed processes: " >> $comparison
  			awk 'FNR == NR { oldfile[$0]=1; }; 
  				FNR != NR { if(oldfile[$0]==0) print; }' $current_processes process_controller_save >> $comparison
  			grep -v "nemo\|bash" $comparison
  			zenity --text-info --filename "$comparison" --title "Detected changes"
  			rm ${current_processes} 
  			rm ${comparison} ;;
  		"Load") 
  			if [ -s process_controller_save ]; then
     			zenity --question --text="Processes will be closed, are you sure?"
  				if [ $? = 0 ]; then
  					current_processes=$(mktemp)
  					comparison=$(mktemp)
  					listProcesses
  					cat $LIST_OF_PROCESSES > $current_processes
					awk 'FNR == NR { oldfile[$0]=1; }; 
  					FNR != NR { if(oldfile[$0]==0) print; }' process_controller_save $current_processes | cut -d ' ' -f 2 >> $comparison
  					while read p; do
 						kill -SIGTERM $p
 						echo "murder!"
					done <$comparison
  					rm ${comparison}
				fi 
			else
     			echo "File is empty, cannot load"
			fi;;
   		*) 
   			echo "other" ;;
	esac
done
rm ${LIST_OF_PROCESSES}
rm ${process_controller_save}

