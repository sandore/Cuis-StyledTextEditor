'From Cuis 4.0 of 3 April 2012 [latest update: #1260] on 17 April 2012 at 11:21:05 pm'!
'Description Please enter a description for this package.'!
!classDefinition: #CrappyUnixOSProcess category: #CrappyOSProcess!
Object subclass: #CrappyUnixOSProcess
	instanceVariableNames: 'programName arguments pid pwd runState exitStatus'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CrappyOSProcess'!
!classDefinition: 'CrappyUnixOSProcess class' category: #CrappyOSProcess!
CrappyUnixOSProcess class
	instanceVariableNames: ''!


!CrappyUnixOSProcess commentStamp: '<historical>' prior: 0!
A simple and crappy replacement for ExternaUnixOSProcess et al.
CrappyUnixOSProcess command: 'open http://www.jvuletich.org'!

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 12/4/2009 15:58'!
argsAsFlatArrayAndOffsets: anArrayOfNullTerminatedStrings
	"Given anArrayOfNullTerminatedStrings, flatten the array into a string buffer,
	leaving space at the beginning of the buffer for a list of C pointers. Answer
	the string buffer and an array of address offsets. The address offsets may later
	be converted to C pointers and overlaid on the beginning of the buffer, resulting
	in a data structure which can be treated as a C array of strings suitable for
	use as a Unix argv vector."

	"OSProcess thisOSProcess argsAsFlatArrayAndOffsets:
		(UnixProcess arguments collect:
			[:e | e, (Character value: 0) asString])"

	| offset arraySize flatStringArray ws addresses |
	"Preserve offset space to hold address pointers."
	offset := (anArrayOfNullTerminatedStrings size + 1) * self sizeOfPointer.
	"Allocate flat strings buffer"
	arraySize := (anArrayOfNullTerminatedStrings collect: [:e | e size]) sum
		+ ((anArrayOfNullTerminatedStrings size + 1) * self sizeOfPointer).
	"Flatten the strings out into a buffer, leaving room at the
	beginning of the buffer for an array of addresses."
	flatStringArray := String new: arraySize.
	ws := WriteStream on: flatStringArray.
	offset timesRepeat: [ws nextPut: (Character value: 0)].
	anArrayOfNullTerminatedStrings do: [:e | ws nextPutAll: e].
	"Find address offsets to be used in creating the addresses for the strings."
	ws := WriteStream on: (Array new: anArrayOfNullTerminatedStrings size).
	(anArrayOfNullTerminatedStrings collect: [:e | e size])
		inject: offset into: [:p :e | ws nextPut: p. p + e].
	addresses := ws contents.
	"Results"
	^ Array with: flatStringArray with: addresses
! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 12/4/2009 15:34'!
arguments: arrayOfArgumentStrings

	arguments := arrayOfArgumentStrings! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 3/23/2010 11:27'!
