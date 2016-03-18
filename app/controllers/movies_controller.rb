class MoviesController < ApplicationController
  
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    
    if params[:sort_by]
      @sortField = params[:sort_by]
    elsif session[:sort_by]
      redirect = true
      @sortField = session[:sort_by]
    end
    session[:sort_by] = @sortField
    
    
    if params[:ratings]
      @ratings = params[:ratings]
    elsif session[:ratings]
      redirect = true
      @ratings = session[:ratings]
    else
      @ratings = {'G'=>1,'PG'=>1,'PG-13'=>1,'R'=>1}
      redirect = true
    end
    session[:ratings] = @ratings
    
    if @sortField
      @movies= Movie.where(rating: @ratings.keys).order "#{@sortField} ASC"
      @sortField == "title" ? @title_header = 'hilite' : @release_date_header = 'hilite'
    else
        @movies = Movie.where(rating: @ratings.keys)
    end
    
    if redirect
      redirect_to movies_path(:sort_by => @sortField, :ratings => @ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
