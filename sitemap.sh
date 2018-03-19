#!/bin/bash

# url configuration
URL="https://www.webarchitects.coop/"

# values: always hourly daily weekly monthly yearly never
FREQ="weekly"

SED=$(which sed)

DATE_TODAY=$(date +%Y-%m-%d)

# begin new sitemap
exec 1> sitemap.xml

# print head
echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<?xml-stylesheet type="text/xsl" href="/sitemap.xsl"?>'
echo '<!-- generator="Milkys Sitemap Generator, https://github.com/mcmilk/sitemap-generator" -->'
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

# print urls
IFS=$'\r\n' GLOBIGNORE='*' command eval "OPTIONS=($(cat $0.options))"
find . -type f "${OPTIONS[@]}" -printf "%TY-%Tm-%Td%p\n" | \
while read -r line; do
  DATE=${line:0:10}
  FILE=${line:12}
  # Remove .shtml and index from the filenames for the URLs
  PATH=$(echo "${FILE}" | "${SED}" -e 's/\.shtml$//' | "${SED}" -e 's/^index$//')
  echo "<url>"
  echo " <loc>${URL}${PATH}</loc>"
  echo " <lastmod>$DATE</lastmod>"
  # Add a priority element for the front page and main section pages
  if [[ ( "${PATH}" == '' ) || ( "${PATH}" == 'hosting' ) || ( "${PATH}" == 'support' ) || ( "${PATH}" == 'about' ) || ( "${PATH}" ==  'help' ) ]]; then
    echo " <priority>1.0</priority>"
  else
    echo " <priority>0.5</priority>"
  fi
  echo " <changefreq>$FREQ</changefreq>"
  echo "</url>"
done

# Add the status page
echo "<url>"
echo " <loc>https://www.webarch.info</loc>"
echo " <lastmod>${DATE_TODAY}</lastmod>"
echo " <priority>1</priority>"
echo " <changefreq>hourly</changefreq>"
echo "</url>"

# print foot
echo "</urlset>"
