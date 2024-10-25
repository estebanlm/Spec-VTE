Class {
	#name : 'VteTerminal',
	#superclass : 'GtkWidget',
	#traits : 'GtkTScrollable',
	#classTraits : 'GtkTScrollable classTrait',
	#pools : [
		'GSpawnFlags',
		'VteCursorShape',
		'VtePtyFlags'
	],
	#category : 'Vte',
	#package : 'Vte'
}

{ #category : 'example' }
VteTerminal class >> example [ 
	| vte scrollbar box |

	GtkEngine ensureRunning.

	GRunLoop defer: [ 
		vte := self new
			beCursorShapeIBeam;
			allowHyperlink: true;
			scrollOnOutput: true;
			mouseAutohide: true;
			yourself.

		scrollbar := GtkScrollbar newVerticalAdjustment: vte vAdjustment.
		scrollbar hExpand: false.

		box := GtkBox newHorizontal
			append: vte;
			append: scrollbar;
			yourself.

		GtkWindow new 
			title: 'Vte';
			child: box;
			present.

		vte feed: ((String loremIpsum withNoLineLongerThan: 80) withLineEndings: String crlf) 
	]
]

{ #category : 'example' }
VteTerminal class >> example2 [
	| vte scrollbar box |

	GEngine ensureRunning.

	GRunLoop defer: [ 
		vte := self new
			beCursorShapeIBeam;
			allowHyperlink: true;
			scrollOnOutput: true;
			mouseAutohide: true;
			yourself.

		scrollbar := GtkScrollbar newVerticalAdjustment: vte vAdjustment.
		scrollbar hExpand: false.

		box := GtkBox newHorizontal
			append: vte;
			append: scrollbar;
			yourself.

		GtkWindow new 
			title: 'Vte';
			child: box;
			present.

		vte feed: ((FileLocator imageDirectory / 'log' / 'LOTJ' / 'log-2021-9-6.txt') 
			readStreamDo: [ :stream | stream contents  ]) ]
]

{ #category : 'accessing' }
VteTerminal class >> features [

	^ self 
		ffiCall: #(char *vte_get_features (void))
		module: VteLibrary
]

{ #category : 'library path' }
VteTerminal class >> ffiLibraryName [

	^ VteLibrary
]

{ #category : 'instance creation' }
VteTerminal class >> new [

	^ self vteTerminalNew initialize
]

{ #category : 'private' }
VteTerminal class >> vteTerminalNew [

	^ self ffiCall: #(VteTerminal *vte_terminal_new()) module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> allowBold: allow_bold [

	self 
		ffiCall: #(void vte_terminal_set_allow_bold (self, gboolean allow_bold))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> allowHyperlink: allow_hyperlink [

	self 
		ffiCall: #(void vte_terminal_set_allow_hyperlink (self, gboolean allow_hyperlink))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> beCursorShapeBlock [

	self cursorShape: VTE_CURSOR_SHAPE_BLOCK
]

{ #category : 'accessing' }
VteTerminal >> beCursorShapeIBeam [

	self cursorShape: VTE_CURSOR_SHAPE_IBEAM
]

{ #category : 'accessing' }
VteTerminal >> beCursorShapeUnderline [

	self cursorShape: VTE_CURSOR_SHAPE_UNDERLINE
]

{ #category : 'accessing' }
VteTerminal >> charHeight [

	^ self 
		ffiCall: #(glong vte_terminal_get_char_height (self))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> charWidth [

	^ self 
		ffiCall: #(glong vte_terminal_get_char_width (self))
		module: VteLibrary
]

{ #category : 'accessing - colors' }
VteTerminal >> colorForeground: foreground [

	^ self 
		ffiCall: #(void vte_terminal_set_color_foreground (self, const GdkRGBA *foreground)) 
		module: VteLibrary
]

{ #category : 'accessing - colors' }
VteTerminal >> colorForeground: foreground background: background palette: paletteArray [
	"Taken from VteTerminal comment, see 
		https://developer.gnome.org/vte/0.48/VteTerminal.html#vte-terminal-set-colors

	palette specifies the new values for the 256 palette colors: 8 standard colors, 
	their 8 bright counterparts, 6x6x6 color cube, and 24 grayscale colors. Omitted 
	entries will default to a hardcoded value. 
	Palette size must be 0, 8, 16, 232 or 256.
	If foreground is NULL and palette size is greater than 0, the new foreground color 
	is taken from palette [7]. If background is NULL and palette_size is greater 
	than 0, the new background color is taken from palette [0]."

	| gtkPalette |

	gtkPalette := paletteArray
		ifNotEmpty: [   
			ByteArray 
				new: (GdkRGBA structureSize * paletteArray size)
				streamContents: [ :stream | 
					paletteArray do: [ :each | stream << each asGdkRGBA getHandle ] ] ]
		ifEmpty: [ 
			ExternalAddress null ].

	self 
		setColorsForeground: (foreground ifNotNil: [ :c | c asGdkRGBA ])
		background: (background ifNotNil: [ :c | c asGdkRGBA ])
		palette: gtkPalette
		paletteSize: paletteArray size
]

{ #category : 'accessing - colors' }
VteTerminal >> colorHighlight: foreground [

	^ self 
		ffiCall: #(void vte_terminal_set_color_highlight (self, const GdkRGBA *foreground)) 
		module: VteLibrary
]

{ #category : 'accessing - colors' }
VteTerminal >> colorHighlightForeground: foreground [

	^ self 
		ffiCall: #(void vte_terminal_set_color_highlight_foreground (self, const GdkRGBA *foreground)) 
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> columnCount [

	^ self ffiCall: #(glong vte_terminal_get_column_count (self))
]

{ #category : 'accessing - copy&paste' }
VteTerminal >> copyClipboardHTML [

	^ self 
		ffiCall: #(void vte_terminal_copy_clipboard_format (self, gint 2))
		module: VteLibrary
]

{ #category : 'accessing - copy&paste' }
VteTerminal >> copyClipboardText [

	^ self 
		ffiCall: #(void vte_terminal_copy_clipboard_format (self, gint 1))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> cursorShape [

	^ self 
		ffiCall: #(VteCursorShape vte_terminal_get_cursor_shape (self))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> cursorShape: shape [

	^ self 
		ffiCall: #(void vte_terminal_set_cursor_shape (self, VteCursorShape shape))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> feed: aString [
	
	self feed: aString length: -1
]

{ #category : 'accessing' }
VteTerminal >> feed: string length: length [

	self 
		ffiCall: #(void vte_terminal_feed (self, const char *string, long length))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> feedBytes: aByteArray [
	
	self feedBytes: aByteArray length: -1
]

{ #category : 'accessing' }
VteTerminal >> feedBytes: aByteArray length: length [

	self 
		ffiCall: #(void vte_terminal_feed (self, ByteArray aByteArray, gssize length))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> feedChild: aString [

	self feedChild: aString length: -1
]

{ #category : 'accessing' }
VteTerminal >> feedChild: text length: length [

	self 
		ffiCall: #(void vte_terminal_feed_child (self, const char *text, gssize length))
		module: VteLibrary
]

{ #category : 'library path' }
VteTerminal >> ffiLibraryName [

	^ VteLibrary
]

{ #category : 'accessing - fonts' }
VteTerminal >> font [

	^ self 
		ffiCall: #(PangoFontDescription *vte_terminal_get_font (self))
		module: VteLibrary
]

{ #category : 'accessing - fonts' }
VteTerminal >> font: font_desc [

	^ self 
		ffiCall: #(void vte_terminal_set_font (self, PangoFontDescription *font_desc))
		module: VteLibrary
]

{ #category : 'accessing - fonts' }
VteTerminal >> fontNamed: aString [

	self font: (PangoFontDescription newFromString: aString) autoRelease
]

{ #category : 'accessing - fonts' }
VteTerminal >> fontScale [

	self 
		ffiCall: #(gdouble vte_terminal_get_font_scale (self))
		module: VteLibrary
]

{ #category : 'accessing - fonts' }
VteTerminal >> fontScale: scale [

	self 
		ffiCall: #(void vte_terminal_set_font_scale (self, gdouble scale))
		module: VteLibrary
]

{ #category : 'private' }
VteTerminal >> getText [

	^ self 
		ffiCall: #(char *vte_terminal_get_text (self,
                       NULL,
                       NULL,
                       NULL))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> hyperlinkCheckAt: aPoint [ 
	| result |
	
	result := self vteHyperlinkCheckAtX: aPoint x y: aPoint y.
	result isNull ifTrue: [ ^ nil ].

	^ [ result utf8StringFromCString ]
	ensure: [ result free ]	

]

{ #category : 'testing' }
VteTerminal >> isAllowBold [

	self 
		ffiCall: #(gboolean vte_terminal_get_allow_bold (self))
		module: VteLibrary
]

{ #category : 'testing' }
VteTerminal >> isAllowHyperlink [

	self 
		ffiCall: #(gboolean vte_terminal_get_allow_hyperlink (self))
		module: VteLibrary
]

{ #category : 'testing' }
VteTerminal >> isMouseAutohide [

	self 
		ffiCall: #(gboolean vte_terminal_get_mouse_autohide (self))
		module: VteLibrary
]

{ #category : 'testing' }
VteTerminal >> isRewrapOnResize [

	^ self 
		ffiCall: #(gboolean vte_terminal_get_rewrap_on_resize (self))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> mouseAutohide: setting [

	self 
		ffiCall: #(void vte_terminal_set_mouse_autohide (self, gboolean setting))
		module: VteLibrary
]

{ #category : 'accessing - copy&paste' }
VteTerminal >> pasteClipboard [

	^ self 
		ffiCall: #(void vte_terminal_paste_clipboard (self))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> rowCount [

	^ self ffiCall: #(glong vte_terminal_get_row_count (self))
]

{ #category : 'accessing' }
VteTerminal >> scrollOnOutput: scroll [

	self 
		ffiCall: #(void vte_terminal_set_scroll_on_output (self, gboolean scroll))
		module: VteLibrary
]

{ #category : 'accessing' }
VteTerminal >> selectAll [

	^ self 
		ffiCall: #(void vte_terminal_select_all (self))
		module: VteLibrary
]

{ #category : 'private' }
VteTerminal >> setColorsForeground: foreground background: background palette: palette paletteSize: palette_size [
		
	self 
		ffiCall: #(void vte_terminal_set_colors (
			self,
			const GdkRGBA *foreground,
			const GdkRGBA *background,
			"const GdkRGBA *"void *palette,
			gsize palette_size))
		module: VteLibrary
]

{ #category : 'accessing - colors' }
VteTerminal >> setDefaultColors [

	self 
		ffiCall: #(void vte_terminal_set_default_colors (self))
		module: VteLibrary
]

{ #category : 'accessing - colors' }
VteTerminal >> setOther [
	| palette |

	palette := #( 
		"Light"
		"0"'111111'
		"1"'d36265'
		"2"'aece91'
		"3"'e7e18c'
		"4"'5297cf'
		"5"'963c59'
		"6"'5E7175'
		"7"'bebebe'
		"Dark"
		"0"'666666'
		"1"'ef8171'
		"2"'cfefb3'
		"3"'fff796'
		"4"'74b8ef'
		"5"'b85e7b'
		"6"'A3BABF'
		"7"'ffffff'
	) 
	collect: [ :each | GdkRGBA fromHexString: each ].
	
	self 
		colorForeground: nil
		background: Color black
		palette: palette
	
	
]

{ #category : 'accessing - colors' }
VteTerminal >> setSolarized [
	| palette |

	palette := #( 
		"Light"
		"0"'eee8d5'
		"1"'dc322f'
		"2"'859900'
		"3"'b58900'
		"4"'268bd2'
		"5"'d33682'
		"6"'2aa198'
		"7"'eee8d5'
		"Dark"
		"0"'cb4b16'
		"1"'fdf6e3'
		"2"'586e75'
		"3"'839496'
		"4"'657b83'
		"5"'6c71c4'
		"6"'586e75'
		"7"'002b36'
	) 
	collect: [ :each | GdkRGBA fromHexString: each ].
	
	self 
		colorForeground: nil
		background: Color black
		palette: palette
	
	
]

{ #category : 'accessing' }
VteTerminal >> size: aPoint [

	self sizeColumns: aPoint x rows: aPoint y
]

{ #category : 'accessing' }
VteTerminal >> sizeColumns: columns rows: rows [

	self 
		ffiCall: #(void vte_terminal_set_size (self, glong columns, glong rows))
		module: VteLibrary
]

{ #category : 'accessing - spawn' }
VteTerminal >> spawnAsync: pty_flags workingDirectory: working_directory argv: argv envv: envv spawnFlags: spawn_flags childSetup: child_setup childSetupData:  child_setup_data childDestroyNotify: child_setup_data_destroy timeout: timeout cancellable: cancellable callback: callback data: user_data [
	"
	GSpawnChildSetupFunc: void (*GSpawnChildSetupFunc) (gpointer user_data)
	GDestroyNotify: void (*GDestroyNotify) (gpointer data)
	VteTerminalSpawnAsyncCallback void (*VteTerminalSpawnAsyncCallback) (VteTerminal *terminal,
                                  GPid pid,
                                  GError *error,
                                  gpointer user_data)
	"

	self ffiCall: #(void vte_terminal_spawn_async (
		self,
		VtePtyFlags pty_flags,
		const char *working_directory,
		"char **"void *argv,
		"char **"void *envv,
		GSpawnFlags spawn_flags,
		"GSpawnChildSetupFunc"void *child_setup,
		gpointer child_setup_data,
		"GDestroyNotify"void *child_setup_data_destroy,
		int timeout,
		"GCancellable *"GObject *cancellable,
		"VteTerminalSpawnAsyncCallback"void *callback,
		gpointer user_data))
]

{ #category : 'accessing - spawn' }
VteTerminal >> spawnAsyncDefaultWorkingDirectory: working_directory argv: argv envv: envv spawnFlags: spaen_flags childSetup: child_setup childSetupData:  child_setup_data childDestroyNotify: child_setup_data_destroy timeout: timeout cancellable: cancellable callback: callback data: user_data [

	self 
		spawnAsync: VTE_PTY_DEFAULT 
		workingDirectory: working_directory
		argv: argv 
		envv: envv 
		spawnFlags: spaen_flags 
		childSetup: child_setup 
		childSetupData:  child_setup_data 
		childDestroyNotify: child_setup_data_destroy 
		timeout: timeout 
		cancellable: cancellable 
		callback: callback
		data: user_data
]

{ #category : 'accessing - spawn' }
VteTerminal >> spawnAsyncDefaultWorkingDirectory: working_directory command: command spawnFlags: spaen_flags childSetup: child_setup childSetupData:  child_setup_data childDestroyNotify: child_setup_data_destroy timeout: timeout cancellable: cancellable callback: callback data: user_data [
	| argv commandArg |
	
	commandArg := ExternalAddress fromString: command.
	argv := ExternalAddress allocate: (FFIExternalType pointerSize * 2).
	argv pointerAt: 1 put: commandArg.
	argv pointerAt: (1 + FFIExternalType pointerSize) put: ExternalAddress null.

	[
		self 
			spawnAsync: VTE_PTY_DEFAULT 
			workingDirectory: working_directory
			argv: argv 
			envv: ExternalAddress null 
			spawnFlags: spaen_flags 
			childSetup: child_setup 
			childSetupData:  child_setup_data 
			childDestroyNotify: child_setup_data_destroy 
			timeout: timeout 
			cancellable: cancellable 
			callback: callback
			data: user_data ]
	ensure: [
		argv free.
		commandArg free ].
]

{ #category : 'accessing' }
VteTerminal >> text [

	^ self getText
]

{ #category : 'accessing' }
VteTerminal >> unselectAll [

	^ self 
		ffiCall: #(void vte_terminal_unselect_all (self))
		module: VteLibrary
]

{ #category : 'private' }
VteTerminal >> vteHyperlinkCheckAtX: x y: y [

	^ self ffiCall: #(void* vte_terminal_check_hyperlink_at (self, double x, double y))
]
