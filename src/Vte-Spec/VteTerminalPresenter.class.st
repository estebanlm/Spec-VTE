Class {
	#name : #VteTerminalPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'scrollBar',
		'box',
		'terminal',
		'inputStream',
		'commandHandlers'
	],
	#category : #'Vte-Spec'
}

{ #category : #private }
VteTerminalPresenter >> announceCommandReceived: commandString [

	commandHandlers ifNil: [ ^ self ].
	commandHandlers do: [ :each | 
		each cull: commandString ]
]

{ #category : #private }
VteTerminalPresenter >> characterReceived: aCharacter [
	
	inputStream << aCharacter.
	terminal feed: aCharacter asString
]

{ #category : #api }
VteTerminalPresenter >> feed: aString [

	GtkRunLoop defer: [ 
		terminal feed: aString ]
]

{ #category : #api }
VteTerminalPresenter >> feedLine: aString [

	^ self feed: aString, self newLine
]

{ #category : #private }
VteTerminalPresenter >> flushInputStream [
	| commandString |
	
	commandString := inputStream contents.
	self resetInputStream.
	self announceCommandReceived: commandString
]

{ #category : #private }
VteTerminalPresenter >> handleKeyEvent: event [

	event isReturn ifTrue: [
		self flushInputStream.
		self feed: self newLine.
		^ true ].

	(event keyValue between: 27 and: 127) ifTrue: [ 
		self characterReceived: event keyCharacter.
		^ true ].

	^ false
]

{ #category : #initialization }
VteTerminalPresenter >> initialize [

	super initialize.
	self resetInputStream
]

{ #category : #initialization }
VteTerminalPresenter >> initializePresenters [

	terminal := VteTerminal new
		connectKeyPressEvent: [ :event | self handleKeyEvent: event ];
		yourself.
	scrollBar := GtkScrollBar newVerticalAdjustment: terminal vAdjustment.

	layout := SpBoxLayout newHorizontal
		add: (self newGtkWidget 
			widget: ((box := GtkBox newHorizontal)
				packStart: terminal expand: true;
				packStart: scrollBar expand: false;
				showAll));
			yourself;
		yourself
]

{ #category : #private }
VteTerminalPresenter >> newLine [
	
	^ String crlf
]

{ #category : #private }
VteTerminalPresenter >> resetInputStream [

	inputStream := String new writeStream
]

{ #category : #'api-events' }
VteTerminalPresenter >> whenCommandReceivedDo: aBlock [

	commandHandlers ifNil: [ commandHandlers := #() ].
	commandHandlers := commandHandlers copyWith: aBlock
]
