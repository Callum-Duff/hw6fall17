class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  
#  def self.find_in_tmdb(string)
#    begin
#      Tmdb::Movie.find(string)
#    rescue Tmdb::InvalidApiKeyError
#        raise Movie::InvalidKeyError, 'Invalid API key'
#    end
#  end
  def self.find_in_tmdb(search_string)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    begin
        search_result_array = Tmdb::Movie.find(search_string)
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
    
    array_of_movie_hashes = []
    
    if not search_result_array.nil?
      search_result_array.each do |movie|
        current_hash = {}
        current_hash[:tmdb_id] = movie.id
        current_hash[:title] = movie.title
        movie_releases = Tmdb::Movie.releases(movie.id)["countries"]
        
        # If there is release data, parse it
        if not movie_releases.blank?
          # Find the ratings hash that pertains to the US
          # If there are multiple, choose the one that isn't blank
          movie_releases.each do |ratings_hash|
            if ratings_hash.has_value?('US') and ratings_hash["certification"] != ""
              current_hash[:rating] = ratings_hash["certification"]
              break
            end
          end
        else
          # If a US rating didn't exist, put a filler string in
          current_hash[:rating] = 'no rating'
        end
        
        # Create a set of accepted ratings
        accepted_ratings = Set.new ['R', 'PG-13', 'PG', 'G', 'NC-17', 'NR']
        
        # If the rating returned from the database is not accepted, remove it
        if not accepted_ratings.include?(current_hash[:rating])
          current_hash[:rating] = 'NR'
        end
        
        current_hash[:release_date] = movie.release_date
        array_of_movie_hashes << current_hash
      end
    end
    
    # Return the array of hashes
    return array_of_movie_hashes
    
  end
end
