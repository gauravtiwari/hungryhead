class SlugChangeListener

  def slug_changed(sluggable)
    return if !sluggable.slug_changed? || sluggable.slugs.last.try(:slug)
    previous = sluggable.slugs.where('lower(slug) = ?', sluggable.slug.downcase)
    previous.delete_all
    sluggable.slugs.create!(slug: sluggable.slug)
  end

end