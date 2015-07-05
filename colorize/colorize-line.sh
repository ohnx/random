#!/bin/bash
	while IFS= read -r line; do
		length="${#line}"
		bol=1
		echo -en "\e[3$(( $RANDOM * 6 / 32767 + 1 ))m"
		for (( offset = 0 ; offset < length ; offset++ )); do
			char="${line:offset:1}"
			echo -n "$char"
			if (( bol )) && [[ "$char" == " " ]]; then
			continue
			fi
			bol=0
		done
		printf '\n'
	done
