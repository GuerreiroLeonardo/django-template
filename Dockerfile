FROM nikolaik/python-nodejs:python3.7-nodejs10

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    postgresql-client python3-pip binutils libproj-dev gdal-bin \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="./node_modules/.bin:${PATH}"

VOLUME ["/app"]
WORKDIR /app

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

COPY pyproject.toml /app/

RUN poetry install

EXPOSE 8000

COPY entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/entrypoint.sh /

ENTRYPOINT ["entrypoint.sh"]
