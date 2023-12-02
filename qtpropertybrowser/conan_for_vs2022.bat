
@echo off
setlocal

set "folderToCheck=./build_for_vs2022"

rmdir /s /q "%folderToCheck%" 2>nul

rem check
if exist "%folderToCheck%" (
    echo "%folderToCheck%" still exist, goto :eof
    
    pause
    goto :eof
) else (
    echo "%folderToCheck%" not exist
)

rem conan profile detect --force
conan install . --output-folder=./build_for_vs2022 --profile=default --build=missing -s build_type=Debug -s compiler.cppstd=23
conan install . --output-folder=./build_for_vs2022 --profile=default --build=missing -s build_type=Release -s compiler.cppstd=23
cmake --preset conan-default

cd ./build_for_vs2022
rem cmake .. -G"Visual Studio 17 2022 Win64" -DCMAKE_CONFIGURATION_TYPES="Release;Debug"
rem https://github.com/conan-io/conan/issues/13750
rem -DCMAKE_CONFIGURATION_TYPES="Release;Debug"
cmake .. -G "Visual Studio 17 2022" -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake 
rem cmake --build build/Release --config Release

cd ..
set "scriptPath=%~dp0"
echo %scriptPath%
set "scriptPath=%scriptPath:~0,-1%"
for %%I in ("%scriptPath%") do set "folderName=%%~nI"

set sln="%folderName%.sln"
echo %sln%

set "linkName=%sln%"
set "targetFile=build_for_vs2022\%sln%"

echo link: %linkName% to %targetFile%
mklink %linkName% "%targetFile%"

start "" "%linkName%"


pause

