// Copyright © 1996 Joseph J. Graf

// Include the windows service stuff
#include <winsvc.h>

// This function must be filled in by the application that is using these
// generic service functions
bool CreateChildrenThreads(void);

BOOL SendStatusToSCM(DWORD dwCurrentState,DWORD dwWin32ExitCode, 
	DWORD dwServiceExitCode,DWORD dwCheckPoint,DWORD dwWaitHint);

typedef struct tagSERVICE_DATA
{
	TCHAR szServiceName[MAX_PATH];
	HANDLE hTerminate;
	SERVICE_STATUS_HANDLE hServiceStatus;
	HWND hMainWnd;
	DWORD dwCurrentState;
} SERVICE_DATA;