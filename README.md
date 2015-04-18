# Simple CMS 
A simple rails app for learning and referencing

## Setup
* Ruby 2.1.6
* DevKit
* Rails 4.2.1
* PostgreSQL 9.4
* WEBrick

## Creating the project
`rails new simple_cms -d postgresql`

### Bundler 
Rails depends on this to manage the gems the app needs.

* Gemfile - the gems that the app needs; the one to edit
* Gemfile.lock - auto-generated tree of gems and dependencies; do not edit

Use the following command to make sure the gems and dependencies are good. Also generates the lock file.
`bundle install`

Sometimes you will attempt to run a command and it will not work (i.e. rake db:migrate).  You can sometimes easily solve the issue by trying `bundle exec rake db:migrate` which will execute the command in the context of the bundle of gems that go with the project.

## Accessing a Project
`rails server` -> default runs on port 3000

## Rails Default File Structure
* app - where most of the application code lives
    * models, views, controllers
    * concerns in controllers and models for commen code
    * helpers - code to help with views 
    * mailers - for sending emails
    * assets - could put imgs, js, css if we want it in the rails asset pipeline
* bin - scripts (bundle, rails, rake)
* config - configuration for the app
    * db, application, environments, specific environment, routes
    * initializers - what needs to launch when the application launches
    * locales - internationalization
* config.ru - config file for rack based applications to work with rails 
* db
    * store code related to managing db (migrations)
* Gemfile and Gemfile.lock (see bundler)
* lib - normal lib folder 
    * tasks (for rake tasks we write)
* log - yep
* public - by default has some http response default pages, favicon, robots.txt, could also put assets
* Rakefile - used by rake
* README.rdoc - place to store documentation
* test - place to store test code
* tmp - place for rails to store temp files for itself
* vendor - rarely used now due to gems

## Database
Used pgAdmin to add a new login role and set db config in config/database.yml
Need to restart server to pick-up new configs.

## Controller
Create using `rails generate controller controller_name view1 view2 view3`

* You can use `layout false` in the controller to suppress the layout in a controller.

## Routes (config/routes.rb)


