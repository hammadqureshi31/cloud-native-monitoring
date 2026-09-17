import os
import socket
import signal

import psutil
from flask import Flask, render_template
import time
from prometheus_client import Gauge, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)
time.sleep(20)

cpu_usage = Gauge(
    "monitoring_cpu_usage_percent",
    "Current CPU usage percentage",
)

memory_usage = Gauge(
    "monitoring_memory_usage_percent",
    "Current memory usage percentage",
)

app.config["MAX_CONTENT_LENGTH"] = int(
    os.environ.get("MAX_CONTENT_LENGTH", 1024 * 1024)
)

def handle_sigterm(signum, frame):
    print("Received SIGTERM - beginning graceful shutdown...", flush=True)

signal.signal(signal.SIGTERM, handle_sigterm)

@app.route("/")
def index():
    cpu_metric = psutil.cpu_percent()
    mem_metric = psutil.virtual_memory().percent
    message = None

    if cpu_metric > 80 or mem_metric > 80:
        message = "High CPU or Memory Detected, scale up!!!"

    pod_name = socket.gethostname()

    return render_template(
        "index.html",
        cpu_metric=cpu_metric,
        mem_metric=mem_metric,
        message=message,
        pod_name=pod_name,
    )


@app.get("/healthz")
def healthz():
    return {"status": "ok"}

@app.get("/metrics")
def metrics():
    cpu_metric = psutil.cpu_percent()
    mem_metric = psutil.virtual_memory().percent

    cpu_usage.set(cpu_metric)
    memory_usage.set(mem_metric)

    return generate_latest(), 200, {
        "Content-Type": CONTENT_TYPE_LATEST,
    }


if __name__ == "__main__":
    app.run(
        debug=os.environ.get("FLASK_DEBUG", "false").lower() == "true",
        host="0.0.0.0",
        port=int(os.environ.get("PORT", "5000")),
    )

