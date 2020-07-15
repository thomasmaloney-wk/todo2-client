#------------------------------------------------------------------
# DART
#------------------------------------------------------------------
build:
	pub get
	pub global run webdev build

clean:
	rm -fr .packages
	rm -fr .dart_tool
	rm -fr ./build

run:
	pub get
	webdev serve