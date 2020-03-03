FROM elixir:1.9.4
MAINTAINER Nicolas Bettenburg <nicbet@gmail.com>

RUN mix local.hex --force \
 && mix archive.install --force hex phx_new 1.4.11 \
 && apt-get update \
 && curl -sL https://deb.nodesource.com/setup_10.x | bash \
 && apt-get install -y apt-utils \
 && apt-get install -y nodejs \
 && apt-get install -y build-essential \
 && apt-get install -y inotify-tools \
 && mix local.rebar --force

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
RUN cd $APP_HOME
RUN ls
# RUN mix deps.get
# RUN mix phx.server
# WORKDIR $APP_HOME

EXPOSE 4000

# CMD ["cd /app", "deps.get", "mix", "phx.server"]

# # Compile elixir files for production
# ENV MIX_ENV prod
# # This prevents us from installing devDependencies
# ENV NODE_ENV production

# # We add manifests first, to cache deps on successive rebuilds
# RUN mix deps.get


# # Add the rest of your app, and compile for production
# RUN mix compile
