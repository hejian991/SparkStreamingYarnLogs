#!/bin/bash
function containerlogs {

		if [ ! -d "$1" ]; then
        		# create app folder if does not exist
  				mkdir -p "$1"
		fi
		cd "$1"
		# get app attempts for app job
		attemptIds=$(yarn applicationattempt -list $1 | \
		 	(awk  '/^(appattempt_[^\s]*).*/ {print $1}'))
		for attemptId in $attemptIds;
        do
        	# get containers for appattempts
        	containers=$(yarn container -list $attemptId | \
        		(awk  '/^(container_[^\s]*).*/ {print $1}'))
        	# create directory with app attempt id	
        	dest_dir=./"$attemptId"
        	if [ ! -d "$dest_dir" ]; then
        		# create destination folder if does not exist
  				mkdir -p "$dest_dir"
			fi
       		
        	containers_dir="$dest_dir/containers"
        	if [ ! -d "$containers_dir" ]; then
        		# create container folder of app if does not exist
  				mkdir -p "$containers_dir"
			fi
        	cd "$containers_dir"
        	
        	# get all yarn container logs
        	for i in $containers;
        	do
        		#Destination file format <container> - <start date parameter> - <end date parameter>
        		# ex. container_e06_1452787512024_0090_01_000002-201601141641-201601141645.txt
        		destFile="$i"-$3-$4.txt
            	echo $i > ./$destFile
            	for j in `seq $3 $4`;
            	do
            		filename="$2$j"
            		# get yarn container log file
            		yarn logs -applicationId $1 -containerId $i -logFiles $filename >> ./$destFile
            	done
        	done     	
          	cd ../../
        	echo Logs dumped in $(pwd)     
        done	
			
}

the_world_is_flat=false

if [ -z "$1" ]; then
	echo usage: must give application id 
	the_world_is_flat=true
	
fi

if [ -z "$2" ]; then
	echo usage: must give active log file name 
	the_world_is_flat=true
fi

if [ -z "$3" ]; then
	echo usage: must give starting date
	the_world_is_flat=true
fi

if [ -z "$4" ]; then
	echo usage: must give ending date 
	the_world_is_flat=true
fi


if [ "$the_world_is_flat" = true ] ; then
    echo Script takes parameters in below order 
    echo applicationid active_file_name start_date end_date in-order
	echo ex. scriptname application_1452787512024_0090 stderr 201601141641 201601141643
	exit
fi

containerlogs $1 $2 $3 $4