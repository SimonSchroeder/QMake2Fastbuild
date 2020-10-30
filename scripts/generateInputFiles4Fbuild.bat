@echo   Extract SOURCES from MyProject.pro...
@echo .Sources = { > fbuild\files.bff
@sed "1,/SOURCES\ +=\ \\/d" MyProject.pro | sed "/^$/,$d" | sed "s/^\s*\(.*\)\ \\/             '\1',/" | sed "s/^\s*\(.*\)\\/             '\1',/" | sed "s/^\s*\(.*[^,]\)$/             '\1'/" >> fbuild\files.bff
@echo            } >> fbuild\files.bff

@echo   Extract HEADERS from MyProject.pro...
@echo .Headers = { >> fbuild\files.bff
@sed "1,/HEADERS\ +=\ \\/d" MyProject.pro | sed "/^$/,$d" | sed "s/^\s*\(.*\)\ \\/             '\1',/" | sed "s/^\s*\(.*\)\\/             '\1',/" | sed "s/^\s*\(.*[^,]\)$/             '\1'/" >> fbuild\files.bff
@echo            } >> fbuild\files.bff

@echo   Extract FORMS from MyProject.pro...
@echo .Forms   = { >> fbuild\files.bff
@sed "1,/FORMS\ +=\ \\/d" MyProject.pro | sed "/^$/,$d" | sed "s/^\s*\(.*\)\ \\/             '\1',/" | sed "s/^\s*\(.*\)\\/             '\1',/" | sed "s/^\s*\(.*[^,]\)$/             '\1'/" >> fbuild\files.bff
@echo            } >> fbuild\files.bff

@echo   Extract RESOURCES from MyProject.pro...
@echo .Resources={ >> fbuild\files.bff
@sed "1,/RESOURCES\ +=\ \\/d" MyProject.pro | sed "/^$/,$d" | sed "s/^\s*\(.*\)\ \\/             '\1',/" | sed "s/^\s*\(.*\)\\/             '\1',/" | sed "s/^\s*\(.*[^,]\)$/             '\1'/" >> fbuild\files.bff
@echo            } >> fbuild\files.bff

@cd fbuild
@mkdir tmp_qmake
@cd tmp_qmake
@echo   Creating dummy project...
@call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\vc\Auxiliary\Build\vcvars64.bat"
@C:\Qt\5.9.1\msvc2013_64\bin\qmake.exe ..\..\MyProject.pro
@echo   Find MOCables...
@echo .Mocables= { >> ..\files.bff
@grep "moc.exe $(DEFINES)" Makefile.Release | sed "s/^.*\ \.\.[\\\/]\.\.[\\\/]\(.*\)\ -o\ .*moc_.*cpp$/\1/" | sed "s/\\/\//g" | sed "s/^/             '/" | sed "s/$/',/" | sed "$,$s/,//" >> ..\files.bff
@echo            } >> ..\files.bff
@echo   Cleaning up...
@cd ..
@rmdir /S /Q tmp_qmake
@cd ..

