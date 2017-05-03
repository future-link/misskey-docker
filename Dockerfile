FROM mhart/alpine-node

RUN cd ~ && \
	apk --no-cache add git && \
	git clone https://github.com/misskey-delta/misskey-docker.git ~ && \
	sh /root/builder.sh

EXPOSE 50000 50001
CMD ["sh","/root/run.sh"]
