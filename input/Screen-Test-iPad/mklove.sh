date "+Compiled: %Y/%m/%d %H:%M:%S" > version.txt
rm ../Screen-Test-iPad-12.0.love
zip -9 -r -x\.git/* ../Screen-Test-iPad-12.0.love .
