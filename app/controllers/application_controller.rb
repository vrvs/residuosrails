class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def generate_types
    render('types')
  end
  def generate_types_percent
    render('percent')
  end
  def generate_often
    render('often')
  end
end
