Readme
================

You'll likely want the arbales fork of Chromext…

	git clone arbales/chromext
    cd path/to/chromext
    npm install
    npm link
    
You can have Chromext watch your directory…

    cd your-chrome
    chromext watch
    
The folder you can load and refresh into Chrome is the `build` folder.
You can also have Chromext build a zip file of your project…

	cd your-chrome
	chromext build
	# …
	# zip Packing archive your-chrome-1.0.6.zip
	
Chromext works with multiple manifest targets. Specify them with the
`MANIFEST_NAME` environment variable…

	MANIFEST_NAME=staging chromext build
	# zip Packing archive your-staging-1.0.9.zip
    