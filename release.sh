#!/bin/zsh

PROJECT_PATH="$(dirname $(readlink -f $0))"

PBXPROJ_PATH="${PROJECT_PATH}/Harmonie.xcodeproj/project.pbxproj"
PRODUCT_BUNDLE_IDENTIFIER="net.nemushee.harmonie"

AWK_SCRIPT_PATH="${PROJECT_PATH}/Scripts/extract_version.awk"
MARKETING_VERSION=$(awk -f ${AWK_SCRIPT_PATH} ${PBXPROJ_PATH})

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