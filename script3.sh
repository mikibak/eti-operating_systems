#!/bin/bash

OUTPUT=$(zenity --forms --title="Wyszukiwarka plikow" --text="Wypelnij pola" --separator="," --add-entry="Nazwa_pliku" --add-entry="Nazwa_katalogu" --add-entry="Minimalna wielkosc" --add-entry="Maksymalna wielkosc" --add-entry="Zawartosc")


FILE_NAME=$(awk -F, '{print $1}' <<<$OUTPUT)
DIR_NAME=$(awk -F, '{print $2}' <<<$OUTPUT)
MIN=$(awk -F, '{print $2}' <<<$OUTPUT)
MAX=$(awk -F, '{print $3}' <<<$OUTPUT)
CONTENT=$(awk -F, '{print $4}' <<<$OUTPUT)

	#-size +$MIN -c -$MAX -c  
        if [ $? = 0 ]; then
    		SEARCH=$(find $DIR_NAME $FILE_NAME $MIN $MAX $CONTENT)
        	if [[ -z "$SEARCH" ]]; then
            		zenity --info --title "Wynik" --text "Plik nie istnieje"
        	else
            		zenity --info --title "Wynik" --text "Plik istnieje"
        	fi
	fi
