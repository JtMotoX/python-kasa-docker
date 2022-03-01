FROM python:3.7-alpine as base_image

###

FROM base_image as builder_image
WORKDIR /python-kasa
RUN apk add --no-cache git
RUN git clone -n https://github.com/python-kasa/python-kasa.git . && \
	git checkout e3d76bea7557616a7a9e8f967368ce1d9009db5a && \
	rm -rf .git
RUN apk add --no-cache curl
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
RUN python3 -m venv /venv
ENV PATH=/venv/bin:$PATH
RUN $HOME/.poetry/bin/poetry build --format wheel
RUN pip install ./dist/*.whl
RUN kasa --version

###

FROM base_image as final_image
COPY --from=builder_image /venv /venv
ENV PATH=/venv/bin:$PATH
ENTRYPOINT ["kasa"]
