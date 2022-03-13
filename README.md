# git-init-deploy  

This bash script will initialize git and push your project to a specified repository on github. Only works in uninitialized directories. Directory name must match repository name.

Place this script in the directory which contains you github repositories:

```
/projects
-/git-init-deploy.sh
-/project-a
-/project-b
```

Change permissions:  
`chmod 777 git-init-deploy.sh`  

__Usage__:
`./git-init-deploy.sh -r jason-allen-oneal/git-init-deploy`