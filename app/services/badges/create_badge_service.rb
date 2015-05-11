class CreateBadgeService

  def initialize(badgeable, args)
    @args = args
  end

  def call
    @badge = badgeable.add_badge!(args)
    if badgeable.save
      publish :created, @badge
    else
      publish :error, @badge
    end
  end

end