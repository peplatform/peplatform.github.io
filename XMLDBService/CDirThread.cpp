// CDirThread.cpp : implementation file
//

#include "stdafx.h"
#include "XMLDBService.h"
#include "CDirThread.h"


// For URLOpenBlockingStream()
#include <urlmon.h>

#include "Service.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

// For use throughout the service
extern SERVICE_DATA sdServiceData;
// These are the external events that the service will generate
extern HANDLE g_hConfigEvent;
// For access synchronization
extern CCriticalSection g_csAccessSync;
// These are the config settings
extern CString g_strFTPDirName;
extern CString g_strInboundExt;
extern CString g_strProcessedExt;

// MSXML GUIDS
const IID LIBID_MSXML = {0xd63e0ce2,0xa0a2,0x11d0,{0x9c,0x02,0x00,0xc0,0x4f,0xc9,0x9c,0x8e}};
const IID IID_IXMLElementCollection = {0x65725580,0x9B5D,0x11d0,{0x9B,0xFE,0x00,0xC0,0x4F,0xC9,0x9C,0x8E}};
const IID IID_IXMLDocument = {0xF52E2B61,0x18A1,0x11d1,{0xB1,0x05,0x00,0x80,0x5F,0x49,0x91,0x6B}};
const IID IID_IXMLElement = {0x3F7F31AC,0xE15F,0x11d0,{0x9C,0x25,0x00,0xC0,0x4F,0xC9,0x9C,0x8E}};
const IID IID_IXMLError = {0x948C5AD3,0xC58D,0x11d0,{0x9C,0x0B,0x00,0xC0,0x4F,0xC9,0x9C,0x8E}};
const IID IID_IXMLElementNotificationSink = {0xD9F1E15A,0xCCDB,0x11d0,{0x9C,0x0C,0x00,0xC0,0x4F,0xC9,0x9C,0x8E}};
const CLSID CLSID_XMLDocument = {0xCFC399AF,0xD876,0x11d0,{0x9C,0x10,0x00,0xC0,0x4F,0xC9,0x9C,0x8E}};


BEGIN_MESSAGE_MAP(CDirThread, CWinThread)
	// Does NOT have a message pump
END_MESSAGE_MAP()

IMPLEMENT_DYNCREATE(CDirThread, CWinThread)

/***************************************************************************
* Function:	CDirThread::InitInstance()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		None
* Returns:	<BOOL> whether initialization worked or not
* Purpose:	Creates the resources needed by this thread
***************************************************************************/

BOOL CDirThread::InitInstance()
{
	// Init COM
	CoInitialize(NULL);
	// Read the current configuration of the server
	GetGlobalSettings();
	// Create the event that signals a new file has appeared
	CreateFileEvent();
	// Add in the service related events
	m_hEventArray[ConfigEvent] = g_hConfigEvent;
	m_hEventArray[DieEvent] = sdServiceData.hTerminate;
	// Create the COM objects that are to last the lifetime of the thread
	HRESULT hr = CoCreateInstance(CLSID_XMLDocument,NULL,
		CLSCTX_INPROC_SERVER,IID_IXMLDocument,(void**)&m_pIXMLDoc);
	if( SUCCEEDED(hr) )
	{
	    // Get the IPersistStreamInit interface of the IXMLDocument
		hr = m_pIXMLDoc->QueryInterface(IID_IPersistStreamInit,
			(void **)&m_pXMLDocStreamInit);
	}
	try
	{
		// Open the connection to the database
		m_ProdSet.Open();
	}
	catch(CDBException* e)
	{
		// For debug tracing
		CWnd* pWnd = AfxGetMainWnd();
		ASSERT_VALID(pWnd);
		CString strErr;
		strErr.Format(_T("DB error: %s"),e->m_strError);
		// Log the error
		pWnd->SendMessage(WM_ADD_CHILD,0,(LPARAM)(LPCTSTR)strErr);
		e->Delete();
		// Make sure that we fail to create
		hr = E_FAIL;
	}

	// Verify that everything went OK
	return SUCCEEDED(hr) &&
		m_hEventArray[FileEvent] != INVALID_HANDLE_VALUE;
}

