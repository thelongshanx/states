# About

This app will return census data about US states.

Given a comma separated list of one or more states, you can select "averages," which will give you the weighted average population below the poverty line of the states you entered. Alternatively, you could select "CSV" and get a comma separated list of the given state name(s), population(s), households(s), income below poverty level(s), and median income(s).

# Building and running the app

## You already run ruby:
Simply clone this repo and run `ruby broadband.rb` and follow the instructions.

## You don't have a ruby environment, but you do have docker:
clone this repo and run the following
`docker image build -t states:v0.1 .`
`docker container run -it states:v0.1 bash`
(from inside the container) `ruby broadband.rb`

# Assumptions
Instructions: 'If​ ​the​ ​specified​ ​output-parameter​ ​format​ ​is​ ​"averages,"​ ​output​ ​a​ ​single​ ​integer representing​ ​the​ ​weighted​ ​average​ ​of​ ​"income​ ​below​ ​poverty"​ ​across​ ​all​ ​the​ ​specified input​ ​states.' I have assumed that the way to get this is to use the total population per state (as opposed to households) and multiply that by the income below poverty number to get total population below poverty. The sum of all state populations below poverty should be divided by the sum of all state populations to get the average percent population below poverty across the given states. I have assumed "single integer" is on called out on purpose and that I should multiply by 100 and round to get a result like 17%, rather than 0.17.

I want to add headers to the csv output, but the instructions didn't say to.

# Tests
Conspiculously lacking. My apologies.