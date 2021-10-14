Class {
	#name : #VteCursorShape,
	#superclass : #GEnumeration,
	#classVars : [
		'VTE_CURSOR_SHAPE_BLOCK',
		'VTE_CURSOR_SHAPE_IBEAM',
		'VTE_CURSOR_SHAPE_UNDERLINE'
	],
	#category : #Vte
}

{ #category : #'accessing enum' }
VteCursorShape class >> VTE_CURSOR_SHAPE_BLOCK [
	"This method was automatically generated"
	^ VTE_CURSOR_SHAPE_BLOCK
]

{ #category : #'accessing enum' }
VteCursorShape class >> VTE_CURSOR_SHAPE_IBEAM [
	"This method was automatically generated"
	^ VTE_CURSOR_SHAPE_IBEAM
]

{ #category : #'accessing enum' }
VteCursorShape class >> VTE_CURSOR_SHAPE_UNDERLINE [
	"This method was automatically generated"
	^ VTE_CURSOR_SHAPE_UNDERLINE
]

{ #category : #'enum declaration' }
VteCursorShape class >> enumDecl [

	^  {
 	#VTE_CURSOR_SHAPE_BLOCK. 			0.
	#VTE_CURSOR_SHAPE_IBEAM.				1.
	#VTE_CURSOR_SHAPE_UNDERLINE.		2.
	}
]
