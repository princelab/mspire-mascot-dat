require 'elif'

module Mspire
  module Mascot
    class Dat
      class Index

        # the hash holding the start byte for each section (besides the
        # queries)
        attr_accessor :byte_num

        # the array holding the start byte for each query.  It is indexed by
        # query number, so the first 
        attr_accessor :byte_num_by_query_num

        # an array of the query nums
        attr_accessor :query_nums

        def initialize(file)
          @byte_num = {}
          @byte_num_by_query_num = []
          @query_nums = []
          from_file(file)
        end

        # returns self
        def from_file(file)
          lines = []
          Elif.foreach(file) do |line|
            break if line =~ /^Content-Type:/
              lines << line
          end
          lines.reverse!
          lines.pop
          lines.each do |line|
            (header, byte_num_s) = line.split('=')
            if md=header.match(/^query(\d+)/)
              query_num = md[1].to_i
              @query_nums << query_num
              @byte_num_by_query_num[query_num] = byte_num_s.to_i
            else
              @byte_num[header] = byte_num_s.to_i
            end
          end
          @byte_num.freeze
          @byte_num_by_query_num.freeze
          self
        end

        # given a string or symbol, looks up the start byte.  Given an
        # Integer, assumes it is a query num and returns the start byte of the
        # query number.
        def [](key)
          if key.is_a?(Integer) 
            @byte_num_by_query_num[key]
          else
            @byte_num[key.to_s]
          end
        end

        # raises an IndexError if the query is out of bounds
        def query(n)
          @byte_num_by_query_num.fetch(n)
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
