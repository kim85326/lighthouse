#!/bin/bash

set -e

OUTPUT_DIR=${OUTPUT_DIR:-"/home/chrome/reports"}

lighthouse --timeout=60000 --enable-error-reporting --chrome-flags="--headless --no-sandbox --allow-running-insecure-content --disable-dev-shm-usage" $@ --output json --output html --output-path="$OUTPUT_DIR/lighthouse"

REPORT_JSON_FILE="$OUTPUT_DIR/lighthouse.report.json"

# 使用 jq 從 JSON 報告中提取各個指標的分數
PERFORMANCE_SCORE=$(jq '.categories.performance.score * 100' "$REPORT_JSON_FILE")
ACCESSIBILITY_SCORE=$(jq '.categories.accessibility.score * 100' "$REPORT_JSON_FILE")
BEST_PRACTICES_SCORE=$(jq '.categories."best-practices".score * 100' "$REPORT_JSON_FILE")
SEO_SCORE=$(jq '.categories.seo.score * 100' "$REPORT_JSON_FILE")

FCP_SCORE=$(jq '.audits."first-contentful-paint".score' "$REPORT_JSON_FILE")
LCP_SCORE=$(jq '.audits."largest-contentful-paint".score' "$REPORT_JSON_FILE")
TBT_SCORE=$(jq '.audits."total-blocking-time".score' "$REPORT_JSON_FILE")
CLS_SCORE=$(jq '.audits."cumulative-layout-shift".score' "$REPORT_JSON_FILE")
SI_SCORE=$(jq '.audits."speed-index".score' "$REPORT_JSON_FILE")

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

if awk "BEGIN {exit !($PERFORMANCE_SCORE < $MIN_PERFORMANCE_SCORE)}"; then
    echo "Failed: Performance Score is below the minimum required"
    exit 1
fi

if awk "BEGIN {exit !($ACCESSIBILITY_SCORE < $MIN_ACCESSIBILITY_SCORE)}"; then
    echo "Failed: Accessibility Score is below the minimum required"
    exit 1
fi

if awk "BEGIN {exit !($BEST_PRACTICES_SCORE < $MIN_BEST_PRACTICES_SCORE)}"; then
    echo "Failed: Best-practices Score is below the minimum required"
    exit 1
fi

if awk "BEGIN {exit !($SEO_SCORE < $MIN_SEO_SCORE)}"; then
    echo "Failed: SEO Score is below the minimum required"
    exit 1
fi

echo "Success!!!"
