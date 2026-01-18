# Install Missing AVD Images

This repository contains a Perl script to automatically find and install missing system images required by your Android Virtual Devices (AVDs).

## Description

When you copy AVD configurations to a new machine, you often have the AVD definitions but are missing the corresponding system images. This script automates the process of installing them.

It scans the `config.ini` files within your AVD directories (e.g., `~/.android/avd/`), identifies the required system image for each AVD, and uses the Android `sdkmanager` to download and install it.

## Prerequisites

1.  **Perl:** The script is written in Perl and requires it to be installed on your system.
2.  **Android SDK:** You must have the Android SDK installed, and the `sdkmanager` command-line tool must be available in your system's `PATH`.

## Usage

1.  Clone this repository or download the `install-missing-avd-images.pl` script.
2.  Navigate to your Android AVD directory. This is typically located at `~/.android/avd/`.
3.  Run the script from within your AVD directory:

    ```bash
    /path/to/install-missing-avd-images.pl
    ```

    The script will then iterate through each AVD, identify the required system image package, and attempt to install it using `sdkmanager`.

## How It Works

The script performs the following steps:
1.  Searches for all `config.ini` files in the immediate subdirectories of the current location.
2.  For each `config.ini` found, it parses the file to find the `image.sysdir.1` property, which specifies the system image directory.
3.  It extracts the SDK package path from this property (e.g., `system-images;android-31;google_apis;x86_64`).
4.  It invokes `sdkmanager` with the extracted package path to trigger the download and installation.

## License

This project is licensed under the terms of the LICENSE file.
