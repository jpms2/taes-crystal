#!/bin/bash
a=$1; a="${a#*/}";a="${a#*/}";a="${a#*/}";a="${a#*/}"
cd "${a%.*}"
git stash
git checkout $2
