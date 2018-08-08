FROM ruby:2.5
RUN apt-get update
COPY . /app
WORKDIR /app
CMD ["ruby","broadband.rb"]
