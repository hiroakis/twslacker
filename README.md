# Twslacker

Notify slack of the twitter stream.

## Installation

```
git clone git@github.com:hiroakis/twslacker.git
cd twslacker
bundle install --path .bundle
```

## Usage

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

### stop application

```
bundle exec ruby bin/twslacker stop
```

## License

MIT
