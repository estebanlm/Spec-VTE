Class {
	#name : #VteLibrary,
	#superclass : #FFILibrary,
	#category : #Vte
}

{ #category : #'accessing platform' }
VteLibrary >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findAnyLibrary: #(
		'libvte-2.91.so' 
		'libvte-2.91.so.0')
]
