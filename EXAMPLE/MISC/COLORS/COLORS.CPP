//      COLORS.CPP (COLORS) - 256 color program.
//      COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//      Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//  May be freely copied, used and distributed.


#include <ui_win.hpp>


#include "colors.hpp"

#if !defined (ZIL_MSDOS) && !defined(ZIL_CURSES)
static ZIL_COLOR _colorTable[256] =
{
        RGB_BLACK, RGB_BLUE, RGB_GREEN, RGB_CYAN, RGB_RED, RGB_MAGENTA, RGB_BROWN,
        RGB_LIGHTGRAY, RGB_DARKGRAY, RGB_LIGHTBLUE, RGB_LIGHTGREEN, RGB_LIGHTCYAN,
        RGB_LIGHTRED, RGB_LIGHTMAGENTA, RGB_YELLOW, RGB_WHITE, PAL_16, PAL_17, PAL_18, PAL_19,
        PAL_20, PAL_21, PAL_22, PAL_23, PAL_24, PAL_25, PAL_26, PAL_27, PAL_28, PAL_29,
        PAL_30, PAL_31, PAL_32, PAL_33, PAL_34, PAL_35, PAL_36, PAL_37, PAL_38, PAL_39,
        PAL_40, PAL_41, PAL_42, PAL_43, PAL_44, PAL_45, PAL_46, PAL_47, PAL_48, PAL_49,
        PAL_50, PAL_51, PAL_52, PAL_53, PAL_54, PAL_55, PAL_56, PAL_57, PAL_58, PAL_59,
        PAL_60, PAL_61, PAL_62, PAL_63, PAL_64, PAL_65, PAL_66, PAL_67, PAL_68, PAL_69,
        PAL_70, PAL_71, PAL_72, PAL_73, PAL_74, PAL_75, PAL_76, PAL_77, PAL_78, PAL_79,
        PAL_80, PAL_81, PAL_82, PAL_83, PAL_84, PAL_85, PAL_86, PAL_87, PAL_88, PAL_89,
        PAL_90, PAL_91, PAL_92, PAL_93, PAL_94, PAL_95, PAL_96, PAL_97, PAL_98, PAL_99,
        PAL_100, PAL_101, PAL_102, PAL_103,     PAL_104, PAL_105, PAL_106, PAL_107, PAL_108, PAL_109,
        PAL_110, PAL_111, PAL_112, PAL_113, PAL_114, PAL_115, PAL_116, PAL_117, PAL_118, PAL_119,
        PAL_120, PAL_121, PAL_122, PAL_123, PAL_124, PAL_125, PAL_126, PAL_127, PAL_128, PAL_129,
        PAL_130, PAL_131, PAL_132, PAL_133, PAL_134, PAL_135, PAL_136, PAL_137, PAL_138, PAL_139,
        PAL_140, PAL_141, PAL_142, PAL_143, PAL_144, PAL_145, PAL_146, PAL_147, PAL_148, PAL_149,
        PAL_150, PAL_151, PAL_152, PAL_153, PAL_154, PAL_155, PAL_156, PAL_157, PAL_158, PAL_159,
        PAL_160, PAL_161, PAL_162, PAL_163, PAL_164, PAL_165, PAL_166, PAL_167, PAL_168, PAL_169,
        PAL_170, PAL_171, PAL_172, PAL_173, PAL_174, PAL_175, PAL_176, PAL_177, PAL_178, PAL_179,
        PAL_180, PAL_181, PAL_182, PAL_183, PAL_184, PAL_185, PAL_186, PAL_187, PAL_188, PAL_189,
        PAL_190, PAL_191, PAL_192, PAL_193, PAL_194, PAL_195, PAL_196, PAL_197, PAL_198, PAL_199,
        PAL_200, PAL_201, PAL_202, PAL_203,     PAL_204, PAL_205, PAL_206, PAL_207, PAL_208, PAL_209,
        PAL_210, PAL_211, PAL_212, PAL_213, PAL_214, PAL_215, PAL_216, PAL_217, PAL_218, PAL_219,
        PAL_220, PAL_221, PAL_222, PAL_223, PAL_224, PAL_225, PAL_226, PAL_227, PAL_228, PAL_229,
        PAL_230, PAL_231, PAL_232, PAL_233, PAL_234, PAL_235, PAL_236, PAL_237, PAL_238, PAL_239,
        PAL_240, PAL_241, PAL_242, PAL_243, PAL_244, PAL_245, PAL_246, PAL_247, PAL_248, PAL_249,
        PAL_250, PAL_251, PAL_252, PAL_253, PAL_254, PAL_255
};
#endif

COLORS_WINDOW::COLORS_WINDOW(void) : UIW_WINDOW(0, 0, 0, 0, WOF_NON_FIELD_REGION, WOAF_NON_CURRENT)
{
        woStatus |= WOS_OWNERDRAW;
#if !defined(ZIL_MSDOS) && !defined(ZIL_CURSES)
        colorTable = _colorTable;
#endif
}

