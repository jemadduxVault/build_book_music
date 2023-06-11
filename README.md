
# Building the Gem
gem build build_book_music.gemspec

# Installing the Gem
gem install build_book_music

# Running the Gem
build_book_music 1.json 2.json 3.json

Or if you haven't installed the gem....

ruby -Ilib ./bin/build_book_music spotify.json changes.json output.json

# Testing
rake test
