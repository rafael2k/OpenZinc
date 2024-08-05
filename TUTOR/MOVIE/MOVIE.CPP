// Include the appropriate directives.
#include <ui_win.hpp>
#include "movie.hpp"
#define USE_MOVIE_CONTROL
#define USE_MOVIE_SELECTION
#define USE_MOVIE_INFORMATION
#define USE_MSG_TABLE
#include "p_movie.hpp"

static ZIL_ICHAR _msgTableName[] = { 'M','S','G','_','T','A','B','L','E',0 };
static ZIL_LANGUAGE *_nameMsgTable;

ZIL_STORAGE_READ_ONLY *MOVIE_CONTROL::_intlStorage = ZIL_NULLP(ZIL_STORAGE_READ_ONLY);
ZIL_ICHAR *MOVIE_CONTROL::_pathName = ZIL_NULLP(ZIL_ICHAR);
ZIL_ICHAR *MOVIE_CONTROL::_exitName = ZIL_NULLP(ZIL_ICHAR);
ZIL_ICHAR *MOVIE_SELECTION::_pathName = ZIL_NULLP(ZIL_ICHAR);
ZIL_ICHAR *MOVIE_SELECTION::_allObjects = ZIL_NULLP(ZIL_ICHAR);
ZIL_ICHAR *MOVIE_INFORMATION::_pathName = ZIL_NULLP(ZIL_ICHAR);

int UI_APPLICATION::Main(void)
{
	// Fix linkers that don't look for main in the .LIBs.
	UI_APPLICATION::LinkMain();

	// Set up strings used to open general and delta storage files.
	static ZIL_ICHAR _fileName[] = { 'p','_','m','o','v','i','e','.',0 };
	static ZIL_ICHAR _extension[] = { 'd','a','t', 0};
	ZIL_ICHAR _intlFileName[32], _baseFileName[32];
	strcpy(_intlFileName, _fileName);
	strcat(_intlFileName, languageManager.defaultName);
	strcpy(_baseFileName, _fileName);
	strcat(_baseFileName, _extension);

	// Create error and help systems.
	UI_WINDOW_OBJECT::errorSystem = new UI_ERROR_SYSTEM;
	UI_WINDOW_OBJECT::helpSystem = new UI_HELP_SYSTEM(_baseFileName);

	// Open general storage file which contains original windows.
	UI_WINDOW_OBJECT::defaultStorage = new ZIL_STORAGE_READ_ONLY(_baseFileName);

	// Check to see if the default storage was allocated.
	if (UI_WINDOW_OBJECT::defaultStorage->storageError)
	{
		delete UI_WINDOW_OBJECT::defaultStorage;
		return(-1);
	}

	// Open delta storage file.
	MOVIE_CONTROL::_intlStorage = new ZIL_STORAGE_READ_ONLY(_intlFileName);

	// If the delta storage file cannot be opened, resort to base storage.
	if (MOVIE_CONTROL::_intlStorage->storageError)
	{
		delete MOVIE_CONTROL::_intlStorage;
		MOVIE_CONTROL::_intlStorage = new ZIL_STORAGE_READ_ONLY(_baseFileName);
	}

	// Open name message table.  The name message table contains names of
	// windows and other required strings.
	_nameMsgTable = new ZIL_LANGUAGE(_msgTableName, UI_WINDOW_OBJECT::defaultStorage);

	// Initialize static name strings.
	MOVIE_CONTROL::_pathName = _nameMsgTable->GetMessage(ZMSG_CTRL_PATH_NAME);
	MOVIE_CONTROL::_exitName = _nameMsgTable->GetMessage(ZMSG_CTRL_EXIT_NAME);
	MOVIE_SELECTION::_pathName = display->isText ? _nameMsgTable->GetMessage(ZMSG_SEL_PATH_TEXT) :
		_nameMsgTable->GetMessage(ZMSG_SEL_PATH_NAME);
	MOVIE_SELECTION::_allObjects = _nameMsgTable->GetMessage(ZMSG_SEL_ALL_NAME);
	MOVIE_INFORMATION::_pathName = _nameMsgTable->GetMessage(ZMSG_INFO_PATH_NAME);

	// Add the control window.
	*windowManager + new MOVIE_CONTROL;
	windowManager->screenID = windowManager->First()->screenID;

	// Process user responses.
	UI_APPLICATION::Control();

	// Clean up and return success.
	delete UI_WINDOW_OBJECT::errorSystem;
	delete UI_WINDOW_OBJECT::helpSystem;
	delete MOVIE_CONTROL::_intlStorage;
	delete UI_WINDOW_OBJECT::defaultStorage;
	delete _nameMsgTable;
	return (0);
}

