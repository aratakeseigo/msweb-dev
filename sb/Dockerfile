FROM ruby:2.7.2-alpine

RUN apk --update-cache --no-cache add alpine-sdk mysql-client mysql-dev tzdata nodejs shared-mime-info

ENV PROJECT_ROOTDIR /app/

WORKDIR $PROJECT_ROOTDIR

COPY Gemfile Gemfile.lock $PROJECT_ROOTDIR

RUN gem install bundler --version 2.1.4 && bundle install

COPY . $PROJECT_ROOTDIR
RUN mkdir -p tmp/pids

#RUN bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
