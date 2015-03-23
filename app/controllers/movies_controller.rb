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
    if(!params[:ratings] && !params[:sortby])
      @movies = Movie.order(@sort).all
      session.delete(:sortby)
      session.delete(:ratings)
    elsif (params[:ratings] && !params[:sortby])
	params[:ratings].each_key do |r|
	  @ratingsVec.push(r)
          @ratingsHash[r] = r
	end
        session[:ratings] = params[:ratings] 
        if(!session[:sortby])
         @movies = Movie.find(:all, :order=>@sortby, :conditions => {:rating =>@ratingsVec})
        else
         @movies = Movie.order(session[:sortby]).find(:all, :order=>@sortby, :conditions => {:rating => @ratingsVec})
        end
#	session[:ratings] = @ratingHash
    else			
	if (session[:ratings])
                session[:ratings].each_key do |r|
                  @ratingsVec.push(r)
                  @ratingsHash[r] = r
                end
#		flash.keep
	#	@movies = Movie.order(@sort).all
#		redirect_to_movies_path(:sorby=>session[:sortby], :ratings=>sessions[:ratings])	
                @movies = Movie.order(@sort).find(:all, :order=>@sortby, :conditions => {:rating =>@ratingsVec}) 
        else    
	        @movies = Movie.order(@sort).all
        end
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
