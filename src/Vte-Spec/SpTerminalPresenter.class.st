Class {
	#name : #SpTerminalPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'scrollBar',
		'box',
		'terminal'
	],
	#category : #'Vte-Spec'
}

{ #category : #accessing }
SpTerminalPresenter >> feed: aString [

	GtkRunLoop defer: [ 
		terminal feed: aString ]
]

{ #category : #initialization }
SpTerminalPresenter >> initializePresenters [

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
