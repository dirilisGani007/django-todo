# FROM python:3
# RUN pip install django==3.2
# COPY . .
# RUN python manage.py migrate
# CMD ["python","manage.py","runserver","0.0.0.0:8081"]
# Stage 1: Build Stage
FROM python:3 AS builder

WORKDIR /app
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Production Stage
FROM python:3

WORKDIR /app
COPY --from=builder /app /app

# Create a non-root user
RUN adduser --disabled-password --gecos '' appuser
USER appuser

# Expose port
EXPOSE 8081

# Run Gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:8081", "your_todo_project.wsgi:application"]

