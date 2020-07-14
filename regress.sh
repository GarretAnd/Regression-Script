#!/bin/bash

# Garret Andreine         4/14/2020       regress.#!/bin/sh
# Allows for directory comparison against existing directories or creates that directory

VAR=$#
TIME=$(date '+%Y%m%d.%H%M%S')
EXISTS=0

if [ $VAR -gt 1 ]  # Checks to make sure more than one argument is listed
  then
	   echo "Two Arguments were provided! The script will carry on!"
  else
	echo "Not Enough Arguments were provided. Leaving bash script."
  exit 1
fi

if [ -f $1 ]  # Checks to make sure the inputted directory isn't actually a file
  then
    echo "A File with this name already exists. Existing Script."
    exit 1
fi

if [ -d $1 ]  # Checks if the first argument inputted is an existing directory
  then
    echo "The directory is detected."
    EXISTS=1
  else
    echo "There is no directory detected. Making this directory."
    TIME=$1  # If the directory doesn't exist stores this in the time variable
fi

for i in "${@:2}"  # Checks every argument after 1 with a for loop
do
  if [ -f $i ] && [ -r $i ]  # Checks that every file exists and is readable
    then
      echo "Argument $i is readable and regular."
    else
      echo "File $i is not readable and regular. Exiting script."
      exit 1
  fi
done

if [ -d $TIME ]  # Checks to see if the data in the time variable or the stored
  then           # Value exists, if not makes the directorys
    echo "The Directory$TIME already exists."
  else           # This part is important because it checks the date, if the TIME
    mkdir $TIME  # Variable doesn't have the date stored into it will automatically
    echo "Made Directory $TIME!"  # make the directory name of the first argument that was inputted
fi

for i in "${@:2}"  # Checks every argument after 1 with a for loop
do    # ./$i runs the file   first > goes to output, the 2> goes to error stream
  BASE=$(basename $i)
  ./$i >$TIME/$BASE.stdout 2>$TIME/$BASE.stderr <"/dev/null"
  echo "$? >$TIME/$BASE.status" # Stores the exit status in the TIME dir
  cp $i $TIME/$BASE.test # Copies Files into TIME dir and gives it .test extension
done

if diff $TIME $1
then
  echo "No difference. Exit with code zero."
else
  echo "Difference detected."
  exit $?
fi

exit 0
