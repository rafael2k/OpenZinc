/************************************/
/* Copyright (c) C Source, Inc 1991 */
/************************************/

#if !defined (__GFX_XLAT_)
#define __GFX_XLAT_
	
	/*  This header file is only used for compiling the demo programs
	 *  provided with each library. The demos use lower case function
	 *  names and this header files provide macros to redefine those
	 *  names to either upper case or the Pascal/Modula 2 convention,
	 *  depending on the interface that is specified at the top of
	 *  the GFX.H header file.
      *
      *  Although not intended for general use, you may find it useful if
	 *  you change from using lower case to Pascal/Modula 2 function type
	 *  calls. 
      */

               /*******************************************
                *      GFX GRAPHICS LIBRARY FUNCTIONS     *
                *******************************************/

#if defined(USE_PAS_M2) && defined(ORIG_LC)

	/* Setting the video 'playing field' */

#define color(a,b,c,d)		     	Color(a,b,c,d)
#define copy_video_pages(a,b)			CopyVideoPages(a,b)
#define init_gfx_struct(a)	     	InitGFXStruct(a)
#define init_GFX_struct(a)	     	InitGFXStruct(a)
#define screen(a)			     	Screen(a)
#define set_video_resolution(a,b)		SetVideoResolution(a,b)
#define set_extended_mode(a,b,c,d)		SetExtendedMode(a,b,c,d)
#define set_video_pages(a,b)			SetVideoPages(a,b)
#define get_card_monitor()			GetCardMonitor()
#define log_to_abs(a)				LogToAbs(a)
#define abs_to_log(a)				AbsToLog(a)
#define identify_SVGA()				IdentifySVGA()
#define get_SVGA_info(a,b)			GetSVGAInfo(a,b)
#define set_SVGA_mode(a)		     	SetSVGAMode(a)
#define get_GFX_error( )				GetGFXError( )
				 
	/* Functions getting various screen coordinates. */
	
#define convert_coor_pt(a,b)			ConvertCoorPt(a,b)			     			    			     
#define get_CAP(a)			     	GetCAP(a)
#define view_origin(a)			     ViewOrigin(a)
#define view_lr_corner(a)			ViewLrCorner(a)
#define view_ul_corner(a)			ViewUlCorner(a)

	/* Pattern setting functions */

#define set_line_pat(a)			     SetLinePat(a)
#define set_fill_pat(a,b,c)			SetFillPat(a,b,c)
#define set_fill_solid(a)			SetFillSolid(a)

	/* General purpose */

#define cls( )			     		Cls( )
#define move_to(a,b)			     MoveTo(a,b)
#define point(a,b,c)			     Point(a,b,c)
#define set_aspect(a,b)			     SetAspect(a,b)
#define alloc_GFX_workspace(a,b)		AllocGFXWorkspace(a,b)
#define free_GFX_workspace()			FreeGFXWorkspace()
#define alloc_GFX_disk_mem(a,b)		AllocGFXDiskMem(a,b)
#define set_dflt_menu_colors(a,b,c,d)   SetDfltMenuColors(a,b,c,d)
#define set_GFX_malloc_data(a,b)        SetGFXMallocData(a,b)

	/* Drawing functions */

#define box(a,b,c,d,e)			     Box(a,b,c,d,e)
#define circle(a,b,c,d)			     Circle(a,b,c,d)
#define circle_arc(a,b,c,d,e,f)		CircleArc(a,b,c,d,e,f)
#define draw			     		Draw
#define draw_line(a,b,c,d,e)			DrawLine(a,b,c,d,e)
#define oval(a,b,c,d,e)			     Oval(a,b,c,d,e)
#define oval_arc(a,b,c,d,e,f,g)		OvalArc(a,b,c,d,e,f,g)
#define pie_slice(a,b,c,d,e,f)		PieSlice(a,b,c,d,e,f)
#define poly_point(a,b,c,d,e)			PolyPoint(a,b,c,d,e)
#define poly_line(a,b,c,d,e)			PolyLine(a,b,c,d,e)
#define pset(a,b,c) 			     Pset(a,b,c) 

	/* Seed fill functions */

