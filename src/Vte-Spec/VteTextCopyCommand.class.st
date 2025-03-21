Class {
	#name : 'VteTextCopyCommand',
	#superclass : 'VteTextEditionCommand',
	#category : 'Vte-Spec-Commands',
	#package : 'Vte-Spec',
	#tag : 'Commands'
}

{ #category : 'defaults' }
VteTextCopyCommand class >> defaultIconName [
	
	^ nil
]

{ #category : 'default' }
VteTextCopyCommand class >> defaultName [

	^ 'Copy'
]

{ #category : 'default' }
VteTextCopyCommand class >> defaultShortcutKey [

	^ $c actionModifier
]

{ #category : 'converting' }
VteTextCopyCommand >> asSpecCommand [
	| command |

	command := super asSpecCommand.
	self shortcutKey ifNotNil: [ :key | command shortcutKey: key ].
	self defaultIconName
		ifNotNil: [ :iconName | command iconName: iconName ].

	^ command
]

{ #category : 'converting' }
VteTextCopyCommand >> defaultIconName [

	^ self class defaultIconName
]

{ #category : 'execution' }
VteTextCopyCommand >> execute [

	context copySelection
]

{ #category : 'converting' }
VteTextCopyCommand >> shortcutKey [

	^ self class defaultShortcutKey
]
