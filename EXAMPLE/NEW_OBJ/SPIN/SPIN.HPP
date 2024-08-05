//	SPIN.HPP (SPIN) - Using spin control and slider
//	COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//	Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

const int MIN_PLAYBACK_SPEED = 0;
const int MAX_PLAYBACK_SPEED = 50;

class ZIL_EXPORT_CLASS PLAYBACK_CONTROL: public UIW_STRING
{
public:
    PLAYBACK_CONTROL(void);
    void *Information(INFO_REQUEST request, void *data, ZIL_OBJECTID);

private:
    int rate;
    ZIL_ICHAR buffer[32];
};
