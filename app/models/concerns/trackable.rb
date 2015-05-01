module Trackable
  extend ActiveSupport::Concern

  module ClassMethods
    def track(name, options={})
      @name = name
      @callback = options.delete :on
      @callback ||= :create
      @actor = options.delete :actor
      @actor ||= :creator
      @object = options.delete :object
      @target = options.delete :target
      @followers = options.delete :followers
      @followers ||= :followers
      @mentionable = options.delete :mentionable

      method_name = "track_#{@name}_after_#{@callback}".to_sym
      define_activity_method method_name, actor: @actor, object: @object, target: @target, followers: @followers, verb: name, mentionable: @mentionable

      send "after_#{@callback}".to_sym, method_name, if: options.delete(:if)
    end

    private
      def define_activity_method(method_name, options={})
        define_method method_name do
          @actor = send(options[:actor])
          @fields_for = {}
          @object = set_object(options[:object])
          @target = !options[:target].nil? ? send(options[:target].to_sym) : nil
          @extra_fields ||= nil
          @followers = @actor.send(options[:followers].to_sym)
          @mentionable = options[:mentionable]
          add_activity activity(verb: options[:verb])
        end
      end
  end

  protected

    def activity(options={})
      {
        verb: options[:verb],
        actor: options_for(@actor),
        object: options_for(@object),
        target: options_for(@target),
        created_at: Time.now
      }
    end

    def add_activity(activity_item)
      add_activity_to_user(activity_item[:actor], activity_item)
      add_mentions(activity_item)
      add_activity_to_followers(activity_item) if @followers.any?
    end

    def add_activity_to_user(user, activity_item)
      user.latest_activities.add(activity_item, activity_item[:created_at])
    end

    def add_activity_to_followers(activity_item)
      @followers.each { |follower| add_activity_to_user(follower, activity_item) }
    end

    def options_for(target)
      if !target.nil?
        {
          id: target.id,
          class: target.class.to_s,
          display_name: target.to_s
        }.merge(extra_fields_for(target))
      else
        nil
      end
    end

    def set_object(object)
      case
      when object.is_a?(Symbol)
        send(object)
      when object.is_a?(Array)
        @fields_for[self.class.to_s.downcase.to_sym] = object
        self
      else
        self
      end
    end

end