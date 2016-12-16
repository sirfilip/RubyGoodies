# Place the plugin inside spec/minitest directory
require 'libnotify'

module Minitest
  def self.plugin_notify_init(options)
    Minitest.reporter << LibnotifyReporter.new
  end

  class LibnotifyReporter < AbstractReporter
    def initialize
      super
      @results = []
    end


    def record result
      @results << result
    end

    def report
      if @results.all? { |r| r.passed? }
        Libnotify.show(:icon_path => "emblem-default.png")
      else
        Libnotify.show(:icon_path => "emblem-important.png")
      end
    end
  end
end
