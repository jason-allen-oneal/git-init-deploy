#!/bin/bash

empty=""

while [ "$1" != "$empty" ]; do
	case "$1" in
		-r | --rep )
repository="$2";	shift;; 
	esac
	shift
done

if [[ "$repository" = "$empty" ]]; then
	echo "Please enter a repository name (eg: jason-allen-oneal/git-init-deploy) with -r or --rep"
	exit
fi

if [[ "$repository" == *"/"* ]]; then
	IFS='/'
	read -ra reparray <<< "$repository"
fi

user="${reparray[0]}"
rep="${reparray[1]}"
cd "$rep"

git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin https://github.com/"$user"/"$rep".git
git push -u origin main