class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  attr_accessor :message
  
  def statistic
    @residues = Residues.all
    @message = "não possui residuos"
  end
  
  def update
    @message = "não possui residuos"
  end
  
end
