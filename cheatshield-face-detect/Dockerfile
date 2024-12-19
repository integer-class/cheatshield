FROM python:3.13-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ARG DOTENV_PRIVATE_KEY_PYTHON
ENV DOTENV_PRIVATE_KEY=${DOTENV_PRIVATE_KEY_PYTHON}

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends gcc curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# dotenvx and uv
RUN curl -sfS https://dotenvx.sh/install.sh | sh
RUN curl -sfS https://astral.sh/install.sh | sh

ENV PATH="/root/.local/bin:$PATH"

RUN uv venv
RUN . .venv/bin/activate

COPY pyproject.toml .
RUN uv sync

COPY . .
COPY .env .

EXPOSE 8000

# Set the command to run the application
CMD ["dotenvx", "run", "--", '"uv", "run", "--", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
