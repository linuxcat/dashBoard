require File.join(File.dirname(__FILE__), 'application')

map('/') {run HomePage.new()}
map('/test-projects') {run TestProjects.new()}
map('/test-failures') {run TestRunFailures.new()}