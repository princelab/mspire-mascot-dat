
%w(
  index 
  peptide 
  query 
  protein
  parameters 
  header masses
).each do |subsection|
  require "mspire/mascot/dat/#{subsection}"
end

module Mspire
  module Mascot
    class Dat

      class << self

        # reads each line from a section until reaching the end of the section
        def each_line(io, &block)
          return to_enum(__method__, io) unless block
          io.each_line do |line|
            break if line[0,2] == '--'
            block.call(line)
          end
        end

        # returns the key and value for KEY=VAL sections
        def each_key_val(io, &block)
          return to_enum(__method__, io) unless block
          each_line(io) do |line|
            line.chomp!
            (key, val) = line.split('=',2)
            block.call( [key, (val=='' ? nil : val)] )
          end
        end

        def string(io, &block)
          each_line(io).to_a.join
        end

        # returns the string after stripping off leading and trailing double
        # quotation marks
        def strip_quotes(string)
          string.gsub(/\A"|"\Z/, '')
        end
        
      
        def open(file, index_file=false, &block)
          io = File.open(file)
          response = block.call(self.new(io, index_file))
          io.close
          response
        end

      end


      # the io object which is the open dat file
      attr_accessor :io

      # the index object which points to the start byte for each section
      attr_accessor :index

      # if index_file is true, will attempt to use a written index file
      # based on naming conventions; if one doesn't yet exist it will create
      # one for the next usage.  If handed a String, will consider it the
      # index filename for reading or writing depending on whether it exists.
      def initialize(io, index_file=false)
        @io = io
        index_filename = 
          case index_file
          when String then index_file
          when TrueClass then Dat::Index.index_filename(io.path)
          else
            nil
          end
        @index = Index.new
        if index_filename && File.exist?(index_filename)
          @index.from_byteindex!(index_filename)
        else
          @index.from_io!(@io)
        end

        if index_filename && !File.exist?(index_filename)
          @index.write(index_filename)
        end
      end

      # the univeral way to access information
      # returns the section with appropriate cast (if available) or as a
      # String object with the information. nil if it doesn't exist.  Also
      # responds to :query by calling Query::each
      def section(*args, &block)
        # If the name exists as a class, then try to call the from_io method
        # on the class (e.g., Parameters.from_io(io)). If the name is a
        # plural, try the singular and the ::each method on the singular class
        # (e.g., Peptide::each).
        name = args.first.to_sym
        capitalized = name.to_s.capitalize
        maybe_singular = 
          case capitalized
          when 'Queries'
            'query'
          else
            start_section!(name)
            capitalized[0...-1]
          end
        maybe_iterator = "each_#{maybe_singular.downcase}".to_sym
        if self.respond_to?(maybe_iterator)
          self.send(maybe_iterator, *args[1..-1], &block)
        elsif Mspire::Mascot::Dat.const_defined?(capitalized)
          klass = Mspire::Mascot::Dat.const_get(capitalized)
          obj = klass.new
          if obj.respond_to?(:from_io!)
            case name
            when :parameters, :masses
              obj.send(:from_io!, @io, false)
            else
              obj.send(:from_io!, @io)
            end
          else
            nil
          end
          #elsif Mspire::Mascot::Dat.const_defined?(maybe_singular)
          #  klass = Mspire::Mascot::Dat.const_get(maybe_singular)
          #  klass.send(:each, @io, &block)
        elsif @index.byte_num.key?(name)
          Mspire::Mascot::Dat.string(@io)
        else
          nil
        end
      end

      alias_method :[], :section

      def each_protein(&block)
        return to_enum(__method__) unless block
        start_section!(:proteins)
        Dat.each_key_val(@io) do |key, val|
          (mw_s, desc) = val.split(',', 2)
          block.call(Dat::Protein.new(Dat.strip_quotes(key), mw_s.to_f, Dat.strip_quotes(desc)))
        end
      end

      def each_query(&block)
        return to_enum(__method__) unless block
        @index.query_nums.each do |query_num| 
          byte = @index.query_num_to_byte[query_num]
          @io.pos = byte
          block.call( Mspire::Mascot::Dat::Query.new.from_io!(@io) )
        end
      end

      # positions io at the beginning of the section data (past the Content
      # type and blank line). If given an integer, interprets it as a query
      # number. returns self
      def start_section!(name)
        @io.pos = @index[name]
        self
      end

      # returns query number n (these are NOT zero indexed)
      def query(n)
        start_section!(n)
        Query.new.from_io!(@io)
      end

      # optional parameters, passed in any order: 
      #
      #     top_n: [Float::INFINITY] a Numeric (top N hits)
      #     non_decoy: [true] a Boolean 
      #
      # Returns the top_n hits.  If non_decoy is false or nil, returns the
      # decoy hits.
      #
      #     each_peptide(false, 1) # top decoy peptide hit
      #     each_peptide(2, true)  # top 2 peptide hits per query
      #     each_peptide(1)        # top peptide hit per query
      def each_peptide(*args, &block)
        return to_enum(__method__, *args) unless block
        (numeric, boolean) = args.partition {|arg| arg.is_a?(Numeric) }
        top_n = numeric.first || Float::INFINITY
        non_decoy = ((boolean.size > 0) ? boolean.first : true)
        start_section!(non_decoy ? :peptides : :decoy_peptides)
        Mspire::Mascot::Dat::Peptide.each(@io) do |peptide|
          if peptide.peptide_num <= top_n
            block.call(peptide) 
          end
        end
      end

      def each_decoy_peptide(top_n=Float::INFINITY, &block)
        each_peptide(false, top_n, &block)
      end

      # returns a list of all sections as symbols. The symbol :queries is
      # returned rather than each query individually if their is 1 or more
      # queries.
      def sections
        reply = @index.byte_num.keys
        if @index.has_queries?
          reply.push('queries')
        end
        reply.map(&:to_sym)
      end

      alias_method :keys, :sections

    end
  end
end
