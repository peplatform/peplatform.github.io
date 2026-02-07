#if !defined(AFX_CDIRTHREAD_H__67B90243_D4A3_11D1_8677_006097256F38__INCLUDED_)
#define AFX_CDIRTHREAD_H__67B90243_D4A3_11D1_8677_006097256F38__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// CDirThread.h : header file
//

// XML pieces
#include <mshtml.h>
#include <msxml.h>
#include "CProductSet.h"

// Macros for ease of coding
#define LOG_XML_PARENT(pInt,str,bstr) VERIFY(pInt->get_tagName(&bstr) == S_OK); \
	str = bstr; \
	SysFreeString(bstr); \
	pWnd->SendMessage(WM_ADD_PARENT,0,(LPARAM)(LPCTSTR)str);

#define LOG_XML_ELEM(pInt,vt,str,bstr) VERIFY(pInt->get_text(&bstr) == S_OK); \
	str = bstr; \
	SysFreeString(bstr); \
	pWnd->SendMessage(WM_ADD_CHILD,0,(LPARAM)(LPCTSTR)CString(CString(vt.bstr) + _T(" = ") + str));

/////////////////////////////////////////////////////////////////////////////
// CDirThread thread

class CDirThread : public CWinThread
{
	DECLARE_DYNCREATE(CDirThread)

	// Member vars for local settings
	CString m_strDirName;
	CString m_strInExt;
	CString m_strProcExt;
	// For event processing
	enum { FileEvent, ConfigEvent, DieEvent, EventCount };
	HANDLE m_hEventArray[EventCount];
	// Vars for processing a file
    IXMLDocument* m_pIXMLDoc;
    IPersistStreamInit* m_pXMLDocStreamInit;
	// To insert data into the DB
	CProductSet m_ProdSet;

	// Helper methods
	void GetGlobalSettings(void);
	void CreateFileEvent(void)
	{
		m_hEventArray[FileEvent] = FindFirstChangeNotification(m_strDirName,
			FALSE,FILE_NOTIFY_CHANGE_FILE_NAME);
	}
	void ProcessFileEvent(void);
	void ProcessFile(LPCTSTR szFileName);
	void ProcessXMLTree(void);
	void ProcessItem(IXMLElement*);

protected:

// Attributes
public:

// Operations
public:
	CDirThread() { m_pIXMLDoc = NULL; m_pXMLDocStreamInit = NULL; }

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDirThread)
	public:
	virtual BOOL InitInstance();
	virtual int ExitInstance();
	virtual int Run();
	//}}AFX_VIRTUAL

// Implementation
protected:
	virtual ~CDirThread() {}

	// Generated message map functions
	//{{AFX_MSG(CDirThread)
		// NOTE - the ClassWizard will add and remove member functions here.
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CDIRTHREAD_H__67B90243_D4A3_11D1_8677_006097256F38__INCLUDED_)