/***************************************************************************
* Function:	CDirThread::ExitInstance()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		None
* Returns:	<int> the return code of the thread
* Purpose:	Releases any alloced resources
***************************************************************************/

int CDirThread::ExitInstance()
{
	// Release the file event if necessary
	if( m_hEventArray[FileEvent] != INVALID_HANDLE_VALUE )
	{
		FindCloseChangeNotification(m_hEventArray[FileEvent]);
	}
	// Release the COM interfaces if they were acquired
	if( m_pIXMLDoc != NULL )
	{
		m_pIXMLDoc->Release();
	}
	if( m_pXMLDocStreamInit != NULL )
	{
		m_pXMLDocStreamInit->Release();
	}
	// Release COM
	CoUninitialize();

	return CWinThread::ExitInstance();
}

/***************************************************************************
* Function:	CDirThread::GetGlobalSettings()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		None
* Returns:	None
* Purpose:	Copies the global settings into the thread's local vars
***************************************************************************/

void CDirThread::GetGlobalSettings(void)
{
	// Lock the global vars while init
	CSingleLock sl(&g_csAccessSync);
	// Make local copies and let go of the lock
	m_strDirName = g_strFTPDirName;
	if( m_strDirName[m_strDirName.GetLength() - 1] != _T('\\') )
	{
		m_strDirName += _T('\\');
	}
	// Build the file to look for
	if( g_strInboundExt[0] != _T('*') )
	{
		m_strInExt = m_strDirName + _T('*') + g_strInboundExt;
	}
	else
	{
		m_strInExt = m_strDirName + m_strInExt;
	}
	m_strProcExt = g_strProcessedExt;
}

/***************************************************************************
* Function:	CDirThread::Run()
* Author:	Joe Graf
* Date:		4/15/98
* Args:		None
* Returns:	<int> the return code of the thread
* Purpose:	Overloads the Run() method of CWinThread, and performs the real
*			work of the thread. Waits for files to land in the specified
*			directory, parses the XML files inserting the data into the DB,
*			and moves the file to a new file name.
***************************************************************************/

int CDirThread::Run() 
{
	// Now process all events that come in until it is time to die
	BOOL bDone = FALSE;
	while( bDone == FALSE )
	{
		// Wait for something to happen
		switch( WaitForMultipleObjects(EventCount,m_hEventArray,FALSE,
			INFINITE) )
		{
			case FileEvent:
			{
				// A File event occured. Process the new file
				ProcessFileEvent();
				// Tell the OS that we want more events
				FindNextChangeNotification(m_hEventArray[FileEvent]);
				break;
			}
			case ConfigEvent:
			{
				// The server has been reconfigured so we need to adjust
				// our cached settings

				// Stop looking for files in the old directory
				FindCloseChangeNotification(m_hEventArray[FileEvent]);
				// Copy the new settings
				GetGlobalSettings();
				// Create the event handle for the directory
				CreateFileEvent();
				// Bail if we can't create it
				if( m_hEventArray[FileEvent] == INVALID_HANDLE_VALUE )
				{
					TRACE0("Failed to create the File Notification Event\n");
					bDone == TRUE;
				}
				break;
			}
			case DieEvent:
			{
				// Terminate event, so go away
				bDone = TRUE;
				break;
			}
			default:
			{
				ASSERT(FALSE);
			}
		}
	}
	// Clean up any resources allocated in the init instance
	return CDirThread::ExitInstance();
}

/***************************************************************************
* Function:	CDirThread::ProcessFileEvent()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		None
* Returns:	None
* Purpose:	Scans the specified directory for any files matching the InExt,
*			processes the file (parses and inserts into the DB), and renames
*			it to the ProcExt.
***************************************************************************/

