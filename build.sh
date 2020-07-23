#!/bin/bash

# Get the config variables
source './config.sh'

buildcart() {
	if $PICOTOOL build $COMPILED --lua $LUAINDEX --gfx $GFX --gff $GFF --map $MAP --sfx $SFX --music $MUSIC
	then
		echo `date +%H:%M:` "Cart successfully built at $COMPILED"
	else
		echo "Couldn't build the cart!"
	fi
}

if [ `command -v $PICOTOOL` ]
then
	buildcart
else
	echo "Couldn't find p8tool!"
fi

