date "+Compiled: %Y/%m/%d %H:%M:%S" > version.txt
rm ../Input-Test-iPad-12.0.love
zip -9 -r -x\.git/* ../Input-Test-iPad-12.0.love .
