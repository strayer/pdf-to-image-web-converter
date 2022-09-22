import base64
import os
import os.path

from flask import Flask, flash, redirect, render_template, request
from wand.image import Image
from wand.resource import limits

# Use 100MB of ram before writing temp data to disk.
limits["memory"] = 1024 * 1024 * 100

app = Flask(__name__)
app.config["MAX_CONTENT_LENGTH"] = 64 * 1024 * 1024

if app.debug:
    app.secret_key = b"debug"
else:
    app.secret_key = os.environ["SECRET_KEY"]


@app.route("/")
def start():
    return render_template("index.html.j2")


@app.route("/upload", methods=["POST"])
def upload():
    if "file" not in request.files:
        flash("Upload fehlgeschlagen.")
        return redirect("/")

    file = (request.files)["file"]

    if file.filename == "":
        flash("Bitte wähle eine Datei zum Hochladen aus.")
        return redirect("/")

    converted_pages = []
    with Image(file=file, resolution=300) as pdf:
        for page_number, page in enumerate(pdf.sequence):
            if len(pdf.sequence) > 1:
                page_name = f"{os.path.splitext(file.filename)[0]}-{page_number+1}.jpg"
            else:
                page_name = os.path.splitext(file.filename)[0] + ".jpg"

            with Image(image=page) as image:
                image.compression_quality = 90
                blob = image.make_blob("JPEG")

                if blob is None:
                    flash(f"Seite {page_number+1} konnte nicht konvertiert werden.")
                    continue

                b64jpeg = base64.b64encode(blob).decode("ascii")
                converted_pages.append(dict(name=page_name, jpeg=b64jpeg))

    return render_template(
        "result.html.j2", filename=file.filename, converted_pages=converted_pages
    )


if __name__ == "__main__":
    from livereload import Server

    server = Server(app.wsgi_app)
    server.watch("templates/*")
    server.watch("**/*.py")
    server.serve()
