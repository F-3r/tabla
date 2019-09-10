# Tabla

A plain text human-readable tabular data format inspired in tablatal (https://wiki.xxiivv.com/#tablatal)"

## Usage

A Tabla file looks like:

```
date       | desc                                 | amount | notes
2019-01-01 | Something that worths a lot storing  | 20     | reference: 1237987
2019-01-01 | Something that worths a lot          | 10     | reference: 1237987
2019-01-01 | Something that worths                | 5      | reference: 1237987
2019-01-01 | Something that                       | 2.5    | reference: 1237987
2019-01-01 | Something                            | 1.25   | reference: 1237987
2019-01-01 |                                      |        | reference: 1237987
```
### Parsing & Dumping

To parse you can use:

* `Tabla.new(string).parse`
* `Tabla::load(string)` which is exactly as the previous
* `Tabla.load_file(path)` which reads the string from a file and loads it

To dump:

* `Tabla.dump(array-of-hashes)`

### Whitespace and format

Whitespace is ignored while parsing, so you can freely use it for improved readability.

The separator can be changed using `Tabla.separator = "any character"`

### Enumerable

It implements the `Enumerable` interface so you can use all the power of ruby collections.

```ruby
Tabla.load_file("./example.tabla").each #=> returns an enumerator
```

```ruby
Tabla.load_file("./example.tabla").each { |row| puts "#{row["amount"]" }
```

```ruby
Tabla.load_file("./example.tabla").map { |row| OpenStruct.new(row) }
                                  .select { |a| a.amount >= 10 }
```
