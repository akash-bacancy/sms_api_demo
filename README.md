# README

* Assumptions -
  - For Authentication, pass auth_id as password and username as username in header of each request.
  - Count of 50 of from number is based on cache add in inbound sms for STOP messages
  - Missing parameter error is done in single line. e.g. - "To, From - are missing" or "To - are missing"
  - Invalid parameter error is done in singe line e.g -"To, From - are invalid" or "From - are invalid"

* Requirements -
	- ruby 2.6.0
	- rails 5.2.4.4
	- PostgreSQL database

* Installations steps -
	- Clone the repo
	- bundle install
	- database setup
	- load dump if present
