# Docker Setup

## Build Image

docker build -t log-analyzer -f docker/Dockerfile .

## Run Container

docker run -p 8000:8000 log-analyzer

## Test Endpoints

http://localhost:8000/health

http://localhost:8000/docs
