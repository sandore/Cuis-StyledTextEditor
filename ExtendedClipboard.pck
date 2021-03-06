'From Cuis 4.0 of 3 April 2012 [latest update: #1260] on 17 April 2012 at 11:21:08 pm'!
'Description Please enter a description for this package.'!
!classDefinition: #ExtendedClipboardInterface category: #ExtendedClipboard!
Object subclass: #ExtendedClipboardInterface
	instanceVariableNames: 'clipboard'
	classVariableNames: 'Current WinClipboardTypes'
	poolDictionaries: ''
	category: 'ExtendedClipboard'!
!classDefinition: 'ExtendedClipboardInterface class' category: #ExtendedClipboard!
ExtendedClipboardInterface class
	instanceVariableNames: ''!

!classDefinition: #ExtendedClipboardMacInterface category: #ExtendedClipboard!
ExtendedClipboardInterface subclass: #ExtendedClipboardMacInterface
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ExtendedClipboard'!
!classDefinition: 'ExtendedClipboardMacInterface class' category: #ExtendedClipboard!
ExtendedClipboardMacInterface class
	instanceVariableNames: ''!

!classDefinition: #ExtendedClipboardTest category: #'ExtendedClipboard-tests'!
TestCase subclass: #ExtendedClipboardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ExtendedClipboard-tests'!
!classDefinition: 'ExtendedClipboardTest class' category: #'ExtendedClipboard-tests'!
ExtendedClipboardTest class
	instanceVariableNames: ''!

!classDefinition: #ExtendedClipboardUnixInterface category: #ExtendedClipboard!
ExtendedClipboardInterface subclass: #ExtendedClipboardUnixInterface
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ExtendedClipboard'!
!classDefinition: 'ExtendedClipboardUnixInterface class' category: #ExtendedClipboard!
ExtendedClipboardUnixInterface class
	instanceVariableNames: ''!

!classDefinition: #ExtendedClipboardWinInterface category: #ExtendedClipboard!
ExtendedClipboardInterface subclass: #ExtendedClipboardWinInterface
	instanceVariableNames: 'lastSeenSequenceNr'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ExtendedClipboard'!
!classDefinition: 'ExtendedClipboardWinInterface class' category: #ExtendedClipboard!
ExtendedClipboardWinInterface class
	instanceVariableNames: ''!

!classDefinition: #Win32Bitmap category: #'ExtendedClipboard-Win32'!
ExternalStructure subclass: #Win32Bitmap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ExtendedClipboard-Win32'!
!classDefinition: 'Win32Bitmap class' category: #'ExtendedClipboard-Win32'!
Win32Bitmap class
	instanceVariableNames: ''!


!ExtendedClipboardInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 23:45'!
addClipboardData: data dataFormat: aFormat
	clipboard = 0 ifTrue: [
		"Should never happen!!"
		self error: 'broken clipboard'.
		^self].
	self primAddClipboardData: clipboard data: data dataFormat: aFormat! !

!ExtendedClipboardInterface methodsFor: 'testing' stamp: 'jmv 1/18/2011 23:44'!
canStore
	"Store into clipboard implemented on most platforms.
	Answer false in subclasses that can't store into clipboard."
	^clipboard ~= 0! !

!ExtendedClipboardInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 14:47'!
clearClipboard
	clipboard = 0 ifTrue: [^self].
	^ self primClearClipboard: clipboard! !

!ExtendedClipboardInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 14:47'!
createClipboard
	clipboard = 0 ifTrue: [^self].
	^ self primCreateClipboard! !

!ExtendedClipboardInterface methodsFor: 'object from raw data' stamp: 'jmv 1/26/2011 10:26'!
fromBMPBytes: bytes
	^ (BMPReadWriter on: bytes readStream) nextImage! !

!ExtendedClipboardInterface methodsFor: 'object from raw data' stamp: 'jmv 1/26/2011 10:24'!
fromJPEGBytes: bytes
	^ (JPEGReadWriter2 on: bytes readStream) nextImage! !

!ExtendedClipboardInterface methodsFor: 'object from raw data' stamp: 'jmv 1/26/2011 10:25'!
fromMacRomanBytes: bytes
	^ (bytes collect: [ :c | Character macRomanToLatin1: c]) asString! !

!ExtendedClipboardInterface methodsFor: 'object from raw data' stamp: 'jmv 1/26/2011 10:24'!
fromPNGBytes: bytes
	^ (PNGReadWriter on: bytes readStream) nextImage! !

!ExtendedClipboardInterface methodsFor: 'object from raw data' stamp: 'jmv 4/11/2011 18:10'!
fromRTFBytes: bytes
	| parser builder |
	builder _ RTFTextBuilder currentClass new.
	parser _ RTFParser new.
	parser
		parseWithTokenizer: (RTFTokenizer newFromString: bytes asString)
		buildWith: builder.
	^builder text! !

!ExtendedClipboardInterface methodsFor: 'object from raw data' stamp: 'jmv 3/17/2011 09:23'!
fromRefStreamBytes: bytes
	^ ReferenceStream unStream: bytes! !

