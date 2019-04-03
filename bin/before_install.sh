DIR="$(pwd)"
cd ..
export SWIFT_VERSION=swift-4.2.1-RELEASE
wget https://swift.org/builds/${SWIFT_VERSION}/ubuntu1404/${SWIFT_VERSION}/${SWIFT_VERSION}-ubuntu14.04.tar.gz
tar xzf $SWIFT_VERSION-ubuntu14.04.tar.gz
export PATH="${PWD}/${SWIFT_VERSION}-ubuntu14.04/usr/bin:${PATH}"
cd "$DIR"
