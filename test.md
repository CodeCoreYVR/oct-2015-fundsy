# JSON APIs in Rails - Summary Notes
In many scenarios you would like to have your Rails application behave as an API, this could be useful in many scenarios such as:
- Being a backend for a mobile application
- Enable other applications to connect to your application programmatically
- Building a single page application (SPA) where most of the front end code is generated on the client side

Rails provide you with many tools to handle that.

## Controllers
The key thing to take care of when building a Rails API is to structure your controller to serve JSON to the client. This can be easily done by simply sending a JSON response back if the request is for JSON as in:
```ruby
class QuestionsController < ApplicationController
  def index
    @questions = Question.order("created_at DESC").limtit(10)
    respond_to do |format|
      format.html { redner }
      format.json { render json: @questions }
    end
  end
end
```
In the example above we send the `@questions` result back as JSON. Note that Rails will call an ActiveRecord built-in method `to_json` on each question record and send them as an array of questions in JSON format. It will include all the attributes on the model.

## Organizing and Versioning APIs Controller
It's generally recommended that you organize the controller for your API by putting them in a special folder such as `api`. This way your API controllers can behave differently from the web pages' controllers and they can be customized for the needs of the API.

It's also recommended that you version your API. This way if, for instance, you decide to roll out a new phone application, you can still support the old ones by keeping the older API version up for a period of time.

### The Routes
Let's say we create a folder structure that looks like this:
```
app
|_ controllers
   |_ api
      |_v1
        |_ questions_controller.rb
```
Then you can write your routes as such:
```ruby
namespace :api, defaults: {format: :json} do
  namespace :v1 do
    resources :questions
  end
end
```
The `namespace` method in Rails routes makes so it will will automatically look in a folder `api` then in a sub-folder `v1` for `QuestionsController`. The url for the index will be: `/api/v1/questions`.

Note also that we added the options `defaults: {format: :json}` this means you can skip the `.json` at the end of the URL to make the formant `JSON`. This is because Rails' default  format is `HTML`.

### Building the Controller
You can generate a controller now by running the generator a bit differently:
```
bin/rails g controller api/v1/questions
```
If you structured your routes as in the section above the generated controller will work and it will look like:
```ruby
class Api::V1::Questions < ApplicationController

end
```
Then if you roll out a new API version `v2` you can simple inherit all the functionality from the `V1` controller as in:
```ruby
class Api::V1::Questions < Api::V2::Questions

end
```
This automatically inherits all the functionality from one version to another and if something changes then you can simply override an action or add an action.

### Rendering JSON
As we saw earlier, we're able to render JSON by simply writing a code in the controller action that looks like:
```ruby
render json: @questions
```
And Rails will automatically render all the attributes for the object as JSON. If the object happens to be a collection then it will be sent as a JSON array. This approach is not the best as it won't be possible to customize the JSON. There are two better approaches to rendering JSON:
- JBuilder
- ActiveModel Serializer

#### JBuilder
Rails comes with `JBuilder` gem included in the `Gemfile`, you may see a line that looks like:
```ruby
gem 'jbuilder', '~> 2.0'
```
So there is no need to include an extra gem for it. So for your can render as you're render any template in Rails so that controller can look like:
```ruby
class QuestionsController < ApplicationController
  def index
    @questions = Question.order("created_at DESC").limit(10)
  end
end
```
Then you would need to have a template `/app/views/questions/index.html.jbuilder` that can look like:
```jbuilder
json.array! @questions do |question|
  json.id    question.id
  json.title question.title.capitalize
  json.url   question_url(question)
  json.answers question.answers do |answer|
    json.id answer.id
    json.body   answer.body
  end
end
```
The code above will generate a JSON which is an array of questions, each question will have an id, a capitalized title, a url and a key `answers` that references an array of answers, each answer will have an id and a body. You can find more information about customizing your `JSON` with `JBuilder` on the Github page: [https://github.com/rails/jbuilder](https://github.com/rails/jbuilder).

#### Using ActiveModel Serializers
Another approach to customize the JSON response it to use ActiveModel Serializers which is a gem that needs to be added. We start by adding the gem to the `Gemfile`:
```ruby
gem 'active_model_serializers'
```
Then we run `bundle`. After that we can generate a serializer class by running:
```ruby
bin/rails g serializer questions
```
Which will generate a class `/app/serializers/question_serializer.rb` that looks like:
```ruby
class QuestionSerializer < ActiveModel::Serializer

end
```
We can customize the class by specifying the attributes we want to generate in the JSON and declaring any associations we want to include with the JSON as well so the class may look like:
```ruby
class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :answers

  def title
    title.capitalize
  end

end
```
By defining a serializer class like the above, Rails will use this class instead of the standard `to_json` method that is built-in with ActiveRecord. So our controller can look like:
```ruby
class QuestionsController < ApplicationController
  def index
    @questions = Question.order("created_at DESC").limtit(10)
    render json: @questions
  end
end

```
And there is no need for a template file as in JBuilder. All the JSON will generated from the Serializer class.