#define fastfill(a,b,c,d)			Fastfill(a,b,c,d)
#define paint(a,b,c,d)			     Paint(a,b,c,d)

	/* Pic & FPic functions */

#define close_fpic(a)			     CloseFpic(a)
#define compress_fpic_file(a,b)		CompressFpicFile(a,b)
#define create_fpic(a,b)			     CreateFpic(a,b)
#define delete_fpic(a,b)			     DeleteFpic(a,b)
#define get_fpic(a,b,c,d,e,f)			GetFpic(a,b,c,d,e,f)
#define free_pic(a)			     	FreePic(a)
#define get_pic(a,b,c,d)			     GetPic(a,b,c,d)
#define open_fpic(a,b)			     OpenFpic(a,b)
#define put_fpic(a,b,c,d,e)			PutFpic(a,b,c,d,e)
#define put_pic(a,b,c,d)			     PutPic(a,b,c,d)
#define read_fpic(a,b)			     ReadFpic(a,b)
#define write_fpic(a,b,c)			WriteFpic(a,b,c)

#define close_blob_file(a)              CloseBlobFile(a)
#define put_image(a,b,c,d)              PutImage(a,b,c,d)
#define init_pic_struct_for_blob        InitPicStructForBlob
#define write_image(a,b,c)              WriteImage(a,b,c)
#define set_default_pic_user_flags      SetDefaultPicUserFlags
#define create_blob_file(a,b,c)         CreateBlobFile(a,b,c)
#define open_blob_file(a,b)             OpenBlobFile(a,b)

				 
	/* Viewport control functions */

#define clear_view(a,b)			     ClearView(a,b)
#define close_view(a,b)			     CloseView(a,b)
#define close_view_file()			CloseViewFile()
#define create_view_file(a)			CreateViewFile(a)
#define logical_int_view(a,b,c,d)		LogicalIntView(a,b,c,d)
#define logical_float_view(a,b,c,d)	LogicalFloatView(a,b,c,d)
#define move_view(a,b)			     MoveView(a,b)
#define open_view(a,b,c,d,e,f)		OpenView(a,b,c,d,e,f)
#define switch_view(a,b)			     SwitchView(a,b)
#define delete_view_file()			DeleteViewFile()				 

	/* PCX Functions */

#define read_PCX_header(a,b)			ReadPCXHeader(a,b)
#define put_PCX_file(a,b,c,d)			PutPCXFile(a,b,c,d)
#define get_PCX_file(a,b,c,d,e,f)       GetPCXFile(a,b,c,d,e,f)



               /*******************************************
                *   GFX FONTS & MENUS LIBRARY FUNCTIONS   *
                *******************************************/

	/* font functions */

#define close_font(a)			     CloseFont(a)
#define curr_font(a)			     CurrFont(a)
#define font_align(a,b)			     FontAlign(a,b)
#define font_color(a,b,c)			FontColor(a,b,c)
#define font_magnify(a,b,c)			FontMagnify(a,b,c)
#define font_rotate(a,b)			     FontRotate(a,b)
#define font_spacing(a,b)			FontSpacing(a,b)
#define font_underline(a,b,c,d)		FontUnderline(a,b,c,d)
#define fprint_font			     	FprintFont
#define get_font_attr(a)			     GetFontAttr(a)
#define get_line_attr()			     GetLineAttr()
#define get_font_height(a)			GetFontHeight(a)
#define get_line_len(a,b,c)			GetLineLen(a,b,c)
#define line_direction(a)			LineDirection(a)
#define line_justify(a)			     LineJustify(a)
#define line_underline(a)			LineUnderline(a)
#define open_font(a)			     OpenFont(a)
#define open_mem_font(a)			     OpenMemFont(a)
#define print_font(a,b,c,d)			PrintFont(a,b,c,d)


	/* menu functions */

