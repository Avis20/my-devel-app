FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y -qq --no-install-recommends \
    starman \
    libcatalyst-perl \
    libcatalyst-devel-perl \
    libmoose-perl \
    libcatalyst-plugin-static-simple-perl \
    libcatalyst-plugin-configloader-perl \
    libcatalyst-action-renderview-perl \
    libcatalyst-view-json-perl \
    libjson-xs-perl \
    xotcl-shells expect-dev \
    wget make \
    cron curl htop tzdata \
    && rm -rf /var/lib/apt/lists/*

# uni::perl
RUN wget "https://cpan.metacpan.org/authors/id/M/MO/MONS/uni-perl-0.92.tar.gz" \
    && mkdir -p /usr/src/perl/uni-perl-0.92 \
    && tar -xof uni-perl-0.92.tar.gz -C /usr/src/perl/uni-perl-0.92 --strip-components=1 \
    && rm uni-perl-0.92.tar.gz \
    && cd /usr/src/perl/uni-perl-0.92 \
    && perl Makefile.PL \
    && make \
    && make install

RUN ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Apply empty cron job
RUN touch /etc/cron.d/crontab && chmod 0644 /etc/cron.d/crontab
RUN touch /var/log/cron.log
RUN crontab /etc/cron.d/crontab

COPY ./daemon/crontab /etc/cron.d/crontab

COPY backend /backend
ENTRYPOINT /backend/start_project/cmd.sh

