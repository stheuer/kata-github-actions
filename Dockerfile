### Test Stage ###
FROM node:12-alpine as stage-test

ARG NPM_TOKEN

WORKDIR /workspace

COPY . .

# Add npm token as build argument
RUN echo "//npm.pkg.github.com/:_authToken=${NPM_TOKEN}" >> .npmrc

# Install dependencies without running scripts, protecting potential compromisation of token
RUN npm install --ignore-scripts
# Remove npm Token
RUN rm -f .npmrc
# Run all postinstall scripts without token
RUN npm rebuild && npm run prepare --if-present

CMD [ "npm", "test" ]


### Build Stage ###
FROM stage-test as stage-build

RUN npm run build


### Release Stage ###
FROM node:12-alpine

WORKDIR /workspace

# Copy built files and package manifests
COPY --from=stage-build /workspace/dist ./dist
COPY --from=stage-build /workspace/package.json .
COPY --from=stage-build /workspace/package-lock.json .

RUN echo "//npm.pkg.github.com/:_authToken=${NPM_TOKEN}" >> .npmrc

# Install all production dependencies, see steps in build phase for explanation
RUN npm install --ignore-scripts --production
RUN rm -f .npmrc
RUN npm rebuild && npm run prepare --if-present

ENV PORT 8080

EXPOSE ${PORT}

CMD ["npm", "start"]
