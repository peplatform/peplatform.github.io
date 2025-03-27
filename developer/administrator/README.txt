Start with the Microsoft Windows Vista SDK & DDK (Subscription Only)

Update Ztools from XP SP3 Source and build it first and create a developer->administraor->sdktools directory.

Set the Vista build environment first witout making a new razzle. setenv /debug /x86 /vista

The Windows Research Kernel Builds for Microsoft Windows Vista without problem.

:: --------------------------------------------------------------------------------------------
:: File    : SetEnv.cmd
::
:: Abstract: This batch file sets the appropriate environment
::           variables for the Windows SDK build environment with
::           respect to OS and platform type.
::
:: "Usage Setenv [/Debug | /Release][/x86 | /x64 | /ia64][/vista | /xp | /2003 ][-h] "
::
::                /Debug   - Create a Debug configuration build environment
::                /Release - Create a Release configuration build environment
::                /x86     - Create 32-bit x86 applications
::                /x64     - Create 64-bit x64 applications
::                /ia64    - Create 64-bit ia64 applications
::                /vista   - Windows Vista applications
::                /xp      - Create Windows XP SP2 applications
::                /2003    - Create Windows Server 2003 applications
::
:: --------------------------------------------------------------------------------------------

Add sdkdiff from the samples your 'sdktools' directory in your environment and start updating tools.

 