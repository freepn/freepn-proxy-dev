# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# use "gpip" command to install to global python env
gpip(){
    PIP_REQUIRE_VIRTUALENV=false python -m pip "$@"
}

# set the paths to use with virtualenvwrapper, ie, depending on
# where the wrapper is installed and where you want your venv
export WORKON_HOME=$HOME/.virtualenvs
# where you put your projects
export PROJECT_HOME=$HOME/src
# make sure this path is correct
source /usr/bin/virtualenvwrapper.sh

# change default proxy cache/log dir under $HOME
# note this is not generally necessary; the default is the XDG user
# location: $HOME/.cache/freepn-proxy
# if you change this, the path MUST be inside your $HOME dir
#export CACHEPATH=some/path
