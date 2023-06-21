FROM python:alpine as base_image

ENV VENV_DIR="/venv"
ENV PATH="${VENV_DIR}/bin:$PATH"

###

FROM base_image as builder_image
WORKDIR /python-kasa
RUN apk add --no-cache git
RUN git clone -n https://github.com/python-kasa/python-kasa.git .
# RUN git checkout e3d76bea7557616a7a9e8f967368ce1d9009db5a
RUN git checkout master
RUN rm -rf .git
RUN apk add --no-cache curl
RUN curl -sSL https://install.python-poetry.org | python3 -
RUN python3 -m venv "${VENV_DIR}"
RUN $HOME/.local/bin/poetry build --format wheel
RUN pip install ./dist/*.whl
RUN pip uninstall -y pip setuptools
RUN find "${VENV_DIR}/bin" -name '*ctivate*' -maxdepth 1 -exec rm -f {} \;
RUN kasa --version

###

FROM base_image as final_image
COPY --from=builder_image "${VENV_DIR}" "${VENV_DIR}"
ENTRYPOINT ["kasa"]
