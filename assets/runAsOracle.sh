#!/bin/bash

echo oracle | su - oracle -c "$1" 2>/dev/null
