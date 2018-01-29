# Dashboards

## [KPI dashboard](https://cengage.looker.com/dashboards/115)

Statistics on Cengage systems' key performance indicators

A monitor is a collection of scripts which run every 5 minutes to check and report on the state of a Cengage’s platform (system). Each such script is run on a server in one of the available locations, one script per location. Different monitors have different number of locations configured, ranging from 1 to 8.

The status of each monitor is primarily determined by its ‘health’. At each 5-minute time range, e.g. from 10:00 am to 10:05 am, a monitor’s health is calculated as the ratio of the locations which reported status OK during that time interval to the total number of the monitor’s locations.

Each check also reports the total access time to the system, which is the sum of server time, network time, and browser time.

During a day, there are 288 checks run from each location for a monitor. So for a monitor with N locations there are 288xN checks run daily, 2016xN weekly, and 8640xN monthly.

For more information on the data and how it is collected see AppNeta PathView API Integration.

### [Another KPI dashboard](https://cengage.looker.com/dashboards/148)

KPI summary dashboard, showing the overall uptime/downtime for the Cenage top systems, in particular Jira.

## JIRA projects

### [ESCAL](https://cengage.looker.com/dashboards/104)

The basic statistics on the tickets opened and resolved in the ESCAL project during the past several months

#### More ESCAL dashboards

##### Techcheck

 - [the look](https://cengage.looker.com/looks/1543) with everyday status for all the issues in the current sprint

 - [the look](https://cengage.looker.com/looks/1545) with lead times and other times between status changes for all the issues in the current sprint

##### AW/GIA

 -  [the look](https://cengage.looker.com/looks/1544) with everyday status for all the issues in the current sprint

##### SSO + Gateway

 -   [dashboard](https://cengage.looker.com/dashboards/157) for the Gateway project

 -   [dashboard](https://cengage.looker.com/dashboards/158) for the SSO project

Currently, there are the tickets created since the start of 2014.

Note also that Looker by default only displays the first several hundred entries in a table; to get all items, click Download and select 'All results'

## Scraping

### [McGraw Hill](https://cengage.looker.com/dashboards/100)

The data on issues experienced by all the products of McGraw-Hill, as reported on status.mheducation.com . The data is available from the start of 2017.

### [Pearson](https://cengage.looker.com/dashboards/120)

The data on issues experienced by all the products of Pearson, as reported on ecollege-prod.apigee.net and in the @pearsonsupport twitter channel. The data from the website is available from Sept 2017. The twitter data is available from June, which allows to deduce the frequency of issues since that time.


###### FYI

- [Looker help: viewing dashboards](https://docs.looker.com/dashboards/viewing-user-dashboards)

- Your can edit this text - click the "Edit Source" button above to make changes.

- It's rendered with [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown).
