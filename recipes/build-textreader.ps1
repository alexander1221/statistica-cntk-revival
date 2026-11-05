$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$env:BOOST_INCLUDE_PATH = 'C:\CNTK\deps\boost_1_60_0'
$env:BOOST_LIB_PATH = 'C:\CNTK\deps\boost_1_60_0\stage\lib'
$env:MSMPI_INC = 'C:\Program Files (x86)\Microsoft SDKs\MPI\Include'
$env:MSMPI_LIB64 = 'C:\Program Files (x86)\Microsoft SDKs\MPI\Lib\x64'
$env:MKL_PATH = Join-Path $PSScriptRoot 'deps\mklml_win_2018.0.3.20180406'
$env:PROTOBUF_PATH = Join-Path $PSScriptRoot 'deps\protobuf-3.1.0-v141'
$env:LIB = (Join-Path $PSScriptRoot 'build\out') + ';' + $env:LIB
$buildArgs = @(
'C:\CNTK\git-src\Source\Readers\CNTKTextFormatReader\CNTKTextFormatReader.vcxproj'
'/t:Build'
'/p:Configuration=Release_CpuOnly'
'/p:Platform=x64'
'/p:PlatformToolset=v141'
'/p:WindowsTargetPlatformVersion=10.0.26100.0'
'/p:SolutionDir=C:\CNTK\git-src\'
'/p:CNTK_ENABLE_ASGD=false'
'/p:BuildProjectReferences=false'
('/p:ForceImportAfterCppTargets=' + (Join-Path $PSScriptRoot 'workspace-link.targets'))
('/p:OutDir=' + (Join-Path $PSScriptRoot 'build\out\'))
('/p:IntDir=' + (Join-Path $PSScriptRoot 'build\textreader\'))
'/m:2'
'/nr:false'
'/v:minimal'
'/fl'
('/flp:logfile=' + (Join-Path $PSScriptRoot 'logs\textreader_build.log') + ';verbosity=normal')
)
& 'C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\MSBuild\Current\Bin\MSBuild.exe' @buildArgs
if ($LASTEXITCODE -eq 0 -and !(Test-Path (Join-Path $PSScriptRoot 'build\out\Cntk.Deserializers.TextFormat-2.7.dll'))) { throw 'Text reader DLL was not created; check missing dependencies in the build log.' }
Write-Host "Exit code: $LASTEXITCODE"
exit $LASTEXITCODE






