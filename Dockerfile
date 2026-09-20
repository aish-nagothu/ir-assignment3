#############################################################
# Keep in mind that using this, you will not shown any plots#
# they will be save to /plots                               #
############################################################
FROM --platform=linux/amd64 python:3.10.13-alpine3.18

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt


ENTRYPOINT [ "/bin/sh", "-c", "python main.py > results.txt"]