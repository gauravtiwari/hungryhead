class Suggester
  # Suggester class to suggest a list of valid usernames available
  # Parameters [:first_name, :last_name]

  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    # Raise exception if not defined in model
    raise Error, 'first_name or last_name has not been specified' if first_name.nil? || last_name.nil?

    # Remove whitespaces first_name and last_name
    @first_name = first_name.downcase.gsub(/[^\w]/, '')
    @last_name  = last_name.downcase.gsub(/[^\w]/, '')
  end

  # Generates the combinations
  # Without the knowledge of what names are available
  def name_combinations
    @name_combinations ||= [
      first_name.to_s,
      last_name.to_s,
      "#{first_name[0]}#{last_name}",
      "#{first_name}#{last_name[0]}",
      "#{first_name}#{last_name}",
      "#{last_name[0]}#{first_name}",
      "#{last_name}#{first_name[0]}",
      "#{last_name}#{first_name}"
    ].uniq.reject(&:blank?)
  end

  # Generates suggestions
  # Make sure they are not in unavailable_suggestions
  def suggest(options)
    candidates_to_exclude = options[:exclude]
    number_of_suggestions = options[:num_suggestions]

    results    = []
    candidates = name_combinations.clone
    while results.size < number_of_suggestions && !candidates.blank?
      candidate = candidates.shift
      if candidate.length <= 4
        # Don't add the candidate to result
      elsif candidates_to_exclude.include? candidate
        candidates << find_extended_candidate(candidate, candidates_to_exclude)
      else
        results << candidate
      end
    end

    results
  end

  private

  # Generates a candidate with "candidate<number>"
  # It should not be included in unavailable_set
  def find_extended_candidate(candidate, candidates_to_exclude)
    i = 1
    i += rand(10) while candidates_to_exclude.include? "#{candidate}#{i}"
    "#{candidate}#{i}"
  end
end
