FROM ruby:2-slim-bullseye as jekyll

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# used in the jekyll-server image, which is FROM this image
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# install both bundler 1.x and 2.x incase you're running
# old gem files
# https://bundler.io/guides/bundler_2_upgrade.html#faq
RUN gem install bundler -v "~>1.0" && gem install bundler jekyll

EXPOSE 4000

WORKDIR /site

# on every container start, check if Gemfile exists and warn if it's missing
ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000" ]
