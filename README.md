# Patient Injection API

A Rails API for managing patient injections and tracking medication adherence. This application provides secure endpoints for patient registration, injection logging, and adherence calculation.

## Technology Stack

- **Ruby:** 3.2.2
- **Rails:** 8.0.0
- **Database:** PostgreSQL 16
- **Containerization:** Docker & Docker Compose
- **API Documentation:** Swagger/OpenAPI (rswag)
- **Testing:** RSpec with FactoryBot
- **Code Quality:** RuboCop

## Prerequisites

- Docker
- Docker Compose

## Quick Start with Make

This project includes a comprehensive Makefile for easy development. All commands can be executed using `make`:

### Initial Setup

```bash
# Build containers, setup database and seed data
make setup
```

This single command will:
- Build Docker containers
- Start the application
- Create and migrate database
- Seed initial data

### Development Commands

```bash
# Start the application
make up

# Stop the application
make down

# Build/rebuild containers
make build

# Install dependencies
make install

# Access Rails console
make console

# Access bash shell
make sh

# Run RSpec tests
make rspec

# Run code linting
make lint

# Generate Swagger documentation
make swagger
```

##  Database Schema

### Patients Table
- `api_key` (string, unique): Authentication token
- `treatment_schedule_days` (integer, default: 3): Days between required injections
- Timestamps

### Injections Table
- `dose` (decimal): Medication dose
- `lot_number` (string, max 6 chars): Batch identifier
- `drug_name` (string): Medication name
- `injected_at` (date): Injection date
- `patient_id` (foreign key): Associated patient
- Timestamps

##  API Endpoints

### Authentication
All API endpoints require Bearer token authentication using the patient's `api_key`.

```bash
Authorization: Bearer <patient_api_key>
```

### Available Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/patients` | Create new patient |
| POST | `/api/v1/injections` | Log new injection |
| GET | `/api/v1/injections` | List patient's injections |
| GET | `/api/v1/adherence` | Get adherence calculation |

## Usage Examples

### API Documentation

Interactive Swagger documentation is available at:
```
http://localhost:3000/api-docs
```

To regenerate documentation:
```bash
make swagger
```

## Testing

### Run All Tests
```bash
make rspec
```

### Linting
```bash
make lint
```

---
** Rails 8.0 and Docker **
