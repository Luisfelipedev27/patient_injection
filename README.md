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

## Implemented Features & Bonus Objectives

### Core Features

#### **Patient Management**
- [x] **Patient Registration**: Create patients with unique API keys for authentication
- [x] **Treatment Schedule Configuration**: Configurable treatment schedule days (default: 3 days)
- [x] **Unique API Key Generation**: Secure patient identification system
- [x] **Data Validation**: Comprehensive input validation for patient data

#### **Injection Logging**
- [x] **Injection Recording**: Log medication injections with detailed information
- [x] **Dose Tracking**: Record medication doses with decimal precision
- [x] **Batch Tracking**: Lot number validation (maximum 6 characters)
- [x] **Drug Name Management**: Track different medication types
- [x] **Date Tracking**: Record injection dates with proper validation
- [x] **Patient Association**: Link injections to authenticated patients

#### **Adherence Calculation**
- [x] **Adherence Percentage**: Calculate treatment compliance percentage
- [x] **Expected vs Actual**: Compare expected injections based on schedule
- [x] **Treatment Timeline**: Track treatment duration and progress

### API Features

#### **RESTful API Design**
- [x] **Clean Endpoints**: Well-structured API with consistent patterns
- [x] **JSON Responses**: Structured data format with proper serialization
- [x] **HTTP Status Codes**: Appropriate status codes for different scenarios
- [x] **Bearer Token Authentication**: Secure API key-based authentication

#### **Authentication & Security**
- [x] **API Key Authentication**: Unique patient identification system
- [x] **Bearer Token Implementation**: Standard Authorization header format
- [x] **Data Validation**: Server-side validation for all inputs

### Documentation & Testing

#### **API Documentation (Swagger/OpenAPI)**
- [x] **Interactive Documentation**: Swagger UI available at `/api-docs`
- [x] **Complete Endpoint Coverage**: All endpoints documented with examples
- [x] **Request/Response Examples**: Detailed examples for all operations
- [x] **Authentication Documentation**: Clear instructions for API key usage

#### **Comprehensive Testing Suite**
- [x] **RSpec Test Framework**: Complete test coverage with RSpec
- [x] **Factory Bot Integration**: Test data factories for consistent testing
- [x] **Request Specs**: API endpoint testing with authentication
- [x] **Authentication Tests**: Security and authorization testing

#### **Code Quality & CI/CD**
- [x] **RuboCop Integration**: Automated code style enforcement
- [x] **GitHub Actions CI**: Continuous integration pipeline
- [x] **Automated Testing**: Tests run on every commit and pull request
- [x] **Linting Pipeline**: Code style checks in CI/CD
- [x] **Make Commands**: Simplified development workflow
- [x] **Docker Integration**: Containerized development environment

---
**Built with Rails 8.0, Docker, and modern development practices, thank you very much for the opportunity**

Luis Felipe
