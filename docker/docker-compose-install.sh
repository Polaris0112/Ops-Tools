#!/bin/bash

# download docker-compose
curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  
# change mod
chmod +x /usr/local/bin/docker-compose

