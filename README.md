# git-bash-express

Speed up Git Bash operations in an enterprise environment by avoiding the network disk.
Starting Git Bash will **still be slow** though.

## Enterprise frustration

* Are you using Git Bash in an enterprise Windows environment where your administrator prevents you from doing what you want on "your" computer?
* Has your organization decided that what's best for you is to use a network drive, typically `H:`, as your "home" directory?
* Are you unable to modify files within your Git for Windows installation?
* Do you find Git Bash to be slow and wonder why your "ultimate git prompt" seems to slow you down even more?
* Do you want Git Bash to be a little snappier?

Using a network disk in the age of SSDs is really a huge leap backwards when it comes to performance and it can be difficult to get your organizations administrators to take this problem seriously. So here is a way to get Git Bash off the network drive without changing the installation.

## What the [speedup.sh](speedup.sh) script does

There are plenty of explanatory comments in the [speedup.sh](speedup.sh) script. In fact they make up the most lines in it. Have a look in it for details.

## Prerequisites

* You have Git for Windows installed already.
* Your Git configuration is set up the way you like it in `/h/.gitconfig` in Git Bash or `H:\.gitconfig` in Windows Explorer..
* Your ssh keys are in place on your network home directory, i.e. `/h/.ssd` in Git Bash or `H:\.ssh` in Windows Explorer.

## Installation

**Note** You may need to set up Git to use the proxy to clone from github.com using https: 

```bash
git config --global http.https://github.com.proxy http://<proxyhost>:<port>
```

* Clone this repo to a location of your choice, e.g. `/c/dev/`
* If needed, edit the `speedup.sh` script to:
  * Set your default start directory unless you like `DEFAULT_START_DIR=/c/projects`, "Git Bash here..." still works
  * Make changes for your network home directory if it is not `/h/`
* Edit or create your `/h/.bash_profile` and source the `speedup.sh` script, i.e. add this at the **very beginning** of the file:
    ```bash
    # Speedup Git Bash
    source /c/dev/git-bash-express/speedup.sh
    ```

## Running git-bash-express

Each time you **start** a new Git Bash session the `speedup.sh` script will be run.

### Worth noting

The first time you start a Git Bash it after installing git-bash-express it will copy your `.gitconfig` and `.ssh` (if missing) to your home directory on your local disk.
Any new change you make using `git config --global` will be stored on your local disk instead of the network disk.
Since startup of Git Bash will still be slow, each startup will also backup the latest local `.gitconfig` to your network drive as `.gitconfig.bak`

## Verify installation

`git config --list --show-origin` will show you that configurations are no longer read from the network drive.
Your `PATH` variable should no longer contain any refences to your network drive.

## Uninstalling

* Remove or comment out the added lines from your `/h/.bash_profile`
* If you want to use your absolute latest git settings (from the backup) just copy `/h/.gitconfig.bak` to `/h/.gitconfig` 
* Start a new Git Bash session and go slow again
