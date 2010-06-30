#!/bin/bash

export ANT_OPTS="-Xmx512m -Xms512m -XX:PermSize=512m -XX:MaxPermSize=512m"

sw/ant/bin/ant -f local.build.xml $*
