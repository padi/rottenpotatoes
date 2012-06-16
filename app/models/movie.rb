class Movie < ActiveRecord::Base
  scope :order_by_rating, lambda{|field| order(field) if valid_sort_option? field }

  def self.ratings
    ['G','PG','PG-13','R']
  end

  private

  def self.valid_sort_option? option
    %w(title release_date).include? option
  end
end
