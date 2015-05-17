class SlugChangeListener

  def sluggable_saved(sluggable)
    return if sluggable.slugs.last.try(:slug)
    previous = sluggable.slugs.where('lower(slug) = ?', sluggable.slug.downcase)
    previous.delete_all
    sluggable.slugs.create!(slug: sluggable.slug)
  end

end