#!/bin/bash

export ANT_OPTS=-Xmx512m

sw/ant/bin/ant -f local.build.xml $*
