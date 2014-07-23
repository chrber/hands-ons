#/bin/bash
no_of_files=120
counter=101
while [[  -le $no_of_files ]]
  do
   dd bs=256 count=$RANDOM if=/dev/urandom of=random-file.$counter
   cp   random-file.$counter /nfs4/random-file.$counter
   rm  -f random-file.$counter
   let "counter += 1"
  done

no_of_files=225
counter=201
while [[ $counter -le $no_of_files ]]
  do
   dd bs=256 count=$((RANDOM%200+1)) if=/dev/urandom of=random-file.$counter
   cp   random-file.$counter /nfs4/random-file.$counter
   rm  -f random-file.$counter
   let "counter += 1"
  done

no_of_files=325
counter=301
while [[ $counter -le $no_of_files ]]
  do
   dd bs=256 count=$((RANDOM%20+1)) if=/dev/urandom of=random-file.$counter
   cp   random-file.$counter /nfs4/random-file.$counter
   rm  -f random-file.$counter
   let "counter += 1"
  done
