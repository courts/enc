# coding: utf-8
require 'bacon'
require 'enc/dec'

include Dec

describe Dec do

  before do
    @url_text = "http://www.example.com?aa=bb&cc=dd"
    @sql_text = "SELECT * FROM users WHERE id = '1' AND pass='password'"
    @utf8_text = "aabbäöü"
  end

  it "should return a URL decoded string (either fully or only partially) when sent Std::url()" do
    Std::url('http%3A%2F%2Fwww.example.com%3Faa%3Dbb%26cc%3Ddd').should.equal @url_text
    Std::url('%68%74%74%70%3A%2F%2F%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D%3F%61%61%3D%62%62%26%63%63%3D%64%64').should.equal @url_text
  end

  it "should return a URL decoded string of the raw data's bytes when sent Std::url_raw()" do
    # "unpack" is used here as a workaround for encoding problems preventing equality comparison
    Std::url_raw('%41%42%EF%FF').unpack("H*").should.equal "\x41\x42\xEF\xFF".unpack("H*")
  end

  it "should return a base64 representation of any binary data given to Std::b64()" do
    Std::b64("dGVzdA==").should.equal "test"
  end

  it "should return the binary represenation of hex data if sent Std::hex()" do
    Std::hex("687474703A2F2F7777772E6578616D706C652E636F6D3F61613D62622663633D6464").should.equal @url_text
  end

  it "should return the binary string from a comma separated hex representation when sent Std::charcode()" do
    Std::charcode('104,116,116,112,58,47,47,119,119,119,46,101,120,97,109,112,108,101,46,99,111,109,63,97,97,61,98,98,38,99,99,61,100,100').should.equal @url_text
  end

  it "should return an HTML unescaped string when sent HTML::html()" do
    HTML::html("http://www.example.com?aa=bb&amp;cc=dd").should.equal @url_text
  end

  it "should return a decoded MSSQL CHAR representation when sent MSSQL::char()" do
    MSSQL::char('CHAR(83)+CHAR(69)+CHAR(76)+CHAR(69)+CHAR(67)+CHAR(84)+CHAR(32)+CHAR(42)+CHAR(32)+CHAR(70)+CHAR(82)+CHAR(79)+CHAR(77)+CHAR(32)+CHAR(117)+CHAR(115)+CHAR(101)+CHAR(114)+CHAR(115)+CHAR(32)+CHAR(87)+CHAR(72)+CHAR(69)+CHAR(82)+CHAR(69)+CHAR(32)+CHAR(105)+CHAR(100)+CHAR(32)+CHAR(61)+CHAR(32)+CHAR(39)+CHAR(49)+CHAR(39)+CHAR(32)+CHAR(65)+CHAR(78)+CHAR(68)+CHAR(32)+CHAR(112)+CHAR(97)+CHAR(115)+CHAR(115)+CHAR(61)+CHAR(39)+CHAR(112)+CHAR(97)+CHAR(115)+CHAR(115)+CHAR(119)+CHAR(111)+CHAR(114)+CHAR(100)+CHAR(39)').should.equal @sql_text
  end

end
