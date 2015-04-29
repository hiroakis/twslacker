# Twslacker

Notify slack of the twitter stream.

## Installation

```
git clone git@github.com:hiroakis/twslacker.git
cd twslacker
bundle install --path .bundle
```

## Usage

At first, create configration file `cp -p config.yml .config.yml`. Twslacker use `.config.yml` by default. Or you can use `-c` option to specify configuration file.

### start application

```
bundle exec ruby bin/twslacker start --type sample
or
bundle exec ruby bin/twslacker start --type track keyword keyword...
or
bundle exec ruby bin/twslacker start --type follow screen_name screen_name...
or
bundle exec ruby bin/twslacker start --type userstream
```

If you would like to ignore some words, you can use `--ignore` option.

* ignore tweet that includes "AAA", "BBB" or "CCC"

```
bundle exec ruby bin/twslacker start --type sample --ignore=AAA,BBB,CCC
```

* ignore Retweet, mention and hashtag

```
bundle exec ruby bin/twslacker start --type sample --ignore=RT,@,#
```

* daemonize

If you would like to start this application in daemon mode, use `-d` flag.

```
bundle exec ruby bin/twslacker start --type sample --ignore=AAA,BBB,CCC -d
```

### stop application

```
bundle exec ruby bin/twslacker stop
```

## TODO

test

## License

MIT
