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

