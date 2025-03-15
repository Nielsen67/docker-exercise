# Stage 1: Build stage
FROM golang:1.23.3-alpine3.20 AS build

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum (if it exists)
COPY go.mod ./
# Use a RUN command to copy go.sum optionally
RUN if [ -f go.sum ]; then cp go.sum .; fi
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o service .

# Stage 2: Final stage
FROM alpine:edge

# Set the working directory
WORKDIR /app

# Copy the binary from the build stage
COPY --from=build /app/service .

# Set the timezone and install CA certificates
RUN apk --no-cache add ca-certificates tzdata

# Expose the port (adjust if your app uses a different port)
EXPOSE 8080

# Set the entrypoint command
ENTRYPOINT ["/app/service"]