// ----- MOVIE_CONTROL -----------------------------------------------------

ZIL_STORAGE *MOVIE_CONTROL::_dataFile = ZIL_NULLP(ZIL_STORAGE);
ZIL_LANGUAGE *MOVIE_CONTROL::_errorMsgTable = ZIL_NULLP(ZIL_LANGUAGE);
ZIL_ICHAR MOVIE_CONTROL::_movieName[64] = { 0 };

MOVIE_CONTROL::MOVIE_CONTROL(void) :
	UIW_WINDOW(_pathName, _pathName, ZIL_NULLP(ZIL_ICHAR), defaultStorage, _intlStorage)
{
	// Give the window a unique searchID.
	searchID = ID_MOVIE_CONTROL;
	_errorMsgTable = new ZIL_LANGUAGE(_msgTableName, _intlStorage);

	// Center the window at the top of the screen.
	windowManager->Center(this);
	relative.bottom = relative.Height() - 1;
	relative.top = 0;

	// Set the exit function.
	windowManager->exitFunction = Exit;

	// Initialize the data file.
	_dataFile = new ZIL_STORAGE(_nameMsgTable->GetMessage(ZMSG_DATA_FILE), UIS_OPENCREATE | UIS_READWRITE);
}

MOVIE_CONTROL::~MOVIE_CONTROL(void)
{
	// Save the data file.
	_dataFile->Save();
	delete _dataFile;

	// Delete the message table.
	delete _errorMsgTable;
}

EVENT_TYPE MOVIE_CONTROL::Event(const UI_EVENT &event)
{
	// Check for special requests.
	EVENT_TYPE ccode = event.type;
	if (event.type == OPT_HELP)
		helpSystem->DisplayHelp(windowManager, event.windowObject->helpContext);
	else if (ccode == OPT_MOVIE_CREATE)
		ccode = MovieCreate(event);
	else if (ccode == OPT_MOVIE_DELETE)
		ccode = MovieDelete(event);
	else if (ccode == OPT_MOVIE_LOAD)
		ccode = MovieLoad(event);
	else if (ccode == OPT_MOVIE_STORE)
		ccode = MovieStore(event);
	else
		ccode = UIW_WINDOW::Event(event);
	return (ccode);
}

EVENT_TYPE MOVIE_CONTROL::Exit(UI_DISPLAY *, UI_EVENT_MANAGER *, UI_WINDOW_MANAGER *windowManager)
{
	// Read the exit window.
	UI_ERROR_STUB::Beep();
	UIW_WINDOW *window = new UIW_WINDOW(_exitName, _exitName, ZIL_NULLP(ZIL_ICHAR), MOVIE_CONTROL::defaultStorage, _intlStorage);
	windowManager->Center(window);
	*windowManager + window;
	return (S_CONTINUE);
}

void *MOVIE_CONTROL::Information(ZIL_INFO_REQUEST request, void *data, ZIL_OBJECTID objectID)
{
	if (request == I_UPDATE_STATUS)
	{
		Get(STATUS_MOVIE_TITLE)->Information(I_SET_TEXT, _movieName);
		_movieName[0] = '\0';
	}
	else
		data = UIW_WINDOW::Information(request, data, objectID);
	return (data);
}

EVENT_TYPE MOVIE_CONTROL::MovieCreate(const UI_EVENT &event)
{
	*windowManager + new MOVIE_INFORMATION;
	return (event.type);
}

EVENT_TYPE MOVIE_CONTROL::MovieDelete(const UI_EVENT &event)
{
	if (_movieName[0])
	{
		if (!_dataFile->FindFirstObject(_movieName))
		{
			ZIL_ICHAR *message = MOVIE_CONTROL::_errorMsgTable->GetMessage(ZMSG_DELETE_ERROR);
			errorSystem->ReportError(windowManager, WOS_NO_STATUS, message, _movieName);
		}
		else
			_dataFile->DestroyObject(_movieName);
		_movieName[0] = '\0';
	}
	else
		*windowManager + new MOVIE_SELECTION(_dataFile, event.type);
	return (event.type);
}

