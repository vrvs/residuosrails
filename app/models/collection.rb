class Collection < ApplicationRecord
  has_many :residues
  has_many :reports, dependent: :destroy
  has_one :notification, dependent: :destroy
  
  validates :max_value, presence: true
  
  attr_accessor :mean, :miss_days, :miss_weight, :solido_organico, :solido_inorganico, :liquido_organico, :liquido_inorganico, :liquido_inflamavel, :outros
  attr_accessor :solido_organico_percent, :solido_inorganico_percent, :liquido_organico_percent, :liquido_inorganico_percent, :liquido_inflamavel_percent, :outros_percent
  attr_accessor :residue_often_registered_list, :residue_often_registered_number
  
  def generate_prediction
    collection = Collection.last
    weight = 0.0
    Residue.all.each do |residue|
      weight += residue.weight
    end
    time = Date.today - collection.created_at.to_date
    mean = weight/time
    miss_weight = (collection.max_value - weight)
    miss_days = miss_weight/mean
    miss_days = miss_days.ceil
    @mean=mean
    @miss_days=miss_days
    @miss_weight=miss_weight
  end
  
  def type_residue
    @solido_organico = 0.0
    @solido_inorganico = 0.0
    @liquido_organico = 0.0
    @liquido_inorganico = 0.0
    @liquido_inflamavel = 0.0
    @outros  = 0.0
    Residue.all.each do |residue|
      case residue.kind
      when "Sólido Orgânico"
        @solido_organico += residue.weight
      when "Sólido Inorgânico"
        @solido_inorganico += residue.weight
      when "Líquido Orgânico"
        @liquido_organico += residue.weight
      when "Líquido Inorgânico"
        @liquido_inorganico += residue.weight
      when "Líquido Inflamável"
        @liquido_inflamavel += residue.weight
      when "Outros"
        @outros += residue.weight
      end
    end
  end
  
  def type_residue_percent
    self.type_residue
    weight = 0.0
    Residue.all.each do |residue|
      weight += residue.weight
    end
    @solido_organico_percent = ((@solido_organico/weight)*1000).round/10.0
    @solido_inorganico_percent = ((@solido_inorganico/weight)*1000).round/10.0
    @liquido_organico_percent = ((@liquido_organico/weight)*1000).round/10.0
    @liquido_inorganico_percent = ((@liquido_inorganico/weight)*1000).round/10.0
    @liquido_inflamavel_percent = ((@liquido_inflamavel/weight)*1000).round/10.0
    @outros_percent = ((@outros/weight)*1000).round/10.0
  end
  
  def residue_often_registered
    @residue_often_registered_list = Hash.new
    @residue_often_registered_number = Hash.new(0)
    Residue.all.order(:created_at).each do |residue|
      lab = Laboratory.find_by(id: residue.laboratory_id)
      if residue.number_registers >= @residue_often_registered_number[lab.name.parameterize.underscore.to_sym]
        @residue_often_registered_number[lab.name.parameterize.underscore.to_sym] = residue.number_registers
        @residue_often_registered_list[lab.name.parameterize.underscore.to_sym] = residue.name
      end
    end
  end
end
