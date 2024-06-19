#!/bin/bash
rm -r dist
# Check if twine and setuptools are installed
if ! python3 -c "import twine" &> /dev/null; then
    echo "twine not found, installing..."
    pip install twine
fi

if ! python3 -c "import setuptools" &> /dev/null; then
    echo "setuptools not found, installing..."
    pip install setuptools
fi

# Build the package
python3 setup.py sdist

# Upload the package to PyPI
twine upload --repository-url https://upload.pypi.org/legacy/ -u __token__ -p $PYPI_TOKEN dist/*
