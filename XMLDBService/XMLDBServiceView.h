// XMLDBServiceView.h : interface of the CXMLDBServiceView class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_XMLDBSERVICEVIEW_H__C1C64C84_D478_11D1_8675_006097256F38__INCLUDED_)
#define AFX_XMLDBSERVICEVIEW_H__C1C64C84_D478_11D1_8675_006097256F38__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

class CXMLDBServiceView : public CTreeView
{
	// Used to add items to the UI
	HTREEITEM m_hTreeParent;

protected: // create from serialization only
	CXMLDBServiceView();
	DECLARE_DYNCREATE(CXMLDBServiceView)

// Attributes
public:
	CXMLDBServiceDoc* GetDocument();

// Operations
public:
	void AddToTree(DWORD dwCmd,LPCTSTR szItem);

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CXMLDBServiceView)
	public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	protected:
	virtual void OnInitialUpdate(); // called first time after construct
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CXMLDBServiceView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CXMLDBServiceView)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in XMLDBServiceView.cpp
inline CXMLDBServiceDoc* CXMLDBServiceView::GetDocument()
   { return (CXMLDBServiceDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_XMLDBSERVICEVIEW_H__C1C64C84_D478_11D1_8675_006097256F38__INCLUDED_)
