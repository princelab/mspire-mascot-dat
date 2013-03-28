# mspire-mascot-dat

Reads the mascot search engine .dat results file.

## Examples

```ruby
require 'mspire-mascot-dat'

Mspire::Mascot::Dat.open(file.dat) do |dat|
  dat.sections  # => [:parameters, :masses, :unimod, :enzyme ...]
end

```
### each peptide

#### every peptide hit

```ruby
dat.each_peptide do |pephit|
  pephit.missed_cleavages # => an Integer
  pephit.ions_score # => a Float
  ...
end
```

#### every decoy peptide hit

```ruby
dat.each_peptide(false) {|pephit| ... }
```

#### each top peptide hit

```ruby
dat.each_peptide(true, 1) {|pephit| ... }
```

## Further Info

See Mascot's Installation & Setup Manual' for detailed information about the
.dat format itself.

## Copyright

MIT.  See LICENSE.txt