EVENT_TYPE MOVIE_CONTROL::MovieLoad(const UI_EVENT &event)
{
	if (_movieName[0])
	{
		if (!_dataFile->FindFirstObject(_movieName))
		{
			ZIL_ICHAR *message = MOVIE_CONTROL::_errorMsgTable->GetMessage(ZMSG_LOAD_ERROR);
			errorSystem->ReportError(windowManager, WOS_NO_STATUS, message, _movieName);
		}
		else
			*windowManager + new MOVIE_INFORMATION(_movieName);
		_movieName[0] = '\0';
	}
	else
		*windowManager + new MOVIE_SELECTION(_dataFile, event.type);
	return (event.type);
}

EVENT_TYPE MOVIE_CONTROL::MovieStore(const UI_EVENT &event)
{
	UI_WINDOW_OBJECT *window = windowManager->Get(_nameMsgTable->GetMessage(ZMSG_INFO_PATH_NAME));
	if (window)
		window->Store(ZIL_NULLP(ZIL_ICHAR), _dataFile);
	return (event.type);
}

// ----- MOVIE_SELECTION -------------------------------------------------------

MOVIE_SELECTION::MOVIE_SELECTION(ZIL_STORAGE_READ_ONLY *dataFile, ZIL_USER_EVENT _request) :
	UIW_WINDOW(_pathName, _pathName, ZIL_NULLP(ZIL_ICHAR), defaultStorage, MOVIE_CONTROL::_intlStorage),
	request(_request)
{
	// Give the window a unique searchID.
	searchID = ID_MOVIE_SELECTION;

	// Center the window on the screen.
	windowManager->Center(this);

	// Load the current movie information.
	extern ZIL_ICHAR *_currentDirectory;
	extern ZIL_ICHAR *_parentDirectory;

	UI_EVENT addEvent(S_ADD_OBJECT);
	UI_WINDOW_OBJECT *list = Get(FLD_SELECT_SELECTION);
	ZIL_ICHAR *entry = dataFile->FindFirstObject(_allObjects);
	for (; entry; entry = dataFile->FindNextObject())
		if (strcmp(entry, _currentDirectory) &&
			strcmp(entry, _parentDirectory))
		{
			addEvent.windowObject = new UIW_BUTTON(0, 0, 30, entry,
				BTF_NO_TOGGLE | BTF_NO_3D | BTF_SEND_MESSAGE,
				WOF_NO_FLAGS, ZIL_NULLF(ZIL_USER_FUNCTION),
				OPT_RESET_SELECTION);
			list->Event(addEvent);
		}
}

EVENT_TYPE MOVIE_SELECTION::Event(const UI_EVENT &event)
{
	// Check for special requests.
	EVENT_TYPE ccode = event.type;
	if (ccode == OPT_HELP)
		helpSystem->DisplayHelp(windowManager, helpContext);
	else if (ccode == OPT_MOVIE_OK)
	{
		Get(FLD_SELECT_TITLE)->Information(I_COPY_TEXT, MOVIE_CONTROL::_movieName);
		if (!MOVIE_CONTROL::_movieName[0])
		{
			ZIL_ICHAR *message = MOVIE_CONTROL::_errorMsgTable->GetMessage(ZMSG_NAME_ERROR);
			errorSystem->ReportError(windowManager, WOS_NO_STATUS, message);
		}
		else
		{
			eventManager->Put(S_CLOSE); // Close the window.
			eventManager->Put(request); // Send response to the main control.
		}
	}
	else if (ccode == OPT_RESET_SELECTION)
	{
		ZIL_ICHAR *title;
		event.windowObject->Information(I_GET_TEXT, &title);
		Get(FLD_SELECT_TITLE)->Information(I_SET_TEXT, title);
	}
	else
		ccode = UIW_WINDOW::Event(event);
	return (ccode);
}

// ----- MOVIE_INFORMATION --------------------------------------------------

MOVIE_INFORMATION::MOVIE_INFORMATION(ZIL_ICHAR *name) :
	UIW_WINDOW(_pathName, _pathName, ZIL_NULLP(ZIL_ICHAR), defaultStorage, MOVIE_CONTROL::_intlStorage)
{
	// Give the window a unique searchID.
	searchID = ID_MOVIE_INFORMATION;

	// Center the window on the screen.
	windowManager->Center(this);

	// Load the record information.
	if (name)
		Load(name, MOVIE_CONTROL::_dataFile);
}

