#!/bin/bash

if [ `command -v fswatch` ]
	then
		echo 'fswatch found. Starting...'

		fswatch -r -0 . -e dist | xargs -0 -n1 -I{} ./build.sh
	else
		echo 'ERROR: fswatch is not installed'
fi
