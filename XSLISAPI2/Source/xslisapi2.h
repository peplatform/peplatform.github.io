

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


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



/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 500
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif /* __RPCNDR_H_VERSION__ */

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __xslisapi2_h__
#define __xslisapi2_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#ifndef DECLSPEC_XFGVIRT
#if defined(_CONTROL_FLOW_GUARD_XFG)
#define DECLSPEC_XFGVIRT(base, func) __declspec(xfg_virtual(base, func))
#else
#define DECLSPEC_XFGVIRT(base, func)
#endif
#endif

/* Forward Declarations */ 

#ifndef __IXMLServerDocument_FWD_DEFINED__
#define __IXMLServerDocument_FWD_DEFINED__
typedef interface IXMLServerDocument IXMLServerDocument;

#endif 	/* __IXMLServerDocument_FWD_DEFINED__ */


#ifndef __IASPPreprocessor_FWD_DEFINED__
#define __IASPPreprocessor_FWD_DEFINED__
typedef interface IASPPreprocessor IASPPreprocessor;

#endif 	/* __IASPPreprocessor_FWD_DEFINED__ */


#ifndef __XMLServerDocument_FWD_DEFINED__
#define __XMLServerDocument_FWD_DEFINED__

#ifdef __cplusplus
typedef class XMLServerDocument XMLServerDocument;
#else
typedef struct XMLServerDocument XMLServerDocument;
#endif /* __cplusplus */

#endif 	/* __XMLServerDocument_FWD_DEFINED__ */


#ifndef __ASPPreprocessor_FWD_DEFINED__
#define __ASPPreprocessor_FWD_DEFINED__

#ifdef __cplusplus
typedef class ASPPreprocessor ASPPreprocessor;
#else
typedef struct ASPPreprocessor ASPPreprocessor;
#endif /* __cplusplus */

#endif 	/* __ASPPreprocessor_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __IXMLServerDocument_INTERFACE_DEFINED__
#define __IXMLServerDocument_INTERFACE_DEFINED__

