Class {
	#name : 'VteChildExited',
	#superclass : 'Announcement',
	#instVars : [
		'status'
	],
	#category : 'Vte-Spec-Widgets',
	#package : 'Vte-Spec',
	#tag : 'Widgets'
}

{ #category : 'instance creation' }
VteChildExited class >> newStatus: aStatus [

	^ self new 
		status: aStatus;
		yourself
]

{ #category : 'accessing' }
VteChildExited >> status [

	^ status
]

{ #category : 'initialization' }
VteChildExited >> status: aStatus [

	status := aStatus
]
