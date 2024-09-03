Class {
	#name : 'VtePtyFlags',
	#superclass : 'GEnumeration',
	#classVars : [
		'VTE_PTY_DEFAULT',
		'VTE_PTY_NO_CTTY',
		'VTE_PTY_NO_FALLBACK',
		'VTE_PTY_NO_HELPER',
		'VTE_PTY_NO_LASTLOG',
		'VTE_PTY_NO_SESSION',
		'VTE_PTY_NO_UTMP',
		'VTE_PTY_NO_WTMP'
	],
	#category : 'Vte',
	#package : 'Vte'
}

{ #category : 'accessing enum' }
VtePtyFlags class >> VTE_PTY_DEFAULT [
	"This method was automatically generated"
	^ VTE_PTY_DEFAULT
]

{ #category : 'accessing enum' }
VtePtyFlags class >> VTE_PTY_NO_CTTY [
	"This method was automatically generated"
	^ VTE_PTY_NO_CTTY
]

{ #category : 'accessing enum' }
VtePtyFlags class >> VTE_PTY_NO_FALLBACK [
	"This method was automatically generated"
	^ VTE_PTY_NO_FALLBACK
]

{ #category : 'accessing enum' }
VtePtyFlags class >> VTE_PTY_NO_HELPER [
	"This method was automatically generated"
	^ VTE_PTY_NO_HELPER
]

{ #category : 'accessing enum' }
VtePtyFlags class >> VTE_PTY_NO_LASTLOG [
	"This method was automatically generated"
	^ VTE_PTY_NO_LASTLOG
]

{ #category : 'accessing enum' }
VtePtyFlags class >> VTE_PTY_NO_SESSION [
	"This method was automatically generated"
	^ VTE_PTY_NO_SESSION
]

{ #category : 'accessing enum' }
VtePtyFlags class >> VTE_PTY_NO_UTMP [
	"This method was automatically generated"
	^ VTE_PTY_NO_UTMP
]

{ #category : 'accessing enum' }
VtePtyFlags class >> VTE_PTY_NO_WTMP [
	"This method was automatically generated"
	^ VTE_PTY_NO_WTMP
]

{ #category : 'enum declaration' }
VtePtyFlags class >> enumDecl [
	"
	self initializeEnumeration.
	self rebuildEnumAccessors 
	"

	^ { 
		#VTE_PTY_NO_LASTLOG. 		1 << 0.
		#VTE_PTY_NO_UTMP. 			1 << 1.
		#VTE_PTY_NO_WTMP. 			1 << 2.
		#VTE_PTY_NO_HELPER. 		1 << 3.
		#VTE_PTY_NO_FALLBACK. 	1 << 4.
		#VTE_PTY_NO_SESSION. 		1 << 5.
		#VTE_PTY_NO_CTTY. 			1 << 6.
		#VTE_PTY_DEFAULT. 			0	
	 }
]
