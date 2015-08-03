global_events_prefix :ab

version 1, "2015-07-26" do
  category :user do
    event :signed_up, "2015-07-26", "user creates a brand-new account"
  end
  category :visitor do
    event :page_viewed, "2015-07-26", "visitor visits a page"
  end
end