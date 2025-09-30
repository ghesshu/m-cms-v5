# Use Node.js 20 as specified in .nvmrc
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Enable Yarn
RUN corepack enable

# Copy package.json files first for better Docker layer caching
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

# Copy workspace package.json files
COPY packages/*/package.json ./packages/*/
COPY packages/*/*/package.json ./packages/*/*/
COPY examples/*/package.json ./examples/*/
COPY examples/plugins/*/package.json ./examples/plugins/*/
COPY .github/actions/*/package.json ./.github/actions/*/
COPY scripts/*/package.json ./scripts/*/

# Install dependencies
RUN yarn install 

# Copy the rest of the application
COPY . .

# Run setup (yarn && yarn clean && yarn build --skip-nx-cache)
RUN yarn setup

# Change to the examples/empty directory
WORKDIR /app/examples/empty

# Expose the default Strapi port
EXPOSE 1337

# Start the application
CMD ["yarn", "start"]