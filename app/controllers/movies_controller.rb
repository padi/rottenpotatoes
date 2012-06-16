class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @movies = Movie.scoped

    session[:sort_by] = params[:sort_by] || session[:sort_by]
    session[:ratings] = params[:ratings] || session[:ratings]

    @movies = @movies.order_by_rating(params[:sort_by]) unless params[:sort_by].blank?

    checked_ratings = []
    params[:ratings].each { |key, value| checked_ratings << key } unless params[:ratings].blank?
    @movies = @movies.where(rating: checked_ratings) unless checked_ratings.empty?

    if params_missing && session_exists
      flash.keep
      redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
    end
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

  def params_missing
    params[:sort_by].blank? && params[:ratings].blank?
  end

  def session_exists
    session[:sort_by] || session[:ratings]
  end
end
