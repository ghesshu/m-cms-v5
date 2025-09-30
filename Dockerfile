# Use Node.js 20 as specified in .nvmrc
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install system dependencies and enable Yarn
RUN apk add --no-cache libc6-compat && \
    corepack enable && \
    corepack prepare yarn@stable --activate

# Copy all files (simpler approach for monorepo)
COPY . .

# Install dependencies
RUN yarn install --immutable

# Run setup (yarn && yarn clean && yarn build --skip-nx-cache)
RUN yarn setup

# Change to the examples/empty directory
WORKDIR /app/examples/empty

# Expose the default Strapi port
EXPOSE 1337

# Start the application
CMD ["yarn", "start"]