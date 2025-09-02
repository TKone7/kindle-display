FROM node:18-bullseye-slim AS builder
WORKDIR /build
RUN apt-get update && \
    apt-get install -y git python3 build-essential && \
    rm -rf /var/lib/apt/lists/*
COPY package*.json ./
RUN npm ci --production

FROM node:18-bullseye-slim
WORKDIR /build

# Install system dependencies
RUN apt-get update && \
    apt-get install -y firefox-esr pngcrush jo jq torsocks curl cron && \
    rm -rf /var/lib/apt/lists/*

# Copy node_modules from builder stage
COPY --from=builder /build/node_modules ./node_modules

# Copy application files
COPY . .

# Setup environment file
COPY .env.sample .env

# Setup cron job
RUN echo "PATH=/bin:/usr/bin:/usr/local/bin" > /etc/cron.d/kindle-display && \
    echo "* * * * * root /bin/bash /build/cron.sh >> /build/cron.log 2>&1" >> /etc/cron.d/kindle-display && \
    echo "" >> /etc/cron.d/kindle-display && \
    chmod 0644 /etc/cron.d/kindle-display && \
    crontab /etc/cron.d/kindle-display

# Create log file
RUN touch /build/cron.log

EXPOSE 3030

# Start cron and the application
CMD ["sh", "-c", "service cron start && npm start"]


# Build and run commands:
# docker build -t kindle-display .
# docker run --name kindle-display -p 3030:3030 -it kindle-display
# docker exec -it kindle-display bash
