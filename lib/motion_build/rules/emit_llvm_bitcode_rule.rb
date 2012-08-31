module MotionBuild ; module Rules

  class EmitLLVMBitcodeRule < MotionBuild::ObjectFileRule
    attr_reader :arch, :init_func_name, :bs_files

    def input_extension
      '.rb'
    end

    def output_extension
      '.bc'
    end

    def run
      project.builder.notify('ruby', source, destination)
      project.builder.run('ruby', [*bs_flags, '--emit-llvm', destination, init_func_name, source], env: {'VM_KERNEL_PATH' => kernel_file})
    end

    def initialize(project, source, options)
      super(project, source)
      @arch = options[:arch] || raise(ArgumentError, "Architecture is not defined")
      @init_func_name = options[:init_func] || raise(ArgumentError, "Init function name is not defined")
      @bs_files = options[:bridge_support_files] || raise(ArgumentError, "Bridge support files are not defined")
    end

    private
    def bs_flags
      @bs_flags ||= @bs_files.map { |x| ['--uses-bs', x] }.flatten
    end

    def kernel_file
      File.join(project.config.get(:motion_data_dir), project.config.get(:base_sdk), project.config.get(:platform), "kernel-#{arch}.bc")
    end
  end

end ; end
