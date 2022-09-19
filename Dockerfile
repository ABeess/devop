FROM node:lts as dependencies

WORKDIR /nextapp
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:lts as builder

WORKDIR /nextapp
COPY . .
COPY --from=dependencies /nextapp/node_modules ./node_modules
RUN yarn build

FROM node:lts as runner

WORKDIR /nextapp
ENV NODE_ENV production

# COPY --from=builder /nextapp/next.config.js ./
# COPY --from=builder /nextapp/public ./public
COPY --from=builder /nextapp/.next ./.next
COPY --from=builder /nextapp/node_modules ./node_modules
COPY --from=builder /nextapp/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]