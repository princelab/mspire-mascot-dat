require 'mspire/mascot/dat/index'
require 'mspire/mascot/dat/peptide'
require 'mspire/mascot/dat/query'

module Mspire
  module Mascot
    class Dat
      # the io object which is the open dat file
      attr_accessor :io

      # the index object which points to the start byte for each section
      attr_accessor :index

      def initialize(io)
        @io = io
        @index = Index.new(@io)
      end

      def self.open(file, &block)
        io = File.open(file)
        response = block.call(self.new(io))
        io.close
        response
      end

      # positions io at the beginning of the section data (past the Content
      # type and blank line). If given an integer, interprets it as a query
      # number. returns self
      def start_section!(name)
        @io.pos = @index[name]
        self
      end

      def query(n)
        start_section!(n)
        Query.from_io(@io)
      end

      def each_peptide(non_decoy=true, top_n=Float::INFINITY, &block)
        return to_enum(__method__, non_decoy, top_n) unless block
        start_section!(non_decoy ? :peptides : :decoy_peptides)
        Mspire::Mascot::Dat::Peptide.each_peptide(@io) do |peptide|
          if peptide.peptide_num <= top_n
            block.call(peptide) 
          end
        end
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

    end
  end
end
