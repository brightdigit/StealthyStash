# Swift Devcontainer Configurations

This directory contains devcontainer configurations for different Swift versions to support development across multiple Swift releases.

## Available Swift Versions

- **Swift 5.8** - `.devcontainer/swift-5.8/`
- **Swift 5.9** - `.devcontainer/swift-5.9/`
- **Swift 5.10** - `.devcontainer/swift-5.10/`
- **Swift 6.2** - `.devcontainer/swift-6.2/`

## How to Use

### Option 1: Using VS Code Command Palette
1. Open VS Code in this workspace
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS)
3. Type "Dev Containers: Reopen in Container"
4. Select the desired Swift version from the list

### Option 2: Using VS Code Settings
1. Open VS Code settings (`Ctrl+,` or `Cmd+,`)
2. Search for "devcontainer"
3. Set the path to the desired Swift version folder (e.g., `.devcontainer/swift-5.8`)

### Option 3: Manual Configuration
1. Copy the desired `devcontainer.json` file to the root `.devcontainer/` directory
2. Reopen the workspace in VS Code
3. VS Code will automatically detect and use the new configuration

## Features

Each devcontainer configuration includes:
- Swift toolchain for the specified version
- Common utilities and Git support
- Swift Language Server Protocol (LSP) support via the `sswg.swift-lang` extension
- LLDB debugging support
- Proper security configurations for debugging

## Requirements

- Docker or Podman
- VS Code with the Dev Containers extension
- At least 2GB of available memory for the container

## Notes

- The containers run as root user for compatibility with Swift toolchain requirements
- Each container includes the same base features and extensions for consistency
- The Swift images are pulled from the official Docker Hub repository
