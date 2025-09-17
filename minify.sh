#!/bin/bash
set -e

# =============================================================================
# Netlify Pre-Build Minification Script
# Only minify files if changes are detected in the `public/` folder
# =============================================================================

echo "Starting minification process..."

# -----------------------------
# 1. Install required minification tools
# -----------------------------
echo "Installing minification tools..."
npm install -g html-minifier-terser clean-css-cli terser

# -----------------------------
# 2. Verify public directory exists
# -----------------------------
if [ ! -d "public" ]; then
    echo "Error: public directory not found!"
    exit 1
fi

# -----------------------------
# 3. Check for changes in public/ folder
# -----------------------------
PREV_COMMIT=$(git rev-parse HEAD~1)
CURRENT_COMMIT=$(git rev-parse HEAD)
CHANGES=$(git diff --name-only $PREV_COMMIT $CURRENT_COMMIT | grep '^public/' || true)

if [ -z "$CHANGES" ]; then
    echo "No changes detected in 'public/' folder. Skipping minification."
    exit 0
fi

echo "Detected changes in 'public/' folder:"
echo "$CHANGES"

# -----------------------------
# 4. Minify HTML files
# -----------------------------
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

# -----------------------------
# 5. Minify CSS files
# -----------------------------
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

# -----------------------------
# 6. Minify JavaScript files
# -----------------------------
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

# -----------------------------
# 7. Build summary
# -----------------------------
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