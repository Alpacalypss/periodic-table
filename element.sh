#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#if no args provided
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  #if arg is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  #if arg is a potential symbol
  elif [[ ! $1 =~ ^[0-9]+$ ]] && [ ${#1} -le 2 ]
  then
    ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  #if arg exists and isnt a number or symbol
  else
    ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  fi

  #if the above values aren't found
  if [[ -z $ATOMIC_NUMBER_RESULT ]]
  then
    echo I could not find that element in the database.
  #if above values are found (valid input)
  else
    #get all formatting variables
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER_RESULT")
    #echo $NAME
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER_RESULT")
    #echo $SYMBOL
    TYPE=$($PSQL "SELECT type FROM types t INNER JOIN properties p ON t.type_id=p.type_id WHERE p.atomic_number=$ATOMIC_NUMBER_RESULT")
    #echo $TYPE
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER_RESULT")
    #echo $ATOMIC_MASS
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER_RESULT")
    #echo $MELTING
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER_RESULT")
    #echo $BOILING
    
    #format output with above variables
    echo The element with atomic number $ATOMIC_NUMBER_RESULT is $NAME '('$SYMBOL')'. It"'"s a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.
  fi

fi
