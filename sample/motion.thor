require 'bundler/setup'

Bundler.require

class RubyMotion < Thor
  desc "build", "build a project"
  def build
    p = Motion::Build::Project.new("DefaultProject")
    p.sources = Dir.glob('app/**/*.rb').map { |fn| File.absolute_path(fn) }
    p.build
  end
end
