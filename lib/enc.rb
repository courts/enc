require 'cgi'
require 'yaml'
require 'digest/sha1'
require 'digest/md5'

# This module implements commonly used (string) encoders for various occasions.
#
# This software is licensed under the Creative
# Commons CC0 1.0 Universal License.
# To view a copy of this license, visit
# http://creativecommons.org/publicdomain/zero/1.0/legalcode
#
# @author Patrick Hof
module Enc

  # Contains all encoders not fitting into a specific category.
  module Std
    # Returns a URL encoded string
    #
    # @param [String] data The data to URL encode
    # @param [Boolean] all Whether to encode the whole string or only the
    #   necessary parts (default is false)
    # @return [String] the URL encoded string
    def Std::url(data, all=false)
      if all
        data.split("").map do |x|
          "%" + x.unpack('H*')[0]
        end.join.upcase
      else
        CGI.escape(data)
      end
    end

    # Returns a URL encoded string of the given data's raw bytes
    #
    # @param [String] data The data to URL encode
    # @return [String] the URL encoded string
    def Std::url_raw(data)
      res = ""
      data.each_byte do |x|
        res << ("%" + (sprintf "%02X" % x))
      end
      res.upcase
    end

    # Returns the base64 representation of the given data
    #
    # @param [String] bin The data to encode in base64
    # @return [String] Base64 encoded string of the given data
    def Std::b64(bin)
      [bin].pack("m").chomp
    end

    # XOR a string with another string
    #
    # Adapted from
    # http://rubyforge.org/snippet/detail.php?type=snippet&id=108
    #
    # @param [String] data The original string
    # @param [String] key The string to XOR with
    # @return [String] the XOR'ed string
    #
    def Std::xor(data, key)
      data.length.times {|x| data[x] = (data[x].ord ^ (key[x % key.length]).ord).chr }
      return data
    end

    # Takes a string and returns the string with randomly uppercased characters
    #
    # @param [String] data The string to transform
    # @return [String] The string with randomly uppercased characters
    def Std::rand_upcase(data)
      data.split("").map do |x|
        if rand(2) == 0 then x.upcase else x end
      end.join
    end
    # Returns the SHA1 encoded hex string of the given string
    #
    # @param [String] data The string to transform
    # @return [String] SHA1 encoded string (hex)
    def Std::sha1(data)
      Digest::SHA1.hexdigest(data)
    end

    # Returns the MD5 encoded hex string of the given string
    #
    # @param [String] data The string to transform
    # @return [String] MD5 encoded string (hex)
    def Std::md5(data)
      Digest::MD5.hexdigest(data)
    end

    # Returns the hex representation of data
    #
    # @param [String] data The data to transform
    # @return [String] Hex representation of data
    def Std::hex(data)
      data.unpack('H*')[0].upcase
    end
  end

  # Encoders converting strings to valid HTML.
  module HTML
    # HTML encodes a string
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def HTML::html(data)
      CGI.escapeHTML(data)
    end

    # Decimal HTML encodes a string (e.g. "a" => &#97;
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def HTML::dec(data)
      data.unpack("c*").map do |x|
        "&##{x};"
      end.join
    end

    # HTML hex encodes a string
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def HTML::hex(data)
      data.split("").map do |x|
        "&#x" + x.unpack('H*')[0].upcase + ";"
      end.join
    end
  end

  # JavaScript encoders.
  module JS
    # Encodes a string with JavaScript string.fromCharCode(), e.g.
    # string.fromCharCode(98,99,100)
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def JS::charcode(data)
      "string.fromCharCode(" + data.unpack("c*").join(",") + ")"
    end
  end

  # Encoders returning valid MySQL strings.
  module MySQL
    # Encodes a string as MySQL CHAR, e.g. CHAR(98,99,100)
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def MySQL::char(data)
      "CHAR(" + data.unpack("c*").join(",") + ")"
    end

    # Substitutes whitespace with MySQL comments .
    #
    # @param [String] data The statement to encode
    # @return [String] the encoded statement
    def MySQL::comment(data)
      data.gsub!(/\s+/, "/**/")
    end
  end

  # Encoders returning valid MSSQL strings.
  module MSSQL
    # Encodes a string as MSSQL CHARs, e.g. CHAR(98)+CHAR(99)+CHAR(100)
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def MSSQL::char(data)
      data.unpack("c*").map do |x|
        "CHAR(#{x})"
      end.join("+")
    end
  end
end
