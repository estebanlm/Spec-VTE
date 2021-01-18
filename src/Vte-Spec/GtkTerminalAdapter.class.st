Class {
	#name : #GtkTerminalAdapter,
	#superclass : #GtkAdapter,
	#instVars : [
		'innerWidget',
		'lastMenuShown',
		'inputStream'
	],
	#category : #'Vte-Spec'
}

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
	
	self addMenuTo: vteTerminal.
	vteTerminal connectKeyPressEvent: [ :event | 
		self handleKeyEvent: event ]
]

{ #category : #building }
GtkTerminalAdapter >> buildMenu: aMenuPresenter [
	| menuPresenter |
	
	menuPresenter := self presenter newMenu.
	
	aMenuPresenter ifNotNil: [ 
		aMenuPresenter menuGroups do: [ :each | 
			menuPresenter addMenuGroup: each ] ].
	
	self presenter hasEditionContextMenu ifTrue: [ 
		self presenter editionContextMenu menuGroups 
			do: [ :each | menuPresenter addMenuGroup: each ] ].
	
	lastMenuShown := menuPresenter buildWithSpec.
		
	^ lastMenuShown
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

{ #category : #api }
GtkTerminalAdapter >> clear [

	self feed: Character escape asString, 'c'	
]

{ #category : #api }
GtkTerminalAdapter >> clearScreen [

	self feed: Character escape asString, '[2J'
]

{ #category : #private }
GtkTerminalAdapter >> configureKeyBindings: gtkWidget [

	dispatcher := GtkKMDispatcher on: self presenter
]

{ #category : #api }
GtkTerminalAdapter >> copySelection [

	self innerWidgetDo: [ :w | w copyClipboardText ]
]

{ #category : #api }
GtkTerminalAdapter >> feed: aString [

	self innerWidgetDo: [ :w |  
		w feed: (self isWrapWord 
			ifTrue: [ self wrapWord: aString ]
			ifFalse: [ aString ]) 
			withLineEndingTerminal ]
]

{ #category : #private }
GtkTerminalAdapter >> flushInputStream [
	| inputString |
	
	inputString := inputStream contents.
	self resetInputStream.
	self flag: #TODO. "inform input"
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

{ #category : #private }
GtkTerminalAdapter >> initialize [

	super initialize.
	self resetInputStream
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
GtkTerminalAdapter >> resetInputStream [

	inputStream := String new writeStream
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
