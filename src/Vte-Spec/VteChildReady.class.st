Class {
	#name : 'VteChildReady',
	#superclass : 'Announcement',
	#instVars : [
		'program'
	],
	#category : 'Vte-Spec-Widgets',
	#package : 'Vte-Spec',
	#tag : 'Widgets'
}

{ #category : 'instance creation' }
VteChildReady class >> on: aProgram [

	^ self new program: aProgram
]

{ #category : 'accessing' }
VteChildReady >> program [

	^ program
]

{ #category : 'initialization' }
VteChildReady >> program: aProgram [

	program := aProgram
]
