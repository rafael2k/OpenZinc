//	Zinc Interface Library - LIBMAIN.CPP
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA

/*       This file is a part of OpenZinc

          OpenZinc is free software; you can redistribute it and/or modify it under
          the terms of the GNU Lessor General Public License as published by
          the Free Software Foundation, either version 3 of the License, or (at
          your option) any later version

	OpenZinc is distributed in the hope that it will be useful, but WITHOUT
          ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
          or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser 
          General Public License for more details.

          You should have received a copy of the GNU Lessor General Public License
	 along with OpenZinc. If not, see <http://www.gnu.org/licenses/>                          */


#include "ui_gen.hpp"

int FAR PASCAL LibMain(HANDLE hInstance, WORD wDataSegment, WORD wHeapSize, LPSTR lpszCmdLine)
{
	if (wHeapSize != 0)
		UnlockData(0);
	return (1);
}

int FAR PASCAL WEP(int bSystemExit)
{
	return (1);
}

