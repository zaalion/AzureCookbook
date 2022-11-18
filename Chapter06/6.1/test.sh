#!/bin/bash

messageCount=100

for (( i=1; i<=$messageCount; i++ ))
do

  randomTemp=$(($RANDOM/100))
  echo $randomTemp

done