PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT=$1
  # check if it is an element number
  if [[ $ELEMENT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$ELEMENT
    IFS="|" read ELEMENT_MASS ELEMENT_MELTING_POINT ELEMENT_BOILING_POINT TYPE_ID <<< "$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")"
    if [[ -z $ELEMENT_MASS ]]
    then
      echo "I could not find that element in the database."
    else 
      IFS="|" read ELEMENT_NAME ELEMENT_SYMBOL <<< "$($PSQL "SELECT name, symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")"
      read ELEMENT_TYPE <<< "$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")"
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
    fi
  # check if it is a symbol
  elif [[ "${#ELEMENT}" -le 3 ]]
  then
    ELEMENT_SYMBOL=$ELEMENT
    IFS="|" read ELEMENT_NAME ATOMIC_NUMBER <<< "$($PSQL "SELECT name, atomic_number FROM elements WHERE symbol='$ELEMENT_SYMBOL';")"
    if [[ -z $ELEMENT_NAME ]]
    then
      echo "I could not find that element in the database."
    else
      IFS="|" read ELEMENT_MASS ELEMENT_MELTING_POINT ELEMENT_BOILING_POINT TYPE_ID <<< "$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")"
      read ELEMENT_TYPE <<< "$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")"
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
    fi

  elif [[ "${#ELEMENT}" -gt 3 ]]
  then
    ELEMENT_NAME=$ELEMENT
    IFS="|" read ATOMIC_NUMBER ELEMENT_SYMBOL <<< "$($PSQL "SELECT atomic_number, symbol FROM elements WHERE name='$ELEMENT_NAME';")"
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      IFS="|" read ELEMENT_MASS ELEMENT_MELTING_POINT ELEMENT_BOILING_POINT TYPE_ID <<< "$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")"
      read ELEMENT_TYPE <<< "$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")"
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
    fi
  fi
fi