FROM mhart/alpine-node

# Get build-arg
ARG urls_primary="http://misskey.local:50000"
ARG urls_secondary="http://misskey-uc.local:50001"
ARG tls_enable="0"
ARG tls_key=""
ARG tls_cert=""
ARG mongo_host="localhost"
ARG mongo_auth="0"
ARG mongo_user=""
ARG mongo_password=""
ARG redis_host="localhost"
ARG redis_auth="0"
ARG redis_password=""
ARG ports_api="50002"
ARG ports_web_http="50000"
ARG ports_web_https"0"
ARG ports_file_internal="50003"
ARG ports_file_http="50001"
ARG ports_file_https="0"
ARG recaptcha_site="6LdytRwUAAAAAOwDJrHj1XV_XQjBVzHkoRjkQ9Ih"
ARG recaptcha_secret="6LdytRwUAAAAAOB3K9oyE0CXxOFYsUnFUQVpTppY"
ARG theme_color="#888888"
ARG file_storage_path="/var/opt/misskey/file"

# Set enviroment
ENV MISSKEY_GEN_URLS_PRIMARY $urls_primary
ENV MISSKEY_GEN_URLS_SECONDARY $urls_secondary
ENV MISSKEY_GEN_TLS_ENABLE $tls_enable
ENV MISSKEY_GEN_TLS_KEY $tls_key
ENV MISSKEY_GEN_TLS_CERT $tls_cert
ENV MISSKEY_GEN_MONGO_HOST $mongo_host
ENV MISSKEY_GEN_MONGO_AUTH $mongo_auth
ENV MISSKEY_GEN_MONGO_USER $mongo_user
ENV MISSKEY_GEN_MONGO_PASSWORD $mongo_password
ENV MISSKEY_GEN_REDIS_HOST $redis_host
ENV MISSKEY_GEN_REDIS_AUTH $redis_auth
ENV MISSKEY_GEN_REDIS_PASSWORD $redis_password
ENV MISSKEY_GEN_PORTS_API $ports_api
ENV MISSKEY_GEN_PORTS_WEB_HTTP $ports_web_http
ENV MISSKEY_GEN_PORTS_WEB_HTTPS $ports_web_https
ENV MISSKEY_GEN_PORTS_FILE_INTERNAL $ports_file_internal
ENV MISSKEY_GEN_PORTS_FILE_HTTP $ports_file_http
ENV MISSKEY_GEN_PORTS_FILE_HTTPS $ports_file_https
ENV MISSKEY_GEN_RECAPTCHA_SITE $recaptcha_site
ENV MISSKEY_GEN_RECAPTCHA_SECRET $recaptcha_secret
ENV MISSKEY_GEN_THEME_COLOR $theme_color
ENV MISSKEY_GEN_FILE_STORAGE_PATH $file_storage_path

# Get depedencies
RUN apk update \
	&& apk add --no-cache \
		alpine-sdk \
		git \
		graphicsmagick \
		openssl \
		python \
	&& npm install -g forever node-gyp

# Make Settings Great Again
RUN mkdir -p /root/.misskey \
	&& git clone https://github.com/misskey-delta/misskey-gen.git /opt/misskey-gen \
	&& cd /opt/misskey-gen \
	&& npm start \
	&& cp /opt/misskey-gen/store/api.json \
		/opt/misskey-gen/store/file.json \
		/opt/misskey-gen/store/web.json \
		/root/.misskey

# Build misskey-api/file/web
RUN mkdir -p /var/opt/misskey/file \
	&& git clone https://github.com/misskey-delta/misskey-api.git /opt/misskey-api \
	&& git clone https://github.com/misskey-delta/misskey-file.git /opt/misskey-file \
	&& git clone https://github.com/misskey-delta/misskey-web.git /opt/misskey-web \
	&& cd /opt/misskey-api \
	&& npm i && npm run build \
	&& cd /opt/misskey-file \
	&& npm i && npm run build \
	&& cd /opt/misskey-web \
	&& npm run deploy

# Publish some ports
EXPOSE $ports_api $ports_file_http $ports_file_https $ports_web_http $ports_web_https

# Start command
CMD cd /opt \
	&& forever start misskey-api \
	&& forever start misskey-file \
	&& forever start misskey-web \
	&& while true; do sleep 1; done;
