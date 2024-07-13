#!/bin/sh
cd ${STEAMAPPDIR}/Headless/net8.0/

if [ $ALLOWMODS -eq 1 ] then
    exec dotnet Resonite.dll -LoadAssembly Libraries/ResoniteModLoader.dll -HeadlessConfig /Config/Config.json -Logs /Logs
else
    exec dotnet Resonite.dll -HeadlessConfig /Config/Config.json -Logs /Logs
fi