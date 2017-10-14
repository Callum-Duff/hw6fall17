
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect(Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
      
      it 'should return a non-empty array with valid search option' do
        return_val = Movie.find_in_tmdb('American Psycho')
        #return_val.each do |movie|
          #puts '--------------------------------'
          #puts "Title: #{movie[:title]}"
          #puts "ID: #{movie[:tmdb_id]}"
          #puts movie[:rating]
          #puts movie[:release_date]
        #end
        #puts '---------------------------------'
        #end
        expect(return_val).not_to be_empty
      end
      
      it 'should return an empty array with a nonsense search option' do
        return_val = Movie.find_in_tmdb('gobbledygook')
        expect(return_val).to be_empty
      end
      
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
end
