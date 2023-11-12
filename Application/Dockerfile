FROM python:3.11-alpine

WORKDIR /demo-project

COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]