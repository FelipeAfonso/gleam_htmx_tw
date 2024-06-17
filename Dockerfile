FROM ghcr.io/gleam-lang/gleam:v1.2.1-erlang-alpine AS builder
RUN apk add inotify-tools
WORKDIR /
COPY . .
RUN gleam deps download
RUN gleam run -m tailwind/install
RUN gleam run -m tailwind/run
RUN gleam export erlang-shipment

FROM docker.io/erlang:27.0.0.0-alpine AS release
COPY --from=builder /build/erlang-shipment/ /opt/deploy/
COPY --from=builder . /opt/deploy
RUN apk add inotify-tools
CMD ["/opt/deploy/entrypoint.sh", "run"]
