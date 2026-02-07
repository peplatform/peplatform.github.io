// XMLDBServiceDoc.cpp : implementation of the CXMLDBServiceDoc class
//

#include "stdafx.h"
#include "XMLDBService.h"

#include "XMLDBServiceDoc.h"
// Include the registry handling classes
#include "regobj.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

// Synchronizes access to the config data
CCriticalSection g_csAccessSync;
// These are the global settings for the service
CString g_strFTPDirName;
CString g_strInboundExt;
CString g_strProcessedExt;
// This event is used to notify the worker thread of a settings change
HANDLE g_hConfigEvent = NULL;

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceDoc

IMPLEMENT_DYNCREATE(CXMLDBServiceDoc, CDocument)

BEGIN_MESSAGE_MAP(CXMLDBServiceDoc, CDocument)
	//{{AFX_MSG_MAP(CXMLDBServiceDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

BEGIN_DISPATCH_MAP(CXMLDBServiceDoc, CDocument)
	//{{AFX_DISPATCH_MAP(CXMLDBServiceDoc)
	DISP_FUNCTION(CXMLDBServiceDoc, "GetFTPDirCfg", GetFTPDirCfg, VT_ERROR, VTS_PBSTR VTS_PBSTR VTS_PBSTR)
	DISP_FUNCTION(CXMLDBServiceDoc, "SetFTPDirCfg", SetFTPDirCfg, VT_ERROR, VTS_BSTR VTS_BSTR VTS_BSTR)
	//}}AFX_DISPATCH_MAP
END_DISPATCH_MAP()

// Note: we add support for IID_IXMLDBService to support typesafe binding
//  from VBA.  This IID must match the GUID that is attached to the 
//  dispinterface in the .ODL file.

// {C1C64C78-D478-11D1-8675-006097256F38}
static const IID IID_IXMLDBService =
{ 0xc1c64c78, 0xd478, 0x11d1, { 0x86, 0x75, 0x0, 0x60, 0x97, 0x25, 0x6f, 0x38 } };

BEGIN_INTERFACE_MAP(CXMLDBServiceDoc, CDocument)
	INTERFACE_PART(CXMLDBServiceDoc, IID_IXMLDBService, Dispatch)
END_INTERFACE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceDoc construction/destruction

/***************************************************************************
* Function:	CXMLDBServiceDoc::CXMLDBServiceDoc()
* Author:	Joe Graf
* Date:		4/15/98
* Args:		None
* Returns:	None
* Purpose:	Initializes the document class. Reads the global config data
*			from the registry
***************************************************************************/

CXMLDBServiceDoc::CXMLDBServiceDoc()
{
	// Protect the vars while accessing them
	CSingleLock sl(&g_csAccessSync);
	try
	{
		// Try to read the values from the registry
		CRegistry regKey(HKEY_LOCAL_MACHINE,BASE_KEY);
		TCHAR szVal[MAX_PATH + 1];
		// Read the FTP directory that is to be scanned & processed
		regKey.GetString(FTP_DIR_KEY,szVal,MAX_PATH + 1);
		// Copy the value into the global setting
		g_strFTPDirName = szVal;
		// Read the file extension of the inbound files
		regKey.GetString(IN_EXT_KEY,szVal,MAX_PATH + 1);
		// Copy the value into the global setting
		g_strInboundExt = szVal;
		// Read the file extension to change processed files to
		regKey.GetString(PROC_EXT_KEY,szVal,MAX_PATH + 1);
		// Copy the value into the global setting
		g_strProcessedExt = szVal;
	}
	catch(CRegistryException)
	{
		// Set the properties to their default values
		g_strFTPDirName = _T("C:\\");
		g_strInboundExt = _T(".XML");
		g_strProcessedExt = _T(".PRC");
	}
	// Create the config event
	g_hConfigEvent = CreateEvent(NULL,FALSE,FALSE,NULL);
	if( g_hConfigEvent == NULL )
	{
		// Tell the service to terminate if it can't create an event
		PostQuitMessage(-1);
	}

	EnableAutomation();

	AfxOleLockApp();
}

CXMLDBServiceDoc::~CXMLDBServiceDoc()
{
	AfxOleUnlockApp();
}

BOOL CXMLDBServiceDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// TODO: add reinitialization code here
	// (SDI documents will reuse this document)

	return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceDoc serialization

