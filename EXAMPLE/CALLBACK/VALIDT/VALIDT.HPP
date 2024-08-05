//	VALIDATE.HPP (VALIDATE) - Validate example program.
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#if !defined(__MWERKS__)
extern "C"
{
#endif
	#include <string.h>
#if !defined(__MWERKS__)
}
#endif
#include <ui_win.hpp>

//  Define the validate class.
class ZIL_EXPORT_CLASS VALIDATE : public UIW_WINDOW
{
public:
	VALIDATE(int left, int top, int helpContext);
	virtual ~VALIDATE(void) {}

private:
	
	// Define the field pointers.
	UIW_BIGNUM *inputA;
	UIW_BIGNUM *inputB;
	UIW_BIGNUM *inputC;
	UIW_BIGNUM *totalField;

	//	The following is a description of the method used in this program
	//	to resolve the C++ code limitations that static class members do not
	//	have access to non static class members and only static class members
	//	can have their address passed as a parameter, as is
	//	needed for validate and user functions:

	//	The address of the static member function, Validation, is passed to
	//	the UIW_BIGNUM constructor when the UIW_BIGNUM objects are created.  When 
	//	called, this function is only a	dummy function to call the non-static
	//	function, MemberValidate, which	has access to all of the non-static
	//	members of VALIDATE.
	//	
	//	To help understand the function of the two lines in the dummy
	//	Validation function, note that these lines could be replaced with the
	//  following three lines:
	//			UIW_BIGNUM *number = (UIW_BIGNUM *)object;
	//			VALIDATE *validateThis = (VALIDATE *)number->parent;
	//          return validateThis->MemberValidate(object, event, ccode);
	//  	
	static EVENT_TYPE CallCompute(UI_WINDOW_OBJECT *object,
		UI_EVENT &event, EVENT_TYPE ccode);
	void ComputeTotal(void);
	static EVENT_TYPE Validation(UI_WINDOW_OBJECT *object, 
       UI_EVENT &event, EVENT_TYPE ccode)
	{
		return (((VALIDATE *)object->parent)->MemberValidate(object, event, ccode));
	}
	
	//  Define MemberValidate as a non static member function.
	virtual EVENT_TYPE MemberValidate(UI_WINDOW_OBJECT *object, UI_EVENT &event, 
       EVENT_TYPE ccode);
};
