"
I am an enumeration of the exit codes used by Unix shells and exec conventions, such as 127 for command not found.

I am used by VteExitStatus to describe the outcome of a child process managed by a VteTerminal.
"
Class {
	#name : 'VteExitCode',
	#superclass : 'GEnumeration',
	#classVars : [
		'COMMAND_NOT_FOUND',
		'GENERAL_ERROR',
		'INTERRUPTED',
		'INVALID_EXIT_CODE',
		'INVALID_USAGE',
		'KILLED',
		'NOT_EXECUTABLE',
		'SUCCESS',
		'TERMINATED'
	],
	#category : 'Vte-Spec-Status',
	#package : 'Vte-Spec',
	#tag : 'Status'
}

{ #category : 'accessing' }
VteExitCode class >> descriptions [
	"Answer the human readable meaning of each named exit code."

	^ Dictionary new
		  at: #SUCCESS 				put: 'success';
		  at: #GENERAL_ERROR 		put: 'general error';
		  at: #INVALID_USAGE 		put: 'invalid usage / invalid arguments';
		  at: #NOT_EXECUTABLE 		put: 'command found but not executable';
		  at: #COMMAND_NOT_FOUND 	put: 'command not found';
		  at: #INVALID_EXIT_CODE 	put: 'invalid exit status';
		  at: #INTERRUPTED 			put: 'interrupted';
		  at: #KILLED 				put: 'killed';
		  at: #TERMINATED 			put: 'terminated';
		  yourself
]

{ #category : 'enum declaration' }
VteExitCode class >> enumDecl [
	"Named exit codes following Unix shell and exec conventions."
	"self initializeEnumeration"

	^ #( 
		SUCCESS 				0 
		GENERAL_ERROR 			1 
		INVALID_USAGE 			2 
		NOT_EXECUTABLE 			126 
		COMMAND_NOT_FOUND 		127 
		INVALID_EXIT_CODE 		128 
		INTERRUPTED 			130 
		KILLED 					137 
		TERMINATED 				143
	)
]

{ #category : 'accessing' }
VteExitCode >> description [
	"Answer the human readable meaning of the receiver, or nil when the code has no well known meaning."

	^ self class descriptions at: self item ifAbsent: [ nil ]
]
