FROM nginx:1.14.2

RUN useradd --uid 10000 user
USER 10000
