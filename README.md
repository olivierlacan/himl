# Himl

Himl is an HTML-based Indented Markup Language for Ruby.


## What's This?

Himl is a yet another template engine for Haml-lovers and non Haml lovers, deriving HTML validity from Haml and syntax intuitiveness from ERB.


## Motivation

Haml is a great template engine that liberates us from annoying HTML bugs.
By automatically closing the HTML tags, Haml always produces perfectly structured 100% valid HTML responses.
Actually, I've never experienced the HTML closing tag mismatch error over the past 10 years or so, thanks to Haml.

However, the Haml (or Slim or whatever equivalent) syntax is very much different from that of HTML.
And to be honest, I still rarely can complete my template markup works without consulting the Haml online reference manual.

Oh, why do we have to learn another markup language syntax where we just want to generate HTML documents?
HTML has tags. HTML has indentations. Why can't we just use them?


## Syntax

Himl syntax is a hybrid of ERB and Haml.
Himl is basically just a kind of ERB. Indeed, Himl documents are compiled to ERB internally, then rendered by the ERB handler.

So, the following Himl template opening and closing a tag will be compiled to exactly the same ERB template.

Himl
```erb
<div>
</div>
```

ERB
```erb
<div>
</div>
```

You can omit closing tags. Then Himl auto-closes them, just like Haml does.

Himl
```erb
<div>
```
ERB
```erb
<div>
</div>
```

For nesting tags, use whitespaces just like you do in the Haml templates.

Himl
```erb
<section>
  <div>
```

ERB
```erb
<section>
  <div>
  </div>
</section>
```

Of course you can include dynamic Ruby code in the ERB way.

Himl
```erb
<section>
  <div>
    <%= post.content %>
```

ERB
```erb
<section>
  <div>
    <%= post.content %>
  </div>
</section>
```

You can open and close tags in the same line.

Himl
```erb
<section>
  <h1><%= post.title %></h1>
```

ERB
```erb
<section>
  <h1><%= post.title %></h1>
</section>
```

There's no special syntax for adding HTML attributes to the tags. You see, it's just ERB.

Himl
```erb
<section class="container">
  <div class="content">
```

ERB
```erb
<section class="container">
  <div class="content">
  </div>
</section>
```


## Example

Following is a comparison of ERB, Haml, and Himl templates that renderes similar HTML results (the Haml example is taken from the [Haml documentation](http://haml.info/)).
You'll notice that Himl consumes the same LOC with the Haml version for expressing the structure of this document, without introducing any new syntax from the ERB version.

### ERB Template
```erb
<section class="container">
  <h1><%= post.title %></h1>
  <h2><%= post.subtitle %></h2>
  <div class="content">
    <%= post.content %>
  </div>
</section>

```

### Haml Template
```haml
%section.container
  %h1= post.title
  %h2= post.subtitle
  .content
    = post.content
```

### Himl Template
```erb
<section class="container">
  <h1><%= post.title %></h1>
  <h2><%= post.subtitle %></h2>
  <div class="content">
    <%= post.content %>
```


## Installation

Bundle 'himl' gem to your project.


## Usage

The gem contains the Himl template handler for Rails.
You need no extra configurations for your Rails app to render `*.himl` templates.


## Runtime Performance

Since every Himl template is converted to ERB, then cached as a Ruby method inside the view frameworks (such as Action View in Rails), Himl runtime performance in production is exactly the same with that of ERB.


## Contributing

Pull requests are welcome on GitHub at https://github.com/amatsuda/himl.


## Other Template Engines That I Maintain

### [jb](https://github.com/amatsuda/jb)

A faster and simpler and stronger alternative to Jbuilder.

### [string_template](https://github.com/amatsuda/string_template)

The ultimate fastest template engine for Rails in the world.

### [Haml](https://github.com/haml/haml)

The one that you may be currently using everyday.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
