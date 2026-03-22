# Disease Info

This project is basically for getting information about diseases from Health Organizations and rare disease databases. It is written in [Ruby](https://www.ruby-lang.org/en/), to contribute, check out the [Contribution Guide](https://github.com/devcenter-square/disease-info/blob/develop/CONTRIBUTING.md).

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

Populate the database with disease info from individual sources or all at once:

```
rake mine_data:who        # Scrape WHO fact sheets
rake mine_data:orphanet   # Fetch Orphanet rare disease data with prevalence
rake mine_data:all        # Fetch from all sources
```

When this is done, visit the endpoint for diseases on [http://localhost:3000/diseases](http://localhost:3000/diseases) to get a list of all diseases on your database.

## Adding a new data scraper

The present scrapers are:

* **WHO** — collects data from [WHO's Fact Sheets page](https://www.who.int/news-room/fact-sheets) (symptoms, transmission, diagnosis, treatment, prevention)
* **Orphanet** — fetches rare disease data from [Orphadata](https://www.orphadata.com/epidemiology/) epidemiology XML (6,443 diseases with prevalence data, CC BY 4.0)

Each scraper lives in `app/lib/scrapers/<source>/` and follows the same pattern: `Request`, `Response`, `Parser`, and `DiseaseParser` classes.

To add a new scraper:
1. Create your scraper classes in `app/lib/scrapers/<source>/`
2. Add a rake task in `lib/tasks/mine_data.rake`
3. Add a method to `app/lib/data_miner.rb`
4. Set `data_source` on each Disease record to your source name (e.g., "CDC")
5. Namespace the disease name with the source (e.g., "Malaria - WHO")
6. Add the source URL in the `more` column

## Available End Points

| End Point                               | Method | Expected response                                                            |
| --------------------------------------- |:------:|------------------------------------------------------------------------------|
| /diseases                               | GET    | Gets a list of all diseases                                                  |
| /diseases?data_source=source            | GET    | Gets a list of diseases from a particular source. Available sources: WHO, ORPHANET |
| /diseases/:disease                      | GET    | Gets a particular disease with the supplied name                             |
| /diseases/:disease/:attribute           | GET    | Gets a specific attribute of a disease (e.g. symptoms, treatment)           |
| /diseases/:disease/set_active_status    | PUT    | Sets the active status of a disease (is_active: true/false)                 |

### Disease Fields

Each disease record includes:

| Field | Type | Description |
|-------|------|-------------|
| name | string | Disease name with source suffix (e.g., "Malaria - WHO") |
| data_source | string | Source identifier: "WHO" or "ORPHANET" |
| prevalence | decimal | Cases per 100,000 population (null if unavailable) |
| facts | array | Key facts about the disease |
| symptoms | array | Symptom descriptions |
| transmission | array | Transmission methods |
| diagnosis | array | Diagnostic procedures |
| treatment | array | Treatment information |
| prevention | array | Prevention strategies |
| more | string | Source URL |
| is_active | boolean | Whether the disease record is active |

## Road Map

To see it live, visit the deployed API. For a specific disease, use `/diseases/tuberculosis`. Disease-info prettifies JSON on production; if you want JSON prettified in development and you are using Chrome, you could install [JSON Formatter](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa?hl=en) to get a prettier display.

### To Do
First see the [Contribution Guide](https://github.com/devcenter-square/disease-info/blob/develop/CONTRIBUTING.md) for how to contribute.
- [ ] Add more Health Organizations' disease information sites (e.g., CDC)
- [ ] Include a way to verify the scraped data
- [x] ~~Put the symptoms of each disease in an array~~
- [x] ~~Add a second data source (Orphanet)~~
- [x] ~~Add prevalence field~~
