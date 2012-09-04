require 'bundler/setup'

Bundler.require

class RubyMotion < Thor
  desc "build", "build a project"
  def build
    p = MotionBuild::Project.new("DefaultProject")
    p.sources = Dir.glob('app/**/*.rb').map { |fn| File.absolute_path(fn) }
    Pry::rescue { p.build }
  end
end
