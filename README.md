```
*****************************************************************

      :::    :::      :::    :::    :::     :::       ::::::::::
     :+:   :+:       :+:    :+:    :+:     :+:       :+:
    +:+  +:+        +:+    +:+    +:+     +:+       +:+
   +#++:++         +#+    +:+    +#+     +:+       +#++:++#
  +#+  +#+        +#+    +#+     +#+   +#+        +#+
 #+#   #+#       #+#    #+#      #+#+#+#         #+#
###    ###       ########         ###           ##########

*****************************************************************
```

Easily view important debugging information over multiple environments.

# Installation

- $ brew update
- $ brew install crystal-lang
- $ cd kuve
- $ cp kuve_conf.sample kuve_conf.json
- $ Update your kuve_conf.json (see Steps to get db-con working)
- $ make update

## List available commands

- $ kuve -h

## Steps to get db-con working

- You will need to have all your apps in one directory
- You will need to add a directory with all psql-service-accounts.json - this is needed to connect to the proxy
- Update the kuve_conf.json to include these two paths
- If the db-con fails to run correctly, check that you have the repo cloned to the apps directory and that you have the service account for the project in the right directory


## Todo

- Use multiple contexts
- Better Error Messages
- More Functionality (Ideas/PR's Welcome)

## Developing locally

- $ crystal kuve.cr your-commands