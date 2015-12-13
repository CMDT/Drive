# Python script for creating text licence files as child windows for settings App. writes Acknowledgement.plist

# J A. Howell 13/12/15
# DRIVE
# licence.py

import os
import sys
import plistlib
from copy import deepcopy

os.chdir(sys.path[0])

plist = {'PreferenceSpecifiers': [], 'StringsTable': 'Acknowledgements'}
base_group = {'Type': 'PSGroupSpecifier', 'FooterText': '', 'Title': ''}

for filename in os.listdir("."):
    if filename.endswith(".licence"):
        current_file = open(filename, 'r')
        group = deepcopy(base_group)
        title = filename.split(".licence")[0]
        group['Title'] = title
        group['FooterText'] = current_file.read()
        plist['PreferenceSpecifiers'].append(group)
        
        plistlib.writePlist(
                            plist,"Acknowledgements.plist"
                            )