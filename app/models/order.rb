class Order < ActiveRecord::Base
  has_many :placements
  has_many :products, through: :placements

  belongs_to :user

  validates_presence_of :user_id
  validates :total, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_total!

  def set_total!
    self.total = products.map(&:price).sum
  end

end
