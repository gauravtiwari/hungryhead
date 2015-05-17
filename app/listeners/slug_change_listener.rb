class SlugChangeListener

  def slug_changed(sluggable)
    previous = sluggable.slugs.where('lower(slug) = ?', sluggable.slug.downcase)
    previous.delete_all
    sluggable.slugs.create!(slug: sluggable.slug)
  end

end