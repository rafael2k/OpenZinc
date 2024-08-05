//      FONTS.CPP (FONTS) - Shows how to load a new font into the font table.
//      COPYRIGHT (C) 1990-1995.  All Rights Reserved.
//      Zinc Software Incorporated.  Pleasant Grove, Utah  USA
//      May be freely copied, used and distributed.

#define INCL_GPILCIDS   // Specific to OS/2.
#include <ui_win.hpp>
#include "fonts.hpp"

int UI_APPLICATION::Main()
{
        ZIL_ICHAR *text = "The quick brown fox jumped over the lazy dog.";

   UIW_WINDOW *fontWindow = UIW_WINDOW::Generic(0, 0, 45, 12, "Fonts Example");

        LoadFont(display);      // Load the new font into the font table.

        UIW_PROMPT *prompt1 = new UIW_PROMPT(2, 1, "Small ");
        UIW_TEXT *text1 = new UIW_TEXT(12, 1, 30, 2, text, 100, WNF_NO_FLAGS);
        text1->Font(FNT_SMALL_FONT);

        UIW_PROMPT *prompt2 = new UIW_PROMPT(2, 3, "System ");
        UIW_TEXT *text2 = new UIW_TEXT(12, 3, 30, 2, text, 100, WNF_NO_FLAGS);
        text2->Font(FNT_SYSTEM_FONT);

        UIW_PROMPT *prompt3 = new UIW_PROMPT(2, 5, "Dialog ");
        UIW_TEXT *text3 = new UIW_TEXT(12, 5, 30, 2, text, 100, WNF_NO_FLAGS);
        text3->Font(FNT_DIALOG_FONT);

        UIW_PROMPT *prompt4 = new UIW_PROMPT(2, 7, "New Font ");
        UIW_TEXT *text4 = new UIW_TEXT(12, 7, 30, 2, text, 100, WNF_NO_FLAGS);
        text4->Font(FNT_NEW_FONT);

        *fontWindow
                + prompt1
                + text1
                + prompt2
                + text2
                + prompt3
                + text3
                + prompt4
                + text4;

        windowManager->Center(fontWindow);
        *windowManager  + fontWindow;

        Control();

        return(0);
}

// Warning:  Font loading is very operating system dependant.

#if defined(ZIL_MSDOS)

#       if defined(DOS16PP) || defined(DOS32PP)
#       include <graphics.h>
        void LoadFont(UI_DISPLAY *)
        {
                UI_BGI_DISPLAY::fontTable[FNT_NEW_FONT].font = DEFAULT_FONT;
        }
#elif (__WATCOMC__ >= 1050)
        void LoadFont(UI_DISPLAY *)
        {
                UI_WCC_DISPLAY::fontTable[FNT_NEW_FONT] = 
                        UI_WCC_DISPLAY::fontTable[FNT_DIALOG_FONT];
        }
#       else
#       include <gfx.h>
        void LoadFont(UI_DISPLAY *)
        {
                UI_GRAPHICS_DISPLAY::fontTable[FNT_NEW_FONT].font = ROM_8x14;
        }
#       endif
#elif defined(ZIL_MSWINDOWS)

        void LoadFont(UI_DISPLAY *)
        {
                HFONT fixedFont = (HFONT)GetStockObject(ANSI_FIXED_FONT);
                UI_MSWINDOWS_DISPLAY::fontTable[FNT_NEW_FONT] = fixedFont;
        }

#elif defined(ZIL_OS2)

        void LoadFont(UI_DISPLAY *)
        {
                HPS desktopPS = WinGetPS(HWND_DESKTOP);
                LONG maxFonts = 0;
                maxFonts = GpiQueryFonts(desktopPS, QF_PUBLIC, (PSZ)"Courier", &maxFonts, sizeof(FONTMETRICS), ZIL_NULLP(FONTMETRICS));
                ZIL_ICHAR buf[30];

                FONTMETRICS *font = new FONTMETRICS[maxFonts];
                GpiQueryFonts(desktopPS, QF_PUBLIC, (PSZ)"Courier", &maxFonts, sizeof(FONTMETRICS), font);

                for (int i = 0; i < maxFonts; i++)
                {
                        if (font[i].sNominalPointSize <= 80 && !UI_OS2_DISPLAY::fontTable[FNT_NEW_FONT].lMatch)
                        {
                                UI_OS2_DISPLAY::fontTable[FNT_NEW_FONT] = font[i];
                                break;
                        }
                }

                delete font;
                WinReleasePS(desktopPS);
        }

