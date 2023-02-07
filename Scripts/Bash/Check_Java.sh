#!/bin/bash

# Check if Java is installed
if type -p java; then
    echo "Java is installed."
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    echo "Java is installed."
    _java="$JAVA_HOME/bin/java"
else
    echo "Java is NOT installed."
    exit 1
fi

# Get Java version
java_version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
echo "Java version: $java_version"

# Get Java location
java_location=$(readlink -f "$_java")
echo "Java location: $java_location"

# Write output to screen and to file
{
    echo "Java version: $java_version"
    echo "Java location: $java_location"
} | tee /tmp/java_info.out
