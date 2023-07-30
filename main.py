import psycopg2
import datetime

def printEntidade(tuplaEntidade, newLine=True):
    for i in tuplaEntidade:
        print(i, " | ", end="")
    if newLine:
        print()


def pesquisa_pessoa_cpf(conn, cpf):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Pessoa WHERE cpf = %s", (cpf,))
    result = cursor.fetchall()
    cursor.close()
    return result

def pesquisa_pessoa_nome(conn, nomePessoa):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Pessoa WHERE nome LIKE %s", ("%"+nomePessoa+"%",))
    result = cursor.fetchall()
    cursor.close()
    return result

def pesquisa_clube_nome(conn, nomeClube):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Clube WHERE nome LIKE %s", ("%"+nomeClube+"%",))
    result = cursor.fetchall()
    cursor.close()
    return result

def pesquisa_jogadores_de_um_clube(conn, nomeClube):
    cursor = conn.cursor()
    tempo_agora = datetime.datetime.now().strftime("%Y-%m-%d")
    sql = """
        SELECT PE.cpf, PE.nome, PE.datanasc, PE.email, PE.nacionalidade, 
        PE.cep, PE.logradouro, PE.bairro, PE.cidade, PE.estado, JO.numero, 
        JO.multarecisoria, JO.posicao, JE.nomeclube, JE.datainicontrato, 
        JE.tempocontrato, JE.datafimcontrato 
        FROM Pessoa AS PE, Jogador AS JO, Jogaem AS JE
        WHERE PE.cpf = JO.cpf AND JE.cpfJogador = JO.cpf 
        AND %s >= JE.dataIniContrato 
        AND %s < JE.dataFimContrato
        AND JE.nomeClube = %s;
    """
    cursor.execute(sql, (tempo_agora, tempo_agora, nomeClube))
    result = cursor.fetchall()
    cursor.close()
    return result

def pesquisa_tecnicos_de_um_clube(conn, nomeClube):
    cursor = conn.cursor()
    tempo_agora = datetime.datetime.now().strftime("%Y-%m-%d")
    sql = """
        SELECT PE.cpf, PE.nome, PE.datanasc, PE.email, PE.nacionalidade, 
        PE.cep, PE.logradouro, PE.bairro, PE.cidade, PE.estado, 
        TR.codRegTreinador, TE.nomeclube, TE.datainicontrato, 
        TE.tempocontrato, TE.datafimcontrato 
        FROM Pessoa AS PE, Treinador AS TR, Treinaem AS TE
        WHERE PE.cpf = TR.cpf AND TE.cpfTreinador = TR.cpf 
        AND %s >= TE.dataIniContrato 
        AND %s < TE.dataFimContrato
        AND TE.nomeClube = %s;
    """
    cursor.execute(sql, (tempo_agora, tempo_agora, nomeClube))
    result = cursor.fetchall()
    cursor.close()
    return result

def pesquisa_ex_jogadores_de_um_clube(conn, nomeClube):
    cursor = conn.cursor()
    tempo_agora = datetime.datetime.now().strftime("%Y-%m-%d")
    sql = """
        SELECT PE.cpf, PE.nome, PE.datanasc, PE.email, PE.nacionalidade, 
        PE.cep, PE.logradouro, PE.bairro, PE.cidade, PE.estado, JO.numero, 
        JO.multarecisoria, JO.posicao, JE.nomeclube, JE.datainicontrato, 
        JE.tempocontrato, JE.datafimcontrato 
        FROM Pessoa AS PE, Jogador AS JO, Jogaem AS JE
        WHERE PE.cpf = JO.cpf AND JE.cpfJogador = JO.cpf 
        AND %s >= JE.dataFimContrato
        AND JE.nomeClube = %s;
    """
    cursor.execute(sql, (tempo_agora, nomeClube))
    result = cursor.fetchall()
    cursor.close()
    return result

def pesquisa_ex_tecnicos_de_um_clube(conn, nomeClube):
    cursor = conn.cursor()
    tempo_agora = datetime.datetime.now().strftime("%Y-%m-%d")
    sql = """
        SELECT PE.cpf, PE.nome, PE.datanasc, PE.email, PE.nacionalidade, 
        PE.cep, PE.logradouro, PE.bairro, PE.cidade, PE.estado, 
        TR.codRegTreinador, TE.nomeclube, TE.datainicontrato, 
        TE.tempocontrato, TE.datafimcontrato 
        FROM Pessoa AS PE, Treinador AS TR, Treinaem AS TE
        WHERE PE.cpf = TR.cpf AND TE.cpfTreinador = TR.cpf 
        AND %s >= TE.dataFimContrato
        AND TE.nomeClube = %s;
    """
    cursor.execute(sql, (tempo_agora, nomeClube))
    result = cursor.fetchall()
    cursor.close()
    return result

