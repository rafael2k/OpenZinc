//      ZINCAPP.CPP (ZINCAPP) - This file contains the main program loop.
//      COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//      Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.

#if defined(_MSC_VER)
#include <new.h>
#endif
#include <ui_win.hpp>
#include "zincapp.hpp"
#define USE_HELP_CONTEXTS
#include "support.hpp"

#if !(__BORLANDC__ >= 0x500)
extern "C"
{
#endif
#include <stdlib.h>
#include <stdio.h>
#if !(__BORLANDC__ >= 0x500)
}
#endif

#if defined(__BCPLUSPLUS__) || defined(__TCPLUSPLUS__)
extern unsigned _stklen = 8192;
#endif
#if defined(DOS32PP)
void CommitStack(void)
// NOTE: must compile with the -N switch to enable stack overflow
// checking before this function can work (Borland uses the stack
// check prologue to commit locals that exceed 4K)
{

   // commit a big chunk of stack space
   long stackgrow[3000];

   stackgrow[2999] = 0;

   return;

}
#endif

#if defined(ZIL_MSDOS) && defined(_MSC_VER)
int NewHandler(size_t size)
{
        printf("\nMemory is all gone.\n");
        return(0);
}
#elif defined(ZIL_MSDOS) && !defined(__WATCOMC__)
void NewHandler(void)
{
        printf("\nMemory is all gone.\n");
        exit(0);
}
#endif

