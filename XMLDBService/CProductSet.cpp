// CProductSet.cpp : implementation file
//

#include "stdafx.h"

#include "CProductSet.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CProductSet

IMPLEMENT_DYNAMIC(CProductSet, CRecordset)

CProductSet::CProductSet(CDatabase* pdb)
	: CRecordset(pdb)
{
	//{{AFX_FIELD_INIT(CProductSet)
	m_lProdID = 0;
	m_strName = _T("");
	m_strPrice = _T("");
	m_lQtyOnHand = 0;
	m_strColor = _T("");
	m_bShipOpts = 0;
	m_nFields = 6;
	//}}AFX_FIELD_INIT
	m_nDefaultType = snapshot;
}


CString CProductSet::GetDefaultConnect()
{
	return _T("ODBC;DSN=XMLApp");
}

CString CProductSet::GetDefaultSQL()
{
	return _T("[dbo].[Products]");
}

void CProductSet::DoFieldExchange(CFieldExchange* pFX)
{
	//{{AFX_FIELD_MAP(CProductSet)
	pFX->SetFieldType(CFieldExchange::outputColumn);
	RFX_Long(pFX, _T("[ProdID]"), m_lProdID);
	RFX_Text(pFX, _T("[Name]"), m_strName);
	RFX_Text(pFX, _T("[Price]"), m_strPrice);
	RFX_Long(pFX, _T("[QtyOnHand]"), m_lQtyOnHand);
	RFX_Text(pFX, _T("[Color]"), m_strColor);
	RFX_Byte(pFX, _T("[ShipOpts]"), m_bShipOpts);
	//}}AFX_FIELD_MAP
}

/////////////////////////////////////////////////////////////////////////////
// CProductSet diagnostics

#ifdef _DEBUG
void CProductSet::AssertValid() const
{
	CRecordset::AssertValid();
}

void CProductSet::Dump(CDumpContext& dc) const
{
	CRecordset::Dump(dc);
}
#endif //_DEBUG
