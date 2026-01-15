# OpenAudible Docker - Build Instructions

Adding arm support to the docker. Currently arm only available at URL: https://openaudible.org/beta/OpenAudible_4.6.9.7_beta_aarch64.sh

Typically the docker file will install the vnc server. When the user first logs in (hits web page) a script needs to run that checks if we need to install the software.
If so, we download https://openaudible.org/beta/OpenAudible_4.6.9.7_beta_aarch64.sh and run with the -q argument to quietly install in default location.


Do not run ./run.sh or ./upgrade.sh, instead instruct the user to run it and wait for an update.



