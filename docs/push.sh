#!/bin/bash

git add .
read -p 'Please enter commit message: ' message
git commit -m $message
git push origin master
