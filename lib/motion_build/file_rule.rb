require 'motion_build/rule'

module MotionBuild
  class FileRule < Rule
    attr_reader :source, :destination

    def input_extension
      nil
    end

    def output_extension
      nil
    end

    def initialize(project, *args)
      super(project)

      if args.count == 1
        @source = args.first
        if input_extension && input_extension != File.extname(@source)
          raise ArgumentError, "Wrong source type '#{File.extname(@source)}' for rule '#{self.class}'"
        end
      elsif args.count > 1
        raise ArgumentError
      end
    end

    def destination
      return nil unless output_extension
      File.join(project.config.get(:build_dir), relative_destination)
    end

    def active?
      return true unless source # run if we have no source
      return true unless destination # run if we have no destination
      #return false unless File.exist?(source) # skip if source file doesn't exist TODO: O RLY?
      return true unless File.exist?(destination) # run if destination file doesn't exist
      return true unless File.mtime(source) <= File.mtime(destination) # run if destination file is old
      false
    end

    def describe_active
      return "active (no source set)" unless source # run if we have no source
      return "active (no destination set)" unless destination # run if we have no destination
      #return "inactive (source does not exist)" unless File.exist?(source) # skip if source file doesn't exist TODO: O RLY?
      return "active (destination does not exist)" unless File.exist?(destination) # run if destination file doesn't exist
      return "active (mtime)" unless File.mtime(source) <= File.mtime(destination) # run if destination file is old
      "inactive (mtime)"
    end

    protected
    def pre_dependencies
      ensure_destination_directory if forced? || active?
    end

    def ensure_destination_directory
      d = File.dirname(destination)
      if File.exist?(d)
        raise RuntimeError, "Expected '#{d}' to be a directory" unless File.directory?(d)
      else
        FileUtils.mkdir_p(d)
      end
    end

    def relative_source
      if source.index(project.config.get(:build_dir)) == 0
        source[project.config.get(:build_dir).length..-1] # return dest-relative
      elsif source.index(project.config.get(:source_dir)) == 0
        source[project.config.get(:source_dir).length..-1]
      else
        source # return absolute source
      end
    end

    def relative_destination
      raise ArgumentError, "Rule #{self} has no output extension" unless output_extension
      File.join(File.dirname(relative_source), destination_file)
    end

    def destination_file
      File.basename(source, input_extension) + output_extension
    end
  end

end
