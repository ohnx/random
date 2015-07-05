#!/bin/bash
	while IFS= read -r line; do
		length="${#line}"
		bol=1
		for (( offset = 0 ; offset < length ; offset++ )); do
			char="${line:offset:1}"
			echo -en "\e[3$(( $RANDOM * 6 / 32767 + 1 ))m$char"
			if (( bol )) && [[ "$char" == " " ]]; then
			continue
			fi
			bol=0
		done
		printf '\n'
	done
