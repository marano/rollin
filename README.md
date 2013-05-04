# rollin

A Ruby minimalistic filesystem based blog engine made for developers.

Different from other blog engines, rollin only does what matters, and leave the rest to you.

It currently supports Markdown format and uses the Github's awesome redcarpet.

## Installation

Add the dependency to your Gemfile:

    gem 'rollin'

## Usage

### Filesystem structure

First you will need to have the following structure in your filesystem.

    ├── posts
        └── 2013_05_01_My_first_post.mk

### Articles
    
    blog = Rollin::Blog.new({articles_folder: "posts"}) # Defaults to "articles"
    
    article = blog.articles.first

    article.id        # => "2013_05_01_My_first_post"
    article.title     # => "My first post"
    article.body      # => "<h3>My first post!</h3>\n<p>blah blah blah</p>"

    article.date      # => #<Date: 2013-05-01 ((2456414j,0s,0n),+0s,2299161j)>
    article.year      # => 2013
    article.month     # => 05
    article.day       # => 01

### Metatags

You may define articles metatags at the beginning of your article with the format:

    ---
    author: Zé
    title: My new awesome blog!
    tags: development, fun
    ---

This is how you access the tag information.

    article.metatags  # => { 'title' => 'My new awesome blog!',
                             'author' => 'Zé',
                             'tags' => [ 'development', 'fun' ] }


It is YAML snippet and follows a similar format to Jekyll's [yaml front matter](https://github.com/mojombo/jekyll/wiki/yaml-front-matter). Except that our special variables are different:

| Metatag | Description |
|:------- |:----------- |
| title   | The article title. It overrides the on extracted from the file name. |

### Inquiring metatags

    blog.metatags  # => A list of metatag objects

    author_metatag = blog.metatags.first

    author_metatag.label           # => "tags"
    author_metatag.values          # => A list of metatag value objects

    author_metatag_value = metatag.values.fist
    author_metatag_value.content   # => "Zé"
    author_metatag_value.articles  # => A list of articles containing that metatag value

### Finding a articles

#### By article id

    blog.article('2013_05_01_My_first_post')  # => #Rollin::Article(:title => "My first post" ...)

#### By metatag

    blog.articles(:tags => "development")  # => A list of articles tagged with development

#### By date

    blog.articles(:year => 2013)                          # => A list of articles for that year
    blog.articles(:year => 2013, :month => 5)             # => A list of articles for that month
    blog.articles(:year => 2013, :month => 5, :day => 1)  # => A list of articles for that day

### Archive

#### Monthly

    may_archive = blog.monthly_archive.first

    may_archive.year      # => 2013
    may_archive.month     # => 5
    may_archive.articles  # => [ Rollin::Article(:title => "My first post" ...) ]

#### Annual

    twenty_thirteen_archive = blog.annual_archive.first

    twenty_thirteen_archive.year                 # => 2013
    twenty_thirteen_archive.articles             # => [ Rollin::Article(:title => "My first post" ...) ]
    twenty_thirteen_archive.monthly_archive      # => [ Rollin::MonthArchive(:year => 2013, :month => 5 ...) ]

### More datailed documentation

You can find a more detailed documentation at the [rollin_spec.rb](https://github.com/marano/rollin/blob/master/spec/rollin_spec.rb) file.

## Build status

[![Build Status](https://travis-ci.org/marano/rollin.png)](https://travis-ci.org/marano/rollin)

## Contributing

1. Pull request!
