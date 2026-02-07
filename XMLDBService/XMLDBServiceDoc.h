// XMLDBServiceDoc.h : interface of the CXMLDBServiceDoc class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_XMLDBSERVICEDOC_H__C1C64C82_D478_11D1_8675_006097256F38__INCLUDED_)
#define AFX_XMLDBSERVICEDOC_H__C1C64C82_D478_11D1_8675_006097256F38__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#define BASE_KEY _T("SOFTWARE\\MIND\\XML_App")
#define FTP_DIR_KEY _T("FTP_Dir")
#define IN_EXT_KEY _T("Inbound_Ext")
#define PROC_EXT_KEY _T("Processed_Ext")

class CXMLDBServiceDoc : public CDocument
{

protected: // create from serialization only
	CXMLDBServiceDoc();
	DECLARE_DYNCREATE(CXMLDBServiceDoc)

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CXMLDBServiceDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CXMLDBServiceDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CXMLDBServiceDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

	// Generated OLE dispatch map functions
	//{{AFX_DISPATCH(CXMLDBServiceDoc)
	afx_msg SCODE GetFTPDirCfg(BSTR FAR* pbstrDirName, BSTR FAR* pbstrInExt, BSTR FAR* pbstrProcExt);
	afx_msg SCODE SetFTPDirCfg(LPCTSTR szDirName, LPCTSTR szInExt, LPCTSTR szProcExt);
	//}}AFX_DISPATCH
	DECLARE_DISPATCH_MAP()
	DECLARE_INTERFACE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_XMLDBSERVICEDOC_H__C1C64C82_D478_11D1_8675_006097256F38__INCLUDED_)
