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

## CRUD and Controllers

Standard Actions
* create
  * new - form, always best to instantiate the object upon new action, this allows the ability to set default values for the object either based on call to new or from the defaults set within the db.
  * create - post
* read
  * index - list
  * show - single rec (requires id)
* update
  * edit - form
  * update - post
* delete
  * delete - form
  * destroy - post
  
Usually you will have one controller per model and it should be plural.  Also, you can specify actions while generating the controller.  For example: `rails generate controller Subjects index show new edit delete`

## Forms in Rails
`form_tag` will create the form, anything in between the do and the end will make up the form.  
`text_field_tag` will create a text field with the value passed in as the second argument after the field name  
`text_field` you can specify the object name followed by the attribute name and will use that attribute value for the value of the form  
`submit_tag` will create the submit for the form

or you can use the `form_for` helper to create a form based on an object
```ruby
<%= form_for(:subject, :url => {:action => 'create}) do |f| %>  
  <%= f.text_field(:name) %>  
  <%= f.text_field(:position) %>  
  <%= f.text_field(:visible) %>  
  <%= submit_tag('Create Subject') %>  
<% end %>  
```

## Strong Parameters
Rails v1,v2 used a blacklisting of attributes, so default was less secure  
Rails v2 used whitelisting of attributes, so secure by default... but you could turn whitelisting off  
Rails v4 uses strong parameters which cannot be turned off, and the code for allowing or disallowing attributes is moved from the model to the controller.  

Mark which attributes are available for mass assignment
params.permit(:first_name, :last_name)

Ensures the parameters are present. If the attributes hash is assigned to subject then need to make sure subject is in the params.  Require does not do permitting but does return the value of the parameter.
params.require(:subject)

So, you can use `params.require(:subject).permit(:name, :position, :visible)`

## Layouts

The default is in app/views/layouts/application.html.erb

`<% yield %>` is where the view content is dropped in.  In the controller you can specify `layout 'layout_name'` to tell the controller which layout to use with the views.

Things to usually include in the layouts:
* Flash Message Structure
* Head, Title, Header Footer

When rails renders layouts and templates, it does not render them sequentially.  It gathers the instance variables first and binds them to the template, so you can set instance variables in the template for use in the layout.

## Partial Templates
Reusable HTML fragments.  The naming scheme for a partial is _partial_name.html.erb; begins with an underscore.  
You call the partial by using `<%= render(:partial => 'partial_name') %>`, you do not include the underscore. You pass data to the partial by adding locals...  `<%= render(:partial => 'partial_name', :locals => {:f => f}) %>` where the key for locals is the variable name that the partial is going to be using and the value is the value for the local.

## Text Helpers
To make common tasks within views easier.  Some examples are:
* word_wrap - wraps the text to the line width provided
* simple_format - takes every single backslash and convert to a br and a double to a p.
* truncate - truncates based on the length provided with a default of '...'.  The omissions string is included in the total character count.
* excerpt - uses radius to remove characters before and after the radius using the omission.
* highlight - looks for certain text and wraps that target text in html tags for styling
* pluralize - this helper is for forming the plural of words to help if you are working with 0, 1, or more objects. This helper knows most of the plurals such as ox, oxen.  If you need to define plurals you can edit inflections file.
* cycle - you can loop and on each loop it will use the value in the order of the argument list.

## Number Helpers
number_to_currency  
number_to_percentage  
number_with_percision / number_to_rounded  
number_with_delimiter / number_to_delimited  
number_to_human  
number_to_human_size  
number_to_phone  

Number as first arg and hash of options as second.  
options:  
delimiter - delimits thousands  
separator - decimal separator  
precision - decimal places to show  

`number_to_currency(34.5)`  
$34.50

`number_to_currency(34.5, :precision => 0, :unit => "kr", :format => "%n %u)`  
35 kr

`number_to_percentage(34.5)`  
34.500%

`number_to_percentage(34.5, :precision => 1, :separator => '.')`  
34,5%

`number_with_percision(34.56789)`   
34.568 (rounds)  #also known as number_to_round

`number_with_percision(34.56789, :precision => 6)`  
34.567890

`number_with_delimiter(3456789)`  
3,456,789 #also known as number_to_delimited

`number_with_delimiter(3456789, :delimiter => ' ')`  
3 456 789

`number_to_human(123456789)`  
123 Million

`number_to_human(123456789, :precision => 5)`  
123.46 Million

`number_to_human_size(1234567)`  
1.18 MB

`number_to_human_size(1234567, :precision => 2)`  
1.2 MB

`number_to_phone(1234567890)`  
123-456-7890

```ruby
number_to_phone(1234567890,  
  :area_code => true,  
  :delimiter => ' ',  
  :country_code => 1,  
  :extension => '321')  
```
+1 (123) 456 7890 x 321  
  
