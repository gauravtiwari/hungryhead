class School < ActiveRecord::Base
	has_many :users, as: :students
	has_many :ideas
	has_many :slugs, as: :sluggable, dependent: :destroy
	store_accessor :data, :established, :location, :website

	after_save :create_slug

	private

	def create_slug
		return if !slug_changed? || slug == slugs.last.try(:slug)
		#re-use old slugs
		previous = slugs.where('lower(slug) = ?', slug.downcase)
		previous.delete_all
		slugs.create!(slug: slug)
	end
end
