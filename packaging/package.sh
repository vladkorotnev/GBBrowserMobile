cd "$( dirname "$0" )/.."
xcodebuild
cp -r build/Debug-iphoneos/GBBrowserMobile.app packaging/layout/Applications/
cd packaging
dpkg-deb -b layout
mv layout.deb GBBrowser-Mobile.deb