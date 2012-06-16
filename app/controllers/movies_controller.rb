class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @movies = Movie.scoped

    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
      @movies = @movies.order_by_rating(params[:sort_by])
    elsif session[:sort_by]
      @movies = @movies.order_by_rating(session[:sort_by])
    end

    checked_ratings = []
    params[:ratings].each { |key, value| checked_ratings << key } if params[:ratings]
    @movies = @movies.where(rating: checked_ratings) unless checked_ratings.empty?
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
