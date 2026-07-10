# Stage 1: Install production dependencies
FROM node:24-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Stage 2: Production runner
FROM node:24-alpine AS runner

# Set working directory
WORKDIR /app

# Set NODE_ENV to production
ENV NODE_ENV=production

# Copy dependencies from builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./

# Copy source code
COPY src ./src

# Expose port
EXPOSE 8989

# Use non-root user for security
USER node

# Run the application
CMD ["node", "src/index.js"]
