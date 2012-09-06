chromext
========

`chromext` is a command line tool that can create a basic workspace for Chrome Extensions with CoffeeScript, Stylus and Jade support. It includes a compilation system that automatically compiles the source files and watches changes. It's pretty handy.

## Installation

	npm install -g chromext

## Usage

#### Setting up a chromext workspace

Chromext can set up a simple and basic Chrome Extension workspace for you. Simply do:

	chromext init [name]

This will ask you for a extension name, a description and a version which will be written into the `manifest.json`. If `name` is not given, the extension will be created in the current directory.


#### Compile source files on-the-fly

Chromext can automatically watch file changes in your workspace and convert `coffee`, `stylus` and `jade` files for you. To run the watchers, do:

	chromext watch [name]


#### Building the extension

Chromext can automatically create a `.zip` file for you, which you can upload to the Chrome Developer Dashboard. To archive your workspace into a `.zip` file, do:

	chromext build [name]
	
Please note that you need to have the `zip` command line tool to build extensions using chromext.