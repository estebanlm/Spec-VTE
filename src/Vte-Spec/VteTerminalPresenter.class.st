Class {
	#name : 'VteTerminalPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#traits : 'SpTContextMenu',
	#classTraits : 'SpTContextMenu classTrait',
	#instVars : [
		'#commandHandlers',
		'#editionContextMenu',
		'#editable',
		'#decorations'
	],
	#category : 'Vte-Spec-Widgets',
	#package : 'Vte-Spec',
	#tag : 'Widgets'
}

{ #category : 'specs' }
VteTerminalPresenter class >> adapterName [

	^ #TerminalAdapter
]

{ #category : 'commands' }
VteTerminalPresenter class >> buildEditionCommandsGroupFor: presenterInstance [
	| rootCommandGroup |

	rootCommandGroup := CmCommandGroup forSpec beRoot.
	self 
		buildEditionCommandsGroupWith: presenterInstance 
		forRoot: rootCommandGroup.
	
	^ rootCommandGroup
]

{ #category : 'commands' }
VteTerminalPresenter class >> buildEditionCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	aCmCommandsGroup beDisplayedAsGroup.
	aCmCommandsGroup register: (self textEditionCommandsGroupWith: presenter)
]

{ #category : 'commands' }
VteTerminalPresenter class >> textEditionCommandsGroupWith: aPresenter [
	| group |

	group := (CmCommandGroup named: 'Selection edition commands') asSpecGroup.
	group
		description: 'Edit code selection.';
		beDisplayedAsGroup.
	
	VteTextEditionCommand allSubclassesDo: [ :commandClass | 
		group register: (commandClass forSpecContext: aPresenter) ].
	
	^ group
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

{ #category : 'private' }
VteTerminalPresenter >> buildContextKeyBindingsWith: aCategory [
	| category |
	
	category := self newContextMenuKeyBindings.
	aCategory ifNotNil: [ 
		aCategory allEntries keymaps do: [ :each |
			category addKeymapEntry: each ] ].
	
	^ category
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

{ #category : 'api - shortcuts' }
VteTerminalPresenter >> contextKeyBindings [

	^ self buildContextKeyBindingsWith: super contextKeyBindings
]

{ #category : 'api' }
VteTerminalPresenter >> contextMenu [
	"Answer context menu or nil if there is none defined.
	 Context menu can be an instace of `SpMenuPresenter` or a block (that will answer eventually an 
	 instance of `SpMenuPresenter` aswell. 
	 If your context menu is defined through a block it means is dynamic, and it will be evaluated 
	 each time the context menu is invoked."

	^ contextMenu
]

{ #category : 'api' }
VteTerminalPresenter >> contextMenu: aValuableOrMenuPresenter [
	"Set the context menu.
	 Context menu can be an instace of `SpMenuPresenter` or a block (that will answer eventually an 
	 instance of `SpMenuPresenter` aswell. 
	 If your context menu is defined through a block it means is dynamic, and it will be evaluated 
	 each time the context menu is invoked."

	contextMenu := aValuableOrMenuPresenter
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

{ #category : 'private' }
VteTerminalPresenter >> editable: aBoolean [

	editable := aBoolean
]

{ #category : 'private' }
VteTerminalPresenter >> editionCommandsGroup [

	^ SpRecursiveContextSetter
		visit: (self class buildEditionCommandsGroupFor: self defaultCommandsContext) 
		toSetContext: self defaultCommandsContext
]

{ #category : 'private' }
VteTerminalPresenter >> editionContextKeyBindings [

	^ self editionCommandsGroup asKMCategory
]

{ #category : 'private' }
VteTerminalPresenter >> editionContextMenu [

	^ self editionCommandsGroup asMenuPresenter
]

{ #category : 'command support' }
VteTerminalPresenter >> feed: aString [

	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter feed: aString ]
]

{ #category : 'command support' }
VteTerminalPresenter >> feedBytes: aByteArray [

	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter feedBytes: aByteArray ]
]

{ #category : 'command support' }
VteTerminalPresenter >> feedLine: aString [

	^ self feed: aString, String cr
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> foregroundColor: aColor [
	"Set RGB color (modern terminals support it)"
	
	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter foregroundColor: aColor ]
]

{ #category : 'testing' }
VteTerminalPresenter >> hasEditionContextMenu [

	^ editionContextMenu
]

{ #category : 'api - ansi' }
VteTerminalPresenter >> hideCursor [
	
	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter hideCursor ]
]

{ #category : 'initialization' }
VteTerminalPresenter >> initialize [

	super initialize.
	editable := true.
	self withEditionContextMenu
]

{ #category : 'testing' }
VteTerminalPresenter >> isEditable [

	^ editable
]

{ #category : 'private' }
VteTerminalPresenter >> newContextMenuKeyBindings [
	
	^ self editionCommandsGroup asKMCategory
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

{ #category : 'command support' }
VteTerminalPresenter >> withEditionContextMenu [
	"Enables edition context menu. When this option is selected, right-clicking in the text area 
	 will show a standard edition menu (copy, cut, copy&paste). 
	 Adding your own context menu (See `SpAbstractTextPresenter>>#contextMenu:`) will make both 
	 menus (edition and your own) to be combined into one single context menu."

	editionContextMenu := true
]

{ #category : 'api' }
VteTerminalPresenter >> withHyperlinks [

	self addDecoration: VteTerminalHyperlinkDecoration new
]

{ #category : 'command support' }
VteTerminalPresenter >> withoutEditionContextMenu [
	"Disable default edition context menu. 
	 See also `SpTextPresenter>>#withEditionContextMenu`."

	editionContextMenu := false
]
