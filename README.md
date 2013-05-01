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
    
    first_post = blog.articles.first

    first_post.id     # => "2013_05_01_My_first_post"
    first_post.title  # => "My first post"
    first_post.body   # => "<h3>My first post!</h3>\n<p>blah blah blah</p>"

    first_post.date   # => #<Date: 2013-05-01 ((2456414j,0s,0n),+0s,2299161j)>
    first_post.year   # => 2013
    first_post.month  # => 05
    first_post.day    # => 01

### Monthly archive

    may_archive = blog.monthly_archive.first

    may_archive.year      # => 2013
    may_archive.month     # => 5
    may_archive.articles  # => [ Rollin::Article(:title => "My first post" ...) ]

### Annual archive

    twenty_thirteen_archive = blog.annual_archive.first

    twenty_thirteen_archive.year                 # => 2013
    twenty_thirteen_archive.articles             # => [ Rollin::Article(:title => "My first post" ...) ]
    twenty_thirteen_archive.monthly_archive      # => [ Rollin::MonthArchive(:year => 2013, :month => 5 ...) ]

### Finding an article

    blog.find_article_by_id('2013_05_01_My_first_post')  # => #Rollin::Article(:title => "My first post" ...)

## Build status

[![Build Status](https://travis-ci.org/marano/rollin.png)](https://travis-ci.org/marano/rollin)

## Contributing

1. Pull request!
