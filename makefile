
SHELL=/bin/sh
IMAGENAME=lambci/lambda
IMAGEVERSION=provided.test

build:
	sudo docker build -t $(IMAGENAME):$(IMAGEVERSION) .

run:
	sudo docker run -p 9000:8080 $(IMAGENAME):$(IMAGEVERSION)

shell:
	sudo docker run -it $(IMAGENAME):$(IMAGEVERSION) /bin/bash

