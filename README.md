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

## Preliminaries
There are two things you need before getting started with the files provided in this repository. First of all, you obviously have to download FASTBuild. Second, the scripts to generate the missing *.bff files need `grep` and `sed` installed. I'll quickly explain how to prepare everything.

### Downloading FASTBuild
1. Download the most recent version of FASTBuild: http://www.fastbuild.org/docs/download.html
1. Extract the executables to a place where they can be found by Windows.
   * Either the the `PATH` environment variable accordingly,
   * Or put the executables into your own projects directory and add them to your projects repository. This is suggested by FASTBuild. The executables do not have any dependencies to any DLLs and can thus be copied to any computer without requiring any set-up.
   
Putting the executables into your project's repository is the preferred method.

### Getting grep and sed
There are certainly many ways to get your hands on `grep` and `sed` for Windows. (Users of other platforms will have them installed already.) The easiest way is to use one of the package managers for Windows, e.g. [Scoop](https://scoop.sh) or [Chocolatey](https://chocolatey.org).

We will explain how to use Scoop for this as it does not need administrative priviledges for installation and the installation process is quite simple.

#### Installing Scoop
They have easy instructions at the bottom of their webpage https://scoop.sh. Here is the gist that should work for most with a current version of Windows installed.
1. Open the PowerShell.
1. Type (or copy)
   ```PowerShell
   Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
   ```
1. If you get an error, set the execution policy:
   ```PowerShell
   Set-ExecutionPolicy RemoteSigned -scope CurrentUser
   ```
   and repeat step 2.
1. You're done.

#### Installing grep and sed using scoop
After installing Scoop this is now quite easy.
1. Open a command prompt.
1. To install `grep` type
   ```cmd
   scoop install grep
   ```
1. To install `sed` type
   ```cmd
   scoop install sed
   ```
1. You're done.

## What you need
We'll shortly explain what you need in order to be able to use the set of tools in this repository. Throughout this explanation and also in the provided files we assume that the project is call `MyProject`. This is something you should replace everywhere.

Initially, we assume the following folder structure:
```bash
{MyProjectDir}/
|-- MyProject.pro   # qmake project file
|-- config.pri      # (optional)
`-- src/            # directory containing everything
    |-- *.cpp       # possibly in subfolders
    |-- *.h         # possibly in subfolders
    |-- *.ui        #         ...
    |-- *.qrc       #         ...
    `-- *           # other files
```
If you don't have a Qt project file yet, you can run `qmake -project` in `{MyProjectDir}/` to generate one with all source files.

Our *.pro file always contains a line
```qmake
exists(config.pri): include(config.pri)
```
to allow local configurations. The `config.pri` is thus not part of the repository. You will encounter the name `config.pri` in `MyProject.bff`, however the scripts will not automatically extract information from that file.

## What you'll get
From this repository you will basically get a bunch of *.bff files (i.e. configuration files for FASTBuild) and a set of script (*.bat batch files for Windows) to generate individual input *.bff files (e.g. with your *.cpp and *.h files in it). In this repository these are put into separate folders `bff` and `scripts`. This is only to have a clean repository here. You need to check out this repository and copy the files over to your project. In the end, you should have the following folder structure:
```bash
{MyProjectDir}/
|-- MyProject.pro                   # your original Qt project file
|-- config.pri                      # (optional)
|-- FBuild.exe                      # (if you copied FASTBuild here)
|-- FBuildWorker.exe                # (if you copied FASTBuild here)
|-- fbuild.bff                      # main configuration file for FASTBuild
|-- MyProject.bff                   # lots of project specific stuff (rename to your project)
|-- src/*                           # all your sources, etc.
|-- fbuild                          # contains some standard FBuild includes (and the cache)
|   |-- Qt
|   |   |-- Qt.bff                  # choose Qt Version in here
|   |   `-- Qt591.bff               # configuration specific to Qt 5.9.1
|   |-- VisualStudio
|   |   |-- VisualStudio.bff        # choose Visual Studio compiler version here
|   |   `-- VS2013.bff              # configuration specific to VS 2013
|   `-- Windows
|       |-- Windows.bff             # choose proper Windows SDK in here
|       |-- Windows81SKD.bff        # configuration specific to Win8.1 SDK
|       `-- Windows10SDK.bff        # tentative configuration for Win10 SDK
|-- generateDefines4Fbuild.bat      # generate preprocessor defines from MyProject.pro
|-- generateIncludes4Fbuild.bat     # generate include paths from MyProject.pro
`-- generateInputFiles4Fbuild.bat   # generate list of all input files from MyProject.pro
```

You should rename `MyProject.bff` according to your own project name. "MyProject" will appear in the following files and needs to be replaced as well:
* `fbuild.bff`
* `MyProject.bff`
* `generateDefines4FBuild.bat`
* `generateIncludes4FBuild.bat`
* `generateInputFiles4Fbuild.bat`
