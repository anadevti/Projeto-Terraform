##Topico feito para testes de carga utilizando o Locust

from locust import FastHttpUser, task

class WebsiteUser(FastHttpUser):

    @task
    def index(self):
        self.client.get("/")