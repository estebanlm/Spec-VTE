Extension { #name : 'GdkKeyEvent' }

{ #category : '*Vte' }
GdkKeyEvent >> hasNotModifierPatched [

	^ self hasAnyModifier not 
		or: [ 
			(self state = GdkModifierType GDK_MOD2_MASK value
			and: [ OSPlatform current isUnix ]) ]
]
