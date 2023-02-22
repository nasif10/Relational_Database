#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    GET_ELEMENT_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$1;")
  else
    GET_ELEMENT_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements inner join properties using(atomic_number) inner join types using(type_id) where symbol='$1' or name='$1';")
  fi
  if [[ -z $GET_ELEMENT_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$GET_ELEMENT_RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT_POINT BAR BOIL_POINT BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi