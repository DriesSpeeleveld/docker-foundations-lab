# syntax=docker/dockerfile:1.7
FROM nginx:1.31.6-alpine

LABEL org.opencontainers.image.title="Docker Foundations Lab" \
      org.opencontainers.image.description="Een kleine non-root Nginx-image om Dockerfundamenten te oefenen" \
      org.opencontainers.image.source="https://github.com/DriesSpeeleveld/docker-foundations-lab"

COPY nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx website/ /usr/share/nginx/html/

USER nginx

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=5 \
  CMD wget -qO- http://127.0.0.1:8080/health || exit 1

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
