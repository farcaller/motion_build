require 'uuidtools'

module MotionBuild ; module Rules

  class CompileRubySourceRule < MotionBuild::FileRule
    attr_reader :archs, :init_func_name, :bs_files

    def input_extension
      '.rb'
    end

    def output_extension
      '.o'
    end

    def run
      # we don't run the code, deps do all the stuff for us
    end

    def initialize(project, source, options)
      super(project, source)
      @archs = options[:archs] || raise(ArgumentError, "Architectures are not defined")
      @bs_files = options[:bridge_support_files] || raise(ArgumentError, "Bridge support files are not defined")

      setup_dependencies # TODO: move this down the chain (action / action! maybe?)
    end

    def init_func_name
      @init_func_name ||= if active? # FIXME: it's not active by FileRule requirements when you force-build
        'MREP_' + UUIDTools::UUID.random_create.to_s.upcase.gsub('-', '')
      else
        nm = project.builder.run('nm', [destination]).scan(/T\s+_(MREP_.*)/)
        raise RuntimeError, "MREP_* symbol is not found in '#{destination}'" unless nm.count == 1
        nm[0][0]
      end
    end

    private
    def setup_dependencies
      emit_bitcode_rules = archs.map do |arch|
        EmitLLVMBitcodeRule.new(project, source, arch: arch, init_func: init_func_name, bridge_support_files: bs_files)
      end
      parse_bitcode_rules = emit_bitcode_rules.map do |rule|
        r = ParseLLVMBitcodeRule.new(@project, rule.destination, arch: rule.arch)
        r.dependencies << rule
        r
      end
      assemble_rules = parse_bitcode_rules.map do |rule|
        r = AssembleSourceRule.new(@project, rule.destination, arch: rule.arch)
        r.dependencies << rule
        r
      end
      lipo_rule = if archs.count == 1
        CopyFileRule.new(@project, assemble_rules.first.destination, destination)
      else
        LipoRule.new(@project, assemble_rules.map { |r| r.destination }, destination)
      end

      self.dependencies.concat([*assemble_rules, lipo_rule])
    end
  end

end ; end
