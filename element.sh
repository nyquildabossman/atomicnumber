PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 
fi

#if parameter is not a number
if [[ ! $1 =~ ^[0-9]+$ ]] 
then
  ELEMENT_PROPERTIES=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, t.type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types as t USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  
  if [[ -z $ELEMENT_PROPERTIES ]]
  then
    echo "I could not find that element in the database."
    exit
  fi

  echo "$ELEMENT_PROPERTIES" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS SYMBOL NAME TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
else
  ELEMENT_PROPERTIES=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, t.type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types as t USING(type_id) WHERE atomic_number = $1 ")  
  
  if [[ -z $ELEMENT_PROPERTIES ]]
  then
    echo "I could not find that element in the database."
    exit
  fi

  echo "$ELEMENT_PROPERTIES" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS SYMBOL NAME TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
fi