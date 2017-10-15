require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering if search valid' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
    
    # Begin my test definitions:
    it 'should make the search terms requested available to that template' do
      fake_results = [double('Movie1'), double('Movie2')]
      allow(Movie).to receive(:find_in_tmdb).and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:search)).to eq('Ted')
    end
    
    it 'should show an error message if the user entered an invalid search' do
      fake_results = [double('Movie1'), double('Movie2')]
      allow(Movie).to receive(:find_in_tmdb).and_return(fake_results)
      post :search_tmdb, {:search_terms => ''}
      expect(flash[:notice]).to eq('Invalid search term')
    end
    
    it 'should alert the user if no results were found in the search' do
      fake_results = []
      allow(Movie).to receive(:find_in_tmdb).and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Test'}
      expect(flash[:notice]).to eq('No matching movies were found on TMDb')
    end
    
  end
  
  describe 'adding a list of checked movies from search results' do
    context 'when no boxes are checked' do
      it 'should set a flash message alerting that no options were selected' do
        expect(false).to be_truthy
      end
    end
    context 'when boxes are checked' do
      it 'should receive a hash of checked movies from the post request' do
        expect(false).to be_truthy
      end
      
      it 'should send a list of TMDb IDs to the model method create_from_tmdb' do
        expect(false).to be_truthy
      end
    end
    
    
  end
end
