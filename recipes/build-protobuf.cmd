@echo off
setlocal
cd /d "%~dp0"
call "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 -vcvars_ver=14.16
if errorlevel 1 exit /b 1
set "PB_CMAKE=C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
"%PB_CMAKE%" -S "%~dp0deps\protobuf-3.1.0\cmake" -B "%~dp0build\protobuf" -G "NMake Makefiles" -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_BUILD_SHARED_LIBS=OFF -Dprotobuf_MSVC_STATIC_RUNTIME=OFF -Dprotobuf_WITH_ZLIB=OFF "-DCMAKE_INSTALL_PREFIX=%~dp0deps\protobuf-3.1.0-v141"
if errorlevel 1 exit /b 1
"%PB_CMAKE%" --build "%~dp0build\protobuf"
if errorlevel 1 exit /b 1
"%PB_CMAKE%" --install "%~dp0build\protobuf"
if errorlevel 1 exit /b 1
"%~dp0deps\protobuf-3.1.0-v141\bin\protoc.exe" --version
if errorlevel 1 exit /b 1
if not exist "%~dp0deps\protobuf-3.1.0-v141\lib\libprotobuf.lib" exit /b 1
echo Protobuf build and installation completed.
exit /b 0
