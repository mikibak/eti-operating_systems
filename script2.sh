#!/bin/bash

TIMER=0
while [[ $TIMER -lt 7 ]]; do

read N_OF_OPERATION
if [[ $N_OF_OPERATION == 1 ]]; then
read FILE_NAME
elif [[ $N_OF_OPERATION == 2 ]]; then
read DIR_NAME
elif [[ $N_OF_OPERATION == 3 ]]; then
read MIN
elif [[ $N_OF_OPERATION == 4 ]]; then
read MAX
elif [[ $N_OF_OPERATION == 5 ]]; then
read CONTENT
CONTENT="-exec grep -li $CONTENT {} +"
elif [[ $N_OF_OPERATION == 6 ]]; then
SEARCH=$(find $DIR_NAME -name $FILE_NAME $MIN $MAX $CONTENT)
if [[ -z "$SEARCH" ]]; then
echo "Plik nie istnieje"
else
echo "Plik istnieje"
fi
#-size +$MIN -c -$MAX -c
elif [[ $N_OF_OPERATION == 7 ]]; then
exit
else
exit
fi



done
