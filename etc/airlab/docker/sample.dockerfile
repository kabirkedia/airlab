FROM ubuntu:jammy

RUN apt-get update && \
    apt-get install -y python3 python3-pip

CMD ["bash"]