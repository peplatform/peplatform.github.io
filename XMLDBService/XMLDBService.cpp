// XMLDBService.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "XMLDBService.h"

#include "MainFrm.h"
#include "XMLDBServiceDoc.h"
#include "XMLDBServiceView.h"

#include "Service.h"

#include "CDirThread.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

// For use throughout the service
extern SERVICE_DATA sdServiceData;

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceApp

BEGIN_MESSAGE_MAP(CXMLDBServiceApp, CWinApp)
	//{{AFX_MSG_MAP(CXMLDBServiceApp)
	ON_COMMAND(ID_APP_ABOUT, OnAppAbout)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
	// Standard file based document commands
	ON_COMMAND(ID_FILE_NEW, CWinApp::OnFileNew)
	ON_COMMAND(ID_FILE_OPEN, CWinApp::OnFileOpen)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceApp construction

CXMLDBServiceApp::CXMLDBServiceApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CXMLDBServiceApp object

CXMLDBServiceApp theApp;

// This identifier was generated to be statistically unique for your app.
// You may change it if you prefer to choose a specific identifier.

// {C1C64C76-D478-11D1-8675-006097256F38}
static const CLSID clsid =
{ 0xc1c64c76, 0xd478, 0x11d1, { 0x86, 0x75, 0x0, 0x60, 0x97, 0x25, 0x6f, 0x38 } };

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceApp initialization

