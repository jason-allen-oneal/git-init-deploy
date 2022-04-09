#!/bin/bash

empty=""

read -p "Please enter the directory to push (eg: projects/git-init-deploy or ~/projects/git-init-deploy): " projectDirectory

if [[ "$projectDirectory" = "$empty" ]]; then
	echo "No project directory provided! How am I supposed to know what you want to push??"
	exit
fi

read -p "Please enter a repository name (eg: jason-allen-oneal/git-init-deploy): " repository

if [[ "$repository" == *"/"* ]]; then
	IFS='/'
	read -ra reparray <<< "$repository"
fi

read -p "Public or private? " type
if [[ "$type" = "$empty" ]]; then
	type="public"
else
	if [[ "$type" != "public" && "$type" != "private" ]]; then
		type="public"
	fi
fi

user="${reparray[0]}"
rep="${reparray[1]}"
cd "$projectDirectory"

read -p "In what language or framework is the project written? " lang
lang="${lang,,}"

if [[ "$lang" != "$empty" ]]; then
	url="https://raw.githubusercontent.com/jason-allen-oneal/gitignore/main/$lang.gitignore"
	if wget -q --method=HEAD "$url"; then
		wget "$url"
		mv "$lang.gitignore" ".gitignore"
	fi
fi

if ! command -v gh &> /dev/null; then
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
	apt update
	apt install gh
	gh auth login
fi

if [[ "$repository" = "$empty" ]]; then
	gh repo create
else
	gh repo create "$repository" "--$type"
fi

git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin https://github.com/"$user"/"$rep".git
git push -u origin main