FROM ghcr.io/gleam-lang/gleam:v1.2.1-erlang-alpine AS builder
WORKDIR /
COPY . .
RUN gleam deps download
RUN gleam export erlang-shipment

FROM docker.io/erlang:26.2.3.0-alpine AS release
COPY --from=builder /build/erlang-shipment/ /opt/deploy/
CMD ["/opt/deploy/entrypoint.sh", "run"]
