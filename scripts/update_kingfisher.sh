#!/usr/bin/sh

script_dir="$(dirname "$0")"

WORK_PATH=${script_dir}/.tmp
KINGFISHER_GITHUB_PROJECT=onevcat/Kingfisher
PROJECT_PATH=${script_dir}/../Tpay

# Prepare

mkdir -p $WORK_PATH

# Download and move source and tests files

sh ${script_dir}/get_latest_release.sh $KINGFISHER_GITHUB_PROJECT $WORK_PATH 
find $WORK_PATH/Sources -type f -name "*.swift" -not -path "*/SwiftUI/*" -print0 | xargs -0 -I{} cp -n {} $PROJECT_PATH/Tpay/Dependencies/Kingfisher/
ruby ${script_dir}/add_to_project.rb $PROJECT_PATH/Tpay.xcodeproj Tpay $PROJECT_PATH/Tpay/Dependencies/Kingfisher "Tpay/Dependencies/Kingfisher"

# remove public/open modifiers

find $PROJECT_PATH/Tpay/Dependencies/Kingfisher -type f -name '*.swift' | xargs sed -i '' 's/public //g'
find $PROJECT_PATH/Tpay/Dependencies/Kingfisher -type f -name '*.swift' | xargs sed -i '' 's/open //g'

# Clean

rm -rf $WORK_PATH