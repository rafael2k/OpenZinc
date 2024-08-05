class ZIL_EXPORT_CLASS SPINNER_REAL : public UIW_REAL
{
public:
	SPINNER_REAL(int left, int top, int width, double *value, double *delta,
		const ZIL_ICHAR *range = ZIL_NULLP(ZIL_ICHAR),
		NMF_FLAGS nmFlags = NMF_NO_FLAGS,
		WOF_FLAGS woFlags = WOF_BORDER | WOF_AUTO_CLEAR,
		ZIL_USER_FUNCTION userFunction = ZIL_NULLF(ZIL_USER_FUNCTION));

	virtual void *Information(ZIL_INFO_REQUEST request, void *data,
		ZIL_OBJECTID objectID = ID_DEFAULT);

private:
	double realDelta;
	void ValueDecrement(double delta);
	void ValueIncrement(double delta);
};
