FROM ruby:3.0.0

RUN apk update \
    && apk add --update make gcc g++

# Install gems
WORKDIR /home/solargraph
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install --jobs=4
RUN gem install solargraph yard

# Generate gem documentation
RUN yard gems

# Convert rails documentation
RUN solargraph bundle

# Solargraph server port
EXPOSE 7658

# Run Solargraph
CMD [ "solargraph", "socket", "--host=0.0.0.0", "--port=7658" ]