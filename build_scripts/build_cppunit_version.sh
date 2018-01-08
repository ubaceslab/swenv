#!/bin/bash

# TA: starting with 1.14.0, the 'cppunit-config' file is removed
# and libmesh/GRINS can no longer link with CPPUnit properly
CPPUNIT_VERSION=1.13.2

./build_cppunit.sh $CPPUNIT_VERSION
