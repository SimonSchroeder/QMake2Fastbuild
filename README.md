# QMake2Fastbuild

*The documentation is still work-in-progress.*

## Aim
Compile Qt Projects with FASTBuild

## Motivation
Based on a Qt project file (*.pro) easily set-up compilation with FASTBuild (http://www.fastbuild.org). Required is a workflow that allows using both Qt Creator as well as Visual Studio as IDEs. Previously, the Qt project file was the basis as `qmake` allows to convert it to a Visual Studio project file. Since FASTBuild only allows conversion to Visual Studio projects and solutions, the Qt project file will still be the basis with tools to convert to the input required for FASTBuild.

The main structure of the *.bff files is borrowed from FASTBuild itself (https://github.com/fastbuild/fastbuild/blob/master/Code/fbuild.bff). This includes subfolders for Visual Studio and Windows SDKs. This structure is extended to include a subfolder for Qt frameworks.