!ExtendedClipboardInterface methodsFor: 'object from raw data' stamp: 'jmv 1/26/2011 10:24'!
fromTIFFBytes: bytes
	^ (TIFFReadWriter on: bytes readStream) nextImage! !

!ExtendedClipboardInterface methodsFor: 'object from raw data' stamp: 'jmv 3/13/2012 16:23'!
fromUTF8Bytes: bytes
	^ bytes asString utf8ToISO8859s15 withCuisLineEndings! !

!ExtendedClipboardInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 14:47'!
getClipboardFormat: formatNumber
	clipboard = 0 ifTrue: [^nil].
	^ self primGetClipboardFormat: clipboard formatNumber: formatNumber! !

!ExtendedClipboardInterface methodsFor: 'initialize-release' stamp: 'tak 5/16/2007 12:03'!
initialize
	clipboard := [self createClipboard] on: Error do: [:ex | clipboard := 0]! !

!ExtendedClipboardInterface methodsFor: 'system primitives' stamp: 'JSM 5/6/2006 16:32'!
primAddClipboardData: clipboard data: data dataFormat: aFormat

	<primitive:'ioAddClipboardData' module: 'ClipboardExtendedPlugin'>
	^ self primitiveFailed.! !

!ExtendedClipboardInterface methodsFor: 'system primitives' stamp: 'JSM 5/6/2006 16:32'!
primClearClipboard: clipboard

	<primitive:'ioClearClipboard' module: 'ClipboardExtendedPlugin'>
	^ self primitiveFailed.
! !

!ExtendedClipboardInterface methodsFor: 'system primitives' stamp: 'JSM 5/6/2006 18:53'!
primCreateClipboard
	<primitive:'ioCreateClipboard' module: 'ClipboardExtendedPlugin'>
	^ self primitiveFailed.
! !

!ExtendedClipboardInterface methodsFor: 'system primitives' stamp: 'JSM 5/6/2006 16:33'!
primGetClipboardFormat: clipboard formatNumber: formatNumber

	<primitive:'ioGetClipboardFormat' module: 'ClipboardExtendedPlugin'>
	^ self primitiveFailed.
! !

!ExtendedClipboardInterface methodsFor: 'system primitives' stamp: 'JSM 5/6/2006 16:33'!
primReadClipboardData: clipboard format: format

	<primitive:'ioReadClipboardData' module: 'ClipboardExtendedPlugin'>.
	^ self primitiveFailed.
! !

!ExtendedClipboardInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 14:47'!
readClipboardData: format
	^clipboard = 0 ifFalse: [
		self primReadClipboardData: clipboard format: format ]! !

!ExtendedClipboardInterface methodsFor: 'api - retrieve' stamp: 'jmv 1/19/2011 15:17'!
retrieveId
	^self subclassResponsibility! !

!ExtendedClipboardInterface methodsFor: 'api - retrieve' stamp: 'jmv 1/26/2011 10:09'!
retrieveObject
	^self subclassResponsibility! !

!ExtendedClipboardInterface methodsFor: 'api - store' stamp: 'jmv 1/26/2011 10:07'!
storeForm: aForm id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id at the end."
	^self subclassResponsibility! !

!ExtendedClipboardInterface methodsFor: 'api - store' stamp: 'jmv 1/26/2011 10:07'!
storeString: aString id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id at the end."
	^self subclassResponsibility! !

!ExtendedClipboardInterface methodsFor: 'api - store' stamp: 'jmv 3/17/2011 09:35'!
storeText: aText id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id is usually at the end, but don't include it if we include a streamed representation."

	^self subclassResponsibility! !

!ExtendedClipboardInterface class methodsFor: 'accessing' stamp: 'jmv 1/11/2011 13:59'!
current
	| platform |
	Current ifNil: [
		platform _ Smalltalk platformName.
		Current _ platform = 'unix'
			ifTrue: [ ExtendedClipboardUnixInterface new ]
			ifFalse: [
				platform = 'Win32'
					ifTrue: [ ExtendedClipboardWinInterface new ]
					ifFalse: [ ExtendedClipboardMacInterface new ]]].
	^ Current.! !

!ExtendedClipboardInterface class methodsFor: 'class initialization' stamp: 'mir 5/10/2006 19:12'!
initialize
	"ExtendedClipboardInterface initialize"
	Current := nil.
	Smalltalk
		addToStartUpList: self after: nil;
		addToShutDownList: self after: nil.! !

!ExtendedClipboardInterface class methodsFor: 'system startup' stamp: 'JSM 5/6/2006 15:33'!
shutDown: quitting
! !

!ExtendedClipboardInterface class methodsFor: 'system startup' stamp: 'JSM 5/6/2006 15:33'!
startUp: resuming
	"The image is either being newly started (resuming is true), or it's just been snapshotted"

	Current := nil.
	self current.! !

!ExtendedClipboardMacInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 15:56'!
readPrimAvailableFormats
	| i availableFormats formatData |
	availableFormats _ OrderedCollection new: 10.
	i _ 1.
	[
		formatData _ self getClipboardFormat: i.
		formatData notNil ] whileTrue: [
			availableFormats add: formatData.
			i _ i + 1 ].
	^ availableFormats! !

