# RalVend Back End

RalVend requires a back-end to provide stability and some degree of recovery in case of catastrophe such as getting all copies of in-world components deleted.
Of course, it's up to the merchant to keep backups of the back-end: data and ideally also files.

A back-end often (always?) comes with an administration back-office. **The back-office is NOT part of this project**. It's up to you, the merchant, to build your own, get someone to build one for you or use a SasS service when/if such a thing ever comes to exist.

## Setup for development

If you know your way around Docker then the best way to setupt your dev environment ot start hacking the back-end is to build the container.

First, make sure to copy the files: `docker-compose.sample.yml` and `Dockerfile.sample`. Modify `docker-compose.yml` to meet your needs then, open a terminal, navigate to the directory where the `Dockerfile` file is and run:

    docker compose up --build -d

Your back-end will be listening to requests in `localhost` and the port you specified. If you didn't change anything in `docker-compose.yml` then the port is `9999`: 

    http://localhost:9999/public


If you don't use Docker, then I'll leave it to you to figure out how to get this running.

## Setup for production

How to setup RalVend's back-end for production depends on so many things that I won't even try to cover it here.
It's up to you to figure out how to do it or hire someone to do it for you.

## Scope

RalVend project includes the portions of the back-end necessary for the system to work.
If you have a shared Web hosting account then you can set up your own back-end and start using RalVend in Second Life. 

### One merchant

This back-end is limited to one single merchant. RalVend's architecture supports multipe merchants but such functionality is not possible with this back-end application as-is.

### File based data management

This application is designed to allow the use of a DBMS such as MySQL, Maria or something else but none of that is shipped out of the box.
What you get instead is file-based data management. All the data is stored in JSON files.

The shipped data management will likely be enough for most cases. Merchants with a large volume of sales may have to consider implementing data adapters that work with a DBMS instead.
These merchants may also benefit from a better hosting service for hiegher uptime and better performance: a VPS, a dedicated service or ideally a cloud-based solution.

### What about administration?

The back-end uses configuration files to "know how to do things". Without a back-office included you have to work with the configuration files manually. 

You can use an FTP client to connect to your server and download all the JSON files. Then use external tools to generate reports or convert JSON to othe format such as CSV in the middle.
The important thing here is that **YOU are in control of your data**, you are only limited by your imagination, your skills or your budget.
