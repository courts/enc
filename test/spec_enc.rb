# coding: utf-8
require 'bacon'
require File.join(File.dirname(__FILE__), '..', 'lib', 'enc')

include Enc

describe Enc do

  before do
    @url_text = "http://www.example.com?aa=bb&cc=dd"
    @sql_text = "SELECT * FROM users WHERE id = '1' AND pass='password'"
    @utf8_text = "aabbäöü"
  end

  it "should return a URL encoded string (either fully or only partially) when sent Std::url()" do
    Std::url(@url_text).should.equal 'http%3A%2F%2Fwww.example.com%3Faa%3Dbb%26cc%3Ddd'
    Std::url(@url_text, all=true).should.equal '%68%74%74%70%3A%2F%2F%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D%3F%61%61%3D%62%62%26%63%63%3D%64%64'
  end

  it "should return a URL encoded string of the raw data's bytes when sent Std::url_raw()" do
    Std::url_raw("\x00\x01\xEF\xFF").should.equal "%00%01%EF%FF"
  end

  it "should return a base64 representation of any binary data given to Std::b64()" do
    Std::b64("test").should.equal "dGVzdA=="
  end

  it "should return a base64 representation of any binary data given to Std::b64() and not split the lines" do
    Std::b64("A"*46).should.equal "QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQQ=="
  end

  it "should return a base64 representation of any binary data given to Std::b64() and split the lines" do
    Std::b64("A"*46, split=true).should.equal "QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB\nQQ=="
  end

  it "should return a transformed string with randomly uppercased characters with Std::rand_upcase()" do
    Std::rand_upcase(@url_text).downcase.should.equal @url_text
  end

  it "should return the SHA1 hex string when sent Std::sha1()" do
    Std::sha1(@url_text).should.equal "ba53d1abf6b7c2fec072379fcd312920c02152c1"
  end

  it "should return the MD5 hex string when sent Std::md5()" do
    Std::md5(@url_text).should.equal "052619cb4bae29861029b120f0b86d54"
  end

  it "should return the hex represenation of binary data if sent Std::hex()" do
    Std::hex(@url_text).should.equal "687474703A2F2F7777772E6578616D706C652E636F6D3F61613D62622663633D6464"
  end

  it "should XOR two strings when sent Std::xor()" do
    Std::xor(@url_text, "test").should.equal "\x1C\x11\a\x04NJ\\\x03\x03\x12]\x11\f\x04\x1E\x04\x18\x00]\x17\e\bL\x15\x15X\x11\x16R\x06\x10I\x10\x01"
  end

  it "should return an HTML escaped string when sent HTML::html()" do
    HTML::html(@url_text).should.equal "http://www.example.com?aa=bb&amp;cc=dd"
  end

  it "should return the decimal html representation of a string when sent HTML::dec()" do
    HTML::dec(@url_text).should.equal "&#104;&#116;&#116;&#112;&#58;&#47;&#47;&#119;&#119;&#119;&#46;&#101;&#120;&#97;&#109;&#112;&#108;&#101;&#46;&#99;&#111;&#109;&#63;&#97;&#97;&#61;&#98;&#98;&#38;&#99;&#99;&#61;&#100;&#100;"
  end

  it "should return the hexadecimal html representation of a string when sent HTML::hex()" do
    HTML::hex(@url_text).should.equal '&#x68;&#x74;&#x74;&#x70;&#x3A;&#x2F;&#x2F;&#x77;&#x77;&#x77;&#x2E;&#x65;&#x78;&#x61;&#x6D;&#x70;&#x6C;&#x65;&#x2E;&#x63;&#x6F;&#x6D;&#x3F;&#x61;&#x61;&#x3D;&#x62;&#x62;&#x26;&#x63;&#x63;&#x3D;&#x64;&#x64;'
  end

  it "should return a JavaScript string.fromCharCode() representation when sent JS::charcode()" do
    JS::charcode(@url_text).should.equal 'string.fromCharCode(104,116,116,112,58,47,47,119,119,119,46,101,120,97,109,112,108,101,46,99,111,109,63,97,97,61,98,98,38,99,99,61,100,100)'
  end

  it "should return a MySQL CHAR representation when sent MySQL::char()" do
    MySQL::char(@sql_text).should.equal 'CHAR(83,69,76,69,67,84,32,42,32,70,82,79,77,32,117,115,101,114,115,32,87,72,69,82,69,32,105,100,32,61,32,39,49,39,32,65,78,68,32,112,97,115,115,61,39,112,97,115,115,119,111,114,100,39)'
  end

  it "should return a string with spaces swapped for comments when sent MySQL::comment()" do
    MySQL::comment(@sql_text).should.equal "SELECT/**/*/**/FROM/**/users/**/WHERE/**/id/**/=/**/'1'/**/AND/**/pass='password'"
  end

  it "should return a MSSQL CHAR representation when sent MSSQL::char()" do
    MSSQL::char(@sql_text).should.equal 'CHAR(83)+CHAR(69)+CHAR(76)+CHAR(69)+CHAR(67)+CHAR(84)+CHAR(32)+CHAR(42)+CHAR(32)+CHAR(70)+CHAR(82)+CHAR(79)+CHAR(77)+CHAR(32)+CHAR(117)+CHAR(115)+CHAR(101)+CHAR(114)+CHAR(115)+CHAR(32)+CHAR(87)+CHAR(72)+CHAR(69)+CHAR(82)+CHAR(69)+CHAR(32)+CHAR(105)+CHAR(100)+CHAR(32)+CHAR(61)+CHAR(32)+CHAR(39)+CHAR(49)+CHAR(39)+CHAR(32)+CHAR(65)+CHAR(78)+CHAR(68)+CHAR(32)+CHAR(112)+CHAR(97)+CHAR(115)+CHAR(115)+CHAR(61)+CHAR(39)+CHAR(112)+CHAR(97)+CHAR(115)+CHAR(115)+CHAR(119)+CHAR(111)+CHAR(114)+CHAR(100)+CHAR(39)'
  end

end