execAndWait
	"Start the external OS process. All instances variables except for pid  
	should have been set. The pid will be set following creation of the new 
	external process."

	| d |
	self
		forkAndExec: programName
		arguments: arguments.
	d _ Delay forMilliseconds: 40.
	[ runState == #running ] whileTrue: [
		"Has the process exited?"
		(self primGetChildExitStatus: pid) ifNotNil: [ :statusArray |
			exitStatus _ (statusArray at: 2).
			runState _ #complete ].
		d wait.
	]! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 3/23/2010 11:03'!
forkAndExec: executableFile arguments: arrayOfStrings
	"Call Unix vfork() and execve() to create a child process, and answer the child process.
	This method is expected to be called by class side methods. Prepare the arguments before
	calling the primitive, including null termination of all strings. anExternalProcess is an
	object which represents the new child process, and which responds to the #pxid: message."

	| nullString progName args argVecAndOffsets argVec argOffsets
	 envVec envOffsets in out err |
	nullString := (Character value: 0) asString.
	progName := executableFile, nullString.		"Null terminated string"
	arrayOfStrings isNil							"Should be a (possibly empty) array"
		ifTrue:
			[args := Array with: progName]		"First argument is the program name (Unix convention)"
		ifFalse:
			[args := (OrderedCollection new: arrayOfStrings size + 2)
						add: progName;
						addAll: (arrayOfStrings collect: [:e | e, nullString ]);	"Null terminate each string"
						yourself;
						asArray].
	argVecAndOffsets := self argsAsFlatArrayAndOffsets: args.
	argVec := argVecAndOffsets at: 1.
	argOffsets := argVecAndOffsets at: 2.
	envVec := nil.
	envOffsets := nil.	"Same as current environment, so just pass nil."
	in := nil.
	out := nil.
	err := nil.
	pid := self
				forkAndExec: progName
				stdIn: in
				stdOut: out
				stdErr: err
				argBuf: argVec
				argOffsets: argOffsets
				envBuf: envVec
				envOffsets: envOffsets
				workingDir: self pwd, nullString.
	runState _ (pid isNil or: [pid = 0])
		ifTrue: [#unknownRunState]
		ifFalse: [#running].
	^ self! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 12/4/2009 15:57'!
forkAndExec: executableFile
	stdIn: inputFileHandle
	stdOut: outputFileHandle
	stdErr: errorFileHandle
	argBuf: argVec
	argOffsets: argOffsets
	envBuf: envVec
	envOffsets: envOffsets
	workingDir: pathString

	"Parameters are expected to have been properly prepared by the caller, including string
	values which are to be null terminated strings. In other words, all strings should have
	(Character value: 0) as the last element in the string.

	Parameters should be:
		executableFile: a string with the name of a file to execute.
		stdIn: a fileID ByteArray (struct SQFile in C) to be used as standard input.
		stdOut: a fileID ByteArray to be used as standard output.
		stdErr: a fileID ByteArray to be used as standard error.
		argVec: a String arranged to look more or less like a char **, but with the addresses not yet fixed.
		argOffsets: an Array of offsets for fixing up the argVec addresses.
		envVec: a String arranged to look more or less like a char **, but with the addresses not yet fixed.
		envOffsets: an Array of offsets for fixing up the envVec addresses.
		workingDir: a null terminated path name String, or nil.
	The envVec parameter may be nil, in which case envOffsets is ignored. workingDir may be nil. The
	other parameters are required. Parameters with nil value indicate that current values for this process
	should be used."

	^ self primForkExec: executableFile
			stdIn: inputFileHandle
			stdOut: outputFileHandle
			stdErr: errorFileHandle
			argBuf: argVec
			argOffsets: argOffsets
			envBuf: envVec
			envOffsets: envOffsets
			workingDir: pathString
! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 3/23/2010 12:03'!
forkAndForget
	"Start the external OS process. All instances variables except for pid  
	should have been set. The pid will be set following creation of the new 
	external process.
	Do not wait for the for the forked unix process to finish.
	There is currently no means for the unix process to finish properly unless squeak exits
	Use with care, and only for never-ending loops"

	^ self
		forkAndExec: programName
		arguments: arguments
! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 12/14/2009 11:35'!
primForkExec: executableFile
	stdIn: inputFileHandle
	stdOut: outputFileHandle
	stdErr: errorFileHandle
	argBuf: argVec
	argOffsets: argOffsets
	envBuf: envVec
	envOffsets: envOffsets
	workingDir: pathString

	"Parameters are expected to have been properly prepared by the caller, including string
	values which are to be null terminated strings. In other words, all strings should have
	(Character value: 0) as the last element in the string.

	Parameters should be:
		executableFile: a string with the name of a file to execute.
		stdIn: a fileID ByteArray (struct SQFile in C) to be used as standard input.
		stdOut: a fileID ByteArray to be used as standard output.
		stdErr: a fileID ByteArray to be used as standard error.
		argVec: a String arranged to look more or less like a char **, but with the addresses not yet fixed.
		argOffsets: an Array of offsets for fixing up the argVec addresses.
		envVec: a String arranged to look more or less like a char **, but with the addresses not yet fixed.
		envOffsets: an Array of offsets for fixing up the envVec addresses.
		workingDir: a null terminated path name String, or nil.
	The envVec parameter may be nil, in which case envOffsets is ignored. workingDir may be nil. The
	other parameters are required. Parameters with nil value indicate that current values for this process
	should be used."

	<primitive: 'primitiveForkExec' module: 'UnixOSProcessPlugin'>

	"On failure, try the older deprecated version. First tell the plugin what semaphore to use."
	"self primSetSemaIndex: (Smalltalk externalObjects indexOf: OSProcess accessor sigChldSemaphore).
	^ self primForkAndExec: executableFile
		stdIn: inputFileHandle
		stdOut: outputFileHandle
		stdErr: errorFileHandle
		argBuf: argVec
		argOffsets: argOffsets
		envBuf: envVec
		envOffsets: envOffsets
		workingDir: pathString"! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 3/23/2010 10:55'!
primGetChildExitStatus: childPid
	"Clean up after the death of a child process, and answer the exit status of the child process."

	<primitive: 'primitiveReapChildProcess' module: 'UnixOSProcessPlugin'>
	^ Array with: childPid with: nil! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 12/4/2009 16:08'!
primGetCurrentWorkingDirectory
	"Call getcwd() to get the current working directory."

	"OSProcess thisOSProcess processAccessor primGetCurrentWorkingDirectory"

	<primitive: 'primitiveGetCurrentWorkingDirectory' module: 'UnixOSProcessPlugin'>
	^ nil
! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 12/4/2009 15:46'!
primSizeOfPointer
	"Size of a void pointer for this C compiler on this machine."

	<primitive: 'primitiveSizeOfPointer' module: 'UnixOSProcessPlugin'>
	^ self primitiveFailed
! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 12/4/2009 15:34'!
programName: fileName

	programName := fileName! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 12/4/2009 16:09'!
pwd

	pwd ifNil: [pwd := self primGetCurrentWorkingDirectory].
	^ pwd! !

!CrappyUnixOSProcess methodsFor: 'as yet unclassified' stamp: 'jmv 12/4/2009 15:46'!
sizeOfPointer
	"Size of a void pointer on this machine with this C compiler."

	^ self primSizeOfPointer! !

!CrappyUnixOSProcess class methodsFor: 'as yet unclassified' stamp: 'jmv 3/23/2010 11:16'!
command: aCommandString

	"CrappyUnixOSProcess command: 'ls -l /etc'"

	^ self
		execAndWait: self defaultShellPath
		arguments: (Array with: '-c' with: aCommandString)! !

!CrappyUnixOSProcess class methodsFor: 'as yet unclassified' stamp: 'jmv 6/24/2010 10:46'!
commandResult: aCommandString
	"
	Run the command and answer the result

	CrappyUnixOSProcess commandResult: 'ls -l /etc'
	"

	| r tmpName result directory |
	r _ Random new.
	tmpName _ nil.
	[ tmpName isNil or: [StandardFileStream isAFileNamed: tmpName] ] whileTrue: [
		tmpName _ FileDirectory default fullNameFor: 'tmp', (r next * 1000000) truncated printString, '.txt' ].

	self command: (aCommandString, ' > "', tmpName, '"').

	(StandardFileStream isAFileNamed: tmpName) ifFalse: [
		^ nil ].

	[
		result _ (StandardFileStream readOnlyFileNamed: tmpName) contentsOfEntireFile.
	] ensure: [
		directory _ FileDirectory default.
		directory deleteFileNamed: tmpName ].

	^result! !

!CrappyUnixOSProcess class methodsFor: 'as yet unclassified' stamp: 'jmv 12/4/2009 15:33'!
defaultShellPath
	"Default shell to run"

	| path |
	path := '/bin/sh'.
	(FileDirectory default fileExists: path)
		ifTrue: [^ path]
		ifFalse: [self notify: path, ' not found']! !

!CrappyUnixOSProcess class methodsFor: 'as yet unclassified' stamp: 'jmv 3/23/2010 11:17'!
execAndWait: executableFile arguments: arrayOfStrings
	"Run a program in an external OS process, and answer an instance of 
	myself which represents the external process.
	Run and wait for execution end."

	"ExternalUnixOSProcess execAndWait: '/bin/ls' arguments: (Array with: '-l') environment: (UnixProcess env)"

	^ self new
		programName: executableFile;
		arguments: arrayOfStrings;
		initialize;
		execAndWait
! !

!CrappyUnixOSProcess class methodsFor: 'as yet unclassified' stamp: 'jmv 3/23/2010 12:04'!
forkAndForget: executableFile arguments: arrayOfStrings
	"Run a program in an external OS process, and answer an instance of 
	myself which represents the external process.
	
	Do not wait for the for the forked unix process to finish.
	There is currently no means for the unix process to finish properly unless squeak exits
	Use with care, and only for never-ending loops"

	"ExternalUnixOSProcess forkAndExec: '/bin/ls' arguments: (Array with: '-l') environment: (UnixProcess env)"

	^ self new
		programName: executableFile;
		arguments: arrayOfStrings;
		initialize;
		forkAndForget
! !

!CrappyUnixOSProcess class methodsFor: 'as yet unclassified' stamp: 'jmv 3/23/2010 12:05'!
forkAndForgetCommand: aCommandString
"
	Do not wait for the for the forked unix process to finish.
	There is currently no means for the unix process to finish properly unless squeak exits
	Use with care, and only for never-ending loops"
	
	"CrappyUnixOSProcess command: 'ls -l /etc'"

	^ self
		forkAndForget: self defaultShellPath
		arguments: (Array with: '-c' with: aCommandString)! !
