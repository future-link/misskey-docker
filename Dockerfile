FROM mhart/alpine-node

RUN cd ~ && \
	apk --no-cache add git && \
	git clone https://github.com/atnanasi/misskey-docker.git . && \
	sh /root/setup.sh

EXPOSE 50000 50001
CMD ["sh","/root/runner.sh"]
