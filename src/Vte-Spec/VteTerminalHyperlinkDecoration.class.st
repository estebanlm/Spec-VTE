Class {
	#name : #VteTerminalHyperlinkDecoration,
	#superclass : #VteTerminalDecoration,
	#classVars : [
		'OSC8',
		'OSC8Separator',
		'ST'
	],
	#category : #'Vte-Spec'
}

{ #category : #'class initialization' }
VteTerminalHyperlinkDecoration class >> initialize [

	OSC8 := Character escape asString, ']8;;'.
	OSC8Separator := Character escape asString, '\'.
	ST := Character escape asString, '\'
]

{ #category : #adding }
VteTerminalHyperlinkDecoration >> addOSCEscapeTo: aString [

	^ String streamContents: [ :stream |
		stream 
			<< OSC8
			<< aString 
			<< OSC8Separator
			<< aString
			<< OSC8
			<< ST ]
]

{ #category : #accessing }
VteTerminalHyperlinkDecoration >> configure: aWidget withinAdapter: anAdapter [

	anAdapter setHyperlinksTo: aWidget
]

{ #category : #decorating }
VteTerminalHyperlinkDecoration >> decorate: aString [

	^ aString 
		escapeAnySubstring: #('http://' 'https://') 
		with: [ :aLink | self addOSCEscapeTo: aLink ]
]
