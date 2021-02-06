FROM ruby:3.0.0-alpine
RUN apk --no-cache add make gcc libc-dev make libxml2 libxslt-dev g++ ncurses libffi-dev
WORKDIR '/app'
COPY Gemfile* ./
RUN bundle install
COPY app.rb .
EXPOSE 8080
CMD ["ruby","app.rb"]
