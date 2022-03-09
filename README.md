# Little Etsy Shop

[![forthebadge](https://forthebadge.com/images/badges/made-with-ruby.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/uses-badges.svg)](https://forthebadge.com)![forthebadge](https://forthebadge.com/images/badges/works-on-my-machine.svg)

## About 

The Little Esty(Etsy) shop is an exercise to build a large scale relational database to mimic an ecommerce shop allowing administrators and merchants to fulfill customer invoices. This application tested our ability to:
1. Create custom rake tasks to parse and ingest CSVs into a PostreSQL database
2. Build a relational database including 7 tables, including joins tables
3. Create full CRUD workflows for many of the objects in the database
4. Create complex SQL and ActiveRecord methods using large sets of data
5. Create Views to allows users to interact and view the data within the database
6. Consume multiple public APIs to enhance the users experience

## Extensions

- Used ActiveRecord to implement functionality that limits merchants from deleting/editing discounts belonging to invoices that are pending
- Used ActiveRecord to store pertinent discount information on invoice records for referencing throughout application
- Create Bulk Discounts for holidays with one click

## Local Hosting
 
1. clone this repo to your local machine
2. run `bundle install`
3. run `rails db:{create,migrate}`
4. run `rails rake all` (to load in CSV data)
3. run `rails server`
4. go to `http://localhost:3000/` in your browser

## Web Hosted
[Hosted on Heroku Here](https://little-etsy-shop-2022.herokuapp.com)