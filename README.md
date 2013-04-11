# mspire-mascot-dat

Access mascot search engine .dat results file.

* Simple interface
* Lazy reading from IO object
* Object access of key data types
* Data casts where appropriate

Pull requests (or requests for features) gladly accepted.

[API of latest version](http://rubydoc.info/gems/mspire-mascot-dat)

## Synposis

A Dat object reads information off an open IO object as lazily as possible.
The sections can be accessed like a hash.

```ruby
require 'mspire-mascot-dat'

Mspire::Mascot::Dat.open(file.dat) do |dat|
  dat.keys # (or dat.sections) => [:parameters, :masses, ...]
  
  dat[:peptides].each do |peptide|
    # or:    dat.each_peptide {|peptide| ... }
    # data is properly cast
    peptide.delta             # => a Float
    peptide.missed_cleavages  # => an Integer
  end

  dat[:queries].each do |query|
    query.title   # => a String (unescaped)
  end

  dat[:proteins].each do |protein|
    protein.accession
  end

  # or random query access
  dat.query(22)   # returns query #22

  # sections with uppercase params are typically accessed by string
  params = dat[:parameters]
  params['CHARGE'] # => an Integer

  # sections with lowercase params are accessed by symbol
  header = dat[:header]
  header[:sequences] # => an Integer

  # sections that aren't normal key/value pairs returned as a String
  dat[:unimod]   # => a String containing lots of XML
  dat[:enzyme]   # => a String with enzyme data
end
```

Note that no support is given for accessing the 'summary' sections because they are often incomplete for large files anyway and the information can all be found by accessing the 

### Enumerable information

Sections with enumerable objects may be accessed as each_<whatever> or with
Dat#[], which returns an enumerable.  So, these are equivalent:

```ruby
dat.each_peptide {|pep| ... }
dat[:peptides].each {|pep| ... }

# these also are equivalent (return an enumerator)
enumerator = dat.each_peptide
enumerator = dat[:peptides]
```

Enumerators for some objects will have additional parameters that may be passed in (to either method style).  For instance, the user may retrieve the top **n** peptide hits:

```ruby
dat.each_peptide(1) {|peptide| ... } # only top peptide hits
```

### Queries

In a dat file, each query is its own section, but this makes them fairly
awkward to access.  We treat them as if they were grouped into a single
section.

```ruby
dat[:queries].each do |query|
  # hash or method access
  query[:charge] # => a positive or negative Integer
  query.charge 
  query.Ions1 # or query.peaks
end
```

But they can also be accessed by query number:

```ruby
dat.query(23)  # return query23
```

### Decoys

Decoy peptides may be accessed a few different ways, all of which are equivalent:

```ruby
dat.each_peptide(false)    {|peptide| ... }
dat[:peptides, false].each {|peptide| ... }
dat.each_decoy_peptide     {|peptide| ... }
dat[:decoy_peptides].each  {|peptide| ... }
```

## Further Info

See the specs for additonal examples. 

Also, see Mascot's "Installation & Setup Manual" for detailed information
about the .dat format itself (can be accessed from the mascot main page
of whichever mascot you are using).

## Copyright

MIT.  See LICENSE.txt
