# Docker Laravel Project Setup

## Prerequisites
- Docker
- Docker Compose

## Installation & Setup

1. Clone the repository and navigate to project directory:
```bash
git clone <repository-url>
cd <project-directory>
```

2. Build and start containers:
```bash
docker-compose up -d --build
```

3. Run migrations and seeders:

For first-time setup:
```bash
docker-compose exec app php artisan migrate --seed
```

For subsequent updates:
```bash
docker-compose exec app php artisan migrate
```

## Accessing the Project

- Web Application: [http://localhost:8000](http://localhost:8000)
- Database:
  - Host: localhost
  - Port: 3306
  - Database: laravel
  - Username: laravel
  - Password: laravel

## Common Commands

```bash
# Stop containers
docker-compose down

# View logs
docker-compose logs -f

# Access PHP container
docker-compose exec app bash

# Clear Laravel cache
docker-compose exec app php artisan cache:clear
```
