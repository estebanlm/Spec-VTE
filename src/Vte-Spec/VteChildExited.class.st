"
I am announced when the child process of a VteTerminal exits.

My status is the raw wait status returned by waitpid(), where the low seven bits hold the terminating signal and the upper bits hold the exit code. Use my decoded accessors instead of interpreting status directly: exitStatus answers a VteExitStatus, exitCode answers a VteExitCode (send #value for the integer code), and signalNumber answers the terminating signal.
"
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
VteChildExited >> exitCode [
	"Answer the exit code as a VteExitCode. Signaled children answer the shell convention code (128 + signal number)."

	^ self exitStatus exitCode
]

{ #category : 'accessing' }
VteChildExited >> exitStatus [

	^ VteExitStatus fromStatus: status
]

{ #category : 'testing' }
VteChildExited >> isSuccess [

	^ self exitStatus isSuccess
]

{ #category : 'accessing' }
VteChildExited >> signalNumber [

	  ^ self exitStatus signalNumber
]

{ #category : 'accessing' }
VteChildExited >> status [

	^ status
]

{ #category : 'initialization' }
VteChildExited >> status: aStatus [

	status := aStatus
]
