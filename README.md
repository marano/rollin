# Rollin

A Ruby minimalistic filesystem based blog engine made for developers.

Different from other blog engines Rollin only does what matters, and leave the rest to you.

Rollin currently only supports Markdown format and uses the Github's awesome redcarpet.

## Installation

Add the dependency to your Gemfile:

    gem 'rollin'

## Usage

### Filesystem structure

First you will need to have the following structure in your filesystem.

    ├── my_posts
        └── 2013_05_01_My_first_post.mk

### Getting articles

In your code.
    
    blog = Rollin::Blog.new({article_folder: "my_posts"}) # Defaults to "articles"
    
    anArticle = blog.articles.first

    anArticle.date   # => #<Date: 2013-05-01 ((2456414j,0s,0n),+0s,2299161j)>
    anArticle.year   # => 2013
    anArticle.month  # => 05
    anArticle.day    # => 01
    anArticle.title  # => "My first post"
    anArticle.body   # => "<h3>My first post!</h3>\n<p>blah blah blah</p>"

### Getting the archive

    a_monthly_archive = blog.monthly_archive.first

    a_monthly_archive.year      # => 2013
    a_monthly_archive.month     # => 5
    a_monthly_archive.articles  # => [ Rollin::Article(:title => "My first post" ...) ]

## Build status

[![Build Status](https://travis-ci.org/marano/rollin.png)](https://travis-ci.org/marano/rollin)

## Contributing

1. Pull request!
