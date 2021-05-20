#!/bin/bash


sess="$(who | awk '{key=$1; getline; print key ", " $1;}')"

load="$( uptime | cut -d ',' -f 4,5,6 | xargs)"

mem="$(free -m |  awk '
  FNR==1{
    for(i=1;i<=NF;i++){ arr[i]=$i }
  }
  FNR==2{
    for(i=2;i<=NF;i++){
      printf("%s%s",arr[i-1]":" OFS $i,i==NF?ORS:", ")
    }
  }
')"


printf "who: %s    %s,   memory: %s" "$sess" "$load" "$mem"

