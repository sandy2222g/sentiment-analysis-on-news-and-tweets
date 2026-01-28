#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "Starting Python API on port 5000..."

# Try to activate virtual environment if it exists in the current dir
if [ -d "venv" ]; then
    echo "Activating Python virtual environment (venv)..."
    source venv/bin/activate
elif [ -d ".venv" ]; then
    echo "Activating Python virtual environment (.venv)..."
    source .venv/bin/activate
fi

# Run backend
python3 -m uvicorn main:app --host 0.0.0.0 --port 5000 --reload &
PYTHON_PID=$!

sleep 3

echo "Starting Ruby Frontend on port 3000..."
# Run frontend
ruby final.rb &
RUBY_PID=$!

echo "Both servers are running:"
echo " - Python API on http://localhost:5000"
echo " - Ruby Frontend on http://localhost:3000"

trap "echo Stopping...; kill $PYTHON_PID; kill $RUBY_PID; exit" INT

wait

