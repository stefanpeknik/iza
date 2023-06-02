# SpendyAndy project


Author:
- Stefan Peknik - xpekni01


### Contains

- SpendyAndy app
- SpendyAndy API


## SpendyAndy app

SpendyAndy app is an application supposed to help groups of people track their spendings and pay stuff together. Currently supports only one group of people.

Data are accessed through SpendyAndy API.

## SpendyAndy API

SpendyAndy API is an API for SpendyAndy app. It works as an entrypoint to postgres database containing all of SpendyAndy data. Currently not deployed anywhere, so it is needed to be run localy to make SpendyAndy app work as well. The adress is hardcoded and set to `127.0.0.1:8080`.

To set up the databse run `docker compose up db`.
To start the API run `swift run App`. 


### Future goals

I would like to expand the app in the future with proper authentication, make it possible to create multiple groups of people and create statistics from the stored data. And of course update the UI to make it more appealing.


