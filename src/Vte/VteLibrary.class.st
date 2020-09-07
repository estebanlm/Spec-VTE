Class {
	#name : #VteLibrary,
	#superclass : #FFILibrary,
	#category : #Vte
}

{ #category : #'accessing platform' }
VteLibrary >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libvte-2.91.so'
]
