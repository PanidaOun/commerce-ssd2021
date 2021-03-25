class Product < ApplicationRecord
    validates :stock, numericality: {greater_than_or_equal_to: 0}
    validates :title, length: { minimum: 2 }

    has_many :categories_products
    has_many :categories, through: :categories_products
end
