# frozen_string_literal: true

require_relative "../channel"

module Goru
  module Routines
    module Channels
      # [public]
      #
      class Writable < Channel
        def initialize(...)
          super

          update_status
        end

        # [public]
        #
        def <<(message)
          @channel << message
        end

        private def update_status
          status = if @channel.full?
            :idle
          elsif @channel.closed?
            :idle
          else
            :ready
          end

          set_status(status)
        end
      end
    end
  end
end
