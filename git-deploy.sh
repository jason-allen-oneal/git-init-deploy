#!/bin/bash

read -rp "Please enter the directory to push (eg: projects/git-init-deploy or ~/projects/git-init-deploy): " projectDirectory

if [[ -z "$projectDirectory" ]]; then
	echo "No project directory provided! How am I supposed to know what you want to push??"
	exit 1
fi

read -rp "Please enter a repository name (eg: jason-allen-oneal/git-init-deploy): " repository

if [[ "$repository" == *"/"* ]]; then
	IFS='/' read -ra reparray <<< "$repository"
fi

read -rp "Public or private? " type
if [[ -z "$type" ]]; then
	type="public"
elif [[ "$type" != "public" && "$type" != "private" ]]; then
	type="public"
fi

user="${reparray[0]}"
rep="${reparray[1]}"
cd "$projectDirectory" || exit 1

read -rp "In what language or framework is the project written? " lang
lang="${lang,,}"

if [[ -n "$lang" ]]; then
	url="https://raw.githubusercontent.com/jason-allen-oneal/gitignore/main/$lang.gitignore"
	if wget -q --method=HEAD "$url"; then
		wget "$url"
		mv "$lang.gitignore" ".gitignore"
	fi
fi

if ! command -v gh &> /dev/null; then
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
	sudo apt update
	sudo apt install gh
	gh auth login
fi

if [[ -z "$repository" ]]; then
	gh repo create
else
	gh repo create "$repository" --"$type"
fi

git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin "https://github.com/$user/$rep.git"
git push -u origin main