#if !defined(ZIL_NEXTSTEP)
#if defined(ZIL_MSDOS)
main(int argc, char *argv[])
{
        UI_PATH searchPath(argv[0], TRUE);

#       if defined(DOS32PP)
        CommitStack();
#       endif
#       if defined(DOS16PP) || defined(DOS32PP)
        // Create the DOS display.
        UI_DISPLAY *display = new UI_BGI_DISPLAY;
#       elif (__WATCOMC__ >= 1050)
        UI_DISPLAY *display = new UI_WCC_DISPLAY;
#       else
        // Create the DOS display.
        UI_DISPLAY *display = new UI_GRAPHICS_DISPLAY;
#       endif
        if (!display->installed)
        {
                delete display;
                display = new UI_TEXT_DISPLAY;
        }
#elif defined(ZIL_MSWINDOWS)
int PASCAL WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR, int nCmdShow)
{
        UI_PATH searchPath;

        // Create the Windows display.
        UI_DISPLAY *display = new UI_MSWINDOWS_DISPLAY(hInstance, hPrevInstance, nCmdShow);
#elif defined(ZIL_OS2)
main(int argc, char *argv[])
{
        UI_PATH searchPath(argv[0], TRUE);

        // Create the OS/2 display.
        UI_DISPLAY *display = new UI_OS2_DISPLAY;
#elif defined(ZIL_MOTIF)
main(int argc, char **argv)
{
        UI_PATH searchPath(argv[0], TRUE);

        // Create the Motif display.
        UI_DISPLAY *display = new UI_MOTIF_DISPLAY(&argc, argv, "ZincApp");
#elif defined(ZIL_CURSES)
main(int argc, char **argv)
{
        UI_PATH searchPath(argv[0], TRUE);

        // Create the Curses display.
        UI_DISPLAY *display = new UI_TEXT_DISPLAY();
#elif defined(ZIL_MACINTOSH)
main(void)
{
        // Initialize stack, heap and non-relocatable blocks,
        // helping prevent application heap fragmentation.
        // This is usually done by UI_APPLICATION.
        SetApplLimit(GetApplLimit() - 0xf000L); // 60K more on the stack.
        MaxApplZone();
        for (int moreMasterBlocks = 0; moreMasterBlocks < 5; moreMasterBlocks++)
                MoreMasters();

        UI_PATH searchPath;

        // Create the Macintosh display.
        UI_DISPLAY *display = new UI_MACINTOSH_DISPLAY;
#endif

        // Make sure the display installed correctly.
        if (!display || !display->installed)
        {
                delete display;
                return (0);
        }

        // Create the event manager and add devices.
        UI_EVENT_MANAGER *eventManager = new UI_EVENT_MANAGER(display);
        *eventManager
                + new UID_KEYBOARD
                + new UID_MOUSE
                + new UID_CURSOR;

        // Set up the support data storage unit.
        ZIL_STORAGE_READ_ONLY::searchPath = &searchPath;
        UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY("support.dat");

        // Check to see if the default storage was allocated.
        if (UI_WINDOW_OBJECT::defaultStorage->storageError)
        {
                delete UI_WINDOW_OBJECT::defaultStorage;
                delete eventManager;
                delete display;
                return(-1);
        }

        // Initialize the zinc application window manager and add the control window.
        ZINCAPP_WINDOW_MANAGER *windowManager = new ZINCAPP_WINDOW_MANAGER(display, eventManager);
        UIW_WINDOW *window = new CONTROL_WINDOW;
        *windowManager + window;

        // This line assigns the exit function to be called before the control
        // window is closed.  It MUST be after the window is added to windowManager.
        windowManager->screenID = window->screenID;

        // Initialize the help and error systems.
        UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;
        UI_WINDOW_OBJECT::helpSystem = new UI_HELP_SYSTEM("support.dat",
                windowManager, HELP_GENERAL);

#if defined(ZIL_MSDOS) && defined(_MSC_VER)
        _set_new_handler(NewHandler);
#elif defined(ZIL_MSDOS) && !defined(__WATCOMC__) && !defined(__SC__)
        extern void (*_new_handler)();
        _new_handler = NewHandler;
#endif

        // Wait for user response.
        UI_EVENT event;
        EVENT_TYPE ccode;
        do
        {
                // Get input from the user.
                eventManager->Get(event);

                // Check for a screen reset message.
                if (event.type == S_RESET_DISPLAY)
                {
#if defined(ZIL_MSDOS)
                        event.data = ZIL_NULLP(void);

                        // Tell the managers we are changing the display.
                        windowManager->Event(event);
                        eventManager->Event(event);

                        delete display;
                        if (event.rawCode == TDM_NONE)
                        {
#       if defined(DOS32PP)
                                CommitStack();
#       endif
#       if defined(DOS16PP) || defined(DOS32PP)
                                // Create the DOS display.
                                display = new UI_BGI_DISPLAY;
#       elif (__WATCOMC__ >= 1050)
                                // Create the DOS display.
                                display = new UI_WCC_DISPLAY;
#       else
                                // Create the DOS display.
                                display = new UI_GRAPHICS_DISPLAY;
#       endif
                                if (!display->installed)
                                {
                                        delete display;
                                        display = new UI_TEXT_DISPLAY;
                                }
                        }
                        else
                                display = new UI_TEXT_DISPLAY(event.rawCode);

                        // Make sure windows don't have negative coordinates.
                        for (UI_WINDOW_OBJECT *object = windowManager->First();
                                object; object = object->Next())
                        {
                                if (object->relative.top < 0)
                                {
                                        object->relative.bottom = object->relative.Height() - 1;
                                        object->relative.top = 0;
                                }
                                if (object->relative.left < 0)
                                {
                                        object->relative.right = object->relative.Width() - 1;
                                        object->relative.left = 0;
                                }
                        }

                        // Tell the managers we changed the display.
                        event.data = display;
                        eventManager->Event(event);
                        ccode = windowManager->Event(event);
                        windowManager->screenID = window->screenID;
#endif
                }
                else
                        ccode = windowManager->Event(event);
        } while (ccode != L_EXIT && ccode != S_NO_OBJECT);

        // Clean up.
    delete UI_WINDOW_OBJECT::defaultStorage;
        delete UI_WINDOW_OBJECT::helpSystem;
        delete UI_WINDOW_OBJECT::errorSystem;
        delete windowManager;
        delete eventManager;
        delete display;

        return (0);
}
#else
// NEXTSTEP requires use of the UI_APPLICATION class.
int UI_APPLICATION::Main(void)
{
        // The UI_APPLICATION constructor automatically initializes the
        // display, eventManager, and windowManager variables.

        // This line fixes linkers that don't look for main in the .LIBs.
        UI_APPLICATION::LinkMain();
        
        // Set up the support data storage unit.
        UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE("support.dat", UIS_READ);
        
        // Add the control window.
        UIW_WINDOW *window = new CONTROL_WINDOW;
        *windowManager + window;

        // This line assigns the exit function to be called before the control
        // window is closed.  It MUST be after the window is added to windowManager.
        windowManager->screenID = window->screenID;

        // Initialize the help and error systems.
        UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;
        UI_WINDOW_OBJECT::helpSystem = new UI_HELP_SYSTEM("support.dat",
                windowManager, HELP_GENERAL);

        
        // Process user responses.
        UI_APPLICATION::Control();
        
        // Clean up.
        delete UI_WINDOW_OBJECT::helpSystem;
        delete UI_WINDOW_OBJECT::errorSystem;
        
        return (0);
}

#endif
