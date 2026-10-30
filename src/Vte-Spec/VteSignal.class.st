"
I am an enumeration of the POSIX signal numbers that are identical on Linux and macOS.

I am used by VteExitStatus to describe a child process terminated by a signal. Signals whose numbers differ between platforms (for example SIGUSR1 or SIGCHLD) are intentionally not enumerated.
"
Class {
	#name : 'VteSignal',
	#superclass : 'GEnumeration',
	#classVars : [
		'SIGABRT',
		'SIGALRM',
		'SIGFPE',
		'SIGHUP',
		'SIGILL',
		'SIGINT',
		'SIGKILL',
		'SIGPIPE',
		'SIGQUIT',
		'SIGSEGV',
		'SIGTERM',
		'SIGTRAP'
	],
	#category : 'Vte-Spec-Status',
	#package : 'Vte-Spec',
	#tag : 'Status'
}

{ #category : 'accessing' }
VteSignal class >> descriptions [
	"Answer the human readable meaning of each named signal."

	^ Dictionary new
		  at: #SIGHUP 		put: 'hangup';
		  at: #SIGINT 		put: 'interrupted';
		  at: #SIGQUIT 		put: 'quit';
		  at: #SIGILL 		put: 'illegal instruction';
		  at: #SIGTRAP 		put: 'trap';
		  at: #SIGABRT 		put: 'aborted';
		  at: #SIGFPE 		put: 'floating point error';
		  at: #SIGKILL 		put: 'killed';
		  at: #SIGSEGV 		put: 'segmentation fault';
		  at: #SIGPIPE 		put: 'broken pipe';
		  at: #SIGALRM 		put: 'alarm';
		  at: #SIGTERM 		put: 'terminated';
		  yourself
]

{ #category : 'enum declaration' }
VteSignal class >> enumDecl [
	"POSIX signals whose numbers are identical on Linux and macOS."
	"self initializeEnumeration"

	^ #( 
		SIGHUP 		1 
		SIGINT 		2
		SIGQUIT 	3 
		SIGILL 		4 
		SIGTRAP 	5 
		SIGABRT 	6 
		SIGFPE 		8 
		SIGKILL 	9 
		SIGSEGV 	11 
		SIGPIPE 	13 
		SIGALRM 	14 
		SIGTERM 	15
	)
]

{ #category : 'initialization' }
VteSignal class >> initialize [
	"Build the enumeration values declared in enumDecl."

	self initializeEnumeration
]

{ #category : 'initialization' }
VteSignal class >> initializeIfNeeded [

	(self classPool includesKey: #SIGHUP) ifFalse: [ self initialize ]
]

{ #category : 'accessing' }
VteSignal >> description [
	"Answer the human readable meaning of the receiver, or nil when the signal has no well known meaning."

	^ self class descriptions 
		at: self item 
		ifAbsent: [ nil ]
]
