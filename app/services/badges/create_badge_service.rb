class CreateBadgeService

  def initialize(badgeable, args)
    @args = args
  end

  def call
    @badge = badgeable.add_badge!(args)
  end

end