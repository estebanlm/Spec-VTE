Class {
	#name : #VteTerminalPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'scrollBar',
		'box',
		'terminal'
	],
	#category : #'Vte-Spec'
}

{ #category : #api }
VteTerminalPresenter >> feed: aString [

	GtkRunLoop defer: [ 
		terminal feed: aString ]
]

{ #category : #api }
VteTerminalPresenter >> feedLine: aString [

	^ self feed: aString, String crlf
]

{ #category : #initialization }
VteTerminalPresenter >> initializePresenters [

	terminal := VteTerminal new.
	scrollBar := GtkScrollBar newVerticalAdjustment: terminal vAdjustment.

	layout := SpBoxLayout newHorizontal
		add: (self newGtkWidget 
			widget: ((box := GtkBox newHorizontal)
				packStart: terminal expand: true;
				packStart: scrollBar expand: false;
				showAll));
			yourself;
		yourself
]
