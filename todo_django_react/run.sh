#!/bin/sh

# cd into project directory
SCRIPT_PATH="$(readlink -e $0)"
SCRIPT_DIR="$(dirname $SCRIPT_PATH)"
cd "$SCRIPT_DIR"

# Install backend (Django) dependencies
echo Checking and installing Django dependencies
pipenv install

# Install frontend (React) dependencies
echo Checking and installing React dependencies
cd frontend
npm install --include=dev --no-audit --fund=false
npm audit --omit=dev
cd ../

# Setup CTRL+C trap
trap ctrl_c INT
ctrl_c () {
	kill %2
	kill %1
	echo 'Exited Properly'
}

# Run django and react
pipenv run django &>django.log &
sh -c 'cd frontend && npm start' &>npm.log &

# Wait until CTL+C
echo Server Running. Goto localhost:3000
echo press CTL+C to stop
read -r -d '' _ </dev/tty