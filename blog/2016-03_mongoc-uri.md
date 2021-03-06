# URL "slug"
`mongodb-destination-receives-face-lift`

# Focus Keyword
`mongodb URI`

# Search engine meta description (at most 142 characters)
Migrated MongoDB destination driver to the official mongo-c-driver binding
with URI connection string instead of libmongo-client.

# Post tags

* configuration
* connection string
* mongo-c-driver
* MongoDB
* syslog-ng
* URI
* release

# Categories

* Logging

# Blog post title: The MongoDB destination receives a face-lift

## Reasons behind the migration

We have migrated to the official mongo-c-driver binding for providing the
MongoDB destination driver
in syslog-ng 3.8.
Previously in syslog-ng 3.7.x and earlier,
libmongo-client provided this binding,
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

---

Therefore, you should analyze the behavior of your deployed system to ensure
that the subtle changes in semantics do not cause any regressions.
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

### Recommended mongodb() destination option substitutes

Use the following options for the mongodb() destination:

* `collection`
* `uri`

You can refer to the documentation for more information about the format of the connection `URI` string:

* [Connection String URI Format](https://docs.mongodb.com/manual/reference/connection-string/) ([mirror](https://web.archive.org/web/20160614104734/https://docs.mongodb.com/manual/reference/connection-string/))
* [Class ConnectionString at the Java API documentation](https://api.mongodb.com/java/current/com/mongodb/ConnectionString.html)
* [MongoClient or how to connect in a new and better way](https://mongodb.github.io/node-mongodb-native/driver-articles/mongoclient.html)
* [URI format for defining connections between applications and MongoDB instances in the official MongoDB drivers](https://mongodb-documentation.readthedocs.io/en/latest/reference/connection-string.html)

Inherited options are not affected, therefore they can be used as before and
as described in the documentation.
(for example,
`frac-digits()`,
`local-time-zone()`,
`log-fifo-size()`,
`on-error()`,
`retries()`,
`throttle()`,
`value-pairs()`,
and so on)

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
