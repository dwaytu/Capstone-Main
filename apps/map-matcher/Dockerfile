FROM debian:bookworm-slim AS extract
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*
ARG OSM_EXTRACT_URL=https://osm.download.movisda.io/admin/PH-11-latest.osm.pbf
RUN curl --fail --silent --show-error --location --connect-timeout 10 --max-time 180 \
      --retry 2 --retry-max-time 240 "$OSM_EXTRACT_URL" -o /tmp/davao.osm.pbf

FROM ghcr.io/project-osrm/osrm-backend:v6.0.0 AS graph
WORKDIR /data
COPY --from=extract /tmp/davao.osm.pbf .
RUN osrm-extract --threads 2 -p /opt/car.lua davao.osm.pbf \
    && osrm-partition --threads 2 davao.osrm \
    && osrm-customize --threads 2 davao.osrm \
    && rm davao.osm.pbf

FROM ghcr.io/project-osrm/osrm-backend:v6.0.0
WORKDIR /data
COPY --from=graph /data/ /data/
ENV DISABLE_ACCESS_LOGGING=1
EXPOSE 5000
ENTRYPOINT ["osrm-routed"]
CMD ["--ip", "::", "--port", "5000", "--algorithm", "mld", "--threads", "2", "--verbosity", "ERROR", "/data/davao.osrm"]
