# womm.sh

## Overview

`womm.sh` (Work On My Machine) is a Bash script designed to automate common development tasks. It provides a text-based user interface (TUI) to help you easily perform actions such as downloading development code, updating your local site, and syncing files.

## Features

- **Download Dev**: Clones the latest development code into a new dated folder.
- **Update Local**: Updates your local site with the latest development code while preserving certain configuration files.
- **Sync Latest From Local**: Syncs newer files from your local site back to the development directory.

## Prerequisites

- **Operating System**: macOS (Apple Silicon)
- **Dependencies**:
  - **Homebrew**: Package manager for macOS.
  - **newt**: Provides the `whiptail` command for TUI menus.
  - **git**: Version control system.
  - **rsync**: Utility for file synchronization.
 
Could be adapted to be executed from any Bash-friendly environment such as WSL2 on Windows or on Linux.

## Installation

### 1. Install Homebrew (if not already installed)

Run the following command in your Terminal:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Dependencies

Update Homebrew:

```
brew update
```

Install `newt`:

```
brew install newt
```

Install `git` (if not already installed):

```
brew install git
```

Install `rsync` (if not already installed):

```
brew install rsync
```

### 3. Make the Script Executable

Navigate to the directory where `womm.sh` is located:

```
cd /Scripts
```

Make the script executable:

```
chmod +x womm.sh
```

### 4. Configure the Script Paths

Open the script in a text editor:

```
nano womm.sh
```

Update the configurable paths at the top of the script:

```
# Configurable paths
CODE_DIR="/Users/yourusername/Code"
SITES_DIR="/Users/yourusername/Sites/YourLocalSite/app/public"
```

Replace `/Users/yourusername/Code` and `/Users/yourusername/Sites/YourLocalSite/app/public` with the actual paths on your system.

Save and exit the editor.

### 5. Create an Alias (Optional)

To run the script from anywhere, you can create an alias:

Open your shell configuration file:

```
nano ~/.zshrc
```

Add the following line:

```
alias womm="/Scripts/womm.sh"
```

Save and exit, then reload your shell configuration:

```
source ~/.zshrc
```

## Usage

Run the script:

```
./womm.sh
```

Or, if you created an alias:

```
womm
```

You'll see a menu with the following options:

- **Download Dev**
- **Update Local**
- **Sync Latest From Local**

Use the arrow keys to navigate and press **Enter** to select an option.

### Option 1: Download Dev

- **Function**: Clones the latest development code into a new folder named `DevProjectDDMMYY` inside your `CODE_DIR`.
- **Process**:
  - Creates a new directory with the current date.
  - Clones the repository into this directory.

### Option 2: Update Local

- **Function**: Updates your local site with the latest development code.
- **Process**:
  - Backs up `wp-config.php` and any `.sql` files from your `SITES_DIR` to a temporary directory.
  - Locates the latest development directory in `CODE_DIR`.
  - Syncs files from the latest development directory to your local site directory, excluding `wp-config.php` and `.sql` files.
  - Restores `wp-config.php` and `.sql` files to your local site directory.
  - Removes `object-cache.php` from the `wp-content` directory.
  - Cleans up temporary files.

### Option 3: Sync Latest From Local

- **Function**: Syncs newer files from your local site directory to the latest development directory.
- **Process**:
  - Locates the latest development directory in `CODE_DIR`.
  - Syncs files from your `SITES_DIR` to the development directory, excluding `wp-config.php` and `.sql` files, and only if the files in `SITES_DIR` are newer.

## Notes

- **Exclusions**: The script excludes `wp-config.php` and `.sql` files during synchronization to prevent overwriting environment-specific configurations.
- **Error Handling**: The script includes basic error handling and will exit with an error message if any critical operation fails.
- **Verbosity**: Progress messages are printed to the console to keep you informed about each step.

## Troubleshooting

### `whiptail` Not Found

If you encounter an error related to `whiptail`, ensure that the `newt` package is installed correctly:

```
brew reinstall newt
```

### Permission Issues

If you receive permission errors when running the script, ensure that you have the necessary permissions for the directories involved.

Example:

```
sudo chmod -R u+rw "/Users/yourusername/Code"
sudo chmod -R u+rw "/Users/yourusername/Sites"
```

### SSH Setup

Since the script uses SSH to clone the repository, ensure your SSH keys are set up correctly with your repository hosting service.

Check SSH connection:

```
ssh -T git@github.com
```

If you see a permission denied error, follow your hosting service's guide to set up SSH keys.

### Verifying Paths

Double-check that the paths in your script correspond to actual directories on your system.

Check if directories exist:

```
ls "/Users/yourusername/Code"
ls "/Users/yourusername/Sites/YourLocalSite/app/public"
```

## Customization

### Adjust Exclusions

If you need to exclude more files or directories during synchronization, modify the `--exclude` parameters in the `rsync` commands within the script.

Example:

```
rsync -av --update "$PUBLIC_DIR/" "$DEV_DIR/" --exclude 'wp-config.php' --exclude '*.sql' --exclude 'node_modules' --exclude '.git'
```

### Change Sync Direction

Ensure that the source and destination paths in the `rsync` commands are correctly set for your intended sync direction.

## Safety Precautions

- **Backups**: Always back up important data before running scripts that modify files.
- **Testing**: Test the script in a safe environment to confirm it works as expected before using it on critical systems.

## License

This script is provided as-is, without any warranty. Use it at your own risk.
