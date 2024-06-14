import toml
import sys
import requests

def main():
    # Load the pyproject.toml file
    data = toml.load(open("pyproject.toml"))

    # Get the current version
    current_version = data["project"]["version"]

    # Check if the version is already published
    response = requests.get(f"https://pypi.org/pypi/find-and-replace-strings/{current_version}/json")

    if response.status_code == 200:
        print("This version is already published. Please bump the version in pyproject.toml.")
        sys.exit(1)

if __name__ == "__main__":
    main()