#define set_double_click(a)			SetDoubleClick(a)
#define set_mouse_event(a)			SetMouseEvent(a)
#define get_event(a)			     GetEvent(a)
#define position_root_menu(a)			PositionRootMenu(a)
#define set_root_menu(a)			     SetRootMenu(a)
#define clear_menus()			     ClearMenus()
#define set_box_wrt_center(a,b,c)		SetBoxWrtCenter(a,b,c)
#define set_box(a,b,c)			     SetBox(a,b,c)
#define init_gfx_menu(a,b,c,d)		InitGFXMenu(a,b,c,d)
#define init_GFX_menu(a,b,c,d)		InitGFXMenu(a,b,c,d)
#define init_mouse()			     InitMouse()
#define clear_box()			     	ClearBox()
#define revisit_box()			     RevisitBox()
#define set_DBOX_hook(a)                SetDBOXHook(a)
#define init_video_storage(a,b,c)	     InitVideoStorage(a,b,c)

#define peek_event()				PeekEvent()				 
#define push_event(a)			     PushEvent(a)
#define flush_event_q()			     FlushEventQ()
#define halt_q()			     	HaltQ()
#define set_cursor_regions(a,b)		SetCursorRegions(a,b)
#define push_hot_spot(a)			     PushHotSpot(a)
#define pop_hot_spots(a)			     PopHotSpots(a)
#define sleep_all_hot_spots()			SleepAllHotSpots()
#define wake_hot_spots()			     WakeHotSpots()
#define mod_hot_spots_status(a,b,c,d)	ModHotSpotsStatus(a,b,c,d)
#define qprint(a,b,c,d,e,f,g)			Qprint(a,b,c,d,e,f,g)
#define shade_box(a,b,c,d,e,f)		ShadeBox(a,b,c,d,e,f)
#define reset_layout(a,b)			ResetLayout(a,b)
#define scale_dim(a,b)			     ScaleDim(a,b)
#define reset_color_scheme(a,b,c,d)	ResetColorScheme(a,b,c,d)

#define init_auto_box(a,b)			InitAutoBox(a,b)
#define build_auto_box			     BuildAutoBox
#define set_box_wrt_menu(a,b,c,d)		SetBoxWrtMenu(a,b,c,d)
#define get_directory(a,b,c)			GetDirectory(a,b,c)
#define free_GFX_disk_mem()			FreeGFXDiskMem()

#define init_auto_gfx_menu(a,b,c,d,e,f)	InitAutoGFXMenu(a,b,c,d,e,f)
#define init_auto_GFX_menu(a,b,c,d,e,f)	InitAutoGFXMenu(a,b,c,d,e,f)
#define reset_auto_cs_layout(a)		ResetAutoCsLayout(a)



               /*******************************************
                *    GFX SCREEN DUMP LIBRARY FUNCTIONS    *
                *******************************************/

#define set_mem_printer_rec(a,b)			SetMemPrinterRec(a,b)
#define set_disk_printer_rec(a,b)			SetDiskPrinterRec(a,b)
#define set_prx_options(a,b,c,d,e)			SetPrxOptions(a,b,c,d,e)
#define set_prx_monitor_aspect(a,b)		SetPrxMonitorAspect(a,b)
#define get_printer_status(a)			     GetPrinterStatus(a)
#define set_prx_swath_hook(a)			     SetPrxSwathHook(a)
#define print_screen(a,b,c,d)			     PrintScreen(a,b,c,d)
#define print_area(a,b,c,d,e,f,g,h)		PrintArea(a,b,c,d,e,f,g,h)
#define set_prx_solid_output(a)			SetPrxSolidOutput(a)
#define set_prx_shading(a)			     SetPrxShading(a)
#define set_prx_color_table(a)			SetPrxColorTable(a)
#define set_prx_color_table(a)			SetPrxColorTable(a)
#define link_all_printer_types()			LinkAllPrinterTypes()
#define link_dot_matrix_printers()			LinkDotMatrixPrinters()
#define link_laser_printers()			     LinkLaserPrinters()

#endif


