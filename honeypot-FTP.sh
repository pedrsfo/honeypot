#!/bin/bash

# Autor: Pedro Otávio
# Email: pedr_ofs@hotmail.com
# Atualizado: 15/02/2022

# Este simples script tem por finalidade realizar a verificação de intrusão através do metodo de HoneyPot.
# Caso seja detectado alguma interação com este falso serviço FTP, é então realizado o bloqueio do endereço
# ip no firewall Iptables.

# Instrui o usuário a encerrar o script.
echo -e "Para encerrar o processo utilize o comando: kill $$"

# Cria o arquivo que contém o Banner do serviço falso.
echo -e "Welcome to VsFTPd Server!" > fakeFTP.txt

# Verifica se há o diretório blockdir.
if [ -d blockdir ]
then
	true

# Caso contrário, é criado o diretório.
else
	# Cria o diretório de logs bloqueados.
	mkdir blockdir
fi

# Inicializa a variável de contagem.
arquivo=0

# Torna o script contínuo.
while [ true ];
do
	# Abre a porta 21 | redireciona conteúdo do Banner para a porta 21 | registra os logs.
	nc -vnlp 21 < fakeFTP.txt >> fakeFTP.log 2>> fakeFTP.log ; echo -e "\n$(date)\n----------------------------" >> fakeFTP.log

	# Verifica se há interação com o serviço falso.
	if [ "$(cat fakeFTP.log | grep 'USER')" ] || [ "$(cat fakeFTP.log | grep 'PASS')" ]
	# caso haja
	then

		# Filtra o endereço IP do atacante e o adiciona a uma variável.
		ip=$(tac fakeFTP.log | grep -m 1 "connect" | cut -d " " -f 6 | sed 's/^.//' | sed 's/.$//')

		# Bloqueia o atacante.
		iptables -I INPUT -s $ip -j DROP

		# Renomeia o arquivo de log e o move para o diretório blockdir.
		mv fakeFTP.log blockdir/blockFTP$arquivo.log

		# incremento da variável arquivo.
		let "arquivo++"
	fi
done
