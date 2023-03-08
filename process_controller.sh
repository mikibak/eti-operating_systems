#!/bin/bash

LIST_OF_PROCESSES=$(mktemp)

listProcesses () {
ps -u mikolaj | sed 's/[ ][ ]*/ /g' | cut -d ' ' -f 1,2,5- | grep -v "ps\|cinnamon\|cut\|grep\|nemo\|bash\|sed\|Web Content\|GeckoMain\|Isolated Web Co" > $LIST_OF_PROCESSES
}

while true; do
	ans=""
	ans=$(zenity --info --title 'Process controller' \
	--text 'Choose A or B or C' \
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
		echo "Show current processes" ;;
	"Save")
		listProcesses
		cat $LIST_OF_PROCESSES > script4_save.txt ;;
	"Show changes")
		current_processes=$(mktemp)
		#comparison=$(mktemp)
		listProcesses
		cat $LIST_OF_PROCESSES > $current_processes

		echo "New processes: " > comparison.txt
		awk 'FNR == NR { oldfile[$0]=1; };
		FNR != NR { if(oldfile[$0]==0) print; }' script4_save.txt $current_processes >> comparison.txt
		echo "Closed processes: " >> comparison.txt
		awk 'FNR == NR { oldfile[$0]=1; };
		FNR != NR { if(oldfile[$0]==0) print; }' $current_processes script4_save.txt >> comparison.txt
		grep -v "nemo\|bash" comparison.txt
		zenity --text-info --filename "comparison.txt" --title "Detected changes"
		rm ${current_processes}
		rm comparison.txt ;;
	"Load")
		zenity --question --text="Processes will be closed, are you sure?"
		if [ $? = 0 ]; then
		current_processes=$(mktemp)
		listProcesses
		cat $LIST_OF_PROCESSES > $current_processes
		echo "murder!"
		awk 'FNR == NR { oldfile[$0]=1; };
		FNR != NR { if(oldfile[$0]==0) print; }' script4_save.txt $current_processes | cut -d ' ' -f 2 >> comparison.txt
		while read p; do
		kill -SIGTERM $p
		done rm comparison.txt
		fi ;;
	*)
		echo "other" ;;
esac

done
rm ${LIST_OF_PROCESSES}
rm ${process_controller_save}