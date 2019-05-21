FROM ruby
WORKDIR '/app'
COPY Gemfile* ./
RUN bundle install
COPY app.rb .
EXPOSE 4567
CMD ["ruby","app.rb"]
