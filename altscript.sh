#!/bin/bash -f
OPTION="some"
NAME=""
DIR=""
CONTENT=""
COMMAND=""
SIZE=""
TIME=""
USER=""
RESULTS=""

option(){
OPTION=`zenity --list --column=Menu "${MENU[@]}" --width 300 --height 450`
}

while [ "$OPTION" != "Koniec" ]
do
   MENU=("Nazwa pliku: $NAME" "Katalog: $DIR" "Plik nalezy do uzytkownika: $USER"  "Dni od ostatniej modyfikacji: $TIME" "Plik mniejszy niz: $SIZE" "Zawartosc: $CONTENT" "Szukaj" "Koniec")
   clear
   option
   case $OPTION in
       "Nazwa "*) NAME=`zenity --entry --text "Podaj nazwe pliku"`;;
       "Katalog:"*) DIR=`zenity --entry --text "Podaj katalog"`;;
       "Wlasciciel"*) USER=`zenity --entry --text "Podaj uzytkownika"`;;
       "Ostatnia modyfikacji"*) TIME=`zenity --entry --text "Podaj ilosc dni od modyfikacji"`;;
       "max rozmiar pliku"*) SIZE=`zenity --entry --text "Podaj rozmiar pliku"`;;
       "Zawartosc"*) CONTENT=`zenity --entry --text "Podaj zawartosc"`;;
       "Koniec"*) echo "Zakonczenie dzialania";;
   esac
   
   if [ "$OPTION" == "Szukaj" ]
   then
   COMMAND=""

    if [ -n "$DIR" ]
   then
       COMMAND=$COMMAND' '$DIR
   fi

   if [ -n "$NAME" ]
   then
       COMMAND=$COMMAND' -name '$NAME
   fi

   if [ -n "$USER" ]
   then
       COMMAND=$COMMAND' -user '$USER
   fi

   if [ -n "$TIME" ]
   then
       COMMAND=$COMMAND' -mtime '$TIME
   fi
   
   if [ -n "$SIZE" ]
   then
       COMMAND=$COMMAND' -size '$SIZE
   fi
   
   if [ -n "$CONTENT" ]
   then
       COMMAND=$COMMAND' -exec grep -l '$CONTENT' '$NAME
       COMMAND=$COMMAND' {} ;'
   fi
   
   RESULTS=`find $COMMAND`
   zenity --info --title "Zakonczono szukanie" --text "$RESULTS"  
   
   fi
   clear
done
