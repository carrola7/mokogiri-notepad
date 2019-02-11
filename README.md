# What is nokogiri-notepad?

Nokogiri-notepad is a Ruby Gem for easily extracting information from an xml file according the paths provided by Notepad++

# Installation

To download the gem do

```
gem install 'nokogiri-notepad'
```

or to include it in your gemfile do

```ruby
# Gemfile

gem 'nokogiri-notepad'
```

and then do `bundle install`

# Usage

First create a parser object. This parser object takes three mandatory arguments and one optional.

The mandatory arguments are: 
 
- file_path -> This is the absolute path to the xml file you want to process
- single_targets -> This is a hash containing with:
  - keys being the names of the methods you would like available on the parser instance
  - values being the path given to you by Notepad++ (by highlighting the value of the node and clicking `Ctrl + Shift + Alt + P`). Note they are always given as an array.
- multiple targets -> Sometimes a path will give you multiple nodes back. This hash is similar in construction to the single_targets except it will give you a method that will return an array of strings
- The Parser initalize method will only accept files with an xml extension by default. You can add an array of extensions to be accepted instead if you wish

### Example `target_hash`

```xml
<plane>
   <year> 1977 </year>
   <make> Cessna </make>
   <model> Skyhawk </model>
   <color> Light blue and white </color>
</plane>
```

If we want to target "1977" and "Cessna" saved on our `parser` instance our `single_target` hash would contain

```ruby
single_targets = { "year" => ["/plane/year"], "make" => ["/plane/make"] }
```

Our parser instance would then have the following attributes

```ruby
parser.year // "1977"
parser.make // "Cessna"
```

Sometimes we can get more complex xml files like below, where it is more difficult to target specific nodes. Let's say we want to target the "Tripacer" node. We would need to specify a node in the group that is unique. This will give us the group of nodes, from which we can access our target node. If we just give the path `planes/plane/model` this leads us to both "Centurian" and "Tripacer", which is not what we want. Instead we can do

```ruby
single_targets = { "model" => ["/planes/plane/foo", "four", "model"] }
```

```xml
<planes>
   <plane>
      <foo> three </foo>      
      <year> 1960 </year>
      <make> Cessna </make>
      <model> Centurian </model>
      <color> Yellow and white </color>
   </plane>
   <plane>
      <foo> four </foo>
      <year> 1956 </year>
      <make> Piper </make>
      <model> Tripacer </model>
      <color> Blue </color>
   </plane>
</planes>
```

If we wanted to capture both "Centurian" and "Tripacer" above we would define the path in our multiple_targets hash

```ruby
multiple_targets = { "model" => ["/planes/plane/model"] }
```

This would give us the following getter method available on our instance

```ruby
parser.model // ["Centurian", "Tripacer"]
```


