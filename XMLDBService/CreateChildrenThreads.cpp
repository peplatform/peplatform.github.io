#include "stdafx.h"
// This is always needed
#include "Service.h"

#include "CDirThread.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

// Yucky global data stuff
extern SERVICE_DATA sdServiceData;

bool CreateChildrenThreads(void)
{
	// Create the dir thread
	CDirThread* pThread = new CDirThread();
	pThread->CreateThread();

	return true;
}
