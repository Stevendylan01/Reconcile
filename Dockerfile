FROM ghcr.io/astral-sh/uv:0.13.9 AS uv
FROM python:3.13-slim-trixie AS build

COPY --from=uv /uv /usr/local/bin/uv
WORKDIR /app

ENV UV_PYTHON_DOWNLOADS=never \
    PYTHONUNBUFFERED=1

# Match the Python path used by the distroless runtime so the virtual
# environment remains valid when copied into the final image.
RUN ln -s /usr/local/bin/python /usr/bin/python

COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev --python /usr/bin/python

COPY app ./app

FROM gcr.io/distroless/python3-debian13:nonroot

WORKDIR /app
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1

COPY --from=build --chown=nonroot:nonroot /app /app

EXPOSE 8000
HEALTHCHECK --interval=15s --timeout=3s --start-period=5s \
    CMD ["/app/.venv/bin/python", "-c", "from urllib.request import urlopen; urlopen('http://127.0.0.1:8000/health', timeout=2).close()"]
ENTRYPOINT ["/app/.venv/bin/python"]
CMD ["-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
