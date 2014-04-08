Ruby Parser for SKS Keydump

This gem parses the SKS Keydump into a hash which looks like this:

dump_hash = {
        hex_key_id => {
            :user => "Name, <email@email.com>",
            :sigs => ["hex_key_id1", "hex_key_id2",...]
                      }
            }


What You Need
-------------

- gpg  (brew install gpg)
- wget (brew install wget)
- in your Gemfile, gem 'sks_dump_parser'

Download the keydump as specified at: http://www.keysigning.org/sks/
to get all the files. It will take a while. Be sure your directory contains only the pgp files.

A call to SksParser.parse_dump('name_of_your_dir') returns your useful hash.

