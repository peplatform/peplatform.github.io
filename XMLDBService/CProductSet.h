#if !defined(AFX_CPRODUCTSET_H__87A39745_D568_11D1_867D_006097256F38__INCLUDED_)
#define AFX_CPRODUCTSET_H__87A39745_D568_11D1_867D_006097256F38__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// CProductSet.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CProductSet recordset

class CProductSet : public CRecordset
{
public:
	CProductSet(CDatabase* pDatabase = NULL);
	DECLARE_DYNAMIC(CProductSet)

// Field/Param Data
	//{{AFX_FIELD(CProductSet, CRecordset)
	long	m_lProdID;
	CString	m_strName;
	CString	m_strPrice;
	long	m_lQtyOnHand;
	CString	m_strColor;
	BYTE	m_bShipOpts;
	//}}AFX_FIELD


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CProductSet)
	public:
	virtual CString GetDefaultConnect();    // Default connection string
	virtual CString GetDefaultSQL();    // Default SQL for Recordset
	virtual void DoFieldExchange(CFieldExchange* pFX);  // RFX support
	//}}AFX_VIRTUAL

// Implementation
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CPRODUCTSET_H__87A39745_D568_11D1_867D_006097256F38__INCLUDED_)
