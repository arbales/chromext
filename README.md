chromext-arbales
================

`chromext` is a command line tool that can create a basic workspace for Chrome
Extensions with CoffeeScript, Stylus and Jade support. It includes a compilation
system that automatically compiles the source files and watches changes.
Also, it can automatically archive the workspace into a .zip. It's pretty handy.

## Installation

	git clone arbales/chromext
	cd path/to/chromext
	npm install
	npm link

## Usage

#### Setting up a chromext workspace

Chromext can set up a simple and basic Chrome Extension workspace for you. Simply do:

	chromext create [name]

This will ask you for a extension name, a description and a version which will
be written into the `manifest.json`. If `name` is not given, the extension
will be created in the current directory.

You can have Chromext watch your directory…

	cd your-chrome
	chromext watch

The folder you can load and refresh into Chrome is the `build` folder.
You can also have Chromext build a zip file of your project. You'll need
the `zip` command line tool.

	cd your-chrome
	chromext build
	# …
	# zip Packing archive your-chrome-1.0.6.zip

Chromext works with multiple manifest targets. Specify them with the
`MANIFEST_NAME` environment variable…

	MANIFEST_NAME=staging chromext build
	# zip Packing archive your-staging-1.0.9.zip