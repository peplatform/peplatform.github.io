; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CProductSet
LastTemplate=CRecordset
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "XMLDBService.h"
ODLFile=XMLDBService.odl
LastPage=0

ClassCount=7
Class1=CXMLDBServiceApp
Class2=CXMLDBServiceDoc
Class3=CXMLDBServiceView
Class4=CMainFrame

ResourceCount=2
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Class5=CAboutDlg
Class6=CDirThread
Class7=CProductSet

[CLS:CXMLDBServiceApp]
Type=0
HeaderFile=XMLDBService.h
ImplementationFile=XMLDBService.cpp
Filter=N
BaseClass=CWinApp
VirtualFilter=AC
LastObject=CXMLDBServiceApp

[CLS:CXMLDBServiceDoc]
Type=0
HeaderFile=XMLDBServiceDoc.h
ImplementationFile=XMLDBServiceDoc.cpp
Filter=N
BaseClass=CDocument
VirtualFilter=DC

[CLS:CXMLDBServiceView]
Type=0
HeaderFile=XMLDBServiceView.h
ImplementationFile=XMLDBServiceView.cpp
Filter=C
LastObject=CXMLDBServiceView

[CLS:CMainFrame]
Type=0
HeaderFile=MainFrm.h
ImplementationFile=MainFrm.cpp
Filter=T



[CLS:CAboutDlg]
Type=0
HeaderFile=XMLDBService.cpp
ImplementationFile=XMLDBService.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[MNU:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_FILE_SAVE_AS
Command5=ID_APP_EXIT
Command6=ID_EDIT_UNDO
Command7=ID_EDIT_CUT
Command8=ID_EDIT_COPY
Command9=ID_EDIT_PASTE
Command10=ID_VIEW_STATUS_BAR
Command11=ID_APP_ABOUT
CommandCount=11

[ACL:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_EDIT_UNDO
Command5=ID_EDIT_CUT
Command6=ID_EDIT_COPY
Command7=ID_EDIT_PASTE
Command8=ID_EDIT_UNDO
Command9=ID_EDIT_CUT
Command10=ID_EDIT_COPY
Command11=ID_EDIT_PASTE
Command12=ID_NEXT_PANE
Command13=ID_PREV_PANE
CommandCount=13

[CLS:CDirThread]
Type=0
HeaderFile=CDirThread.h
ImplementationFile=CDirThread.cpp
BaseClass=CWinThread
Filter=N
VirtualFilter=TC
LastObject=CDirThread

[CLS:CProductSet]
Type=0
HeaderFile=CProductSet.h
ImplementationFile=CProductSet.cpp
BaseClass=CRecordset
Filter=N
VirtualFilter=r
LastObject=CProductSet

[DB:CProductSet]
DB=1
DBType=ODBC
ColumnCount=6
Column1=[ProdID], 4, 4
Column2=[Name], 1, 40
Column3=[Price], 3, 21
Column4=[QtyOnHand], 4, 4
Column5=[Color], 1, 10
Column6=[ShipOpts], -6, 1

