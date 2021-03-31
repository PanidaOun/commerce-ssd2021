class Product < ApplicationRecord
    enum status: [:draft, :published, :archived]

    scope :search, -> (arg) {where("title LIKE ? or description LIKE ?", "%#{arg}%", "%#{arg}%")}
    validates :stock, numericality: {greater_than_or_equal_to: 0}
    validates :title, length: { minimum: 2 }

    has_many :categories_products
    has_many :categories, through: :categories_products
end
