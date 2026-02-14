#!/bin/bash

# Download Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to path
export PATH="$PATH:`pwd`/flutter/bin"

# Run flutter doctor to ensure setup
flutter doctor

# Build for web
flutter build web --release
