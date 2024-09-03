Class {
	#name : 'VteLibrary',
	#superclass : 'FFILibrary',
	#category : 'Vte',
	#package : 'Vte'
}

{ #category : 'accessing platform' }
VteLibrary >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libvte-2.91-gtk4.so'
]
