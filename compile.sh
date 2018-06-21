#!/bin/bash

# So we can see what we're doing
set -x

# Setup bikeshed. See https://tabatkins.github.io/bikeshed/#install-linux
git clone https://github.com/tabatkins/bikeshed.git
pip install --editable $PWD/bikeshed
bikeshed update

# Check out the master branch of the spec
(cd out;
git checkout master
# Run bikeshed and save the output.  You can use this output as is
# to update expected-errs.txt.
bikeshed --print=plain -f spec 2>&1 | tee bs.log
# Remove the line numbers from the log, and make sure it ends with a
# newline.
sed 's;^LINE [0-9]*:;LINE:;' bs.log | sed -e '$a\' > actual-errs.txt
# Do the same for the expected errors and compare the two.  Any
# differences need to be fixed.
sed 's;^LINE [0-9]*:;LINE:;' expected-errs.txt | sed -e '$a\' | diff -u - actual-errs.txt
)