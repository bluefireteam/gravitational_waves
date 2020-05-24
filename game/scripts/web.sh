#!/bin/bash -xe

flutter run --release -d chrome --dart-define=FLUTTER_WEB_USE_SKIA=true
