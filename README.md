
**Remove all files that are listed in the .gitignore but still on the repository:**

    git rm --cached `git ls-files -i -c --exclude-from=.gitignore`
    
    
**.pem file permission set:**

    chmod 400 file.pem

**Installing rvm in ubuntu**

    $ \curl -sSL https://get.rvm.io | bash
    $ source /home/<user>/.rvm/scripts/rvm
    $ rvm -v
