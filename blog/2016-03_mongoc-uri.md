# MongoDB destination receiving a face lift

We have migrated to the official Mongo-C-Driver binding for providing the
MongoDB destination driver.
Previously, libmongo-client provided this binding,
mandating its own special syntax.

Some of the options have been deprecated
and the following ones should be used instead:

* `collection`
* `uri`
  ([https://docs.mongodb.org/manual/reference/connection-string/]())

This should enable more fine grained configuration
and future proofing.
MongoDB 3 is not officially supported or being tested yet,
but this kind of connection should
theoretically enable easy support in the future.

If you used legacy syntax in your configuration file,
syslog-ng will substitute the given deprecated options to form a URI.
Note that certain aspects of semantics could also differ
between the two drivers,
so do take care and test the behavior of your deployment.

Here is a non-exhaustive list of aspects to consider:

* replica set formation
* health checks
* failure handling
* reconnection
* asynchronous operation
* timeouts
* sanitization
* caching & buffering

Here is the list of deprecated options and their new substitutes:

## host('example.com'), port(1234)

* `uri('mongodb://example.com:1234/syslog')`

## servers('example.com:1234', 'example.net:12345')

* `uri('mongodb://example.com:1234,example.net:12345/syslog')`

## path('/tmp/mongo.sock')

* `uri('mongodb:///tmp/mongo.sock')`

## database('syslog-ng')

* `uri('mongodb://example.com:1234/syslog-ng')`

## username('user'), password('pass')

* `uri('mongodb://user:pass@example.com/syslog')`

## safe_mode(no)

The original intention of this option was to support asynchronous operation
where records can be output without waiting for acknowledgement.

Please see the MongoDB URI documentation for available settings
that influence such aspects of operation.

For example, you can disable write concern and set timeouts by specifying:

* `uri('mongodb://example.com:1234/syslog?w=0&safe=false&socketTimeoutMS=60000&connectTimeoutMS=60000')`
