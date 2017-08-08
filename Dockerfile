FROM alpine

RUN cd ~ && \
	apk --no-cache add git && \
	git clone https://github.com/misskey-delta/Misskey-Docker.git && \
	sh ~/Misskey-Docker/build.sh

EXPOSE 50000 50001
CMD ["sh","/root/run.sh"]
