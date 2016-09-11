#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Geengo::Application.load_tasks

# JU : set the :default rake task to only [:spec] instead of [:spec, :test] since the app was generated with --skip-test-unit
Rake::Task[:default].prerequisites.clear
task :default => [:spec]

namespace :import_attachments do

  desc "Import attachments for infrastructures"
  task :infrastructures => :environment do
    puts "Importing Infrastructure attachments"
    puts

    Infrastructure.import_uploaders
  end

end