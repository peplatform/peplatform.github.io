// XMLDBService.h : main header file for the XMLDBSERVICE application
//

#if !defined(AFX_XMLDBSERVICE_H__C1C64C7B_D478_11D1_8675_006097256F38__INCLUDED_)
#define AFX_XMLDBSERVICE_H__C1C64C7B_D478_11D1_8675_006097256F38__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceApp:
// See XMLDBService.cpp for the implementation of this class
//

class CXMLDBServiceApp : public CWinApp
{
public:
	CXMLDBServiceApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CXMLDBServiceApp)
	public:
	virtual BOOL InitInstance();
	virtual int ExitInstance();
	//}}AFX_VIRTUAL

// Implementation
	COleTemplateServer m_server;
		// Server object for document creation

	// Service helpers
	void InstallService(void);
	void RemoveService(void);


	//{{AFX_MSG(CXMLDBServiceApp)
	afx_msg void OnAppAbout();
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_XMLDBSERVICE_H__C1C64C7B_D478_11D1_8675_006097256F38__INCLUDED_)
