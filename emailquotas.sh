COUNTER=0
while IFS=, read username blockused blocklimit inodeused; do
	# Only include as many results as requested.
	if [ $COUNTER -lt $RESULTS ]; then
		# Ignore accounts without a block limit.
		if [ "$blocklimit" != "0" ]; then
			# Process our blocks used and block limit into a human-readable format.
			PROCBLOCKUSED=`numfmt "$blockused" --from-unit=1024 --to=iec`
			PROCBLOCKLIMIT=`numfmt "$blocklimit" --from-unit=1024 --to=iec`
			# Calculate a percentage used.
			PERCENTUSED=$(awk "BEGIN { pc=100*${blockused}/${blocklimit}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
			# Not interested in accounts that have used 0% of their allowance.
			if [ $PERCENTUSED -gt 0 ]; then
				# Format our results into a nice list.
				echo "   $username	$PERCENTUSED%	$PROCBLOCKUSED of $PROCBLOCKLIMIT" >> $LOGFILE
				COUNTER=$[$COUNTER +1]
			fi
		fi
	fi
done < $QUOTALIST

