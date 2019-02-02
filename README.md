# git-bash-express
Speed up Git bash operations in an enterprise environment by avoiding the network disk.

## Why this?
* Are you using **Git Bash** (in Windows) in an enterprise environment where your administrator prevents you from doing what you want on "your" computer?
* Has your organization decided that what's best for you is to use a network drive, typically `H:`, as your "home" directory?
* Are you unable to modify files within your Git for Windows installation?
* Do you find Git Bash to be slow and wonder why your "ultimate git prompt" seems to slow you down even more?
* Do you want Git Bash to be a little snappier?

Using a network disk in the age of SSDs is really a huge leap backwards when it comes to performance and it can be difficult to get your organizations administrators to take this problem seriously. So here is a way to get Git Bash off the network drive without changing the installation.

## Prerequisites
* You have Git for Windows installed already.
* Your Git configuration is set up the way you like it in `/h/.gitconfig` in Git Bash or `H:\.gitconfig` in Windows Explorer..
* Your ssh keys are in place on your network home directory, i.e. `/h/.ssd` in Git Bash or `H:\.ssh` in Windows Explorer.

## Installation
* Clone this repo to a location of your choice, e.g. `/c/dev/`
* If needed: 
  * Edit the `speedup.sh` script to set your default Git Bash start directory unless you like `DEFAULT_START_DIR=/c/projects`
  * Make changes for your network home directory if it is not `/h/`
* Edit or create your `/h/.bash_profile` and source the `speedup.sh` script at the very beginning of the file:
```
# Speedup Git Bash
source /c/dev/git-bash-express/speedup.sh
```

## Running git-bash-express
* The first time you start a Git Bash it after this it will copy your `.gitconfig` and `.ssh` (if missing) to your home directory on your local disk.
* Any changes you make using `git config --global` will thereafter be stored on your local disk instead of the network disk.
* Since startup of Git Bash will still be slow, each startup will also backup the latest local `.gitconfig` to your network drive as `.gitconfig.bak`
