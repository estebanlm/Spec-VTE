Class {
	#name : 'GtkAdapterActionTerminalManager',
	#superclass : 'GtkAdapterActionManager',
	#category : 'Vte-Spec-Adapter',
	#package : 'Vte-Spec',
	#tag : 'Adapter'
}

{ #category : 'private - actions' }
GtkAdapterActionTerminalManager >> actionGroups [
	| groups |

	groups := { self presenter actions beRoot beDisplayedAsGroup }.
	^ self presenter hasEditionContextMenu 
		ifTrue: [ groups copyWithFirst: self presenter editionCommandsGroup beRoot beDisplayedAsGroup ]
		ifFalse: [ groups ]
]

{ #category : 'actions' }
GtkAdapterActionTerminalManager >> installGroupsOn: gtkWidget [

	super installGroupsOn: gtkWidget.	
	self presenter hasEditionContextMenu ifTrue: [  
		self installGroup: self presenter editionCommandsGroup on: gtkWidget ]
]
