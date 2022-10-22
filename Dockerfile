# syntax=docker/dockerfile:1
FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /personal_dashboard_back
COPY Gemfile /personal_dashboard_back/Gemfile
COPY Gemfile.lock /personal_dashboard_back/Gemfile.lock
# Fix "NameError: uninitialized constant Gem::Source" when using
# Ruby 3.1.2 with Rails 7
RUN gem update bundler
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]

