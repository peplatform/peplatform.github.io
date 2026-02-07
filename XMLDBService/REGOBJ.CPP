// Copyright © 1996 JG Consulting Services
// This is the implementation of the Registry object classes

#include "stdafx.h"

#include "regobj.h"

/***************************************************************************
* Function:	CRegistry::CRegistry()
* Author:	Joe Graf
* Date:		5/3/96
*			5/21/96 Added the auto-create flag
* Args:		<HKEY> hKey - the open key to use HKEY_LOCAL_MACHINE etc...
*			<LPCTSTR> pKey - the registry key to attach to
*			<BOOL>	bCreate - indicates if it should be created
* Purpose:	Connects to the local registry using the specified key
***************************************************************************/

CRegistry::CRegistry(HKEY hKey,LPCTSTR pKey,BOOL bCreate)
{
	m_hKey = NULL;
	// Try to connect to the specified key
	if( RegOpenKeyEx(hKey,pKey,0,KEY_ALL_ACCESS,&m_hKey) != ERROR_SUCCESS )
	{
		if( bCreate != TRUE )
			throw CRegistryException(CRegistryException::MissingKey);
		// Create the key
		if( RegCreateKey(hKey,pKey,&m_hKey) != ERROR_SUCCESS )
			throw CRegistryException(CRegistryException::MissingKey);
	}
}

/***************************************************************************
* Function:	CRegistry::~CRegistry()
* Author:	Joe Graf
* Date:		5/3/96
* Purpose:	Closes any open key
***************************************************************************/

CRegistry::~CRegistry()
{
	if( m_hKey != NULL )
		RegCloseKey(m_hKey);
}

/***************************************************************************
* Function:	CRegistry::GetString()
* Author:	Joe Graf
* Date:		5/3/96
*			6/25/96 Added a terminating zero to the string
* Args:		<LPCTSTR> pValueName - the name of the value to read
*			<LPCTSTR> pBuffer - a pointer to the buffer that will receive it
*			<UINT> nCount - the size of the buffer in bytes
* Purpose:	Copies a registry string into the designated buffer
***************************************************************************/

void CRegistry::GetString(LPCTSTR pValueName,LPTSTR pBuffer,UINT nCount)
{
	DWORD dwType = 0;
	// Convert the count to the correct char set
	nCount *= sizeof(TCHAR);
	// Read the value
	if( RegQueryValueEx(m_hKey,pValueName,NULL,&dwType,(LPBYTE)pBuffer,
		(ULONG*)&nCount) != ERROR_SUCCESS )
	{
		throw CRegistryException(CRegistryException::MissingValue);
	}
	// Zeros the end of the string
	pBuffer[nCount / sizeof(TCHAR)] = TEXT('\0');
}

/***************************************************************************
* Function:	CRegistry::GetDword()
* Author:	Joe Graf
* Date:		5/3/96
* Purpose:	Copies a registry dword into the designated buffer
***************************************************************************/

void CRegistry::GetDword(LPCTSTR pValueName,DWORD* pDword)
{
	DWORD dwType = 0;
	DWORD dwCount = sizeof(DWORD);
	if( RegQueryValueEx(m_hKey,pValueName,NULL,&dwType,(LPBYTE)pDword,
		&dwCount) != ERROR_SUCCESS )
	{
		throw CRegistryException(CRegistryException::MissingValue);
	}
}

/***************************************************************************
* Function:	CRegistry::EnumValues()
* Author:	Joe Graf
* Date:		5/3/96
* Args:		<UINT> nIndex - the index of the item to be read
*			<LPCTSTR> pValueName - a pointer to the buffer get the item's name
*			<DWORD*> pdwValSize - the size of the buffer to get the name
*			<LPCTSTR> pBuffer - a pointer to the buffer that will receive it
*			<DWORD*> pdwCount - the size of the buffer in bytes
* Returns:	<LONG> the return value from regenumkey
* Purpose:	Copies a registry string into the designated buffer
***************************************************************************/

LONG CRegistry::EnumValues(UINT nIndex,LPTSTR pValueName,DWORD* pdwValSize,
	LPTSTR pBuffer,DWORD* pdwCount)
{
	DWORD dwType = 0;
	// Convert length to the correct char set
	*pdwValSize *= sizeof(TCHAR);
	*pdwCount *= sizeof(TCHAR);
	LONG lRetCode = RegEnumValue(m_hKey,nIndex,pValueName,pdwValSize,
		NULL,&dwType,(LPBYTE)pBuffer,pdwCount);
	if( lRetCode != ERROR_SUCCESS && lRetCode != ERROR_NO_MORE_ITEMS )
	{
		throw CRegistryException(CRegistryException::MissingValue);
	}
	// For EnumKey weird behavior
	pValueName[*pdwValSize / sizeof(TCHAR)] = TEXT('\0');
	pBuffer[*pdwCount / sizeof(TCHAR)] = TEXT('\0');
	return lRetCode;
}

/***************************************************************************
* Function:	CRegistry::SetString()
* Author:	Joe Graf
* Date:		5/12/96
* Purpose:	Sets a value in the registry
***************************************************************************/

void CRegistry::SetString(LPCTSTR pValueName,LPCTSTR pValue)
{
	// Set the value
	if( RegSetValueEx(m_hKey,pValueName,0,REG_SZ,(LPBYTE)pValue,
		_tcslen(pValue) * sizeof(TCHAR)) != ERROR_SUCCESS )
	{
		throw CRegistryException(CRegistryException::MissingValue);
	}
}

/***************************************************************************
* Function:	CRegistry::SetDword()
* Author:	Joe Graf
* Date:		5/21/96
* Purpose:	Sets a value in the registry
***************************************************************************/

void CRegistry::SetDword(LPCTSTR pValueName,DWORD dwValue)
{
	// Set the value
	if( RegSetValueEx(m_hKey,pValueName,0,REG_DWORD,(LPBYTE)&dwValue,
		sizeof(DWORD)) != ERROR_SUCCESS )
	{
		throw CRegistryException(CRegistryException::MissingValue);
	}
}

/***************************************************************************
* Function:	CRegistry::DeleteValue()
* Author:	Joe Graf
* Date:		5/12/96
* Purpose:	Deletes a value from the Registry
***************************************************************************/

void CRegistry::DeleteValue(LPCTSTR pValueName)
{
	// Delete the value
	if( RegDeleteValue(m_hKey,pValueName) != ERROR_SUCCESS )
	{
		throw CRegistryException(CRegistryException::MissingValue);
	}
}
