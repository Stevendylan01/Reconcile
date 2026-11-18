# Disaster Recovery Portal

This local starter shows a read-only FastAPI and Jinja evidence request queue
with fictional projects. It uses Python 3.13 and a non-root distroless runtime
image. All demo data lives in the application. AWS, a database, sign-in, and
document uploads are outside this starter's scope.

## Run locally with Colima

Colima provides the lightweight Linux container runtime on macOS. The Docker
command-line tools talk to Colima and do not require Docker Desktop.

Install the local tools once:

```sh
brew install colima docker
colima start --cpu 2 --memory 2
```

Then, from the project directory:

```sh
docker build -t reconcile-portal .
docker run --rm --name reconcile-portal -p 127.0.0.1:8000:8000 reconcile-portal
```

Open [the portal](http://127.0.0.1:8000/) or check
[container health](http://127.0.0.1:8000/health). The app is published only
on localhost. Press Ctrl+C to stop and remove the container. Run `colima stop`
when you are finished using containers. The first build downloads public base
images and Python packages.

The project keeps a standard OCI-compatible image and Compose configuration.
Colima is only the local runtime, so the same image can later be built for and
pushed to Amazon ECR for deployment with Amazon ECS.

## Develop with uv

```sh
uv sync --locked
uv run --locked python -m pytest
uv run --locked uvicorn app.main:app --reload
```

Commit `pyproject.toml` and `uv.lock` together when updating dependencies.
The container installs runtime dependencies from the same lockfile.
