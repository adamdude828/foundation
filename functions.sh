#!/usr/bin/env bash

runFromHere() {
     #capture current path
     currentPath=$(pwd)

     #move to temp spot
     cd $1

     #run command
     $2

     #go back to old path
     cd "$currentPath"
}