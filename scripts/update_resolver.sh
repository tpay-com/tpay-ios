#!/usr/bin/sh

script_dir="$(dirname "$0")"

WORK_PATH=${script_dir}/.tmp
RESOLVER_GITHUB_PROJECT=hmlongco/Resolver
PROJECT_PATH=${script_dir}/../Tpay

# Prepare

mkdir -p $WORK_PATH

# Download and move source and tests files

sh ${script_dir}/get_latest_release.sh $RESOLVER_GITHUB_PROJECT $WORK_PATH 
find $WORK_PATH/Sources/Resolver/Resolver.swift -type f -name "*.swift" -print0 | xargs -0 -I{} cp -n {} $PROJECT_PATH/Tpay/Dependencies/Resolver/
find $WORK_PATH/Tests/ResolverTests -type f -name "*.swift" -print0 | xargs -0 -I{} cp -n {} $PROJECT_PATH/TpayTests/DependenciesTests/ResolverTests/

ruby ${script_dir}/add_to_project.rb $PROJECT_PATH/Tpay.xcodeproj Tpay $PROJECT_PATH/Tpay/Dependencies/Resolver "Tpay/Dependencies/Resolver"
ruby ${script_dir}/add_to_project.rb $PROJECT_PATH/Tpay.xcodeproj TpayTests $PROJECT_PATH/TpayTests/DependenciesTests/ResolverTests "TpayTests/DependenciesTests/ResolverTests"

# replace @testable imports

find $PROJECT_PATH/TpayTests/DependenciesTests/ResolverTests -type f -name '*.swift' | xargs sed -i '' 's/@testable import Resolver/@testable import Tpay/g'
find $PROJECT_PATH/TpayTests/DependenciesTests/ResolverTests -type f -name '*.swift' | xargs sed -i '' 's/import Resolver/@testable import Tpay/g'

# remove public modifiers

find $PROJECT_PATH/Tpay/Dependencies/Resolver -type f -name '*.swift' | xargs sed -i '' 's/public //g'

# Clean

rm -rf $WORK_PATH