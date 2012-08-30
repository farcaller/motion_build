require 'term/ansicolor'
require 'open3'

module Motion ; module Build
  class Builder
    include Term::ANSIColor

    def info(msg)
      puts msg
    end

    def notify(command, i, o)
      i = i ? [i].flatten : []
      o = o ? [o].flatten : []
      
      s = "\t#{bold(yellow(command))} "
      s += i.map { |_| blue(_.index(Dir.pwd) == 0 ? '.'+_[Dir.pwd.length..-1] : _) }.join(', ')
      s += ' -> ' if o.count > 0
      s += o.map { |_| green(_.index(Dir.pwd) == 0 ? '.'+_[Dir.pwd.length..-1] : _) }.join(', ')
      puts s
    end

    def run(command, args, *options)
      options = options.first || {}
      env = options[:env] || {}
      # puts "#{Term::ANSIColor.yellow(resolve_command(command))} #{args.join(' ')}"
      stdout, status = Open3::capture2(env, resolve_command(command), *args)
      unless status.exitstatus == 0
        puts "\t#{bold(red('^--- FAILED'))}"
        exit status.exitstatus
      end
      stdout
    end

    private
    def resolve_command(command)
      return "/Library/RubyMotion/bin/#{command}" if File.exist?("/Library/RubyMotion/bin/#{command}")
      plat = `which #{command}`.strip
      return plat unless plat =~ /not found$/
      raise ArgumentError, "Command '#{command} is not found"
    end
  end

end ; end