void CDirThread::ProcessFileEvent(void)
{
	WIN32_FIND_DATA wfd;
	ZeroMemory(&wfd,sizeof(WIN32_FIND_DATA));
	// Search the ftp dir for any matching files
	HANDLE hFileSearch = FindFirstFile(m_strInExt,&wfd);
	if( hFileSearch != INVALID_HANDLE_VALUE )
	{
		do
		{
			// Build the full path to the file
			CString strOrigName(m_strDirName + wfd.cFileName);
			// Process the file that was found
			ProcessFile(strOrigName);
			// Build the new file name
			CString strNewName(strOrigName);
			strNewName = strNewName.Left(strNewName.Find(_T('.')));
			strNewName += m_strProcExt;
			// Rename the file to use the processed file extension
			CFile::Rename(strOrigName,strNewName);
		}
		while( FindNextFile(hFileSearch,&wfd) != 0 );
		// Clean up
		FindClose(hFileSearch);
	}
}

/***************************************************************************
* Function:	CDirThread::ProcessFileEvent()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		<LPCTSTR> szFileName - the name of the file to process
* Returns:	None
* Purpose:	Parses the specified XML file and inserts the data into the DB
***************************************************************************/

void CDirThread::ProcessFile(LPCTSTR szFileName)
{
	// Update the UI
	CWnd* pWnd = AfxGetMainWnd();
	ASSERT_VALID(pWnd);
	// Tell it the name of the dir changed
	pWnd->SendMessage(WM_ADD_FILE,0,(LPARAM)szFileName);
	// Wrap an IStream interface around the file
	IStream* pStream = NULL;
	HRESULT hr = URLOpenBlockingStream(NULL,szFileName,&pStream,NULL,NULL);
    if( SUCCEEDED(hr) )
	{
		// Try to load the XML file into the IXMLDocument interface via
		// the IPersistStreamInit interface
		hr = m_pXMLDocStreamInit->Load(pStream);
		if( SUCCEEDED(hr) )
		{
			// The XML document is well formed so parse it
			ProcessXMLTree();
		}
		else
		{
			// Place an error message
			pWnd->SendMessage(WM_ADD_PARENT,0,
				(LPARAM)_T("Invalid XML file"));
			// Build the reason using the IXMLError interface
			IXMLError* pIXMLError = NULL;
			XML_ERROR xmle;
			ZeroMemory(&xmle,sizeof(XML_ERROR));
			// Get the IXMLError interface from the IPersistStreamInit
			hr = m_pXMLDocStreamInit->QueryInterface(IID_IXMLError,
				(void **)&pIXMLError);
			if( SUCCEEDED(hr) )
			{
				// Fill in the error structure
				hr = pIXMLError->GetErrorInfo(&xmle);
				CString strErr;
				// Now build the error message as a CString
				strErr.Format(_T("Found %s while expecting %s on line %d"),
					xmle._pszFound,xmle._pszExpected,xmle._nLine);
				pWnd->SendMessage(WM_ADD_CHILD,0,(LPARAM)(LPCTSTR)strErr);
				// Now dump the buffer
				strErr.Format(_T("Buffer: %s"),xmle._pchBuf);
				pWnd->SendMessage(WM_ADD_CHILD,0,(LPARAM)(LPCTSTR)strErr);
				// Release the interfaces and strings (BSTRs)
				pIXMLError->Release();
				SysFreeString(xmle._pszFound);
				SysFreeString(xmle._pszExpected);
				SysFreeString(xmle._pchBuf);
			}
			else
			{
				// Place an error message
				pWnd->SendMessage(WM_ADD_PARENT,0,
					(LPARAM)_T("Failed to get IXMLError interface"));
			}
		}
	}
	else
	{
		// Place an error message
		pWnd->SendMessage(WM_ADD_PARENT,0,
			(LPARAM)_T("Failed to create IStream"));
	}
	// Release the stream interface if it was acquired
	if( pStream != NULL )
	{
		pStream->Release();
	}
}

