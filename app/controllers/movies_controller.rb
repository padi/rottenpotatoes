class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @movies = Movie.scoped

    checked_ratings = []

    session[:sort_by] = params[:sort_by] unless params[:sort_by].blank?
    session[:ratings] = params[:ratings] unless params[:ratings].blank?

    @movies = @movies.order_by_rating(session[:sort_by]) unless session[:sort_by].blank?

    session[:ratings].each { |key, value| checked_ratings << key } unless session[:ratings].blank?
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
