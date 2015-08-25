global_events_prefix :ab

version 1, "2015-07-26" do
  category :user do
    event :signed_up, "2015-07-26", "user creates a brand-new account"
    event :new_idea_from_email, "2015-07-26", "user opens new idea from welcome email"
    event :new_invite_request, "2015-07-26", "user request an invite to create account"
    event :new_contact_request, "2015-07-26", "user contacted using connect with us form"
  end
  category :visitor do
    event :page_viewed, "2015-07-26", "visitor visits a page"
  end
  category :idea do
    event :new_idea, "2015-07-26", "Pitched new idea"
  end
end