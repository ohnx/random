#!/bin/bash
if [ $# -eq 0 ]
then
	TOUSE="n"
else
	TOUSE=$@
fi
while true
do
	echo $TOUSE
done
