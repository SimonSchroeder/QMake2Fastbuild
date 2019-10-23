# QMake2Fastbuild

## Aim
Compile Qt Projects with FASTBuild

## Motivation
Based on a Qt project file (*.pro) easily set-up compilation with FASTBuild (http://www.fastbuild.org). Required is a workflow that allows using both Qt Creator as well as Visual Studio as IDEs. Previously, the Qt project file was the basis as `qmake` allows to convert it to a Visual Studio project file. Since FASTBuild only allows conversion to Visual Studio projects and solutions, the Qt project file will still be the basis with tools to convert to the input required for FASTBuild.

The main structure of the *.bff files is borrowed from FASTBuild itself (https://github.com/fastbuild/fastbuild/blob/master/Code/fbuild.bff). This includes subfolders for Visual Studio and Windows SDKs. This structure is extended to include a subfolder for Qt frameworks.

Everything is set-up to support everything FASTBuild offers: pre-compiled headers, caching, distributed builds and unity files.

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
   * Either set the `PATH` environment variable accordingly,
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
* `generateInputFiles4FBuild.bat`

Running `generateDefines4FBuild.bat`, `generateIncludes4FBuild.bat`, and `generateInputFiles4FBuild.bat` generates additional files `fbuild\defines.bff`, `fbuild\includes.bff`, and `fbuild\files.bff`. These are necessary before running FASTBuild on this project for the first time.

## Configuration
Right now, the configuration of this project is still comparatively static. Not everything will be extracted from Qt's *.pro file using the `generate*.bat` scripts. At the top of `fbuild.bff` you will find defines to choose your compiler and Qt version. Below that you can specify if you want to turn on pre-compiled headers (if you have them) and compile as unity files. Right at the beginning of `MyProject.bbf` there are similar options. Here you can easily turn on and off if your project contains any mocable headers, qrc files or has an RC_ICON set up. Furthermore, you can define the names of your pre-compiled headers and the number of unity files.

Let's have a look at what is being compiled. Towards the bottom of `MyProject.bff` you'll find the following:
```fastbuild
    Alias( 'Debug' )           { .Targets = { '$ProjectName$-X64-Debug' } }
    Alias( 'Profile' )         { .Targets = { '$ProjectName$-X64-Profile' } }
    Alias( 'Release' )         { .Targets = { '$ProjectName$-X64-Release' } }
```
This corresponds to Qt's set-up of `Debug`, `Profile`, and `Release` builds. These will be the targets that are easily included in Visuals Studio projects or even Qt Creator. (Also, they are quite easy to type on the command line.) You should note that these are only 64bit targets. Usually, Qt Creator is not configured to provide 32bit builds of the same project. Have a look on FASTBuilds *.bff files for ideas how to support 32bit and 64bit at the same time.

These aliases basically forward to the `Executable` target in `MyProject.bff`. It is defined as follows:
```fastbuild
        Executable( '$ProjectName$-$Platform$-$Config$' )
        {
            .Libraries          =  {  'Objects-$Platform$-$Config$' }
            #if USING_UNITY
                .Libraries      +  { 'NonUnity-Objects-$Platform$-$Config$' }
            #endif
            #if HAS_MOCABLES
                .Libraries      +  { 'Moc-Objects-$Platform$-$Config$' }
            #endif
            #if HAS_QRC_FILES
                .Libraries      +  { 'Qrc-Objects-$Platform$-$Config$' }
            #endif
            #if HAS_RC_ICONS
                .Libraries      +  { 'Windows-Resources-$Platform$-$Config$' }
            #endif

            .LinkerOutput       = '$OutputBase$\$ProjectName$.exe'
        }
```
These targets compile `*.cpp` files as unity files, a few `*.cpp` files not as unity, run `moc` and compile `moc_*.cpp` files, compile `*.qrc` files, and compile Windows resource files, respectively. The last one needs further explanation: If your *.pro file contains the line
```qmake
RC_ICONS = some_icon.ico
```
running `qmake` produces a `MyProject_resource.rc`. For now, you need to copy this file to `fbuild\MyProject_resource.rc` (or change the corresponding line in `MyProject.bff`). If you don't have a Windows resource file remove the target from the `Executable`'s `.Libraries`. You will find the corresponding defines at the top of `MyProject.bff`. Just comment the defines you don't need.

Most configuration takes place at the top of `MyProject.bff`. I have not found an equivalent to Qt's `config.pri` (i.e. an optionally included file) in FASTBuild. So, for now you can just add more preprocessor definitions to `.Defines`. Also, set-ups depending on debug/release builds in Qt project files are not extracted. Therefore, __all__ libraries need to be specified by hand. You will find examples for `.Libs`, `.LibsDebug`, `.LibsProfile`, and `.LibsRelease` in `MyProject.bff`. Adapt these to your own project.

Finally, there is a list of files that should not be build as unity called `.DoNotBuildInUnity`. This is necessary when there are some name collisions between different files (e.g. an independent component which includes a Windows header containing classes with the same name as your own). It could also be helpful to exclude a few `*.cpp` files you are currently working on, such that the other unity files are not always rebuild. For the target `Unity( 'Unity-$Platform$-$Config$' )` you should change the number of `.UnityNumFiles` according to the size of your project. Here's the reasoning to use unity builds: when doing distributed compilation there is virtually no speed-up compiling `*.cpp` files individually. It is therefore necessary to have larger build units, hence unity files. We chose a high number of unity files in order to keep recompiles to a minimum during development.

### Pre-compiled headers
If you do not have pre-compiled headers, you need to turn these off in several places within `MyProject.bff`. Look for `.PCHInputFile` and `.PCHOutputFile` together with the corresponding `.CompilerOptions` within the same target. Just remove these.

By default, `MyProject.bff` is configured to use two different pre-compiled header input files `src/pch.h` and `src/pch4moc.h`. The latter is also reused for non-unity objects. The reason behind this is that FASTBuild requires different `*.pch` files per target. However, all `*.pch` files will later be linked into the exectable. Somehow certain Boost headers clash during linking. Simple solution is to only have Boost headers included in `src/pch.h` and not in `src/pch4moc.h`. Otherwise the two are identical in our project. If you have different names for your pre-compiled headers you need to change them consistently in `MyProject.h`.


## Workflow

Once everything is set-up and configured, we can now start with the regular workflow. As said above you need to configure libraries and their paths by hand. Even Boost non-header libraries most likely need extra linking. Our `*.bff` files still lack 3 additional include files that need to be generated.

### First Run
Before running FASTBuild for the first time you need to run all `generate_*.bat` scripts.
1. `generateDefines4Fbuild.bat` parses `MyProject.pro` for lines that contain `DEFINES +=`. These will be added as variable `.Defines` to the FASTBuild files. The script generates the file `fbuild/defines.bff`.
1. `generateIncludes4Fbuild.bat` parses `MyProject.pro` for lines containing `INCLUDEPATH +=`. These will be added as variable `.Includes` to the FASTBuild files. The script generates the file `fbuild/includes.bff`.
1. `generateInputFiles4Fbuild.bat` is the most extensive script. I looks for `SOURCES`, `HEADERS`, `FORMS`, and `RESOURCES` in `MyProject.pro`. These will be written to `.Sources`, `.Headers`, `.Forms`, and `.Resources`, respectively. Additionally, we need the list of mocable objects, or rather their respective files. Right now, this is done by running `qmake` once on the Qt project file (__note__ the full path for Qt 5.9.1 in this script!) and extracting the information from the generated Makefile. This last step might take a while (compared to the other steps). This is why the scripts are not run automatically from within FASTBuild.

Now, you are ready to run FASTBuild on our set of `*.bff` files (FASTBuild will __always__ look for `fbuild.bff`). Besides all the `*.bff` files you downloaded from this repository, you should also add the generated files `fbuild/defines.bff`, `fbuild/includes.bff`, and `fbuild/files.bff` to your own repository.

### Re-running scripts
Most of the time you do not have to run any of the scripts. If you have a long existing project, chances are that all your `DEFINES` and `INCLUDEPATH`s are properly set-up. Only if you make changes here do you have to re-run the first two scripts. The premise is that you are using (or at least one person in your team) Qt Creator for development. In this case it makes sense to always use the `*.pro` file as basis for changes. If you add new sources to the project, add them in `MyProject.pro`. After that, re-run `generateInputFiles4Fbuild.bat`. Now, your FASTBuild project is also up-to-date. If you are using Visual Studio as IDE, you need to re-run `fbuild solution` or at least `fbuild MyProject-proj` so that everything is discoverable in VS.

### Running FASTBuild
There are many options to running FASTBuild. First of all, there is running FASTBuild from the command line (or e.g. a CI (continuous integration) tool). Then, there is running FASTBuild from an IDE like Qt Creator or Visual Studio. We will have a quick look at all three of them.
1. __Command Line.__ Change to the directory of your project. `fbuild.bff` should be located in this directory. `FBuild.exe` should either also be located in this directory or the `PATH` environment variable needs to be set-up accordingly. Now, you can just run the command `fbuild`. More likely, you want to run a specific target instead of all of the configurations, like `Debug`, `Profile` or `Release`. Here is the command which I prefer: `fbuild Debug -fastcancel -report -summary -dist -cache`
2. __Qt Creator.__ It is possible to configure Qt Creator to use FASTBuild when hitting 'Build' from within the IDE. By default Qt will set-up configuration for Debug, Profile and Release. In the 'Build Steps' Qt Creator will run `qmake` followed by `jom`. The command for 'Clean Steps' is defined as `jom clean`. These commands need to be replaced. Under 'Build steps' we now need a single 'Make' command: `FBuild.exe Debug -cache -fastcancel -dist -ide -monitor -progress -summary` For the 'Clean Steps' I have replaced the command by a 'Custom Process Step' and a 'Make' step. The 'Custom Process Step' is running `generateInputFiles4Fbuild.bat`. FASTBuild actually never requires a true rebuild. Including this script here hijacks rebuilding to reparsing the list of source files. This allows to hit 'Rebuild' when files are added to the project. For the 'Make' step you should set-up the following command `FBuild.exe Debug  -cache -fastcancel -dist -clean -ide -monitor -progress -summary` The set-ups for Profile and Release need to be adapted accordingly. I prefer having `-progress` and `-summary` included, though these are quite unusual for use in an IDE.
1. __Visual Studio.__ This one is quite easy. The FASTBuild configuration contains targets to generate a Visual Studio solution file or optionally only the project file. In order to generate both the solution and the project file, just run `fbuild solution`. In order to generate only the project file run `fbuild MyProject-proj`. The resulting project is already set-up to use FASTBuild. You can just hit 'Build' or 'Rebuild' from within Visual Studio and it will work. No extra set-up is required. You need to regenerate the Visual Studio project file when source files have been added in FASTBuild (e.g. using `gnerateInputFiles4Fbuild.bat`). Otherwise, the files will not appear in the list.

### Using Distributed Builds
All the commands demonstrated above already have the `-dist` option set. So, there is only little configuration required to actually use distributed builds. First of all, you need to set the environment variable `FASTBUILD_BROKERAGE_PATH` on all computers that should participate in distributed builds as well as on the computer issuing the build. The variable needs to point to a network directory that is discoverable by all participating computers. Now, on the build clients start the software `FBuildWorker.exe`. The next build will now use available workers.

As described before, the number of unity files is fine-tuned for distributed builds: `.UnityNumFiles` needs to be small enough such that the unity files are large enough to have enough work to actually gain a speed-up using distributed builds. On the other hand, I prefer a large number of unity files so that during development the unity files are kept comparatively small for fast compiles when there are only small changes to the source code. Also, if you have many worker threads you need enough work for everyone of them.

## Current Restrictions
The current set-up is already quite extensive. It includes all file types which could be used by a Qt project. However, not everything is automated, yet. One of the restrictions is that there is a fixed list of Qt modules. The original `*.pro` file used as template contains the following two lines:
```qmake
QT       += core gui opengl winextras printsupport
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
```
`MyProject.bff` sets the `.Defines` accordingly. Furthermore, in `Qt591.bff` the includes paths and libraries are set-up according to these modules. If your list of modules differs from this, you need to adapt these three places (defines, includes, libraries).

Also, initially the project is set-up to work with Visual Studio 2013 and Qt 5.9.1 together with WinSDK 8.1. Further configurations need to be adapted, but should not have any problems.

One major drawback right now is the `.Environment` at the top of `fbuild.bff`. This was a quick fix for linking. Suggestions for improvement are welcome.