#elif defined(ZIL_MOTIF)

        void LoadFont(UI_DISPLAY *_display)
        {
                UI_XT_DISPLAY *display = (UI_XT_DISPLAY *)_display;
                typedef struct
                {
                        char *italicFont;
                } AppData;

                #define XmNitalicFont   "italicFont"
                #define XmCItalicFont   "ItalicFont"

                static XtResource resources[] =
                {
                        XmNitalicFont,
                        XmCItalicFont,
                        XmRString,
                        sizeof(char *),
                        XtOffsetOf(AppData, italicFont),
                        XmRString,
                        // If font string is not found in X resource file then this font will be used.
                        (XtPointer)"-*-*-bold-o-*--14-*-iso8859-1"
                };

                AppData appData;
                XtGetApplicationResources(display->topShell, (XtPointer)&appData,
                        resources, XtNumber(resources), ZIL_NULLP(Arg), 0);

                display->fontTable[FNT_NEW_FONT].fontStruct
                        = XLoadQueryFont(display->xDisplay, appData.italicFont);

                display->fontTable[FNT_NEW_FONT].fontList =
                        XmFontListCreate(display->fontTable[FNT_NEW_FONT].fontStruct,
                                XmSTRING_DEFAULT_CHARSET);
        }

#elif defined(ZIL_MACINTOSH)

        void LoadFont(UI_DISPLAY *)
        {
                // Save the current port setup.
                short oldFace = qd.thePort->txFace;
                short oldFont = qd.thePort->txFont;
                short oldMode = qd.thePort->txMode;
                short oldSize = qd.thePort->txSize;

                // This is how to use TrueType fonts if available (rather than built-in bitmap fonts).
                // We do not do this, since we like the bitmap fonts that are built-into the system,
                // like systemFont and applFont. For example, the TrueType version of chicago is
                // different than the bitmap version. Menus and title bars would look non-standard.
                //long gestaltFeature = 0L;
                //if ((Gestalt(gestaltFontMgrAttr, &gestaltFeature) == noErr) && (gestaltFeature & 0xf))
                //      SetOutlinePreferred(true);

                // Initialize the new font structure and the current port setup.
                short fontID;
                GetFNum("\pCourier", &fontID);
                UI_MACINTOSH_DISPLAY::MACFONT initFont = { fontID, italic, srcOr, 12, { 0, 0, 0, 0 } };
                TextFace(initFont.face);
                TextFont(initFont.font);
                TextMode(initFont.mode);
                TextSize(initFont.size);

                // Load the FontInfo data structure with the current port setup.
                GetFontInfo(&initFont.fInfo);

                // Restore the current port setup.
                TextFace(oldFace);
                TextFont(oldFont);
                TextMode(oldMode);
                TextSize(oldSize);

                // Store the new font into the font table.
                UI_MACINTOSH_DISPLAY::fontTable[FNT_NEW_FONT] = initFont;
        }

#elif defined(ZIL_NEXTSTEP)

        extern "Objective-C"
        {
        #       include <appkit/Font.h>
        #       include <appkit/FontManager.h>
        }
        void LoadFont(UI_DISPLAY *)
        {
                id newFont = [Font newFont:"Times-Italic" size:18.0];
                UI_NEXTSTEP_DISPLAY::fontTable[FNT_NEW_FONT].font = newFont;
        }

#elif defined(ZIL_CURSES)
        void LoadFont(UI_DISPLAY *)
        {
        }
#endif