#if defined(USE_UPPER_C) && defined(ORIG_LC)

	/*  The definitions in the remaining portion of this file were
	 *  originally in the GFXG_LOW.H and GFXF_LOW.H header files.
	 */

	/* Graphics definitions */

#define screen		     		SCREEN
#define init_gfx_struct			INIT_GFX_STRUCT
#define init_GFX_struct			INIT_GFX_STRUCT
#define set_extended_ega_mode		SET_EXTENDED_EGA_MODE
#define set_extended_mode		SET_EXTENDED_MODE
#define set_video_pages			SET_VIDEO_PAGES
#define copy_video_pages			COPY_VIDEO_PAGES
#define color(a,b,c)	     	COLOR(a,b,c)
#define get_curr_pt		     	GET_CURR_PT
#define convert_coor_pt			CONVERT_COOR_PT
#define abs_to_log			     ABS_TO_LOG
#define log_to_abs			     LOG_TO_ABS
#define view_ul_corner	  		VIEW_UL_CORNER
#define view_lr_corner			VIEW_LR_CORNER
#define view_origin		     	VIEW_ORIGIN
#define set_line_pat			SET_LINE_PAT
#define set_fill_pat			SET_FILL_PAT
#define move_to    		     	MOVE_TO
#define cls   		     		CLS
#define point 		     		POINT
#define pset  		     		PSET
#define poly_dot   				POLY_DOT
#define draw_line  				DRAW_LINE
#define draw  		     		DRAW
#define box   		     		BOX
#define poly_line  				POLY_LINE
#define circle		     		CIRCLE
#define circle_arc 				CIRCLE_ARC
#define oval  		     		OVAL
#define oval_arc   		 		OVAL_ARC
#define pie_slice  		 		PIE_SLICE
#define paint 		     		PAINT
#define fastfill   		 		FASTFILL
#define free_pic    		 	FREE_PIC
#define get_pic    		 		GET_PIC
#define put_pic    		 		PUT_PIC
#define get_fpic   		 		GET_FPIC
#define put_fpic				PUT_FPIC
#define create_fpic		     	CREATE_FPIC
#define open_fpic	  			OPEN_FPIC
#define close_fpic				CLOSE_FPIC
#define read_fpic	  			READ_FPIC
#define write_fpic	 			WRITE_FPIC
#define compress_fpic_file		COMPRESS_FPIC_FILE
#define delete_fpic		     	DELETE_FPIC
#define open_view	  			OPEN_VIEW
#define clear_view	 			CLEAR_VIEW
#define close_view				CLOSE_VIEW
#define switch_view		     	SWITCH_VIEW
#define move_view	  			MOVE_VIEW
#define create_view_file			CREATE_VIEW_FILE
#define close_view_file	 		CLOSE_VIEW_FILE
#define logical_int_view			LOGICAL_INT_VIEW
#define logical_float_view		LOGICAL_FLOAT_VIEW
#define locate		     		LOCATE
#define line	  		     	LINE
#define scale_int_view			SCALE_INT_VIEW
#define scale_float_view			SCALE_FLOAT_VIEW

  /* Font definitions */
  
#define close_font	     	CLOSE_FONT
#define font_align	     	FONT_ALIGN
#define font_color	     	FONT_COLOR
#define font_magnify	     FONT_MAGNIFY
#define font_rotate	     	FONT_ROTATE
#define font_spacing	     FONT_SPACING
#define font_underline	     FONT_UNDERLINE
#define fprint_font	     	FPRINT_FONT
#define get_font_attr	     GET_FONT_ATTR
#define get_line_attr	     GET_LINE_ATTR
#define get_font_height	     GET_FONT_HEIGHT
#define get_line_len	     GET_LINE_LEN
#define line_direction	     LINE_DIRECTION
#define line_justify	     LINE_JUSTIFY
#define line_underline	     LINE_UNDERLINE
#define open_font	     	OPEN_FONT
#define print_font	     	PRINT_FONT
#define curr_font	       	CURR_FONT

#endif

#endif
