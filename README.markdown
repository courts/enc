Ruby Enc
========

Author:      Patrick Hof <courts@offensivethinking.org>  
License:     [CC0 1.0 Universal License](http://creativecommons.org/publicdomain/zero/1.0/legalcode)

Download:    git clone git@github.com:courts/enc.git  
YARD docs:   [http://courts.github.com/enc](http://courts.github.com/enc)

Two modules implementing commonly used string encoders and decoders for various
occasions. Their intended primary use is to include them in your scripts.  Basic
command line clients are included.

Command Line Usage
------------------

There is a basic command line client in the /bin directory. Usage:

    enc-cli <encoder> [params] <string from stdin>
    enc-cli -d <decoder> [params] <string from stdin>

See ``enc-cli -h`` for more information.

Examples
--------
    enc-cli Std::url <<< 'http://www.example.com?aa=bb&cc=dd'
    http%3A%2F%2Fwww.example.com%3Faa%3Dbb%26cc%3Ddd%0A

    enc-cli Std::url true <<< 'http://www.example.com?aa=bb&cc=dd'
    %68%74%74%70%3A%2F%2F%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D%3F%61%61%3D%62%62%26%63%63%3D%64%64%0A

    enc-cli -d Std::url <<< 'http%3A%2F%2Fwww.example.com%3Faa%3Dbb%26cc%3Ddd'
    http://www.example.com?aa=bb&cc=dd

Be aware of the trailing newline in the encoding example, which also gets
encoded. To get rid of it, use the ``-n`` option.

RubyGems
--------

A gemspec file is included, so you can build and install Enc as a gem with:

    gem build Enc.gemspec
    gem install Enc-x.x.x.gem

---

Inspired by:

*   [wfuzz][1]
*   [rbkb][2]

[1]: http://www.edge-security.com/wfuzz.php
[2]: http://github.com/emonti/rbkb
