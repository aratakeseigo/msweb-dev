FROM ruby:2.7.2-alpine

RUN apk --update-cache --no-cache add alpine-sdk mysql-client mysql-dev tzdata nodejs shared-mime-info

ENV PROJECT_ROOTDIR /app/

WORKDIR $PROJECT_ROOTDIR

COPY . $PROJECT_ROOTDIR

RUN gem install bundler --version 2.1.4 && bundle config set path 'vendor/bundle' && bundle install

RUN bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
