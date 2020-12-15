==============================================
 Local python venv dev install on Linux/MacOS
==============================================

Prerequisites:

* recent python install (3.6 or better)
* brew package manager (MacOS only)
* POSIX shell (eg, bash)
* git, make, etc

Recommended approach:

* install the minimum required in the *global* python environment

  + pip virtualenv virtualenvwrapper
  + use local tools: ``emerge`` or ``apt-get`` or ``pip``

Setup virtualenvwrapper
-----------------------

* create a new virtualenv/project using virtualenvwrapper

  + first edit bashrc.sh as needed (see below) then

    - ``source bashrc.sh``
    - ``mkproject proxy-dev``

* the previous command should leave you in the new project dir

  + ``pwd`` should confirm this

* clone this repo into the new project dir (note the trailing '.')

  + ``git clone git@github.com:freepn/freepn-proxy.git .``

* upgrade pip and setuptools in the new virtualenv

  + ``python -m pip install -U pip setuptools``

* install everything else into your new virtualenv

  + ``pip install -r requirements-dev.txt``

* run ``deactivate`` to leave your new virtualenv

  + to resume work on the proxy project, run

    - ``workon proxy-dev``


Note the use of ``mkproject`` instead of ``mkvirtualenv`` will move your
current working directory automatically when you run the ``workon`` and
``deactivate`` commands.


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


Running the tools
-----------------

The current set of dev-tools is intended for testing/analyzing proxy
scripts in a local virtualenv, and consist mainly of env/Procfile and
shell scripts.  Using ``honcho`` is optional; you can always run one
of the web servers and the proxy in separate terminals with whatever
arguments you need (honcho and shell tools only tested on Linux so
far).

.. note:: With the current .js filter sources hosted on a public ``https``
          server, there is no need to run a local web server in parallel
          with the proxy, thus the default http config will only launch a
          single process.
 

Configs for ``honcho`` consist of a Procfile and env file; the default
names are ``Procfile`` and ``.env`` but alternate names can also be passed
via arguments to ``honcho``.

* honcho default filter config

  + ``Procfile`` and ``env.filter``
  + copy ``env.filter`` to ``.env``
  + run ``honcho start``

* honcho adblock config

  + ``Procfile.adblock`` and ``env.adblock``
  + copy to default names and run ``honcho start``
  + or use an alternate command, something like:

::

  $ honcho -e env.adblock -f Procfile.adblock start


To see more output, run proxy adblock command from a terminal::

  mitmdump -s adblock/adblock.py -p 8080 \
      --set stream_large_bodies=100k -q --flow-detail 0 --anticache \
      --anticomp --set ssl_insecure=false \
		--set ssl_verify_upstream_trusted_confdir="$TRUSTDIR"

Be sure and export (or replace) the "$TRUSTDIR" variable for your distro,
eg, ``/etc/ssl/certs/`` for Gentoo or Ubuntu.

* honcho http-only (local) config

  + ``Procfile.fltr-http`` and ``env.fltr-http``
  + copy to default names and run ``honcho start``
  + or use an alternate command, something like:

::

  $ honcho -e env.fltr-http -f Procfile.fltr-http start


To see a bit more output from each process, run in separate terminals.

Open a terminal window and start the http server to host the remote
javascript resources::

  $ python -m http.server --directory filters/ 8000

and then start the proxy in a second terminal window using a filterurl
pointing to the above http server::

  $ mitmdump -s filters/filter_injector.py \
      --set filterurl=http://localhost:8000/filter.js \
      -p 8080 --anticache --anticomp

.. note:: For the above to work, the remote resource contained in the
          ``filter.js`` script must also use an http URL, and you must
          be browsing a web site that allows http-only. In this example
          ``filter.js`` contains an equivalent filterurl pointing to
          ``http://localhost:8000/script.js``.



Additional helper tools to use while running the proxy include the
following:

* shell tools preconfigured for ``localhost`` proxy (start proxy first)

  + ``bin/chkip`` - wrapper script for wget geoip lookup over proxy
  + ``bin/links`` - wrapper script for links browser over proxy

* shell tools preconfigured for adblock script

  + ``adblock/bin/proxy-runner.sh``
  + ``adblock/bin/update-blocklists.sh``
  + ``adblock/bin/install-cert.sh``



More information about the virtualenv setup:

* `pelican setup readme`_
* `python venv on macos`_
* `django project virtualenvwrapper`_

.. _pelican setup readme: https://github.com/VCTLabs/vct-web
.. _python venv on macos: https://hackercodex.com/guide/python-development-environment-on-mac-osx/
.. _django project virtualenvwrapper: https://neosergio.wordpress.com/2014/09/10/how-to-start-a-django-project-virtualenvwrapper-git/


Currently supported proxy modes:

* proxy mode - requires browser/environment configuration for local traffic

Specific configurations vary across OS and applications; most linux distros
have a "system" config/env variables for proxy config, however, the "big"
browser apps mainly use their own configuration options (which should
include an option for "use system proxy settings").  Note the same "config"
issues also apply to the system trustdb (ie, which trusted certificate
store is used by different applications).

.. tip:: The FoxyProxy plugin for firefox can be used to easily enable
         disable mutiple proxy configurations for testing.

* transparent mode - TODO

