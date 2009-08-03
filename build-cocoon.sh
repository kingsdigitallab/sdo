#!/bin/bash

export ANT_OPTS=-Xmx512m

tools/ant/bin/ant -f buildconf/cocoon/build-cocoon.xml $*