!ExtendedClipboardMacInterface methodsFor: 'api - retrieve' stamp: 'jmv 1/19/2011 14:55'!
retrieveId
	| bytes formats |
	formats _ self readPrimAvailableFormats.
	(formats includes: 'cuis-id')
		ifTrue: [
			bytes _ self readClipboardData: 'cuis-id'.
			^ bytes asString ].
	^ nil! !

!ExtendedClipboardMacInterface methodsFor: 'api - retrieve' stamp: 'jmv 3/29/2011 09:15'!
retrieveObject
	| conversion bytes |
	self readPrimAvailableFormats do: [ :format |
		conversion _ format caseOf: {
			"Unformatted plain text"
			[ 'public.utf8-plain-text' ] -> [ #fromUTF8Bytes: ].
			[ 'com.apple.traditional-mac-plain-text' ] -> [ #fromMacRomanBytes: ].
			"Bitmap images (not sure if all of them are actually used in this platform)"
			[ 'public.png' ] -> [ #fromPNGBytes: ].
			[ 'public.tiff' ] -> [ #fromTIFFBytes: ].
			[ 'public.jpeg' ] -> [ #fromJPEGBytes: ].
			[ 'public.bmp' ] -> [ #fromBMPBytes: ].
			[ 'cuis-refStreamed' ] -> [ #fromRefStreamBytes: ].
			"Rich text"
			[ 'public.rtf' ] -> [ #fromRTFBytes: ]
		} otherwise: [ nil ].
		conversion ifNotNil: [
			bytes _ self readClipboardData: format.
			^self perform: conversion with: bytes ]
		].
	^nil	"Could not read any of the available formats"! !

!ExtendedClipboardMacInterface methodsFor: 'api - store' stamp: 'jmv 1/26/2011 10:07'!
storeForm: aForm id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id at the end."
	self clearClipboard.
	self addClipboardData: (PNGReadWriter bytesFor: aForm) dataFormat: 'public.png'.
	"
	Could be done in addition...
	self addClipboardData: (JPEGReadWriter2 bytesFor: aForm) dataFormat: 'public.jpeg'
	"
	self addClipboardData: otherString dataFormat: 'cuis-id'! !

!ExtendedClipboardMacInterface methodsFor: 'api - store' stamp: 'jmv 3/14/2012 09:33'!
storeString: aString id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id at the end."
	self clearClipboard.
	self
		addClipboardData: aString iso8859s15ToUtf8
		dataFormat: 'public.utf8-plain-text'.
	"Could be done in addition (maybe with cr line ending?)
	self
		addClipboardData: (aString asByteArray collect: [ :c | Character latin1ToMacRoman: c ])
		dataFormat: 'com.apple.traditional-mac-plain-text'.
		"
	self addClipboardData: otherString dataFormat: 'cuis-id'! !

!ExtendedClipboardMacInterface methodsFor: 'api - store' stamp: 'jmv 3/14/2012 09:29'!
storeText: aText id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id is usually at the end, but don't include it if we include a streamed representation."
	self clearClipboard.

	"SmartRefStream handles class changes, but a little testing shows stuff is twice as big, and takes 20 times more time to generate"
	self addClipboardData: (ReferenceStream streamedRepresentationOf: aText) dataFormat: 'cuis-refStreamed'.

	"RTF format"
	self addClipboardData: aText rtfString dataFormat: 'public.rtf'.

	"Just the string"
	self
		addClipboardData: aText asString iso8859s15ToUtf8
		dataFormat: 'public.utf8-plain-text'.

	"If we store a streamed representation, don't store the id. In these cases, we prefer rebuilding the object, regardless of
	whether it is present in memory (because we stored it in the clipboard) or not (because some other Cuis image did it)"
	self addClipboardData: otherString dataFormat: 'cuis-id'! !

!ExtendedClipboardTest methodsFor: 'testing' stamp: 'jmv 3/14/2012 09:34'!
testSample1ToAndFromRTFClipboard
	"
	ExtendedClipboardTest new testSample1ToAndFromRTFClipboard
	"
	| text |
	text _ RTFConversionTest textSample1.

	"This will use a refStreamed object"
	Clipboard default storeObject: text.
	self assert:Clipboard default retrieveObject = text.

	"This will also test storing and retrieving RTF data from platform Clipboard, and RTF conversion"
	ExtendedClipboardInterface current
		clearClipboard;
		addClipboardData: text rtfString dataFormat: 'public.rtf'.
	self assert:Clipboard default retrieveObject = text.! !

!ExtendedClipboardTest methodsFor: 'testing' stamp: 'jmv 3/14/2012 09:35'!
testSample2ToAndFromRTFClipboard
	"
	ExtendedClipboardTest new testSample2ToAndFromRTFClipboard
	"
	| text |
	text _ RTFConversionTest textSample2.

	"This will use a refStreamed object"
	Clipboard default storeObject: text.
	self assert:Clipboard default retrieveObject = text.

	"This will also test storing and retrieving RTF data from platform Clipboard, and RTF conversion"
	ExtendedClipboardInterface current
		clearClipboard;
		addClipboardData: text rtfString dataFormat: 'public.rtf'.
	self assert:Clipboard default retrieveObject = text.! !

!ExtendedClipboardTest methodsFor: 'testing' stamp: 'jmv 3/14/2012 09:35'!
testSample3ToAndFromRTFClipboard
	"
	ExtendedClipboardTest new testSample3ToAndFromRTFClipboard
	"
	| text |
	text _ RTFConversionTest textSample3.

	"This will use a refStreamed object"
	Clipboard default storeObject: text.
	self assert:Clipboard default retrieveObject = text.

	"This will also test storing and retrieving RTF data from platform Clipboard, and RTF conversion"
	ExtendedClipboardInterface current
		clearClipboard;
		addClipboardData: text rtfString dataFormat: 'public.rtf'.
	self assert:Clipboard default retrieveObject = text.! !

!ExtendedClipboardTest methodsFor: 'testing' stamp: 'jmv 3/14/2012 09:35'!
testSample4ToAndFromRTFClipboard
	"
	ExtendedClipboardTest new testSample4ToAndFromRTFClipboard
	"
	| text |
	text _ RTFConversionTest textSample4.

	"This will use a refStreamed object"
	Clipboard default storeObject: text.
	self assert:Clipboard default retrieveObject = text.

	"This will also test storing and retrieving RTF data from platform Clipboard, and RTF conversion"
	ExtendedClipboardInterface current
		clearClipboard;
		addClipboardData: text rtfString dataFormat: 'public.rtf'.
	self assert:Clipboard default retrieveObject = text.! !

!ExtendedClipboardTest methodsFor: 'testing' stamp: 'jmv 3/14/2012 09:49'!
testSample5ToAndFromRTFClipboard
	"
	ExtendedClipboardTest new testSample5ToAndFromRTFClipboard
	"
	| text |
	text _ RTFConversionTest textSample5.

	"This will use a refStreamed object"
	Clipboard default storeObject: text.
	self assert:Clipboard default retrieveObject = text.

	"This will also test storing and retrieving RTF data from platform Clipboard, and RTF conversion"
	ExtendedClipboardInterface current
		clearClipboard;
		addClipboardData: text rtfString dataFormat: 'public.rtf'.
	self assert:Clipboard default retrieveObject = text.! !

!ExtendedClipboardTest methodsFor: 'testing' stamp: 'jmv 3/14/2012 09:49'!
testSample6ToAndFromRTFClipboard
	"
	ExtendedClipboardTest new testSample6ToAndFromRTFClipboard
	"
	| text |
	text _ RTFConversionTest textSample6.

	"This will use a refStreamed object"
	Clipboard default storeObject: text.
	self assert:Clipboard default retrieveObject = text.

	"This will also test storing and retrieving RTF data from platform Clipboard, and RTF conversion"
	self deny: text rtfString = '{\rtf
{\colortbl;}
Tom� ag�ita, �and�. �and�. \par �������߃�ݲެ�禵.\par ���������ϩ���ҭǦ��}'.
	self assert: text rtfString =  '{\rtf
{\colortbl;}
Tom\u225? ag\u252?ita, \u241?and\u250?. \u209?and\u250?. \par \u339?\u381?\u174?\u165?\u353?\u248?\u229?\u223?\u131?\u169?\u221?\u178?\u222?\u172?\u173?\u231?\u352?\u181?.\par \u338?\u381?\u174?\u193?\u353?\u216?\u197?\u205?\u206?\u207?\u169?\u211?\u212?\u222?\u210?\u173?\u199?\u352?\u208?\u194?}'.
	ExtendedClipboardInterface current
		clearClipboard;
		addClipboardData: text rtfString dataFormat: 'public.rtf'.
	self assert: Clipboard default retrieveObject = text.! !

!ExtendedClipboardTest methodsFor: 'testing' stamp: 'jmv 4/6/2011 14:29'!
testStar16BitToAndFromImageClipboard
	"
	ExtendedClipboardTest new testStar16BitToAndFromImageClipboard
	"
	| form form1 form2 |
	form _ (StarMorph new
		extent: 100@100;
		imageForm) asFormOfDepth: 16.

	"This will use a refStreamed object"
	Clipboard default storeObject: form.
	form2 _ Clipboard default retrieveObject.
	form1 _ form copy.
	form1 addDeltasFrom: form2.
	self assert: form1 primCountBits = 0 description: 'Form copyPasted from Clipboard appears to be bad.'.

	"This will also test storing and retrieving PNG data from platform Clipboard, and PNG conversion"
	ExtendedClipboardInterface current
		clearClipboard;
		addClipboardData: (PNGReadWriter bytesFor: form)  dataFormat: 'public.png'.
	form2 _ Clipboard default retrieveObject.
	form1 _ form copy.
	form1 addDeltasFrom: form2.
	self assert: form1 primCountBits = 0 description: 'Form copyPasted from Clipboard appears to be bad.'.! !

!ExtendedClipboardTest methodsFor: 'testing' stamp: 'jmv 4/6/2011 14:29'!
testStar8BitToAndFromImageClipboard
	"
	ExtendedClipboardTest new testStar8BitToAndFromImageClipboard
	"
	| form form1 form2 |
	form _ (StarMorph new
		extent: 100@100;
		imageForm) asFormOfDepth: 8.

	"This will use a refStreamed object"
	Clipboard default storeObject: form.
	form2 _ Clipboard default retrieveObject.
	form1 _ form copy.
	form1 addDeltasFrom: form2.
	self assert: form1 primCountBits = 0 description: 'Form copyPasted from Clipboard appears to be bad.'.

	"This will also test storing and retrieving PNG data from platform Clipboard, and PNG conversion"
	ExtendedClipboardInterface current
		clearClipboard;
		addClipboardData: (PNGReadWriter bytesFor: form)  dataFormat: 'public.png'.
	form2 _ Clipboard default retrieveObject.
	form1 _ form copy.
	form1 addDeltasFrom: form2.
	self assert: form1 primCountBits = 0 description: 'Form copyPasted from Clipboard appears to be bad.'.! !

!ExtendedClipboardTest methodsFor: 'testing' stamp: 'jmv 4/6/2011 14:29'!
testStarToAndFromImageClipboard
	"
	ExtendedClipboardTest new testStarToAndFromImageClipboard
	"
	| form form1 form2 |
	form _ StarMorph new
		extent: 100@100;
		imageForm.

	"This will use a refStreamed object"
	Clipboard default storeObject: form.
	form2 _ Clipboard default retrieveObject.
	form1 _ form copy.
	form1 addDeltasFrom: form2.
	self assert: form1 primCountBits = 0 description: 'Form copyPasted from Clipboard appears to be bad.'.

	"This will also test storing and retrieving PNG data from platform Clipboard, and PNG conversion"
	ExtendedClipboardInterface current
		clearClipboard;
		addClipboardData: (PNGReadWriter bytesFor: form)  dataFormat: 'public.png'.
	form2 _ Clipboard default retrieveObject.
	form1 _ form copy.
	form1 addDeltasFrom: form2.
	self assert: form1 primCountBits = 0 description: 'Form copyPasted from Clipboard appears to be bad.'.! !

!ExtendedClipboardUnixInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 15:56'!
readPrimAvailableFormats
	| i availableFormats formatData |
	availableFormats _ OrderedCollection new: 10.
	i _ 1.
	[
		formatData _ self getClipboardFormat: i.
		formatData notNil ] whileTrue: [
			availableFormats add: formatData.
			i _ i + 1 ].
	^ availableFormats! !

!ExtendedClipboardUnixInterface methodsFor: 'api - retrieve' stamp: 'jmv 1/19/2011 15:17'!
retrieveId
	| bytes formats |
	formats _ self readPrimAvailableFormats.
	(formats includes: 'cuis-id')
		ifTrue: [
			bytes _ self readClipboardData: 'cuis-id'.
			^ bytes asString ].
	^ nil! !

!ExtendedClipboardUnixInterface methodsFor: 'api - retrieve' stamp: 'jmv 3/17/2011 09:08'!
retrieveObject
	| conversion bytes |
	self readPrimAvailableFormats do: [ :format |
		conversion _ format caseOf: {
			"Unformatted plain text"
			[ 'UTF8_STRING' ] -> [ #fromUTF8Bytes: ].
			"Bitmap images (not sure if all of them are actually used in this platform)"
			[ 'image/png' ] -> [ #fromPNGBytes: ].
			[ 'image/tiff' ] -> [ #fromTIFFBytes: ].
			[ 'image/jpeg' ] -> [ #fromJPEGBytes: ].
			[ 'image/bmp' ] -> [ #fromBMPBytes: ].
			[ 'cuis-refStreamed' ] -> [ #fromRefStreamBytes: ].
			"Rich text"
"			[ '????rtf' ] -> [ #fromRTFBytes: ]"
		} otherwise: [ nil ].
		conversion ifNotNil: [
			bytes _ self readClipboardData: format.
			^self perform: conversion with: bytes ]
		].
	^nil	"Could not read any of the available formats"! !

!ExtendedClipboardUnixInterface methodsFor: 'api - store' stamp: 'jmv 1/26/2011 10:07'!
storeForm: aForm id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id at the end."
	self clearClipboard.
	self addClipboardData: (PNGReadWriter bytesFor: aForm) dataFormat: 'image/png'.
	self addClipboardData: otherString dataFormat: 'cuis-id'! !

!ExtendedClipboardUnixInterface methodsFor: 'api - store' stamp: 'jmv 3/14/2012 09:30'!
storeString: aString id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id at the end."
	self clearClipboard.
	self
		addClipboardData: aString iso8859s15ToUtf8
		dataFormat: 'UTF8_STRING'.
	self addClipboardData: otherString dataFormat: 'cuis-id'! !

!ExtendedClipboardUnixInterface methodsFor: 'api - store' stamp: 'jmv 3/14/2012 09:31'!
storeText: aText id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id is usually at the end, but don't include it if we include a streamed representation."
	self clearClipboard.

	"SmartRefStream handles class changes, but a little testing shows stuff is twice as big, and takes 20 times more time to generate"
	self addClipboardData: (ReferenceStream streamedRepresentationOf: aText) dataFormat: 'cuis-refStreamed'.

	"onvert text to RTF and implement"
	"
	self
		addClipboardData: aText rtfString
		dataFormat: '????'
	"
	self
		addClipboardData: aText asString iso8859s15ToUtf8
		dataFormat: 'UTF8_STRING'.

	"If we store a streamed representation, don't store the id. In these cases, we prefer rebuilding the object, regardless of
	whether it is present in memory (because we stored it in the clipboard) or not (because some other Cuis image did it)"
	self addClipboardData: otherString dataFormat: 'cuis-id'! !

!ExtendedClipboardWinInterface methodsFor: 'testing' stamp: 'jmv 1/18/2011 22:27'!
canStore
	"Store into clipboard not yet implemented on Windows"
	^false! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 2/14/2008 23:56'!
clipboardAvailable: format
	"ExtendedClipboardWinInterface new clipboardAvailable: 8"

	"http://msdn2.microsoft.com/en-us/library/ms649047(VS.85).aspx

BOOL IsClipboardFormatAvailable(      
    UINT format
);"
	<apicall: bool 'IsClipboardFormatAvailable' (ulong) module: 'user32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 5/10/2006 17:56'!
closeClipboard
	"ExtendedClipboardWinInterface new closeClipboard"
	"http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/dataexchange/clipboard/clipboardreference/clipboardfunctions/getclipboardformatname.asp

BOOL CloseClipboard(      

    VOID 
);"
	<apicall: long 'CloseClipboard' () module: 'user32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 5/10/2006 16:09'!
format: format
	"ExtendedClipboardInterface format: 0"

	"http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/dataexchange/clipboard/clipboardreference/clipboardfunctions/emptyclipboard.asp

UINT EnumClipboardFormats(      

    UINT format
);"
	<apicall: ulong 'EnumClipboardFormats' (ulong) module: 'user32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 2/15/2008 00:09'!
getBitmapBitsFrom: handle count: nrOfBytes buffer: buffer
	"ExtendedClipboardWinInterface new getBitmapBitsFrom: handle count: nrOfBytes buffer: buffer"

	"http://msdn2.microsoft.com/en-us/library/ms532332(VS.85).aspx

LONG GetBitmapBits(
  HBITMAP hbmp,      // handle to bitmap
  LONG cbBuffer,     // number of bytes to copy
  LPVOID lpvBits     // buffer to receive bits
);"
	<apicall: long 'GetBitmapBits' (void* long byte* ) module: 'Gdi32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 5/10/2006 17:57'!
getClipboardData: format
	"ExtendedClipboardWinInterface new getClipboardData: 1"

	"http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/dataexchange/clipboard/clipboardreference/clipboardfunctions/getclipboarddata.asp

HANDLE GetClipboardData(      

    UINT uFormat
);"
	<apicall: byte * 'GetClipboardData' (ulong) module: 'user32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 2/14/2008 23:38'!
getClipboardDataHandle: format
	"ExtendedClipboardWinInterface new getBMPClipboardData: 2"

	"http://msdn2.microsoft.com/en-us/library/ms649039.aspx

HANDLE GetClipboardData(      

    UINT uFormat
);"
	<apicall: void* 'GetClipboardData' (ulong) module: 'user32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 5/10/2006 16:09'!
getClipboardFormatName: format name: string size: stringSize
	"ExtendedClipboardInterface getClipboardFormatName: 49171 name: (String new:128) size: 128"

	"http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/dataexchange/clipboard/clipboardreference/clipboardfunctions/getclipboardformatname.asp

int GetClipboardFormatName(      

    UINT format,
    LPTSTR lpszFormatName,
    int cchMaxCount
);"
	<apicall: long 'GetClipboardFormatNameA' (ulong char* long) module: 'user32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 1/23/2008 12:13'!
getClipboardSequenceNumber

	"http://msdn2.microsoft.com/en-us/library/ms649042(VS.85).aspx

 DWORD GetClipboardSequenceNumber(      
    VOID 
);"
	<apicall: long 'GetClipboardSequenceNumber' () module: 'user32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 2/14/2008 21:57'!
getObject: handle bufferSize: bufferSize buffer: buffer
	"ExtendedClipboardWinInterface new getObject: handle bufferSize buffer: buffer"

	"http://msdn2.microsoft.com/en-us/library/ms533268.aspx

int GetObject(
  HGDIOBJ hgdiobj,  // handle to graphics object
  int cbBuffer,     // size of buffer for object information
  LPVOID lpvObject  // buffer for object information
);"
	<apicall: long 'GetObjectW' (void* long Win32TagBitmap *) module: 'Gdi32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'testing' stamp: 'mir 1/23/2008 12:07'!
hasExternalClipboardChanged
	| prevSequenceNr |
	prevSequenceNr :=  self lastSeenSequenceNr.
	self
		openClipboard;
		closeClipboard.
	^prevSequenceNr < self lastSeenSequenceNr! !

!ExtendedClipboardWinInterface methodsFor: 'private' stamp: 'mir 1/23/2008 12:11'!
lastSeenSequenceNr
	^lastSeenSequenceNr ifNil: [lastSeenSequenceNr := -1].! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'jmv 3/13/2012 12:33'!
listFormats
	"ExtendedClipboardWinInterface new listFormats"

	| currentFormat result data buffer |
	result := self openClipboard: 0.
	result = 0
		ifTrue: [^self halt].
	currentFormat := 0.
	[
		'' print.
		currentFormat := self format: currentFormat.
		Transcript show: 'format: '; show: currentFormat printString; newLine.
		(#(1 16 7 49510 49355) includes: currentFormat)
			ifTrue: [
				data := self getClipboardData: currentFormat.
				Transcript show: data fromCString; newLine].
"		13 = currentFormat
			ifTrue: [
				data := self getClipboardData: currentFormat.
				Transcript show: data fromUTF16String; newLine]."

		currentFormat > 18
			ifTrue: [
				buffer := ByteArray new:128.
				self getClipboardFormatName: currentFormat name: buffer size: buffer size.
				Transcript show: 'buffer: '; show: buffer; newLine].
		currentFormat ~= 0
	] whileTrue.
	self closeClipboard! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 1/23/2008 12:11'!
openClipboard
	| result |
	result := self openClipboard: 0.
	lastSeenSequenceNr := self getClipboardSequenceNumber.
	result = 0
		ifTrue: [self halt].
! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 5/10/2006 16:09'!
openClipboard: windowOwner
	"ExtendedClipboardInterface openClipboard: 0"

	"http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/dataexchange/clipboard/clipboardreference/clipboardfunctions/openclipboard.asp

BOOL OpenClipboard(      

    HWND hWndNewOwner
);"
	<apicall: long 'OpenClipboard' (long) module: 'user32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 14:47'!
readClipboardData: format
	| answer |
	self openClipboard.
	[
		answer _ (self getClipboardData: format) fromCString
	] ensure: [ self closeClipboard ].
	^ answer! !

!ExtendedClipboardWinInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 15:56'!
readPrimAvailableFormats
	| i availableFormats |
	availableFormats _ OrderedCollection new: 10.
	i _ 0.
	self openClipboard.
	[
		i _ self format: i.
		i ~= 0 ] whileTrue: [
			availableFormats add: i ].
	self closeClipboard.
	^ availableFormats! !

!ExtendedClipboardWinInterface methodsFor: 'api - retrieve' stamp: 'jmv 1/19/2011 15:18'!
retrieveId
	"Implement!!"
	^nil! !

!ExtendedClipboardWinInterface methodsFor: 'api - retrieve' stamp: 'jmv 4/12/2011 11:55'!
retrieveObject
	| conversion formatName bytes |
	conversion _ nil.
	self readPrimAvailableFormats do: [ :format |

		"Bitmap images "		
		format = 2 ifTrue: [
			^ self retrieveWindowsBMPForm ].	"CF_BITMAP: read using FFI"

		"Unformatted plain text"
		format = 1 ifTrue: [
			conversion _ #fromUTF8Bytes: ].	"'text/plain' CF_TEXT"
			"Check for other formats such as 13 'text/unicode' CF_UNICODETEXT if needed"


		format > 18 ifTrue: [
			formatName := ByteArray new:128.
			self getClipboardFormatName: format name: formatName size: formatName size.
			(formatName asString beginsWith: 'Rich Text Format') ifTrue: [
				conversion _ #fromRTFBytes: ].		"text/rtf"

		].

		"Work on this when we do copy to clipboard"
		"[ 'cuis-refStreamed' ] -> [ #fromRefStreamBytes: ]"

		conversion ifNotNil: [
			bytes _ self readClipboardData: format.
			^self perform: conversion with: bytes ]
	].
	^ nil	"Could not read any of the available formats"! !

!ExtendedClipboardWinInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 16:05'!
retrieveWindowsBMPForm
	| handle bitmap result form bitBuffer byteCount |
	self openClipboard.
	[handle := self getClipboardDataHandle: 2 " 'image/*' CF_BITMAP"]
		ensure: [self closeClipboard].

	"Check handle"
	"Allocate buffer for bitmap structure"
	bitmap := Win32Bitmap new.
	result := self getObject: handle bufferSize: Win32Bitmap byteSize buffer: bitmap.
	byteCount := bitmap bmWidth * bitmap bmHeight * bitmap bmBitsPixel / 8.
	bitBuffer := ByteArray new: byteCount.
	result := self getBitmapBitsFrom: handle count: byteCount buffer: bitBuffer.

	result = 0
		ifTrue: [
			^nil].
	form := Form fromWin32BitMap: bitmap bits: bitBuffer.
	^form! !

!ExtendedClipboardWinInterface methodsFor: 'private' stamp: 'jmv 1/18/2011 16:05'!
retrieveWindowsDIBForm
	| handle bitmap result form bitBuffer |
	self openClipboard.
	[handle := self getClipboardDataHandle: 8 "CF_DIB"]
		ensure: [self closeClipboard].

	"Check handle"
	"Allocate buffer for bitmap structure"
"	result := self getObject: handle bufferSize: Win32BitmapInfoHeader byteSize buffer: nil."
self halt.
	bitmap := Win32Bitmap new.
	result := self getObject: handle bufferSize: Win32Bitmap byteSize buffer: bitmap.
	bitBuffer := ExternalAddress allocate: bitmap bmWidth*bitmap bmHeight*bitmap bmBitsPixel.
	bitmap bmBits: (ExternalData fromHandle: bitBuffer type: ExternalType byte asPointerType).
	result := self getObject: handle bufferSize: Win32Bitmap byteSize buffer: bitmap.

	result = 0
		ifTrue: [
			bitBuffer free.
			self halt.
			^nil].
	form := Form fromWin32BitMap: bitmap.
	bitBuffer free.
	^form! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'mir 6/18/2006 18:47'!
setClipboardFormat: format data: data 
	"ExtendedClipboardInterface current setClipboardFormat: 1 data: ('clipboard test' copyWith: 0 asCharacter) "

	"http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/dataexchange/clipboard/clipboardreference/clipboardfunctions/setclipboarddata.asp

HANDLE SetClipboardData(      

    UINT uFormat,
    HANDLE hMem
);"
	<apicall: long 'SetClipboardData' (ulong char*) module: 'user32.dll'>
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'system calls' stamp: 'jmv 1/13/2011 11:16'!
setClipboardString: string
	"ExtendedClipboardInterface current setClipboardString: 'clipboard test'"

	"http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/dataexchange/clipboard/clipboardreference/clipboardfunctions/setclipboarddata.asp

HANDLE SetClipboardData(      

    UINT uFormat,
    HANDLE hMem
);"
"	Warning (jmv) This code from Sophie gives a compilation error in Cuis. Learn why.
	<apicall: long 'SetClipboardData' (ulong char*) module: 'user32.dll'>
"
	^self externalCallFailed! !

!ExtendedClipboardWinInterface methodsFor: 'api - store' stamp: 'jmv 1/26/2011 10:07'!
storeForm: aForm id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id at the end."
	"To be implemented"
	self halt! !

!ExtendedClipboardWinInterface methodsFor: 'api - store' stamp: 'jmv 1/26/2011 10:07'!
storeString: aString id: otherString
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id at the end."
	"To be implemented"
	self halt! !

!ExtendedClipboardWinInterface methodsFor: 'api - store' stamp: 'jmv 3/17/2011 09:35'!
storeText: aText id: otherString
	"To be implemented (store both as string and as RTF)"
	"I presume the order is: most preferred format first, least desirable format last.
	Cuis object id is usually at the end, but don't include it if we include a streamed representation."
	self halt! !

!Form methodsFor: '*extendedClipboard-Win32' stamp: 'mir 2/16/2008 19:52'!
fromWin32BitMap: bitmapBits
	0 to: self height-1 do: [:y |
		1 to: self width do: [:x |
			bits integerAt: (y*width) + x put: ((bitmapBits unsignedLongAt: 1 + (y*width*4) + ((x-1) *4)) bitOr: 16rFF000000)
	]].
! !

!Form class methodsFor: '*extendedClipboard-Win32' stamp: 'mir 2/15/2008 10:24'!
fromWin32BitMap: bitmap bits: bits
	| form |
	form := self extent: bitmap bmWidth@bitmap bmHeight depth: bitmap bmBitsPixel.
	form fromWin32BitMap: bits.
	^form! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmBits
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: 21) type: ExternalType byte asPointerType! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmBits: anObject
	"This method was automatically generated"
	handle pointerAt: 21 put: anObject getHandle.! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmBitsPixel
	"This method was automatically generated"
	^handle signedShortAt: 19! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmBitsPixel: anObject
	"This method was automatically generated"
	handle signedShortAt: 19 put: anObject! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmHeight
	"This method was automatically generated"
	^handle signedLongAt: 9! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmHeight: anObject
	"This method was automatically generated"
	handle signedLongAt: 9 put: anObject! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmPlanes
	"This method was automatically generated"
	^handle signedShortAt: 17! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmPlanes: anObject
	"This method was automatically generated"
	handle signedShortAt: 17 put: anObject! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmType
	"This method was automatically generated"
	^handle signedLongAt: 1! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmType: anObject
	"This method was automatically generated"
	handle signedLongAt: 1 put: anObject! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmWidth
	"This method was automatically generated"
	^handle signedLongAt: 5! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmWidth: anObject
	"This method was automatically generated"
	handle signedLongAt: 5 put: anObject! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmWidthBytes
	"This method was automatically generated"
	^handle signedLongAt: 13! !

!Win32Bitmap methodsFor: 'accessing' stamp: 'mir 2/14/2008 22:47'!
bmWidthBytes: anObject
	"This method was automatically generated"
	handle signedLongAt: 13 put: anObject! !

!Win32Bitmap class methodsFor: 'instance creation' stamp: 'mir 2/14/2008 22:47'!
fields
	"Win32TagBitmap defineFields"


	^ #(
		#(#bmType 'long')
		#(#bmWidth 'long')
		#(#bmHeight 'long')
		#(#bmWidthBytes 'long')
		#(#bmPlanes 'short')
		#(#bmBitsPixel 'short')
		#(#bmBits 'byte*')
	)

"typedef struct tagBITMAP {
  LONG   bmType; 
  LONG   bmWidth; 
  LONG   bmHeight; 
  LONG   bmWidthBytes; 
  WORD   bmPlanes; 
  WORD   bmBitsPixel; 
  LPVOID bmBits; 
} BITMAP"
! !
ExtendedClipboardInterface initialize!
