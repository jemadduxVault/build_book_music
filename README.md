
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

# Thoughts
To scale this up:
- Load the files into a relational database and change the #change_data method to work on that database instead of directly on the loaded hash. At scale a large hash in Ruby will just eat up all the computer's RAM and freeze. 
Design decision:
- Making this a ruby gem instead of justa flat ruby file took a few minutes more but I think it was the correct way to go. Making it a Gem gives you a way to version and distribute it even if you are just distributing it internally within the company.
Time taken: 
- Took as long as the git logs show. About 2 hours with a couple short breaks.
