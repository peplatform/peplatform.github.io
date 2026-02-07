// XMLDBServiceView.cpp : implementation of the CXMLDBServiceView class
//

#include "stdafx.h"
#include "XMLDBService.h"

#include "XMLDBServiceDoc.h"
#include "XMLDBServiceView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceView

IMPLEMENT_DYNCREATE(CXMLDBServiceView, CTreeView)

BEGIN_MESSAGE_MAP(CXMLDBServiceView, CTreeView)
	//{{AFX_MSG_MAP(CXMLDBServiceView)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceView construction/destruction

CXMLDBServiceView::CXMLDBServiceView()
{
	m_hTreeParent = NULL;
}

CXMLDBServiceView::~CXMLDBServiceView()
{
}

BOOL CXMLDBServiceView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return CTreeView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceView drawing

void CXMLDBServiceView::OnDraw(CDC* pDC)
{
	CXMLDBServiceDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);

	// TODO: add draw code for native data here
}

/***************************************************************************
* Function:	CXMLDBServiceView::OnInitialUpdate()
* Author:	Joe Graf
* Date:		4/17/98
* Args:		None
* Returns:	None
* Purpose:	Changes the style of the tree ctrl to enhance the look and feel
***************************************************************************/

void CXMLDBServiceView::OnInitialUpdate()
{
	CTreeView::OnInitialUpdate();

	// Style bits for this control
	long lStyle = GetWindowLong(GetTreeCtrl().m_hWnd,GWL_STYLE);
	// Add the lines and buttons to enhance readability
	lStyle |= TVS_HASLINES | TVS_HASBUTTONS | TVS_LINESATROOT;
	SetWindowLong(GetTreeCtrl().m_hWnd,GWL_STYLE,lStyle);
}

/////////////////////////////////////////////////////////////////////////////
// CXMLDBServiceView diagnostics

#ifdef _DEBUG
void CXMLDBServiceView::AssertValid() const
{
	CTreeView::AssertValid();
}

void CXMLDBServiceView::Dump(CDumpContext& dc) const
{
	CTreeView::Dump(dc);
}

CXMLDBServiceDoc* CXMLDBServiceView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CXMLDBServiceDoc)));
	return (CXMLDBServiceDoc*)m_pDocument;
}
#endif //_DEBUG

/***************************************************************************
* Function:	CXMLDBServiceView::AddToTree()
* Author:	Joe Graf
* Date:		4/16/98
* Args:		<DWORD> dwCmd - the type of addition to perform
*			<LPCTSTR> szItem - the item text to add to the tree
* Returns:	None
* Purpose:	Adds items to the tree for debug purposes
***************************************************************************/

void CXMLDBServiceView::AddToTree(DWORD dwCmd,LPCTSTR szItem)
{
	// Determine what type of item to add
	switch( dwCmd )
	{
		case AddFileCmd:
		{
			// Add the file name to the view
			m_hTreeParent = GetTreeCtrl().InsertItem(szItem);
			break;
		}
		case AddParentCmd:
		{
			// Add the XML parent to the tree under the file name
			m_hTreeParent = GetTreeCtrl().InsertItem(szItem,m_hTreeParent);
			break;
		}
		case AddChildCmd:
		{
			// Add the XML child to the tree under the parent aggregate
			GetTreeCtrl().EnsureVisible(GetTreeCtrl().
				InsertItem(szItem,m_hTreeParent));
			break;
		}
		case MoveUpCmd:
		{
			// Move the indent up one level
			m_hTreeParent = GetTreeCtrl().GetParentItem(m_hTreeParent);
			break;
		}
		default:
		{
			ASSERT(FALSE);
		}
	}
	// Expand the tree to show this item
	GetTreeCtrl().EnsureVisible(m_hTreeParent);
}
