//	Zinc Interface Library - Z_STDARG.HPP
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA

extern "C"
{
#include <stdio.h>
#include <stdarg.h>
}

const int ZIL_MAXPARAMLEN				= 512;

class ZIL_EXPORT_CLASS ZIL_STDARG : public ZIL_INTERNATIONAL
{
public:
	static int vsprintf(ZIL_ICHAR *buffer, const ZIL_ICHAR *format, va_list argList);
	static int vsscanf(ZIL_ICHAR *buffer, const ZIL_ICHAR *format, va_list argList);
	static void RearrangeArgs(int isScanf, void *newBuffer,
				  const ZIL_ICHAR *format, const va_list ap,
				  ZIL_ICHAR *newFormat, va_list *toRet);
	static int _vsprintf(ZIL_ICHAR *fp, const ZIL_ICHAR *fmt, va_list ap);
	static int _vsscanf(ZIL_ICHAR *fp, const ZIL_ICHAR *fmt, va_list ap);
};

