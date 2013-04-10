require 'json'

module Mspire
  module Mascot
    class Dat
      # makes a byte index (not line index) 
      class Index

        INDEX_EXT = '.byteindex'

        class << self
          def index_filename(file)
            file + Dat::INDEX_EXT
          end
        end

        # the hash holding the start byte for each section (besides the
        # queries).  Keyed by symbol.
        attr_accessor :byte_num

        # the array holding the start byte for each query.  It is indexed by
        # query number, so the first 
        attr_accessor :query_num_to_byte

        # an array of the query nums
        attr_accessor :query_nums


        # if handed an index_bytefile it will open the filename and use that
        # for the index
        def initialize
          @byte_num = {}
          @query_num_to_byte = []
          @query_nums = []
        end

        def has_queries?
          @query_nums.size > 0
        end

        # returns self
        def from_byteindex!(filename)
          hash = JSON.parse!(filename)
          [:byte_num, :query_num_to_byte, :query_nums].each do |key|
            self.send("#{key}=", hash[key])
          end
          self
        end

        def write(filename)
          File.open(filename,'w') do |io|
            JSON.dump(
              {
              byte_num: byte_num,
              query_num_to_byte: query_num_to_byte,
              query_nums: query_nums,
            }, io)
          end
        end

        def from_file!(filename)
          File.open(filename) {|io| from_io!(io) }
        end

        # returns self
        def from_io!(io)
          io.rewind
          while line=io.gets
            io.each_line do |line|
              if md=/^Content-Type: application\/x-Mascot; name=["'](\w+)["']/.match(line)
                head = md[1]
                io.gets # the newline
                pos = io.pos

                if qmd=/query(\d+)/.match(head)
                  query_num = qmd[1].to_i
                  @query_nums << query_num                
                  @query_num_to_byte[query_num] = pos
                else
                  @byte_num[head.to_sym] = pos
                end
              end
            end
          end
          io.rewind

          @query_nums.freeze
          @query_num_to_byte.freeze
          @byte_num.freeze
          self
        end

        # given a string or symbol, looks up the start line.  Given an
        # Integer, assumes it is a query num and returns the start line of the
        # query number.
        def [](key)
          if key.is_a?(Integer) 
            @query_num_to_byte[key]
          else
            @byte_num[key.to_sym]
          end
        end

        # nil if the query is out of bounds
        def query(n)
          @query_num_to_byte[n]
        end

      end
    end
  end
end

#--gc0p4Jq0M2Yt08jU534c0p
#Content-Type: application/x-Mascot; name="index"

#parameters=4
#masses=78
#unimod=119
#enzyme=484
#header=492
#summary=507
#peptides=820
#proteins=853
#query1=858
#query2=871
#--gc0p4Jq0M2Yt08jU534c0p--
