require 'cfpropertylist'

module MotionBuild ; module Rules

  class RenderPlistRule < MotionBuild::FileRule
    attr_reader :destination

    def output_extension
      '.plist'
    end

    def run
      plist = CFPropertyList::List.new
      plist.value = CFPropertyList.guess(@root_object)
      project.builder.notify('plist', nil, destination)
      plist.save(destination, cf_format)
    end

    def initialize(project, root_object, destination, format)
      super(project)
      @root_object = root_object
      @destination = destination
      @format = format
    end

    private
    def cf_format
      case @format
      when :xml
        CFPropertyList::List::FORMAT_XML
      when :binary
        CFPropertyList::List::FORMAT_BINARY
      else
        raise ArgumentError, "Unknown plist format '#{@format}'"
      end
    end
  end

end ; end
