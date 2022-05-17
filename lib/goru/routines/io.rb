# frozen_string_literal: true

require_relative "../routine"
require_relative "bridges/readable"
require_relative "bridges/writable"

module Goru
  module Routines
    # [public]
    #
    class IO < Routine
      def initialize(state = nil, io:, intent:, &block)
        super(state, &block)

        @io = io
        @intent = intent
        @status = :selecting
        @monitor = nil
        @finishers = []
      end

      # [public]
      #
      attr_reader :io, :intent

      attr_writer :monitor

      # [public]
      #
      def accept
        @io.accept_nonblock
      end

      # [public]
      #
      def read(bytes)
        result = @io.read_nonblock(bytes, exception: false)

        case result
        when nil
          finished
          nil
        when :wait_readable
          # nothing to do
        else
          result
        end
      rescue Errno::ECONNRESET
        finished
        nil
      end

      # [public]
      #
      def write(data)
        result = @io.write_nonblock(data, exception: false)

        case result
        when nil
          finished
          nil
        when :wait_writable
          # nothing to do
        else
          result
        end
      rescue Errno::ECONNRESET
        finished
        nil
      end

      # [public]
      #
      def intent=(intent)
        intent = intent.to_sym

        # TODO: Validate intent (move validation from scheduler into the routines).
        #
        @monitor.interests = intent
        @intent = intent
      end

      # [public]
      #
      def bridge(channel, intent:)
        # TODO: Validate intent.
        #
        bridge = case intent
        when :r
          Bridges::Readable.new(routine: self, channel: channel)
        when :w
          Bridges::Writable.new(routine: self, channel: channel)
        end

        on_finished { bridge.finished }
        @reactor.adopt_routine(bridge)
        bridge
      end

      # [public]
      #
      def on_finished(&block)
        @finishers << block
      end

      private def status_changed
        case @status
        when :finished
          @finishers.each(&:call)
        end

        super
      end
    end
  end
end
