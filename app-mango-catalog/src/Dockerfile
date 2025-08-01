# Use the official lightweight Python image based on Alpine Linux
FROM python:alpine

# Set the working directory inside the container to /app
WORKDIR /app

# Copy the requirements.txt file into the container at /app
COPY requirements.txt requirements.txt

# Install the Python dependencies specified in requirements.txt
RUN pip install -r requirements.txt

# Copy the entire contents of the current directory to /app inside the container
COPY . .

# Expose port 8080 to allow external access to the container's Flask app
EXPOSE 8080

# Define the command to run the Flask app when the container starts
CMD ["python", "app.py"]
