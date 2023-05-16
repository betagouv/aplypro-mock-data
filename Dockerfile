FROM ruby:3.2-slim

EXPOSE 3002

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y build-essential

WORKDIR /bundle
COPY Gemfile Gemfile.lock .
RUN bundle install

WORKDIR /app
COPY . .

CMD ["ruby", "server.rb"]
