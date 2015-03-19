# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    sort = params[:sortby]
    if(params[:sortby])	
    	session[:sortby] = sort
    end	
    @sort = sort
    @ratingsVec = []
    @ratingsHash = {}	
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    if(params[:ratings])
	params[:ratings].each_key do |r|
	  @ratingsVec.push(r)
          @ratingsHash[r] = r
	end
        @movies = Movie.find(:all, :order=>@sortby, :conditions => {:rating =>@ratingsVec})
	session[:ratings] = @ratingHash
    else			
	if (session[:ratings])
		flash.keep
		redirect_to_movies_path(:sorby=>session[:sortby], :ratings=>sessions[:ratings])	
	end    
	@movies = Movie.order(@sort).all
    end
  #  @sort = sort	
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
