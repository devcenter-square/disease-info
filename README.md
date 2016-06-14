# DISEASE INFO

This project is basically for getting information about diseases from Health Organizations -  WHO, CDC et al.

## Getting Started

Clone the project repository by running the command below if you use SSH

```git clone git@github.com:devcenter-square/disease-info.git```

If you use https, use this instead

```git clone https://github.com/devcenter-square/disease-info.git```

## Database

This project uses **Mysql**, if you already have it installed on your machine, you can skip to the next step.

If you don't have it installed:

### Mac users

You can install it with
```brew update && brew install mysql```

Skip this part **unless** you are having errors setting up your DB.

Create a config file at any location of your choice e.g

```touch /usr/local/etc/my.cnf```

Then type this in the file

```
[mysqld]
skip-external-locking
```

### Others

Please follow the instructions [here](http://dev.mysql.com/doc/refman/5.7/en/installing.html).

## Setting Up

* `cd` into the project directory.
* Run `bundle install`
* then `rake db:create`
* then `rake db:migrate`

## Populating the Database

Populate Database with disease info by running

`rake mine_data:who`

When this is done, visit  the endpoint for diseases on [http://localhost:3000/diseases.json](http://localhost:3000/diseases.json) to get a list of all diseases on your database.

## Adding a new data scraper

The present scrapers are:

* WHO, collects data from [WHO's Infectious diseases page](http://www.who.int/topics/infectious_diseases/factsheets/en/)

Feel free to add another scraper by first adding your rake task to the present list on `lib/tasks/mine_data.rake`.
Then create your scraper in `app/lib/scrapers`. You can follow the example of the WHO scraper.
If you have to add new columns to the existing Disease structure based on the data you get, feel free to do that.
More importantly, add the source of your data in the `more` column present on the Disease object.
Make sure to name space your Disease name with the source. For example Malaria from WHO is saved with name Malaria - WHO.

## Available End Points

| End Point                          | Method      |  Expected response                                                             |
| ---------------------------------- |:-----------:|--------------------------------------------------------------------------------|
| /diseases.json                     |  GET        |  Gets a list of all diseases                                                   |
| /diseases.json?data_source=source  |  GET        |  Gets a list of diseases from a particular source. Available sources are; WHO  |
| /diseases/disease_name.json        |  GET        |  Gets a particular disease with the supplied name                              |


