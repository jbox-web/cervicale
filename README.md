## Cervicale

### A CalDav server built on Rails

**This development is still in alpha. Use at your own risks.**

The aim of this Rails app is to provide :

* a CalDav server accessible by CalDav clients (Thunderbird, etc...)
* a web interface to manage calendars and eveything around :
  * add/update/delete calendars
  * add/update/delete events/tasks
  * manage share/permissions

The basics are implemented but it needs some additionnal work :

* add support for alarms
* add support for event's participants
* a cleaner/better implementation of the CalDav server

This app should be considered as a POC (Proof Of Concept) of a CalDav server implementation in Ruby/Rails.

## Roadmap

* Finish CalDav server implementation
* Extract the CalDav server in gem (the server should be mountable in a standard Rails app)

## Why?

I know some alternatives exist out there to manage calendars like :

* [http://calendarserver.org/](http://calendarserver.org/) (Python)
* [http://radicale.org/](http://radicale.org/) (Python)
* [http://baikal-server.com/](http://baikal-server.com/) (Php)
* [https://owncloud.org/](https://owncloud.org/) (Php)

(The full list [here](http://caldav.calconnect.org/implementations/servers.html))

But none of them is in Ruby.

I thought it would be nice to have a Ruby alternative. Thus this project.

## Contribute

You can contribute to this plugin in many ways such as :
* Helping with documentation
* Contributing code (features or bugfixes)
* Reporting a bug
* Submitting translations
