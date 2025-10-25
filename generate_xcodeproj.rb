#!/usr/bin/env ruby
require 'xcodeproj'
require 'fileutils'

# Paths
project_path = File.expand_path("../StressApp.xcodeproj", __dir__)
shared_path = File.expand_path("../Shared", __dir__)

# Create new Xcode project
project = Xcodeproj::Project.new(project_path)

# ----------------------------
# 1. Create iOS target
# ----------------------------
ios_target = project.new_target(:application, 'StressApp', :ios, '15.0')
ios_target.build_configuration_list.set_setting('PRODUCT_BUNDLE_IDENTIFIER', 'com.claire.stressapp')

# ----------------------------
# 2. Create watchOS target
# ----------------------------
watch_target = project.new_target(:watch2_app, 'StressApp WatchKit App', :watchos, '9.0')
watch_target.build_configuration_list.set_setting('PRODUCT_BUNDLE_IDENTIFIER', 'com.claire.stressapp.watch')

# ----------------------------
# 3. Add Shared groups
# ----------------------------
shared_group = project.main_group.new_group('Shared', 'Shared')

models_group = shared_group.new_group('Models', 'Shared/Models')
exercises_group = shared_group.new_group('Exercises', 'Shared/Exercises')
views_group = shared_group.new_group('Views', 'Shared/Views')
components_group = views_group.new_group('Components', 'Shared/Views/Components')

# ----------------------------
# 4. Add files to groups
# ----------------------------
# Models
Dir.glob(File.join(shared_path, 'Models', '*.swift')).each do |file|
  models_group.new_file(file).targeted_for(:ios, :watchos)
end

# Exercises
Dir.glob(File.join(shared_path, 'Exercises', '*.swift')).each do |file|
  exercises_group.new_file(file).targeted_for(:ios, :watchos)
end

# Views
Dir.glob(File.join(shared_path, 'Views', '*.swift')).each do |file|
  views_group.new_file(file).targeted_for(:ios, :watchos)
end

# Components
Dir.glob(File.join(shared_path, 'Views', 'Components', '*.swift')).each do |file|
  components_group.new_file(file).targeted_for(:ios, :watchos)
end

# ----------------------------
# 5. Save project
# ----------------------------
project.save

puts "✅ StressApp.xcodeproj generated successfully in the Stress folder!"
