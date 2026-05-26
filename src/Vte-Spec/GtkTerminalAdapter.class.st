Class {
	#name : 'GtkTerminalAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'innerWidget',
		'lastMenuShown',
		'inputStream',
		'cursorHidden',
		'programs'
	],
	#pools : [
		'GSpawnFlags'
	],
	#category : 'Vte-Spec-Adapter',
	#package : 'Vte-Spec',
	#tag : 'Adapter'
}

{ #category : 'api' }
GtkTerminalAdapter >> addDecoration: aDecoration [

	self innerWidgetDo: [ :w | 
		aDecoration configure: w withinAdapter: self ]
]

{ #category : 'building' }
GtkTerminalAdapter >> addModelTo: vteTerminal [

	super addModelTo: vteTerminal.
	
	vteTerminal connectChildExited: [ :status | self announceChildExited: status ].
	
	self presenter decorations do: [ :each | 
		each configure: vteTerminal withinAdapter: self ].
	"self addMenuTo: vteTerminal."
	"vteTerminal connectKeyPressEvent: [ :event | 
		self handleKeyEvent: event ]"
]

{ #category : 'private' }
GtkTerminalAdapter >> announceChildExited: status [

	self runInSystem: [
		self presenter announce: (VteChildExited newStatus: status) ]
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> backgroundColor: aColor [

	self feedEscape: ('[48;2;{1};{2};{3}m' format: {
		(aColor red * 255) asInteger.
		(aColor green * 255) asInteger. 
		(aColor blue * 255) asInteger })
]

{ #category : 'theme' }
GtkTerminalAdapter >> beDarkTheme [
	| palette |
	
	palette := #( 
		"0: Black" "1: Red" "2: Green" "3: Yellow" "4: Blue" "5: Magenta" "6: Cyan" "7: White" "8: Bright Black" 
		'2E3436' 'CC0000' '4E9A06' 'C4A000' '3465A4' '75507B' '06989A' 'D3D7CF' 
		"9: Bright Red" "10: Bright Green" "11: Bright Yellow" "12: Bright Blue" "13: Bright Magenta" "14: Bright Cyan" "15: Bright White"
		'555753' 'EF2929' '8AE234' 'FCE94F' '729FCF' 'AD7FA8' '34E2E2' 'EEEEEC' ) 
		collect: [ :each | GdkRGBA fromHexString: each ]. 
		

	self innerWidgetDo: [ :w | 
		w 
			colorForeground: nil 
			background: Color black 
			palette: palette ]
]

{ #category : 'theme' }
GtkTerminalAdapter >> beLightTheme [
	| palette |
	
	palette := #( 
		"0: Bright White (light background)" "1: Red" "2: Green" "3: Yellow" "4: Blue" "5: Magenta" "6: Cyan" "7: Black (dark foreground)" "8: Bright Black" 
		'EEEEEC' 'CC0000' '4E9A06' 'C4A000' '3465A4' '75507B' '06989A' '2E3436' 
		"9: Bright Red" "10: Bright Green" "11: Bright Yellow" "12: Bright Blue" "13: Bright Magenta" "14: Bright Cyan" "15: Bright Black"
		'555753' 'EF2929' '8AE234' 'FCE94F' '729FCF' 'AD7FA8' '34E2E2' '555753' ) 
		collect: [ :each | GdkRGBA fromHexString: each ]. 

	self innerWidgetDo: [ :w | 
		w colorForeground: nil 
		background: Color white 
		palette: palette ]
]

{ #category : 'api' }
GtkTerminalAdapter >> charSize [

	^ self innerWidgetDo: [ :w | 
		 w charWidth @ w charHeight ]
]

{ #category : 'private' }
GtkTerminalAdapter >> characterReceived: aCharacter [
	
	inputStream << aCharacter.
	self feed: aCharacter asString
]

{ #category : 'private' }
GtkTerminalAdapter >> characterWidth [
	
	^ self innerWidget pangoContext metrics approximateScaledWidth
]

{ #category : 'configuring' }
GtkTerminalAdapter >> checkForHyperlink: event [

	event isPrimaryButton ifFalse: [ ^ false ].

	^ self innerWidgetDo: [ :w |
		(w hyperlinkCheckAt: event position)
			ifNotNil: [ :aString |
				self triggerHyperlinkPressed: aString.
				true ]
			ifNil: [ 
				false ] ]
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> clear [

	self feedEscape: 'c'.
	cursorHidden ifTrue: [ self hideCursor ]
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> clearLine [

	self feedEscape: '[2K'
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> clearScreen [

	self feedEscape: '[2J'
]

{ #category : 'api' }
GtkTerminalAdapter >> columnCount [

	^ self innerWidgetDo: [ :w | w columnCount ]
]

{ #category : 'api' }
GtkTerminalAdapter >> copySelection [

	self innerWidgetDo: [ :w | w copyClipboardText ]
]

{ #category : 'api' }
GtkTerminalAdapter >> copySelectionAsHTML [

	self innerWidgetDo: [ :w | w copyClipboardHTML ]
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> cursorPosition: aPoint [
	"ANSI CUP"

	self feedEscape: ('[{1};{2}H' format: { aPoint y. aPoint x })
]

{ #category : 'api' }
GtkTerminalAdapter >> feed: aString [
	| feedString |

	feedString := (self processDecorations: aString) withLineEndingTerminal.
	self innerWidgetDo: [ :w |  
		w feed: feedString ]
]

{ #category : 'api' }
GtkTerminalAdapter >> feedBytes: aByteArray [

	self innerWidgetDo: [ :w |  
		w feedBytes: aByteArray ]
]

{ #category : 'api' }
GtkTerminalAdapter >> feedEscape: aString [

	self innerWidgetDo: [ :w |
		w feed: Character escape asString, aString ].
]

{ #category : 'private' }
GtkTerminalAdapter >> flushInputStream [
	| inputString |
	
	inputStream ifNil: [ ^ self ].
	inputString := inputStream contents.
	self resetInputStream.
	self flag: #TODO. "inform input"
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> foregroundColor: aColor [

	self feedEscape: ('[38;2;{1};{2};{3}m' format: {
		(aColor red * 255) asInteger.
		(aColor green * 255) asInteger. 
		(aColor blue * 255) asInteger })
]

{ #category : 'private' }
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

{ #category : 'api - ansi' }
GtkTerminalAdapter >> hideCursor [

	cursorHidden := true.
	self feedEscape: '[?25l'
]

{ #category : 'initialization' }
GtkTerminalAdapter >> initialize [

	super initialize.
	cursorHidden := false
]

{ #category : 'private - accessing' }
GtkTerminalAdapter >> innerWidget [

	^ innerWidget
]

{ #category : 'private' }
GtkTerminalAdapter >> isWrapWord [

	^ false
]

{ #category : 'api' }
GtkTerminalAdapter >> paste [

	self innerWidgetDo: [ :w | w pasteClipboard ]
]

{ #category : 'private' }
GtkTerminalAdapter >> processDecorations: aString [
	| result |

	self presenter decorations isEmptyOrNil 
		ifTrue: [ ^ aString ].
	
	result := aString.
	self presenter decorations do: [ :aDecoration | 
		result := aDecoration decorate: result ].

	^ result
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> reset [

	self feedEscape: '[0m'
]

{ #category : 'private' }
GtkTerminalAdapter >> resetInputStream [

	inputStream := String new writeStream
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> restoreCursor [

	self feedEscape: '[u'
]

{ #category : 'api' }
GtkTerminalAdapter >> rowCount [

	^ self innerWidgetDo: [ :w | w rowCount ]
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> saveCursor [

	self feedEscape: '[s'
]

{ #category : 'configuring' }
GtkTerminalAdapter >> setHyperlinksTo: aWidget [

	aWidget allowHyperlink: true.
	aWidget addPrimaryButtonPressEvent: [ :event | 
		self checkForHyperlink: event ]
	
]

{ #category : 'api - ansi' }
GtkTerminalAdapter >> showCursor [

	cursorHidden := false.
	self feedEscape: '[?25h'
]

{ #category : 'private' }
GtkTerminalAdapter >> sigterm: pid [
	"#define SIGTERM 15"

	^ self 
		ffiCall: #(int kill(int pid, int 15)) 
		module: LibC
]

{ #category : 'api' }
GtkTerminalAdapter >> size: aPoint [

	self innerWidgetDo: [ :w | w size: aPoint ]
]

{ #category : 'api' }
GtkTerminalAdapter >> spawnAsync: aCommand workingDirectory: workingDirectory arguments: aCollection [
	| readyCallback |

	programs ifNil: [ programs := OrderedCollection new ].
	readyCallback := GCallback 
		signature: #(void (void *selfHandle, int pid, void *error, gpointer user_data)) 
		block: [ :selfHandle :pid :error :user_data | 
			error isNull ifFalse: [ 
				self error: ('Spawn failed: {1}' format: { (GError fromHandle: error) messageString }) ].
			programs add: { aCommand. pid } ]. 

	self innerWidgetDo: [ :w | 
		w 
			spawnAsyncDefaultWorkingDirectory: workingDirectory 
			command: aCommand
			spawnFlags: G_SPAWN_DEFAULT
			childSetup: ExternalAddress null 
			childSetupData:  ExternalAddress null  
			childDestroyNotify: GCallback null
			timeout: -1 
			cancellable: ExternalAddress null
			callback: readyCallback
			data: ExternalAddress null ]
]

{ #category : 'api' }
GtkTerminalAdapter >> terminateAllSpawns [

	programs ifNil: [ ^ self ].
	
	programs do: [ :eachTuple |
		logger debug: 'Terminating: ',  eachTuple first.
		self sigterm: eachTuple second ]
]

{ #category : 'configuring' }
GtkTerminalAdapter >> triggerHyperlinkPressed: aLink [

	self presenter announce: (VteHyperlinkPressed newLink: aLink)
]

{ #category : 'building' }
GtkTerminalAdapter >> widgetClass [

	^ VteTerminal
]

{ #category : 'building' }
GtkTerminalAdapter >> wrapWidget: gtkWidget [
	| scrollbar |

	innerWidget := gtkWidget.
	innerWidget hExpand: true.
	scrollbar := GtkScrollbar newVerticalAdjustment: innerWidget vAdjustment.
	scrollbar hExpand: false.
	^ GtkBox newHorizontal
		append: innerWidget;
		append: scrollbar;
		yourself
]

{ #category : 'private' }
GtkTerminalAdapter >> wrapWord: aString [
	| width maxChars |

	width := self innerWidget size x.
	maxChars := width // self characterWidth.
	
	^ aString size <= maxChars 
		ifTrue: [ aString ]
		ifFalse: [ aString withNoLineLongerThan: maxChars ].
]
