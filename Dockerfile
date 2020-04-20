FROM elixir:1.10.2-slim AS build
WORKDIR /app
ADD . /app
ENV MIX_ENV 'prod'
RUN mix local.rebar --force \
  && mix local.hex --force \
  && mix deps.get \
  && mix release

FROM elixir:1.10.2-slim AS run
WORKDIR /app
COPY --from=build /app/_build/prod/rel/edgybot/ .
ENTRYPOINT ["/app/bin/edgybot"]
CMD ["start"]
