#!/bin/bash

PROJECT_PATH="$(dirname $(readlink -f $0))"

PBXPROJ_PATH="${PROJECT_PATH}/Harmonie.xcodeproj/project.pbxproj"
PRODUCT_BUNDLE_IDENTIFIER="jp.mknn.harmonie"

AWK_SCRIPT_PATH="${PROJECT_PATH}/Scripts/extract_version.awk"
MARKETING_VERSION=$(awk '
  /PRODUCT_BUNDLE_IDENTIFIER = '${PRODUCT_BUNDLE_IDENTIFIER}';/ {
    if (prev_line ~ /MARKETING_VERSION =/) {
      split(prev_line, arr, "= ");
      gsub(";", "", arr[2]);
      print arr[2];
      exit;
    }
  }
  { prev_line = $0 }
' "${PBXPROJ_PATH}")

git tag ${MARKETING_VERSION}
git push origin ${MARKETING_VERSION}
gh release create ${MARKETING_VERSION} -t ${MARKETING_VERSION} --generate-notes
