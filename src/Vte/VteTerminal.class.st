Class {
	#name : #VteTerminal,
	#superclass : #GtkWidget,
	#traits : 'GtkTScrollable',
	#classTraits : 'GtkTScrollable classTrait',
	#category : #Vte
}

{ #category : #example }
VteTerminal class >> example [ 
	| vte scrollBar box |

	GtkApplication ensureRunning.

	vte := self new
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

	vte feed: ((String loremIpsum withNoLineLongerThan: 80) withLineEndings: String crlf).

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

{ #category : #accessing }
VteTerminal >> scrollOnOutput: scroll [

	self 
		ffiCall: #(void vte_terminal_set_scroll_on_output (self, gboolean scroll))
		module: VteLibrary
]
