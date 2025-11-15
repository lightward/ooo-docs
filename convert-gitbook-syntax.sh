#!/bin/bash

# Convert GitBook syntax to standard markdown
cd /Users/isaac/dev/ooo-docs

# Function to convert a single file
convert_file() {
    local file="$1"

    # Remove GitBook frontmatter (but keep file)
    perl -i -0pe 's/^---\nlayout:.*?\n---\n\n//s' "$file"

    # Convert {% code %} blocks to just keep the inner content
    perl -i -0pe 's/\{% code[^\%]*%\}\n(```.*?```)\n\{% endcode %\}/\1/gs' "$file"

    # Convert {% hint %} blocks to blockquotes
    perl -i -0pe 's/\{% hint style="[^"]*" %\}\n(.*?)\n\{% endhint %\}/> \1/gs' "$file"

    # Fix blockquote formatting (each line needs > )
    perl -i -0pe 's/> (.*?)\n(.*?)\n(?!>)/> \1\n> \2\n/gs' "$file"
}

# Convert all .md files except those in _includes
find . -name "*.md" -not -path "./_includes/*" -not -path "./.git/*" | while read file; do
    echo "Converting: $file"
    convert_file "$file"
done

echo "Done!"
