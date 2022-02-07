# Common Docker Compose for Laravel projects

### This docker composes configuration includes:
 - **PHP Image**
   - Available to set PHP version through build args
   - Optimized INI-files
   - Multi-stage build (local and production steps)
   - BuildIn Composer
   - Including XDebug for local environment
   - Powerful entrypoint for local environment
     - Auto install\update composer dependency
     - Auto generate security key
     - Auto migration
   - Automated composer installation in production
 - **Nginx Image**
   - Basic config for Laravel apps
 - **PostgresSQL Image**
   - Environments for database initialization
 - **Redis Image**

### How to build:
 - if it is your first launch `make build up`
 - else `make up`
 - done!

## Currently using images:
 - **PHP:** 8.1
 - **Nginx:** 1.21.6
 - **PostgresSQL:** 14.1
 - **Redis:** 6.2.6
