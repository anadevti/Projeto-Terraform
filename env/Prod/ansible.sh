#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py ## instalando pip
sudo python3 get-pip.py
sudo python3 -m pip install ansible ## instalando ansible
tee -a playbook.yml > /dev/null <EOT

##
##Para a criação do arquivo de playbook usamos o comando tee, esse comando faz com que toda 
##informação digitada vá para o terminal e para o arquivo escolhido. 
##Como não temos um terminal aberto, podemos apagar a saída com o > /dev/null 
##e ao invés de digitarmos podemos usar o <<EOT EOT para entrarmos com o valor. 
##EOT é end of tape, ou fim da fita. Também pode ser utilizado EOF, 
##que é end of file, ou fim do arquivo. Ambos são parte do linux e unix 
##para descrever o fim de um arquivo ou dispositivo
##

- hosts: localhost
  tasks:
    - name: instalando o python3 e virtualenv
      apt:
        pkg:
          - python3
          - virtualenv
        update_cache: yes
      become: yes
      # Para clonar uma API de exemplo dentro da máquina.
      
    - name: Git Clone
      ansible.builtin.git:
        repo: https://github.com/alura-cursos/clientes-leo-api.git
        dest: /home/ubuntu/teste/
        version: master
        force: yes ## para forçar a pegar a versão mais nova do nosso código.

    - name: instalando dependências com pip (Django e Django Rest)
      pip:
        virtualenv: /home/ubuntu/teste/venv
        requirements: /caminho/do/seu/arquivo/requerimentos.txt
        name:
          - Django
          - djangorestframework

    - name: verificando se o projeto já existe 
      stat:
        path: /home/ubuntu/teste/setup/settings.py
      register: projeto
      
    - name: iniciando o Projeto
      shell: '. /home/ubuntu/teste/venv/bin/activate; django-admin startproject setup /home/ubuntu/teste/'
      when: not projeto.stat.exists
      
    - name: Alterando o hosts do settings
      lineinfile:
        path: /home/ubuntu/teste/setup/settings.py
        regexp: 'ALLOWED_HOSTS'
        line: 'ALLOWED_HOSTS = ["*"]'
        backrefs: yes
        
    - name: configurando banco de dados
      shell: '. /home/ubuntu/teste/venv/bin/activate; python /caminho/da/aplicacao/manage.py migrate'
      
    - name: carregando dados iniciais
      shell: '. /home/ubuntu/teste/venv/bin/activate; python /caminho/da/aplicacao/manage.py loaddata clientes.json'
    - name: Iniciando o servidor
      shell: '. /home/ubuntu/teste/venv/bin/activate; nohup python /caminho/da/aplicacao/manage.py runserver 0.0.0.0:8000 &'
      EOT
      ansible-playbook playbook.yml