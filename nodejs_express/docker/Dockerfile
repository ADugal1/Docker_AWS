FROM node:10.16.2-stretch

WORKDIR /usr/src/app

ENV NODE_ENV production

# Install envsubst
RUN apt-get update && apt-get install -y gettext
COPY docker/custom-entrypoint /usr/local/bin/
RUN chmod u+x /usr/local/bin/custom-entrypoint
ENTRYPOINT ["custom-entrypoint"]
RUN mkdir /usr/src/app/config/

# Copy config files
COPY config/*.tmp /tmp/config/

# Install Node.js dependencies
COPY package*.json /usr/src/app/
RUN npm ci --only=production

# Copy Node.js files
COPY css /usr/src/app/css
COPY img /usr/src/app/img
COPY views /usr/src/app/views
COPY server.js /usr/src/app/

HEALTHCHECK --interval=15s --timeout=10s --start-period=60s --retries=2 CMD curl -f http://127.0.0.1:8080/health-check || exit 1

# Expose port 8080 and start Node.js server
EXPOSE 8080
CMD ["node", "server.js"]
