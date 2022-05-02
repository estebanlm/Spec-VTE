Class {
	#name : #GtkTerminalAdapter,
	#superclass : #GtkAdapter,
	#instVars : [
		'innerWidget',
		'lastMenuShown',
		'inputStream',
		'cursorHidden'
	],
	#category : #'Vte-Spec-Adapter'
}

{ #category : #api }
GtkTerminalAdapter >> addDecoration: aDecoration [

	self innerWidgetDo: [ :w | 
		aDecoration configure: w withinAdapter: self ]
]

{ #category : #building }
GtkTerminalAdapter >> addKeyBindingsTo: vteTerminal [

	super addKeyBindingsTo: vteTerminal.
	self hasContextMenu ifTrue: [
		self addContextMenuKeyBindings: vteTerminal ]
]

{ #category : #building }
GtkTerminalAdapter >> addMenuTo: vteTerminal [
	
	self hasContextMenu ifFalse: [ ^ self ].
	vteTerminal connectRightClicked: [ :event |
		self 
			showMenu: self presenter contextMenu 
			event: event.
		true ]
]

{ #category : #building }
GtkTerminalAdapter >> addModelTo: vteTerminal [

	super addModelTo: vteTerminal.
	self presenter decorations do: [ :each | 
		each configure: vteTerminal withinAdapter: self ].
	self addMenuTo: vteTerminal.
	"vteTerminal connectKeyPressEvent: [ :event | 
		self handleKeyEvent: event ]"
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> backgroundColor: aColor [

	self feedEscape: ('[48;2;{1};{2};{3}m' format: {
		(aColor red * 255) asInteger.
		(aColor green * 255) asInteger. 
		(aColor blue * 255) asInteger })
]

{ #category : #building }
GtkTerminalAdapter >> buildMenu: aMenuPresenter [
	| menuPresenter |
	
	menuPresenter := self presenter newMenu.
	
	self presenter hasEditionContextMenu ifTrue: [ 
		self presenter editionContextMenu menuGroups 
			do: [ :each | menuPresenter addMenuGroup: each ] ].

	aMenuPresenter ifNotNil: [ 
		aMenuPresenter menuGroups do: [ :each | 
			menuPresenter addMenuGroup: each ] ].
		
	lastMenuShown := menuPresenter build.
		
	^ lastMenuShown
]

{ #category : #api }
GtkTerminalAdapter >> charSize [

	^ self innerWidgetDo: [ :w | 
		 w charWidth @ w charHeight ]
]

{ #category : #private }
GtkTerminalAdapter >> characterReceived: aCharacter [
	
	inputStream << aCharacter.
	self feed: aCharacter asString
]

{ #category : #private }
GtkTerminalAdapter >> characterWidth [
	
	^ self innerWidget pangoContext metrics approximateScaledWidth
]

{ #category : #configuring }
GtkTerminalAdapter >> checkForHyperlink: event [

	event isPrimaryButton ifFalse: [ ^ false ].

	^ self innerWidgetDo: [ :w |
		(w hyperlinkCheckEvent: event)
			ifNotNil: [ :aString |
				self triggerHyperlinkPressed: aString.
				true ]
			ifNil: [ 
				false ] ]
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> clear [

	self feedEscape: 'c'.
	cursorHidden ifTrue: [ self hideCursor ]
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> clearLine [

	self feedEscape: '[2K'
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> clearScreen [

	self feedEscape: '[2J'
]

{ #category : #api }
GtkTerminalAdapter >> columnCount [

	^ self innerWidgetDo: [ :w | w columnCount ]
]

{ #category : #private }
GtkTerminalAdapter >> configureKeyBindings: gtkWidget [

	dispatcher := GtkKMDispatcher on: self presenter
]

{ #category : #api }
GtkTerminalAdapter >> copySelection [

	self innerWidgetDo: [ :w | w copyClipboardText ]
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> cursorPosition: aPoint [
	"ANSI CUP"

	self feedEscape: ('[{1};{2}H' format: { aPoint y. aPoint x })
]

{ #category : #api }
GtkTerminalAdapter >> feed: aString [

	self innerWidgetDo: [ :w |  
		| decoratedString |
		decoratedString := self processDecorations: aString.
		w feed: decoratedString withLineEndingTerminal ]
]

{ #category : #api }
GtkTerminalAdapter >> feedBytes: aByteArray [

	self innerWidgetDo: [ :w |  
		w feedBytes: aByteArray ]
]

{ #category : #api }
GtkTerminalAdapter >> feedEscape: aString [

	self innerWidgetDo: [ :w |
		w feed: Character escape asString, aString ].
]

{ #category : #private }
GtkTerminalAdapter >> flushInputStream [
	| inputString |
	
	inputStream ifNil: [ ^ self ].
	inputString := inputStream contents.
	self resetInputStream.
	self flag: #TODO. "inform input"
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> foregroundColor: aColor [

	self feedEscape: ('[38;2;{1};{2};{3}m' format: {
		(aColor red * 255) asInteger.
		(aColor green * 255) asInteger. 
		(aColor blue * 255) asInteger })
]

{ #category : #private }
GtkTerminalAdapter >> handleKeyEvent: event [
	| wasHandled |

	wasHandled := super handleKeyEvent: event.
	wasHandled ifTrue: [ ^ wasHandled ].

	"Do not listen to keyboard if this is not editable"
	self presenter isEditable ifFalse: [ ^ false  ].
		
	event isReturn ifTrue: [ 
		self flushInputStream.
		self feed: String crlf.
		^ true ].
	
	(event keyValue between: 27 and: 127) ifTrue: [ 
		self characterReceived: event keyCharacter.
		^ true ].
	
	^ false
]

{ #category : #private }
GtkTerminalAdapter >> hasContextMenu [
	
	^ self presenter hasEditionContextMenu
		or: [ self presenter contextMenu notNil ]
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> hideCursor [

	cursorHidden := true.
	self feedEscape: '[?25l'
]

{ #category : #initialization }
GtkTerminalAdapter >> initialize [

	super initialize.
	cursorHidden := false
]

{ #category : #'private accessing' }
GtkTerminalAdapter >> innerWidget [

	^ innerWidget
]

{ #category : #private }
GtkTerminalAdapter >> isWrapWord [

	^ false
]

{ #category : #private }
GtkTerminalAdapter >> processDecorations: aString [
	| result |

	self presenter decorations isEmptyOrNil 
		ifTrue: [ ^ aString ].
	
	result := aString.
	self presenter decorations do: [ :aDecoration | 
		result := aDecoration decorate: result ].

	^ result
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> reset [

	self feedEscape: '[0m'
]

{ #category : #private }
GtkTerminalAdapter >> resetInputStream [

	inputStream := String new writeStream
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> restoreCursor [

	self feedEscape: '[u'
]

{ #category : #api }
GtkTerminalAdapter >> rowCount [

	^ self innerWidgetDo: [ :w | w rowCount ]
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> saveCursor [

	self feedEscape: '[s'
]

{ #category : #configuring }
GtkTerminalAdapter >> setHyperlinksTo: aWidget [

	aWidget allowHyperlink: true.
	aWidget connectButtonPressEvent: [ :event |
		self checkForHyperlink: event ].
]

{ #category : #'api-ansi' }
GtkTerminalAdapter >> showCursor [

	cursorHidden := false.
	self feedEscape: '[?25h'
]

{ #category : #api }
GtkTerminalAdapter >> size: aPoint [

	self innerWidgetDo: [ :w | w size: aPoint ]
]

{ #category : #configuring }
GtkTerminalAdapter >> triggerHyperlinkPressed: aLink [

	self presenter announce: (VteHyperlinkPressed newLink: aLink)
]

{ #category : #building }
GtkTerminalAdapter >> widgetClass [

	^ VteTerminal
]

{ #category : #building }
GtkTerminalAdapter >> wrapWidget: gtkWidget [
	| scrollBar |

	innerWidget := gtkWidget.
	scrollBar := GtkScrollBar newVerticalAdjustment: innerWidget vAdjustment.
	^ GtkBox newHorizontal
		packStart: innerWidget expand: true;
		packStart: scrollBar expand: false;
		showAll
]

{ #category : #private }
GtkTerminalAdapter >> wrapWord: aString [
	| width maxChars |

	width := self innerWidget size x.
	maxChars := width // self characterWidth.
	
	^ aString size <= maxChars 
		ifTrue: [ aString ]
		ifFalse: [ aString withNoLineLongerThan: maxChars ].
]
