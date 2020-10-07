Class {
	#name : #VteTerminal,
	#superclass : #GtkWidget,
	#traits : 'GtkTScrollable',
	#classTraits : 'GtkTScrollable classTrait',
	#pools : [
		'VteCursorShape'
	],
	#category : #Vte
}

{ #category : #example }
VteTerminal class >> example [ 
	| vte scrollBar box |

	GtkApplication ensureRunning.

	vte := self new
		beCursorShapeIBeam;
		allowHyperlink: true;
		scrollOnOutput: true;
		mouseAutohide: true;
		yourself.

	scrollBar := GtkScrollBar newVerticalAdjustment: vte vAdjustment.

	box := GtkBox newHorizontal
		packStart: vte;
		packStart: scrollBar expand: false;
		yourself.

	GtkWindow new 
		title: 'Vte';
		add: box;
		showAll.

	vte feed: ((String loremIpsum withNoLineLongerThan: 80) withLineEndings: String crlf)
]

{ #category : #'instance creation' }
VteTerminal class >> new [

	^ self vteTerminalNew initialize
]

{ #category : #private }
VteTerminal class >> vteTerminalNew [

	^ self ffiCall: #(VteTerminal *vte_terminal_new()) module: VteLibrary
]

{ #category : #accessing }
VteTerminal >> allowHyperlink: allow_hyperlink [

	self 
		ffiCall: #(void vte_terminal_set_allow_hyperlink (self, gboolean allow_hyperlink))
		module: VteLibrary
]

{ #category : #accessing }
VteTerminal >> beCursorShapeBlock [

	self cursorShape: VTE_CURSOR_SHAPE_BLOCK
]

{ #category : #accessing }
VteTerminal >> beCursorShapeIBeam [

	self cursorShape: VTE_CURSOR_SHAPE_IBEAM
]

{ #category : #accessing }
VteTerminal >> beCursorShapeUnderline [

	self cursorShape: VTE_CURSOR_SHAPE_UNDERLINE
]

{ #category : #accessing }
VteTerminal >> colorForeground: foreground [

	^ self 
		ffiCall: #(void vte_terminal_set_color_foreground (self, const GdkRGBA *foreground)) 
		module: VteLibrary
]

{ #category : #accessing }
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
				new: (GdkRGBA structureSize * paletteArray size) + 1
				streamContents: [ :stream | 
					paletteArray do: [ :each | stream << each gtkRGBA getHandle ].
					stream << (ByteArray with: 0) ] ]
		ifEmpty: [ 
			ExternalAddress null ].

	self 
		setColorsForeground: (foreground 
			ifNotNil: [ :c | c gtkRGBA getHandle ] 
			ifNil: [ ExternalAddress null ])
		background: (background 
			ifNotNil: [ :c | c gtkRGBA getHandle ] 
			ifNil: [ ExternalAddress null ])
		palette: gtkPalette
		paletteSize: paletteArray size
]

{ #category : #accessing }
VteTerminal >> colorHighlight: foreground [

	^ self 
		ffiCall: #(void vte_terminal_set_color_highlight (self, const GdkRGBA *foreground)) 
		module: VteLibrary
]

{ #category : #accessing }
VteTerminal >> colorHighlightForeground: foreground [

	^ self 
		ffiCall: #(void vte_terminal_set_color_highlight_foreground (self, const GdkRGBA *foreground)) 
		module: VteLibrary
]

{ #category : #'accessing copy-paste' }
VteTerminal >> copyClipboardHTML [

	^ self 
		ffiCall: #(void vte_terminal_copy_clipboard_format (self, gint 2))
		module: VteLibrary
]

{ #category : #'accessing copy-paste' }
VteTerminal >> copyClipboardText [

	^ self 
		ffiCall: #(void vte_terminal_copy_clipboard_format (self, gint 1))
		module: VteLibrary
]

{ #category : #accessing }
VteTerminal >> cursorShape [

	^ self 
		ffiCall: #(VteCursorShape vte_terminal_get_cursor_shape (self))
		module: VteLibrary
]

{ #category : #accessing }
VteTerminal >> cursorShape: shape [

	^ self 
		ffiCall: #(void vte_terminal_set_cursor_shape (self, VteCursorShape shape))
		module: VteLibrary
]

{ #category : #accessing }
VteTerminal >> feed: aString [
	
	self feed: aString length: -1
]

{ #category : #accessing }
VteTerminal >> feed: string length: length [

	self 
		ffiCall: #(void vte_terminal_feed (self, const char *string, gssize length))
		module: VteLibrary
]

{ #category : #accessing }
VteTerminal >> feedChild: aString [

	self feedChild: aString length: -1
]

{ #category : #accessing }
VteTerminal >> feedChild: text length: length [

	self 
		ffiCall: #(void vte_terminal_feed_child (self, const char *text, gssize length))
		module: VteLibrary
]

{ #category : #testing }
VteTerminal >> isAllowHyperlink [

	self 
		ffiCall: #(gboolean vte_terminal_get_allow_hyperlink (self))
		module: VteLibrary
]

{ #category : #testing }
VteTerminal >> isMouseAutohide [

	self 
		ffiCall: #(gboolean vte_terminal_get_mouse_autohide (self))
		module: VteLibrary
]

{ #category : #accessing }
VteTerminal >> mouseAutohide: setting [

	self 
		ffiCall: #(void vte_terminal_set_mouse_autohide (self, gboolean setting))
		module: VteLibrary
]

{ #category : #'accessing copy-paste' }
VteTerminal >> pasteClipboard [

	^ self 
		ffiCall: #(void vte_terminal_paste_clipboard (self))
		module: VteLibrary
]

{ #category : #accessing }
VteTerminal >> scrollOnOutput: scroll [

	self 
		ffiCall: #(void vte_terminal_set_scroll_on_output (self, gboolean scroll))
		module: VteLibrary
]

{ #category : #private }
VteTerminal >> setColorsForeground: foreground background: background palette: palette paletteSize: palette_size [
		
	self 
		ffiCall: #(void vte_terminal_set_colors (
			self,
			"const GdkRGBA *"void *foreground,
			"const GdkRGBA *"void *background,
			"const GdkRGBA *"void *palette,
			gsize palette_size))
		module: VteLibrary
]
