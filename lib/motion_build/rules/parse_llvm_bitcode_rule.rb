module Motion ; module Build ; module Rules

  class ParseLLVMBitcodeRule < Motion::Build::FileRule
    attr_reader :arch, :llc_arch

    def input_extension
      '.bc'
    end

    def output_extension
      '.s'
    end

    def run
      project.builder.notify('llc', source, destination)
      project.builder.run('llc', [source, "-o=#{destination}", "-march=#{llc_arch}", '-relocation-model=pic', '-disable-fp-elim', '-jit-enable-eh', '-disable-cfi'])
    end

    def initialize(project, source, options)
      super(project, source)
      @arch = options[:arch] || raise(ArgumentError, "Architecture is not defined")
    end

    protected
    def destination_file
      File.basename(source, input_extension) + '.' + arch + output_extension
    end

    private
    def llc_arch
      @llc_arch ||= case @arch
        when 'i386'; 'x86'
        when 'x86_64'; 'x86-64'
        when /^arm/; 'arm'
        else; arch
      end
    end
  end

end ; end ; end
