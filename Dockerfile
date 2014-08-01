FROM ubuntu:14.04
MAINTAINER densuke

# リポジトリを日本語向けに変更します
RUN sed -e 's;http://archive;http://jp.archive;' -e  's;http://us\.archive;http://jp.archive;' -i /etc/apt/sources.list
RUN [ ! -x /usr/bin/wget ] && apt-get update && apt-get install -y wget && touch /.get-wget
RUN wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | apt-key add -
RUN wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | apt-key add -
RUN wget https://www.ubuntulinux.jp/sources.list.d/trusty.list -O /etc/apt/sources.list.d/ubuntu-ja.list

# 日付周りを日本語向けに変更します
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && echo 'Asia/Tokyo' > /etc/timezone && date

# ロケールを基本日本語に設定します
RUN echo 'LC_ALL=ja_JP.UTF-8' > /etc/default/locale && echo 'LANG=ja_JP.UTF-8' >> /etc/default/locale
RUN echo 'ja_JP.UTF-8 UTF-8' > /var/lib/locales/supported.d/ja && locale-gen

# システムを更新します
RUN apt-get update
RUN apt-get dist-upgrade -y

# 後始末をします
RUN [ -f /.get-wget ] && apt-get purge --auto-remove -y wget && rm -f /.get-wget
RUN apt-get clean
