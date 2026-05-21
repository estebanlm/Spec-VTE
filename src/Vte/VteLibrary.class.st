Class {
	#name : 'VteLibrary',
	#superclass : 'FFILibrary',
	#category : 'Vte',
	#package : 'Vte'
}

{ #category : 'accessing platform' }
VteLibrary >> macLibraryName [

	^ FFIMacLibraryFinder findLibrary: 'libvte-2.91-gtk4.0.dylib'
]

{ #category : 'accessing platform' }
VteLibrary >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libvte-2.91-gtk4.so'
]

{ #category : 'accessing platform' }
VteLibrary >> win32LibraryName [

	self error: 'This library is not available on Windows' 
]
