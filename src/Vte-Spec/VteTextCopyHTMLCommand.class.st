Class {
	#name : #VteTextCopyHTMLCommand,
	#superclass : #VteTextEditionCommand,
	#category : #'Vte-Spec-Commands'
}

{ #category : #defaults }
VteTextCopyHTMLCommand class >> defaultIconName [
	
	^ nil
]

{ #category : #default }
VteTextCopyHTMLCommand class >> defaultName [

	^ 'Copy HTML'
]

{ #category : #default }
VteTextCopyHTMLCommand class >> defaultShortcutKey [

	^ nil
]

{ #category : #converting }
VteTextCopyHTMLCommand >> asSpecCommand [
	| command |

	command := super asSpecCommand.
	self shortcutKey ifNotNil: [ :key | command shortcutKey: key ].
	self defaultIconName
		ifNotNil: [ :iconName | command iconName: iconName ].

	^ command
]

{ #category : #converting }
VteTextCopyHTMLCommand >> defaultIconName [

	^ self class defaultIconName
]

{ #category : #execution }
VteTextCopyHTMLCommand >> execute [

	context copySelectionAsHTML
]

{ #category : #converting }
VteTextCopyHTMLCommand >> shortcutKey [

	^ self class defaultShortcutKey
]
