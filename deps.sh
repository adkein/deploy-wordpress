#!/bin/bash

set -eu

venv_path=$(dirname $0)/venv
if [[ ! -d $venv_path ]] ; then
  python3 -m venv $venv_path
fi
source $venv_path/bin/activate
pip install ansible