def inserir_jogador_em_um_clube(conn, cpf, nome, dataNasc, email, nacionalidade, cep, logradouro, 
                                bairro, cidade, estado, telefones : list, numero, multaRecisoria, posicao,
                                nomeClube, tempoContrato, dataIniContrato=datetime.datetime.now()):
    cursor = None
    try:
        cursor = conn.cursor()
        sql = """
        INSERT INTO Pessoa (cpf, nome, dataNasc, email, nacionalidade, cep, logradouro, bairro, cidade, estado)
        VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
        """
        cursor.execute(sql, (cpf, nome, dataNasc, email, nacionalidade, cep, logradouro, bairro, cidade, estado))
        if len(telefones) > 0:
            sql = """
            INSERT INTO TelefonePessoa (cpf, telefone)
            VALUES (%s, %s);
            """
            for telefone in telefones:
                cursor.execute(sql, (cpf, telefone))

        sql = """
        INSERT INTO Jogador (cpf, numero, multaRecisoria, posicao)
        VALUES (%s, %s, %s, %s);
        """
        cursor.execute(sql, (cpf, numero, multaRecisoria, posicao))

        sql = """
        INSERT INTO JogaEm(cpfJogador, nomeClube, dataIniContrato, tempoContrato, dataFimContrato)
        VALUES (%s, %s, %s, %s, %s)
        """
        dataFinal = dataIniContrato + datetime.timedelta(days=int(tempoContrato))
        cursor.execute(sql, (cpf, nomeClube, dataIniContrato.strftime("%Y-%m-%d"), tempoContrato, dataFinal.strftime("%Y-%m-%d")))

        conn.commit()
        cursor.close()
        return True
    
    except Exception as e:
        print(e)
        cursor.close()
        return False

def inserir_responsavel_legal(conn, cpfDependente, nomeResponsavel, relacao):
    cursor = None
    try:
        cursor = conn.cursor()
        sql = """
        INSERT INTO ResponsavelLegal (cpfDependente, nome, relacao)
        VALUES(%s, %s, %s);
        """
        cursor.execute(sql, (cpfDependente, nomeResponsavel, relacao))
        conn.commit()
        cursor.close()
        return True
    except:
        cursor.close()
        return False

def terminar_contrato_jogador(conn, cpfJogador):
    cursor = conn.cursor()
    tempo_agora = datetime.datetime.now().strftime("%Y-%m-%d")
    sql = """
        UPDATE JogaEm
        SET dataFimContrato = %s
        WHERE cpfJogador = %s 
        AND dataIniContrato <= %s
        AND dataFimContrato > %s
    """
    cursor.execute(sql, (tempo_agora, cpfJogador, tempo_agora, tempo_agora))
    r_count = cursor.rowcount
    conn.commit()
    cursor.close()
    if r_count>0:
        return True
    return False

funcoes = [pesquisa_pessoa_cpf, pesquisa_pessoa_nome, 
 pesquisa_clube_nome, pesquisa_jogadores_de_um_clube,
 pesquisa_tecnicos_de_um_clube, pesquisa_ex_jogadores_de_um_clube, 
 pesquisa_ex_tecnicos_de_um_clube, inserir_jogador_em_um_clube, 
 terminar_contrato_jogador]

headers = [['cpf', 'nome', 'dataNasc', 'email', 'nacionalidade', 'cep', 'logradouro', 'bairro', 'cidade', 'estado'],
           ['cpf', 'nome', 'dataNasc', 'email', 'nacionalidade', 'cep', 'logradouro', 'bairro', 'cidade', 'estado'],
           ['nome', 'anoFundacao', 'pontos', 'numSociosTorcedores', 'idAgenteFinanceiro'],
           ['cpf', 'nome', 'dataNasc', 'email', 'nacionalidade', 'cep', 'logradouro', 'bairro', 'cidade', 'estado', 'numero', 'multaRecisoria', 'posicao', 'nomeClube', 'dataIniContrato', 'tempoContrato', 'dataFimContrato'],
           ['cpf', 'nome', 'dataNasc', 'email', 'nacionalidade', 'cep', 'logradouro', 'bairro', 'cidade', 'estado', 'codRegTreinador', 'nomeClube', 'dataIniContrato', 'tempoContrato', 'dataFimContrato'],
           ['cpf', 'nome', 'dataNasc', 'email', 'nacionalidade', 'cep', 'logradouro', 'bairro', 'cidade', 'estado', 'numero', 'multaRecisoria', 'posicao', 'nomeClube', 'dataIniContrato', 'tempoContrato', 'dataFimContrato'],
           ['cpf', 'nome', 'dataNasc', 'email', 'nacionalidade', 'cep', 'logradouro', 'bairro', 'cidade', 'estado', 'codRegTreinador', 'nomeClube', 'dataIniContrato', 'tempoContrato', 'dataFimContrato'],
           [],
           []]

# Essa é a porta default para o PostgreSQL. Caso seja alterada, é necessário modificar esta variável.
PORT = 5432

print("[SISTEMA DE BANCO DE DADOS CAMPEONATO BRASILEIRO]")
db_name = input("Informe o nome do banco de dados: ")
db_host = input("Informe o nome do host (deixe vazio para localhost): ")
if db_host == "":
    db_host = "localhost"
