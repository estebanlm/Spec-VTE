Class {
	#name : #VteTerminalDecoration,
	#superclass : #Object,
	#instVars : [
		'presenter'
	],
	#category : #'Vte-Spec-Decorations'
}

{ #category : #accessing }
VteTerminalDecoration >> configure: aWidget withinAdapter: anAdapter [
	
]

{ #category : #decorating }
VteTerminalDecoration >> decorate: aString [

	^ self subclassResponsibility
]

{ #category : #accessing }
VteTerminalDecoration >> presenter [

	^ presenter
]

{ #category : #accessing }
VteTerminalDecoration >> presenter: anObject [

	presenter := anObject
]
