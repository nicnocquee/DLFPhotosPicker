module Fastlane
  module Actions
    module SharedValues
      ENSURE_POD_TRUNK_SESSION_CUSTOM_VALUE = :ENSURE_POD_TRUNK_SESSION_CUSTOM_VALUE
    end

    # To share this integration with the other fastlane users:
    # - Fork https://github.com/fastlane/fastlane/tree/master/fastlane
    # - Clone the forked repository
    # - Move this integration into lib/fastlane/actions
    # - Commit, push and submit the pull request

    class EnsurePodTrunkSessionAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        
        me = Helper.backticks("pod trunk me")
        properties = me.split("\n  -")
        if properties.last.strip.start_with?("Sessions")
          sessions = properties.last.strip.split("\n")
          if sessions.count > 1
            expire = sessions.last.split(".").first.split("-").last.strip
            expire_date = Date.parse expire
            if Date.today > expire_date
              UI.error "Cocoapod trunk session has expired. Run pod trunk register <email> '<name>' --description='<description>' to create new session."
            else
              UI.success "Cocoapod trunk session is still valid. Cruise on!"
            end
          end
        end
        # Actions.lane_context[SharedValues::ENSURE_POD_TRUNK_SESSION_CUSTOM_VALUE] = "my_val"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Ensure user has created new session for pushing pod by running pod trunk register <email> '<name>' --description='<description>'"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples

      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['ENSURE_POD_TRUNK_SESSION_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
