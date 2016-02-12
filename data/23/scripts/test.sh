#!/bin/bash

2&>1

exec 1> tee file.txt
