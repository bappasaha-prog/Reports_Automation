@echo off
setlocal enabledelayedexpansion

:: Ask for the full paths of parent XML files (multiple, space-separated)
echo Enter the full paths of the parent XML files (separated by space):
set /p "PARENT_XMLS="

:: Check if user has entered at least one file
if "%PARENT_XMLS%"=="" (
    echo ERROR: You must provide at least one XML file path.
    pause
    exit /b
)

:: Set the Exago base folder path
set "EXAGO_BASE=C:\Program Files\Exago"

:: Loop through each XML file provided
for %%F in (%PARENT_XMLS%) do (
    :: Validate if the XML file exists
    if not exist "%%F" (
        echo ERROR: The file "%%F" does not exist.
    ) else (
        echo Processing file: %%F

        :: Extract the XML file name (e.g., 202500103.xml)
        for %%A in ("%%F") do set "XML_NAME=%%~nxA"

        echo Looking for -Scheduler folders in "%EXAGO_BASE%"

        :: Loop through the folders matching *-Scheduler
        for /D %%S in ("%EXAGO_BASE%\*-Scheduler") do (
            set "CONFIG_FOLDER=%%S\Config"

            if exist "!CONFIG_FOLDER!" (
                echo Copying "%%F" to "!CONFIG_FOLDER!\!XML_NAME!"
                copy /Y "%%F" "!CONFIG_FOLDER!\!XML_NAME!" >nul

                if errorlevel 1 (
                    echo ERROR: Failed to copy to "!CONFIG_FOLDER!\!XML_NAME!"
                ) else (
                    echo SUCCESS: Copied to "!CONFIG_FOLDER!\!XML_NAME!"
                )
            ) else (
                echo Skipped: Config folder not found in "%%S"
            )
        )

        :: Also update ExagoScheduler folder
        set "EXAGO_SCHEDULER_FOLDER=%EXAGO_BASE%\ExagoScheduler\Config"
        if exist "!EXAGO_SCHEDULER_FOLDER!" (
            echo Copying "%%F" to "!EXAGO_SCHEDULER_FOLDER!\!XML_NAME!"
            copy /Y "%%F" "!EXAGO_SCHEDULER_FOLDER!\!XML_NAME!" >nul

            if errorlevel 1 (
                echo ERROR: Failed to copy to "!EXAGO_SCHEDULER_FOLDER!\!XML_NAME!"
            ) else (
                echo SUCCESS: Copied to "!EXAGO_SCHEDULER_FOLDER!\!XML_NAME!"
            )
        ) else (
            echo Skipped: ExagoScheduler config folder not found
        )
    )
)

echo Done processing all parent XML files.
pause