/////////////////////////////////////////////////
//
//
//
//
///////////////////////////////////////////////////
#include "stdafx.h"
#include "windows.h"

#import "msxml4.dll" rename_namespace("xml")
int main(int argc, char* argv[])
{

    CoInitialize( NULL );         // Register with COM 

    {
        HRESULT hRes;

        xml::IXMLDOMDocumentPtr spDocument;
        xml::IXMLDOMElementPtr spRootElement;
        xml::IXMLDOMTextPtr spSomeText;

        hRes = spDocument.CreateInstance( __uuidof( xml::DOMDocument) );

        if  ( FAILED(hRes) ) 
        {   
            printf("Failed to create DOM document : %08x\n", hRes );
            return 1;
        }

        try
        {
            spRootElement = spDocument->createElement( "COMDeveloper" );
            spDocument->appendChild( spRootElement );
            spSomeText = spDocument->createTextNode( "Hello XML" );
            spRootElement->appendChild( spSomeText );
        }
        catch( _com_error err )
        {
            printf("Failed to create element\n");
            printf("%08x - %S\n", err.Error(), err.Description() );
            return 1;
        }

        spDocument->save( "c:\\dexplorer.xml" );
    }    

    CoUninitialize();                   // Unregister with COM

	return 0;
}

