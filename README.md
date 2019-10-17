# QMake2Fastbuild

*The documentation is still work-in-progress.*

## Aim
Compile Qt Projects with FASTBuild

## Motivation
Based on a Qt project file (*.pro) easily set-up compilation with FASTBuild (http://www.fastbuild.org). Required is a workflow that allows using both Qt Creator as well as Visual Studio as IDEs. Previously, the Qt project file was the basis as `qmake` allows to convert it to a Visual Studio project file. Since FASTBuild only allows conversion to Visual Studio projects and solutions, the Qt project file will still be the basis with tools to convert to the input required for FASTBuild.

The main structure of the *.bff files is borrowed from FASTBuild itself (https://github.com/fastbuild/fastbuild/blob/master/Code/fbuild.bff). This includes subfolders for Visual Studio and Windows SDKs. This structure is extended to include a subfolder for Qt frameworks.

## Compatibility
The initial supported platforms and compilers is quite limited because it is used by the initiator for this specific set-up. However, based on FASTBuild's *.bff files (https://github.com/fastbuild/fastbuild/blob/master/Code) this can be easily expanded to other operating systems and compilers. A few adaptations need to be made, though.
### Target platforms
* Windows

Could be extended to include Linux and Mac OS.

### Compilers
* Visual Studio 2013

FASTBuild has corresponding files for other versions of Visual Studio in their set-up. These have not been tested and need slight adaptations. Our adaption of VS2013.bff can be used as a guide. FASTBuild also has *.bff files for GCC and clang.

### Windows SDKs
* Windows 8.1 SDK

The *.bff files in this repository are set-up to automatically select the Windows 8.1 SDK for Visual Studio 2013. The Windows 10 SDK bff file is already included, but has not been adapted nor been tested.

### Qt Versions
* Qt 5.9.1

Incorporating other Qt versions is one of the most easiest extensions to the FASTBuild set-up. Just take Qt591.bff as template.