EVENT_TYPE MOVIE_INFORMATION::Event(const UI_EVENT &event)
{
	// Check for special requests.
	EVENT_TYPE ccode = event.type;
	if (ccode == OPT_HELP)
		helpSystem->DisplayHelp(windowManager, helpContext);
	else if (ccode == S_CURRENT || ccode == S_NON_CURRENT)
	{
		ccode = UIW_WINDOW::Event(event);
		UI_WINDOW_OBJECT *window = windowManager->Get(_nameMsgTable->GetMessage(ZMSG_CTRL_PATH_NAME));
		if (window && ccode == S_CURRENT)
		{
			Get(FLD_INFO_TITLE)->Information(I_COPY_TEXT, MOVIE_CONTROL::_movieName);
			window->Information(I_UPDATE_STATUS, ZIL_NULLP(void));
		}
	}
	else if (ccode == OPT_MOVIE_STORE)
		Store(ZIL_NULLP(ZIL_ICHAR), MOVIE_CONTROL::_dataFile);
	else
		ccode = UIW_WINDOW::Event(event);
	return (ccode);
}

void MOVIE_INFORMATION::Load(const ZIL_ICHAR *name,
	ZIL_STORAGE_READ_ONLY *file, ZIL_STORAGE_OBJECT_READ_ONLY *,
	UI_ITEM *, UI_ITEM *)
{
	// Load the information from the movie directory.
	if (name && name[0])
	{
		ZIL_INT16 iData;
		ZIL_ICHAR *sData;
		ZIL_STORAGE_OBJECT_READ_ONLY lObject(*file, name, 0);

		lObject.Load(&sData);
		Get(FLD_INFO_TITLE)->Information(I_SET_TEXT, sData); // title.
		delete sData;
		lObject.Load(&iData);
		int copyright = iData;
		Get(FLD_INFO_COPYRIGHT)->Information(I_SET_VALUE, &copyright); // copyright.
		lObject.Load(&iData);
		int length = iData;
		Get(FLD_INFO_LENGTH)->Information(I_SET_VALUE, &length); // length.
		lObject.Load(&sData);
		Get(FLD_INFO_DIRECTOR)->Information(I_SET_TEXT, sData); // director.
		delete sData;
		lObject.Load(&sData);
		Get(FLD_INFO_LEADS)->Information(I_SET_TEXT, sData); // leads.
		delete sData;
		lObject.Load(&sData);
		Get(FLD_INFO_DESCRIPTION)->Information(I_SET_TEXT, sData); // description.
		delete sData;
	}
}

void MOVIE_INFORMATION::Store(const ZIL_ICHAR *name,
	ZIL_STORAGE *file, ZIL_STORAGE_OBJECT *, UI_ITEM *, UI_ITEM *)
{
	// Store the movie information.
	if (!name || !name[0])
		Get(FLD_INFO_TITLE)->Information(I_GET_TEXT, (void *)&name); // title.
	if (!name || !name[0])
	{
		ZIL_ICHAR *message = MOVIE_CONTROL::_errorMsgTable->GetMessage(ZMSG_NAME_ERROR);
		errorSystem->ReportError(windowManager, WOS_NO_STATUS, message);
	}
	if (name && name[0])
	{
		ZIL_INT16 iData;
		ZIL_ICHAR *sData;
		ZIL_STORAGE_OBJECT sObject(*file, name, 0, UIS_CREATE | UIS_READWRITE);

		Get(FLD_INFO_TITLE)->Information(I_GET_TEXT, &sData); // title.
		sObject.Store(sData);
		int copyright;
		Get(FLD_INFO_COPYRIGHT)->Information(I_GET_VALUE, &copyright); // copyright.
		iData = (ZIL_INT16)copyright;
		sObject.Store(iData);
		int length;
		Get(FLD_INFO_LENGTH)->Information(I_GET_VALUE, &length); // length.
		iData = (ZIL_INT16)length;
		sObject.Store(iData);
		Get(FLD_INFO_DIRECTOR)->Information(I_GET_TEXT, &sData); // director.
		sObject.Store(sData);
		Get(FLD_INFO_LEADS)->Information(I_GET_TEXT, &sData); // leads.
		sObject.Store(sData);
		Get(FLD_INFO_DESCRIPTION)->Information(I_GET_TEXT, &sData); // description.
		sObject.Store(sData);
	}
}

