// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__C1C64C7E_D478_11D1_8675_006097256F38__INCLUDED_)
#define AFX_STDAFX_H__C1C64C7E_D478_11D1_8675_006097256F38__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#define VC_EXTRALEAN		// Exclude rarely-used stuff from Windows headers

#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions
#include <afxcview.h>
#include <afxdisp.h>        // MFC OLE automation classes
#include <afxmt.h>

#ifndef _AFX_NO_DB_SUPPORT
#include <afxdb.h>			// MFC ODBC database classes
#endif // _AFX_NO_DB_SUPPORT

#ifndef _AFX_NO_DAO_SUPPORT
#include <afxdao.h>			// MFC DAO database classes
#endif // _AFX_NO_DAO_SUPPORT

#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>			// MFC support for Windows Common Controls
#endif // _AFX_NO_AFXCMN_SUPPORT

// Window messages for updating the UI in debug mode
#define WM_ADD_FILE (WM_USER+1)
#define WM_ADD_PARENT (WM_ADD_FILE+1)
#define WM_ADD_CHILD (WM_ADD_PARENT+1)
#define WM_MOVE_TO_PARENT (WM_ADD_CHILD+1)
// enum for the same purpose
enum { AddFileCmd, AddParentCmd, AddChildCmd, MoveUpCmd, CmdCount };

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__C1C64C7E_D478_11D1_8675_006097256F38__INCLUDED_)
