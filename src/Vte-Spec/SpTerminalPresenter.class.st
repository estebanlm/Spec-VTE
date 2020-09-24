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
