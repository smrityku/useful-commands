
**Remove all files that are listed in the .gitignore but still on the repository:**

    git rm --cached `git ls-files -i -c --exclude-from=.gitignore`
    
    
**.pem file permission set:**

    chmod 400 file.pem