void COLORS_WINDOW::RGBConvert(int colorIndex, UI_PALETTE &palette)
{
#if defined(ZIL_MSDOS) || defined(ZIL_CURSES)
        // Don't use color 255, since it is defined as transparent.
        ZIL_COLOR color = colorIndex == 255 ? (ZIL_COLOR)colorIndex - 1 :
                (ZIL_COLOR)colorIndex;
        palette.colorForeground = BLACK;
        palette.fillPattern = PTN_SOLID_FILL;
#else
        ZIL_COLOR color = colorTable[colorIndex];
        palette.colorForeground = RGB_BLACK;
        palette.fillPattern = PTN_RGB_COLOR;
        // Convert RGB values to BGR values for Windows.
#       if defined(ZIL_MSWINDOWS)
        if (colorIndex >= 16)
                color = ((color & 0x00FF0000L) >> 16) | (color & 0x0000FF00L) |
                        ((color & 0x000000FFL) << 16);
#       endif
#endif
        palette.colorBackground = color;
}

EVENT_TYPE COLORS_WINDOW::DrawItem(const UI_EVENT &, EVENT_TYPE )
{
        display->VirtualGet(screenID, trueRegion);

        static UI_PALETTE palette =
                { ' ', attrib(BLACK, WHITE), attrib(MONO_HIGH, MONO_BLACK),
                PTN_SOLID_FILL, BLACK, WHITE, BW_WHITE, BW_BLACK, GS_BLACK, GS_GRAY };

        // Reset the background to white and draw the background of the window.
        RGBConvert(15, palette);
        display->Rectangle(screenID, trueRegion, &palette, 0, TRUE, FALSE, &clip);

        // Compute the draw region then draw the boxes and text.
        static int BOX_COUNT = 16;
        ZIL_ICHAR number[4];
        int spacing = display->TextHeight("Wq", screenID, FNT_SMALL_FONT) + 2;
        int boxWidth = (trueRegion.Width() - (BOX_COUNT + 1) * (spacing / 2)) / BOX_COUNT;
        int boxHeight = (trueRegion.Height() - 2 - BOX_COUNT * spacing) / BOX_COUNT;
        int left = trueRegion.left + spacing / 2;
        int top = trueRegion.top + spacing;

        for (int i = 0, color = 0; i < BOX_COUNT; i++)
        {
                for (int j = 0; j < BOX_COUNT; j++)
                {
                        // Re-assign the palette.
                        RGBConvert(color, palette);

                        itoa(color, number, 10);
                        display->Text(screenID, left, top - spacing + 1, number,
                                &palette, -1, FALSE, FALSE, &clip, FNT_SMALL_FONT);
                        display->Rectangle(screenID, left, top, left + boxWidth - 1, top + boxHeight - 1,
                                &palette, 1, TRUE, FALSE, &clip);
                        color++;
                        left += boxWidth + spacing / 2;                                                                                                                                         
                }
                left = trueRegion.left + spacing / 2;
                top += boxHeight + spacing;
        }
        
        display->VirtualPut(screenID);
        return (TRUE);  // Draw operation is not complete until children are drawn.
}

#if defined(ZIL_MSDOS)
main()
{
        // Create the MSDOS display.
#       if defined(DOS16PP)
        UI_DISPLAY *display = new UI_BGI_DISPLAY;
#       elif defined(DOS32PP)
        UI_DISPLAY *display = new UI_BGI_DISPLAY(256);
#       elif (__WATCOMC__ >= 1050)
        UI_DISPLAY *display = new UI_WCC_DISPLAY;
#       else
        UI_DISPLAY *display = new UI_GRAPHICS_DISPLAY(0x101);
#       endif
        if (!display->installed)
        {
                delete display;
                display = new UI_TEXT_DISPLAY;
        }
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

        // Create the window manager.
        UI_WINDOW_MANAGER *windowManager = new UI_WINDOW_MANAGER(display, eventManager);

        // Create the colors window and add it to the window manager.
        UIW_WINDOW *window = UIW_WINDOW::Generic(0, 0, 60, 18, "COLOR WINDOW",
                ZIL_NULLP(UI_WINDOW_OBJECT), WOF_NO_FLAGS, WOAF_NO_SIZE);
        *window
                + new COLORS_WINDOW();
        windowManager->Center(window);
        *windowManager
                + window;

        // Process user responses.
        UI_EVENT event;
        EVENT_TYPE ccode;
        do
        {
                // Get input from the user.
                eventManager->Get(event);

                // Send event information to the window manager.
                ccode = windowManager->Event(event);
        } while (ccode != L_EXIT && ccode != S_NO_OBJECT);

        // Clean up.
        delete windowManager;
        delete eventManager;
        delete display;

        return (0);
}

#else

int UI_APPLICATION::Main()
{
        // The UI_APPLICATION constructor automatically initializes the
        // display, eventManager, and windowManager variables.

        // This line fixes linkers that don't look for main in the .LIBs.
        UI_APPLICATION::LinkMain();

        // Create the colors window and add it to the window manager.
        UIW_WINDOW *window = UIW_WINDOW::Generic(0, 0, 60, 18, "COLOR WINDOW",
                ZIL_NULLP(UI_WINDOW_OBJECT), WOF_NO_FLAGS, WOAF_NO_SIZE);
        *window
                + new COLORS_WINDOW();
        windowManager->Center(window);
        *windowManager
                + window;

        // Process user responses.
        UI_APPLICATION::Control();

        return (0);
}

#endif
