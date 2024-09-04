#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c "

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  ELEMENT=$1
  INT_REGEX='^[0-9]+$'
  STRING_REGEX='^([A-Z])([a-z]+)?'

  if [[ $ELEMENT =~ $INT_REGEX ]]
  then
    ELEMENT_QUERY=$($PSQL "SELECT * FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number=$ELEMENT")
  elif [[ $ELEMENT =~ $STRING_REGEX ]]
  then
    SYM_ELEMENT_QUERY=$($PSQL "SELECT * FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE elements.symbol='$ELEMENT'")
    NAME_ELEMENT_QUERY=$($PSQL "SELECT * FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE elements.name='$ELEMENT'")
  fi

  # echo $ELEMENT_QUERY
  # echo $SYM_ELEMENT_QUERY
  # echo $NAME_ELEMENT_QUERY
  
  if [[ -z $ELEMENT_QUERY ]] && [[ -z $SYM_ELEMENT_QUERY ]] && [[ -z $NAME_ELEMENT_QUERY ]]
  then
    echo "I could not find that element in the database."
  elif [[ $ELEMENT_QUERY ]]
  then
    echo $ELEMENT_QUERY | while read E_ATOMIC_NUM BAR SYMBOL BAR NAME BAR P_ATOMIC_NUM BAR MASS BAR MELT BAR BOIL BAR TYPE_ID BAR TYPE_ID_2 BAR TYPE
    do
      echo -e "The element with atomic number $E_ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  elif [[ $SYM_ELEMENT_QUERY ]]
  then
    echo $SYM_ELEMENT_QUERY | while read E_ATOMIC_NUM BAR SYMBOL BAR NAME BAR P_ATOMIC_NUM BAR MASS BAR MELT BAR BOIL BAR TYPE_ID BAR TYPE_ID_2 BAR TYPE
    do
      echo -e "The element with atomic number $E_ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  elif [[ $NAME_ELEMENT_QUERY ]]
  then
    echo $NAME_ELEMENT_QUERY | while read E_ATOMIC_NUM BAR SYMBOL BAR NAME BAR P_ATOMIC_NUM BAR MASS BAR MELT BAR BOIL BAR TYPE_ID BAR TYPE_ID_2 BAR TYPE
    do
      echo -e "The element with atomic number $E_ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
  
  
fi