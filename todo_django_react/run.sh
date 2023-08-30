#!/bin/sh

# Check if pipenv exists
if !( type pipenv &> /dev/null )
then
	echo "Missing pipenv"
	exit -1
fi

# Check if npm exists
if !( type npm &> /dev/null )
then
	echo "Missing npm"
	exit -2
fi

# cd into project directory
SCRIPT_PATH="$(readlink -e $0)"
SCRIPT_DIR="$(dirname $SCRIPT_PATH)"
cd "$SCRIPT_DIR"

# Install backend (Django) dependencies
echo Checking and installing Django dependencies
export PIPENV_VENV_IN_PROJECT=1
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
	echo "Exiting"
	jobs -l
	kill -INT $(jobs -p)
	sleep 2
	kill -TERM $(jobs -p)
	wait $(jobs -p)
	echo 'Exited Properly'
}

# Run django and react
pipenv run django &>django.log &
cd frontend
npm start &>npm.log &
cd ../
echo
jobs -l

# Wait until CTL+C
echo Server Running. Goto localhost:3000
echo press CTL+C to stop
read -r -d '' _ </dev/tty
