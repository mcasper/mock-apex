FROM ruby:3.1.2-alpine

RUN apk add --update --no-cache --virtual .build-deps build-base

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN bundle install

ADD web.rb $APP_HOME/

CMD ["bundle", "exec", "ruby", "web.rb"]
