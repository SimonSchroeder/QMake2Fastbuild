echo .Includes = { > fbuild\includes.bff
grep "^INCLUDEPATH" MyProject.pro | sed "s/INCLUDEPATH\ +=\ \(.*\)/              '\1',/" | sed "$,$s/,//" >> fbuild\includes.bff
echo             } >> fbuild\includes.bff
