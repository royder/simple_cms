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

## Rails Architecture
Browser ~~ Web Server <-> Public -> |Rails Framework| -> Routing -> Controller <-> Model or -> View -> Web Server

So, if you happen to have a file in public with the same name as one in the rails app, if public satisifies the request, the request will never make it to the rails framework.

## Routes (config/routes.rb)
Routes are processed in order of how they are set in the routes file.

### Basic Routes
* Simple Route (Match Route)
* Default Route
* Root Route

#### Simple Route
`get 'demo/index'` 

the same as:
`match 'demo/index', :to => "demo#index", :via => :get

Which means it's matching the string demo/index and then sending to the demo controller and index action using GET

#### Default Route
This used to be the default route in rails.  This is no longer considered a best practice and not included in the routes file by default.
:controller/:action/:id
GET /demo/edit/52

`match ':controller(:/action(/:id))', :via => :get`
parens is used meaning optional

you can add format as well:
`match ':controller(:/action(/:id)(/:format))', :via => :get`

#### Root Route
When you go to the root of the application, where should the request be redirected.
`root :to => 'demo#index'`
or shorthand
`root 'demo#index'`

## Rendering Templates
The controller chooses which view template to render similar to Grails. 

Goes to requested controller and runs the action and renders the same view.  Or, if there is not an action with the action name requested, rails will attempt to just render the template with the requested name.

The most common way to choose the template is to let the default rails behavior kick in. Or, you can specify the template to render within the action.
`render(:template => 'demo/hello')` == `render('demo/hello')` == `render('hello')`

## Redirecting Actions
The controller can render a view as mentioned above but can also redirect to another action, which sends an HHTP redirect for the new request.
`redirect_to(:controller => 'demo', :action => 'index')`

The controller is optional if it's an action within the same controller.

## View Templates
ERB - Embedded Ruby 
`<% code %>` - executes code
`<%= code %>` - executes and outputs

## Instance Variables
Use instance variables to pass data from the controller to the view.  The controller is just a regular class that inherits from the ApplicationController.

So, when the request comes in, rails creates an instance of the class.


## Database
Used pgAdmin to add a new login role and set db config in config/database.yml
Need to restart server to pick-up new configs.

## Controller
Create using `rails generate controller controller_name view1 view2 view3`

* You can use `layout false` in the controller to suppress the layout in a controller.




