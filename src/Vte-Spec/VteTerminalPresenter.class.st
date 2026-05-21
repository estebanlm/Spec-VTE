Class {
	#name : 'VteTerminalPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'commandHandlers',
		'editable',
		'decorations'
	],
	#category : 'Vte-Spec-Widgets',
	#package : 'Vte-Spec',
	#tag : 'Widgets'
}

{ #category : 'specs' }
VteTerminalPresenter class >> adapterName [

	^ #TerminalAdapter
]

{ #category : 'api' }
VteTerminalPresenter >> addDecoration: aDecoration [

	decorations ifNil: [ decorations := #() ].
	aDecoration presenter: self.
	decorations := decorations copyWith: aDecoration.
	self withAdapterDo: [ :anAdapter | 
		anAdapter addDecoration: aDecoration ]
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> backgroundColor: aColor [
	"Set RGB color (modern terminals support it)"

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter backgroundColor: aColor ]
]

{ #category : 'api' }
VteTerminalPresenter >> beEditable [
	"Allow edition (deny readonly)."

	self editable: true
]

{ #category : 'api' }
VteTerminalPresenter >> beNotEditable [
	"Set content text as not editable (readonly)"

	self editable: false
]

{ #category : 'api' }
VteTerminalPresenter >> charSize [
	"The size of a character in the terminal (useful to conversions)"
	
	^ self withAdapterDo: [ :anAdapter | anAdapter charSize ]
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> clear [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter clear ]
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> clearLine [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter clearLine ]
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> clearScreen [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter clearScreen ]
]

{ #category : 'api' }
VteTerminalPresenter >> columnCount [

	self withAdapterDo: [ :anAdapter | ^ anAdapter columnCount ].
	^ 0

]

{ #category : 'command support' }
VteTerminalPresenter >> copySelection [
	
	self withAdapterDo: [ :anAdapter | 
		anAdapter copySelection ]
]

{ #category : 'command support' }
VteTerminalPresenter >> copySelectionAsHTML [
	
	self withAdapterDo: [ :anAdapter | 
		anAdapter copySelectionAsHTML ]
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> cursorPosition: aPoint [
	
	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter cursorPosition: aPoint ]
]

{ #category : 'api' }
VteTerminalPresenter >> decorations [

	^ decorations ifNil: [ #() ]
]

{ #category : 'initialization' }
VteTerminalPresenter >> defaultActions [

	^ SpActionGroup new 
		addActionWith: [ :action | action
			name: 'Copy';
			description: 'Copy current selection';
			shortcutKey: $c shift actionModifier;
			action: [ self copySelection ] ];
		addActionWith: [ :action | action
			name: 'Copy as HTML';
			description: 'Copy current selection as HTML text';
			action: [ self copySelectionAsHTML ] ];
		addActionWith: [ :action | action 
			name: 'Paste';
			description: 'Paste current clipboard context';
			shortcutKey: $p shift actionModifier;
			action: [ self paste ] ];
		yourself
]

{ #category : 'private' }
VteTerminalPresenter >> editable: aBoolean [

	editable := aBoolean
]

{ #category : 'api' }
VteTerminalPresenter >> feed: aString [

	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter feed: aString ]
]

{ #category : 'api' }
VteTerminalPresenter >> feedBytes: aByteArray [

	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter feedBytes: aByteArray ]
]

{ #category : 'api' }
VteTerminalPresenter >> feedLine: aString [

	^ self feed: aString, String cr
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> foregroundColor: aColor [
	"Set RGB color (modern terminals support it)"
	
	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter foregroundColor: aColor ]
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> hideCursor [
	
	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter hideCursor ]
]

{ #category : 'initialization' }
VteTerminalPresenter >> initialize [

	super initialize.
	editable := true.
	self registerActions
]

{ #category : 'testing' }
VteTerminalPresenter >> isEditable [

	^ editable
]

{ #category : 'command support' }
VteTerminalPresenter >> paste [
	
	self withAdapterDo: [ :anAdapter | 
		anAdapter paste ]
]

{ #category : 'initialization' }
VteTerminalPresenter >> registerActions [

	self ensureInternalActions 
		addShortcutWith: [ :action | action
			name: 'show-context-menu';
			shortcutKey: $t actionModifier;
			action: [ self showContextMenu ] ].
			
	self actions: self defaultActions
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> reset [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter reset ]
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> restoreCursor [
	
	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter restoreCursor ]
]

{ #category : 'api' }
VteTerminalPresenter >> rowCount [

	self withAdapterDo: [ :anAdapter | ^ anAdapter rowCount ].
	^ 0

]

{ #category : 'api - ansi' }
VteTerminalPresenter >> saveCursor [
	
	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter saveCursor ]
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> showCursor [
	
	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter showCursor ]
]

{ #category : 'api' }
VteTerminalPresenter >> size: aPoint [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter size: aPoint ]
]

{ #category : 'api' }
VteTerminalPresenter >> spawnAsync: programName workingDirectory: workingDirectory arguments: aCollection [
	
	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter 
			spawnAsync: programName 
			workingDirectory: workingDirectory 
			arguments: aCollection ]
]

{ #category : 'api' }
VteTerminalPresenter >> terminateAllSpawns [
	
	self withAdapterDo: [ :anAdapter |
		anAdapter terminateAllSpawns ]
]

{ #category : 'api - events' }
VteTerminalPresenter >> whenChildExitedDo: aBlock [

	self announcer 
		when: VteChildExited 
		do: aBlock 
		for: aBlock receiver
]

{ #category : 'api' }
VteTerminalPresenter >> withHyperlinks [

	self addDecoration: VteTerminalHyperlinkDecoration new
]
