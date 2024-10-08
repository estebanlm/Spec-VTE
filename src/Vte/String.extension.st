Extension { #name : 'String' }

{ #category : '*Vte' }
String >> ansiReplaceAllBoldWithBright [
	"Answer a copy of the receiver in which all occurrences of oldSubstring have been replaced by newSubstring"
    | index bold |
	
	index := 1.
	bold := Character escape asString, '[1;'.
	^ self species 
		new: self size 
		streamContents: [ :stream | | foundIndex newString |
			[ (foundIndex := self findString: bold startingAt: index) isZero ] 
			whileFalse: [ | colorNumber |
				colorNumber := (self copyFrom: foundIndex + 4 to: foundIndex + 6) asInteger.
				newString := bold, (60 + colorNumber) asString.
				stream
					next: (foundIndex - index) putAll: self startingAt: index;
					nextPutAll: newString.
				index := foundIndex + 6 ].
			index <= self size 
				ifTrue: [ stream next: (self size - index + 1) putAll: self startingAt: index ] ]
]

{ #category : '*Vte' }
String >> escapeAnySubstring: aCollection with: aBlock [
    | index separators |
	
	separators := Character separators copyWith: Character escape.
	index := 1.
	^ self species 
		new: self size 
		streamContents: [ :stream | | foundIndex newString |
			[ (foundIndex := self findAnySubstring: aCollection startingAt: index) < self size ] 
			whileTrue: [ 
				| endIndex |
				endIndex := self indexOfAnyOf: separators startingAt: foundIndex.
				endIndex := endIndex isZero 
					ifTrue: [ self size ]
					ifFalse: [ endIndex - 1 ].
				newString := aBlock value: (self copyFrom: foundIndex to: endIndex).
				stream
					next: (foundIndex - index) putAll: self startingAt: index;
					nextPutAll: newString.
				index := endIndex + 1 ].
			index <= self size 
				ifTrue: [ stream next: (self size - index + 1) putAll: self startingAt: index ] ]
]
