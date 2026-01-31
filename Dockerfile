# Build stage
FROM golang:1.24-alpine AS builder

# Install necessary build tools
RUN apk add --no-cache git ca-certificates

# Set working directory
WORKDIR /app

# Copy dependency files first for better caching
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app/server ./cmd

# Final stage
FROM alpine:3.19

# Install CA certificates for HTTPS requests
RUN apk add --no-cache ca-certificates tzdata

# Set timezone (optional, change as needed)
ENV TZ=Asia/Taipei

# Create non-root user for security
RUN adduser -D -g '' appuser

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/server .

# Change ownership
RUN chown -R appuser:appuser /app

# Use non-root user
USER appuser

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["./server"]
