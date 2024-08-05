const EVENT_TYPE U_LEFT_ARROW = 10000;
const EVENT_TYPE U_RIGHT_ARROW = 10001;

class VIEW_WIN : public UIW_WINDOW
{
public:
	UIW_IMAGE *i1,*i2;
	int imageNumber;

	VIEW_WIN(void);
   ~VIEW_WIN();
   EVENT_TYPE Event(const UI_EVENT &event);
};


