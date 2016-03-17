# The MongoDB destination receives a face-lift

## Reasons behind the migration

We have migrated to the official mongo-c-driver binding for providing the
MongoDB destination driver.
Previously, libmongo-client provided this binding,
mandating its own special syntax.

This change will facilitate future-proof and more fine-grained configuration.
MongoDB 3 is not officially supported or being tested yet,
but this kind of connection should
theoretically enable easy MongoDB 3 support in the future.

## What to do when using legacy syntax

If you have used legacy syntax in your configuration file,
syslog-ng will substitute the given deprecated options to form a URI.
Note that certain aspects of semantics could also differ
between the two drivers.

Therefore, you should analyze the behavior of your deployed system to ensure
that the subtle changes in semantics do not cause any a regression.
A non-exhaustive list of aspects to consider:

* replica set formation
* health checks
* failure handling
* reconnection
* asynchronous operation
* timeouts
* sanitization
* caching & buffering

## Deprecated options and substitutes

### The mongodb() destination options

Use the following options for the mongodb() destination:

* `collection`
* `uri`
  ([https://docs.mongodb.org/manual/reference/connection-string/](https://docs.mongodb.org/manual/reference/connection-string/))

Inherited options are not affected, so they can be used as before and
as described in the documentation.
(e.g.,
`frac-digits()`,
`local-time-zone()`,
`log-fifo-size()`,
`on-error()`,
`retries()`,
`throttle()`,
`value-pairs()`,
etc.
)

### The deprecated options of mongodb() destination

Here is the list of deprecated options and their new substitutes:

#### database() (DEPRECATED)
`database('syslog-ng')`

* `uri('mongodb://example.com:1234/syslog-ng')`

#### host() (DEPRECATED)
`host('example.com'), port(1234)`

* `uri('mongodb://example.com:1234/syslog')`

#### path() (DEPRECATED)
`path('/tmp/mongo.sock')`

* `uri('mongodb:///tmp/mongo.sock')`

#### password() (DEPRECATED)
`password('pass')`

* `uri('mongodb://user:pass@example.com/syslog')`

#### servers() (DEPRECATED)
`servers('example.com:1234', 'example.net:12345')`

* `uri('mongodb://example.com:1234,example.net:12345/syslog')`

#### username() (DEPRECATED)
`username('user')`

* `uri('mongodb://user:pass@example.com/syslog')`

#### safe_mode() (DEPRECATED)
`safe_mode(no)`

The original intention of this option was to support asynchronous operation
where records can be output without waiting for acknowledgement.

See the MongoDB URI documentation for available settings
that could influence such aspects of operation.

For example, you can disable write concern and set timeouts by specifying:

* `uri('mongodb://example.com:1234/syslog?w=0&safe=false&socketTimeoutMS=60000&connectTimeoutMS=60000')`
