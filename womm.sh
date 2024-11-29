#!/bin/bash

# Configurable paths
CODE_DIR="/Users/jonatanjansson/Code"
SITES_DIR="/Users/jonatanjansson/Sites/Latest Local ProductSite/ProductSite.com/app/public"

# Check if whiptail is installed
if ! command -v whiptail &> /dev/null; then
    echo "Error: 'whiptail' is not installed. Please install it to proceed."
    exit 1
fi

# Display menu
CHOICE=$(whiptail --title "Work On My Machine" --menu "Choose an option" 15 60 3 \
"1" "Download Dev" \
"2" "Update Local" \
"3" "Sync Latest From Local" 3>&1 1>&2 2>&3)

# Check if the user canceled the menu
if [ $? -ne 0 ]; then
    echo "Operation canceled by user."
    exit 1
fi

case $CHOICE in
    1)
        # Download Dev
        DATE_SUFFIX=$(date +"%d%m%y")
        NEW_FOLDER="$CODE_DIR/ProductSiteDev$DATE_SUFFIX"
        echo "Creating folder: $NEW_FOLDER"
        if mkdir -p "$NEW_FOLDER"; then
            echo "Successfully created directory."
        else
            echo "Error: Failed to create directory $NEW_FOLDER"
            exit 1
        fi
        echo "Cloning repository into $NEW_FOLDER"
        if git clone git@github.com:thirdparty/wp-ProductSite.com.git "$NEW_FOLDER/wp-ProductSite.com"; then
            echo "Repository cloned successfully."
        else
            echo "Error: Git clone failed."
            exit 1
        fi
        ;;
    2)
        # Update Local
        PUBLIC_DIR="$SITES_DIR"
        TEMP_DIR=$(mktemp -d)
        echo "Backing up wp-config.php and .sql files to temporary directory: $TEMP_DIR"
        cp "$PUBLIC_DIR/wp-config.php" "$TEMP_DIR/" || { echo "Error: Failed to copy wp-config.php"; exit 1; }
        cp "$PUBLIC_DIR"/*.sql "$TEMP_DIR/" 2>/dev/null

        echo "Locating the latest ProductSiteDev directory..."
        LATEST_DEV=$(ls -d "$CODE_DIR"/ProductSiteDev* 2>/dev/null | sort | tail -n 1)
        if [ -z "$LATEST_DEV" ]; then
            echo "Error: No ProductSiteDev directories found in $CODE_DIR"
            exit 1
        else
            echo "Latest development directory found: $LATEST_DEV"
        fi

        echo "Updating local files..."
        rsync -av --delete "$LATEST_DEV/wp-ProductSite.com/" "$PUBLIC_DIR/" || { echo "Error: Failed to sync files."; exit 1; }

        echo "Restoring wp-config.php and .sql files..."
        cp "$TEMP_DIR/wp-config.php" "$PUBLIC_DIR/" || { echo "Error: Failed to restore wp-config.php"; exit 1; }
        cp "$TEMP_DIR"/*.sql "$PUBLIC_DIR/" 2>/dev/null

        echo "Removing object-cache.php from wp-content directory..."
        rm -f "$PUBLIC_DIR/wp-content/object-cache.php"

        echo "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"

        echo "Local update completed successfully."
        ;;
    3)
        # Sync Latest From Local
        PUBLIC_DIR="$SITES_DIR"
        echo "Locating the latest ProductSiteDev directory..."
        LATEST_DEV=$(ls -d "$CODE_DIR"/ProductSiteDev* 2>/dev/null | sort | tail -n 1)
        if [ -z "$LATEST_DEV" ]; then
            echo "Error: No ProductSiteDev directories found in $CODE_DIR"
            exit 1
        else
            echo "Latest development directory found: $LATEST_DEV"
        fi

        DEV_DIR="$LATEST_DEV/wp-ProductSite.com"

        echo "Syncing newer files from Local to Dev directory..."
        rsync -av --update "$PUBLIC_DIR/" "$DEV_DIR/" --exclude 'wp-config.php' --exclude '*.sql' || { echo "Error: Failed to sync files."; exit 1; }

        echo "Sync completed successfully."
        ;;
    *)
        echo "Invalid option selected."
        exit 1
        ;;
esac
