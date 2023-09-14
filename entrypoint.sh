#!/bin/bash

set -e

CHROME_FLAGS=${CHROME_FLAGS:-"--headless --disable-gpu --no-sandbox"}

# first arg is `-f` or `--some-option`
if [ "${1#http}" != "$1" ]; then
    set -- lighthouse --enable-error-reporting --chrome-flags="${CHROME_FLAGS}" "$@" --output=json --output-path=/home/chrome/reports/result.json
fi

# Execute the lighthouse command
"$@"

# 使用 jq 從 JSON 報告中提取各個指標的分數
PERFORMANCE_SCORE=$(cat /home/chrome/reports/result.json | jq '.categories.performance.score * 100')
ACCESSIBILITY_SCORE=$(cat /home/chrome/reports/result.json | jq '.categories.accessibility.score * 100')
BEST_PRACTICES_SCORE=$(cat /home/chrome/reports/result.json | jq '.categories."best-practices".score * 100')
SEO_SCORE=$(cat /home/chrome/reports/result.json | jq '.categories.seo.score * 100')

FCP_SCORE=$(cat /home/chrome/reports/result.json | jq '.audits."first-contentful-paint".score')
LCP_SCORE=$(cat /home/chrome/reports/result.json | jq '.audits."largest-contentful-paint".score')
TBT_SCORE=$(cat /home/chrome/reports/result.json | jq '.audits."total-blocking-time".score')
CLS_SCORE=$(cat /home/chrome/reports/result.json | jq '.audits."cumulative-layout-shift".score')
SI_SCORE=$(cat /home/chrome/reports/result.json | jq '.audits."speed-index".score')

echo "Performance Score: $PERFORMANCE_SCORE"
echo "Accessibility Score: $ACCESSIBILITY_SCORE"
echo "Best-practices Score: $BEST_PRACTICES_SCORE"
echo "SEO Score: $SEO_SCORE"
echo "-------------------------"
echo "First Contentful Paint Score: $FCP_SCORE"
echo "Largest Contentful Paint Score: $LCP_SCORE"
echo "Total Blocking Time Score: $TBT_SCORE"
echo "Cumulative Layout Shift Score: $CLS_SCORE"
echo "Speed Index Score: $SI_SCORE"
echo "-------------------------"

# 檢查每個分數是否低於給定的最低分數
if (( PERFORMANCE_SCORE < MIN_PERFORMANCE_SCORE )); then
    echo "Failed: Performance Score is below the minimum required"
    exit 1
fi

if (( ACCESSIBILITY_SCORE < MIN_ACCESSIBILITY_SCORE )); then
    echo "Failed: Accessibility Score is below the minimum required"
    exit 1
fi

if (( BEST_PRACTICES_SCORE < MIN_BEST_PRACTICES_SCORE )); then
    echo "Failed: Best-practices Score is below the minimum required"
    exit 1
fi

if (( SEO_SCORE < MIN_SEO_SCORE )); then
    echo "Failed: SEO Score is below the minimum required"
    exit 1
fi

echo "Success!!!"
