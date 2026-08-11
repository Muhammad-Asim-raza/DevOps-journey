# DevOps Sample App

A sample Python application with full CI/CD pipeline.

## Run Locally
```bash
python3 app.py
```

## Run Tests
```bash
pip install -r requirements.txt
pytest test_app.py -v
```

## CI/CD Pipeline
Every push triggers:
1. Code quality check (flake8)
2. Unit tests (pytest)
3. Coverage report
4. Build Docker image (on main branch)
