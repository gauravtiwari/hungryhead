module Suggestions
  extend ActiveSupport::Concern
  class_methods do
    def suggestions_for(attribute = :username, option_hash = {})
      options = {
        :first_name_attribute => :first_name,
        :last_name_attribute  => :last_name,
        :num_suggestions      => 5,
        :exclude              => []
      }.merge(option_hash)

      define_method "#{attribute}_suggestions" do
        suggester = Suggester.new(send(options[:first_name_attribute]), send(options[:last_name_attribute]))
        suggestions_to_search = suggester.name_combinations.map { |s| "#{s}" }

        unavailable_choices = self.class.where(username: suggestions_to_search)
                                .map(&:username).map(&:downcase).uniq

        options[:exclude] += unavailable_choices
        suggester.suggest(options)
      end
    end
  end
end