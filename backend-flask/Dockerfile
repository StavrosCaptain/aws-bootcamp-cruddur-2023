FROM 439314924498.dkr.ecr.eu-central-1.amazonaws.com/cruddur-python:3.10-slim-buster

# Inside Container
WORKDIR /backend-flask

# Outside Container -> Inside Container
# This contains the libraries want to install to run the app
COPY requirements.txt requirements.txt

# Inside Container
# Install the python libraries used for the app
RUN pip3 install -r requirements.txt

# Outside Container -> Inside Container
# . means everything in current directory
# first period (.) means /backend-flask  (outside container)
# second period (.) means /backend-flask  (inside container)
COPY . .

EXPOSE ${PORT}

ENV PYTHONUNBUFFERED=1

# CMD (Command)
# python3 -m flask run --host=0.0.0.0 --port=4567
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567", "--debug"]