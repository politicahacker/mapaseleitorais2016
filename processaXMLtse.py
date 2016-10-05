from lxml.etree import parse
import csv

arquivo = open('/home/markun/devel/eleicoes2016/raw/eleicao2016/resultado/resultado2016.xml','r')

soup = parse(arquivo)

resultado = csv.DictWriter(open('/home/markun/devel/eleicoes2016/raw/eleicao2016/resultado/resultado2016.csv', 'w'), fieldnames=['numero','votos','zona'])
resultado.writeheader()
for zona in soup.xpath('//Abrangencia[@tipoAbrangencia="ZONA"]'):
	z = zona.get('codigoAbrangencia')
	for c in zona.xpath('./VotoCandidato'):
		candidato = {
			'numero' : c.get('numeroCandidato'),
			'votos' : c.get('totalVotos'),
			'zona' : z
		}
		resultado.writerow(candidato)

arquivo.close()