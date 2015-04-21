# Simple CMS 
A simple rails app for learning and referencing.  This README consists of notes made as I went through the process to use as a rails reference for later.

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
`rails server` or `rails s` -> default runs on port 3000

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

## Rails Environments
### Development
Used for developing.

### Production
For production.

### Test
For running tests on code.

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

the same as: `match 'demo/index', :to => "demo#index", :via => :get`  

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

## Controller
Create using `rails generate controller controller_name view1 view2 view3`

* You can use `layout false` in the controller to suppress the layout in a controller.

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

So, when the request comes in, rails creates an instance of the class.  Rails couples the code between the controller and the view as part of action pack, Action controller and Action view.

## Links
Similar to Grails links  
`<%= link_to(text, target) %>`  
`<%= link_to(text, {:controller => 'demo', :action => 'index'}) %>`  

So, the following are the same:  
`<a href="/demo/hello">Hello Page 1</a><br />`  
`<%= link_to('Hello Page 2', {:action => 'hello'}) %>`  

Depending on the routes file, the links could be created based on what is setup there.

## URL Parameters
Adding parameters to links:  
`{:controller => 'demo', :action => 'hello', :id => 1, :page => 3, :name => 'john'}`

So, rails will see if it has been given a controller and if not, then default to the current controller. Next, it will look for an action or default into the current action.  Then is takes the remaining parameters and turns them into URL parameters except for the special "id" parm, since it's used so frequently.

To access params from requests coming in, you use HashWithIndifferentAccess  
`params[:id]` or `params['id']` will work

You can access params in the controller and the view, but usually you will make decisions based on params which will be in the controller. 

## Database
Used pgAdmin to add a new role for DB and set db config in config/database.yml  
Need to restart server to pick-up new configs.  

We usually give the application access at the database level.  
In the rails framework, one model is equal to one table.  
Database name and table name is all lowercase with underscores for rails.  
Table names are plural.  
Foreign keys convention in rails example: subject_id  

Using command line (psql)  
http://www.postgresql.org/docs/9.4/static/app-psql.html  
`psql -d database_name -U user`

## Rake
Rake is a ruby helper program to run tasks (similar to Unix make) == Ruby Make - rake  
Uses `Rakefile` inside the root of the application.  
You can write custom tasks; place them in /lib/tasks  

See all tasks: `rake -T`  
See all db tasks: `rake -T db`  
Pass environment variables to rake: `rake db:schema:dump RAILS_ENV=production`

## Migrations
* Set of db instructions in ruby (or SQL if needed) to migrate the db from one state to another
* Contains instructions for moving up to next state or back down to previous state
* Keeps the db schema with the project and project version

Migrations will reside in the db directory.  
To generate a new migration: `rails generate migration NameOfMigration`

This will create a new migration within db:  
`create    db/migrate/20150418232018_name_of_migration.rb` where 20150418232018 is the timestamp to help make each migration unique and put migrations in order.

Migrations come with a predefined method `def change`.  This is a shortcut method for `def up` and `def down`.  The code in up describes what to do to change the db and down describes how to revert.  You can use the shortcut method if you are using migration methods that have a context for both up and down and can automatically be reversed.  For example, for rename_table, you specify the current and new name. Up will change to the new name and down will automatically change back to the old name.

Create table column syntax formats:  
```ruby
create table 'table' do |t|  
  t.column 'name', :type, options  
  t.type 'name', options  
end
```

Table column types:  
binary, boolean, date, datetime, decimal, float, integer, string, text, time

The primary key or id column is automatically added.  You only need to specify when you do not want the column to be added.

### Running Migrations
Run all migrations which have not yet been run:  
`rake db:migrate` and optionally `RAILS_ENV=env`

Revert all the way back:  
`rake db:migrate VERSION=0`

View migration status:  
`rake db:migrate:status`

Run migrate up for a version:  
`rake db:migrate:up VERSION=20150418232018`

Run migrate down for a version:  
`rake db:migrate:down VERSION=20150418232018`

Redo migrate for a version - runs down and then immediately runs up:  
`rake db:migrate:redo VERSION=20150418232018`

Schema.rb will always have the current schema of the database, it will get updated during migrations.

### Migration Methods
#### Table Migration Methods
`create_table (table, options) do |t| end`  
`drop table (table)`  
`rename_table (table, new_name)`  

