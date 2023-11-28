#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Script Name: oncall.py
Author:  Cardondev
Created: 28 November 2023
Last Modified By: Cardondev
Last Modified: 11/28/2023
Version: v1.0

Description: This script is intended to generate a quick on-call calendar based on 1 or 2 week rotations.

Revision History:
    Date     - Author's Name        - Version - Changes Made
    11/28/23 - Cardondev             - v1.0    - Created  

"""
from datetime import datetime, timedelta

# Function to get the user-inputted list of team members
def get_team_members():
    members_input = input("Enter team members' names, separated by a comma: ")
    members = [member.strip() for member in members_input.split(',')]
    return members

# Function to get the on-call persons for a given date
def get_on_call_members(date, rotation_length, team_members):
    # Adjust the cycle number based on the rotation length
    cycle_number = (date.isocalendar()[1] - 1) // rotation_length

    # Determine the primary and secondary on-call members
    primary_index = cycle_number % len(team_members)
    secondary_index = (primary_index + 1) % len(team_members)

    return team_members[primary_index], team_members[secondary_index]

# Get team members from user input
team_members = get_team_members()
if not team_members:
    print("No team members entered. Exiting program.")
    exit()

# Ask user for the start date
start_date_input = input("Enter the start date (YYYY-MM-DD): ")
start_date = datetime.strptime(start_date_input, '%Y-%m-%d')

# Ask user for the rotation length (1 or 2 weeks)
rotation_length = int(input("Enter the rotation length in weeks (1 or 2): "))

# Ask user for the number of weeks they want to display
number_of_weeks = int(input("Enter the number of weeks to display: "))

# Output the on-call members for the specified number of weeks
for i in range(number_of_weeks):
    week_start = start_date + timedelta(weeks=i)
    primary_on_call, secondary_on_call = get_on_call_members(week_start, rotation_length, team_members)
    print(f"Week starting {week_start.strftime('%Y-%m-%d')}: Primary - {primary_on_call}, Secondary - {secondary_on_call}")
