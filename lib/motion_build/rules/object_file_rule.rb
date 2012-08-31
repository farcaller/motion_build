module MotionBuild

  class ObjectFileRule < FileRule
    def destination
      return nil unless output_extension
      File.join(project.config.get(:build_dir_objects), relative_destination)
    end

    protected
    def relative_source
      if source.index(project.config.get(:build_dir_objects)) == 0
        source[project.config.get(:build_dir_objects).length..-1] # return dest-relative
      elsif source.index(project.config.get(:build_dir)) == 0
        source[project.config.get(:build_dir).length..-1] # return dest-relative
      elsif source.index(project.config.get(:source_dir)) == 0
        source[project.config.get(:source_dir).length..-1]
      else
        source # return absolute source
      end
    end
  end

end