#### Column Migration Methods
`add_column(table, column, type, options)` - cannot use short format like we can in create_table, also, the options might not be compatible will all DBs.  For instance, the option :after to specify the new column position is compatible with MySQL but not with postgres, where you have to recreate the table with the order you want and copy the data over.  
`remove_column(table, column)`  
`rename_column(table, column, new_name)`  
`change_column(table, column, type, options)` - for changing column options in place  

#### Index Migration Methods
`add_index(table, column, options)` - if we want to create multiple, pass in array for columns  
`remove_index(table, column)`  
Some index options are: `:unique => true/false` `:name => 'custome_name'`  
Always want to add indexes on foreign keys and columns frequently used for lookups

#### Execute Migration Methods
You can use this to pass along any SQL string to execute: `execute("any SQL string")`

### schema_migrations table
This table is created to keep track of migrations by storing the migration timestamp as the version

### Solving Migration Problems
If an migration throws an error half way through and the DB gets in a state in between a migration, it's usually best to fix your migration and then comment out the part of the migration file that completed so it will pick up where it left off or something similar instead of running SQL commands and possibly also mess with the schema_migrations table.

## Models
To generate a model, which also creates a migration and test templates:  
`rails generate model SingularName`

### ActiveRecord
active record: a common design pattern for working with relational databases  
ActiveRecord: refers to the rails implementation of the active record pattern  

This design pattern allows us to retrieve records from a database as objects not as static rows.  The objects understand the structure of the table and contain data from table rows.  They know how to CRUD.

Objects can be manipulated and saved back to the db with simple commands.

Example:  
```ruby
user = User.new
user.first_name = "First"
user.save # SQL INSERT

user.last_name = "Last"
user.save # SQL UPDATE

user.delete # SQL DELETE
```
### ActiveRelation
Added in Rails v3 (ARel)
OO interpretation of relational algebra - or simplifies the generation of complex db queries by allowing chaining  simple commands which will be joined and use efficient more complicated SQL.

Example:  
```ruby
users = User.where(:first_name => 'First')
users = users.order('last_name ASC').limit(5)
users = users.include(:articles_authored)

# SELECT users.*, articles.*
# FROM users
# LEFT JOIN articles ON (users.id =
#   articles.author_id)
# WHERE users.first_name = 'First'
# ORDER BY last_name ASC LIMIT 5
```

## Rails Console
Similar to irb: `rails console` or `rails c` or `rails console env`
Great way to work with your models and view data during development.

## Creating Records
* New/save
  * Instantiate Object
  * Set Values
  * Save
* Create
  * Instantiate Object, Set Values, Save - in a single step

### New
```ruby
subject = Subject.new(:name => 'First Last', :position => 1, :visible => true) # mass assignment  
subject.new_record? # TRUE has this been saved to the db?  
subject.save # returns true or false  
subject.new_record? # FALSE has this been saved to the db?  
subject.id # this has now been generated along with created_at and updated_at  
```

### Create
```ruby
subject = Subject.create(:name => 'First Last', :position => 1)  
subject.new_record? # FALSE has this been saved to the db?  
```

## Updating Records
If you have a column named updated_at, it will automatically get updated.
* Find/Save - Set attributes and save in multiple steps
  * Find Record
  * Set Values
  * Save
* Find/Update - Sets attributes and save in a single step
  * Find Record
  * Set values and save

### Find/Save
```ruby
subject = Subject.find(1) # find subject with id 1; returns instance  
subject.new_record? # FALSE  
subject.name = 'New Subject'  
subject.save  
```

### Find/Update
```ruby
subject = Subject.find(2)  
subject.update_attributes(:name => 'First Last', :visible => true) # true/false  
```

## Deleting Records
* Find/destroy
  * Find a record
  * destroy the record (not delete, delete might bypass some rails default behavior)
  
```ruby
subject = Subject.find(3)  
subject.destroy  # returns the record that was destroyed  
```

## Finding Records

The following all make immediate db calls:

### Primary Key Finder
`Subject.find(id)` - returns an object or an error

### Dynamic Finder
`Subject.find_by_id(2)` - returns an object or nil (instead of an error)
This is called dynamic finder because you can `find_by_column_name`.  Returns the first that if finds.

### Find all
`Subject.all` - returns an array of objects

