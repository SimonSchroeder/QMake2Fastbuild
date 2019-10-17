echo .Defines = '' > fbuild\defines.bff
grep "^DEFINES" MyProject.pro | sed "s/DEFINES\ +=\ \(.*\)/         + ' -D\1'/" >> fbuild\defines.bff
