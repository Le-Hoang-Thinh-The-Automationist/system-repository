from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv('/vault/output/.env')

app = Flask(__name__)

DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")
DB_URL  = os.getenv("DB_URL")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")

# Configure database
app.config["SQLALCHEMY_DATABASE_URI"] = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_URL}:{DB_PORT}/{DB_NAME}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)

# Define a simple model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

@app.route("/")
def home():
    return "Database connected successfully!"

if __name__ == "__main__":
    print(f"DB_USER  :{DB_USER}")
    print(f"DB_PASS  :{DB_PASS}")
    print(f"DB_URL   :{DB_URL}")
    print(f"DB_PORT  :{DB_PORT}")
    print(f"DB_NAME  :{DB_NAME}")
    with app.app_context():
        db.create_all()
    app.run(debug=True)