BOOL CXMLDBServiceApp::InitInstance()
{
	// Initialize OLE libraries
	if (!AfxOleInit())
	{
		AfxMessageBox(IDP_OLE_INIT_FAILED);
		return FALSE;
	}

	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	// Change the registry key under which our settings are stored.
	// You should modify this string to be something appropriate
	// such as the name of your company or organization.
	SetRegistryKey(_T("Local AppWizard-Generated Applications"));

	LoadStdProfileSettings(0);  // Load standard INI file options (including MRU)

	// Register the application's document templates.  Document templates
	//  serve as the connection between documents, frame windows and views.

	CSingleDocTemplate* pDocTemplate;
	pDocTemplate = new CSingleDocTemplate(
		IDR_MAINFRAME,
		RUNTIME_CLASS(CXMLDBServiceDoc),
		RUNTIME_CLASS(CMainFrame),       // main SDI frame window
		RUNTIME_CLASS(CXMLDBServiceView));
	AddDocTemplate(pDocTemplate);

	// Connect the COleTemplateServer to the document template.
	//  The COleTemplateServer creates new documents on behalf
	//  of requesting OLE containers by using information
	//  specified in the document template.
	m_server.ConnectTemplate(clsid, pDocTemplate, TRUE);
		// Note: SDI applications register server objects only if /Embedding
		//   or /Automation is present on the command line.

	// Parse command line for standard shell commands, DDE, file open
	CCommandLineInfo cmdInfo;
	ParseCommandLine(cmdInfo);

	// Check to see if launched as OLE server
	if (cmdInfo.m_bRunEmbedded || cmdInfo.m_bRunAutomated)
	{
		// Register all OLE server (factories) as running.  This enables the
		//  OLE libraries to create objects from other applications.
		COleTemplateServer::RegisterAll();

		// Application was run with /Embedding or /Automation.  Don't show the
		//  main window in this case.
		return TRUE;
	}

	// When a server application is launched stand-alone, it is a good idea
	//  to update the system registry in case it has been damaged.
	m_server.UpdateRegistry(OAT_DISPATCH_OBJECT);
	COleObjectFactory::UpdateRegistryAll();

	// Are we running as a service or from the command line
	bool bAsService = true;
	// Determine if the user wants to install or remove the service
	if( _tcsicmp(m_lpCmdLine,_T("-install")) == 0 )
	{
		InstallService();
		return FALSE;
	}
	else if( _tcsicmp(m_lpCmdLine,_T("-remove")) == 0 )
	{
		RemoveService();
		return FALSE;
	}
	else if( _tcsicmp(m_lpCmdLine,_T("-noservice")) == 0 )
	{
		bAsService = false;
	}
	// Open the display
	OnFileNew();

	// Only go through the service start up routines if this is not being
	// run interactively
	if( bAsService == true )
	{
		// Start the service's thread
		UINT StartServiceThread(LPVOID);
		AfxBeginThread(StartServiceThread,NULL);
		// The one and only window has been initialized, so show and update it.
		m_pMainWnd->ShowWindow(SW_SHOW);
		m_pMainWnd->UpdateWindow();
	}
	else
	{
		// Set the window handle of the main window of the UI thread
		sdServiceData.hMainWnd = AfxGetMainWnd()->m_hWnd;
		// Create the event since the service thread won't
		if( (sdServiceData.hTerminate = CreateEvent(NULL,TRUE,FALSE,NULL)) ==
			NULL )
		{
			return FALSE;
		}
		// Try to create the worker threads
		if( CreateChildrenThreads() == false )
		{
			return FALSE;
		}
	}

	return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
		// No message handlers
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

// App command to run the dialog
void CXMLDBServiceApp::OnAppAbout()
{
	CAboutDlg aboutDlg;
	aboutDlg.DoModal();
}

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceApp commands

int CXMLDBServiceApp::ExitInstance() 
{
	// Trigger the "die" event if it still exists
	if( sdServiceData.hTerminate != NULL )
	{
		SetEvent(sdServiceData.hTerminate);
		// Let us pause for the other threads to exit 5 seconds
		Sleep(5000);
	}
	return CWinApp::ExitInstance();
}

/***************************************************************************
* Function:	CXMLDBServiceApp::InstallService()
* Author:	Joe Graf
* Date:		11/13/96
*			8/26/97 JG - Removed the previous logging methods
* Vars In:	None
* Vars Out:	None
* Returns:	None
* Purpose:	Adds this service into the Service Control Manager's list.
***************************************************************************/

void CXMLDBServiceApp::InstallService() 
{
	// Open a connection to the SCM
	SC_HANDLE hScm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
	if( hScm != NULL )
	{
		SC_HANDLE hService = NULL;
		// Determine where the file is
		TCHAR szExePath[MAX_PATH];
		GetModuleFileName(NULL,szExePath,MAX_PATH);
		// Get the application name from the resource fork
		CString strAppName;
		if( strAppName.LoadString(AFX_IDS_APP_TITLE) == TRUE )
		{
			// Install the new service
			hService = CreateService(hScm,strAppName,strAppName,
				SERVICE_ALL_ACCESS,
				SERVICE_INTERACTIVE_PROCESS | SERVICE_WIN32_OWN_PROCESS,
				SERVICE_DEMAND_START,SERVICE_ERROR_NORMAL,
				szExePath,NULL,NULL,NULL,NULL,NULL);
			// Don't close bogus handles
			if( hService != NULL )
			{
				// Clean up
				CloseServiceHandle(hService);
			}
			else
			{
				// Log the error
			}
		}
		// Clean up
		CloseServiceHandle(hScm);
	}
	else
	{
		// Log the error
	}
}

/***************************************************************************
* Function:	CXMLDBServiceApp::RemoveService()
* Author:	Joe Graf
* Date:		11/13/96
*			8/26/97 JG - Removed the previous logging methods
* Vars In:	None
* Vars Out:	None
* Returns:	None
* Purpose:	Removes this service from the Service Control Manager's list.
***************************************************************************/

void CXMLDBServiceApp::RemoveService() 
{
	// Open a connection to the SCM
	SC_HANDLE hScm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
	if( hScm == NULL )
	{
		// Log the error
		return;
	}
	SC_HANDLE hService = NULL;
	// Get the application name from the resource fork
	CString strAppName;
	if( strAppName.LoadString(AFX_IDS_APP_TITLE) == TRUE )
	{
		// Open a connection to the service
		hService = OpenService(hScm,strAppName,SERVICE_ALL_ACCESS);
		if( hService != NULL )
		{
			// Make sure the service is stopped before deleting it
			SERVICE_STATUS srvStatus;
			ZeroMemory(&srvStatus,sizeof(SERVICE_STATUS));
			ControlService(hService,SERVICE_CONTROL_STOP,&srvStatus);
			while( srvStatus.dwCurrentState != SERVICE_STOPPED )
			{
				// Pause for a 1/2 second
				Sleep(500);
				QueryServiceStatus(hService,&srvStatus);
			}
			// Delete the service
			DeleteService(hService);
			// Clean up
			CloseServiceHandle(hService);
		}
		else
		{
			// Log the error
		}
	}
	// Clean up
	CloseServiceHandle(hScm);
}

