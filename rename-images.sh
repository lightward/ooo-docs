#!/bin/bash

# Rename screenshot images to match their include filenames
cd /Users/isaac/dev/ooo-docs

for include_file in _includes/*.md; do
    # Get the base name without .md extension
    include_name=$(basename "$include_file" .md)

    # Extract the image filename from the include
    image_file=$(grep -o 'src="/assets/[^"]*"' "$include_file" | sed 's/src="\/assets\/\([^"]*\)"/\1/' | head -1)

    if [ -n "$image_file" ]; then
        # Get the file extension
        ext="${image_file##*.}"

        # New semantic filename
        new_name="${include_name}.${ext}"

        # Full paths
        old_path="assets/$image_file"
        new_path="assets/$new_name"

        if [ -f "$old_path" ]; then
            echo "Renaming: $image_file -> $new_name"

            # Rename the file
            mv "$old_path" "$new_path"

            # Update the reference in the include file
            sed -i.bak "s|/assets/${image_file}|/assets/${new_name}|g" "$include_file"
            rm "${include_file}.bak"
        fi
    fi
done

echo ""
echo "Done! All images renamed to match their include files."
