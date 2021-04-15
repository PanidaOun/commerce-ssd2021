class Product < ApplicationRecord
    enum status: [:draft, :published, :archived]

    scope :search, -> (arg) {where("title LIKE ? or description LIKE ?", "%#{arg}%", "%#{arg}%")}
    validates :stock, numericality: {greater_than_or_equal_to: 0}
    validates :title, length: { minimum: 2 }

    has_many :categories_products
    has_many :categories, through: :categories_products
    has_one_attached :primary_image
    has_many_attached :supporting_images

    attr_accessor :remove_primary_image, :remove_supporting_images

    after_save :purge_primary_image, if: :remove_primary_image
    private def purge_primary_image
        return unless @remove_primary_image == '1'
        primary_image.purge_later
    end

    after_save :purge_supporting_images, if: :remove_supporting_images
    private def purge_supporting_images
        return unless @remove_supporting_images == '1'
        supporting_images.purge_later
    end
end
