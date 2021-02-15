# Here are some tricks to stop Git from using your network home directory in order to speed it up.
# The speedup due to skipping network access is about 7x when working from my VPN connection.
# Unfortunately Git Bash will always start up slowly but every single git operation after that will skip the network access.
# Please set DEFAULT_START_DIR to your preferred default start location.
# NOTE: The order we do things in this file also affects the speed of the startup and this is the order I have found to be the fastest to execute.

# Fix PATH to exclude locations on /h/ by replacing it with references to /c/.
export PATH=${PATH//\/h\//\/c\/}

# Git for Windows (MINGW) and Cygwin uses different conventions to find the C: drive
# In Cygwin you need to start the path with /cygdrive while Git for Windows uses just /
# before the drive letter in the path.
if [[ $(uname) == CYGWIN* ]]; then
        echo "Cygwin detected by speedup.sh"
        ROOT_PREFIX=/cygdrive
fi

if [[ $(uname) == MINGW* ]]; then
        echo "MINGW detected by speedup.sh"
        ROOT_PREFIX=
fi

# The directory you want to start Git Bash in unless you have used the right click context menu option "Git Bash here...".
# The default value is ${HOME} which points to "/h/" which is your network drive and you NEVER want to use that one for Git repos.
DEFAULT_START_DIR=${ROOT_PREFIX}/c/repos

# Make Git Bash start by default in ${DEFAULT_START_DIR} unless we used "Git bash here".
if [ ${PWD} = "${ROOT_PREFIX}/h/" ] ; then
	# Detected default bash start in /h/. Changing to desired start dir.
	cd ${DEFAULT_START_DIR}
elif [ ${PWD} = "${HOME}" ] ; then
	# Detected default bash start in ${HOME} other than "${ROOT_PREFIX}/h/". Changing to desired default start dir.
	cd ${DEFAULT_START_DIR}
fi

# Git uses ${HOME} which points to "/h/" to determine where to store your settings.
# It means that it needs to access the network for every time a git command is run.
# NEWHOME is where we want to store the settings instead.
# And yes - the trailing / is consistent with the default setting for HOME. It can probably be omitted but that is untested.
NEWHOME=${ROOT_PREFIX}/c/Users/${USERNAME}
OLDHOME="${ROOT_PREFIX}/h"

# Make git use C drive for settings
export HOME=${NEWHOME}/

# Since this trick also stores your settings on your local hard drive you no longer have a network backup of your settings.
# We might as well take care of that since the startup is slow anyway.
# Granted this trick only makes a backup every time you start a new Git Bash session but that is a lot better than never backing it up.
# It also slows down the Git Bash startup a little :(
if [ -f "${NEWHOME}/.gitconfig" ]; then
	# Backing up any changes in ${NEWHOME}/.gitconfig to ${OLDHOME}/.gitconfig.bak
	cp "${NEWHOME}/.gitconfig" "${OLDHOME}/.gitconfig.bak"
else
	echo "No local '${NEWHOME}/.gitconfig' file found. Copying initial '${OLDHOME}/.gitconfig' to '${NEWHOME}/.gitconfig'"
	cp "${OLDHOME}/.gitconfig" "${NEWHOME}/.gitconfig"
fi

# Add ssh keys from network drive if none found locally
if [ ! -f "${NEWHOME}/.ssh/id_rsa" ]; then
  if [ -d "${NEWHOME}/.ssh" ]; then
  	# We already have a local .ssh directory
  	echo "No local '.ssh/id_rsa' file found. Copying initial 'id_rsa' and 'id_rsa.pub' from ${OLDHOME}/.ssh to ${NEWHOME}/.ssh"
  	cp "${OLDHOME}/.ssh/id_rsa" "${NEWHOME}/.ssh/"
  	cp "${OLDHOME}/.ssh/id_rsa.pub" "${NEWHOME}/.ssh/"
  else
  	echo "No local '.ssh' directory found. Copying ${OLDHOME}/.ssh to ${NEWHOME}/.ssh"
  	cp -r "${OLDHOME}/.ssh" "${NEWHOME}/"
  fi
fi
