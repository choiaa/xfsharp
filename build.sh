#!/usr/bin/env bash

currentDirectory="$( cd "$( dirname "$0" )" && pwd )"
toolsDirectory=$currentDirectory/tools
nugetDirectory=$toolsDirectory/nuget
nugetExe=$nugetDirectory/nuget.exe
fakeExe=$toolsDirectory/FAKE/tools/FAKE.exe
nunitFrameworkDll=$toolsDirectory/NUnit/lib/net45/nunit.framework.dll
nunitConsoleExe=$toolsDirectory/NUnit.ConsoleRunner/tools/nunit3-console.exe

if test ! -d $nugetDirectory; then
    mkdir -p $nugetDirectory
fi

if test ! -f $nugetExe; then
    nugetUrl="https://dist.nuget.org/win-x86-commandline/v3.3.0/nuget.exe"
    wget -O $nugetExe $nugetUrl 2> /dev/null || curl -o $nugetExe --location $nugetUrl /dev/null
    
    if test ! -f $nugetExe; then
        echo "Could not find nuget.exe"
        exit 1
    fi
    
    chmod 755 $nugetExe
fi

mono $nugetExe install FAKE -Version 4.28.0 -ExcludeVersion -OutputDirectory $toolsDirectory
if test ! -f $fakeExe; then
	echo "Could not find fake.exe"
    exit 1
fi

mono $nugetExe install NUnit -Version 3.2.1 -ExcludeVersion -OutputDirectory $toolsDirectory
if test ! -f $nunitFrameworkDll; then
	echo "Could not find nunit.framework.dll"
    exit 1
fi

mono $nugetExe install NUnit.ConsoleRunner -Version 3.2.1 -ExcludeVersion -OutputDirectory $toolsDirectory
if test ! -f $nunitConsoleExe; then
	echo "Could not find nunit3-console.exe"
    exit 1
fi

# Use FAKE to execute the build script
mono $fakeExe build.fsx default -ev encoding utf-8