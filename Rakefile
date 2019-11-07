# frozen_string_literal: true

autoload(:Alluvion, "#{__dir__}/lib/alluvion")

require 'kamaze/project'
require 'sys/proc'
require 'yaml'

Sys::Proc.progname = nil

# @formatter:off
Kamaze.project do |project|
  project.subject = Alluvion
  project.name = 'alluvion'
  project.tasks = [
    'cs:correct', 'cs:control',
    'cs:pre-commit',
    'doc', 'doc:watch',
    'gem', 'gem:compile',
    'misc:gitignore',
    'shell', 'sources:license',
    'test',
  ]
end.load!
# @formatter:on

task default: [:gem]

if project.path('spec').directory?
  task :spec do |task, args|
    Rake::Task[:test].invoke(*args.to_a)
  end
end

if Gem::Specification.find_all_by_name('simplecov').any?
  if YAML.safe_load(ENV['coverage'].to_s) == true
    autoload(:SimpleCov, 'simplecov')

    SimpleCov.start do
      add_filter 'rake/'
      add_filter 'spec/'
    end
  end
end
