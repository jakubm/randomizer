FROM ruby:alpine
RUN apk --no-cache add make gcc libc-dev make libxml2 libxslt-dev g++ ncurses libffi-dev
WORKDIR '/app'
COPY Gemfile* ./
RUN gem install bundler -v 1.17.3 && bundle install
COPY app.rb .
EXPOSE 4567
CMD ["ruby","app.rb"]
