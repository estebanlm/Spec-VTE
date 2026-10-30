"
I wrap the raw wait status reported by VTE's child-exited signal and decode it as waitpid() does.

The low seven bits hold the terminating signal (when non-zero), otherwise the upper bits hold the exit code. My description answers a human readable text suitable for warnings, for example 'exited with code 127 (command not found)'.

My exitCode answers a VteExitCode; send #value to it for the integer code. Signaled children answer the shell convention code 128 + signal number, so exitCode is nil only when the raw status is unknown.

Use VteExitStatus fromStatus: to create me.
"
Class {
	#name : 'VteExitStatus',
	#superclass : 'Object',
	#instVars : [
		'rawStatus'
	],
	#category : 'Vte-Spec-Status',
	#package : 'Vte-Spec',
	#tag : 'Status'
}

{ #category : 'instance creation' }
VteExitStatus class >> fromStatus: aStatus [
	"Create a status from the raw wait status reported by VTE's child-exited signal."

	^ self new
		  rawStatus: aStatus;
		  yourself
]

{ #category : 'printing' }
VteExitStatus >> description [

	self rawStatus ifNil: [ 
		^ 'unknown exit status' ].
	
	self isSignaled ifTrue: [
		^ 'terminated by signal {1} ({2})' format: { self signalNumber. self signalName } ].

	^ self exitCodeDescription
		ifNotNil: [ :text | 'exited with code {1} ({2})' format: { self exitCode value. text } ]
		ifNil: [ 'exited with code {1}' format: { self exitCode value } ]
]

{ #category : 'accessing' }
VteExitStatus >> exitCode [
	"Answer the exit code of the child as a VteExitCode.
	When the child was terminated by a signal, answer the shell convention code (128 + signal number)."

	self rawStatus ifNil: [ ^ nil ].
	self isSignaled ifTrue: [ ^ VteExitCode fromInteger: 128 + self signalNumber ].
	^ VteExitCode fromInteger: self rawStatus >> 8
]

{ #category : 'accessing' }
VteExitStatus >> exitCodeDescription [

	^ self exitCode ifNotNil: [ :code | code description ]
]

{ #category : 'testing' }
VteExitStatus >> isInterrupted [
	"Answer whether the child was interrupted by the user (SIGINT)."

	^ self signal = (VteSignal fromInteger: 2)
]

{ #category : 'testing' }
VteExitStatus >> isSignaled [

	  self rawStatus ifNil: [ ^ false ].
	  ^ (self rawStatus bitAnd: 16r7F) ~= 0
]

{ #category : 'testing' }
VteExitStatus >> isSuccess [

	^ self rawStatus = 0
]

{ #category : 'printing' }
VteExitStatus >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self description;
		nextPut: $)
]

{ #category : 'accessing' }
VteExitStatus >> rawStatus [

	^ rawStatus
]

{ #category : 'accessing' }
VteExitStatus >> rawStatus: anInteger [

	rawStatus := anInteger
]

{ #category : 'accessing' }
VteExitStatus >> signal [

	^ self signalNumber ifNil: [ nil ] ifNotNil: [ :number | VteSignal fromInteger: number ]
]

{ #category : 'accessing' }
VteExitStatus >> signalName [

	| signal |
	signal := self signal.
	signal ifNil: [ ^ nil ].
	^ signal item ifNil: [ 'signal {1}' format: { self signalNumber } ] ifNotNil: [ :name | name asString ]
]

{ #category : 'accessing' }
VteExitStatus >> signalNumber [

	self isSignaled ifFalse: [ ^ nil ].
	^ self rawStatus bitAnd: 16r7F
]
