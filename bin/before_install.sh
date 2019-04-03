DIR="$(pwd)"
cd ..
export SWIFT_VERSION=swift-4.2.1-RELEASE
wget https://swift.org/builds/swift-4.2.1-release/ubuntu1404/swift-4.2.1-RELEASE/swift-4.2.1-RELEASE-ubuntu14.04.tar.gz
tar xzf $SWIFT_VERSION-ubuntu14.04.tar.gz
export PATH="${PWD}/${SWIFT_VERSION}-ubuntu14.04/usr/bin:${PATH}"
cd "$DIR"
