#include <ui_win.hpp>

class btWin : public UIW_WINDOW
{
public:
        btWin(char *name,ZIL_STORAGE_READ_ONLY *storage);
private:
        enum grp1Msgs { grp1bt1 = 10000, grp1bt2 = 10001} ;
        enum grp2Msgs { grp2bt1 = 10002, grp2bt2 = 10003, grp2bt3 = 10004 } ;  
        EVENT_TYPE Event(const UI_EVENT &event);
        UIW_BUTTON *bt[5];  
        void setGrp1bt(int idx); 
        void setGrp2bt(int idx);          
        BOOL resetBt(UI_WINDOW_OBJECT *obj);
        BOOL setBt(UI_WINDOW_OBJECT *obj);
};

btWin::btWin(char *name,ZIL_STORAGE_READ_ONLY *storage)
        :UIW_WINDOW(name,storage)
{
        bt[0] = (UIW_BUTTON *)Get("B_1");
        bt[1] = (UIW_BUTTON *)Get("B_2");
        bt[2] = (UIW_BUTTON *)Get("B_3");
        bt[3] = (UIW_BUTTON *)Get("B_4");
        bt[4] = (UIW_BUTTON *)Get("B_5");
        setBt(bt[0]); 
        setBt(bt[2]);
}


EVENT_TYPE btWin::Event(const UI_EVENT &event)
{
    EVENT_TYPE ccode = event.type;
    
    // Switch on the event type.
    switch(ccode)
    {
       case grp1bt1   : 
       case grp1bt2   : setGrp1bt(ccode-10000);
                        break;
       case grp2bt1   : 
       case grp2bt2   : 
       case grp2bt3   : setGrp2bt(ccode-10000);
                        break;
       default:
            ccode = UIW_WINDOW::Event(event);
    }
    return(ccode);
}

void   btWin::setGrp1bt(int idx)
{
   switch(idx)
   {
        case 0:setBt(bt[0]);resetBt(bt[1]);break;
        case 1:setBt(bt[1]);resetBt(bt[0]);break;                          
   }
}

void   btWin::setGrp2bt(int idx)
{
   switch(idx)
   {
        case 2:setBt(bt[2]);resetBt(bt[3]);resetBt(bt[4]);break;
        case 3:setBt(bt[3]);resetBt(bt[2]);resetBt(bt[4]);break;                          
        case 4:setBt(bt[4]);resetBt(bt[2]);resetBt(bt[3]);break;
   }

}

BOOL btWin::resetBt(UI_WINDOW_OBJECT *obj)
{
    UIS_STATUS status  = WOS_SELECTED;
    if (FlagSet(obj->woStatus, status))
    {
       obj->Information(I_CLEAR_STATUS,&status,ID_WINDOW_OBJECT);
       obj->Information(I_CHANGED_STATUS, NULL);
    }
    return(TRUE);
}

BOOL btWin::setBt(UI_WINDOW_OBJECT *obj)
{
    UIS_STATUS status  = WOS_SELECTED;
    if (!FlagSet(obj->woStatus, status))
    {
       obj->Information(I_SET_STATUS,&status,ID_WINDOW_OBJECT);
       obj->Information(I_CHANGED_STATUS, NULL);
    }
    return(TRUE);
}

void openWindow()
{
        ZIL_STORAGE_READ_ONLY *DatFile = new ZIL_STORAGE_READ_ONLY("rd_bt.dat");        
        if (DatFile->storageError)
        {
            delete DatFile;
            DatFile = NULL ;
        }
        else
        {   
            UIW_WINDOW  *win = new btWin("rd_bt.dat~WIN_BUTTON",DatFile);        
            delete DatFile;
           
            UIW_WINDOW::windowManager->Center(win);
            UIW_WINDOW::windowManager->Add(win);
        }
}

int UI_APPLICATION::Main(void)
{
                

        UI_APPLICATION::LinkMain();
        UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM();
        
                

        // Process user responses.
        openWindow();
        Control();
            
        return (0);
}
