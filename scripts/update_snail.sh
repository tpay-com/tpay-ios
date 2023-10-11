#!/usr/bin/sh

script_dir="$(dirname "$0")"

WORK_PATH=${script_dir}/.tmp
SNAIL_GITHUB_PROJECT=UrbanCompass/Snail
PROJECT_PATH=${script_dir}/../Tpay

# Prepare

mkdir -p $WORK_PATH

# Download and move source and tests files

sh ${script_dir}/get_latest_release.sh $SNAIL_GITHUB_PROJECT $WORK_PATH 
find $WORK_PATH/Snail -type f -name "*.swift" -print0 | xargs -0 -I{} cp -n {} $PROJECT_PATH/Tpay/Dependencies/Snail/
find $WORK_PATH/SnailTests -type f -name "*.swift" -print0 | xargs -0 -I{} cp -n {} $PROJECT_PATH/TpayTests/DependenciesTests/SnailTests/

ruby ${script_dir}/add_to_project.rb $PROJECT_PATH/Tpay.xcodeproj Tpay $PROJECT_PATH/Tpay/Dependencies/Snail "Tpay/Dependencies/Snail"
ruby ${script_dir}/add_to_project.rb $PROJECT_PATH/Tpay.xcodeproj TpayTests $PROJECT_PATH/TpayTests/DependenciesTests/SnailTests "TpayTests/DependenciesTests/SnailTests"

# replace @testable imports

find $PROJECT_PATH/TpayTests/DependenciesTests/SnailTests -type f -name '*.swift' | xargs sed -i '' 's/@testable import Snail/@testable import Tpay/g'

# remove public modifiers

find $PROJECT_PATH/Tpay/Dependencies/Snail -type f -name '*.swift' | xargs sed -i '' 's/public //g'

# Clean

rm -rf $WORK_PATH