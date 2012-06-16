class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if valid_sort_option? params[:sort_by]
      @movies = Movie.order(params[:sort_by])
    else
      @movies = Movie.scoped
    end

    unless params[:ratings].blank?
      checked_ratings = []
      params[:ratings].each_key do |key|
        checked_ratings << key
      end
      @movies = @movies.where(rating: checked_ratings)
    end
    @movies
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

  private

  def valid_sort_option? option
    %w(title release_date).include? option
  end
end
