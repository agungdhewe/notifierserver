@echo off
setlocal enabledelayedexpansion

set PORT=8080

REM Baca PORT dari file .env jika ada
if exist .env (
    for /f "usebackq tokens=1,2 delims==" %%A in (".env") do (
        set "KEY=%%A"
        set "VAL=%%B"
        REM Hilangkan spasi
        for /f "tokens=* delims= " %%k in ("!KEY!") do set "KEY=%%k"
        for /f "tokens=* delims= " %%v in ("!VAL!") do set "VAL=%%v"
        if /i "!KEY!"=="PORT" set "PORT=!VAL!"
    )
)

echo Memeriksa port %PORT%...

REM Cari dan matikan proses yang mendengarkan di PORT tersebut
for /f "tokens=5" %%a in ('netstat -aon ^| findstr /r /c:":%PORT%[ ]\+" ^| findstr /i "LISTENING"') do (
    set "PID=%%a"
    if defined PID (
        if not "!PID!"=="0" (
            echo Mematikan proses dengan PID: !PID! pada port %PORT%...
            taskkill /F /PID !PID! >nul 2>&1
        )
    )
)

npm run start