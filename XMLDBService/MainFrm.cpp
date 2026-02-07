// MainFrm.cpp : implementation of the CMainFrame class
//

#include "stdafx.h"
#include "XMLDBService.h"

#include "MainFrm.h"
#include "XMLDBServiceDoc.h"
#include "XMLDBServiceView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMainFrame

IMPLEMENT_DYNCREATE(CMainFrame, CFrameWnd)

BEGIN_MESSAGE_MAP(CMainFrame, CFrameWnd)
	//{{AFX_MSG_MAP(CMainFrame)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	ON_WM_CREATE()
	ON_MESSAGE(WM_ADD_FILE,OnAddFile)
	ON_MESSAGE(WM_ADD_PARENT,OnAddParent)
	ON_MESSAGE(WM_ADD_CHILD,OnAddChild)
	ON_MESSAGE(WM_MOVE_TO_PARENT,OnMoveToParent)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

static UINT indicators[] =
{
	ID_SEPARATOR,           // status line indicator
	ID_INDICATOR_CAPS,
	ID_INDICATOR_NUM,
	ID_INDICATOR_SCRL,
};

/////////////////////////////////////////////////////////////////////////////
// CMainFrame construction/destruction

CMainFrame::CMainFrame()
{
	// TODO: add member initialization code here
	
}

CMainFrame::~CMainFrame()
{
}

int CMainFrame::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CFrameWnd::OnCreate(lpCreateStruct) == -1)
		return -1;

	if (!m_wndStatusBar.Create(this) ||
		!m_wndStatusBar.SetIndicators(indicators,
		  sizeof(indicators)/sizeof(UINT)))
	{
		TRACE0("Failed to create status bar\n");
		return -1;      // fail to create
	}

	return 0;
}

BOOL CMainFrame::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return CFrameWnd::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CMainFrame diagnostics

#ifdef _DEBUG
void CMainFrame::AssertValid() const
{
	CFrameWnd::AssertValid();
}

void CMainFrame::Dump(CDumpContext& dc) const
{
	CFrameWnd::Dump(dc);
}

#endif //_DEBUG

/***************************************************************************
* Function:	CMainFrame::OnAddFile()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		<UINT> ignored
*			<LONG> lParam - the lParam of the message that is to be forwarded
* Returns:	<LONG> always 0
* Purpose:	Forwards a msg on the view class
***************************************************************************/

LONG CMainFrame::OnAddFile(UINT,LONG lParam)
{
	// Find the active view
	CXMLDBServiceView* pView = (CXMLDBServiceView*)GetActiveView();
	ASSERT_VALID(pView);
	pView->AddToTree(AddFileCmd,(LPCTSTR)lParam);
	return 0;
}

/***************************************************************************
* Function:	CMainFrame::OnAddParent()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		<UINT> ignored
*			<LONG> lParam - the lParam of the message that is to be forwarded
* Returns:	<LONG> always 0
* Purpose:	Forwards a msg on the view class
***************************************************************************/

LONG CMainFrame::OnAddParent(UINT,LONG lParam)
{
	// Find the active view
	CXMLDBServiceView* pView = (CXMLDBServiceView*)GetActiveView();
	ASSERT_VALID(pView);
	pView->AddToTree(AddParentCmd,(LPCTSTR)lParam);
	return 0;
}

/***************************************************************************
* Function:	CMainFrame::OnAddChild()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		<UINT> ignored
*			<LONG> lParam - the lParam of the message that is to be forwarded
* Returns:	<LONG> always 0
* Purpose:	Forwards a msg on the view class
***************************************************************************/

LONG CMainFrame::OnAddChild(UINT,LONG lParam)
{
	// Find the active view
	CXMLDBServiceView* pView = (CXMLDBServiceView*)GetActiveView();
	ASSERT_VALID(pView);
	pView->AddToTree(AddChildCmd,(LPCTSTR)lParam);
	return 0;
}

/***************************************************************************
* Function:	CMainFrame::OnMoveToParent()
* Author:	Joe Graf
* Date:		4/17/98
* Args:		<UINT> ignored
*			<LONG> ignored
* Returns:	<LONG> always 0
* Purpose:	Forwards a msg on the view class
***************************************************************************/

LONG CMainFrame::OnMoveToParent(UINT,LONG)
{
	// Find the active view
	CXMLDBServiceView* pView = (CXMLDBServiceView*)GetActiveView();
	ASSERT_VALID(pView);
	pView->AddToTree(MoveUpCmd,NULL);
	return 0;
}

