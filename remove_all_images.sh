#!/bin/sh -x
docker images | grep chefprovisioner  |  awk  ' { print $3 } ' | xargs docker rmi -f
