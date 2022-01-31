Class {
	#name : #BaselineOfVte,
	#superclass : #BaselineOf,
	#category : #BaselineOfVte
}

{ #category : #baselines }
BaselineOfVte >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		self gtk: spec.
		self spec: spec.
		
		spec 
			package: 'Vte' with: [ spec requires: 'GtkCore' ];
			package: 'Vte-Spec' with: [ spec requires: #('Vte' 'SpecCore') ] ]
]

{ #category : #'external projects' }
BaselineOfVte >> gtk: spec [

	spec baseline: 'GtkCore' with: [ 
		spec 
			repository: 'github://pharo-spec/gtk-bindings';
			className: 'BaselineOfGtk';			
			loads: #('Core' 'GLib-IO') ]
]

{ #category : #'external projects' }
BaselineOfVte >> spec: spec [

	spec baseline: 'SpecCore' with: [ 
		spec 
			repository: 'github://pharo-spec/Spec';
			loads: 'Core' ]
]
