"""
This script is written for officer use only.
It's not likely to be helpful or intuitive for non-officers, and it may not be entirely stable.

It runs the `gdlint` command (which must be installed before use)
and automatically corrects all issues regarding naming convention.
Other issues are ignored.

The .gdlintrc file is used by this program. It configures the linter, and cannot be moved
"""

import os
import subprocess
import re


def fix_name(wrong_name):
    return re.sub(r'(?<!^)(?=[A-Z])', '_', wrong_name).lower()

def replace_name(file_path, wrong_name_list, corrected_name_list):
    with open(file_path, 'r') as file:
        file_data = file.read()
    
    for (wrong, corrected) in zip(wrong_name_list, corrected_name_list):
        file_data = file_data.replace(wrong, corrected)

    with open(file_path, 'w') as file:
        file.write(file_data)

def get_gdscript_files():
    result = []

    for (root, dirs, files) in os.walk("."):
        root = root.replace("\\", "/")

        # ignore files in the "addon" folder
        if root.startswith("./addons"):
            continue

        for file in files:
            if file.endswith(".gd"):
                file_path = root + "/" + file
                result.append(file_path)
    
    return result

def get_wrong_names(file_path_list):
    wrong_names = []

    for file_path in file_path_list:
        result = subprocess.run("gdlint " + file_path, capture_output=True, text=True)
        if result.returncode == 0: continue # no issues in this file

        problems = result.stderr.splitlines()
        problems.pop() # final value is just "Failure: # problems found"
        for problem in problems:
            # example output:
            # ./file.gd:1: Error: Variable name "xxx" is not valid (variable-name)
            # print(problem)
            given_name = problem.split('"')[1]
            wrong_names.append(given_name)
    
    return wrong_names

def get_wrong_file_names(file_path_list):
    result = []
    for file_path in file_path_list:
        file = file_path.split("/")[-1]
        if file.lower() != file:
            result.append(file)
    return result

if __name__ == "__main__":
    # change working directory to the project folder
    os.chdir(os.path.dirname(__file__))

    # get filepaths of every .gd file in the project
    print("reading files...")
    file_path_list = get_gdscript_files()

    # find all wrong names (by parsing linter output)
    print("linting...")
    wrong_names = get_wrong_names(file_path_list)

    # if nothing's wrong, exit
    if wrong_names == []:
        print("Variable naming finished: nothing to fix :3")
    else:
        # get corrected names
        corrected_names = []
        for wrong_name in wrong_names:
            corrected_names.append(fix_name(wrong_name))

        # print all corrections
        for (wrong, corrected) in zip(wrong_names, corrected_names):
            print(wrong.rjust(30) + " -> " + corrected.ljust(30))
        
        # replace all instances in every file
        print("replacing names...")
        for file_path in file_path_list:
            replace_name(file_path, wrong_names, corrected_names)

        print(f"Variable naming finished: fixed {len(wrong_names)} names :D")

    # Notify wrongly-named files (these aren't fixed automatically)
    wrong_files = get_wrong_file_names(file_path_list)
    if wrong_files == []:
        print("All gdscript files are named correctly.")
    else:
        print(f"But {len(wrong_files)} gdscript files are named incorrectly:")
        for wrong in wrong_files:
            print(" - " + wrong)
    
    print("(note that non-gdscript files are unchecked)")