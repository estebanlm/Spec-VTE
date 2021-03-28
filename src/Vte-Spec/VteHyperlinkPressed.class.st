Class {
	#name : #VteHyperlinkPressed,
	#superclass : #Announcement,
	#instVars : [
		'link'
	],
	#category : #'Vte-Spec-Decorations'
}

{ #category : #'instance creation' }
VteHyperlinkPressed class >> newLink: aString [

	^ self new 
		link: aString;
		yourself
]

{ #category : #accessing }
VteHyperlinkPressed >> link [

	^ link
]

{ #category : #accessing }
VteHyperlinkPressed >> link: anObject [

	link := anObject
]
