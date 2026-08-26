.PHONY: build help

build:
	@command -v flutter >/dev/null 2>&1 || { echo "flutter not found in PATH"; exit 127; }
	flutter build appbundle --release

help:
	@echo "Usage: make build  # build Google Play AAB"
