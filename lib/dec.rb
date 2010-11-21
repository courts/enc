# coding: utf-8
require 'cgi'
require 'yaml'
require 'digest/sha1'
require 'digest/md5'

# This module implements the decoders complementary to the encoders in enc.rb
# (where it makes sense).
#
# This software is licensed under the Creative
# Commons CC0 1.0 Universal License.
# To view a copy of this license, visit
# http://creativecommons.org/publicdomain/zero/1.0/legalcode
#
# @author Patrick Hof
module Dec

  # Contains all decoders not fitting into a specific category.
  module Std
    # Returns a URL decoded string
    #
    # @param [String] data The data to URL decode
    # @return [String] the URL decoded string
    def Std::url(data)
      CGI.unescape(data)
    end

    # Returns the raw bytes of a URL encoded string
    #
    # @param [String] data The data to URL decode
    # @return [String] the raw bytes
    def Std::url_raw(data)
      data = data.split("%")
      data[1..-1].pack("H2"*(data.length - 1))
    end

    # Returns the decoded base64 string
    #
    # @param [String] bin The data to decode in base64
    # @return [String] Base64 decoded string of the given data
    def Std::b64(bin)
      bin.unpack("m")[0]
    end

    # Returns the decoded hex representation of data
    #
    # @param [String] data The hex data to decode
    # @return [String] Hex decoded data
    def Std::hex(data)
      res = ""
      data = data.split("")
      until data.empty?
        res << data.shift(2).join().hex.chr
      end
      res
    end

    # Decodes a string of comma separated character codes, e.g.
    # "98,99,100"
    #
    # @param [String] data The string to decode
    # @return [String] The decoded string
    def Std::charcode(data)
      data.split(/,\s*/).map {|x| x.to_i.chr}.join()
    end
  end

  # Encoders converting strings to valid HTML.
  module HTML
    # HTML decodes a string
    #
    # @param [String] data The string to decode
    # @return [String] The decoded string
    def HTML::html(data)
      CGI.unescapeHTML(data)
    end
  end

  # Encoders returning valid MSSQL strings.
  module MSSQL
    # Decodes an MSSQL CHARs string, e.g. CHAR(98)+CHAR(99)+CHAR(100)
    #
    # @param [String] data The string to decode
    # @return [String] The decoded string
    def MSSQL::char(data)
      data = data.split("+")
      data.map{|x| x =~ /CHAR\((\d+)\)/; $1.to_i.chr}.join()
    end
  end
end
