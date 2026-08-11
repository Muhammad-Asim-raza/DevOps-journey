# Day 23 Exercises — Sample App, Testing & Docker

**Date:** Jul 12 2026
**Status:** ✅ Completed

---

## Exercise 1: Sample App Setup ✅

Created a Python application, wrote comprehensive unit tests, verified that all tests pass locally, and created a Dockerfile to containerize the application.

### Tasks Completed

* [x] Created Python application with multiple functions
* [x] Created comprehensive unit tests using `pytest`
* [x] Tested normal and edge-case behavior
* [x] Verified all tests pass locally
* [x] Created `requirements.txt`
* [x] Created a Dockerfile
* [x] Learned the basic structure of a Dockerfile
* [x] Learned how application files are copied into a container
* [x] Learned how Python dependencies are installed inside an image
* [x] Learned how the application starts inside a container

---

## Project Structure

```text
day23-practice/
└── sample-app/
    ├── app.py
    ├── test_app.py
    ├── requirements.txt
    └── Dockerfile
```

---

## Python Application

The application contains functions for:

* Addition
* Subtraction
* Multiplication
* Division
* Greeting users
* Health checks

---

## Testing

Tests were written using **pytest** to verify both normal behavior and edge cases.

### Test Cases

All 11 tests are passing:

* `test_add_positive` ✅
* `test_add_negative` ✅
* `test_subtract` ✅
* `test_multiply` ✅
* `test_divide_normal` ✅
* `test_divide_by_zero` ✅
* `test_greet_valid` ✅
* `test_greet_empty` ✅
* `test_health_check_returns_dict` ✅
* `test_health_check_status` ✅
* `test_health_check_has_version` ✅

### Test Result

```text
11 tests passed
```

This confirmed that the application works correctly before containerization.

---

# Dockerfile Learning

The application was containerized using a Dockerfile.

### Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python3", "app.py"]
```

---

## Dockerfile Concepts Learned

### 1. `FROM`

```dockerfile
FROM python:3.11-slim
```

Defines the **base image** for the application.

The application needs Python, so a Python base image is used.

---

### 2. `WORKDIR`

```dockerfile
WORKDIR /app
```

Creates/sets `/app` as the working directory inside the container.

It is similar to:

```bash
cd /app
```

inside the container.

---

### 3. `COPY`

```dockerfile
COPY requirements.txt .
```

Copies the dependency file from the build context into the container.

Then:

```dockerfile
COPY . .
```

copies the application files into the container.

---

### 4. Installing Dependencies

```dockerfile
RUN pip install --no-cache-dir -r requirements.txt
```

Installs the Python packages listed in `requirements.txt` inside the Docker image.

---

### 5. `CMD`

```dockerfile
CMD ["python3", "app.py"]
```

Defines the default command that runs when a container is started.

In this case:

```bash
python3 app.py
```

starts the application.

---

## Dockerfile Creation Process Learned

Before creating a Dockerfile, identify:

1. **Application language**

   * Python
   * Node.js
   * Java
   * Go
   * etc.

2. **Base image**

   * Choose an image containing the required runtime.

3. **Dependency file**

   * Python → `requirements.txt`
   * Node.js → `package.json`
   * Go → `go.mod`
   * Java Maven → `pom.xml`

4. **Application files**

   * Determine which files the application needs inside the container.

5. **Startup command**

   * Determine how the application normally starts.

For this project:

```text
Python application
       ↓
python:3.11-slim
       ↓
requirements.txt
       ↓
pip install
       ↓
copy application
       ↓
python3 app.py
```

---

## Docker Build & Run

Build the Docker image:

```bash
docker build -t sample-app .
```

Run the container:

```bash
docker run sample-app
```

The Docker workflow is:

```text
Dockerfile
    ↓
docker build
    ↓
Docker Image
    ↓
docker run
    ↓
Container
    ↓
Python Application
```

---

## Key Learning

This exercise established the basic workflow:

```text
Write application
       ↓
Write tests
       ↓
Run tests locally
       ↓
Create requirements.txt
       ↓
Create Dockerfile
       ↓
Build Docker image
       ↓
Run application in container
```

### Main Concepts Learned

* Python application structure
* Unit testing with pytest
* Testing normal cases
* Testing edge cases
* Dependency management with `requirements.txt`
* Docker images vs containers
* Dockerfile structure
* `FROM`
* `WORKDIR`
* `COPY`
* `RUN`
* `CMD`
* Docker build context
* Building an image
* Running a container

---

## Proof

See:

```text
practices/day23-practice/exercise1-proof.txt
practices/day23-practice/sample-app/
```

### Files

```text
sample-app/
├── app.py
├── test_app.py
├── requirements.txt
└── Dockerfile
```

---

## Summary

Exercise 1 was completed successfully.

The Python application was created, tested with **11 passing tests**, and containerized using Docker.

**Result:** ✅ Application tested locally and prepared to run inside a Docker container.

