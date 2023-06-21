FROM python:alpine as base_image

ENV VENV_DIR="/venv"
ENV PATH="${VENV_DIR}/bin:$PATH"

###

FROM base_image as builder_image
RUN python3 -m venv "${VENV_DIR}"
RUN pip install python-kasa
RUN pip uninstall -y pip setuptools
RUN find "${VENV_DIR}/bin" -name '*ctivate*' -type f -maxdepth 1 -exec rm -f {} \;
RUN kasa --version

###

FROM base_image as final_image
COPY --from=builder_image "${VENV_DIR}" "${VENV_DIR}"
ENTRYPOINT ["kasa"]
