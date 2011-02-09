require 'cgi'
require 'base64'
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
    # @param [String, Fixnum, #each] data The data to URL encode
    # @param [Boolean] all Whether to encode the whole string or only the
    #   necessary parts (default is false). If the data is not a string, it will
    #   always be fully encoded at the moment.
    # @return [String] the URL encoded string
    def Std::url(data, all=false)
      if all || (data.class != String)
        Std::hex_as_ary(data).map {|x| "%#{x}"}.join("")
      else
        CGI.escape(data)
      end
    end

    # Returns the base64 representation of the given data
    #
    # @param [String] bin The data to encode in base64
    # @param [Boolean] split whether to split lines with newlines or not (default is false)
    # @param [Boolean] htmlsafe whether to encode the string url-safe
    # @return [String] Base64 encoded string of the given data
    def Std::b64(bin, split=false, htmlsafe=false)
      if htmlsafe
        b64 = Base64.urlsafe_encode64(bin)
      else
        b64 = [bin].pack("m").chomp
      end
      b64.gsub!("\n", "") unless split
      return b64
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

    # Returns the SHA1 encoded (hex) string of the given string
    #
    # @param [String] data The string to transform
    # @param [Boolean] raw Wether to return the raw data if true or the hex
    #   string (default: false)
    # @return [String] SHA1 encoded string (hex)
    def Std::sha1(data, raw=false)
      if raw
        Digest::SHA1.digest(data)
      else
        Digest::SHA1.hexdigest(data)
      end
    end

    # Returns the MD5 encoded (hex) string of the given string
    #
    # @param [String] data The string to transform
    # @param [Boolean] raw Wether to return the raw data if true or the hex
    #   string (default: false)
    # @return [String] MD5 encoded string (hex)
    def Std::md5(data, raw=false)
      if raw
        Digest::MD5.digest(data)
      else
        Digest::MD5.hexdigest(data)
      end
    end

    # Returns the hex representation of data
    #
    # @param [String, Fixnum, #each] data The data to transform
    # @return [String] Hex representation of data
    def Std::hex(data)
      Std::hex_as_ary(data).join("")
    end

    # Returns the hex representation of data
    #
    # @param [String, Fixnum, #each] data The data to transform
    # @return [Array] Hex representation of data
    def Std::hex_as_ary(data)
      func = nil
      res = []
      if data.respond_to? 'each'
        func = :each
      elsif data.class == String
        func = :each_byte
      end
      if func
        data.send(func) do |x|
          res << Std::hex_char(x)
        end
      else
        res = [Std::hex_char(data)]
      end
      res
    end

    # Returns the hex representation of an Integer. Also accepts a one
    # character string.
    #
    # @param [Char, Fixnum] data The data to transform
    # @return [String] Hex representation of data
    def Std::hex_char(data)
      return "%02X" % data.ord
    end

    # Returns the integer ordinals of a string
    #
    # @param [String] data The string to encode
    # @return [Array<Fixnum>] Array of Integers
    def Std::ord_as_ary(data)
      data.unpack("c*")
    end

    # Substitutes whitespace with /**/ comments .
    #
    # @param [String] data The statement to encode
    # @return [String] the encoded statement
    def Std::comment(data)
      data.gsub!(/\s+/, "/**/")
    end
  end

  # PHP encoders
  module PHP
    # Encodes a string as PHP CHARs, e.g. chr(98).chr(99).chr(100)
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def PHP::chr(data)
      Std::ord_as_ary(data).map do |x|
        "chr(#{x})"
      end.join(".")
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
      Std::ord_as_ary(data).map do |x|
        "&##{x};"
      end.join
    end

    # HTML hex encodes a string
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def HTML::hex(data)
      Std::hex_as_ary(data).map do |x|
        "&#x" + x + ";"
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
      "string.fromCharCode(" + Std::ord_as_ary(data).join(",") + ")"
    end
  end

  # Encoders returning valid MySQL strings.
  module MySQL
    # Returns the MySQL hex representation of data
    #
    # @param [String] data The data to transform
    # @return [String] MySQL hex representation of data
    def MySQL::hex(data)
      return "0x#{Std::hex(data)}"
    end

    # Encodes a string as MySQL CHAR, e.g. CHAR(98,99,100)
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def MySQL::char(data)
      "CHAR(" + Std::ord_as_ary(data).join(",") + ")"
    end
  end

  # Encoders returning valid MSSQL strings.
  module MSSQL
    # Encodes a string as MSSQL CHARs, e.g. CHAR(98)+CHAR(99)+CHAR(100)
    #
    # @param [String] data The string to encode
    # @return [String] The encoded string
    def MSSQL::char(data)
      Std::ord_as_ary(data).map do |x|
        "CHAR(#{x})"
      end.join("+")
    end
  end
end
