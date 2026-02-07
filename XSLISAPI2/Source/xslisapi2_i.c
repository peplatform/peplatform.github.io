

/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 8.01.0628 */
/* at Mon Jan 18 22:14:07 2038
 */
/* Compiler settings for xslisapi2.idl:
    Oicf, W1, Zp8, env=Win32 (32b run), target_arch=X86 8.01.0628 
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */



#ifdef __cplusplus
extern "C"{
#endif 


#include <rpc.h>
#include <rpcndr.h>

#ifdef _MIDL_USE_GUIDDEF_

#ifndef INITGUID
#define INITGUID
#include <guiddef.h>
#undef INITGUID
#else
#include <guiddef.h>
#endif

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        DEFINE_GUID(name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8)

#else // !_MIDL_USE_GUIDDEF_

#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        EXTERN_C __declspec(selectany) const type name = {l,w1,w2,{b1,b2,b3,b4,b5,b6,b7,b8}}

#endif // !_MIDL_USE_GUIDDEF_

MIDL_DEFINE_GUID(IID, IID_IXMLServerDocument,0x1beafdb7,0x0d85,0x4410,0xbf,0xf1,0x32,0xcc,0xda,0x96,0x99,0x86);


MIDL_DEFINE_GUID(IID, IID_IASPPreprocessor,0x9db9b8c2,0xaa4e,0x4ac2,0x8c,0xe0,0xd0,0x79,0x43,0x20,0x35,0xd9);


MIDL_DEFINE_GUID(IID, LIBID_XSLISAPI2Lib,0x9A31B2D4,0x52BB,0x4D05,0x92,0x09,0x1C,0xB2,0x6D,0xFF,0xD4,0xC1);


MIDL_DEFINE_GUID(CLSID, CLSID_XMLServerDocument,0xe92356a1,0x1f0f,0x4251,0xb9,0xd8,0x11,0x16,0x80,0x97,0x8b,0x86);


MIDL_DEFINE_GUID(CLSID, CLSID_ASPPreprocessor,0x006938ee,0xbe8e,0x443c,0x8d,0xdf,0x63,0xbc,0xd3,0xde,0x73,0xb0);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



