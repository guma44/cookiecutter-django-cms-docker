FROM python:3.6

ENV BUILD_TIMESTAMP 2017-10-14:17:11:14

ENV PYTHONUNBUFFERED 1

RUN groupadd -r django && useradd -r -g django django

RUN mkdir -p /usr/src/app
RUN mkdir -p /public/media
RUN mkdir -p /public/static
WORKDIR /usr/src/app
RUN mkdir logs

# Run python requirements installation
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy run_server.sh
COPY ./run_server.sh /run_server.sh
RUN sed -i 's/\r//' /run_server.sh
RUN chmod a+x /run_server.sh

# Copy entrypoint.sh
COPY ./entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh
RUN chmod a+x /entrypoint.sh

COPY . /usr/src/app

ENTRYPOINT ["/entrypoint.sh"]
