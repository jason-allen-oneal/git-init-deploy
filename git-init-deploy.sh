#!/bin/bash

read -p "Please enter the directory to push (eg: projects/git-init-deploy or ~/projects/git-init-deploy): " projectDirectory
if [[ -z "$projectDirectory" ]]; then
	echo "No project directory provided! How am I supposed to know what you want to push??"
	exit
fi

read -p "Please enter a repository name (eg: jason-allen-oneal/git-init-deploy): " repository
read -p "Public or private? " type
type=${type:-public}
IFS='/' read -ra reparray <<< "$repository"
user="${reparray[0]}"
rep="${reparray[1]}"

cd "$projectDirectory"

read -p "In what language or framework is the project written? " lang
lang="${lang,,}"
[[ -n "$lang" ]] && wget -q "https://raw.githubusercontent.com/jason-allen-oneal/gitignore/main/$lang.gitignore" && mv "$lang.gitignore" .gitignore

if ! command -v gh &> /dev/null; then
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
	apt update
	apt install gh
	gh auth login
fi

[[ -z "$repository" ]] && gh repo create || gh repo create "$repository" "--$type"

git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin "https://github.com/$user/$rep.git"
git push -u origin main
