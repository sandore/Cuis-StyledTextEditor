'From Cuis 4.0 of 3 April 2012 [latest update: #1260] on 17 April 2012 at 11:21:23 pm'!
'Description Please enter a description for this package.'!
!classDefinition: #BpStyledTextNotebook category: #StyledTextNotebook!
Object subclass: #BpStyledTextNotebook
	instanceVariableNames: ''
	classVariableNames: 'AppMorph Filename MyModel SaveIcon'
	poolDictionaries: ''
	category: 'StyledTextNotebook'!
!classDefinition: 'BpStyledTextNotebook class' category: #StyledTextNotebook!
BpStyledTextNotebook class
	instanceVariableNames: ''!


!BpStyledTextNotebook class methodsFor: 'StyledText Notebook' stamp: 'jmv 8/2/2011 15:10'!
createModelAndView
	"
	BpStyledTextNotebook createModelAndView
	"

	| saveButton topRow |
	MyModel _ StyledTextModel new.
	AppMorph _ SystemWindow createStyledTextEditor: MyModel in: STEMainMorph newColumn.
	AppMorph adoptWidgetsColor: MyModel class windowColor.
	saveButton _ (PluggableButtonMorph model: self action: #save)
		extent: 22@22;
		icon: self saveIcon;
		layoutSpec: LayoutSpec keepMorphExtent;
		yourself.
	topRow _ AppMorph submorphs last.
	topRow addMorphBack: saveButton.

	AppMorph bounds: World bounds.
	World addMorph: AppMorph.! !

!BpStyledTextNotebook class methodsFor: 'StyledText Notebook' stamp: 'jmv 5/24/2011 08:53'!
install
	"
	BpStyledTextNotebook install
	Preferences enable: #focusFollowsMouse
	"
	| newName |
	Preferences disable: #focusFollowsMouse.
	Preferences disable: #commandClickOpensHalo.
	Smalltalk addToStartUpList: self.

	Filename _ 'StyledText.object'.
	(SystemWindow windowsIn: World satisfying: [:w | true])
		do: [:w | w delete].
	World allNonFlapRelatedSubmorphs do: [ :m | m delete].
	World color: Color white.

	self createModelAndView.

	"Save image"
	newName _ 'StyledTextEditor.image'.
	(SourceFiles at: 2) ifNotNil: [
		Smalltalk
			closeSourceFiles; "so copying the changes file will always work"
			 saveChangesInFileNamed: (Smalltalk fullNameForChangesNamed: newName)].
	Smalltalk saveImageInFileNamed: newName! !

!BpStyledTextNotebook class methodsFor: 'StyledText Notebook' stamp: 'jmv 1/6/2012 14:17'!
save
	"Maybe we're still saving too much...
	Besides, check if new instances of ParagraphStyle et al are created on startup..."
	MyModel saveAs: Filename! !

!BpStyledTextNotebook class methodsFor: 'StyledText Notebook' stamp: 'jmv 3/11/2011 17:39'!
saveIcon
	"Created using:
	Clipboard default storeObject:
	 	((PNGReadWriter bytesFor: (Form fromFileNamed: 'Save.png')) asString base64Encoded)
	"
	SaveIcon ifNil: [ SaveIcon _ Form fromBinaryStream: 'iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAACjElEQVR4Xq3UXUhaYRwG8HNd
aZmk6WrmGkbWytJdlJgTuq3RaAPJm9ZY+wrHYrYPvPNqI02Z0EZjFycH3W6apqkgxDZiW4PR
xQi2XeximbAgkNHFM/9vKOcgywkTHt9zDs/58Z7X98il02mk/2M4+pqfn4fb7cbg4CB8Ph+m
bs3BMjpVlqHzV0u54nzAugaDAcPDw7gwNnYEplIpTE9P4/nSEsxmMw4PD8FHt3Dp3stjQx3q
6vV6nLNaoVQqQRYDR0dGMOdyoaOjA/l8vqooFQroOzshk8mOwGQyCevQEBwTE1Cr1Tg4OKgq
BGm1WkilUpDFra+vw2KxwG63Q61SYX9/H5lMBsFg8NhQh7qyhgZo29oYSBaXSCREYC6XqypC
kCwuHo+LwGw2y6bu9/uPDXWoKwTJ4tbW1kTg7u5uxfwUHAtBssrAlZWVf0Ip1C0DY7FYCdTp
dJA3NlYV2n9FkCwRaDIacbq9vapoNBoxGI1Gy8BHjxfw/uM2y+ftHXz9/gN7e78KG/k36LPM
L+OsyYQz3d0ikCxudXW1DCxCPB/Cxpu3JYhGgr/sfGM9QoUgWQwcGBjAxfFxGPv7WbE4o9ra
WhYh9G7zE5Kpjb+DkUgE3YWp22w2VjpVeI2KMyqukxCKxtJ4HUkwqLenBydbW9mxRCIBWVw4
HMaJwjvc1dXF3mVVc3NpRq0tLSxCiEY6l8vlDFI0NbFfmp6ELI7neVyenGR7sL6+HnV1ddj8
sMXW0FhY074+owh6FY7j6bMXqKmpYY9JfRrpnCwuEAjA6/XC4XCwix6PB665hyzXrs/gxk0n
ZpyzuH3Hhdm799l178ITdg916R5Kf2H9yeJCoRAWFxcr/rtUChlk/QGoFPNClwN64wAAAABJ
RU5ErkJggg==' base64Decoded asByteArray readStream ].
	^SaveIcon! !

!BpStyledTextNotebook class methodsFor: 'StyledText Notebook' stamp: 'jmv 1/28/2011 18:44'!
startUp
	| file |
	(FileStream isAFileNamed: Filename) ifTrue: [
		file _ FileStream fileNamed: Filename.
		[ MyModel _ (SmartRefStream on: file) next ] ensure: [ file close ].
		AppMorph submorphs first
			 model: MyModel;
			 possiblyChanged ].! !
