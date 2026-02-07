// Copyright © 1996 JG Consulting Services
// This is the definition of the registry related classes

class CRegistryException
{
	UINT m_nErrorCode;

public:
	CRegistryException(UINT nError)
		{ m_nErrorCode = nError; }
	UINT GetReason(void) { return m_nErrorCode; }
	enum { MissingKey,MissingValue,IsWin16,Unknown,ErrorCount };
};

class CRegistry
{
	HKEY m_hKey;

public:
	// For opening a remote registry
	CRegistry(LPCTSTR,HKEY,LPCTSTR);
	// For opening a local registry
	CRegistry(HKEY,LPCTSTR,BOOL bCreate = TRUE);
	~CRegistry();
	void GetString(LPCTSTR,LPTSTR,UINT);
	void GetDword(LPCTSTR,DWORD*);
	void SetDword(LPCTSTR,DWORD);
	LONG EnumValues(UINT,LPTSTR,DWORD*,LPTSTR,DWORD*);
	void DeleteValue(LPCTSTR);
	void SetString(LPCTSTR,LPCTSTR);
};
