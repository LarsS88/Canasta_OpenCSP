#!/bin/bash
cd `dirname $0`
printf "uglifyjs urlfixer.js -c|sed -i \"$(grep -n . urlfixer.php|sed -n 's/^\([0-9]*\):<script.*/\1/p')r/dev/stdin\" urlfixer.php\n"|sh