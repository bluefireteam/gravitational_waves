#!/bin/bash

flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter build web

cd build/web
zip -r ../.gravity.zip *
