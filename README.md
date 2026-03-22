# Disease Info

This project is basically for getting information about diseases from Health Organizations - WHO, CDC et al. It is written in [Ruby](https://www.ruby-lang.org/en/), to contribute, check out the [Contribution Guide](https://github.com/devcenter-square/disease-info/blob/develop/CONTRIBUTING.md).

## Requirements

- Ruby 3.2.10
- Rails 7.1
- SQLite3 (development/test)
- PostgreSQL (production)

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
* then `rails db:create`
* then `rails db:migrate`

## Populating the Database

Populate Database with disease info by running

`rake mine_data:who`

When this is done, visit the endpoint for diseases on [http://localhost:3000/diseases](http://localhost:3000/diseases) to get a list of all diseases on your database.

## Adding a new data scraper

The present scrapers are:

* WHO, collects data from [WHO's Fact Sheets page](https://www.who.int/news-room/fact-sheets)

Feel free to add another scraper by first adding your rake task to the present list on `lib/tasks/mine_data.rake`.
Then create your scraper in `app/lib/scrapers`. You can follow the example of the WHO scraper.
If you have to add new columns to the existing Disease structure based on the data you get, feel free to do that.
More importantly, add the source of your data in the `more` column present on the Disease object.
Make sure to name space your Disease name with the source. For example Malaria from WHO is saved with name Malaria - WHO.

## Available End Points

| End Point                               | Method | Expected response                                                            |
| --------------------------------------- |:------:|------------------------------------------------------------------------------|
| /diseases                               | GET    | Gets a list of all diseases                                                  |
| /diseases?data_source=source            | GET    | Gets a list of diseases from a particular source. Available sources are: WHO |
| /diseases/:disease                      | GET    | Gets a particular disease with the supplied name                             |
| /diseases/:disease/:attribute           | GET    | Gets a specific attribute of a disease (e.g. symptoms, treatment)           |
| /diseases/:disease/set_active_status    | PUT    | Sets the active status of a disease (is_active: true/false)                 |

## Road Map

To see it live, visit the deployed API. For a specific disease, use `/diseases/tuberculosis`. Disease-info prettifies JSON on production; if you want JSON prettified in development and you are using Chrome, you could install [JSON Formatter](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa?hl=en) to get a prettier display.

### To Do
First see the [Contribution Guide](https://github.com/devcenter-square/disease-info/blob/develop/CONTRIBUTING.md) for how to contribute.
- [ ] Add more Health Organizations' disease information sites
- [ ] Include a way to verify the scrapped data
- [ ] Put the symptoms of each disease in an array
