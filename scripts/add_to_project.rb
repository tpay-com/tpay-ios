#!/usr/bin/env ruby

require 'xcodeproj'

project_file, target_name, sources_dir, group_path = ARGV

# open the project
project = Xcodeproj::Project.open(project_file)

# find the target
target = project.native_targets.select { |x| x.name == target_name }.first

# Add sources to group
group = project[group_path]
group.clear
sources = Dir["#{sources_dir}/**/*.swift"].map { |f| File.expand_path(f) }.map { |f| group.new_file(f) }

# Add references to source build phase
sources.each { |s| target.source_build_phase.add_file_reference(s) }

# Clear empty references
empty_references = target.source_build_phase.files.select { |f| f.file_ref.nil? }
empty_references.each { |er| target.source_build_phase.remove_build_file(er) }

# Save the project file
project.save
