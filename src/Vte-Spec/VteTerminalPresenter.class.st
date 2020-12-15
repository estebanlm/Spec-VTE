Class {
	#name : #VteTerminalPresenter,
	#superclass : #SpAbstractWidgetPresenter,
	#traits : 'SpTContextMenu',
	#classTraits : 'SpTContextMenu classTrait',
	#instVars : [
		'#commandHandlers',
		'#editionContextMenu'
	],
	#category : #'Vte-Spec'
}

{ #category : #specs }
VteTerminalPresenter class >> adapterName [

	^ #TerminalAdapter
]

{ #category : #commands }
VteTerminalPresenter class >> buildEditionCommandsGroupFor: presenterInstance [
	| rootCommandGroup |

	rootCommandGroup := CmCommandGroup forSpec beRoot.
	self 
		buildEditionCommandsGroupWith: presenterInstance 
		forRoot: rootCommandGroup.
	
	^ rootCommandGroup
]

{ #category : #commands }
VteTerminalPresenter class >> buildEditionCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	aCmCommandsGroup beDisplayedAsGroup.
	aCmCommandsGroup register: (self textEditionCommandsGroupWith: presenter)
]

{ #category : #commands }
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

{ #category : #private }
VteTerminalPresenter >> buildContextKeyBindingsWith: aCategory [
	| category |
	
	category := self newContextMenuKeyBindings.
	aCategory ifNotNil: [ 
		aCategory allEntries keymaps do: [ :each |
			category addKeymapEntry: each ] ].
	
	^ category
]

{ #category : #'api-shortcuts' }
VteTerminalPresenter >> contextKeyBindings [

	^ self buildContextKeyBindingsWith: super contextKeyBindings
]

{ #category : #'command support' }
VteTerminalPresenter >> contextMenu [
	"Answer context menu or nil if there is none defined.
	 Context menu can be an instace of `SpMenuPresenter` or a block (that will answer eventually an 
	 instance of `SpMenuPresenter` aswell. 
	 If your context menu is defined through a block it means is dynamic, and it will be evaluated 
	 each time the context menu is invoked."

	^ contextMenu
]

{ #category : #'command support' }
VteTerminalPresenter >> contextMenu: aValuableOrMenuPresenter [
	"Set the context menu.
	 Context menu can be an instace of `SpMenuPresenter` or a block (that will answer eventually an 
	 instance of `SpMenuPresenter` aswell. 
	 If your context menu is defined through a block it means is dynamic, and it will be evaluated 
	 each time the context menu is invoked."

	contextMenu := aValuableOrMenuPresenter
]

{ #category : #'command support' }
VteTerminalPresenter >> copySelection [
	
	self withAdapterDo: [ :anAdapter | 
		anAdapter copySelection ]
]

{ #category : #private }
VteTerminalPresenter >> editionCommandsGroup [

	^ SpRecursiveContextSetter
		visit: (self class buildEditionCommandsGroupFor: self defaultCommandsContext) 
		toSetContext: self defaultCommandsContext
]

{ #category : #private }
VteTerminalPresenter >> editionContextKeyBindings [

	^ self editionCommandsGroup asKMCategory
]

{ #category : #private }
VteTerminalPresenter >> editionContextMenu [

	^ self editionCommandsGroup asMenuPresenter
]

{ #category : #'command support' }
VteTerminalPresenter >> feed: aString [

	self withAdapterDo: [ :anAdapter |
		anAdapter feed: aString ]
]

{ #category : #'command support' }
VteTerminalPresenter >> feedLine: aString [

	^ self feed: aString, String cr
]

{ #category : #testing }
VteTerminalPresenter >> hasEditionContextMenu [

	^ editionContextMenu
]

{ #category : #initialization }
VteTerminalPresenter >> initialize [

	super initialize.
	self withEditionContextMenu
]

{ #category : #private }
VteTerminalPresenter >> newContextMenuKeyBindings [
	
	^ self editionCommandsGroup asKMCategory
]

{ #category : #'command support' }
VteTerminalPresenter >> withEditionContextMenu [
	"Enables edition context menu. When this option is selected, right-clicking in the text area 
	 will show a standard edition menu (copy, cut, copy&paste). 
	 Adding your own context menu (See `SpAbstractTextPresenter>>#contextMenu:`) will make both 
	 menus (edition and your own) to be combined into one single context menu."

	editionContextMenu := true
]

{ #category : #'command support' }
VteTerminalPresenter >> withoutEditionContextMenu [
	"Disable default edition context menu. 
	 See also `SpTextPresenter>>#withEditionContextMenu`."

	editionContextMenu := false
]
