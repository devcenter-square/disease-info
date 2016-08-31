# Disease Info

This project is basically for getting information about diseases from Health Organizations -  WHO, CDC et al. It is written in [Ruby](https://www.ruby-lang.org/en/), to contribute, check out the [Contribution Guide](https://github.com/devcenter-square/disease-info/blob/develop/CONTRIBUTION.md).

## Getting Started

Clone the project repository by running the command below if you use SSH

```git clone git@github.com:devcenter-square/disease-info.git```

If you use https, use this instead

```git clone https://github.com/devcenter-square/disease-info.git```

## Database

This project uses **SQLite3** for development and testing and **PostgreSQL** for production. To contribute, you only need to install SQLite3. If you already have it installed on your machine, you can skip to the next step.

If you don't have it installed, check the following links for guides on how to install:
- [SQLite - Installation](http://www.tutorialspoint.com/sqlite/sqlite_installation.htm) by Tutorials Point
- [How to install SQLite3](http://mislav.net/rails/install-sqlite3/) by Mislav Marohnić

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

## Road Map
This will be the first release and we are tagging it v1.0. To see it live, go to https://disease-info-api.herokuapp.com/diseases. For specific a specific disease, use https://disease-info-api.herokuapp.com/diseases/tuberculosis. Also if you are using Chrome to access the site you could install [JSON Formatter](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa?hl=en) to get a prettier display.

### To Do
First see the [Contribution Guide](https://github.com/devcenter-square/disease-info/blob/develop/CONTRIBUTION.md) for how to contribute.
- [ ] Add more Health Organizations' disease information sites
- [ ] Include a way to verify the scrapped data