void CXMLDBServiceDoc::Serialize(CArchive& ar)
{
	if (ar.IsStoring())
	{
		// TODO: add storing code here
	}
	else
	{
		// TODO: add loading code here
	}
}

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceDoc diagnostics

#ifdef _DEBUG
void CXMLDBServiceDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CXMLDBServiceDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceDoc commands

/***************************************************************************
* Function:	CXMLDBServiceDoc::GetFTPDirCfg()
* Author:	Joe Graf
* Date:		4/15/98
* Args:		<BSTR*> pbstrDirName - returns the name of the dir being watched
*			<BSTR*> pbstrInExt - returns the file extension to process
*			<BSTR*> pbstrProcExt - returns the file extension of proc. files
* Returns:	<SCODE/HRESULT> standard COM return codes
* Purpose:	Copies the current diretory settings into the supplied vars
***************************************************************************/

SCODE CXMLDBServiceDoc::GetFTPDirCfg(BSTR FAR* pbstrDirName,
	BSTR FAR* pbstrInExt,BSTR FAR* pbstrProcExt) 
{
	// Protect the vars while accessing them
	CSingleLock sl(&g_csAccessSync);
	// Create BSTRs for each of the properties
	*pbstrDirName = g_strFTPDirName.AllocSysString();
	*pbstrInExt = g_strInboundExt.AllocSysString();
	*pbstrProcExt = g_strProcessedExt.AllocSysString();
	return S_OK;
}

/***************************************************************************
* Function:	CXMLDBServiceDoc::SetFTPDirCfg()
* Author:	Joe Graf
* Date:		4/15/98
* Args:		<BSTR> bstrDirName - the name of the new dir to watch
*			<BSTR> bstrInExt - the new file extension to process
*			<BSTR> bstrProcExt - the new file extension change proc. files to
* Returns:	<SCODE/HRESULT> standard COM return codes
* Purpose:	Sets the new the directory settings internally and in the
*			registry
***************************************************************************/

SCODE CXMLDBServiceDoc::SetFTPDirCfg(LPCTSTR szDirName,LPCTSTR szInExt,
	LPCTSTR szProcExt) 
{
	// Assume an error
	HRESULT hr = E_FAIL;
	// Protect the vars while accessing them
	CSingleLock sl(&g_csAccessSync);
	// For debug tracing
	CWnd* pWnd = AfxGetMainWnd();
	ASSERT_VALID(pWnd);
	// Update the UI of the event
	pWnd->SendMessage(WM_ADD_FILE,0,(LPARAM)_T("Config settings changed"));
	try
	{
		// Copy the new settings in the global vars
		g_strFTPDirName = szDirName;
		g_strInboundExt = szInExt;
		g_strProcessedExt = szProcExt;
		// Try to read the values from the registry
		CRegistry regKey(HKEY_LOCAL_MACHINE,BASE_KEY);
		// Write the new directory setting
		regKey.SetString(FTP_DIR_KEY,g_strFTPDirName);
		// Write the new inbound file extension to look for
		regKey.SetString(IN_EXT_KEY,g_strInboundExt);
		// Write the processed file extension to copy files to
		regKey.SetString(PROC_EXT_KEY,g_strProcessedExt);
		// Update the UI of the new settings
		pWnd->SendMessage(WM_ADD_CHILD,0,
			(LPARAM)(LPCTSTR)(CString(_T("FTP Dir = ") + g_strFTPDirName)));
		pWnd->SendMessage(WM_ADD_CHILD,0,
			(LPARAM)(LPCTSTR)(CString(_T("Inbound Ext = ") +
			g_strInboundExt)));
		pWnd->SendMessage(WM_ADD_CHILD,0,
			(LPARAM)(LPCTSTR)(CString(_T("Processed Ext = ") +
			g_strProcessedExt)));
		// Let the worker thread know that the settings have changed
		SetEvent(g_hConfigEvent);
		// Everything went OK so indicate it
		hr = S_OK;
	}
	catch(CRegistryException)
	{
		// We defaulted to failure so nothing to do
		// A real app (non sample) should provide a roll back mechanism
		pWnd->SendMessage(WM_ADD_PARENT,0,
			(LPARAM)_T("Error saving settings to the registry"));
	}
	return hr;
}
