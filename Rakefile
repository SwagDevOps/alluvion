# frozen_string_literal: true

autoload(:Alluvion, "#{__dir__}/lib/alluvion")

require 'kamaze/project'
require 'sys/proc'

Sys::Proc.progname = nil

Kamaze.project do |project|
  project.subject = Alluvion
  project.name    = 'alluvion'
  project.tasks   = [
    'cs:correct', 'cs:control',
    'cs:pre-commit',
    'doc', 'doc:watch',
    'gem', 'gem:compile',
    'misc:gitignore',
    'shell', 'sources:license',
    'test',
  ]
end.load!

task default: [:gem]

if project.path('spec').directory?
  task :spec do |task, args|
    Rake::Task[:test].invoke(*args.to_a)
  end
end
