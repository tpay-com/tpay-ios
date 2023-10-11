# Contribution

## Setup workspace

1. Run `bundle install`
3. Run `bundle exec pod install --repo-update`
4. Open `Tpay.xcworkspace`

## Dependencies update

Third party dependencies are integrated by checking out sources and adding them to the project.\
In case, there is a need to update any of the following dependencies, simply run associated command.

| Dependency      | Command                                 | 
| --------------- | --------------------------------------- |
| Resolver        | `sh scripts/update_resolver.sh`         | 
| Snail           | `sh scripts/update_snail.sh`            | 
| Kingfisher      | `sh scripts/update_kingfisher.sh`       | 
