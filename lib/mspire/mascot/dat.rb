require 'mspire/mascot/dat/index'
require 'mspire/mascot/dat/peptide'

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
        block.call(self.new(io))
        io.close
      end

      # positions io at the beginning of the section data (past the Content
      # type and blank line). returns self
      def start_section!(name)
        @io.pos = @index[name]
        p @io.pos
        puts "READING:"
        3.times { p @io.readline }
        puts "NOW: "
        p @io.pos
        self
      end

      def each_peptide(&block)
        start_section!(:peptides)
        while peptide = Peptide.from_io(@io)
          p peptide
          block.call(peptide)
        end
        puts "ENDED!"
      end

      # returns a list of all sections as symbols. The symbol :queries is
      # returned rather than each query individually if their is 1 or more
      # queries.
      def sections
        reply = @index.byte_num.keys
        if @index.has_queries?
          reply.push(:queries)
        end
        reply
      end

    end
  end
end
