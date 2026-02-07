// Copyright © 1996 Joseph J. Graf
// This file contains the functions necessary to build a NT service


#include "stdafx.h"
#include <winsvc.h>
#include <WINUSER.H>

#include "Service.h"

// Yucky global data stuff
SERVICE_DATA sdServiceData;

/***************************************************************************
* Function:	SendStatusToSCM()
* Author:	Joe Graf
* Date:		11/13/96
* Args:		<DWORD> dwCurrentState - the current state of the service
*			<DWORD> dwWin32ExitCode - the Win32 exit code to use
*			<DWORD> dwServiceExitCode - the service related exit code
*			<DWORD> dwCheckPoint - the
* Purpose:	This is the entry point for the SCM to start the service.
***************************************************************************/

BOOL SendStatusToSCM(DWORD dwCurrentState,DWORD dwWin32ExitCode, 
	DWORD dwServiceExitCode,DWORD dwCheckPoint,DWORD dwWaitHint)
{
	SERVICE_STATUS Status;
	// Fill in all of the SERVICE_STATUS fields
	Status.dwServiceType = SERVICE_WIN32_OWN_PROCESS;
	Status.dwCurrentState = dwCurrentState;
	// If in the process of something, then accept
	// no control events, else accept anything
	if (dwCurrentState == SERVICE_START_PENDING)
		Status.dwControlsAccepted = 0;
	else
		Status.dwControlsAccepted = SERVICE_ACCEPT_STOP |
			SERVICE_ACCEPT_PAUSE_CONTINUE | SERVICE_ACCEPT_SHUTDOWN;
	// If a specific exit code is defines, set up
	// the win32 exit code properly
	if( dwServiceExitCode == 0 )
		Status.dwWin32ExitCode = dwWin32ExitCode;
	else
		Status.dwWin32ExitCode = ERROR_SERVICE_SPECIFIC_ERROR;
	Status.dwServiceSpecificExitCode = dwServiceExitCode;
	Status.dwCheckPoint = dwCheckPoint;
	Status.dwWaitHint = dwWaitHint;
	// Pass the status record to the SCM
	return SetServiceStatus(sdServiceData.hServiceStatus,&Status);
}

/***************************************************************************
* Function:	ServiceCtrlHandler()
* Author:	Joe Graf
* Date:		11/13/96
* Args:		<DWORD> dwControl - the command code from the SCM
* Purpose:	This is the entry point for the SCM to start the service.
***************************************************************************/

void ServiceCtrlHandler(DWORD dwControl) 
{
	switch( dwControl )
	{
		// There is no START option because
		// ServiceMain gets called on a start

		// Stop the service
		case SERVICE_CONTROL_STOP:
		{
			sdServiceData.dwCurrentState = SERVICE_STOPPED;
			SetEvent(sdServiceData.hTerminate);
			break;
		}
		// Pause the service
		case SERVICE_CONTROL_PAUSE:
		{
			sdServiceData.dwCurrentState = SERVICE_PAUSED;
			break;
		}
		// Resume from a pause
		case SERVICE_CONTROL_CONTINUE:
		{
			sdServiceData.dwCurrentState = SERVICE_RUNNING;
			break;
		}
		// Update current status
		case SERVICE_CONTROL_INTERROGATE:
		default:
			// it will fall to bottom and send status
			break;
	}
	SendStatusToSCM(sdServiceData.dwCurrentState,NO_ERROR,0,0,0);
}

/***************************************************************************
* Function:	ServiceMain()
* Author:	Joe Graf
* Date:		11/13/96
* Args:		<DWORD> ignored
*			<LPTSTR*> ignored
* Purpose:	This is the entry point for the SCM to start the service.
***************************************************************************/

UINT ServiceMain(DWORD,LPTSTR*)
{
	// Tell the SCM about our control handler function
	if( (sdServiceData.hServiceStatus = RegisterServiceCtrlHandler(
		sdServiceData.szServiceName,
		(LPHANDLER_FUNCTION)ServiceCtrlHandler)) == FALSE )
	{
#ifdef _DEBUG
		MessageBox(NULL,TEXT("Couldn't register service control function"),
			TEXT("Startup Error"),MB_OK | 0x00200000L);
#endif
		return GetLastError();
	}
	// We must regularly post status to the SCM or it will kill us
	DWORD dwState = 1;
	SendStatusToSCM(SERVICE_START_PENDING,NO_ERROR,0,dwState++,5000);
	// Try to create the terminate handle
	if( (sdServiceData.hTerminate = CreateEvent(NULL,TRUE,FALSE,NULL)) ==
		NULL )
	{
#ifdef _DEBUG
		MessageBox(NULL,TEXT("Couldn't create the event"),
			TEXT("Startup Error"),MB_OK | 0x00200000L);
#endif
		return GetLastError();
	}
	SendStatusToSCM(SERVICE_START_PENDING,NO_ERROR,0,dwState++,5000);
	// Create the children threads that are the heart of the service
	// NOTE: This function must be filled in by the user of these generic
	// service routines
	if( CreateChildrenThreads() == true )
	{
		SendStatusToSCM(SERVICE_RUNNING,NO_ERROR,0,0,0);
		sdServiceData.dwCurrentState = SERVICE_RUNNING;
		// Do nothing but wait for the die event
		WaitForSingleObject(sdServiceData.hTerminate,INFINITE);
	}
	else
	{
		// There was an error so make sure that everything knows it is
		// time to die
		SetEvent(sdServiceData.hTerminate);
	}
	// Tell the SCM that we are going away
	SendStatusToSCM(SERVICE_STOPPED,NO_ERROR,0,0,0);
	// Tell the UI that it should also die
	PostMessage(sdServiceData.hMainWnd,WM_CLOSE,0,0);
	// Clean up
	CloseHandle(sdServiceData.hTerminate);
	sdServiceData.hTerminate = NULL;
	return 0;
}

/***************************************************************************
* Function:	StartServiceThread()
* Author:	Joe Graf
* Date:		11/13/96
* Args:		<LPVOID> ignored
* Returns:	<UINT> the exit code of the thread. 0 if OK non-zero if error
* Purpose:	Calls into the SCM telling it that it is OK to start the service
***************************************************************************/

UINT StartServiceThread(LPVOID)
{
	// Empty the SERVICE_DATA structure
	ZeroMemory(&sdServiceData,sizeof(SERVICE_DATA));
	sdServiceData.hMainWnd = AfxGetMainWnd()->m_hWnd;
	// Get the service name
	CString strAppName;
	if( strAppName.LoadString(AFX_IDS_APP_TITLE) == FALSE )
		return TRUE;
	// Copy the data into the SERVICE_DATA structure
	lstrcpy(sdServiceData.szServiceName,strAppName);
	// Build the service table
	SERVICE_TABLE_ENTRY steServiceTable[] = 
	{ 
		{
			(TCHAR*)(LPCTSTR)strAppName,
			(LPSERVICE_MAIN_FUNCTION)ServiceMain
		},
		{
			NULL,
			NULL
		}
	};
	// Register with the SCM
	return StartServiceCtrlDispatcher(steServiceTable) == FALSE;
}