/***************************************************************************
* Function:	CDirThread::ProcessXMLTree()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		None
* Returns:	None
* Purpose:	Uses the MSXML component to parse the XML file and insert the
*			data into the database.
***************************************************************************/

void CDirThread::ProcessXMLTree(void)
{
	// For debug tracing
	CWnd* pWnd = AfxGetMainWnd();
	ASSERT_VALID(pWnd);
	// For debug processing
	CString strElement, strVal;
	// Holds data returned from the XML component
	BSTR bstrVal = NULL;
	// Must start manipulating the tree at the root level, so get a pointer
	// to the root IXMLElement
	IXMLElement* pRoot = NULL;
	HRESULT hr = m_pIXMLDoc->get_root(&pRoot);
	if( SUCCEEDED(hr) )
	{
		LOG_XML_PARENT(pRoot,strElement,bstrVal)

		IXMLElementCollection* pItemList = NULL;
		// Get the collection of items from the root node
		hr = pRoot->get_children(&pItemList);
		// We are done with the root so release it
		pRoot->Release();
		// Check for an empty item list
		if( FAILED(hr) )
		{
			// We are done
			return;
		}
		long lItems = 0;
		COleVariant vtEmpty;
		// Determine how many items there are in the item list <ITEMLIST>
		pItemList->get_length(&lItems);
		// Holds the child lists
		IXMLElement* pItem = NULL;
		for( long lIndex = 0; lIndex < lItems; lIndex++ )
		{
			// Get a pointer the Item collection (<ITEM>) at this index
			COleVariant vtIndex(lIndex,VT_I4);
			hr = pItemList->item(vtIndex,vtEmpty,(LPDISPATCH*)&pItem);
			// Verify the pointer before trying to process
			if( SUCCEEDED(hr) )
			{
				// This call will parse the individual item
				ProcessItem(pItem);
				// Done with this collection so release it
				pItem->Release();
				pItem = NULL;
			}
		}
		// Release the ItemList
		pItemList->Release();
	}
}

/***************************************************************************
* Function:	CDirThread::ProcessItem()
* Author:	Joe Graf
* Date:		4/17/98
* Args:		<IXMLElement*> pItem - the <ITEM> to add to the DB
* Returns:	None
* Purpose:	Takes an instance of the <ITEM> entity and inserts that into the
*			database
***************************************************************************/

