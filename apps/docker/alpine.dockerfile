FROM alpine:3.6
RUN sed -i 's#http://dl-cdn.alpinelinux.org#https://mirrors.ustc.edu.cn#g' /etc/apk/repositories    # 加https防止劫持, 导致包版本不正确

# timezone
RUN apk add --no-cache tzdata
ENV TZ Asia/Shanghai

RUN set -x \
   && apk --update --no-cache add make \
   && apk --update --no-cache --virtual .build-dep add \
       build-base libffi-dev openssl-dev \
   && apk del .build-dep

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h  # for pandas
