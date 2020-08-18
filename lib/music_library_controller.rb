class MusicLibraryController
  attr_accessor :path

  def initialize(path='./db/mp3s')
    @path = path
    new_importer_object = MusicImporter.new(path)
    new_importer_object.import
  end

  def call
    input = ''
    while input != "exit"
      puts "Welcome to your music library!"
      puts "To list all of your songs, enter 'list songs'."
      puts "To list all of the artists in your library, enter 'list artists'."
      puts "To list all of the genres in your library, enter 'list genres'."
      puts "To list all of the songs by a particular artist, enter 'list artist'."
      puts "To list all of the songs of a particular genre, enter 'list genre'."
      puts "To play a song, enter 'play song'."
      puts "To quit, type 'exit'."
      puts "What would you like to do?"

      input = gets.strip

      case input
      when "list songs"
        list_songs
      when "list artists"
        list_artists
      when "list genres"
        list_genres
      when "list artist"
        list_songs_by_artist
      when "list genre"
        list_songs_by_genre
      when "play song"
        play_song
      end
    end
  end

  def list_songs
    Song.all.uniq.sort_by(&:name).each.with_index(1) do |song, i|
      puts "#{i}. #{song.artist.name} - #{song.name} - #{song.genre.name}"
    end
  end

  def list_artists
    Artist.all.uniq.sort_by(&:name).each.with_index(1) do |artist, index|
      puts "#{index}. #{artist.name}"
    end
  end

  def list_genres
    Genre.all.uniq.sort_by(&:name).each.with_index do |genre, index|
      puts "#{index+1}. #{genre.name}"
    end
  end

  def list_songs_by_artist
    input = ''
    input = gets.strip
    puts "Please enter the name of an artist:"
    if artist = Artist.find_by_name(input)
      artist.songs.sort{|a, b| a.name <=> b.name}.each_with_index do |s, i|
        puts "#{i+1}. #{s.name} - #{s.genre.name}"
      end
    end
  end

  def list_songs_by_genre
    input = ''
    input = gets.strip
    puts "Please enter the name of a genre:"


    if genre = Genre.find_by_name(input)
      genre.songs.sort{|a, b| a.name <=> b.name}.each_with_index do |s, i|
        puts "#{i+1}. #{s.artist.name} - #{s.name}"
      end
    end
  end

  def play_song
      puts "Which song number would you like to play?"
      song_num = gets.strip.to_i
      return if song_num < 1 || song_num > Song.all.length
      song = Song.all.uniq.sort{|a,b| a.name <=> b.name}[song_num - 1]
      # binding.pry
      if !!song
        puts "Playing #{song.name} by #{song.artist.name}"
      end
    end

end
