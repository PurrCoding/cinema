#!/bin/bash

# Exit on any error
set -e

echo "Starting minification process..."

# Install minification tools
echo "Installing minification tools..."
npm install -g html-minifier-terser clean-css-cli terser

# Verify public directory exists
if [ ! -d "public" ]; then
	echo "Error: public directory not found!"
	exit 1
fi

echo "Files in public directory:"
find public -type f | head -20
echo "Total files: $(find public -type f | wc -l)"

# Minify HTML files with null delimiter to handle special characters
echo "Minifying HTML files..."
find public -name "*.html" -type f -print0 | while IFS= read -r -d '' file; do
	echo "Processing: $file"
	if [ -f "$file" ] && [ -s "$file" ]; then
		html-minifier-terser \
			--collapse-whitespace \
			--remove-comments \
			--remove-optional-tags \
			--remove-redundant-attributes \
			--remove-script-type-attributes \
			--remove-tag-whitespace \
			--use-short-doctype \
			--minify-css true \
			--minify-js true \
			--output "$file" \
			"$file" 2>/dev/null || echo "⚠ Failed to minify $file"
		echo "✓ $file processed"
	else
		echo "⚠ Skipping $file - file not found or empty"
	fi
done

# Minify CSS files with null delimiter
echo "Minifying CSS files..."
find public -name "*.css" -type f -print0 | while IFS= read -r -d '' file; do
	echo "Processing: $file"
	if [ -f "$file" ] && [ -s "$file" ]; then
		cleancss --output "$file" "$file" 2>/dev/null || echo "⚠ Failed to minify $file"
		echo "✓ $file processed"
	else
		echo "⚠ Skipping $file - file not found or empty"
	fi
done

# Minify JavaScript files with null delimiter
echo "Minifying JavaScript files..."
find public -name "*.js" -type f -print0 | while IFS= read -r -d '' file; do
	echo "Processing: $file"
	if [ -f "$file" ] && [ -s "$file" ]; then
		terser "$file" --compress --mangle --output "$file" 2>/dev/null || echo "⚠ Failed to minify $file"
		echo "✓ $file processed"
	else
		echo "⚠ Skipping $file - file not found or empty"
	fi
done

# Move public contents to root and clean up
echo "Moving public contents to root..."
# Create a temporary directory to avoid conflicts
mkdir -p temp_build
# Move everything from public to temp_build
cp -r public/* temp_build/ 2>/dev/null || true
# Remove everything except temp_build
find . -maxdepth 1 -not -name '.' -not -name 'temp_build' -exec rm -rf {} + 2>/dev/null || true
# Move contents from temp_build to root
mv temp_build/* . 2>/dev/null || true
# Remove temp_build directory
rmdir temp_build 2>/dev/null || true

# Generate summary
echo "Build Summary:"
html_count=$(find . -maxdepth 10 -name "*.html" | wc -l)
css_count=$(find . -maxdepth 10 -name "*.css" | wc -l)
js_count=$(find . -maxdepth 10 -name "*.js" | wc -l)
total_files=$(find . -type f | wc -l)

echo "HTML files: $html_count"
echo "CSS files: $css_count"
echo "JavaScript files: $js_count"
echo "Total files: $total_files"

echo "Files now in root:"
find . -maxdepth 2 -type f | head -10

echo "Minification and restructuring completed successfully!"