/* interface IXMLServerDocument */
/* [unique][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IXMLServerDocument;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("1beafdb7-0d85-4410-bff1-32ccda969986")
    IXMLServerDocument : public IDispatch
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE Write( 
            /* [in] */ BSTR bstrText) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE End( void) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Flush( void) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Clear( void) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE WriteLine( 
            /* [in] */ BSTR bstrLine) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Transform( 
            /* [in] */ IDispatch *pdispResponse) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Load( 
            /* [in] */ BSTR bstrFileName) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE HandleError( 
            /* [in] */ IDispatch *pdispResponse) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SetError( 
            /* [in] */ BSTR errorString,
            /* [in] */ BSTR errorURL,
            /* [in] */ BSTR errorHTTPCode) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE ClearError( void) = 0;
        
        virtual /* [propput] */ HRESULT STDMETHODCALLTYPE put_URL( 
            /* [in] */ BSTR bstrURL) = 0;
        
        virtual /* [propput] */ HRESULT STDMETHODCALLTYPE put_UserAgent( 
            /* [in] */ BSTR bstrUserAgent) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct IXMLServerDocumentVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IXMLServerDocument * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IXMLServerDocument * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IXMLServerDocument * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            IXMLServerDocument * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            IXMLServerDocument * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            IXMLServerDocument * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            IXMLServerDocument * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, Write)
        HRESULT ( STDMETHODCALLTYPE *Write )( 
            IXMLServerDocument * This,
            /* [in] */ BSTR bstrText);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, End)
        HRESULT ( STDMETHODCALLTYPE *End )( 
            IXMLServerDocument * This);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, Flush)
        HRESULT ( STDMETHODCALLTYPE *Flush )( 
            IXMLServerDocument * This);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, Clear)
        HRESULT ( STDMETHODCALLTYPE *Clear )( 
            IXMLServerDocument * This);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, WriteLine)
        HRESULT ( STDMETHODCALLTYPE *WriteLine )( 
            IXMLServerDocument * This,
            /* [in] */ BSTR bstrLine);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, Transform)
        HRESULT ( STDMETHODCALLTYPE *Transform )( 
            IXMLServerDocument * This,
            /* [in] */ IDispatch *pdispResponse);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, Load)
        HRESULT ( STDMETHODCALLTYPE *Load )( 
            IXMLServerDocument * This,
            /* [in] */ BSTR bstrFileName);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, HandleError)
        HRESULT ( STDMETHODCALLTYPE *HandleError )( 
            IXMLServerDocument * This,
            /* [in] */ IDispatch *pdispResponse);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, SetError)
        HRESULT ( STDMETHODCALLTYPE *SetError )( 
            IXMLServerDocument * This,
            /* [in] */ BSTR errorString,
            /* [in] */ BSTR errorURL,
            /* [in] */ BSTR errorHTTPCode);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, ClearError)
        HRESULT ( STDMETHODCALLTYPE *ClearError )( 
            IXMLServerDocument * This);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, put_URL)
        /* [propput] */ HRESULT ( STDMETHODCALLTYPE *put_URL )( 
            IXMLServerDocument * This,
            /* [in] */ BSTR bstrURL);
        
        DECLSPEC_XFGVIRT(IXMLServerDocument, put_UserAgent)
        /* [propput] */ HRESULT ( STDMETHODCALLTYPE *put_UserAgent )( 
            IXMLServerDocument * This,
            /* [in] */ BSTR bstrUserAgent);
        
        END_INTERFACE
    } IXMLServerDocumentVtbl;

    interface IXMLServerDocument
    {
        CONST_VTBL struct IXMLServerDocumentVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IXMLServerDocument_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IXMLServerDocument_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IXMLServerDocument_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IXMLServerDocument_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define IXMLServerDocument_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define IXMLServerDocument_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define IXMLServerDocument_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define IXMLServerDocument_Write(This,bstrText)	\
    ( (This)->lpVtbl -> Write(This,bstrText) ) 

#define IXMLServerDocument_End(This)	\
    ( (This)->lpVtbl -> End(This) ) 

#define IXMLServerDocument_Flush(This)	\
    ( (This)->lpVtbl -> Flush(This) ) 

#define IXMLServerDocument_Clear(This)	\
    ( (This)->lpVtbl -> Clear(This) ) 

#define IXMLServerDocument_WriteLine(This,bstrLine)	\
    ( (This)->lpVtbl -> WriteLine(This,bstrLine) ) 

#define IXMLServerDocument_Transform(This,pdispResponse)	\
    ( (This)->lpVtbl -> Transform(This,pdispResponse) ) 

#define IXMLServerDocument_Load(This,bstrFileName)	\
    ( (This)->lpVtbl -> Load(This,bstrFileName) ) 

#define IXMLServerDocument_HandleError(This,pdispResponse)	\
    ( (This)->lpVtbl -> HandleError(This,pdispResponse) ) 

#define IXMLServerDocument_SetError(This,errorString,errorURL,errorHTTPCode)	\
    ( (This)->lpVtbl -> SetError(This,errorString,errorURL,errorHTTPCode) ) 

#define IXMLServerDocument_ClearError(This)	\
    ( (This)->lpVtbl -> ClearError(This) ) 

#define IXMLServerDocument_put_URL(This,bstrURL)	\
    ( (This)->lpVtbl -> put_URL(This,bstrURL) ) 

#define IXMLServerDocument_put_UserAgent(This,bstrUserAgent)	\
    ( (This)->lpVtbl -> put_UserAgent(This,bstrUserAgent) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IXMLServerDocument_INTERFACE_DEFINED__ */


#ifndef __IASPPreprocessor_INTERFACE_DEFINED__
#define __IASPPreprocessor_INTERFACE_DEFINED__

/* interface IASPPreprocessor */
/* [unique][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IASPPreprocessor;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("9db9b8c2-aa4e-4ac2-8ce0-d079432035d9")
    IASPPreprocessor : public IDispatch
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE Process( 
            /* [in] */ BSTR bstrSrcFile,
            /* [retval][out] */ BSTR *pbstrOutFile) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct IASPPreprocessorVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IASPPreprocessor * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IASPPreprocessor * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IASPPreprocessor * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            IASPPreprocessor * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            IASPPreprocessor * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            IASPPreprocessor * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            IASPPreprocessor * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        DECLSPEC_XFGVIRT(IASPPreprocessor, Process)
        HRESULT ( STDMETHODCALLTYPE *Process )( 
            IASPPreprocessor * This,
            /* [in] */ BSTR bstrSrcFile,
            /* [retval][out] */ BSTR *pbstrOutFile);
        
        END_INTERFACE
    } IASPPreprocessorVtbl;

    interface IASPPreprocessor
    {
        CONST_VTBL struct IASPPreprocessorVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IASPPreprocessor_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IASPPreprocessor_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IASPPreprocessor_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IASPPreprocessor_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define IASPPreprocessor_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define IASPPreprocessor_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define IASPPreprocessor_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define IASPPreprocessor_Process(This,bstrSrcFile,pbstrOutFile)	\
    ( (This)->lpVtbl -> Process(This,bstrSrcFile,pbstrOutFile) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IASPPreprocessor_INTERFACE_DEFINED__ */



#ifndef __XSLISAPI2Lib_LIBRARY_DEFINED__
#define __XSLISAPI2Lib_LIBRARY_DEFINED__

/* library XSLISAPI2Lib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_XSLISAPI2Lib;

EXTERN_C const CLSID CLSID_XMLServerDocument;

#ifdef __cplusplus

class DECLSPEC_UUID("e92356a1-1f0f-4251-b9d8-111680978b86")
XMLServerDocument;
#endif

EXTERN_C const CLSID CLSID_ASPPreprocessor;

#ifdef __cplusplus

class DECLSPEC_UUID("006938ee-be8e-443c-8ddf-63bcd3de73b0")
ASPPreprocessor;
#endif
#endif /* __XSLISAPI2Lib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

unsigned long             __RPC_USER  BSTR_UserSize(     unsigned long *, unsigned long            , BSTR * ); 
unsigned char * __RPC_USER  BSTR_UserMarshal(  unsigned long *, unsigned char *, BSTR * ); 
unsigned char * __RPC_USER  BSTR_UserUnmarshal(unsigned long *, unsigned char *, BSTR * ); 
void                      __RPC_USER  BSTR_UserFree(     unsigned long *, BSTR * ); 

unsigned long             __RPC_USER  BSTR_UserSize64(     unsigned long *, unsigned long            , BSTR * ); 
unsigned char * __RPC_USER  BSTR_UserMarshal64(  unsigned long *, unsigned char *, BSTR * ); 
unsigned char * __RPC_USER  BSTR_UserUnmarshal64(unsigned long *, unsigned char *, BSTR * ); 
void                      __RPC_USER  BSTR_UserFree64(     unsigned long *, BSTR * ); 

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


