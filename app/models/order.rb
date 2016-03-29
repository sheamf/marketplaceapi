class Order < ActiveRecord::Base
  has_many :placements
  has_many :products, through: :placements

  belongs_to :user

  validates_presence_of :user_id
  validates :total, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
  validates_with EnoughProductsValidator

  before_validation :set_total!

  def set_total!
    self.total = products.map(&:price).sum
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      id, quantity = product_id_and_quantity # [1,5]
      # I think it would be better to use a hash here w/id and qty keys, but author wanted to keep it simple
      self.placements.build(product_id: id, quantity: quantity)
    end
  end

end