## Date and Time Helpers

DateTime contains:  
second(s), minute(s), hour(s), day(s), week(s), time(s), year(s)  
`Time.now + 30.days - 23.minutes` # returns a DateTime that has been modified based on the number of seconds

Date calculations from Time.now:  
ago, from_now  
`30.days.from_now - 23.minutes` is the same as `Time.now + 30.days - 23.minutes`

Relative  DateTime calculations:
`beginning_of_day` and `end_of_day`  
`beginning_of_week` and `end_of_week`  
`beginning_of_month` and `end_of_month`  
`beginning_of_year` and `end_of_year`  
`yesterday` and `tomorrow`  
`last_week` and `next_week`  
`last_month` and `next_month`  
`last_year` and `next_year`  

`Time.now.last_year.end_of_month.beginning_of_day` # a good way to jump around in time

Ruby DateTime  
`datetime.strftime(format code)`  
`Time.now.strftime("%B %d, %Y %H:%M)`

Rails DateTime  
`datetime.to_s( format_symbol )`  
:db, :number, :time, :short, :long, :long_ordinal

You can setup symbols in config/initializers/date_formats.rb  
Time::DATE_FORMATS[:custom] = "%B %e, %Y at %l:%M %p"

## Custom Helpers
* Created when generating a controller 
* Any defined will be available in view templates

Useful for: 
* Frequently used code
* Storing complex code to simplify views
* Writing large sections of Ruby code

Application based helpers should go into application_helpers file as a best practice.

## Sanitize Helpers

XSS  and HTML 
Consider all user-entered data unsafe:
* URL parms
* Form parms
* Cookie Data
* Database data

Methods:  
`html_escape()`, `h()` (have to use these in older version of rails, now its auto)  
`raw()`  
`html_safe`  
`html_safe?` - has it been marked html safe or not

`strip_links(html)` - Removes HTML links from text
`strip_tags(html)` - Remove all HTML tags from text
  
`sanitize(html, options)`  
Removes HTML and JS, watching for all tricks
Options: :tags, :attributes (as arrays) to whitelist

## Asset Pipeline
* Concatenates CSS and JS Files
  * Reduces requests to render and allows caching of these files
* Compresses/minifies CSS and JS
  * removes whitespace and comments and makes gzips
* Precompiles CSS and JS
* Allows writing assets in other languages (SASS, coffee script, ERB)
* Adds asset fingerprinting
  * allows browser to keep cached assets up to date my using an MD5 fingerprint at the end of the filename, so when the asset changes, the file name changes since the fingerprint changes

The location for these assets are in the app/assets directory.  You can still use public for static files.  
  
## Manifest Files 
Manifest files are used to set directives for including asset files.  
= require_tree . will use all files within and in subdirectories  
= require_self will use the css defined within the manifest  
  
So, the directives for including asset files cause files to be loaded, processed, concatenated, and compressed so that you serve one file back but can still develop with many files for many parts of the site.  This is true for CSS and JS. 

These manifests are processed from top to bottom but require_tree uses an unspecified order.

These are compiled into the public/assets folder.

### Development vs Processing
* Development does not do all of the above, it serves assets separately but will compile what it needs on the fly from SASS etc
* Production does not do any asset processing and assumes that assets have been precompiled.

Use the following to precompile:  
`rake assets:precompile` or `RAILS_ENV=production bundle exec rake assets:precompile`

Since dev vs prod is different in this way, it's best to test assets out in development running as production or on a qa server.

### Stylesheets
/app/assets/stylesheets  
.css or Sass .css.scss  

Rails helper for generating the CSS link tags.  The arg is the name of the manifest file.  
`<%= stylesheet_link_tag('application') %>`

You can also overwrite the default of media=screen:  
`<%= stylesheet_link_tag('application', :media => 'all') %>`

### JavaScript
/apps/assets/javascripts  
.js or .js.coffee for CofeeScript  

Since rails 3.1 jQuery is included by default

JavaScript Helper tag:  
`<%= javascript_include_tag('name_of_manifest_file') %>`  
`<%= javascript_tag("alert('Are you sure?');") %>`  
```
<%= javascript_tag do %>  
  alert('Are you sure?');  
<% end %>  
```

### Escaping JavaScript
Need to worry about user-submitted data XSS
Use `escape_javascript()` or `j()` around the user submitted value

### CoffeeScript
A scripting language that is compiled into JS with a different syntax that is supposed to be more concise and readable.  
requires coffee-rails and uglifier gems

### Images
/app/assets/images  

Image upload can be assisted with gems (paperclip and carrierwave)

Rails img tag helper:  
`<%= image_tag('logo.png') %>`  
`<%= image_tag('logo.png', :size => '90x55', :alt => 'logo') %>`  
`<%= image_tag('logo.png', :width => 90, :height => 55, :alt => 'logo') %>`  

