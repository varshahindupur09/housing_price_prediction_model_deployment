# Use an official Python runtime as the base image
FROM --platform=linux/amd64 python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .

# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt


# Copy the application code and model files
COPY . .

# Expose the port the app runs on
EXPOSE 5001

# Set environment variables
ENV FLASK_APP=routers.main:app
ENV FLASK_ENV=production

# Bind Flask to 0.0.0.0 to make it accessible outside the container
CMD ["flask", "run", "--host=0.0.0.0", "--port=5001"]