# honeypot
Simples Script Honeypot

Este simples script tem por finalidade realizar a verificação de intrusão através do método de Honeypot.
Caso seja detectado alguma interação com o falso servido FTP, é então realizado o bloqueio do intruso no firewall Iptables.

Recomendo que a execução deste script seja feita em backgroung, para isso, utilize o comando: ./honeypot.sh&

Para encerrar o processo utilize o comando: kill (PID do processo)
