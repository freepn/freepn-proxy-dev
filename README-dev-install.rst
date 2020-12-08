==============================================
 Local python venv dev install on Linux/MacOS
==============================================

Prerequisites:

* recent python install (3.6 or better)
* brew package manager (MacOS only)
* POSIX shell (eg, bash)
* git, make, etc

Recommended approach:

* install the minimum required in the *global* python env
  + pip and virtualenv and virtualenvwrapper
  + use local tools: ``emerge`` or ``apt-get`` or ``pip``

* create a new virtualenv/project using virtualenvwrapper
  + first edit .bashrc as needed (see below) then
    - ``source ~/.bashrc``
    - ``mkproject proxy-dev``

* the previous command should leave you in the new project dir
  + ``pwd`` should confirm this

* clone this repo into the new project dir (note the '.')
  + ``git clone git@github.com:freepn/freepn-proxy.git .``

* upgrade pip and setuptools in the new virtualenv
  + ``python -m pip install -U pip setuptools``

* install everything else into your new virtualenv
  + ``pip install -r requirements-dev.txt``




Required ``bash`` environment for using virtualenvwrapper; add to your
``.bashrc`` and source it before creating anything with virtualenvwrapper.

::

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



More information about the general setup:

https://github.com/VCTLabs/vct-web
https://hackercodex.com/guide/python-development-environment-on-mac-osx/
https://neosergio.wordpress.com/2014/09/10/how-to-start-a-django-project-virtualenvwrapper-git/


Currently supported proxy modes:

* proxy mode - requires browser/environment configuration for local traffic

Specific configurations vary across OS and applications; most linux distos
have a "system" config/env variables, however, the "big" browser apps mainly
use their own configuration options (which should include an optin for
"use system settings").  Note the same "config" issues also apply to the
system trustdb (ie, which trusted certificate store is used by different
applications).

* transparent mode - 