db_user = input("Informe o nome do usuário: ")
db_pass = input("Informe a senha: ")

conn = None
try:
    conn = psycopg2.connect(database=db_name,
                            host=db_host,
                            user=db_user,
                            password=db_pass,
                            port=PORT)
except:
    print("[ERRO]: Conexão inválida! Verifique as informações...")
    exit(1)

while True:
    opcao = -1
    print("[SELECIONE UMA OPÇÃO]\n")
    print("0. Pesquisar pessoa por cpf")
    print("1. Pesquisar pessoa por nome")
    print("2. Pesquisar clube por nome")
    print("3. Pesquisar jogadores de um clube")
    print("4. Pesquisar técnico de um clube")
    print("5. Pesquisar ex-jogadores de um clube")
    print("6. Pesquisar ex-técnicos de um clube")
    print("7. Inserir jogador em um clube")
    print("8. Encerrar o contrato de um jogador")
    print("9. Digite 9 para sair\n")
    opcao = input("[SELEÇÃO]: ")
    if opcao.isnumeric() and (0 <= int(opcao) <= 9):
        opcao = int(opcao)
        if opcao == 9: # Saída do programa
            break
        elif opcao==7: # Caso especial: função precisa de muitos parametros
            cpf = input("[INFORME O CPF DO JOGADOR]: ")
            nome = input("[INFORME O NOME DO JOGADOR]: ")
            dataNasc = input("[INFORME A DATA DE NASCIMENTO (AAAA-MM-DD) DO JOGADOR]: ")
            maiorIdade = datetime.datetime.strptime(dataNasc, "%Y-%m-%d") + datetime.timedelta(days=6570) <= datetime.datetime.now()
            if not maiorIdade:
                print("[JOGADOR MENOR DE IDADE]")
                nomeResponsavel = input("[INFORME O NOME DO RESPONSÁVEL]: ")
                relacaoResponsavel = input("[INFORME A RELACAO DO RESPONSÁVEL]: ")
            email = input("[INFORME O EMAIL DO JOGADOR]: ")
            nacionalidade = input("[INFORME A NACIONALIDADE DO JOGADOR]: ")
            cep = input("[INFORME O CEP DO JOGADOR]: ")
            logradouro = input("[INFORME O LOGRADOURO DO JOGADOR]: ")
            bairro = input("[INFORME O BAIRRO DO JOGADOR]: ")
            cidade = input("[INFORME A CIDADE DO JOGADOR]: ")
            estado = input("[INFORME O ESTADO DO JOGADOR]: ")
            print("[INFORME TELEFONES DO JOGADOR. PARA SAIR DEIXE A ENTRADA VAZIA]")
            telefones = []
            while True:
                tel = input("[INFORME O TELEFONE (DDXXXXXXXXX)]: ")
                if tel=="":
                    break
                telefones.append(tel)
            numero = input("[INFORME O NÚMERO DO JOGADOR]: ")
            multaRecisoria = input("[INFORME A MULTA RECISÓRIA DO JOGADOR]: ")
            posicao = input("[INFORME A POSIÇÃO DO JOGADOR]: ")
            nomeClube = input("[INFORME O CLUBE DO JOGADOR]: ")
            tempoContrato = input("[INFORME O TEMPO DE CONTRATO DO JOGADOR (EM DIAS)]: ")

            inserido = inserir_jogador_em_um_clube(conn, cpf, nome, dataNasc, 
                                        email, nacionalidade, cep, 
                                        logradouro, bairro, cidade, 
                                        estado, telefones, numero,
                                         multaRecisoria, posicao, 
                                         nomeClube, tempoContrato)
            
            if inserido:
                if not maiorIdade:
                    if inserir_responsavel_legal(conn, cpf, nomeResponsavel, relacaoResponsavel):
                        print("[INSERÇÃO REALIZADA COM SUCESSO!]")
                    else:
                        print("[INSERÇÃO REALIZADA PARCIALMENTE COM SUCESSO. VERIFIQUE OS DADOS DO RESPONSÁVEL LEGAL!]")
                else:
                    print("[INSERÇÃO REALIZADA COM SUCESSO]")
            else:
                print("[ERRO! VERIFIQUE OS DADOS INFORMADOS!]")

        elif opcao==8: # Caso especial: função que retorna booleano
            cpfJogador = input("[INFORME O CPF DO JOGADOR PARA TERMINAR O CONTRATO]: ")
            if terminar_contrato_jogador(conn, cpfJogador):
                print("[OPERAÇÃO REALIZADA COM SUCESSO!]")
            else:
                print("[ERRO! VERIFIQUE AS INFORMAÇÕES FORNECIDAS!]")
        else:
            f = funcoes[opcao]
            arg = input("[INSIRA O DADO SOLICITADO]: ")
            resultados = f(conn, arg)
            print("O resultado segue o seguinte formato: ", ", ".join(headers[opcao]))
            for resultado in resultados:
                printEntidade(resultado)
    else:
        print("[ENTRADA INVÁLIDA]\n")
    input("Pressione enter para prosseguir...")
        
