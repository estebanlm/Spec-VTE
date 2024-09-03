Extension { #name : 'String' }

{ #category : '*Vte-Spec' }
String >> withLineEndingTerminal [

	^ self withLineEndingsExtended: self class crlf
]

{ #category : '*Vte-Spec' }
String >> withLineEndingsExtended: lineEndingString [
	"Answer a new instance where all occurrences of CRLF, CR, and LF are substituted with the specified line ending string."
	
	^ self species streamContents: [ :out |
		| in c |
		in := self readStream.
		[ in atEnd ] whileFalse: [
			c := in next.
			"CR"
			c == Character cr 
				ifTrue: [
					c := in peek.
					"CR LF"
					c == Character lf 
						ifTrue: [ in next ].
					out nextPutAll: lineEndingString ] 
				ifFalse: [
					"LF"
					c == Character lf 
						ifTrue: [
							c := in peek. 
							c == Character cr 
								ifTrue: [ in next ].
							out nextPutAll: lineEndingString ] 
						ifFalse: [ out nextPut: c ] ] ] ]

]