void CDirThread::ProcessItem(IXMLElement* pItem)
{
	// For debug tracing
	CWnd* pWnd = AfxGetMainWnd();
	ASSERT_VALID(pWnd);
	CString strProdID;
	// Holds data returned from the XML component
	BSTR bstrVal = NULL;
	LOG_XML_PARENT(pItem,strProdID,bstrVal)
	// Get the list of child elements from the <ITEM>
	IXMLElementCollection* pItemChildren = NULL;
	HRESULT hr = pItem->get_children(&pItemChildren);
	if( FAILED(hr) )
	{
		// Empty <ITEM></ITEM> pair so nothing to process
		return;
	}

	COleVariant vtIndex((long)0,VT_I4);
	// This is the IXMLElement interface for each child field
	IXMLElement* pElem = NULL;
	// Get the <PRODID> element
	COleVariant vtElem(L"PRODID",VT_BSTR);
	
	// NOTE: The documentation states that when an item is requested by
	// name and an index is supplied, only the item at that index in the
	// list of available items will be returned. So, if there are mulitple
	// elements, these calls will only return the first element in the list

	hr = pItemChildren->item(vtElem,vtIndex,(LPDISPATCH*)&pElem);
	if( SUCCEEDED(hr) )
	{
		LOG_XML_ELEM(pElem,vtElem,strProdID,bstrVal)
		// Release the element
		pElem->Release();
		pElem = NULL;
	}
	// Get the <NAME> element
	vtElem = COleVariant(L"NAME",VT_BSTR);
	CString strName;
	hr = pItemChildren->item(vtElem,vtIndex,(LPDISPATCH*)&pElem);
	if( SUCCEEDED(hr) )
	{
		LOG_XML_ELEM(pElem,vtElem,strName,bstrVal)
		// Release the element
		pElem->Release();
		pElem = NULL;
	}
	// Get the <PRICE> element
	vtElem = COleVariant(L"PRICE",VT_BSTR);
	CString strPrice;
	hr = pItemChildren->item(vtElem,vtIndex,(LPDISPATCH*)&pElem);
	if( SUCCEEDED(hr) )
	{
		LOG_XML_ELEM(pElem,vtElem,strPrice,bstrVal)
		// Release the element
		pElem->Release();
		pElem = NULL;
	}
	// Get the <QTYONHAND> element
	vtElem = COleVariant(L"QTYONHAND",VT_BSTR);
	CString strQty;
	hr = pItemChildren->item(vtElem,vtIndex,(LPDISPATCH*)&pElem);
	if( SUCCEEDED(hr) )
	{
		LOG_XML_ELEM(pElem,vtElem,strQty,bstrVal)
		// Release the element
		pElem->Release();
		pElem = NULL;
	}
	// Get the <COLOR> element
	vtElem = COleVariant(L"COLOR",VT_BSTR);
	CString strColor;
	hr = pItemChildren->item(vtElem,vtIndex,(LPDISPATCH*)&pElem);
	if( SUCCEEDED(hr) )
	{
		LOG_XML_ELEM(pElem,vtElem,strColor,bstrVal)
		// Release the element
		pElem->Release();
		pElem = NULL;
	}
	// Get the <SHIPOPTS> element
	vtElem = COleVariant(L"SHIPOPTS",VT_BSTR);
	CString strShip;
	hr = pItemChildren->item(vtElem,vtIndex,(LPDISPATCH*)&pElem);
	if( SUCCEEDED(hr) )
	{
		LOG_XML_ELEM(pElem,vtElem,strShip,bstrVal)
		// Release the element
		pElem->Release();
		pElem = NULL;
	}
	// Release the children list of the <ITEM>
	pItemChildren->Release();
	// Validate that all of the fields are present
	if( strProdID.IsEmpty() || strName.IsEmpty() ||
		strPrice.IsEmpty() || strQty.IsEmpty() ||
		strColor.IsEmpty() || strShip.IsEmpty() )
	{
		// Not everything is present so place and error
		pWnd->SendMessage(WM_ADD_CHILD,0,
			(LPARAM)_T("ERROR: Missing a field"));
	}
	else
	{
		try
		{
			// Add the record to the database
			m_ProdSet.AddNew();
			// Set all of the fields
			m_ProdSet.m_lProdID = _ttol(strProdID);
			m_ProdSet.m_strName = strName;
			m_ProdSet.m_strPrice = strPrice;
			m_ProdSet.m_lQtyOnHand = _ttol(strQty);
			m_ProdSet.m_strColor = strColor;
			// 0 = Ground shipping, 1 = Air shipping
			m_ProdSet.m_bShipOpts =
				(_tcscmp(strShip,_T("Ground")) == 0) ? 0 : 1;
			// Commit the record
			m_ProdSet.Update();
		}
		catch(CDBException* e)
		{
			CString strErr;
			strErr.Format(_T("DB error: %s"),e->m_strError);
			// Log the error
			pWnd->SendMessage(WM_ADD_CHILD,0,(LPARAM)(LPCTSTR)strErr);
			e->Delete();
		}
	}
	// Update the indent on the UI
	pWnd->SendMessage(WM_MOVE_TO_PARENT,0,0);
}
