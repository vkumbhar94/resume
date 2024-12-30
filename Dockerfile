FROM pandoc/latex:latest-ubuntu
ENV PATH="/usr/local/bin:${PATH}"
RUN apt-get update && apt-get install -y make wkhtmltopdf
WORKDIR /code
ENTRYPOINT ["make"]