### First/Last
`Subject.first` or `Subject.last` -  returns object or nil

### Where Query Method
`where(conditions)` - Returns an ActiveRelation object, which can be chained to build an SQL statement before executing.  
`Subject.where(:visible => true).order('position ASC')

Some condition expression types:  
* String - Flexible, raw SQL - have to watch out for SQL injection
  * `"name = 'First Name' AND visible = true"`
* Array - Flexible, raw SQL, safe from SQL injection, gives rails the opportunity to escape values coming in
  * `['name = ? AND visible = true', 'First Last']`
* Hash - Simple, escaped SQL as well - each key/value is joined with AND
  * only supports equality, range, subset: NO or, like, less/greater than... if you need these then use array
  * `{:name => 'First Last', :visible => true}`

You can also use the `to_sql` method to show what the SQL would be as you build your query method chain.

Other Query Methods:
* Order Query Method
  * order(sql_fragment) - table_name.column_name ASC/DESC
  * table_name not necessary for a single table, but with joined tabled you should include table_name
  * can sort by more than one column across tables
* Limit Query Method
  * limit (int)
* Order Query Method
  * offset (int)
  
Example:
`Subject.where(query).order('position' ASC).limit(20).offset(40)`

## Named Scopes
* Queries defined in a model
* Defined using ActiveRelation query methods
* Can be called liked ARel methods, daisy chain, can accept parameters
* rails 4 must use lambda syntax

So, we create a scope called active and have an anonymous function with what we want.  
`scope :active, lambda {where(:active => true)}`  
`scope :active, -> {where(:active => true)}`  -> is a lambda but there are differences between lambda and ->  

The above would be the same as writing a class method on the model like:
```ruby
def self  
  where(:active => true)  
end  
```

The way you would call the above would be the same as the query methods:  
`Customer.active`  

With arguments:  
`scope :with_content_type, lambda {|ctype| where(:content_type => ctype)}`  
`Section.with_content_type('html')  

Lambdas are evaluated when they are called, not when they are defined.  So, if you have a 1.week.ago..Time.now, it would be the time when it's being executed.

## Associations in Rails
### One-to-one 1:1
One of the two items will have a foreign key which goes on the belongs to table. For example, if a classroom has one teacher, then the teach belongs to the classroom and the foreign key goes on teachers table.  
ARec: `Classroom has_one :teacher` and `Teacher belongs_to :classroom`  

has_one methods:  
subject.page and subject.page = page will allow you to get the subject's page or assign it.

### One-to-many 1:m
A teacher has many courses and a course belongs to a teacher.  The foreign key goes on the courses table.  
ARec: `Teacher has_many :courses` and `Course belongs_to :teacher`

has_many methods:  
subject.pages  
subject.pages << page  
subject.pages = [page, page, page]  
subject.pages.delete(page) - removes a page from the array  
subject.pages.destroy(page) - destroy to destroy the page (deletes from db)  
subject.pages.clear - remove all pages  
subject.pages.empty? - check if any pages, like reg arrays  
subject.pages.size - checks size of array, like reg arrays  


### Many-to-many m:m
A course has many students and a student has many courses.  So, you need two foreign keys in a join table.  
ARec: `Courses has_and_belongs_to_many :students` and `Student has_and_belongs_to_many :courses` (habtm). Use this when the join table is simple and only has the foreign keys.  The join table should not have its own primary key: `(:id => false)`

habtm methods  
same has has_many

### Creating a Join Table
Naming for rails is first_table_plural_second_table_plural in alphabetical order.  
`rails generate migration CreateAdminUsersPagesJoin`  

### Creating a Rich Join
You can have a model that is has_many to a join and another that is has_many to the same join and finally the join can belongs_to both.  This new join table will still have the foreign keys but it will also have a primary key.  There is not a naming conventions for this type of join table but it is usually a good idea to end it in -ments or -ships.

See the relationship between the admin users and sections in the app.  Be careful about updating associations in the db but not refreshing the objects in those associations.

To traverse this rich join, you have to take an additional step.  You should use `has_many :through`  
`AdminUser has_many :sections, :through => :section_edits` and `Section has_many :admin_users, :through => :section_edits`

So, now you can use admin_user.sections and section.editors instead of the following:  
section.section_edits.map {|se| se.editor}

You cannot easily do section.editors << user, since you need to specify the data in the join table such as summary.