FROM python:3
COPY . /MLmodel
WORKDIR /MLmodel
RUN pip install -r requirements.txt
CMD ["python", "decisiontreeclassifier.py"]
