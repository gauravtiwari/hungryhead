module UniversitiesHelper
	def cache_key_for_organization(organization)
		max_updated_at = organization.maximum(:updated_at).try(:utc).try(:to_s, :number)
	    "activities/all-#{count}-#{max_updated_at}"
	end
end
