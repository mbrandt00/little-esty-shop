class BulkDiscount < ApplicationRecord 
    belongs_to :merchant

    validates :threshold, presence: true, numericality: {only_integer: true }
    validates :discount, presence: true, numericality: {only_float: true}
    validates :name, presence: true

end