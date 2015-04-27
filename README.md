# Twslacker

Notify slack of the twitter stream.

## Installation

```
git clone git@github.com:hiroakis/twslacker.git
cd twslacker
bundle install --path .bundle
```

## Usage

* start application

```
twslacker start --type sample
or
twslacker start --type track keyword, keyword, keyword
or
twslacker start --type follow follow_ids --notifier slack --limit xx
or
twslacker start --type userstream
```

* stop application

```
twslacker stop
```

## License

MIT
