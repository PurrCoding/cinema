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
  
# Minify HTML files  
echo "Minifying HTML files..."  
find public -name "*.html" -type f | while read file; do  
    echo "Processing: $file"  
    original_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")  
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
        "$file"  
    new_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")  
    savings=$((original_size - new_size))  
    echo "✓ $file: ${original_size}B → ${new_size}B (saved ${savings}B)"  
done  
  
# Minify CSS files  
echo "Minifying CSS files..."  
find public -name "*.css" -type f | while read file; do  
    echo "Processing: $file"  
    original_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")  
    cleancss --output "$file" "$file"  
    new_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")  
    savings=$((original_size - new_size))  
    echo "✓ $file: ${original_size}B → ${new_size}B (saved ${savings}B)"  
done  
  
# Minify JavaScript files  
echo "Minifying JavaScript files..."  
find public -name "*.js" -type f | while read file; do  
    echo "Processing: $file"  
    original_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")  
    terser "$file" --compress --mangle --output "$file"  
    new_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")  
    savings=$((original_size - new_size))  
    echo "✓ $file: ${original_size}B → ${new_size}B (saved ${savings}B)"  
done  
  
# Generate summary  
echo "Build Summary:"  
html_count=$(find public -name "*.html" | wc -l)  
css_count=$(find public -name "*.css" | wc -l)  
js_count=$(find public -name "*.js" | wc -l)  
total_files=$(find public -type f | wc -l)  
  
echo "HTML files: $html_count"  
echo "CSS files: $css_count"  
echo "JavaScript files: $js_count"  
echo "Total files: $total_files"  
  
echo "Minification completed successfully!"